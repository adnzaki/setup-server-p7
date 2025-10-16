#!/bin/bash

# === 1. Install Apache ===
echo "📦 Menginstal Apache..."
sudo apt update
sudo apt install -y apache2

# === 2. Enable dan jalankan service Apache ===
echo "🚀 Menyalakan service Apache..."
sudo systemctl enable apache2
sudo systemctl start apache2

# === 3. Buat direktori aplikasi Surpress ===
echo "📁 Menyiapkan folder aplikasi Surpress..."
sudo mkdir -p /var/www/html/surpress

# === 4. Buat konfigurasi virtual host utama (sdnpengasinan7.sch.id) ===
echo "🛠️ Membuat konfigurasi virtual host utama..."
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

# === 5. Buat konfigurasi virtual host Surpress ===
echo "🛠️ Membuat konfigurasi virtual host Surpress..."
sudo tee /etc/apache2/sites-available/surpress.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName surpress.sdnpengasinan7.sch.id
    DocumentRoot /var/www/html/surpress

    <Directory /var/www/html/surpress>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/surpress_error.log
    CustomLog \${APACHE_LOG_DIR}/surpress_access.log combined
</VirtualHost>
EOF

# === 6. Aktifkan konfigurasi virtual host dan nonaktifkan default ===
echo "🔧 Mengaktifkan konfigurasi virtual host..."
sudo a2ensite sdnpengasinan7.conf
sudo a2ensite surpress.conf
sudo a2dissite 000-default.conf

# === 7. Aktifkan mod_rewrite untuk dukungan .htaccess ===
echo "🔄 Mengaktifkan mod_rewrite..."
sudo a2enmod rewrite

# === 8. Reload Apache untuk menerapkan semua konfigurasi ===
echo "🔁 Reload Apache..."
sudo systemctl reload apache2

echo "✅ Apache berhasil dikonfigurasi untuk Surpress dan domain utama."
