#ifndef APICLIENT_H
#define APICLIENT_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QString>
#include <QUrl>

class ApiClient : public QObject
{
    Q_OBJECT

public:
    explicit ApiClient(const QString &baseUrl, QObject *parent = nullptr);

    void get(const QString &endpoint, const std::function<void(QJsonObject)> &callback);
    void post(const QString &endpoint, const QJsonObject &data, const std::function<void(QJsonObject)> &callback);
    void put(const QString &endpoint, const QJsonObject &data, const std::function<void(QJsonObject)> &callback);
    void deleteRequest(const QString &endpoint, const std::function<void(QJsonObject)> &callback);

    void setAuthToken(const QString &token);
    QString authToken() const;

signals:
    void requestError(const QString &error);

private:
    void handleReply(QNetworkReply *reply, const std::function<void(QJsonObject)> &callback);

    QNetworkAccessManager *m_networkManager;
    QString m_baseUrl;
    QString m_authToken;
};

#endif // APICLIENT_H
