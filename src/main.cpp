#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "apiclient.h"
#include "authmanager.h"
#include "propertymanager.h"
#include "usermanager.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    // Application information
    app.setOrganizationName("SenLocation");
    app.setOrganizationDomain("senlocation.sn");
    app.setApplicationName("SenLocation Mobile");

    // Create API client
    ApiClient apiClient("https://api.senlocation.sn");

    // Create managers
    AuthManager authManager(&apiClient);
    PropertyManager propertyManager(&apiClient);
    UserManager userManager(&apiClient);

    // Setup QML engine
    QQmlApplicationEngine engine;

    // Expose C++ objects to QML
    engine.rootContext()->setContextProperty("authManager", &authManager);
    engine.rootContext()->setContextProperty("propertyManager", &propertyManager);
    engine.rootContext()->setContextProperty("userManager", &userManager);

    // Load main QML file
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
