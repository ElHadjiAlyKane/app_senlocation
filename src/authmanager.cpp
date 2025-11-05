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

bool AuthManager::isDemoMode() const
{
    QSettings settings;
    return settings.value("demo_mode", false).toBool();
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
    // Check for demo credentials - Landlord
    if (email == "770000001" && password == "password") {
        // Demo mode authentication
        QString token = "DEMO_TOKEN_OFFLINE";
        
        m_apiClient->setAuthToken(token);
        m_isAuthenticated = true;
        m_userRole = "landlord";
        m_userName = "Amadou Diop (Bailleur)";
        m_userId = "demo_user_001";

        // Save authentication and demo flag
        QSettings settings;
        settings.setValue("auth/token", token);
        settings.setValue("auth/role", m_userRole);
        settings.setValue("auth/name", m_userName);
        settings.setValue("auth/id", m_userId);
        settings.setValue("demo_mode", true);

        emit authenticationChanged();
        emit loginSuccess();
        return;
    }
    
    // Check for demo credentials - Tenant
    if (email == "770000002" && password == "password") {
        // Demo mode authentication
        QString token = "DEMO_TOKEN_OFFLINE_TENANT";
        
        m_apiClient->setAuthToken(token);
        m_isAuthenticated = true;
        m_userRole = "tenant";
        m_userName = "Fatou Sall (Locataire)";
        m_userId = "demo_user_tenant_001";

        // Save authentication and demo flag
        QSettings settings;
        settings.setValue("auth/token", token);
        settings.setValue("auth/role", m_userRole);
        settings.setValue("auth/name", m_userName);
        settings.setValue("auth/id", m_userId);
        settings.setValue("demo_mode", true);

        emit authenticationChanged();
        emit loginSuccess();
        return;
    }
    
    // Normal API authentication for other credentials
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

            // Save authentication (not demo mode)
            QSettings settings;
            settings.setValue("auth/token", token);
            settings.setValue("auth/role", m_userRole);
            settings.setValue("auth/name", m_userName);
            settings.setValue("auth/id", m_userId);
            settings.setValue("demo_mode", false);

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
    settings.remove("demo_mode");

    emit authenticationChanged();
}
