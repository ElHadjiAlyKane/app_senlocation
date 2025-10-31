# Architecture de l'Application SenLocation

## Vue d'ensemble

L'application SenLocation suit une architecture moderne Qt/QML avec séparation claire entre la logique métier (C++) et l'interface utilisateur (QML).

## Diagramme d'Architecture

```
┌─────────────────────────────────────────────────────┐
│                   Interface QML                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐          │
│  │  Pages   │  │Components│  │Navigation│          │
│  └──────────┘  └──────────┘  └──────────┘          │
└─────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────┐
│              Managers (C++ Backend)                  │
│  ┌──────────────┐  ┌──────────────┐                │
│  │ AuthManager  │  │PropertyMgr   │                │
│  └──────────────┘  └──────────────┘                │
│  ┌──────────────┐                                   │
│  │ UserManager  │                                   │
│  └──────────────┘                                   │
└─────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────┐
│                  ApiClient (C++)                     │
│  ┌─────────────────────────────────────┐           │
│  │  QNetworkAccessManager              │           │
│  │  - GET, POST, PUT, DELETE           │           │
│  │  - Token Management                 │           │
│  └─────────────────────────────────────┘           │
└─────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────┐
│              API REST SenLocation                    │
│        https://api.senlocation.sn                    │
└─────────────────────────────────────────────────────┘
```

## Composants Principaux

### 1. Interface Utilisateur (QML)

#### Pages
- **main.qml** : Point d'entrée, gère la navigation avec StackView
- **LoginPage.qml** : Authentification
- **RegisterPage.qml** : Inscription avec sélection de rôle
- **HomePage.qml** : Tableau de bord principal
- **PropertyListPage.qml** : Liste des propriétés
- **PropertyDetailPage.qml** : Détails d'une propriété
- **AddPropertyPage.qml** : Formulaire d'ajout de propriété
- **RentalAgreementPage.qml** : Gestion des contrats
- **ProfilePage.qml** : Profil utilisateur

#### Composants Réutilisables
- **CustomButton.qml** : Bouton stylisé avec modes primaire/secondaire
- **CustomTextField.qml** : Champ de texte avec animations
- **PropertyCard.qml** : Carte de propriété pour les listes

### 2. Backend C++

#### ApiClient
Gère toutes les communications HTTP avec le serveur.

**Responsabilités:**
- Requêtes HTTP (GET, POST, PUT, DELETE)
- Gestion du token d'authentification
- Sérialisation/Désérialisation JSON
- Gestion des erreurs réseau

**Méthodes principales:**
```cpp
void get(const QString &endpoint, callback)
void post(const QString &endpoint, const QJsonObject &data, callback)
void put(const QString &endpoint, const QJsonObject &data, callback)
void deleteRequest(const QString &endpoint, callback)
void setAuthToken(const QString &token)
```

#### AuthManager
Gère l'authentification et les sessions utilisateur.

**Responsabilités:**
- Login/Logout
- Inscription
- Gestion des sessions
- Sauvegarde du token

**Propriétés exposées à QML:**
```cpp
Q_PROPERTY(bool isAuthenticated)
Q_PROPERTY(QString userRole)
Q_PROPERTY(QString userName)
```

**Signaux:**
```cpp
void loginSuccess()
void loginFailed(const QString &error)
void registrationSuccess()
void authenticationChanged()
```

#### PropertyManager
Gère les opérations sur les propriétés immobilières.

**Responsabilités:**
- Récupération des propriétés
- Ajout de propriétés (bailleurs)
- Modification de propriétés
- Suppression de propriétés

**Propriétés exposées à QML:**
```cpp
Q_PROPERTY(QVariantList properties)
```

**Signaux:**
```cpp
void propertiesChanged()
void propertyAdded()
void propertyUpdated()
void operationFailed(const QString &error)
```

#### UserManager
Gère les opérations utilisateur et les contrats.

**Responsabilités:**
- Gestion du profil
- Création de contrats de location
- Récupération des contrats

**Signaux:**
```cpp
void profileFetched(const QJsonObject &profile)
void profileUpdated()
void rentalAgreementCreated()
void operationFailed(const QString &error)
```

## Flux de Données

### 1. Authentification
```
User Input (QML) 
  → AuthManager::login()
  → ApiClient::post("/api/auth/login")
  → API Response
  → Token saved
  → authenticationChanged signal
  → QML updates UI
```

### 2. Récupération des Propriétés
```
QML Page Load
  → PropertyManager::fetchProperties()
  → ApiClient::get("/api/properties")
  → API Response
  → Parse JSON
  → Update m_properties
  → propertiesChanged signal
  → QML ListView updates
```

### 3. Ajout de Propriété
```
Form Submit (QML)
  → PropertyManager::addProperty(data)
  → ApiClient::post("/api/properties", data)
  → API Response
  → propertyAdded signal
  → Refresh properties list
  → Navigate back
```

## Gestion de l'État

### Persistance
- **Token** : Sauvegardé via QSettings
- **User Info** : Sauvegardé via QSettings
- **Properties** : Cache en mémoire (QVariantList)

### Navigation
- **StackView** : Gestion de la pile de navigation
- **Components** : Chargés dynamiquement
- **Deep Linking** : Support des paramètres de page

## Sécurité

### Token Management
- Token JWT stocké localement
- Ajouté automatiquement aux requêtes API
- Nettoyé lors de la déconnexion

### Validation
- Validation côté client des formulaires
- Messages d'erreur en français
- Gestion des cas d'erreur API

### Permissions
- Contrôle d'accès basé sur le rôle
- UI adaptée selon le rôle (landlord/tenant/lawyer)
- Vérification serveur pour les opérations sensibles

## Performance

### Optimisations QML
- Lazy loading des pages
- ListView avec délégués optimisés
- Animations fluides avec Behavior

### Optimisations Réseau
- Callbacks asynchrones
- Gestion des timeouts
- Retry logic (à implémenter)

### Gestion Mémoire
- Smart pointers (QObject parent/child)
- Cleanup automatique des objets
- Cache limité en mémoire

## Tests

### Tests Unitaires (à implémenter)
```cpp
// tests/tst_apiclient.cpp
void TestApiClient::testGetRequest() { ... }
void TestApiClient::testPostRequest() { ... }
```

### Tests d'Intégration (à implémenter)
```cpp
// tests/tst_authmanager.cpp
void TestAuthManager::testLogin() { ... }
void TestAuthManager::testLogout() { ... }
```

### Tests UI (à implémenter)
```qml
// tests/tst_loginpage.qml
TestCase {
    name: "LoginPage"
    function test_login() { ... }
}
```

## Extensibilité

### Ajout de Nouvelles Fonctionnalités

1. **Nouvelle Page QML**
   - Créer le fichier QML dans `qml/`
   - Ajouter à `qml.qrc`
   - Ajouter la navigation dans les pages existantes

2. **Nouveau Manager C++**
   - Créer header/source dans `src/`
   - Ajouter à `SenLocation.pro`
   - Exposer à QML via `rootContext()`

3. **Nouveau Endpoint API**
   - Ajouter méthode dans le manager approprié
   - Utiliser ApiClient pour la requête
   - Définir signaux pour les callbacks

## Déploiement

### Desktop
- Binary standalone
- Qt libraries déployées avec

### Android
- APK signé
- Permissions définies dans AndroidManifest.xml
- Store listing préparé

### iOS
- Archive pour App Store
- Certificats et profils configurés
- App Store submission

## Monitoring et Logs

### Logging (à implémenter)
```cpp
qDebug() << "API Request:" << endpoint;
qWarning() << "Network error:" << error;
qCritical() << "Fatal error:" << error;
```

### Analytics (à implémenter)
- Tracking des actions utilisateur
- Métriques de performance
- Rapports d'erreurs

## Maintenance

### Updates
- Version check au démarrage
- Force update si nécessaire
- Migration des données si besoin

### Support
- Logs d'erreur envoyés au serveur
- Feedback utilisateur intégré
- Documentation accessible
