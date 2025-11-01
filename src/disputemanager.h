#ifndef DISPUTEMANAGER_H
#define DISPUTEMANAGER_H

#include <QObject>
#include <QVariantList>
#include <QJsonObject>
#include <QJsonArray>
#include "apiclient.h"

class DisputeManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList disputes READ disputes NOTIFY disputesChanged)

public:
    explicit DisputeManager(ApiClient *apiClient, QObject *parent = nullptr);

    QVariantList disputes() const;

    Q_INVOKABLE void fetchDisputes();
    Q_INVOKABLE void createDispute(const QJsonObject &disputeData);
    Q_INVOKABLE void fetchEligibleForMediation();
    Q_INVOKABLE void getDisputeWithMediation(int disputeId);
    Q_INVOKABLE void requestMediation(int disputeId, const QJsonObject &mediationData);

signals:
    void disputesChanged();
    void disputeCreated(const QJsonObject &dispute);
    void eligibleDisputesFetched(const QJsonArray &disputes);
    void disputeMediationFetched(const QJsonObject &mediation);
    void mediationRequested(const QJsonObject &response);
    void operationFailed(const QString &error);

private:
    ApiClient *m_apiClient;
    QVariantList m_disputes;
};

#endif // DISPUTEMANAGER_H
