#!/bin/bash

TARGET_DIR="/var/www/html/surpress"
ZIP_FILE="surpress.zip"

echo "🚀 Memulai deployment Surpress..."

# 1. Git fetch & pull
echo "🔄 Menarik update dari Git..."
cd "$TARGET_DIR" || { echo "❌ Gagal masuk ke $TARGET_DIR"; exit 1; }
git fetch && git pull

# 2. Hapus semua kecuali whitelist
echo "🧹 Menghapus file dan folder versi sebelumnya..."
find "$TARGET_DIR" -mindepth 1 ! -name '.git' ! -name 'api' ! -name 'app' ! -name '.htaccess' ! -name 'README.md' -exec rm -rf {} +

# 3. Unzip surpress.zip
if [ -f "$ZIP_FILE" ]; then
    echo "📦 Mengekstrak $ZIP_FILE..."
    unzip -o "$ZIP_FILE" -d "$TARGET_DIR"
    echo "🗑️ Menghapus $ZIP_FILE..."
    rm "$ZIP_FILE"
else
    echo "❌ File $ZIP_FILE tidak ditemukan!"
    exit 1
fi

echo "✅ Deploy selesai. Aplikasi Surpress telah diperbarui."