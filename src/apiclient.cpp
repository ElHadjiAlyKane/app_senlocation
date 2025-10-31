#include "apiclient.h"
#include <QNetworkRequest>
#include <QJsonDocument>

ApiClient::ApiClient(const QString &baseUrl, QObject *parent)
    : QObject(parent)
    , m_networkManager(new QNetworkAccessManager(this))
    , m_baseUrl(baseUrl)
{
}

void ApiClient::get(const QString &endpoint, const std::function<void(QJsonObject)> &callback)
{
    QUrl url(m_baseUrl + endpoint);
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    
    if (!m_authToken.isEmpty()) {
        request.setRawHeader("Authorization", QString("Bearer %1").arg(m_authToken).toUtf8());
    }

    QNetworkReply *reply = m_networkManager->get(request);
    handleReply(reply, callback);
}

void ApiClient::post(const QString &endpoint, const QJsonObject &data, const std::function<void(QJsonObject)> &callback)
{
    QUrl url(m_baseUrl + endpoint);
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    
    if (!m_authToken.isEmpty()) {
        request.setRawHeader("Authorization", QString("Bearer %1").arg(m_authToken).toUtf8());
    }

    QJsonDocument doc(data);
    QNetworkReply *reply = m_networkManager->post(request, doc.toJson());
    handleReply(reply, callback);
}

void ApiClient::put(const QString &endpoint, const QJsonObject &data, const std::function<void(QJsonObject)> &callback)
{
    QUrl url(m_baseUrl + endpoint);
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    
    if (!m_authToken.isEmpty()) {
        request.setRawHeader("Authorization", QString("Bearer %1").arg(m_authToken).toUtf8());
    }

    QJsonDocument doc(data);
    QNetworkReply *reply = m_networkManager->put(request, doc.toJson());
    handleReply(reply, callback);
}

void ApiClient::deleteRequest(const QString &endpoint, const std::function<void(QJsonObject)> &callback)
{
    QUrl url(m_baseUrl + endpoint);
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    
    if (!m_authToken.isEmpty()) {
        request.setRawHeader("Authorization", QString("Bearer %1").arg(m_authToken).toUtf8());
    }

    QNetworkReply *reply = m_networkManager->deleteResource(request);
    handleReply(reply, callback);
}

void ApiClient::setAuthToken(const QString &token)
{
    m_authToken = token;
}

QString ApiClient::authToken() const
{
    return m_authToken;
}

void ApiClient::handleReply(QNetworkReply *reply, const std::function<void(QJsonObject)> &callback)
{
    connect(reply, &QNetworkReply::finished, this, [this, reply, callback]() {
        if (reply->error() == QNetworkReply::NoError) {
            QByteArray response = reply->readAll();
            QJsonDocument doc = QJsonDocument::fromJson(response);
            callback(doc.object());
        } else {
            emit requestError(reply->errorString());
            callback(QJsonObject());
        }
        reply->deleteLater();
    });
}
