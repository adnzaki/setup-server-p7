# 2. Tentukan user aktif dan buat folder credential
ACTIVE_USER=${SUDO_USER:-$(whoami)}
USER_HOME=$(eval echo "~$ACTIVE_USER")
mkdir -p "$USER_HOME/.cloudflared"

# 3. Salin credential file
CRED_FILE="$USER_HOME/.cloudflared/52b2a47a-0d9d-4b3a-80a9-0f270a86a262.json"
sudo tee "$CRED_FILE" > /dev/null <<EOF
{
  "AccountTag":"16917dc5f09ffe994d7118ada14bfc47",
  "TunnelSecret":"bzg8bdToU3e16JQR3zdUMY5ENyxXOMkQXpIFOEP5+os=",
  "TunnelID":"52b2a47a-0d9d-4b3a-80a9-0f270a86a262",
  "Endpoint":""
}
EOF

# Validasi file credential
if [ ! -f "$CRED_FILE" ]; then
    echo "❌ Gagal membuat file credential di $CRED_FILE"
    exit 1
fi

# 4. Buat config.yml
sudo mkdir -p /etc/cloudflared
sudo tee /etc/cloudflared/config.yml > /dev/null <<EOF
tunnel: 52b2a47a-0d9d-4b3a-80a9-0f270a86a262
credentials-file: $CRED_FILE

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

# 5. Set permission
sudo chown -R "$ACTIVE_USER":"$ACTIVE_USER" "$USER_HOME/.cloudflared"
sudo chmod 600 "$CRED_FILE"

# 6. Setup dan restart service
sudo cloudflared service install
sudo systemctl enable cloudflared
sudo systemctl restart cloudflared
