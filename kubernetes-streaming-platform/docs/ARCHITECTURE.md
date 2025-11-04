# Architecture Technique Ginflix

## Table des Matières
1. [Vue d'ensemble Architecture](#vue-densemble-architecture)
2. [Cluster Kubernetes Multi-Nodes](#cluster-kubernetes-multi-nodes)
3. [Services et Microservices](#services-et-microservices)
4. [Réseau et Sécurité](#réseau-et-sécurité)
5. [Stockage et Persistance](#stockage-et-persistance)
6. [Load Balancing](#load-balancing)
7. [Autoscaling](#autoscaling)
8. [Monitoring et Métriques](#monitoring-et-métriques)

## Vue d'ensemble Architecture

### Paradigme Architectural
Ginflix implémente une architecture **microservices** déployée sur Kubernetes avec les principes suivants :

- **Separation of Concerns** : Chaque service a une responsabilité unique
- **Scalabilité Horizontale** : Auto-scaling basé sur les métriques
- **Résilience** : Distribution multi-nodes avec failover automatique
- **Sécurité Zero-Trust** : Network policies restrictives
- **Observabilité** : Métriques et monitoring temps réel

### Diagramme d'Architecture Globale

```
┌─────────────────────────────────────────────────────────────────────────┐
│                             GINFLIX PLATFORM                            │
├─────────────────────────────────────────────────────────────────────────┤
│                              USERS LAYER                               │
│  ┌─────────────────┐              ┌─────────────────┐                  │
│  │   End Users     │              │   Admins        │                  │
│  │                 │              │                 │                  │
│  └─────────┬───────┘              └─────────┬───────┘                  │
├────────────┼────────────────────────────────┼────────────────────────────┤
│            │         NGINX REVERSE PROXY    │                          │
│            │     ┌─────────────────────────────────┐                   │
│            │     │ HTTPS/TLS Termination           │                   │
│            │     │ • ginflix27.gin-telecom.ovh     │                   │
│            │     │ • admin.ginflix27.gin-telecom.ovh │                 │
│            │     └─────────────────────────────────┘                   │
├────────────┼────────────────────────────────┼────────────────────────────┤
│            │         KUBERNETES CLUSTER     │                          │
│            ▼                                ▼                          │
│  ┌─────────────────┐              ┌─────────────────┐                  │
│  │   Frontend      │              │ Frontend-Admin  │                  │
│  │   (User App)    │              │ (Admin App)     │                  │
│  │                 │              │                 │                  │
│  │ • React UI      │              │ • Admin UI      │                  │
│  │ • nginx         │              │ • nginx         │                  │
│  │ • HPA 2-4       │              │ • 2 replicas    │                  │
│  └─────────┬───────┘              └─────────┬───────┘                  │
│            │                                │                          │
│            └────────────┬───────────────────┘                          │
│                         ▼                                              │
│              ┌─────────────────┐                                       │
│              │    Backend      │                                       │
│              │   (API + FFmpeg)│                                       │
│              │                 │                                       │
│              │ • Node.js API   │                                       │
│              │ • FFmpeg        │                                       │
│              │ • Upload/Transcode │                                    │
│              │ • HPA 2-8       │                                       │
│              └─────────┬───────┘                                       │
│                        │                                               │
│             ┌──────────┼──────────┐                                    │
│             ▼          ▼          ▼                                    │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐                     │
│  │   MongoDB   │ │   Streamer  │ │  External   │                     │
│  │             │ │             │ │  Services   │                     │
│  │ • Database  │ │ • HLS       │ │             │                     │
│  │ • Metadata  │ │ • Video     │ │ • S3 Storage│                     │
│  │ • Users     │ │ • CDN       │ │ • Keycloak  │                     │
│  │ • 1 replica │ │ • HPA 2-5   │ │ • HTTPS     │                     │
│  └─────────────┘ └─────────────┘ └─────────────┘                     │
└─────────────────────────────────────────────────────────────────────────┘
```

## Cluster Kubernetes Multi-Nodes

### Configuration Kind

```yaml
# kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker  
- role: worker
```

### Topologie Réseau

```
Docker Network: kind (172.18.0.0/16)
├── Control-Plane: ginflix27-cluster-control-plane (172.18.0.4)
│   ├── API Server (6443)
│   ├── etcd (2379-2380)
│   ├── Scheduler
│   └── Controller Manager
├── Worker-1: ginflix27-cluster-worker (172.18.0.2)
│   ├── kubelet
│   ├── kube-proxy
│   └── Container Runtime
└── Worker-2: ginflix27-cluster-worker2 (172.18.0.3)
    ├── kubelet
    ├── kube-proxy
    └── Container Runtime
```

### Stratégie de Placement des Pods

| Service | Stratégie | Justification |
|---------|-----------|---------------|
| **Backend** | Anti-affinity préférée | Distribution charge FFmpeg |
| **Frontend** | Anti-affinity préférée | Résilience interface utilisateur |
| **Streamer** | Anti-affinity préférée | Distribution bande passante |
| **MongoDB** | Node affinity forte | Persistance données critique |

## Services et Microservices

### Frontend Service

```yaml
Deployment: frontend
├── Replicas: 2-4 (HPA)
├── Image: registry.gin-telecom.ovh/ginflix/frontend:latest
├── Port: 80 (nginx)
├── Resources:
│   ├── Requests: 50m CPU, 64Mi RAM
│   └── Limits: 100m CPU, 128Mi RAM
├── ConfigMap: ginflix-config
└── Service: LoadBalancer (MetalLB)
```

**Responsabilités** :
- Interface utilisateur React
- Authentification Keycloak
- Lecture vidéo HLS
- Communication API Backend

### Frontend-Admin Service

```yaml
Deployment: frontend-admin
├── Replicas: 2 (fixe)
├── Image: registry.gin-telecom.ovh/ginflix/frontend-admin:latest
├── Port: 80 (nginx)
├── ConfigMap: ginflix-config
└── Service: LoadBalancer (MetalLB)
```

**Responsabilités** :
- Interface d'administration
- Gestion des contenus
- Analytics et métriques
- Configuration système

### Backend Service

```yaml
Deployment: backend
├── Replicas: 2-8 (HPA agressif)
├── Image: registry.gin-telecom.ovh/ginflix/backend:latest
├── Port: 8080 (Node.js)
├── Resources:
│   ├── Requests: 250m CPU, 256Mi RAM
│   └── Limits: 500m CPU, 512Mi RAM
├── Secrets: s3-credentials
├── ConfigMap: ginflix-config
└── Service: LoadBalancer (MetalLB)
```

**Responsabilités** :
- API REST complète
- Upload de fichiers
- Transcodage FFmpeg
- Gestion métadonnées MongoDB
- Authentification Keycloak
- Interface S3 Garage

### Streamer Service

```yaml
Deployment: streamer
├── Replicas: 2-5 (HPA)
├── Image: registry.gin-telecom.ovh/ginflix/streamer:latest
├── Port: 8080 (Node.js)
├── Resources:
│   ├── Requests: 100m CPU, 128Mi RAM
│   └── Limits: 200m CPU, 256Mi RAM
├── Secrets: s3-credentials
└── Service: LoadBalancer (MetalLB)
```

**Responsabilités** :
- Streaming HLS adaptatif
- Cache intelligents
- Distribution CDN
- Gestion bande passante

### MongoDB Service

```yaml
Deployment: mongodb
├── Replicas: 1 (StatefulSet recommandé)
├── Image: mongo:5.0
├── Port: 27017
├── Resources:
│   ├── Requests: 100m CPU, 256Mi RAM
│   └── Limits: 200m CPU, 512Mi RAM
├── PVC: 5Gi (ReadWriteOnce)
└── Service: ClusterIP (interne uniquement)
```

**Responsabilités** :
- Stockage métadonnées
- Données utilisateurs
- Index de recherche
- Logs applicatifs

## Réseau et Sécurité

### Network Policies Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    NETWORK SECURITY MODEL                      │
├─────────────────────────────────────────────────────────────────┤
│                         EXTERNAL                               │
│  ┌─────────────┐  HTTPS   ┌─────────────────────────────────┐   │
│  │   Users     │◄────────►│      nginx Proxy               │   │
│  │   Admins    │          │                                 │   │
│  └─────────────┘          └─────────────┬───────────────────┘   │
├─────────────────────────────────────────┼───────────────────────┤
│                    KUBERNETES DMZ       │                       │
│                                         ▼                       │
│  ┌─────────────┐         ┌─────────────────┐         ┌────────┐ │
│  │  Frontend   │◄───────►│    Backend      │◄───────►│External│ │
│  │  (Port 80)  │   HTTP  │   (Port 8080)   │  HTTPS  │Services│ │
│  └─────────────┘         └─────────────────┘         │S3+Auth │ │
│         │                          │                 └────────┘ │
│         │ HTTP                     │ MongoDB                    │
│         ▼                          ▼ (Port 27017)              │
│  ┌─────────────┐         ┌─────────────────┐                   │
│  │  Streamer   │         │    MongoDB      │                   │
│  │  (Port 8080)│         │   (ClusterIP)   │                   │
│  └─────────────┘         └─────────────────┘                   │
├─────────────────────────────────────────────────────────────────┤
│                    POLICY ENFORCEMENT                          │
│  • Default Deny All                                            │
│  • Explicit Allow Rules                                        │
│  • Pod-to-Pod Isolation                                        │
│  • Ingress/Egress Control                                      │
└─────────────────────────────────────────────────────────────────┘
```

### Règles de Sécurité Détaillées

#### MongoDB Isolation Policy
```yaml
# Seul le Backend peut accéder à MongoDB
spec:
  podSelector:
    matchLabels:
      app: mongodb
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: backend
    ports:
    - protocol: TCP
      port: 27017
```

#### Backend Security Policy
```yaml
# Backend peut recevoir du trafic Frontend et accéder MongoDB
spec:
  podSelector:
    matchLabels:
      app: backend
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
  - from:
    - podSelector:
        matchLabels:
          app: frontend-admin
  - from: []  # External LoadBalancer
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: mongodb
  - {}  # External services (S3, Keycloak)
```

## Stockage et Persistance

### Architecture de Stockage

```
┌─────────────────────────────────────────────────────────┐
│                   STORAGE ARCHITECTURE                 │
├─────────────────────────────────────────────────────────┤
│                    PERSISTENT LAYER                    │
│  ┌─────────────────┐              ┌─────────────────┐   │
│  │   MongoDB PVC   │              │   External S3   │   │
│  │                 │              │                 │   │
│  │ • Size: 5Gi     │              │ • Garage        │   │
│  │ • RWO           │              │ • Bucket:       │   │
│  │ • Local Storage │              │   ginflix27     │   │
│  │ • Kubernetes    │              │ • Videos/HLS    │   │
│  │   managed       │              │ • Thumbnails    │   │
│  └─────────────────┘              └─────────────────┘   │
├─────────────────────────────────────────────────────────┤
│                     EPHEMERAL LAYER                    │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────┐ │
│  │ Frontend Cache  │  │ Backend Temp    │  │Streamer │ │
│  │                 │  │                 │  │ Cache   │ │
│  │ • nginx cache   │  │ • FFmpeg temp   │  │         │ │
│  │ • Static assets │  │ • Upload buffer │  │ • HLS   │ │
│  │ • emptyDir      │  │ • emptyDir      │  │ • CDN   │ │
│  └─────────────────┘  └─────────────────┘  └─────────┘ │
└─────────────────────────────────────────────────────────┘
```

### MongoDB Persistance Strategy

```yaml
# Persistent Volume Claim
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mongodb-pvc
  namespace: ginflix
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  # StorageClass: default (local-path pour Kind)
```

**Caractéristiques** :
- **Access Mode** : ReadWriteOnce (single node attachment)
- **Storage Class** : local-path (Kind default)
- **Backup Strategy** : MongoDB dump vers S3 (futur)
- **Retention** : Persistent même après pod deletion

### S3-Compatible Storage (Garage)

**Configuration** :
```yaml
S3_ENDPOINT: https://s3.gin-telecom.ovh
S3_BUCKET: ginflix27
AWS_REGION: us-east-1
```

**Structure Bucket** :
```
ginflix27/
├── videos/
│   ├── original/          # Fichiers sources uploadés
│   ├── transcoded/        # Vidéos transcodées
│   └── hls/              # Segments HLS (.m3u8, .ts)
├── thumbnails/           # Vignettes générées
├── subtitles/            # Sous-titres (futur)
└── temp/                 # Fichiers temporaires
```

## Load Balancing

### MetalLB Configuration

```yaml
# IP Address Pool
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: metallb-ippool
  namespace: metallb-system
spec:
  addresses:
  - 172.18.255.200-172.18.255.250
  autoAssign: true
```

### Service Load Balancing Strategy

| Service | LoadBalancer IP | Algorithm | Health Check |
|---------|----------------|-----------|--------------|
| **frontend-service** | 172.18.255.201 | Round-Robin | HTTP /health |
| **frontend-admin-service** | 172.18.255.202 | Round-Robin | HTTP /health |
| **backend-service** | 172.18.255.203 | Round-Robin | HTTP /api/health |
| **streamer-service** | 172.18.255.204 | Round-Robin | HTTP /stream/health |

### nginx Reverse Proxy Configuration

```nginx
# Load balancing vers pods Kubernetes
upstream frontend_backend {
    server 172.18.255.201:80;
    # Health check automatique
}

upstream api_backend {
    server 172.18.255.203:8080;
    # Session affinity for uploads
}

upstream streaming_backend {
    server 172.18.255.204:8080;
    # Optimisé pour streaming
}
```

## Autoscaling

### HPA Configuration Strategy

#### Backend HPA (CPU-Intensive)
```yaml
spec:
  minReplicas: 2
  maxReplicas: 8
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 40    # Seuil bas pour FFmpeg
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 50
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 15  # Réaction rapide
      policies:
      - type: Pods
        value: 3                      # +3 pods immédiatement
      - type: Percent
        value: 100                    # Ou doublement
```

#### Frontend HPA (Traffic-Based)
```yaml
spec:
  minReplicas: 2
  maxReplicas: 4
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 60    # nginx plus efficient
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 15
      policies:
      - type: Pods
        value: 2                  # +2 pods max
```

### Scaling Decision Matrix

| Condition | Backend Action | Frontend Action | Streamer Action |
|-----------|---------------|----------------|-----------------|
| **Upload spike** | Scale to 6-8 pods | Maintain | Scale to 3-4 pods |
| **View spike** | Maintain | Scale to 4 pods | Scale to 5 pods |
| **Night hours** | Scale to 2 pods | Scale to 2 pods | Scale to 2 pods |
| **Peak hours** | Auto-scale | Auto-scale | Auto-scale |

## Monitoring et Métriques

### Metrics Server Configuration

```yaml
# Patch pour Kind compatibility
spec:
  template:
    spec:
      containers:
      - name: metrics-server
        args:
        - --kubelet-insecure-tls      # Kind certificates
        - --kubelet-preferred-address-types=InternalIP
        - --metric-resolution=15s     # High frequency
```

### Métriques Collectées

#### Niveau Infrastructure
- **CPU utilization** par node et pod
- **Memory utilization** par node et pod  
- **Network I/O** par pod
- **Disk I/O** pour persistance

#### Niveau Application
- **Request latency** (API response time)
- **Upload throughput** (MB/s)
- **Transcoding time** (FFmpeg performance)
- **Streaming quality** (buffering events)
- **Error rates** par service

#### Niveau Business
- **Active users** (concurrent viewers)
- **Video uploads** per hour
- **Popular content** (view count)
- **Geographic distribution** (CDN hits)

### Alerting Strategy

| Métrique | Seuil Warning | Seuil Critical | Action |
|----------|---------------|----------------|--------|
| **CPU > 80%** | 2 min | 5 min | Auto-scale |
| **Memory > 90%** | 1 min | 3 min | Scale + alert |
| **Upload fails** | 5% | 10% | Investigation |
| **Stream errors** | 2% | 5% | CDN check |

Cette architecture garantit une plateforme de streaming robuste, sécurisée et scalable, démontrant l'application pratique des concepts GIN207.
