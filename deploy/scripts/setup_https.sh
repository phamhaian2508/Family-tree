#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <domain> <email>"
  echo "Example: $0 familytree.example.com admin@example.com"
  exit 1
fi

DOMAIN="$1"
EMAIL="$2"

if command -v dnf >/dev/null 2>&1; then
  sudo dnf install -y nginx certbot python3-certbot-nginx
elif command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y nginx certbot python3-certbot-nginx
else
  echo "Unsupported OS package manager."
  exit 1
fi

sudo systemctl enable --now nginx

sudo tee /etc/nginx/conf.d/family-tree.conf >/dev/null <<EOF
server {
    listen 80;
    server_name ${DOMAIN};

    client_max_body_size 200m;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location /ws/live {
        proxy_pass http://127.0.0.1:8080/ws/live;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
    }
}
EOF

sudo nginx -t
sudo systemctl reload nginx

sudo certbot --nginx -d "${DOMAIN}" --redirect -m "${EMAIL}" --agree-tos -n
sudo certbot renew --dry-run

echo "HTTPS is ready: https://${DOMAIN}"
