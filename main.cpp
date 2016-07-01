#include <assert.h>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWebEngine>
#include <QDebug>
#include <QRegularExpression>
#include <QtTest/QtTest>
#include <unordered_map>

class MemoryImplementationBase {
protected:
    size_t _size{ 0 };
public:
    const size_t& size() const { return _size; }
    virtual ~MemoryImplementationBase() {}
    virtual void reallocate(size_t newSize) = 0;
    virtual void move(size_t size, size_t srcOffset, size_t dstOffset) = 0;
    virtual void copy(size_t size, size_t offset, uint8_t* data) = 0;
    bool overlap(size_t size, size_t offsetA, size_t offsetB) {
        if (offsetA > offsetB) {
            std::swap(offsetA, offsetB);
        }
        return offsetA + size > offsetB;
    }

    bool validRange(size_t size, size_t offset) {
        return size > 0 && size + offset <= _size;
    }
};

class NullMemory : public MemoryImplementationBase {
public:
    void reallocate(size_t newSize) override {
        _size = newSize;
    }

    void move(size_t size, size_t srcOffset, size_t dstOffset) override {
        Q_UNUSED(size);
        Q_UNUSED(srcOffset);
        Q_UNUSED(dstOffset);
    }

    void copy(size_t size, size_t offset, uint8_t* data) override {
        Q_UNUSED(size);
        Q_UNUSED(offset);
        Q_UNUSED(data);
    }
};

class TestMemoryImplementationBase : public QObject {
    Q_OBJECT
    NullMemory m;
private slots:

    void initTestCase() {
        m.reallocate(1024);
    }

    void testValidRange() {

        // Zero size is always invalid
        QVERIFY(!m.validRange(0, 0));

        // Valid ranges mean the offset + the size does not exceed the memory size
        QVERIFY(m.validRange(1, 0));
        QVERIFY(m.validRange(1024, 0));
        QVERIFY(m.validRange(1, 512));
        QVERIFY(m.validRange(512, 512));
        QVERIFY(m.validRange(1, 1023));

        // Invalid ranges mean the offset + the size goes beyond the allocation range
        QVERIFY(!m.validRange(1025, 0));
        QVERIFY(!m.validRange(1, 1024));
        QVERIFY(!m.validRange(513, 512));
        QVERIFY(!m.validRange(1024, 1024));
    }

    void testOverlap() {
        // Zero size is always invalid
        QVERIFY(!m.overlap(1, 0, 1));
        QVERIFY(!m.overlap(1, 1, 0));
        QVERIFY(m.overlap(1, 0, 0));
        QVERIFY(m.overlap(1, 1, 1));
        QVERIFY(!m.overlap(512, 512, 0));
        QVERIFY(!m.overlap(512, 0, 512));
        QVERIFY(m.overlap(512, 0, 0));
        QVERIFY(m.overlap(512, 1, 2));
        QVERIFY(m.overlap(512, 2, 1));
    }
};

class SystemMemory : public MemoryImplementationBase {
    uint8_t* _data{nullptr};

public:
    ~SystemMemory() {
        delete[] _data;
        _data = nullptr;
        _size = 0;
    }

    void reallocate(size_t newSize) override {
        assert(newSize != 0);
        uint8_t* newData = new uint8_t[newSize];
        if (_data) {
            memcpy(newData, _data, _size);
        }
        std::swap(newData, _data);
        std::swap(newSize, _size);
        delete[] newData;
    }

    void move(size_t size, size_t srcOffset, size_t dstOffset) override {
        assert(!overlap(size, srcOffset, dstOffset));
        assert(validRange(size, srcOffset));
        assert(validRange(size, dstOffset));
        memcpy(_data + dstOffset, _data + srcOffset, size);
    }
};



template <typename MemoryOperator>
class SmartMemoryPool {
public:
    using Handle = uint64_t;
    static const size_t INVALID_SIZE = std::numeric_limits<size_t>::max();
    static const size_t INVALID_OFFSET = std::numeric_limits<size_t>::max();
    static const Handle INVALID_HANDLE = std::numeric_limits<uint64_t>::max();

private:
    struct Block {
        size_t offset;
        size_t size;
    };

    struct Allocation {
        Handle handle;
        size_t size;
        void* data;
    };

    using AllocationMap = std::unordered_map<Handle, Allocation>;
    using Vector = std::vector<Block>;
    using HandleMap = std::unordered_map<Handle, Block>;


    MemoryOperator _memoryOperator;
    Vector _freeBlocks;
    HandleMap _usedBlocks;
    AllocationMap _pendingAllocations;
    Handle _nextHandle{ 1 };
    bool _autoCommit{ false };

private:
    void compact() {}

public:
    bool isAutoCommit() const {
        return _autoCommit;
    }

    void setAutoCommit(bool autoCommit) {
        _autoCommit = autoCommit;
        if (_autoCommit) {
            sync();
        }
    }

    Handle allocate(size_t size, void* data = nullptr) {
        Handle handle = _nextHandle++;
        _pendingAllocations[handle] = { handle, size, data };
        if (_autoCommit) {
            sync();
        }
        return handle;
    }


    // Return the current offset of the specified memory handle.
    size_t offset(Handle handle) const {
        assert(_usedBlocks.count(handle) == 1 || _pendingAllocations.count(handle) == 1);
        if (_pendingAllocations.count(handle)) {
            return INVALID_OFFSET;
        }
        return _usedBlocks[handle].offset;
    }

    void free(Handle handle) {
        assert(_usedBlocks.count(handle) == 1 || _pendingAllocations.count(handle) == 1);
        if (_pendingAllocations.count(handle)) {
            _pendingAllocations.erase(handle);
            return;
        }

        Block block = _usedBlocks[handle];
        _usedBlocks.erase(handle);
        if (_freeBlocks.empty()) {
            // If the free block list is empty, we're done, just add the block
            _freeBlocks.push_back(block);
        } else {
            // If the free block list is not empty, there are three possibilities...
            // this block is in at the beginning, middle or end.
            // For the beginning and end we need to check one other block to see if
            // we find a contiguous segment and either extend it, or insert into the
            // vector if we can't
            if (block.offset < _freeBlocks[0].offset) {
                auto& front = _freeBlocks[0];
                // If contiguous, update the first block
                if (block.offset + block.size == front.offset) {
                    front.offset = block.offset;
                    front.size += block.size;
                } else {
                    // Ugh... O(N) insertion into vector
                    _freeBlocks.insert(_freeBlocks.begin(), block);
                }
            } else if (block.offset > _freeBlocks.back().offset) {
                auto& back = _freeBlocks.back();
                if (back.offset + back.size == block.offset) {
                    back.size += block.size;
                } else {
                    _freeBlocks.push_back(block);
                }
            } else {
                // For the middle we need to check two other blocks for continuity.
                // If one or the other is continuous, we extend it.  If both are contiuous,
                // we combine the new block and the two ends into one new block and shrink
                // the array
                Vector::iterator nextItr = std::upper_bound(_freeBlocks.begin(), _freeBlocks.end(), block.offset);
                auto& next = *nextItr;
                auto& prev = *(nextItr - 1);
                bool prevContiguous = prev.offset + prev.size == block.offset;
                bool nextContiguous = block.offset + block.size == next.offset;
                if (!prevContiguous && !nextContiguous) {
                    // Neither blocks contiguous, insert this block
                    _freeBlocks.insert(nextItr, block);
                } else if (prevContiguous && nextContiguous) {
                    // Both blocks contiguous, update prev and shrink the array
                    prev.size += block.size + next.size;
                    _freeBlocks.erase(nextItr);
                } else if (prevContiguous) {
                    // Previous block contiguous, update prev
                    prev.size += block.size;
                } else if (nextContiguous) {
                    // Next block contiguous, update prev
                    next.offset = block.offset;
                    next.size += block.size;
                } else {
                    Q_UNREACHABLE();
                }
            }
        }
    }

    // Commit all the pending allocations
    void sync() {
        if (_pendingAllocations.empty()) {
            return;
        }

        using AllocationVector = std::vector<Allocation>;
        AllocationVector allocations = _pendingAllocations.values();
        std::sort(allocations.begin(), allocations.end(), [&](const Allocation& a, const Allocation& b){
           return a.size < b.size;
        });

        AllocationVector deferredAllocations;
        deferredAllocations.reserve(allocations.size());

        // Brute force approch
        for (const Allocation& allocation : allocations) {
            size_t offset = findFreeBlock(allocation.size);
            if (offset == INVALID_OFFSET) {
                deferredAllocations.push_back(allocation);
                continue;
            }
            _memoryOperator.copy(allocation.size, allocation.offset, allocation.data);
        }


    }
};

using SystemMemoryPool = SmartMemoryPool<SystemMemory>;

QStringList readLines(const QString& file) {
    QStringList stringList;
    QFile textFile(file);
    textFile.open(QIODevice::Text | QIODevice::ReadOnly);
    //... (open the file for reading, etc.)
    QTextStream textStream(&textFile);
    while (true) {
        QString line = textStream.readLine();
        if (line.isNull()) {
            break;
        }
        stringList.append(line);
    }
    return stringList;
}

struct Allocation {
    uint64_t id;
    size_t size;
    time_t begin;
    time_t end;

    bool operator <(const Allocation& o) const {
        return begin < o.begin;
    }

    time_t lifetime() const {
        return end - begin;
    }

    static QVector<Allocation> parseAllocations() {
        QStringList lines = readLines("c:/Users/bdavis/tracker.txt");
        qDebug() << lines.size();
        // [06/30 21:45:12] [DEBUG] GLTracker buffer:  0x225bd0a8850   4096
        const QRegularExpression re("\\[06/30 21:(\\d\\d):(\\d\\d)\] \\[DEBUG\\] GLTracker (~)?buffer:  0x([0-9a-f]+)\\s*(\\d+)?");
        QVector<Allocation> allocations;
        QHash<uint64_t, Allocation> map;
        size_t lineCount{0};
        time_t lastTime;
        for (const auto& line : lines) {
            ++lineCount;
            auto match = re.match(line);
            if (!match.hasMatch()) {
                continue;
            }

            int time = match.captured(1).toInt() * 60;
            time += match.captured(2).toInt();
            lastTime = time + 1;
            bool destructor = !match.captured(3).isEmpty();
            uint64_t id = match.captured(4).toLongLong(0, 16);
            if (!destructor) {
                size_t size = match.captured(5).toLongLong();
                Allocation a { id, size, time, 0 };
                assert(!map.contains(id));
                map[id] = a;
            } else {
                assert(map.contains(id));
                auto a = map[id];
                a.end = time;
                map.remove(id);
                allocations.push_back(a);
            }
        }
        for (auto a : map.values()) {
            assert(a.end == 0);
            a.end = lastTime;
            allocations.push_back(a);
        }
        map.clear();

        qDebug() << map.size();
        qDebug() << allocations.size();
        qStableSort(allocations);
        QSet<uint64_t> seenIds;
        for (auto& a : allocations) {
            while (seenIds.)
        }
        return allocations;
    }

};

int main(int argc, char *argv[]) {
    QCoreApplication app(argc, argv);
    size_t totalSize = 0;
    size_t concurrentAllocation = 0;
    size_t maxConcurrentAllocation = 0;
    const auto allocations = Allocation::parseAllocations();
    {
        std::map<time_t, std::list<size_t>> deallocations;
        for (const auto& a : allocations) {
            if (a.lifetime() <= 1) {
                continue;
            }
            assert(a.end);

            totalSize += a.size;
            concurrentAllocation += a.size;
            deallocations[a.end].push_back(a.size);
            while (deallocations.begin()->first < a.begin) {
                auto sizes = deallocations.begin()->second;
                for (auto size : sizes) {
                    assert(size <= concurrentAllocation);
                    concurrentAllocation -= size;
                }
                deallocations.erase(deallocations.begin()->first);
            }
            maxConcurrentAllocation = std::max(maxConcurrentAllocation, concurrentAllocation);
        }
        qDebug() << "Total size " << totalSize;
        qDebug() << "Max concurrent allocation " << maxConcurrentAllocation;
    }

    {
        SystemMemoryPool pool;
        std::map<time_t, std::list<size_t>> deallocations;
        for (const auto& a : allocations) {
            deallocations[a.end].push_back(a.size);
        }
        time_t now{0};
        for (const auto& a : allocations) {
            if (a.start > now) {
                pool.sync();
            }
            pool.allocate()

        }
    }



//    QQmlApplicationEngine engine;
//    engine.addImportPath("qrc:/qml");
//    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
//    return app.exec();
}

//QTEST_MAIN(TestMemoryImplementationBase)
//#include "main.moc"
