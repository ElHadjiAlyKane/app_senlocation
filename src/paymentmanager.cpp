#include "paymentmanager.h"
#include <QSettings>

// Role constants
static const QString ROLE_LANDLORD = "landlord";
static const QString ROLE_TENANT = "tenant";

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

void PaymentManager::fetchReceivedPayments()
{
    // Check for demo mode
    QSettings settings;
    bool isDemoMode = settings.value("demo_mode", false).toBool();
    QString userRole = settings.value("auth/role", "").toString();
    
    if (isDemoMode && userRole == ROLE_LANDLORD) {
        // Load demo received payments for landlord
        m_payments.clear();
        
        // Payment 1: Wave from Fatou Sall for Villa Mermoz
        QVariantMap payment1;
        payment1["id"] = 1;
        payment1["tenantName"] = "Fatou Sall";
        payment1["propertyName"] = "Villa moderne Mermoz";
        payment1["amount"] = 800000.0;
        payment1["tax"] = 40000.0;  // 5% tax
        payment1["totalReceived"] = 840000.0;
        payment1["paymentMethod"] = "Wave";
        payment1["paymentDate"] = "2025-11-05";
        payment1["transactionId"] = "WAVE-TXN-001234";
        payment1["paymentType"] = "Loyer mensuel";
        payment1["status"] = "Reçu";
        m_payments.append(payment1);
        
        // Payment 2: Orange Money from Moussa Kane for Studio Plateau
        QVariantMap payment2;
        payment2["id"] = 2;
        payment2["tenantName"] = "Moussa Kane";
        payment2["propertyName"] = "Studio Plateau";
        payment2["amount"] = 200000.0;
        payment2["tax"] = 10000.0;  // 5% tax
        payment2["totalReceived"] = 210000.0;
        payment2["paymentMethod"] = "Orange Money";
        payment2["paymentDate"] = "2025-11-03";
        payment2["transactionId"] = "OM-TXN-567890";
        payment2["paymentType"] = "Loyer mensuel";
        payment2["status"] = "Reçu";
        m_payments.append(payment2);
        
        // Payment 3: Wave from Fatou Sall for Villa Mermoz (October)
        QVariantMap payment3;
        payment3["id"] = 3;
        payment3["tenantName"] = "Fatou Sall";
        payment3["propertyName"] = "Villa moderne Mermoz";
        payment3["amount"] = 800000.0;
        payment3["tax"] = 40000.0;  // 5% tax
        payment3["totalReceived"] = 840000.0;
        payment3["paymentMethod"] = "Wave";
        payment3["paymentDate"] = "2025-10-05";
        payment3["transactionId"] = "WAVE-TXN-001123";
        payment3["paymentType"] = "Loyer mensuel";
        payment3["status"] = "Reçu";
        m_payments.append(payment3);
        
        // Payment 4: Wave from Moussa Kane for Studio Plateau (October)
        QVariantMap payment4;
        payment4["id"] = 4;
        payment4["tenantName"] = "Moussa Kane";
        payment4["propertyName"] = "Studio Plateau";
        payment4["amount"] = 200000.0;
        payment4["tax"] = 10000.0;  // 5% tax
        payment4["totalReceived"] = 210000.0;
        payment4["paymentMethod"] = "Wave";
        payment4["paymentDate"] = "2025-10-03";
        payment4["transactionId"] = "WAVE-TXN-556789";
        payment4["paymentType"] = "Loyer mensuel";
        payment4["status"] = "Reçu";
        m_payments.append(payment4);
        
        // Payment 5: Orange Money from Fatou Sall - Initial deposit
        QVariantMap payment5;
        payment5["id"] = 5;
        payment5["tenantName"] = "Fatou Sall";
        payment5["propertyName"] = "Villa moderne Mermoz";
        payment5["amount"] = 1600000.0;
        payment5["tax"] = 80000.0;  // 5% tax
        payment5["totalReceived"] = 1680000.0;
        payment5["paymentMethod"] = "Orange Money";
        payment5["paymentDate"] = "2025-09-01";
        payment5["transactionId"] = "OM-TXN-445566";
        payment5["paymentType"] = "Caution";
        payment5["status"] = "Reçu";
        m_payments.append(payment5);
        
        emit paymentsChanged();
        return;
    }
    
    // Normal API call for non-demo mode
    // For now, reuse fetchPayments logic
    fetchPayments();
}

void PaymentManager::fetchTenantPayments()
{
    // Check for demo mode
    QSettings settings;
    bool isDemoMode = settings.value("demo_mode", false).toBool();
    QString userRole = settings.value("auth/role", "").toString();
    
    if (isDemoMode && userRole == ROLE_TENANT) {
        // Load demo tenant payment history
        m_payments.clear();
        
        // Current rent info (not a past payment, just info)
        QVariantMap currentRent;
        currentRent["id"] = 0;
        currentRent["propertyName"] = "Appartement 2 pièces Sacré-Cœur";
        currentRent["landlordName"] = "Moussa Ndiaye";
        currentRent["amount"] = 350000.0;
        currentRent["tax"] = 17500.0;  // 5% tax
        currentRent["total"] = 367500.0;
        currentRent["dueDate"] = "2025-11-05";
        currentRent["status"] = "En attente";
        currentRent["paymentType"] = "Loyer du mois";
        m_payments.append(currentRent);
        
        // Payment history
        // Payment 1: October rent
        QVariantMap payment1;
        payment1["id"] = 1;
        payment1["propertyName"] = "Appartement 2 pièces Sacré-Cœur";
        payment1["amount"] = 350000.0;
        payment1["tax"] = 17500.0;  // 5% tax
        payment1["total"] = 367500.0;
        payment1["paymentMethod"] = "Wave";
        payment1["paymentDate"] = "2025-10-05";
        payment1["transactionId"] = "WAVE-TXN-TEN001";
        payment1["paymentType"] = "Loyer Octobre 2025";
        payment1["status"] = "Payé";
        m_payments.append(payment1);
        
        // Payment 2: September rent
        QVariantMap payment2;
        payment2["id"] = 2;
        payment2["propertyName"] = "Appartement 2 pièces Sacré-Cœur";
        payment2["amount"] = 350000.0;
        payment2["tax"] = 17500.0;  // 5% tax
        payment2["total"] = 367500.0;
        payment2["paymentMethod"] = "Orange Money";
        payment2["paymentDate"] = "2025-09-05";
        payment2["transactionId"] = "OM-TXN-TEN002";
        payment2["paymentType"] = "Loyer Septembre 2025";
        payment2["status"] = "Payé";
        m_payments.append(payment2);
        
        // Payment 3: August rent
        QVariantMap payment3;
        payment3["id"] = 3;
        payment3["propertyName"] = "Appartement 2 pièces Sacré-Cœur";
        payment3["amount"] = 350000.0;
        payment3["tax"] = 17500.0;  // 5% tax
        payment3["total"] = 367500.0;
        payment3["paymentMethod"] = "Wave";
        payment3["paymentDate"] = "2025-08-05";
        payment3["transactionId"] = "WAVE-TXN-TEN003";
        payment3["paymentType"] = "Loyer Août 2025";
        payment3["status"] = "Payé";
        m_payments.append(payment3);
        
        // Payment 4: Initial deposit
        QVariantMap payment4;
        payment4["id"] = 4;
        payment4["propertyName"] = "Appartement 2 pièces Sacré-Cœur";
        payment4["amount"] = 700000.0;
        payment4["tax"] = 35000.0;  // 5% tax
        payment4["total"] = 735000.0;
        payment4["paymentMethod"] = "Orange Money";
        payment4["paymentDate"] = "2025-07-15";
        payment4["transactionId"] = "OM-TXN-TEN004";
        payment4["paymentType"] = "Caution initiale";
        payment4["status"] = "Payé";
        m_payments.append(payment4);
        
        emit paymentsChanged();
        return;
    }
    
    // Normal API call for non-demo mode
    // For now, reuse fetchPayments logic
    fetchPayments();
}
