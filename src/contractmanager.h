#ifndef CONTRACTMANAGER_H
#define CONTRACTMANAGER_H

#include <QObject>
#include <QVariantList>
#include <QJsonObject>
#include <QJsonArray>
#include "apiclient.h"

class ContractManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList contracts READ contracts NOTIFY contractsChanged)

public:
    explicit ContractManager(ApiClient *apiClient, QObject *parent = nullptr);

    QVariantList contracts() const;

    Q_INVOKABLE void fetchContracts();
    Q_INVOKABLE void createContract(const QJsonObject &contractData);
    Q_INVOKABLE void initiateContract(const QJsonObject &contractData);
    Q_INVOKABLE void validateContractTenant(int contractId, const QString &validationCode);
    Q_INVOKABLE void rejectContractTenant(int contractId, const QJsonObject &rejectionData);
    Q_INVOKABLE void getContractValidationStatus(int contractId);
    Q_INVOKABLE void fetchPendingValidationContracts();
    Q_INVOKABLE void confirmInitialPayments(int contractId, const QJsonObject &paymentData);
    Q_INVOKABLE void confirmTenantDeparture(int contractId, const QJsonObject &departureData);
    Q_INVOKABLE void confirmLandlordDeparture(int contractId, const QJsonObject &departureData);
    Q_INVOKABLE void getDepartureStatus(int contractId);

signals:
    void contractsChanged();
    void contractCreated();
    void contractInitiated(const QJsonObject &response);
    void contractValidated();
    void contractRejected();
    void validationStatusFetched(const QJsonObject &status);
    void pendingContractsFetched(const QJsonArray &contracts);
    void initialPaymentsConfirmed();
    void tenantDepartureConfirmed();
    void landlordDepartureConfirmed();
    void departureStatusFetched(const QJsonObject &status);
    void operationFailed(const QString &error);

private:
    ApiClient *m_apiClient;
    QVariantList m_contracts;
};

#endif // CONTRACTMANAGER_H
