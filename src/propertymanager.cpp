#include "propertymanager.h"
#include <QSettings>

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
    // Check for demo mode
    QSettings settings;
    bool isDemoMode = settings.value("demo_mode", false).toBool();
    
    if (isDemoMode) {
        // Load demo properties
        m_properties.clear();
        
        // Property 1: Appartement 3 pièces Almadies
        QVariantMap property1;
        property1["id"] = "demo_prop_001";
        property1["title"] = "Appartement 3 pièces Almadies";
        property1["description"] = "Bel appartement moderne avec vue sur mer, proche de toutes commodités";
        property1["price"] = 450000.0;
        property1["address"] = "Almadies, Dakar";
        property1["type"] = "appartement";
        property1["bedrooms"] = 3;
        property1["bathrooms"] = 2;
        property1["area"] = 85.0;
        property1["available"] = true;
        m_properties.append(property1);
        
        // Property 2: Villa moderne Mermoz
        QVariantMap property2;
        property2["id"] = "demo_prop_002";
        property2["title"] = "Villa moderne Mermoz";
        property2["description"] = "Superbe villa avec jardin et piscine dans un quartier calme";
        property2["price"] = 800000.0;
        property2["address"] = "Mermoz, Dakar";
        property2["type"] = "villa";
        property2["bedrooms"] = 5;
        property2["bathrooms"] = 4;
        property2["area"] = 200.0;
        property2["available"] = true;
        m_properties.append(property2);
        
        // Property 3: Studio Plateau
        QVariantMap property3;
        property3["id"] = "demo_prop_003";
        property3["title"] = "Studio Plateau";
        property3["description"] = "Studio meublé au cœur du Plateau, idéal pour jeune professionnel";
        property3["price"] = 200000.0;
        property3["address"] = "Plateau, Dakar";
        property3["type"] = "studio";
        property3["bedrooms"] = 1;
        property3["bathrooms"] = 1;
        property3["area"] = 35.0;
        property3["available"] = true;
        m_properties.append(property3);
        
        // Property 4: Maison Sicap Liberté
        QVariantMap property4;
        property4["id"] = "demo_prop_004";
        property4["title"] = "Maison Sicap Liberté";
        property4["description"] = "Grande maison familiale avec cour, dans un quartier résidentiel";
        property4["price"] = 550000.0;
        property4["address"] = "Sicap Liberté, Dakar";
        property4["type"] = "maison";
        property4["bedrooms"] = 4;
        property4["bathrooms"] = 3;
        property4["area"] = 150.0;
        property4["available"] = false;
        m_properties.append(property4);
        
        // Property 5: Duplex Point E
        QVariantMap property5;
        property5["id"] = "demo_prop_005";
        property5["title"] = "Duplex Point E";
        property5["description"] = "Magnifique duplex avec terrasse, proche des commerces";
        property5["price"] = 650000.0;
        property5["address"] = "Point E, Dakar";
        property5["type"] = "duplex";
        property5["bedrooms"] = 3;
        property5["bathrooms"] = 2;
        property5["area"] = 120.0;
        property5["available"] = true;
        m_properties.append(property5);
        
        emit propertiesChanged();
        return;
    }
    
    // Normal API call for non-demo mode
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
    // Check for demo mode
    QSettings settings;
    bool isDemoMode = settings.value("demo_mode", false).toBool();
    
    if (isDemoMode) {
        // Simulate adding property in demo mode
        emit propertyAdded();
        fetchProperties(); // Refresh the list (will show demo properties)
        return;
    }
    
    // Normal API call for non-demo mode
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
    // Check for demo mode
    QSettings settings;
    bool isDemoMode = settings.value("demo_mode", false).toBool();
    
    if (isDemoMode) {
        // Simulate updating property in demo mode
        emit propertyUpdated();
        fetchProperties(); // Refresh the list (will show demo properties)
        return;
    }
    
    // Normal API call for non-demo mode
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
    // Check for demo mode
    QSettings settings;
    bool isDemoMode = settings.value("demo_mode", false).toBool();
    
    if (isDemoMode) {
        // Simulate deleting property in demo mode
        emit propertyDeleted();
        fetchProperties(); // Refresh the list (will show demo properties)
        return;
    }
    
    // Normal API call for non-demo mode
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
