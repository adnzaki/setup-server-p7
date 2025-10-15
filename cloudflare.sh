#!/bin/bash

# 1. Install cloudflared
sudo apt update
sudo apt install -y curl
curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cloudflared.deb
sudo dpkg -i cloudflared.deb

# 2. Buat folder credential di home user aktif
USER_HOME=$(eval echo "~$USER")
mkdir -p "$USER_HOME/.cloudflared"

# 3. Salin credential file
sudo tee "$USER_HOME/.cloudflared/52b2a47a-0d9d-4b3a-80a9-0f270a86a262.json" > /dev/null <<EOF
{
  "AccountTag":"16917dc5f09ffe994d7118ada14bfc47",
  "TunnelSecret":"bzg8bdToU3e16JQR3zdUMY5ENyxXOMkQXpIFOEP5+os=",
  "TunnelID":"52b2a47a-0d9d-4b3a-80a9-0f270a86a262",
  "Endpoint":""
}
EOF

# 4. Buat config.yml di /etc/cloudflared
sudo mkdir -p /etc/cloudflared
sudo tee /etc/cloudflared/config.yml > /dev/null <<EOF
tunnel: 52b2a47a-0d9d-4b3a-80a9-0f270a86a262
credentials-file: $USER_HOME/.cloudflared/52b2a47a-0d9d-4b3a-80a9-0f270a86a262.json

ingress:
  - hostname: surpress.sdnpengasinan7.sch.id
    service: http://localhost:80
    originRequest:
      httpHostHeader: surpress.sdnpengasinan7.sch.id

  - hostname: sdnpengasinan7.sch.id
    service: http://localhost:80

  - hostname: webmin.sdnpengasinan7.sch.id
    service: https://localhost:8080
    originRequest:
      noTLSVerify: true

  - hostname: cockpit.sdnpengasinan7.sch.id
    service: https://localhost:9090
    originRequest:
      noTLSVerify: true

  - hostname: erapor.sdnpengasinan7.sch.id
    service: http://localhost:8055

  - service: http_status:404
EOF

# 5. Set permission agar cloudflared bisa akses file
sudo chown -R $(whoami):$(whoami) "$USER_HOME/.cloudflared"
sudo chmod 600 "$USER_HOME/.cloudflared/52b2a47a-0d9d-4b3a-80a9-0f270a86a262.json"

# 6. Setup systemd service
sudo cloudflared service install

# 7. Start dan enable service
sudo systemctl enable cloudflared
sudo systemctl start cloudflared