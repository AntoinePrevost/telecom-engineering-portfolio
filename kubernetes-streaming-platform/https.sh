# Récupération IPs LoadBalancer
FRONTEND_IP=$(kubectl get svc frontend-service -n ginflix -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
ADMIN_IP=$(kubectl get svc frontend-admin-service -n ginflix -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
BACKEND_IP=$(kubectl get svc backend-service -n ginflix -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
STREAMER_IP=$(kubectl get svc streamer-service -n ginflix -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Configuration certificats SSL
sudo mkdir -p /etc/nginx/ssl
sudo cp certs/ginflix27.gin-telecom.ovh.crt /etc/nginx/ssl/
sudo cp certs/ginflix27.gin-telecom.ovh.key /etc/nginx/ssl/
sudo chmod 644 /etc/nginx/ssl/*.crt
sudo chmod 600 /etc/nginx/ssl/*.key

# Génération configuration nginx
sudo tee /etc/nginx/sites-available/ginflix > /dev/null <<EOF
server {
    listen 80;
    server_name ginflix27.gin-telecom.ovh admin.ginflix27.gin-telecom.ovh;
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl;
    server_name ginflix27.gin-telecom.ovh;
    
    ssl_certificate /etc/nginx/ssl/ginflix27.gin-telecom.ovh.crt;
    ssl_certificate_key /etc/nginx/ssl/ginflix27.gin-telecom.ovh.key;
    
    client_max_body_size 1G;
    proxy_connect_timeout 300s;
    proxy_send_timeout 300s;
    proxy_read_timeout 300s;
    proxy_request_buffering off;
    
    location / {
        proxy_pass http://$FRONTEND_IP/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
    
    location /api {
        proxy_pass http://$BACKEND_IP:8080/api;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
    
    location /stream {
        proxy_pass http://$STREAMER_IP:8080/stream;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        
        add_header Access-Control-Allow-Origin "*" always;
        add_header Access-Control-Allow-Methods "GET, HEAD, OPTIONS" always;
        add_header Access-Control-Allow-Headers "Range, Content-Range" always;
        add_header Cache-Control "no-cache" always;
        
        proxy_set_header Range \$http_range;
        proxy_set_header If-Range \$http_if_range;
        proxy_pass_request_body on;
        proxy_pass_request_headers on;
    }
}

server {
    listen 443 ssl;
    server_name admin.ginflix27.gin-telecom.ovh;
    
    ssl_certificate /etc/nginx/ssl/ginflix27.gin-telecom.ovh.crt;
    ssl_certificate_key /etc/nginx/ssl/ginflix27.gin-telecom.ovh.key;
    
    client_max_body_size 1G;
    proxy_connect_timeout 300s;
    proxy_send_timeout 300s;
    proxy_read_timeout 300s;
    proxy_request_buffering off;
    
    location / {
        proxy_pass http://$ADMIN_IP/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
    
    location /api {
        proxy_pass http://$BACKEND_IP:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
    
    location /stream {
        proxy_pass http://$STREAMER_IP:8080/stream;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        
        add_header Access-Control-Allow-Origin "*" always;
        add_header Access-Control-Allow-Methods "GET, HEAD, OPTIONS" always;
        add_header Access-Control-Allow-Headers "Range, Content-Range" always;
        add_header Cache-Control "no-cache" always;
        
        proxy_set_header Range \$http_range;
        proxy_set_header If-Range \$http_if_range;
        proxy_pass_request_body on;
        proxy_pass_request_headers on;
    }
}
EOF

# Activation configuration nginx
sudo ln -sf /etc/nginx/sites-available/ginflix /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx