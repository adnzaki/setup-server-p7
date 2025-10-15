#!/bin/bash

# 1. Install Nginx
sudo apt update
sudo apt install -y nginx

# 2. Enable dan jalankan service Nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# 3. Tambahkan file konfigurasi fingerprint
sudo tee /etc/nginx/sites-available/fingerprint > /dev/null <<EOF
server {
    listen 8888;
    server_name localhost;

    location / {
        proxy_pass http://192.168.1.200;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

# 4. Aktifkan konfigurasi fingerprint
sudo ln -s /etc/nginx/sites-available/fingerprint /etc/nginx/sites-enabled/fingerprint

# 5. Tes konfigurasi dan reload Nginx
sudo nginx -t && sudo systemctl reload nginx

# 6. Allow port 8888
sudo ufw allow 8888/tcp