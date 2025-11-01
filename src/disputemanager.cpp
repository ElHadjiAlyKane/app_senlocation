#include "disputemanager.h"

DisputeManager::DisputeManager(ApiClient *apiClient, QObject *parent)
    : QObject(parent)
    , m_apiClient(apiClient)
{
}

QVariantList DisputeManager::disputes() const
{
    return m_disputes;
}

void DisputeManager::fetchDisputes()
{
    m_apiClient->get("/api/v1/disputes", [this](QJsonObject response) {
        if (response.contains("disputes")) {
            QJsonArray disputesArray = response["disputes"].toArray();
            m_disputes.clear();
            
            for (const QJsonValue &value : disputesArray) {
                QJsonObject dispute = value.toObject();
                QVariantMap disputeMap;
                disputeMap["id"] = dispute["id"].toInt();
                disputeMap["contractId"] = dispute["contractId"].toInt();
                disputeMap["initiatorId"] = dispute["initiatorId"].toInt();
                disputeMap["subject"] = dispute["subject"].toString();
                disputeMap["description"] = dispute["description"].toString();
                disputeMap["status"] = dispute["status"].toString();
                disputeMap["createdAt"] = dispute["createdAt"].toString();
                disputeMap["resolvedAt"] = dispute["resolvedAt"].toString();
                m_disputes.append(disputeMap);
            }
            
            emit disputesChanged();
        } else {
            emit operationFailed("Échec du chargement des litiges");
        }
    });
}

void DisputeManager::createDispute(const QJsonObject &disputeData)
{
    m_apiClient->post("/api/v1/disputes", disputeData, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            if (response.contains("dispute")) {
                emit disputeCreated(response["dispute"].toObject());
            } else {
                emit disputeCreated(QJsonObject());
            }
            fetchDisputes(); // Refresh the list
        } else {
            QString error = response["message"].toString("Échec de la création du litige");
            emit operationFailed(error);
        }
    });
}

void DisputeManager::fetchEligibleForMediation()
{
    m_apiClient->get("/api/v1/disputes/eligible-mediation", [this](QJsonObject response) {
        if (response.contains("disputes")) {
            QJsonArray disputes = response["disputes"].toArray();
            emit eligibleDisputesFetched(disputes);
        } else {
            emit operationFailed("Échec de la récupération des litiges éligibles à la médiation");
        }
    });
}

void DisputeManager::getDisputeWithMediation(int disputeId)
{
    QString endpoint = QString("/api/v1/disputes/%1/mediation").arg(disputeId);
    m_apiClient->get(endpoint, [this](QJsonObject response) {
        if (response.contains("mediation") || response.contains("dispute")) {
            emit disputeMediationFetched(response);
        } else {
            emit operationFailed("Échec de la récupération de la médiation du litige");
        }
    });
}

void DisputeManager::requestMediation(int disputeId, const QJsonObject &mediationData)
{
    QString endpoint = QString("/api/v1/disputes/%1/request-mediation").arg(disputeId);
    m_apiClient->post(endpoint, mediationData, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            emit mediationRequested(response);
            fetchDisputes(); // Refresh the list
        } else {
            QString error = response["message"].toString("Échec de la demande de médiation");
            emit operationFailed(error);
        }
    });
}
