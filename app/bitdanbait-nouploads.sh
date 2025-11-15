#!/bin/bash

# === Konfigurasi ===
MEGA_EMAIL="sdnpengasinantujuh@gmail.com"
MEGA_PASS="@pgn7_2021@"
APP_DIR="/var/www/html/bitdanbait"
BACKUP_PREFIX="/backup-bitdanbait/nouploads"

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
[ -z "$BACKUP_FILE" ] && echo "❌ Tidak ada file backup." && exit 1

echo "📦 Mengambil $BACKUP_FILE dari $LATEST_FOLDER..."

# === Bersihkan dan restore ===
sudo rm -rf "$APP_DIR"/*
mega-get "$BACKUP_PREFIX/$LATEST_FOLDER/$BACKUP_FILE" /tmp/
sudo tar -xzf "/tmp/$BACKUP_FILE" -C "$APP_DIR"
sudo chown -R www-data:www-data "$APP_DIR"
sudo chmod -R 755 "$APP_DIR"
rm "/tmp/$BACKUP_FILE"
echo "✅ Restore selesai ke $APP_DIR"
