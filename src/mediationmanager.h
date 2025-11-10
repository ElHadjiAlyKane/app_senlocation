#ifndef MEDIATIONMANAGER_H
#define MEDIATIONMANAGER_H

#include <QObject>
#include <QVariantList>
#include <QJsonObject>
#include <QJsonArray>
#include "apiclient.h"

class MediationManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList mediations READ mediations NOTIFY mediationsChanged)
    Q_PROPERTY(QVariantList mediators READ mediators NOTIFY mediatorsChanged)

public:
    explicit MediationManager(ApiClient *apiClient, QObject *parent = nullptr);

    QVariantList mediations() const;
    QVariantList mediators() const;

    // Mediator endpoints
    Q_INVOKABLE void registerMediator(const QJsonObject &mediatorData);
    Q_INVOKABLE void fetchMediators();
    Q_INVOKABLE void fetchMediatorProfile(int mediatorId);
    Q_INVOKABLE void fetchMediatorStats(int mediatorId);
    Q_INVOKABLE void verifyMediator(int mediatorId, const QJsonObject &verificationData);

    // Mediation endpoints
    Q_INVOKABLE void requestMediation(int disputeId, const QJsonObject &mediationData);
    Q_INVOKABLE void createMediation(const QJsonObject &mediationData);
    Q_INVOKABLE void fetchMediation(int mediationId);
    Q_INVOKABLE void acceptMediation(int mediationId);
    
    // Session endpoints
    Q_INVOKABLE void createSession(int mediationId, const QJsonObject &sessionData);
    Q_INVOKABLE void updateSession(int mediationId, int sessionId, const QJsonObject &sessionData);
    Q_INVOKABLE void fetchSessions(int mediationId);
    
    // Mediation conclusion endpoints
    Q_INVOKABLE void recordAgreement(int mediationId, const QJsonObject &agreementData);
    Q_INVOKABLE void recordFailure(int mediationId, const QJsonObject &failureData);
    Q_INVOKABLE void fetchReport(int mediationId);
    Q_INVOKABLE void escalateToLegal(int mediationId, const QJsonObject &legalData);
    
    // Dispute-mediation endpoints
    Q_INVOKABLE void fetchEligibleDisputes();
    Q_INVOKABLE void fetchDisputeMediation(int disputeId);

signals:
    void mediationsChanged();
    void mediatorsChanged();
    void mediatorRegistered(const QJsonObject &mediator);
    void mediatorProfileFetched(const QJsonObject &profile);
    void mediatorStatsFetched(const QJsonObject &stats);
    void mediatorVerified();
    void mediationRequested(const QJsonObject &response);
    void mediationCreated(const QJsonObject &mediation);
    void mediationFetched(const QJsonObject &mediation);
    void mediationAccepted();
    void sessionCreated(const QJsonObject &session);
    void sessionUpdated();
    void sessionsFetched(const QJsonArray &sessions);
    void agreementRecorded(const QJsonObject &agreement);
    void failureRecorded();
    void reportFetched(const QJsonObject &report);
    void legalActionInitiated();
    void eligibleDisputesFetched(const QJsonArray &disputes);
    void disputeMediationFetched(const QJsonObject &mediation);
    void operationFailed(const QString &error);

private:
    ApiClient *m_apiClient;
    QVariantList m_mediations;
    QVariantList m_mediators;
};

#endif // MEDIATIONMANAGER_H
