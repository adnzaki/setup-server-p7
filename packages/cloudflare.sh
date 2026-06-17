#!/bin/bash

# === Tahap 0: Uninstall & Bersihkan Cloudflare Tunnel Sebelumnya ===

echo "🧹 Menghapus instalasi cloudflared dan konfigurasi lama..."

# 1. Stop dan disable service
sudo systemctl stop cloudflared
sudo systemctl disable cloudflared

# 2. Hapus service dari systemd
sudo rm -f /etc/systemd/system/cloudflared.service
sudo systemctl daemon-reload

# 3. Hapus binary dan paket
sudo apt purge -y cloudflared
sudo rm -f /usr/bin/cloudflared
sudo rm -f /usr/local/bin/cloudflared
sudo rm -f cloudflared.deb

# 4. Hapus konfigurasi dan credential
sudo rm -rf /etc/cloudflared

ACTIVE_USER=${SUDO_USER:-$(whoami)}
USER_HOME=$(eval echo "~$ACTIVE_USER")
sudo rm -rf "$USER_HOME/.cloudflared"

echo "✅ Cloudflared dan semua konfigurasi lama berhasil dihapus."

# === Tahap 1: Install cloudflared ===

sudo apt update
sudo apt install -y curl unzip
curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cloudflared.deb
sudo dpkg -i cloudflared.deb

# === Tahap 2: Setup credential dan konfigurasi ===

mkdir -p "$USER_HOME/.cloudflared"

CRED_FILE="$USER_HOME/.cloudflared/52b2a47a-0d9d-4b3a-80a9-0f270a86a262.json"
sudo tee "$CRED_FILE" > /dev/null <<EOF
{
  "AccountTag":"16917dc5f09ffe994d7118ada14bfc47",
  "TunnelSecret":"bzg8bdToU3e16JQR3zdUMY5ENyxXOMkQXpIFOEP5+os=",
  "TunnelID":"52b2a47a-0d9d-4b3a-80a9-0f270a86a262",
  "Endpoint":""
}
EOF

sudo mkdir -p /etc/cloudflared
sudo tee /etc/cloudflared/config.yml > /dev/null <<EOF
tunnel: 52b2a47a-0d9d-4b3a-80a9-0f270a86a262
credentials-file: $USER_HOME/.cloudflared/52b2a47a-0d9d-4b3a-80a9-0f270a86a262.json

ingress:
  - hostname: server-check.sdnpengasinan7.sch.id
    service: http://localhost:8091

  - hostname: rapor.sdnpengasinan7.sch.id
    service: http://100.119.100.15:8535
   
  - hostname: dapo.sdnpengasinan7.sch.id
    service: http://100.119.100.15:5774

  - hostname: rapor-bjr9.sdnpengasinan7.sch.id
    service: http://100.81.249.7:8535
    originRequest:
      noTLSVerify: true

  - hostname: cloud.sdnpengasinan7.sch.id
    service: http://localhost:8286

  - hostname: surpress.sdnpengasinan7.sch.id
    service: http://localhost:80
    originRequest:
      httpHostHeader: surpress.sdnpengasinan7.sch.id

  - hostname: siabsen.sdnpengasinan7.sch.id
    service: http://localhost:80
    originRequest:
      httpHostHeader: siabsen.sdnpengasinan7.sch.id

  - hostname: sdnpengasinan7.sch.id
    service: http://localhost:80

  - hostname: cms.sdnpengasinan7.sch.id
    service: http://localhost:8090

  - hostname: webmin.sdnpengasinan7.sch.id
    service: https://localhost:10000
    originRequest:
      noTLSVerify: true

  - hostname: cockpit.sdnpengasinan7.sch.id
    service: https://localhost:9090
    originRequest:
      noTLSVerify: true

  - hostname: absensi.sdnpengasinan7.sch.id
    service: http://localhost:8888

  - hostname: bitdanbait.web.id
    service: http://localhost:8082

  - hostname: cms.bitdanbait.web.id
    service: http://localhost:8083

  - hostname: photos.bitdanbait.web.id
    service: http://localhost:8285

  - service: http_status:404
EOF

sudo chown -R "$ACTIVE_USER":"$ACTIVE_USER" "$USER_HOME/.cloudflared"
sudo chmod 600 "$CRED_FILE"

# === Tahap 3: Setup dan aktifkan service ===

sudo cloudflared service install
sudo systemctl enable cloudflared
sudo systemctl restart cloudflared

echo "🚀 Cloudflare Tunnel berhasil diinstal dan dikonfigurasi ulang."

# === Tahap 4: Validasi Tunnel dan Hostname ===

echo ""
echo "🔍 Validasi status Cloudflare Tunnel dan konektivitas hostname..."

# 1. Cek status service
echo "🛠️ Status service cloudflared:"
sudo systemctl status cloudflared --no-pager | grep -E 'Active:|Loaded:'

# 2. Daftar hostname yang akan diuji
HOSTNAMES=(
  "surpress.sdnpengasinan7.sch.id"
  "sdnpengasinan7.sch.id"
  "webmin.sdnpengasinan7.sch.id"
  "cockpit.sdnpengasinan7.sch.id"
  "erapor.sdnpengasinan7.sch.id"
  "bitdanbait.web.id"
)

# 3. Tes koneksi ke masing-masing hostname
for HOST in "${HOSTNAMES[@]}"; do
  echo "🌐 Menguji akses ke https://$HOST ..."
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://$HOST)
  if [ "$STATUS" -eq 200 ]; then
    echo "✅ $HOST merespons dengan kode 200 (OK)"
  else
    echo "❌ $HOST gagal diakses (kode: $STATUS)"
  fi
done

echo ""
echo "🎯 Validasi selesai. Pastikan DNS dan konfigurasi tunnel sudah benar jika ada hostname yang gagal."
