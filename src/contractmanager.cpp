#include "contractmanager.h"

ContractManager::ContractManager(ApiClient *apiClient, QObject *parent)
    : QObject(parent)
    , m_apiClient(apiClient)
{
}

QVariantList ContractManager::contracts() const
{
    return m_contracts;
}

void ContractManager::fetchContracts()
{
    m_apiClient->get("/api/v1/contracts", [this](QJsonObject response) {
        if (response.contains("contracts")) {
            QJsonArray contractsArray = response["contracts"].toArray();
            m_contracts.clear();
            
            for (const QJsonValue &value : contractsArray) {
                QJsonObject contract = value.toObject();
                QVariantMap contractMap;
                contractMap["id"] = contract["id"].toInt();
                contractMap["propertyId"] = contract["propertyId"].toInt();
                contractMap["tenantId"] = contract["tenantId"].toInt();
                contractMap["ownerId"] = contract["ownerId"].toInt();
                contractMap["startDate"] = contract["startDate"].toString();
                contractMap["endDate"] = contract["endDate"].toString();
                contractMap["monthlyRent"] = contract["monthlyRent"].toDouble();
                contractMap["deposit"] = contract["deposit"].toDouble();
                contractMap["status"] = contract["status"].toString();
                m_contracts.append(contractMap);
            }
            
            emit contractsChanged();
        } else {
            emit operationFailed("Échec du chargement des contrats");
        }
    });
}

void ContractManager::createContract(const QJsonObject &contractData)
{
    m_apiClient->post("/api/v1/contracts", contractData, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            emit contractCreated();
            fetchContracts(); // Refresh the list
        } else {
            QString error = response["message"].toString("Échec de la création du contrat");
            emit operationFailed(error);
        }
    });
}

void ContractManager::initiateContract(const QJsonObject &contractData)
{
    m_apiClient->post("/api/v1/contracts/initiate", contractData, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            emit contractInitiated(response);
        } else {
            QString error = response["message"].toString("Échec de l'initiation du contrat");
            emit operationFailed(error);
        }
    });
}

void ContractManager::validateContractTenant(int contractId, const QString &validationCode)
{
    QJsonObject data;
    data["validationCode"] = validationCode;
    
    QString endpoint = QString("/api/v1/contracts/%1/validate-tenant").arg(contractId);
    m_apiClient->post(endpoint, data, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            emit contractValidated();
            fetchContracts(); // Refresh the list
        } else {
            QString error = response["message"].toString("Échec de la validation du contrat");
            emit operationFailed(error);
        }
    });
}

void ContractManager::getContractValidationStatus(int contractId)
{
    QString endpoint = QString("/api/v1/contracts/%1/validation-status").arg(contractId);
    m_apiClient->get(endpoint, [this](QJsonObject response) {
        if (response.contains("status")) {
            emit validationStatusFetched(response);
        } else {
            emit operationFailed("Échec de la récupération du statut de validation");
        }
    });
}
