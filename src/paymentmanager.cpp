#include "paymentmanager.h"
#include <QSettings>

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
    // Check for demo mode
    QSettings settings;
    bool isDemoMode = settings.value("demo_mode", false).toBool();
    
    if (isDemoMode) {
        // Load demo payments
        m_payments.clear();
        
        // Payment 1
        QVariantMap payment1;
        payment1["id"] = 1;
        payment1["contractId"] = 1;
        payment1["amount"] = 450000.0;
        payment1["paymentDate"] = "2024-01-05";
        payment1["paymentMethod"] = "Wave";
        payment1["status"] = "Payé";
        payment1["reference"] = "PAY-DEMO-001";
        m_payments.append(payment1);
        
        // Payment 2
        QVariantMap payment2;
        payment2["id"] = 2;
        payment2["contractId"] = 1;
        payment2["amount"] = 450000.0;
        payment2["paymentDate"] = "2024-02-05";
        payment2["paymentMethod"] = "Orange Money";
        payment2["status"] = "Payé";
        payment2["reference"] = "PAY-DEMO-002";
        m_payments.append(payment2);
        
        // Payment 3
        QVariantMap payment3;
        payment3["id"] = 3;
        payment3["contractId"] = 2;
        payment3["amount"] = 200000.0;
        payment3["paymentDate"] = "2024-06-05";
        payment3["paymentMethod"] = "Wave";
        payment3["status"] = "Payé";
        payment3["reference"] = "PAY-DEMO-003";
        m_payments.append(payment3);
        
        emit paymentsChanged();
        return;
    }
    
    // Normal API call for non-demo mode
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
    // Check for demo mode
    QSettings settings;
    bool isDemoMode = settings.value("demo_mode", false).toBool();
    
    if (isDemoMode) {
        // Simulate creating payment in demo mode
        emit paymentCreated(QJsonObject());
        fetchPayments(); // Refresh the list (will show demo payments)
        return;
    }
    
    // Normal API call for non-demo mode
    m_apiClient->post("/api/v1/payments", paymentData, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            if (response.contains("payment")) {
                emit paymentCreated(response["payment"].toObject());
            } else {
                emit paymentCreated(QJsonObject());
            }
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
