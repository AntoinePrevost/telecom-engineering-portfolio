set -e

# Vérification cluster
kubectl cluster-info > /dev/null

# Création namespace
kubectl apply -f 01-namespace.yaml

# Configuration secret registry
kubectl create secret docker-registry regcred \
  --docker-server=registry.gin-telecom.ovh \
  --docker-username="ginflix" \
  --docker-password="ginflix" \
  --docker-email="ginflix@ginflix.gin-telecom.ovh" \
  --namespace=ginflix --dry-run=client -o yaml | kubectl apply -f -

# Application secrets et configmaps
kubectl apply -f 02-secrets-config.yaml
kubectl apply -f 03-metallb-config.yaml
kubectl apply -f 04-network-policies.yaml

# Déploiement services applicatifs
kubectl apply -f 05-mongodb.yaml
kubectl apply -f 06-backend.yaml
kubectl apply -f 07-frontend.yaml
kubectl apply -f 08-frontend-admin.yaml
kubectl apply -f 09-streamer.yaml

# Installation Metrics Server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.6.4/components.yaml
sleep 10

# Patch du deployment avec les arguments Kind
kubectl patch deployment metrics-server -n kube-system --type='strategic' --patch '
spec:
  template:
    spec:
      containers:
      - name: metrics-server
        args:
        - --cert-dir=/tmp
        - --secure-port=4443
        - --kubelet-preferred-address-types=InternalIP
        - --kubelet-insecure-tls
        - --metric-resolution=15s
'

# Patch de l'APIService pour désactiver TLS
kubectl patch apiservice v1beta1.metrics.k8s.io --type='merge' --patch '
spec:
  insecureSkipTLSVerify: true
'
sleep 15

# Déploiement HPA
kubectl apply -f 10-hpa.yaml

# Vérification finale
sleep 10
kubectl get svc -n ginflix
kubectl get hpa -n ginflix