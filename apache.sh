#!/bin/bash

echo "📦 Menginstal Apache..."
sudo apt update
sudo apt install -y apache2

echo "🚀 Menyalakan dan mengaktifkan service Apache..."
sudo systemctl enable apache2
sudo systemctl start apache2

# === Validasi service aktif ===
if ! sudo systemctl is-active --quiet apache2; then
    echo "❌ Apache gagal dijalankan. Cek status dan log untuk detail."
    sudo systemctl status apache2 --no-pager
    exit 1
fi

# === Buat direktori aplikasi Surpress ===
echo "📁 Menyiapkan folder aplikasi Surpress..."
sudo mkdir -p /var/www/html/surpress

# === Buat konfigurasi virtual host utama ===
echo "🛠️ Membuat konfigurasi virtual host sdnpengasinan7.sch.id..."
sudo tee /etc/apache2/sites-available/sdnpengasinan7.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName sdnpengasinan7.sch.id
    ServerAlias www.sdnpengasinan7.sch.id

    DocumentRoot /var/www/html

    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# === Buat konfigurasi virtual host Surpress ===
echo "🛠️ Membuat konfigurasi virtual host surpress.sdnpengasinan7.sch.id..."
sudo tee /etc/apache2/sites-available/surpress.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName surpress.sdnpengasinan7.sch.id
    DocumentRoot /var/www/html/surpress

    <Directory /var/www/html/surpress>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>


    ErrorLog \${APACHE_LOG_DIR}/surpress_error.log
    CustomLog \${APACHE_LOG_DIR}/surpress_access.log combined
</VirtualHost>
EOF

# === Aktifkan konfigurasi virtual host dan nonaktifkan default ===
echo "🔧 Mengaktifkan konfigurasi virtual host..."
sudo a2ensite sdnpengasinan7.conf
sudo a2ensite surpress.conf
sudo a2dissite 000-default.conf

# === Aktifkan mod_rewrite ===
echo "🔄 Mengaktifkan mod_rewrite..."
sudo a2enmod rewrite

# === Validasi konfigurasi Apache ===
echo "🔍 Memeriksa validitas konfigurasi Apache..."
CONFIG_TEST=$(sudo apachectl configtest 2>&1)
if [[ "$CONFIG_TEST" == *"Syntax OK"* ]]; then
    echo "✅ Konfigurasi Apache valid."
else
    echo "❌ Konfigurasi Apache bermasalah:"
    echo "$CONFIG_TEST"
    exit 1
fi

# === Restart Apache ===
echo "🔁 Restart Apache..."
sudo systemctl restart apache2

# === Validasi service aktif setelah restart ===
if sudo systemctl is-active --quiet apache2; then
    echo "✅ Apache berhasil dijalankan ulang."
else
    echo "❌ Apache gagal dijalankan ulang. Cek status berikut:"
    sudo systemctl status apache2 --no-pager
    exit 1
fi

# === Tes konektivitas virtual host ===
echo "🌐 Menguji konektivitas virtual host..."

HOSTNAMES=(
  "sdnpengasinan7.sch.id"
  "surpress.sdnpengasinan7.sch.id"
)

for HOST in "${HOSTNAMES[@]}"; do
  echo "🔗 Tes akses ke http://$HOST ..."
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://$HOST)
  if [ "$STATUS" -eq 200 ]; then
    echo "✅ $HOST merespons dengan kode 200 (OK)"
  else
    echo "❌ $HOST gagal diakses (kode: $STATUS)"
  fi
done

echo ""
echo "🎯 Instalasi dan konfigurasi Apache selesai dengan validasi penuh."
