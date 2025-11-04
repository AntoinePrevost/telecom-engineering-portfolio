# TP Source Coding & JPEG - TSIA 207

## Auteur
**Antoine Prevost** - TSIA 207

## Description
Ce TP explore les concepts fondamentaux du codage de source appliqué à la compression d'images, en implémentant une chaîne de compression similaire au standard JPEG.

## Objectifs
- Comprendre les étapes clés de la compression d'images
- Implémenter les composants d'une chaîne de compression JPEG
- Analyser l'impact de différents paramètres sur la qualité et le taux de compression

## Contenu du TP

### 1. Conversion d'espace de couleurs (15 min)
- Implémentation des conversions RGB ↔ YUV
- Formats YUV : 444, 422, 420
- Séparation luminance/chrominance

### 2. Partitionnement en blocs (30 min)
- Partitionnement uniforme en blocs 8x8
- Algorithme de quadtree (optionnel)
- Préparation pour la transformation DCT

### 3. Transformée en cosinus discrète (DCT) (45 min)
- Implémentation de la DCT 2D par blocs
- Transformation du domaine spatial vers fréquentiel
- DCT inverse pour reconstruction

### 4. Quantification (30 min)
- Quantification uniforme des coefficients DCT
- Réduction de la précision des coefficients
- Impact sur la qualité d'image

### 5. Codage entropique (45 min)
- Implémentation du codage de Huffman
- Réduction de la redondance statistique
- Compression sans perte finale

## Structure des fichiers
```
TSIA 207/
├── TP-Antoine-Prevost.ipynb   # Notebook principal
├── README.md                  # Ce fichier
├── compression-env/           # Environnement Python
└── images/                    # Images de test
    ├── birds.png
    └── lena.png
```

## Prérequis
- Python 3.12+
- Jupyter Notebook
- Bibliothèques : numpy, PIL, matplotlib, scikit-image, scipy

## Installation
```bash
# Activer l'environnement virtuel
source compression-env/bin/activate

# Ou installer les dépendances manuellement
pip install numpy pillow matplotlib scikit-image scipy jupyter
```

## Utilisation
1. Lancer Jupyter Notebook
2. Ouvrir `TP-Antoine-Prevost.ipynb`
3. Exécuter les cellules séquentiellement
4. Compléter les fonctions marquées `# write code below/above`

## Exécution
### Démarrage rapide
```bash
# Naviguer vers le répertoire du TP
cd "/telecom/TSIA 207"

# Activer l'environnement virtuel
source compression-env/bin/activate

# Lancer Jupyter Notebook
jupyter notebook TP-Antoine-Prevost.ipynb
```

### Étapes d'exécution détaillées
1. **Configuration** : Vérifier que toutes les bibliothèques sont installées
2. **Images de test** : Les images `birds.png` et `lena.png` sont fournies dans le dossier `images/`
3. **Implémentation** : Compléter les fonctions dans l'ordre des sections
4. **Tests** : Chaque section contient des cellules de visualisation pour valider l'implémentation
5. **Expérimentation** : Tester différents paramètres (taille de blocs, niveaux de quantification)

### Conseils d'exécution
- Exécuter les cellules dans l'ordre pour maintenir l'état des variables
- Utiliser les fonctions de visualisation pour comprendre l'effet de chaque étape
- Expérimenter avec différents paramètres pour observer les compromis qualité/compression

## Points clés à retenir
- **Compromis qualité/compression** : Plus la quantification est agressive, plus la compression est élevée mais la qualité diminue
- **Importance de la DCT** : Concentre l'énergie sur peu de coefficients pour une compression efficace
- **Codage entropique** : Dernière étape pour éliminer la redondance statistique
