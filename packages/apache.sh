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
<VirtualHost *:8085>
    ServerName sdnpengasinan7.sch.id
    ServerAlias www.sdnpengasinan7.sch.id

    DocumentRoot /var/www/html/main-web

    <Directory /var/www/html/main-web>
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

# === Buat konfigurasi virtual host Bit & Bait ===
echo "🛠️ Membuat konfigurasi virtual host bitdanbait.web.id..."
sudo tee /etc/apache2/sites-available/bitdanbait.conf > /dev/null <<EOF
<VirtualHost *:8082>
    ServerName bitdanbait.web.id
    DocumentRoot /var/www/html/bitdanbait/public

    <Directory /var/www/html/bitdanbait/public>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/bitdanbait_error.log
    CustomLog \${APACHE_LOG_DIR}/bitdanbait_access.log combined
</VirtualHost>
EOF

# === Buat konfigurasi virtual host Bit & Bait ===
echo "🛠️ Membuat konfigurasi virtual host cms.bitdanbait.web.id..."
sudo tee /etc/apache2/sites-available/cms-bitdanbait.conf > /dev/null <<EOF
<VirtualHost *:8083>
    ServerName cms.bitdanbait.web.id
    DocumentRoot /var/www/html/bitdanbait/cms

    <Directory /var/www/html/bitdanbait/cms>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/cms_bitdanbait_error.log
    CustomLog \${APACHE_LOG_DIR}/cms_bitdanbait_access.log combined
</VirtualHost>
EOF

# === Buat konfigurasi virtual host CMS SDN Pengasinan 7 ===
echo "🛠️ Membuat konfigurasi virtual host cms.sdnpengasinan7.sch.id..."
sudo tee /etc/apache2/sites-available/pengasinan7.conf > /dev/null <<EOF
<VirtualHost *:8090>
    ServerName cms.sdnpengasinan7.sch.id
    DocumentRoot /var/www/html/sdnpengasinan7/cms

    <Directory /var/www/html/sdnpengasinan7/cms>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/cms_sdnpengasinan7_error.log
    CustomLog \${APACHE_LOG_DIR}/cms_sdnpengasinan7_access.log combined
</VirtualHost>

EOF


# === Aktifkan konfigurasi virtual host dan nonaktifkan default ===
echo "🔧 Mengaktifkan konfigurasi virtual host..."
sudo a2ensite sdnpengasinan7.conf
sudo a2ensite surpress.conf
sudo a2ensite bitdanbait.conf
sudo a2ensite server-status.conf
sudo a2ensite cms-bitdanbait.conf
sudo a2ensite cms-pengasinan7.conf
sudo a2dissite 000-default.conf

# === Aktifkan mod_rewrite ===
echo "🔄 Mengaktifkan mod_rewrite..."
sudo a2enmod rewrite

# === Tambahkan port 8082 sd. 8091 ke Apache ===
echo "🔌 Menambahkan Listen 8082 sampai dengan 8091 ke Apache..."
sudo sed -i '/^Listen 80$/a Listen 8082\nListen 8083\nListen 8084\nListen 8085\nListen 8086\nListen 8087\nListen 8088\nListen 8089\nListen 8090\nListen 8091' /etc/apache2/ports.conf

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
  "bitdanbait.web.id"
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
