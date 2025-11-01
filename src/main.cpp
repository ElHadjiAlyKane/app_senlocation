#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include "apiclient.h"
#include "authmanager.h"
#include "propertymanager.h"
#include "usermanager.h"
#include "contractmanager.h"
#include "paymentmanager.h"
#include "disputemanager.h"

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

    // Load configuration from config.json
    QString apiBaseUrl = "http://localhost:8080"; // Default value
    QFile configFile("config.json");
    if (configFile.open(QIODevice::ReadOnly)) {
        QByteArray configData = configFile.readAll();
        QJsonDocument configDoc = QJsonDocument::fromJson(configData);
        if (!configDoc.isNull() && configDoc.isObject()) {
            QJsonObject config = configDoc.object();
            if (config.contains("api") && config["api"].isObject()) {
                QJsonObject apiConfig = config["api"].toObject();
                apiBaseUrl = apiConfig["baseUrl"].toString("http://localhost:8080");
            }
        }
        configFile.close();
    }

    // Create API client
    ApiClient apiClient(apiBaseUrl);

    // Create managers
    AuthManager authManager(&apiClient);
    PropertyManager propertyManager(&apiClient);
    UserManager userManager(&apiClient);
    ContractManager contractManager(&apiClient);
    PaymentManager paymentManager(&apiClient);
    DisputeManager disputeManager(&apiClient);

    // Setup QML engine
    QQmlApplicationEngine engine;

    // Expose C++ objects to QML
    engine.rootContext()->setContextProperty("authManager", &authManager);
    engine.rootContext()->setContextProperty("propertyManager", &propertyManager);
    engine.rootContext()->setContextProperty("userManager", &userManager);
    engine.rootContext()->setContextProperty("contractManager", &contractManager);
    engine.rootContext()->setContextProperty("paymentManager", &paymentManager);
    engine.rootContext()->setContextProperty("disputeManager", &disputeManager);

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
