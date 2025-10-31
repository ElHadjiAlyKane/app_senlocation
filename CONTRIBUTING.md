# Contributing to SenLocation Mobile

Merci de votre intérêt pour contribuer à SenLocation Mobile ! Ce guide vous aidera à commencer.

## Code de Conduite

En participant à ce projet, vous acceptez de maintenir un environnement respectueux et inclusif.

## Comment Contribuer

### Signaler des Bugs

Si vous trouvez un bug, créez une issue avec :
- Une description claire du problème
- Les étapes pour reproduire le bug
- Le comportement attendu vs le comportement actuel
- Des captures d'écran si applicable
- Votre environnement (OS, version Qt, etc.)

### Proposer des Fonctionnalités

Pour proposer une nouvelle fonctionnalité :
1. Vérifiez qu'elle n'existe pas déjà
2. Créez une issue décrivant la fonctionnalité
3. Expliquez pourquoi elle serait utile
4. Proposez une implémentation si possible

### Soumettre des Pull Requests

1. **Fork** le projet
2. **Créez** une branche pour votre fonctionnalité
   ```bash
   git checkout -b feature/ma-fonctionnalite
   ```
3. **Committez** vos changements
   ```bash
   git commit -m "Ajout: description de la fonctionnalité"
   ```
4. **Pushez** vers votre fork
   ```bash
   git push origin feature/ma-fonctionnalite
   ```
5. **Ouvrez** une Pull Request

### Style de Code

#### C++
- Suivre les conventions Qt
- Utiliser C++17
- Commentaires en français pour la documentation
- Noms de classes en PascalCase
- Noms de méthodes en camelCase
- Variables membres préfixées par `m_`

Exemple :
```cpp
class UserManager : public QObject
{
    Q_OBJECT
public:
    explicit UserManager(QObject *parent = nullptr);
    void fetchProfile();
    
private:
    ApiClient *m_apiClient;
    QString m_userName;
};
```

#### QML
- Indentation de 4 espaces
- Propriétés en camelCase
- IDs explicites
- Commentaires pour la logique complexe

Exemple :
```qml
Rectangle {
    id: customButton
    width: 200
    height: 50
    radius: 25
    color: "#4CAF50"
    
    Text {
        anchors.centerIn: parent
        text: "Cliquer ici"
        color: "white"
    }
}
```

### Structure des Commits

Format recommandé :
```
Type: Description courte (max 50 caractères)

Description détaillée si nécessaire (max 72 caractères par ligne)

Fixes #123
```

Types de commits :
- `Ajout:` - Nouvelle fonctionnalité
- `Fix:` - Correction de bug
- `Refactor:` - Refactorisation du code
- `Style:` - Changements de style/formatage
- `Docs:` - Documentation
- `Test:` - Ajout/modification de tests
- `Perf:` - Amélioration de performance

### Tests

Avant de soumettre votre PR :
1. Compilez le projet sans erreurs
2. Testez sur au moins une plateforme (Desktop/Mobile)
3. Vérifiez que l'UI est responsive
4. Testez les cas limites

### Documentation

- Documentez les nouvelles fonctionnalités
- Mettez à jour le README si nécessaire
- Ajoutez des commentaires pour le code complexe
- Incluez des captures d'écran pour les changements UI

## Questions ?

Si vous avez des questions, n'hésitez pas à :
- Ouvrir une issue
- Contacter l'équipe de développement

Merci pour vos contributions ! 🎉
