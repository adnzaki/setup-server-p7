#!/bin/bash
echo "🛠️ Memulai instalasi kebutuhan server..."

echo "🚀 Memasang Apache2..."
bash apache.sh
echo "✅ Instalasi Apache2 selesai"

echo "🚀 Memasang Nginx..."
bash nginx.sh
echo "✅ Instalasi Nginx selesai"

echo "🚀 Memasang PHP..."
bash php.sh
echo "✅ Instalasi PHP selesai"

echo "🚀 Memasang MariaDB..."
bash mysql.sh
echo "✅ Instalasi MariaDB selesai"

echo "🚀 Memasang Tailscale..."
bash tailscale.sh
echo "✅ Instalasi Tailscale selesai"

echo "🚀 Memasang Control Panel..."
bash control-panel.sh
echo "✅ Instalasi Control Panel selesai"

echo "🚀 Memasang Cloudflare untuk keperluan tunnel..."
bash cloudflare.sh
echo "✅ Instalasi Cloudflare selesai"

echo "🚀 Memasang MEGA CLI..."
bash mega-cli.sh
echo "✅ Instalasi MEGA CLI selesai"


# ------ Cek status semua service
echo "😬😬😬 Cek status semua service..."
sudo systemctl status apache2
sudo systemctl status nginx
sudo systemctl status mariadb
sudo systemctl status tailscaled
sudo systemctl status tailscale

tailscale status
tailscale ip -4

echo "🎉🎉🎉 Instalasi selesai 😄😆"