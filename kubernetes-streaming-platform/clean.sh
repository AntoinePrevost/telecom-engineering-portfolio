# Suppression route MetalLB
sudo ip route del 172.18.255.0/24 2>/dev/null || true

# Suppression ressources Kubernetes dans l'ordre inverse
kubectl delete -f 11-hpa.yaml --ignore-not-found=true > /dev/null 2>&1
kubectl delete -f 10-metrics-server.yaml --ignore-not-found=true > /dev/null 2>&1
kubectl delete -f 09-streamer.yaml --ignore-not-found=true > /dev/null 2>&1
kubectl delete -f 08-frontend-admin.yaml --ignore-not-found=true > /dev/null 2>&1
kubectl delete -f 07-frontend.yaml --ignore-not-found=true > /dev/null 2>&1
kubectl delete -f 06-backend.yaml --ignore-not-found=true > /dev/null 2>&1
kubectl delete -f 05-mongodb.yaml --ignore-not-found=true > /dev/null 2>&1
kubectl delete -f 04-network-policies.yaml --ignore-not-found=true > /dev/null 2>&1
kubectl delete -f 03-metallb-config.yaml --ignore-not-found=true > /dev/null 2>&1
kubectl delete -f 02-secrets-config.yaml --ignore-not-found=true > /dev/null 2>&1
kubectl delete secret regcred -n ginflix --ignore-not-found=true > /dev/null 2>&1
kubectl delete -f 01-namespace.yaml --ignore-not-found=true > /dev/null 2>&1

# Suppression CRDs Metrics Server et MetalLB
kubectl delete -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.6.4/components.yaml --ignore-not-found=true > /dev/null 2>&1
kubectl delete -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml --ignore-not-found=true > /dev/null 2>&1

# Nettoyage configuration nginx
sudo rm -f /etc/nginx/sites-enabled/ginflix > /dev/null 2>&1
sudo systemctl reload nginx > /dev/null 2>&1 || true

# Suppression cluster Kind et nettoyage Docker
kind delete cluster --name ginflix27-cluster > /dev/null 2>&1
docker system prune -f > /dev/null 2>&1