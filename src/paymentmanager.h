#ifndef PAYMENTMANAGER_H
#define PAYMENTMANAGER_H

#include <QObject>
#include <QVariantList>
#include <QJsonObject>
#include <QJsonArray>
#include "apiclient.h"

class PaymentManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList payments READ payments NOTIFY paymentsChanged)

public:
    explicit PaymentManager(ApiClient *apiClient, QObject *parent = nullptr);

    QVariantList payments() const;

    Q_INVOKABLE void fetchPayments();
    Q_INVOKABLE void createPayment(const QJsonObject &paymentData);
    Q_INVOKABLE void getPaymentStatus(int paymentId);

signals:
    void paymentsChanged();
    void paymentCreated(const QJsonObject &payment);
    void paymentStatusFetched(const QJsonObject &status);
    void operationFailed(const QString &error);

private:
    ApiClient *m_apiClient;
    QVariantList m_payments;
};

#endif // PAYMENTMANAGER_H
