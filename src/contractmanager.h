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
    Q_INVOKABLE void getContractValidationStatus(int contractId);

signals:
    void contractsChanged();
    void contractCreated();
    void contractInitiated(const QJsonObject &response);
    void contractValidated();
    void validationStatusFetched(const QJsonObject &status);
    void operationFailed(const QString &error);

private:
    ApiClient *m_apiClient;
    QVariantList m_contracts;
};

#endif // CONTRACTMANAGER_H
