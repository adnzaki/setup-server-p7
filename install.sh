#!/bin/bash
echo "🛠️ Memulai instalasi kebutuhan server..."

echo "🚀 Memasang Apache2..."
bash packages/apache.sh
echo "✅ Instalasi Apache2 selesai"

echo "🚀 Memasang Nginx..."
bash packages/nginx.sh
echo "✅ Instalasi Nginx selesai"

echo "🚀 Memasang PHP..."
bash packages/php.sh
echo "✅ Instalasi PHP selesai"

echo "🚀 Memasang MariaDB..."
bash packages/mysql.sh
echo "✅ Instalasi MariaDB selesai"

echo "🚀 Memasang Tailscale..."
bash packages/tailscale.sh
echo "✅ Instalasi Tailscale selesai"

echo "🚀 Memasang Control Panel..."
bash packages/control-panel.sh
echo "✅ Instalasi Control Panel selesai"

echo "🚀 Memasang Cloudflare untuk keperluan tunnel..."
bash packages/cloudflare.sh
echo "✅ Instalasi Cloudflare selesai"

# echo "🚀 Mengonfigurasi tunnel untuk Bitdanbait..."
# bash packages/bitdanbait-tunnel.sh
# echo "✅ Konfigurasi tunnel untuk Bitdanbait selesai"

echo "🚀 Memasang MEGA CLI..."
bash packages/mega-cli.sh
echo "✅ Instalasi MEGA CLI selesai"

echo "🐎🦬🦌🦏 Memasang paket tambahan..."
sudo apt install ncdu

echo "⚾🥎🏀 Mengatur log-rotation untuk menghemat space..."
bash log-rotation.sh

# ------ Cek status semua service
echo "😬😬😬 Cek status semua service..."
sudo systemctl status apache2
sudo systemctl status nginx
sudo systemctl status mariadb
sudo systemctl status tailscaled.service
sudo systemctl status cloudflared

echo "🎉🎉🎉 Instalasi selesai 😄😆"