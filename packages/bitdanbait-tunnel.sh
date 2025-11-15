#!/bin/bash

# === CONFIG ===
TUNNEL_NAME="bitdanbait-tunnel"
TUNNEL_UUID="ab591b51-ee7c-4525-9d25-e92e9f7750d1"
DOMAIN1="bitdanbait.web.id"
DOMAIN2="cms.bitdanbait.web.id"
DOMAIN3="photos.bitdanbait.web.id"
PORT1="8082"
PORT2="8083"
PORT3="8285"
CONFIG_DIR="/etc/cloudflared-bitdanbait"
SERVICE_NAME="cloudflared-bitdanbait"

# === STEP 0: Ambil user aktif ===
USER_NAME="$(logname 2>/dev/null || echo $USER)"
CREDENTIALS_FILE="/home/${USER_NAME}/.cloudflared/${TUNNEL_UUID}.json"

# Validasi user
if ! id "$USER_NAME" &>/dev/null; then
  echo "[ERROR] User '$USER_NAME' tidak ditemukan di sistem."
  exit 1
fi

# === STEP 1: Install cloudflared jika belum ada ===
if ! command -v cloudflared &> /dev/null; then
  echo "[INFO] Menginstal cloudflared..."
  curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o cloudflared
  sudo mv cloudflared /usr/bin/cloudflared
  sudo chmod +x /usr/bin/cloudflared
fi

# === STEP 2: Autentikasi ke Cloudflare ===
echo "[INFO] Autentikasi ke Cloudflare..."
cloudflared login

# === STEP 3: Buat file credential ===
echo "[INFO] Menulis credential file ke ${CREDENTIALS_FILE}"
mkdir -p "$(dirname "${CREDENTIALS_FILE}")"
tee "${CREDENTIALS_FILE}" > /dev/null <<EOF
{
  "AccountTag": "16917dc5f09ffe994d7118ada14bfc47",
  "TunnelSecret": "GyL1OjvfSPs5QZfeHSncdotkxN1x5DFlwjF4CjdEmSk=",
  "TunnelID": "ab591b51-ee7c-4525-9d25-e92e9f7750d1",
  "Endpoint": ""
}
EOF
chmod 600 "${CREDENTIALS_FILE}"
chown "${USER_NAME}:${USER_NAME}" "${CREDENTIALS_FILE}"


# === STEP 4: Tulis config.yml ===
echo "[INFO] Menulis config ke ${CONFIG_DIR}/config.yml"
sudo mkdir -p "${CONFIG_DIR}"
sudo tee "${CONFIG_DIR}/config.yml" > /dev/null <<EOF
tunnel: ${TUNNEL_UUID}
credentials-file: ${CREDENTIALS_FILE}

ingress:
  - hostname: ${DOMAIN1}
    service: http://localhost:${PORT1}

  - hostname: ${DOMAIN2}
    service: http://localhost:${PORT2}

  - hostname: ${DOMAIN3}
    service: http://localhost:${PORT3}

  - service: http_status:404
EOF

# === STEP 5: Buat systemd service ===
echo "[INFO] Membuat systemd service: ${SERVICE_NAME}"
sudo tee /etc/systemd/system/${SERVICE_NAME}.service > /dev/null <<EOF
[Unit]
Description=Cloudflare Tunnel untuk ${DOMAIN1} dan ${DOMAIN2}
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/cloudflared --no-autoupdate --config ${CONFIG_DIR}/config.yml tunnel run
Restart=on-failure
User=${USER_NAME}

[Install]
WantedBy=multi-user.target
EOF

# === STEP 6: Aktifkan dan jalankan service ===
echo "[INFO] Mengaktifkan dan menjalankan service..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable ${SERVICE_NAME}
sudo systemctl start ${SERVICE_NAME}

echo "[SUCCESS] Tunnel berhasil disiapkan untuk:"
echo "→ ${DOMAIN1} → localhost:${PORT1}"
echo "→ ${DOMAIN2} → localhost:${PORT2}"
echo "→ Config: ${CONFIG_DIR}/config.yml"
echo "→ Service: ${SERVICE_NAME} (User: ${USER_NAME})"