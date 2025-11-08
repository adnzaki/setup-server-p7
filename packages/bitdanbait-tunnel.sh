#!/bin/bash

# === CONFIG ===
TUNNEL_NAME="bitdanbait-tunnel"
TUNNEL_UUID="ab591b51-ee7c-4525-9d25-e92e9f7750d1"
DOMAIN1="bitdanbait.web.id"
DOMAIN2="cms.bitdanbait.web.id"
PORT1="8082"
PORT2="8083"
CONFIG_DIR="/etc/cloudflared-bitdanbait"
SERVICE_NAME="cloudflared-bitdanbait"
USER_NAME="admin1"
CREDENTIALS_FILE="/home/${USER_NAME}/.cloudflared/${TUNNEL_UUID}.json"

# === STEP 1: Install cloudflared if missing ===
if ! command -v cloudflared &> /dev/null; then
  echo "[INFO] Installing cloudflared..."
  curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o cloudflared
  sudo mv cloudflared /usr/bin/cloudflared
  sudo chmod +x /usr/bin/cloudflared
fi

# === STEP 2: Authenticate to Cloudflare ===
echo "[INFO] Authenticating to Cloudflare..."
cloudflared login

# === STEP 3: Create tunnel (if not exists) ===
EXISTING=$(cloudflared tunnel list | grep "${TUNNEL_UUID}")
if [ -z "$EXISTING" ]; then
  echo "[INFO] Creating tunnel: ${TUNNEL_NAME}"
  cloudflared tunnel create "${TUNNEL_NAME}"
else
  echo "[INFO] Tunnel already exists: ${TUNNEL_UUID}"
fi

# === STEP 4: Write config.yml ===
echo "[INFO] Writing config to ${CONFIG_DIR}/config.yml"
sudo mkdir -p "${CONFIG_DIR}"
sudo tee "${CONFIG_DIR}/config.yml" > /dev/null <<EOF
tunnel: ${TUNNEL_UUID}
credentials-file: ${CREDENTIALS_FILE}

ingress:
  - hostname: ${DOMAIN1}
    service: http://localhost:${PORT1}

  - hostname: ${DOMAIN2}
    service: http://localhost:${PORT2}

  - service: http_status:404
EOF

# === STEP 5: Create systemd service ===
echo "[INFO] Creating systemd service: ${SERVICE_NAME}"
sudo tee /etc/systemd/system/${SERVICE_NAME}.service > /dev/null <<EOF
[Unit]
Description=Cloudflare Tunnel for ${DOMAIN1} and ${DOMAIN2}
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/cloudflared --no-autoupdate --config ${CONFIG_DIR}/config.yml tunnel run
Restart=on-failure
User=${USER_NAME}

[Install]
WantedBy=multi-user.target
EOF

# === STEP 6: Enable and start service ===
echo "[INFO] Enabling and starting service..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable ${SERVICE_NAME}
sudo systemctl start ${SERVICE_NAME}

echo "[SUCCESS] Tunnel setup complete for:"
echo "→ ${DOMAIN1} → localhost:${PORT1}"
echo "→ ${DOMAIN2} → localhost:${PORT2}"
echo "→ Config: ${CONFIG_DIR}/config.yml"
echo "→ Service: ${SERVICE_NAME}"
