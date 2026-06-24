#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQml>
#include <QUrl>

#include "appbackend.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    AppBackend appBackend;

    // Resolve App.* QML modules (Components, Screens, Controllers) shipped in
    // the resource tree, so QML can `import App.Components` instead of "../".
    engine.addImportPath(QStringLiteral("qrc:/qml"));

    // Register the design-system singletons. The .qml files declare `pragma
    // Singleton`; these calls supply the module URI/name (so no qmldir entry is
    // needed) — a single source of truth reachable from any QML file via
    // `import App.Theme` / `import App.Icons`.
    qmlRegisterSingletonType(
        QUrl(QStringLiteral("qrc:/qml/App/Theme/Theme.qml")),
        "App.Theme", 1, 0, "Theme");
    qmlRegisterSingletonType(
        QUrl(QStringLiteral("qrc:/qml/App/Icons/Icons.qml")),
        "App.Icons", 1, 0, "Icons");

    engine.rootContext()->setContextProperty(QStringLiteral("appBackend"), &appBackend);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
