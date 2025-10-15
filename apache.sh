#!/bin/bash

# 1. Install Apache
sudo apt update
sudo apt install -y apache2

# 2. Enable dan jalankan service Apache
sudo systemctl enable apache2
sudo systemctl start apache2

# 3. Buat direktori untuk surpress jika belum ada
sudo mkdir -p /var/www/html/surpress

# 4. Tambahkan file konfigurasi sdnpengasinan7.conf
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

# 5. Tambahkan file konfigurasi surpress.conf
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

# 6. Aktifkan kedua site
sudo a2ensite sdnpengasinan7.conf
sudo a2ensite surpress.conf

# 7. Aktifkan mod_rewrite (jika pakai .htaccess)
sudo a2enmod rewrite

# 8. Reload Apache untuk menerapkan konfigurasi
sudo systemctl reload apache2