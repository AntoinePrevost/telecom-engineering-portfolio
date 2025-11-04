# Guide de Déploiement Ginflix

## Installation Rapide

### Prérequis
```bash
# Logiciels requis
docker, kind, kubectl, nginx

# Vérification rapide
docker run hello-world
kind version
kubectl version --client
```

### Déploiement One-Click
```bash
./install.sh           # Installation complète
./monitor-scaling.sh   # Monitoring temps réel
./clean.sh            # Nettoyage complet
```

---

## Configuration Manuelle

### Cluster Multi-Nodes
```bash
# Création cluster 3-nodes
kind create cluster --name ginflix27-cluster --config kind-config.yaml

# Vérification
kubectl get nodes
```

### MetalLB LoadBalancer
```bash
# Installation
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml

# Configuration IP pool
kubectl apply -f 03-metallb-config.yaml

# Route d'accès
KIND_IP=$(docker inspect ginflix27-cluster-control-plane --format='{{.NetworkSettings.Networks.kind.IPAddress}}')
sudo ip route add 172.18.255.0/24 via $KIND_IP
```

### Services Applicatifs
```bash
# Déploiement ordonné
kubectl apply -f 01-namespace.yaml
kubectl apply -f 02-secrets-config.yaml
kubectl apply -f 04-network-policies.yaml
kubectl apply -f 05-mongodb.yaml
kubectl apply -f 06-backend.yaml
kubectl apply -f 07-frontend.yaml
kubectl apply -f 08-frontend-admin.yaml
kubectl apply -f 09-streamer.yaml
```

### Metrics & Autoscaling
```bash
# Metrics Server avec patch Kind
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.6.4/components.yaml

kubectl patch deployment metrics-server -n kube-system --patch '
spec:
  template:
    spec:
      containers:
      - name: metrics-server
        args:
        - --kubelet-insecure-tls
        - --kubelet-preferred-address-types=InternalIP
        - --metric-resolution=15s'

# HPA Configuration
kubectl apply -f 10-hpa.yaml
```

---

## Troubleshooting

### Diagnostic Rapide
```bash
# Status général
kubectl get all -n ginflix
kubectl get hpa -n ginflix
kubectl top pods -n ginflix

# Tests connectivité
kubectl exec -n ginflix deployment/backend -- curl mongodb-service:27017
```

### Problèmes Courants

#### MetalLB non fonctionnel
```bash
kubectl logs -n metallb-system deployment/controller
kubectl get validatingwebhookconfigurations metallb-webhook-configuration
```

#### Pods en erreur
```bash
kubectl describe pod <pod-name> -n ginflix
kubectl logs <pod-name> -n ginflix --previous
```

#### Metrics indisponibles
```bash
kubectl patch deployment metrics-server -n kube-system --patch '
spec:
  template:
    spec:
      containers:
      - name: metrics-server
        args:
        - --kubelet-insecure-tls'
```

---

## Maintenance

### Backup MongoDB
```bash
# Backup quotidien
kubectl exec -n ginflix deployment/mongodb -- mongodump --archive --gzip > backup_$(date +%Y%m%d).gz

# Restoration
kubectl exec -n ginflix deployment/mongodb -- mongorestore --archive --gzip < backup_file.gz
```

### Mise à jour Services
```bash
# Rolling update
kubectl rollout restart deployment/backend -n ginflix
kubectl rollout restart deployment/frontend -n ginflix
kubectl rollout status deployment/backend -n ginflix
```

### Monitoring Performance
```bash
# Dashboard temps réel
./monitor-scaling.sh

# Métriques détaillées
kubectl top nodes --sort-by=cpu
kubectl top pods -n ginflix --sort-by=cpu
```

---

## Configuration HTTPS

### Automatique
```bash
./https.sh    # Configuration complète nginx + SSL
```

### Manuelle
```bash
# Récupération IPs
FRONTEND_IP=$(kubectl get svc frontend-service -n ginflix -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
BACKEND_IP=$(kubectl get svc backend-service -n ginflix -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Configuration nginx
sudo tee /etc/nginx/sites-available/ginflix > /dev/null <<EOF
server {
    listen 443 ssl;
    server_name ginflix27.gin-telecom.ovh;
    
    ssl_certificate /etc/nginx/ssl/ginflix27.gin-telecom.ovh.crt;
    ssl_certificate_key /etc/nginx/ssl/ginflix27.gin-telecom.ovh.key;
    
    location / {
        proxy_pass http://$FRONTEND_IP/;
    }
    
    location /api {
        proxy_pass http://$BACKEND_IP:8080/api;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/ginflix /etc/nginx/sites-enabled/
sudo systemctl reload nginx
```

---

## Scaling Avancé

### HPA Optimisé
```yaml
# Configuration agressive pour FFmpeg
spec:
  minReplicas: 2
  maxReplicas: 8
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        averageUtilization: 40
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 15
      policies:
      - type: Pods
        value: 3
```

### Tests de Charge
```bash
# Génération charge CPU
kubectl exec -n ginflix deployment/backend -- sh -c 'yes > /dev/null &'

# Monitoring scaling
watch 'kubectl get hpa -n ginflix && kubectl get pods -n ginflix -l app=backend'

# Arrêt charge
kubectl exec -n ginflix deployment/backend -- pkill yes
```

Cette version condensée garde l'essentiel pour un déploiement efficace tout en gardant les informations critiques accessibles.
