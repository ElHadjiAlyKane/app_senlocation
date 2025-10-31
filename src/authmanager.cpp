#include "authmanager.h"
#include <QSettings>

AuthManager::AuthManager(ApiClient *apiClient, QObject *parent)
    : QObject(parent)
    , m_apiClient(apiClient)
    , m_isAuthenticated(false)
{
    // Check for saved authentication
    QSettings settings;
    QString token = settings.value("auth/token").toString();
    if (!token.isEmpty()) {
        m_apiClient->setAuthToken(token);
        m_isAuthenticated = true;
        m_userRole = settings.value("auth/role").toString();
        m_userName = settings.value("auth/name").toString();
        m_userId = settings.value("auth/id").toString();
        emit authenticationChanged();
    }
}

bool AuthManager::isAuthenticated() const
{
    return m_isAuthenticated;
}

QString AuthManager::userRole() const
{
    return m_userRole;
}

QString AuthManager::userName() const
{
    return m_userName;
}

void AuthManager::login(const QString &email, const QString &password)
{
    QJsonObject data;
    data["email"] = email;
    data["password"] = password;

    m_apiClient->post("/api/auth/login", data, [this](QJsonObject response) {
        if (response.contains("token") && response.contains("user")) {
            QString token = response["token"].toString();
            QJsonObject user = response["user"].toObject();
            
            m_apiClient->setAuthToken(token);
            m_isAuthenticated = true;
            m_userRole = user["role"].toString();
            m_userName = user["name"].toString();
            m_userId = user["id"].toString();

            // Save authentication
            QSettings settings;
            settings.setValue("auth/token", token);
            settings.setValue("auth/role", m_userRole);
            settings.setValue("auth/name", m_userName);
            settings.setValue("auth/id", m_userId);

            emit authenticationChanged();
            emit loginSuccess();
        } else {
            QString error = response["message"].toString("Échec de la connexion");
            emit loginFailed(error);
        }
    });
}

void AuthManager::register_(const QString &name, const QString &email, const QString &password, const QString &role)
{
    QJsonObject data;
    data["name"] = name;
    data["email"] = email;
    data["password"] = password;
    data["role"] = role;

    m_apiClient->post("/api/auth/register", data, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            emit registrationSuccess();
        } else {
            QString error = response["message"].toString("Échec de l'inscription");
            emit registrationFailed(error);
        }
    });
}

void AuthManager::logout()
{
    m_apiClient->setAuthToken("");
    m_isAuthenticated = false;
    m_userRole = "";
    m_userName = "";
    m_userId = "";

    // Clear saved authentication
    QSettings settings;
    settings.remove("auth/token");
    settings.remove("auth/role");
    settings.remove("auth/name");
    settings.remove("auth/id");

    emit authenticationChanged();
}
