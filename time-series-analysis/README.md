# TSIA202a - Travaux Pratiques d'Analyse des Processus Stochastiques

## 📚 Description du Cours

Ce repository contient les travaux pratiques du cours TSIA202a portant sur l'analyse des processus stochastiques et leurs applications au traitement du signal. Les TP couvrent l'estimation spectrale, l'analyse des moments statistiques et la modélisation de signaux de parole.

## 👥 Auteurs

- **Antoine** - Étudiant TSIA202a
- **Cours dispensé dans le cadre du programme TSIA (Traitement du Signal et Intelligence Artificielle)**


## 📖 Contenu des Travaux Pratiques

### TP 1 : Estimation des Moments du Second Ordre pour les Processus Aléatoires

**Objectifs :**
- Expérimenter l'estimation des moments du second ordre pour les processus aléatoires
- Comparer les estimateurs empiriques avec leurs versions théoriques
- Analyser la convergence des estimateurs en fonction de la taille d'échantillon

**Processus étudiés :**
1. **Bruit Blanc (WN)** : $Z_t$ avec variance $\sigma^2$
2. **Processus MA(1)** : $X_t = a + bZ_t + Z_{t-1}$
3. **Processus à moyenne mobile** : $X_t = \sum_{k=0}^{K}2^{-k}Z_{t-k} + a$
4. **Processus Harmonique** : $X_t = A_0\cos(\lambda_0t+\Phi_0) + Z_t$

**Méthodes implémentées :**
- Calcul théorique des moyennes et autocovariances
- Estimation empirique des moments
- Analyse de l'erreur quadratique moyenne (MSE)
- Visualisation comparative pour différentes tailles d'échantillon

### TP 2 : Estimation de la Densité Spectrale de Puissance et Périodogramme

**Objectifs :**
- Implémenter l'estimation de la densité spectrale de puissance
- Utiliser l'algorithme FFT pour calculer le périodogramme
- Explorer la relation entre autocovariance empirique et périodogramme

**Concepts clés :**
- **Périodogramme** : $I_n(\lambda) = \frac{1}{2\pi n}|\sum_{k=0}^{n-1} X_k e^{i\lambda k}|^2$
- **Théorème de Herglotz** : relation entre $\hat{\gamma}_n$ et $I_n$
- **Transformée de Fourier Discrète (DFT)** et son lien avec le périodogramme

**Analyses réalisées :**
- Démonstration théorique des relations DFT-périodogramme
- Estimation spectrale pour les processus du TP1
- Étude de la variance du périodogramme pour le bruit blanc
- Implémentation d'estimateurs d'autocovariance via IDFT

### TP 3 : Modélisation AR(p) pour les Signaux de Parole

**Objectifs :**
- Modéliser un signal de parole à l'aide d'un processus AR(p)
- Implémenter un algorithme de synthèse vocale basé sur la prédiction linéaire
- Analyser les performances du modèle AR pour la compression/synthèse audio

**Pipeline de synthèse :**
1. **Pré-accentuation** : Filtrage pour égaliser le spectre
2. **Segmentation** : Division en trames avec recouvrement
3. **Détection de pitch** : Classification voisé/non-voisé et estimation de F0
4. **Estimation AR(p)** : Utilisation des équations de Yule-Walker
5. **Re-synthèse** : Génération à partir des coefficients AR
6. **Overlap-add** : Reconstruction avec fenêtrage de Hanning
7. **Dé-accentuation** : Filtrage inverse

**Équations de Yule-Walker :**
```
Processus AR(p) : X_t = φ₁X_{t-1} + φ₂X_{t-2} + ... + φₚX_{t-p} + Z_t
Forme matricielle : Γₚ₊₁[1 -φ₁ ... -φₚ]ᵀ = [σ² 0 ... 0]ᵀ
```

## 🛠️ Installation et Utilisation

### Prérequis
```bash
pip install numpy matplotlib scipy librosa soundfile seaborn tqdm ipython
```

### Lancement des notebooks
```bash
jupyter notebook TP-1_TSIA202A.ipynb
jupyter notebook TP-2_TSIA202A.ipynb  
jupyter notebook TP3_TSIA202a.ipynb
```

## 📊 Résultats Principaux

### TP1 - Convergence des Estimateurs
- Les estimateurs empiriques convergent vers les valeurs théoriques avec l'augmentation de T
- L'erreur quadratique moyenne diminue en $O(1/T)$
- Validation de la loi des grands nombres pour les processus stationnaires

### TP2 - Estimation Spectrale
- Relation démontrée entre DFT et périodogramme : $I_n(2πk/m) = \frac{1}{2πn}|DFT(X,m)(k)|²$
- Implémentation efficace via FFT
- Étude de la variance du périodogramme pour le bruit blanc

### TP3 - Synthèse Vocale
- Modélisation efficace des signaux de parole par processus AR(30)
- Synthèse de qualité acceptable avec compression significative
- Possibilité de modification du pitch pour altérer la voix

## 📈 Concepts Théoriques Abordés

- **Processus stochastiques** : stationnarité, ergodicité
- **Estimation statistique** : biais, variance, convergence
- **Analyse spectrale** : transformée de Fourier, périodogramme
- **Modélisation paramétrique** : processus AR, équations de Yule-Walker
- **Traitement de la parole** : détection de pitch, prédiction linéaire

## 🎯 Compétences Développées

1. **Analyse théorique** : Démonstrations mathématiques rigoureuses
2. **Implémentation numérique** : Algorithmes d'estimation et de synthèse
3. **Validation empirique** : Comparaison théorie/pratique
4. **Visualisation** : Graphiques d'analyse et de validation
5. **Applications pratiques** : Traitement de signaux audio réels

## 📚 Références

- Cours TSIA202a - Analyse des Processus Stochastiques
- Oppenheim & Schafer - Discrete-Time Signal Processing
- Kay - Modern Spectral Estimation
- Rabiner & Juang - Fundamentals of Speech Recognition

## 📄 Licence

Ce travail est réalisé dans le cadre académique du programme TSIA. Utilisation libre pour l'enseignement et la recherche.

---

*Dernière mise à jour : Novembre 2025*