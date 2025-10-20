#!/bin/bash

MEGA_EMAIL="sdnpengasinantujuh@gmail.com"
MEGA_PASS="@pgn7_2021@"
APP_DIR="/var/www/html/surpress"
APP_BACKUP_PREFIX="/backup-surpress-full"

# === Login ke MEGA ===
mega-login "$MEGA_EMAIL" "$MEGA_PASS"

# === Ambil folder backup database terbaru berdasarkan nama ===
LATEST_FOLDER=$(mega-ls "$DB_BACKUP_ROOT" | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' | sort | tail -n 1)

if [ -z "$LATEST_FOLDER" ]; then
    echo "❌ Tidak ditemukan folder backup dengan format tanggal."
    exit 1
fi

echo "📂 Folder backup terbaru: $LATEST_FOLDER"

# === Tentukan path backup aplikasi dan database ===
APP_BACKUP_FILE=$(mega-ls "$APP_BACKUP_PREFIX/${LATEST_FOLDER}" | grep '.tar.gz' | head -n 1)

if [ -z "$APP_BACKUP_FILE" ]; then
    echo "❌ File backup aplikasi tidak ditemukan."
    exit 1
fi

# === Bersihkan folder aplikasi jika sudah berisi file ===
if [ "$(ls -A "$APP_DIR")" ]; then
    echo "⚠️ Folder $APP_DIR sudah berisi file. Menghapus sebelum restore..."
    sudo rm -rf "$APP_DIR"/*
else
    echo "✅ Folder $APP_DIR kosong. Siap restore."
fi

# === Unduh dan ekstrak file aplikasi ===
mega-get "$APP_BACKUP_PREFIX/${LATEST_FOLDER}/${APP_BACKUP_FILE}" /tmp/
echo "📦 File aplikasi Surpress berhasil diunduh."

sudo tar -xzf "/tmp/${APP_BACKUP_FILE}" -C "$APP_DIR"
echo "📂 File Surpress berhasil diekstrak ke $APP_DIR."

sudo chown -R www-data:www-data "$APP_DIR"
sudo chmod -R 755 "$APP_DIR"
rm "/tmp/${APP_BACKUP_FILE}"
echo "🗑️ File backup aplikasi dihapus dari /tmp."