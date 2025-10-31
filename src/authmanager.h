#ifndef AUTHMANAGER_H
#define AUTHMANAGER_H

#include <QObject>
#include <QString>
#include <QJsonObject>
#include "apiclient.h"

class AuthManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isAuthenticated READ isAuthenticated NOTIFY authenticationChanged)
    Q_PROPERTY(QString userRole READ userRole NOTIFY authenticationChanged)
    Q_PROPERTY(QString userName READ userName NOTIFY authenticationChanged)

public:
    explicit AuthManager(ApiClient *apiClient, QObject *parent = nullptr);

    bool isAuthenticated() const;
    QString userRole() const;
    QString userName() const;

    Q_INVOKABLE void login(const QString &email, const QString &password);
    Q_INVOKABLE void register_(const QString &name, const QString &email, const QString &password, const QString &role);
    Q_INVOKABLE void logout();

signals:
    void authenticationChanged();
    void loginSuccess();
    void loginFailed(const QString &error);
    void registrationSuccess();
    void registrationFailed(const QString &error);

private:
    ApiClient *m_apiClient;
    bool m_isAuthenticated;
    QString m_userRole;
    QString m_userName;
    QString m_userId;
};

#endif // AUTHMANAGER_H
