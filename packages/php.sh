#!/bin/bash

echo "📦 Menyiapkan repository PHP terbaru..."
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update

echo "🚀 Menginstal PHP 8.4 dan semua ekstensi penting untuk CodeIgniter 4..."
sudo apt install -y \
  php8.4 php8.4-cli php8.4-common php8.4-curl php8.4-mbstring php8.4-xml php8.4-zip \
  php8.4-gd php8.4-mysql php8.4-intl php8.4-bcmath php8.4-soap php8.4-readline php8.4-opcache \
  libapache2-mod-php8.4

echo "🔁 Restart Apache untuk menerapkan konfigurasi PHP..."
sudo systemctl restart apache2

echo "🔍 Validasi instalasi PHP dan modul aktif..."
echo "Versi PHP:"
php -v

echo "Modul PHP yang aktif:"
php -m | grep -E 'intl|mbstring|curl|mysql|xml|zip|gd|bcmath|soap|readline|opcache'

echo "✅ Instalasi PHP 8.4 dan integrasi Apache selesai."
