# Monitoring en temps réel de l'infrastructure multi-nodes
while true; do
    clear
    echo "=== GINFLIX MULTI-NODES MONITORING $(date) ==="
    echo ""
    
    # Affichage des nodes du cluster
    echo "CLUSTER NODES:"
    kubectl get nodes -o wide | head -4
    echo ""
    
    # État des HPA
    echo "HPA STATUS:"
    kubectl get hpa -n ginflix 2>/dev/null || echo "❌ HPA indisponible"
    echo ""
    
    # Comptage pods par service
    echo "POD COUNT & DISTRIBUTION:"
    echo "Backend:  $(kubectl get pods -n ginflix -l app=backend --no-headers 2>/dev/null | wc -l) pods"
    echo "Frontend: $(kubectl get pods -n ginflix -l app=frontend --no-headers 2>/dev/null | wc -l) pods"  
    echo "Streamer: $(kubectl get pods -n ginflix -l app=streamer --no-headers 2>/dev/null | wc -l) pods"
    echo ""
    
    # Répartition des pods par node
    echo "PODS PAR NODE:"
    kubectl get pods -n ginflix -o wide --no-headers 2>/dev/null | awk '{print $1 " → " $7}' | sort -k3
    echo ""
    
    # Utilisation des ressources par pod
    echo "RESOURCE USAGE:"
    kubectl top pods -n ginflix 2>/dev/null || echo "❌ Metrics indisponibles"
    echo ""
    
    # Utilisation des ressources par node
    echo "NODES USAGE:"
    kubectl top nodes 2>/dev/null || echo "❌ Node metrics indisponibles"
    echo ""
    
    # État des pods
    echo "POD STATUS:"
    kubectl get pods -n ginflix | grep -E "(backend|frontend|streamer)" | awk '{print $1 " " $3 " " $2}'
    echo ""
    
    # Attente avant refresh
    echo "...Refresh dans 10s... (Ctrl+C pour arrêter)"
    sleep 10
done