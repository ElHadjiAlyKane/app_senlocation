# SenLocation - Application Mobile

Application mobile Qt/QML pour le système SenLocation, permettant aux bailleurs, locataires et juristes d'interagir avec le serveur de location immobilière.

## Fonctionnalités

### Pour tous les utilisateurs
- 🔐 Authentification et inscription
- 👤 Gestion du profil utilisateur
- 📋 Consultation des propriétés disponibles
- 📄 Gestion des contrats de location

### Pour les bailleurs
- ➕ Ajout de nouvelles propriétés
- ✏️ Modification des propriétés existantes
- 📊 Suivi des locations

### Pour les locataires
- 🔍 Recherche de propriétés
- 📅 Demande de visites
- 📝 Signature de contrats

### Pour les juristes
- ⚖️ Création de contrats de location
- 📋 Validation légale des documents

## Architecture

L'application est structurée en plusieurs composants :

### Backend C++
- **ApiClient** : Gestion des requêtes HTTP vers le serveur
- **AuthManager** : Gestion de l'authentification et des sessions
- **PropertyManager** : Gestion des propriétés immobilières
- **UserManager** : Gestion des utilisateurs et des contrats

### Frontend QML
- **Interface fluide et moderne** avec des transitions animées
- **Composants réutilisables** (CustomButton, CustomTextField, PropertyCard)
- **Navigation intuitive** entre les différentes pages
- **Formulaires optimisés** pour mobile

## Technologies utilisées

- **Qt 5.15+** : Framework principal
- **Qt Quick/QML** : Interface utilisateur
- **Qt Network** : Communication API
- **C++17** : Langage de développement

## Structure du projet

```
SenLocation/
├── src/
│   ├── main.cpp              # Point d'entrée de l'application
│   ├── apiclient.h/cpp       # Client API REST
│   ├── authmanager.h/cpp     # Gestion authentification
│   ├── propertymanager.h/cpp # Gestion propriétés
│   └── usermanager.h/cpp     # Gestion utilisateurs
├── qml/
│   ├── main.qml              # Page principale
│   ├── LoginPage.qml         # Page de connexion
│   ├── RegisterPage.qml      # Page d'inscription
│   ├── HomePage.qml          # Page d'accueil
│   ├── PropertyListPage.qml  # Liste des propriétés
│   ├── PropertyDetailPage.qml# Détails d'une propriété
│   ├── AddPropertyPage.qml   # Ajout de propriété
│   ├── RentalAgreementPage.qml # Gestion des contrats
│   ├── ProfilePage.qml       # Profil utilisateur
│   └── components/           # Composants réutilisables
│       ├── CustomButton.qml
│       ├── CustomTextField.qml
│       └── PropertyCard.qml
├── SenLocation.pro           # Fichier projet Qt
└── qml.qrc                   # Fichier de ressources

```

## Configuration de l'API

Par défaut, l'application se connecte à `https://api.senlocation.sn`. 
Pour modifier l'URL de l'API, éditez la ligne suivante dans `src/main.cpp` :

```cpp
ApiClient apiClient("https://api.senlocation.sn");
```

## Compilation

### Prérequis
- Qt 5.15 ou supérieur
- Qt Creator (recommandé)
- Compilateur C++17 compatible

### Compilation avec Qt Creator
1. Ouvrir `SenLocation.pro` dans Qt Creator
2. Configurer le kit de compilation (Android/iOS/Desktop)
3. Cliquer sur "Build" (Ctrl+B)
4. Cliquer sur "Run" (Ctrl+R)

### Compilation en ligne de commande
```bash
qmake SenLocation.pro
make
./SenLocation
```

### Compilation pour Android
```bash
# Configurer les variables d'environnement Android SDK/NDK
qmake SenLocation.pro
make apk
```

### Compilation pour iOS
```bash
qmake SenLocation.pro -spec macx-ios-clang CONFIG+=iphoneos CONFIG+=device
make
```

## API Endpoints utilisés

L'application communique avec les endpoints suivants :

- `POST /api/auth/login` - Connexion
- `POST /api/auth/register` - Inscription
- `GET /api/properties` - Liste des propriétés
- `GET /api/properties/:id` - Détails d'une propriété
- `POST /api/properties` - Créer une propriété
- `PUT /api/properties/:id` - Modifier une propriété
- `DELETE /api/properties/:id` - Supprimer une propriété
- `GET /api/user/profile` - Profil utilisateur
- `PUT /api/user/profile` - Modifier le profil
- `GET /api/rental-agreements` - Liste des contrats
- `POST /api/rental-agreements` - Créer un contrat

## Contribution

1. Fork le projet
2. Créer une branche pour votre fonctionnalité (`git checkout -b feature/AmazingFeature`)
3. Commit vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## Licence

Ce projet est propriétaire de SenLocation.

## Contact

SenLocation - https://senlocation.sn
