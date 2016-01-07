#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWebEngine>

void setChild(QQmlApplicationEngine& engine, const char* name) {
  for (auto obj : engine.rootObjects()) {
    auto child = obj->findChild<QObject*>(QString(name));
    if (child) {
      engine.rootContext()->setContextProperty(name, child);
      return;
    }
  }
  qWarning() << "Could not find object named " << name;
}

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    QtWebEngine::initialize();

    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:/qml");
    engine.load(QUrl(QStringLiteral("qrc:/qml/Stubs.qml")));
    setChild(engine, "rootMenu");
    setChild(engine, "Account");
    setChild(engine, "Desktop");
    setChild(engine, "MenuHelper");
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    return app.exec();
}
