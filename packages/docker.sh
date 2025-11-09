#!/bin/bash

set -e

echo "🚀 Memulai instalasi Docker Engine + Compose v2..."

# 1. Hapus versi Docker lama (jika ada)
sudo apt remove -y docker docker-engine docker.io containerd runc || true

# 2. Update dan install dependensi
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

# 3. Tambahkan GPG key Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 4. Tambahkan repository Docker
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5. Update dan install Docker Engine + Compose plugin
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 6. Tambahkan user ke grup docker (opsional)
sudo usermod -aG docker $USER

# 7. Tes versi
echo "✅ Versi Docker:"
docker --version
echo "✅ Versi Docker Compose:"
docker compose version

echo "🎉 Instalasi selesai. Silakan logout dan login ulang agar grup docker aktif."