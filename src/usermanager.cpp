#include "usermanager.h"

UserManager::UserManager(ApiClient *apiClient, QObject *parent)
    : QObject(parent)
    , m_apiClient(apiClient)
{
}

void UserManager::fetchProfile()
{
    m_apiClient->get("/api/user/profile", [this](QJsonObject response) {
        if (response.contains("user")) {
            QJsonObject user = response["user"].toObject();
            emit profileFetched(user);
        } else {
            emit operationFailed("Échec du chargement du profil");
        }
    });
}

void UserManager::updateProfile(const QJsonObject &profileData)
{
    m_apiClient->put("/api/user/profile", profileData, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            emit profileUpdated();
        } else {
            QString error = response["message"].toString("Échec de la mise à jour du profil");
            emit operationFailed(error);
        }
    });
}

void UserManager::createRentalAgreement(const QJsonObject &agreementData)
{
    m_apiClient->post("/api/rental-agreements", agreementData, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            emit rentalAgreementCreated();
        } else {
            QString error = response["message"].toString("Échec de la création du contrat");
            emit operationFailed(error);
        }
    });
}

void UserManager::fetchRentalAgreements()
{
    m_apiClient->get("/api/rental-agreements", [this](QJsonObject response) {
        if (response.contains("agreements")) {
            emit rentalAgreementsFetched(response);
        } else {
            emit operationFailed("Échec du chargement des contrats");
        }
    });
}
