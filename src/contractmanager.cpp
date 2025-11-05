#include "contractmanager.h"
#include <QSettings>

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
    // Check for demo mode
    QSettings settings;
    bool isDemoMode = settings.value("demo_mode", false).toBool();
    
    if (isDemoMode) {
        // Load demo contracts based on user role
        m_contracts.clear();
        QString userRole = settings.value("auth/role", "").toString();
        
        if (userRole == "landlord") {
            // Landlord sees contracts where they are the owner
            
            // Contract 1: Villa louée à Fatou Sall
            QVariantMap contract1;
            contract1["id"] = 1;
            contract1["propertyId"] = 2;
            contract1["tenantId"] = 101;
            contract1["ownerId"] = 1;
            contract1["startDate"] = "2024-01-01";
            contract1["endDate"] = "2024-12-31";
            contract1["monthlyRent"] = 800000.0;
            contract1["deposit"] = 1600000.0;
            contract1["status"] = "Actif";
            contract1["tenantName"] = "Fatou Sall";
            contract1["propertyTitle"] = "Villa moderne Mermoz";
            m_contracts.append(contract1);
            
        } else if (userRole == "tenant") {
            // Tenant sees contracts where they are the tenant
            
            // Contract 1: Fatou Sall loue un appartement à Sacré-Cœur
            QVariantMap contract1;
            contract1["id"] = 1;
            contract1["propertyId"] = 1;
            contract1["tenantId"] = 101;
            contract1["ownerId"] = 10;
            contract1["startDate"] = "2024-06-01";
            contract1["endDate"] = "2025-05-31";
            contract1["monthlyRent"] = 350000.0;
            contract1["deposit"] = 700000.0;
            contract1["status"] = "Actif";
            contract1["landlordName"] = "Moussa Ndiaye";
            contract1["propertyTitle"] = "Appartement 2 pièces Sacré-Cœur";
            m_contracts.append(contract1);
        }
        
        emit contractsChanged();
        return;
    }
    
    // Normal API call for non-demo mode
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
    // Check for demo mode
    QSettings settings;
    bool isDemoMode = settings.value("demo_mode", false).toBool();
    
    if (isDemoMode) {
        // Simulate creating contract in demo mode
        emit contractCreated();
        fetchContracts(); // Refresh the list (will show demo contracts)
        return;
    }
    
    // Normal API call for non-demo mode
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
