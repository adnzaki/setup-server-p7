#!/bin/bash

# === Konfigurasi ===
MEGA_EMAIL="sdnpengasinantujuh@gmail.com"
MEGA_PASS="@pgn7_2021@"
UPLOAD_DIR="/var/www/html/bitdanbait/cms/wp-content/uploads"
YEAR=$(date +"%Y")
MONTH=$(date +"%m")
BACKUP_PREFIX="/backup-bitdanbait/uploads/$YEAR/$MONTH"

# === Login ke MEGA ===
mega-login "$MEGA_EMAIL" "$MEGA_PASS"

# === Cek login ===
STATUS=$(mega-whoami 2>&1)
if [[ "$STATUS" == *"Not logged in"* ]]; then
    echo "❌ Gagal login ke MEGA."
    exit 1
fi

# === Ambil folder backup terbaru ===
LATEST_FOLDER=$(mega-ls "$BACKUP_PREFIX" | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' | sort | tail -n 1)
[ -z "$LATEST_FOLDER" ] && echo "❌ Tidak ada folder backup." && exit 1

# === Ambil file backup terbaru ===
BACKUP_FILE=$(mega-ls "$BACKUP_PREFIX/$LATEST_FOLDER" | sort | tail -n 1)
[ -z "$BACKUP_FILE" ] && echo "❌ Tidak ada file upload." && exit 1

echo "📦 Mengambil $BACKUP_FILE dari $LATEST_FOLDER..."

# Dapatkan user aktif (yang menjalankan skrip)
ACTIVE_USER=$(logname)
echo "🔍 Menambahkan user '$ACTIVE_USER' ke grup www-data..."
sudo usermod -aG www-data "$ACTIVE_USER"

# === Restore ke folder uploads bulan ini ===
TARGET_DIR="$UPLOAD_DIR/$YEAR/$MONTH"
mkdir -p "$TARGET_DIR"
mega-get "$BACKUP_PREFIX/$LATEST_FOLDER/$BACKUP_FILE" /tmp/
sudo tar -xzf "/tmp/$BACKUP_FILE" -C "$TARGET_DIR"

echo "🔧 Mengubah permission folder '$UPLOAD_DIR'..."z
sudo chown -R www-data:www-data "$TARGET_DIR"
sudo chmod -R 755 "$TARGET_DIR"
rm "/tmp/$BACKUP_FILE"
echo "✅ Uploads bulan $MONTH-$YEAR berhasil direstore ke $TARGET_DIR"
