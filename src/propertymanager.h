#ifndef PROPERTYMANAGER_H
#define PROPERTYMANAGER_H

#include <QObject>
#include <QVariantList>
#include <QJsonObject>
#include <QJsonArray>
#include "apiclient.h"

class PropertyManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList properties READ properties NOTIFY propertiesChanged)

public:
    explicit PropertyManager(ApiClient *apiClient, QObject *parent = nullptr);

    QVariantList properties() const;

    Q_INVOKABLE void fetchProperties();
    Q_INVOKABLE void fetchPropertyById(const QString &propertyId);
    Q_INVOKABLE void addProperty(const QJsonObject &propertyData);
    Q_INVOKABLE void updateProperty(const QString &propertyId, const QJsonObject &propertyData);
    Q_INVOKABLE void deleteProperty(const QString &propertyId);

signals:
    void propertiesChanged();
    void propertyFetched(const QJsonObject &property);
    void propertyAdded();
    void propertyUpdated();
    void propertyDeleted();
    void operationFailed(const QString &error);

private:
    ApiClient *m_apiClient;
    QVariantList m_properties;
};

#endif // PROPERTYMANAGER_H
