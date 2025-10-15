#!/bin/bash

# 1. Tambahkan repository PHP (jika ingin versi terbaru)
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update

# 2. Install PHP dan ekstensi umum
sudo apt install -y php php-cli php-common php-curl php-mbstring php-xml php-zip php-gd php-mysql php-intl php-bcmath php-soap php-readline php-opcache

# 3. Cek versi PHP dan ekstensi aktif
echo "Versi PHP yang terinstal:"
php -v
php -m