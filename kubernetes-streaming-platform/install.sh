set -e

# Gestion cluster existant ou création nouveau
if kind get clusters | grep -q "ginflix27-cluster"; then
    read -p "Cluster existant détecté. Voulez-vous le recréer ? (y/N): " recreate
    if [[ $recreate == "y" || $recreate == "Y" ]]; then
        kind delete cluster --name ginflix27-cluster
    else
        kubectl cluster-info > /dev/null
    fi
fi

# Création cluster multi-nodes si inexistant
if ! kind get clusters | grep -q "ginflix27-cluster"; then
    kind create cluster --name ginflix27-cluster --config kind-config.yaml
    kubectl get nodes
fi

# Installation MetalLB
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml

# Attente des pods MetalLB
kubectl wait --for=condition=ready pod -l app=metallb -n metallb-system --timeout=300s

# Attente du webhook MetalLB
for i in {1..60}; do
    if kubectl get validatingwebhookconfigurations metallb-webhook-configuration >/dev/null 2>&1; then
        if kubectl apply --dry-run=server -f 03-metallb-config.yaml >/dev/null 2>&1; then
            break
        fi
    fi
    if [[ $i -eq 60 ]]; then
        break
    fi
    sleep 5
done

# Déploiement services
./deploy.sh

# Configuration routage MetalLB
KIND_IP=$(docker inspect ginflix27-cluster-control-plane --format='{{.NetworkSettings.Networks.kind.IPAddress}}')
sudo ip route add 172.18.255.0/24 via $KIND_IP 2>/dev/null || true

# Attente attribution IPs LoadBalancer
for i in {1..30}; do
    FRONTEND_IP=$(kubectl get svc frontend-service -n ginflix -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)
    ADMIN_IP=$(kubectl get svc frontend-admin-service -n ginflix -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)
    BACKEND_IP=$(kubectl get svc backend-service -n ginflix -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)
    STREAMER_IP=$(kubectl get svc streamer-service -n ginflix -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)
    
    if [[ -n "$FRONTEND_IP" && -n "$ADMIN_IP" && -n "$BACKEND_IP" && -n "$STREAMER_IP" ]]; then
        break
    fi
    sleep 10
done

# Configuration HTTPS
./https.sh

# État final du cluster
kubectl get nodes
kubectl get all -n ginflix
kubectl get hpa -n ginflix
kubectl top nodes 2>/dev/null || true