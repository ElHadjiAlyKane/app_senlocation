#include "mediationmanager.h"
#include <QSettings>

MediationManager::MediationManager(ApiClient *apiClient, QObject *parent)
    : QObject(parent)
    , m_apiClient(apiClient)
{
}

QVariantList MediationManager::mediations() const
{
    return m_mediations;
}

QVariantList MediationManager::mediators() const
{
    return m_mediators;
}

void MediationManager::registerMediator(const QJsonObject &mediatorData)
{
    m_apiClient->post("/api/v1/mediators", mediatorData, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            emit mediatorRegistered(response["mediator"].toObject());
        } else {
            QString error = response["message"].toString("Échec de l'inscription du médiateur");
            emit operationFailed(error);
        }
    });
}

void MediationManager::fetchMediators()
{
    m_apiClient->get("/api/v1/mediators", [this](QJsonObject response) {
        if (response.contains("mediators")) {
            QJsonArray mediatorsArray = response["mediators"].toArray();
            m_mediators.clear();
            
            for (const QJsonValue &value : mediatorsArray) {
                QJsonObject mediator = value.toObject();
                QVariantMap mediatorMap;
                mediatorMap["id"] = mediator["id"].toInt();
                mediatorMap["name"] = mediator["name"].toString();
                mediatorMap["email"] = mediator["email"].toString();
                mediatorMap["phone"] = mediator["phone"].toString();
                mediatorMap["specialization"] = mediator["specialization"].toString();
                mediatorMap["verified"] = mediator["verified"].toBool();
                mediatorMap["rating"] = mediator["rating"].toDouble();
                m_mediators.append(mediatorMap);
            }
            
            emit mediatorsChanged();
        } else {
            emit operationFailed("Échec du chargement des médiateurs");
        }
    });
}

void MediationManager::fetchMediatorProfile(int mediatorId)
{
    QString endpoint = QString("/api/v1/mediators/%1").arg(mediatorId);
    m_apiClient->get(endpoint, [this](QJsonObject response) {
        if (response.contains("mediator")) {
            emit mediatorProfileFetched(response["mediator"].toObject());
        } else {
            emit operationFailed("Échec du chargement du profil");
        }
    });
}

void MediationManager::fetchMediatorStats(int mediatorId)
{
    QString endpoint = QString("/api/v1/mediators/%1/stats").arg(mediatorId);
    m_apiClient->get(endpoint, [this](QJsonObject response) {
        if (response.contains("stats")) {
            emit mediatorStatsFetched(response["stats"].toObject());
        } else {
            emit operationFailed("Échec du chargement des statistiques");
        }
    });
}

void MediationManager::verifyMediator(int mediatorId, const QJsonObject &verificationData)
{
    QString endpoint = QString("/api/v1/mediators/%1/verify").arg(mediatorId);
    m_apiClient->put(endpoint, verificationData, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            emit mediatorVerified();
        } else {
            QString error = response["message"].toString("Échec de la vérification");
            emit operationFailed(error);
        }
    });
}

void MediationManager::requestMediation(int disputeId, const QJsonObject &mediationData)
{
    QString endpoint = QString("/api/v1/disputes/%1/request-mediation").arg(disputeId);
    m_apiClient->post(endpoint, mediationData, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            emit mediationRequested(response);
        } else {
            QString error = response["message"].toString("Échec de la demande de médiation");
            emit operationFailed(error);
        }
    });
}

void MediationManager::createMediation(const QJsonObject &mediationData)
{
    m_apiClient->post("/api/v1/mediations", mediationData, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            emit mediationCreated(response["mediation"].toObject());
        } else {
            QString error = response["message"].toString("Échec de la création de la médiation");
            emit operationFailed(error);
        }
    });
}

void MediationManager::fetchMediation(int mediationId)
{
    QString endpoint = QString("/api/v1/mediations/%1").arg(mediationId);
    m_apiClient->get(endpoint, [this](QJsonObject response) {
        if (response.contains("mediation")) {
            emit mediationFetched(response["mediation"].toObject());
        } else {
            emit operationFailed("Échec du chargement de la médiation");
        }
    });
}

void MediationManager::acceptMediation(int mediationId)
{
    QString endpoint = QString("/api/v1/mediations/%1/accept").arg(mediationId);
    m_apiClient->put(endpoint, QJsonObject(), [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            emit mediationAccepted();
        } else {
            QString error = response["message"].toString("Échec de l'acceptation de la médiation");
            emit operationFailed(error);
        }
    });
}

void MediationManager::createSession(int mediationId, const QJsonObject &sessionData)
{
    QString endpoint = QString("/api/v1/mediations/%1/sessions").arg(mediationId);
    m_apiClient->post(endpoint, sessionData, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            emit sessionCreated(response["session"].toObject());
        } else {
            QString error = response["message"].toString("Échec de la création de la séance");
            emit operationFailed(error);
        }
    });
}

void MediationManager::updateSession(int mediationId, int sessionId, const QJsonObject &sessionData)
{
    QString endpoint = QString("/api/v1/mediations/%1/sessions/%2").arg(mediationId).arg(sessionId);
    m_apiClient->put(endpoint, sessionData, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            emit sessionUpdated();
        } else {
            QString error = response["message"].toString("Échec de la mise à jour de la séance");
            emit operationFailed(error);
        }
    });
}

void MediationManager::fetchSessions(int mediationId)
{
    QString endpoint = QString("/api/v1/mediations/%1/sessions").arg(mediationId);
    m_apiClient->get(endpoint, [this](QJsonObject response) {
        if (response.contains("sessions")) {
            emit sessionsFetched(response["sessions"].toArray());
        } else {
            emit operationFailed("Échec du chargement des séances");
        }
    });
}

void MediationManager::recordAgreement(int mediationId, const QJsonObject &agreementData)
{
    QString endpoint = QString("/api/v1/mediations/%1/agreement").arg(mediationId);
    m_apiClient->post(endpoint, agreementData, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            emit agreementRecorded(response["agreement"].toObject());
        } else {
            QString error = response["message"].toString("Échec de l'enregistrement de l'accord");
            emit operationFailed(error);
        }
    });
}

void MediationManager::recordFailure(int mediationId, const QJsonObject &failureData)
{
    QString endpoint = QString("/api/v1/mediations/%1/failure").arg(mediationId);
    m_apiClient->post(endpoint, failureData, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            emit failureRecorded();
        } else {
            QString error = response["message"].toString("Échec de l'enregistrement de l'échec");
            emit operationFailed(error);
        }
    });
}

void MediationManager::fetchReport(int mediationId)
{
    QString endpoint = QString("/api/v1/mediations/%1/report").arg(mediationId);
    m_apiClient->get(endpoint, [this](QJsonObject response) {
        if (response.contains("report")) {
            emit reportFetched(response["report"].toObject());
        } else {
            emit operationFailed("Échec du chargement du rapport");
        }
    });
}

void MediationManager::escalateToLegal(int mediationId, const QJsonObject &legalData)
{
    QString endpoint = QString("/api/v1/mediations/%1/legal-action").arg(mediationId);
    m_apiClient->post(endpoint, legalData, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            emit legalActionInitiated();
        } else {
            QString error = response["message"].toString("Échec de l'escalade juridique");
            emit operationFailed(error);
        }
    });
}

void MediationManager::fetchEligibleDisputes()
{
    m_apiClient->get("/api/v1/disputes/eligible-mediation", [this](QJsonObject response) {
        if (response.contains("disputes")) {
            emit eligibleDisputesFetched(response["disputes"].toArray());
        } else {
            emit operationFailed("Échec du chargement des litiges éligibles");
        }
    });
}

void MediationManager::fetchDisputeMediation(int disputeId)
{
    QString endpoint = QString("/api/v1/disputes/%1/mediation").arg(disputeId);
    m_apiClient->get(endpoint, [this](QJsonObject response) {
        if (response.contains("mediation")) {
            emit disputeMediationFetched(response["mediation"].toObject());
        } else {
            emit operationFailed("Échec du chargement de la médiation du litige");
        }
    });
}
