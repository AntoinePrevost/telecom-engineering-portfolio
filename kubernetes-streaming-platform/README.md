# Ginflix - Plateforme de Streaming Kubernetes
## Projet GIN207 - Applications et Services Multimédia

### Équipe
- **Antoine Prevost**
- **Jennifer Timani**

### Contexte Académique

Ce projet s'inscrit dans le cadre de l'UE **GIN207 : Applications et services multimédia** et constitue un mini-projet de 4 semaines intégrant l'ensemble des compétences acquises dans la filière GIN (GIN201, 203, 204, 205, 207).

#### Objectifs Pédagogiques
- Mise en œuvre d'un service de **VoD (Vidéo à la Demande)** distribué
- Déploiement sur cluster **Kubernetes** multi-nodes
- Intégration des technologies vues : infrastructure cloud, réseau, sécurité
- Analyse des architectures de diffusion multimédia modernes

---

## Documentation

### 📋 Table des Matières
- **[Architecture Technique](docs/ARCHITECTURE.md)** - Détails complets de l'architecture microservices
- **[Guide de Déploiement](docs/DEPLOYMENT.md)** - Instructions d'installation et maintenance
- **Installation Rapide** - Démarrage en une commande (ci-dessous)

---

## Vue d'ensemble

Plateforme de streaming vidéo déployée sur Kubernetes avec un cluster multi-nodes optimisé pour les performances et la résilience. Le projet implémente une architecture de **Content Delivery Network (CDN)** distribuée avec autoscaling intelligent.

### Technologies Utilisées
- **Container Orchestration** : Kubernetes avec Kind
- **Load Balancing** : MetalLB (Layer 2)
- **Streaming Protocol** : HLS (HTTP Live Streaming)
- **Video Processing** : FFmpeg
- **Storage** : S3-compatible (Garage)
- **Database** : MongoDB
- **Security** : Network Policies, HTTPS/TLS

---

## Installation Rapide

### Déploiement Automatisé
```bash
# Installation complète en une commande
./install.sh

# Monitoring temps réel
./monitor-scaling.sh
```

### Accès aux Services
- **Frontend** : https://ginflix27.gin-telecom.ovh
- **Administration** : https://admin.ginflix27.gin-telecom.ovh

### Nettoyage
```bash
./clean.sh    # Suppression complète
```

---

## Architecture Technique

### Configuration Multi-Nodes
Le cluster Kubernetes utilise **Kind** avec 3 nodes pour optimiser les performances et la résilience :

```
┌─────────────────────────────────────────────────────────────┐
│                    GINFLIX CLUSTER                         │
├─────────────────────────────────────────────────────────────┤
│ Control-Plan (ginflix27-cluster-control-plane)             │
│ ├── Kubernetes API Server                                  │
│ ├── etcd                                                   │
│ └── Scheduler + Controller Manager                         │
├─────────────────────────────────────────────────────────────┤
│ Worker-1 (ginflix27-cluster-worker)                        │
│ ├── Frontend Pods (2-4 replicas)                          │
│ ├── Backend Pods (2-8 replicas)                           │
│ └── MongoDB Pod                                            │
├─────────────────────────────────────────────────────────────┤
│ Worker-2 (ginflix27-cluster-worker2)                       │
│ ├── Streamer Pods (2-5 replicas)                          │
│ ├── Frontend-Admin Pods (2 replicas)                      │
│ └── Load Distribution                                       │
└─────────────────────────────────────────────────────────────┘
```

### Network Policies Sécurisées
- **Principe** : Seul le Backend peut accéder à MongoDB
- **Résultat** : Protection contre les accès non autorisés
- **Règles** : Blocage de tout trafic sauf backend → mongodb (port 27017)

## LoadBalancer avec MetalLB

### Configuration
- **Pool IP** : 172.18.255.200-250
- **Mode** : Layer 2 (ARP)
- **Attribution** : Automatique par service

### Résolution problème Kind
Les IPs MetalLB ne sont pas accessibles depuis l'hôte par défaut. On ajoute une route statique pour résoudre ce problème.

## Autoscaling (HPA)

### Stratégie Agressive
Configuration d'un HPA ultra-agressif pour répondre rapidement aux charges :
- **Réaction** : 15 secondes au lieu de 5 minutes standard
- **Scaling** : +3 pods ou doublement instantané
- **Justification** : Uploads FFmpeg = charge CPU intense mais temporaire

### Dimensionnement
| Service | CPU Request | Seuil HPA | Justification |
|---------|-------------|-----------|---------------|
| Backend | 200m | 40% | FFmpeg intensif |
| Frontend | 50m | 60% | Nginx léger |
| Streamer | 100m | 50% | Réseau modéré |

## Metrics Server

### Problématique Kind
Le metrics-server officiel ne fonctionne pas directement avec Kind à cause des certificats TLS.

### Solution
J'ai automatisé l'installation avec les patches nécessaires :
- Installation depuis le repository officiel
- Application automatique des arguments Kind
- Configuration TLS adaptée

---

## Améliorations Apportées

- ✅ Cluster multi-nodes pour la performance
- ✅ Sécurisation avec Network Policies
- ✅ LoadBalancer MetalLB fonctionnel
- ✅ Autoscaling ultra-réactif
- ✅ Installation automatisée complète
- ✅ Monitoring en temps réel
- ✅ Configuration HTTPS
- ✅ Persistance des données MongoDB

---

## Support et Documentation

Pour plus d'informations détaillées :
- **Architecture complète** : [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- **Guide de déploiement** : [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md)
- **Monitoring** : `./monitor-scaling.sh`
- **Troubleshooting** : Voir section dans le guide de déploiement
