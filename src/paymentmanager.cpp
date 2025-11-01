#include "paymentmanager.h"

PaymentManager::PaymentManager(ApiClient *apiClient, QObject *parent)
    : QObject(parent)
    , m_apiClient(apiClient)
{
}

QVariantList PaymentManager::payments() const
{
    return m_payments;
}

void PaymentManager::fetchPayments()
{
    m_apiClient->get("/api/v1/payments", [this](QJsonObject response) {
        if (response.contains("payments")) {
            QJsonArray paymentsArray = response["payments"].toArray();
            m_payments.clear();
            
            for (const QJsonValue &value : paymentsArray) {
                QJsonObject payment = value.toObject();
                QVariantMap paymentMap;
                paymentMap["id"] = payment["id"].toInt();
                paymentMap["contractId"] = payment["contractId"].toInt();
                paymentMap["amount"] = payment["amount"].toDouble();
                paymentMap["paymentDate"] = payment["paymentDate"].toString();
                paymentMap["paymentMethod"] = payment["paymentMethod"].toString();
                paymentMap["status"] = payment["status"].toString();
                paymentMap["reference"] = payment["reference"].toString();
                m_payments.append(paymentMap);
            }
            
            emit paymentsChanged();
        } else {
            emit operationFailed("Échec du chargement des paiements");
        }
    });
}

void PaymentManager::createPayment(const QJsonObject &paymentData)
{
    m_apiClient->post("/api/v1/payments", paymentData, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            QJsonObject payment = response.contains("payment") ? response["payment"].toObject() : response;
            emit paymentCreated(payment);
            fetchPayments(); // Refresh the list
        } else {
            QString error = response["message"].toString("Échec de la création du paiement");
            emit operationFailed(error);
        }
    });
}

void PaymentManager::getPaymentStatus(int paymentId)
{
    QString endpoint = QString("/api/v1/payments/%1/status").arg(paymentId);
    m_apiClient->get(endpoint, [this](QJsonObject response) {
        if (response.contains("status")) {
            emit paymentStatusFetched(response);
        } else {
            emit operationFailed("Échec de la récupération du statut du paiement");
        }
    });
}
