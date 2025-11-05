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
        // Load demo properties based on user role
        m_properties.clear();
        QString userRole = settings.value("auth/role", "").toString();
        
        if (userRole == "landlord") {
            // Landlord sees their own properties (3 properties)
            
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
            property1["isOwner"] = true;
            m_properties.append(property1);
            
            // Property 2: Villa moderne Mermoz
            QVariantMap property2;
            property2["id"] = "demo_prop_002";
            property2["title"] = "Villa moderne Mermoz";
            property2["description"] = "Superbe villa avec jardin et piscine dans un quartier calme";
            property2["price"] = 800000.0;
            property2["address"] = "Mermoz, Dakar";
            property2["type"] = "villa";
            property2["bedrooms"] = 4;
            property2["bathrooms"] = 3;
            property2["area"] = 200.0;
            property2["available"] = false;
            property2["isOwner"] = true;
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
            property3["isOwner"] = true;
            m_properties.append(property3);
            
        } else if (userRole == "tenant") {
            // Tenant sees market properties (5 available properties)
            
            // Market Property 1: Appartement Sacré-Cœur
            QVariantMap market1;
            market1["id"] = "demo_prop_market_001";
            market1["title"] = "Appartement 2 pièces Sacré-Cœur";
            market1["description"] = "Appartement bien situé, proche des transports et commerces";
            market1["price"] = 350000.0;
            market1["address"] = "Sacré-Cœur 3, Dakar";
            market1["type"] = "appartement";
            market1["bedrooms"] = 2;
            market1["bathrooms"] = 1;
            market1["area"] = 65.0;
            market1["available"] = true;
            market1["landlordName"] = "Moussa Ndiaye";
            m_properties.append(market1);
            
            // Market Property 2: Chambre Ouakam
            QVariantMap market2;
            market2["id"] = "demo_prop_market_002";
            market2["title"] = "Chambre meublée Ouakam";
            market2["description"] = "Chambre individuelle dans quartier calme, proche de la plage";
            market2["price"] = 120000.0;
            market2["address"] = "Ouakam, Dakar";
            market2["type"] = "chambre";
            market2["bedrooms"] = 1;
            market2["bathrooms"] = 1;
            market2["area"] = 20.0;
            market2["available"] = true;
            market2["landlordName"] = "Awa Diouf";
            m_properties.append(market2);
            
            // Market Property 3: Appartement Point E
            QVariantMap market3;
            market3["id"] = "demo_prop_market_003";
            market3["title"] = "Appartement 3 pièces Point E";
            market3["description"] = "Grand appartement lumineux dans résidence moderne";
            market3["price"] = 500000.0;
            market3["address"] = "Point E, Dakar";
            market3["type"] = "appartement";
            market3["bedrooms"] = 3;
            market3["bathrooms"] = 2;
            market3["area"] = 90.0;
            market3["available"] = true;
            market3["landlordName"] = "Amadou Diop";
            m_properties.append(market3);
            
            // Market Property 4: Studio Liberté 6
            QVariantMap market4;
            market4["id"] = "demo_prop_market_004";
            market4["title"] = "Studio Liberté 6";
            market4["description"] = "Studio moderne et fonctionnel, idéal pour étudiant";
            market4["price"] = 180000.0;
            market4["address"] = "Liberté 6, Dakar";
            market4["type"] = "studio";
            market4["bedrooms"] = 1;
            market4["bathrooms"] = 1;
            market4["area"] = 30.0;
            market4["available"] = true;
            market4["landlordName"] = "Ibrahima Fall";
            m_properties.append(market4);
            
            // Market Property 5: Duplex HLM Grand Yoff
            QVariantMap market5;
            market5["id"] = "demo_prop_market_005";
            market5["title"] = "Duplex HLM Grand Yoff";
            market5["description"] = "Duplex spacieux avec terrasse, quartier résidentiel";
            market5["price"] = 650000.0;
            market5["address"] = "HLM Grand Yoff, Dakar";
            market5["type"] = "duplex";
            market5["bedrooms"] = 4;
            market5["bathrooms"] = 3;
            market5["area"] = 150.0;
            market5["available"] = true;
            market5["landlordName"] = "Cheikh Sarr";
            m_properties.append(market5);
        }
        
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
