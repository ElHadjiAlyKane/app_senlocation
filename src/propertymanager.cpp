#include "propertymanager.h"

PropertyManager::PropertyManager(ApiClient *apiClient, QObject *parent)
    : QObject(parent)
    , m_apiClient(apiClient)
{
}

QVariantList PropertyManager::properties() const
{
    return m_properties;
}

void PropertyManager::fetchProperties()
{
    m_apiClient->get("/api/properties", [this](QJsonObject response) {
        if (response.contains("properties")) {
            QJsonArray propertiesArray = response["properties"].toArray();
            m_properties.clear();
            
            for (const QJsonValue &value : propertiesArray) {
                QJsonObject property = value.toObject();
                QVariantMap propertyMap;
                propertyMap["id"] = property["id"].toString();
                propertyMap["title"] = property["title"].toString();
                propertyMap["description"] = property["description"].toString();
                propertyMap["price"] = property["price"].toDouble();
                propertyMap["address"] = property["address"].toString();
                propertyMap["type"] = property["type"].toString();
                propertyMap["bedrooms"] = property["bedrooms"].toInt();
                propertyMap["bathrooms"] = property["bathrooms"].toInt();
                propertyMap["area"] = property["area"].toDouble();
                propertyMap["available"] = property["available"].toBool();
                m_properties.append(propertyMap);
            }
            
            emit propertiesChanged();
        } else {
            emit operationFailed("Échec du chargement des propriétés");
        }
    });
}

void PropertyManager::fetchPropertyById(const QString &propertyId)
{
    m_apiClient->get("/api/properties/" + propertyId, [this](QJsonObject response) {
        if (response.contains("property")) {
            QJsonObject property = response["property"].toObject();
            emit propertyFetched(property);
        } else {
            emit operationFailed("Propriété introuvable");
        }
    });
}

void PropertyManager::addProperty(const QJsonObject &propertyData)
{
    m_apiClient->post("/api/properties", propertyData, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            emit propertyAdded();
            fetchProperties(); // Refresh the list
        } else {
            QString error = response["message"].toString("Échec de l'ajout de la propriété");
            emit operationFailed(error);
        }
    });
}

void PropertyManager::updateProperty(const QString &propertyId, const QJsonObject &propertyData)
{
    m_apiClient->put("/api/properties/" + propertyId, propertyData, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            emit propertyUpdated();
            fetchProperties(); // Refresh the list
        } else {
            QString error = response["message"].toString("Échec de la mise à jour");
            emit operationFailed(error);
        }
    });
}

void PropertyManager::deleteProperty(const QString &propertyId)
{
    m_apiClient->deleteRequest("/api/properties/" + propertyId, [this](QJsonObject response) {
        if (response.contains("success") && response["success"].toBool()) {
            emit propertyDeleted();
            fetchProperties(); // Refresh the list
        } else {
            QString error = response["message"].toString("Échec de la suppression");
            emit operationFailed(error);
        }
    });
}
