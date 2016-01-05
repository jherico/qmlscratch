import QtQuick 2.5
import QtQuick.Controls 1.4

FocusScope {
    id: root
    anchors.fill: parent
    property var crossBar: null

    function closeChild() {
        crossBar.restore()
    }

    Keys.onPressed: {
        switch(event.key) {
            case Qt.Key_Escape:
            case Qt.Key_Backspace:
                closeChild();
                event.accepted = true
                break
        }
    }
}
