#!/bin/bash

# === Konfigurasi dasar ===
SOURCE_DIR="/var/www/html/surpress"
TARGET_DIR="/var/www/html/surpress-offline"
ENV_FILE="$TARGET_DIR/.env"
APACHE_CONF="/etc/apache2/sites-available/surpress-offline.conf"
PORT="8925"
BASE_URL_ONLINE="https://surpress.sdnpengasinan7.sch.id/api/public/"
BASE_URL_OFFLINE="http://localhost:${PORT}/api/public/"

# Ambil IP lokal (IPv4 pertama yang bukan loopback)
IP_ADDRESS=$(hostname -I | awk '{print $1}')

echo "🌀 Mulai cloning Surpress ke versi offline..."

# 1. Copy folder
if [ -d "$TARGET_DIR" ]; then
    echo "⚠️ Folder $TARGET_DIR sudah ada. Menghapus dulu..."
    rm -rf "$TARGET_DIR"
fi

echo "📁 Menyalin folder dari $SOURCE_DIR ke $TARGET_DIR..."
cp -r "$SOURCE_DIR" "$TARGET_DIR"

# 2. Edit file .env
if [ -f "$ENV_FILE" ]; then
    echo "📝 Mengubah baseURL di file .env..."
    sed -i "s|$BASE_URL_ONLINE|$BASE_URL_OFFLINE|g" "$ENV_FILE"
else
    echo "❌ File .env tidak ditemukan di $TARGET_DIR"
    exit 1
fi

# 3. Buat konfigurasi Apache
echo "🌐 Membuat konfigurasi Apache di $APACHE_CONF..."
cat <<EOF > "$APACHE_CONF"
<VirtualHost *:${PORT}>

    DocumentRoot $TARGET_DIR

    <Directory $TARGET_DIR>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/surpress_offline_error.log
    CustomLog \${APACHE_LOG_DIR}/surpress_offline_access.log combined
</VirtualHost>
EOF

# 4. Tambahkan port ke Apache
if ! grep -q "Listen ${PORT}" /etc/apache2/ports.conf; then
    echo "🔧 Menambahkan Listen ${PORT} ke ports.conf..."
    echo "Listen ${PORT}" >> /etc/apache2/ports.conf
fi

# 5. Allow port via UFW
echo "🛡️ Mengizinkan port ${PORT} lewat UFW..."
ufw allow "${PORT}"

# 6. Aktifkan site dan restart Apache
echo "🚀 Mengaktifkan site dan restart Apache..."
a2ensite surpress-offline.conf
systemctl reload apache2

echo "✅ Surpress versi offline siap diakses di:"
echo "   👉 http://localhost:${PORT}"
echo "   👉 http://${IP_ADDRESS}:${PORT}"
