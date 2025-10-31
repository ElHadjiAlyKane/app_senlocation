#ifndef USERMANAGER_H
#define USERMANAGER_H

#include <QObject>
#include <QJsonObject>
#include "apiclient.h"

class UserManager : public QObject
{
    Q_OBJECT

public:
    explicit UserManager(ApiClient *apiClient, QObject *parent = nullptr);

    Q_INVOKABLE void fetchProfile();
    Q_INVOKABLE void updateProfile(const QJsonObject &profileData);
    Q_INVOKABLE void createRentalAgreement(const QJsonObject &agreementData);
    Q_INVOKABLE void fetchRentalAgreements();

signals:
    void profileFetched(const QJsonObject &profile);
    void profileUpdated();
    void rentalAgreementCreated();
    void rentalAgreementsFetched(const QJsonObject &agreements);
    void operationFailed(const QString &error);

private:
    ApiClient *m_apiClient;
};

#endif // USERMANAGER_H
