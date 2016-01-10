#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWebEngine>
#include <QFileSystemModel>

#include "ScriptsModel.h"
#include "ScriptsModelFilter.h"

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
    app.setOrganizationName("Some Company");
    app.setOrganizationDomain("somecompany.com");
    app.setApplicationName("Amazing Application");

    QtWebEngine::initialize();
    ScriptsModel scriptsModel;
    ScriptsModelFilter scriptsModelFilter;
    scriptsModelFilter.setSourceModel(&scriptsModel);
    scriptsModelFilter.sort(0, Qt::AscendingOrder);
    scriptsModelFilter.setDynamicSortFilter(true);

    QQmlApplicationEngine engine;
    engine.addImportPath("qrc:/qml");

    engine.rootContext()->setContextProperty("scriptsModel",  QVariant::fromValue(&scriptsModelFilter));

    engine.load(QUrl(QStringLiteral("qrc:/qml/Stubs.qml")));
    setChild(engine, "rootMenu");
    setChild(engine, "Account");
    setChild(engine, "Desktop");
    setChild(engine, "ScriptDiscoveryService");
    setChild(engine, "MenuHelper");

    //engine.load(QUrl(QStringLiteral("qrc:/qml/gallery/main.qml")));
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    return app.exec();
}
