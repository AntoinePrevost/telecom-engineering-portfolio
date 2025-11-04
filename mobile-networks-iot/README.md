# GIN206 - GeoLocator

## Description
GeoLocator est une application web de géolocalisation développée dans le cadre du cours GIN206. Cette application permet de localiser l'utilisateur, de créer des itinéraires, de gérer des trajets et de personnaliser les préférences utilisateur.

## Structure du Projet

```
GIN206/
├── src/
│   ├── App.vue             # Composant principal de l'application
│   ├── components/         # Composants Vue réutilisables
│   ├── views/             # Pages de l'application
│   └── router/            # Configuration des routes
├── public/                # Fichiers statiques
├── docs/                  # Documentation du projet
└── package.json           # Dépendances et scripts
```

## Prérequis
- Node.js (version 16 ou supérieure)
- npm ou yarn
- Navigateur web moderne avec support de la géolocalisation

## Installation

1. Cloner le repository :
```bash
git clone [URL_DU_REPO]
cd GIN206
```

2. Installer les dépendances :
```bash
npm install
```

## Utilisation

### Développement
```bash
npm run dev
```

### Build de production
```bash
npm run build
```

### Tests
```bash
npm test
```

## Technologies Utilisées
- **Frontend** : Vue.js 3 (Composition API), HTML5, CSS3
- **Cartographie** : Leaflet.js, OpenStreetMap
- **Routing** : Vue Router
- **Géolocalisation** : API Geolocation HTML5
- **Styling** : CSS personnalisé avec thème sombre/clair
- **Outils de développement** : Vite, npm

## Fonctionnalités Principales
- **Localisation en temps réel** : Géolocalisation de l'utilisateur avec affichage sur carte interactive
- **Navigation et itinéraires** : Création et suivi d'itinéraires personnalisés
- **Gestion des trajets** : Sauvegarde et historique des trajets effectués
- **Préférences utilisateur** : Personnalisation de l'interface et des paramètres
- **Interface responsive** : Adaptation automatique aux différentes tailles d'écran
- **Thème sombre/clair** : Basculement entre modes d'affichage avec détection automatique

## Architecture

L'application suit une architecture SPA (Single Page Application) basée sur Vue.js 3 :

- **App.vue** : Composant racine avec navigation globale et carte de fond
- **Router** : Gestion des routes pour la navigation entre les pages
- **Responsive Design** : Interface adaptative avec navigation mobile optimisée
- **Composition API** : Utilisation des fonctionnalités modernes de Vue.js
- **État réactif** : Gestion de l'état avec les refs et reactive de Vue

## Pages de l'application

- **🏠 Localisation** : Page principale avec géolocalisation
- **🧭 Itinéraires** : Planification et navigation d'itinéraires  
- **📝 Mes Trajets** : Historique et gestion des trajets sauvegardés
- **👤 Préférences** : Configuration utilisateur et paramètres

## Fonctionnalités techniques

- Carte de fond interactive avec Leaflet.js
- Interface glassmorphism avec backdrop-filter
- Navigation adaptative (desktop/mobile)
- Gestion automatique du thème selon les préférences système
- Chargement dynamique des ressources Leaflet
- Optimisations pour les appareils mobiles et orientation paysage

## Configuration

L'application utilise les APIs suivantes :
- **Geolocation API** : Pour obtenir la position de l'utilisateur
- **OpenStreetMap** : Tuiles de carte gratuites
- **Leaflet.js** : Bibliothèque de cartographie interactive

## Auteur
Projet développé dans le cadre du cours GIN206 - Génie Informatique

---
*Application GeoLocator - Projet de cours GIN206*
