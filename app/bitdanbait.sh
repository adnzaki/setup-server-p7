#!/bin/bash

# === Konfigurasi ===
MEGA_EMAIL="sdnpengasinantujuh@gmail.com"
MEGA_PASS="@pgn7_2021@"
APP_DIR="/var/www/html/bitdanbait"
APP_BACKUP_PREFIX="/backup-bitdanbait/website"

# === Login ke MEGA ===
mega-login "$MEGA_EMAIL" "$MEGA_PASS"

# Tunggu hingga login selesai
STATUS=$(mega-whoami 2>&1)
if [[ "$STATUS" != *"Not logged in"* ]]; then
    echo "✅ Login MEGA berhasil."
else
    echo "⏳ Menunggu login MEGA selesai..."
    sleep 2
    STATUS=$(mega-whoami 2>&1)
    if [[ "$STATUS" == *"Not logged in"* ]]; then
        echo "❌ Gagal login ke MEGA setelah menunggu."
        exit 1
    fi
fi

# === Cari folder backup terbaru ===
LATEST_FOLDER=$(mega-ls "$APP_BACKUP_PREFIX" | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' | sort | tail -n 1)

if [ -z "$LATEST_FOLDER" ]; then
    echo "❌ Tidak ditemukan folder backup dengan format tanggal."
    exit 1
fi

echo "📂 Folder backup terbaru: $LATEST_FOLDER"

# === Cari file backup aplikasi terbaru ===
APP_BACKUP_FILE=$(mega-ls "$APP_BACKUP_PREFIX/${LATEST_FOLDER}" | grep 'bitdanbait_site_.*\.tar\.gz' | sort | tail -n 1)

if [ -z "$APP_BACKUP_FILE" ]; then
    echo "❌ File backup aplikasi tidak ditemukan."
    exit 1
fi

echo "📦 File backup ditemukan: $APP_BACKUP_FILE"

# === Bersihkan folder aplikasi jika sudah berisi file ===
if [ "$(ls -A "$APP_DIR")" ]; then
    echo "⚠️ Folder $APP_DIR sudah berisi file. Menghapus sebelum restore..."
    sudo rm -rf "$APP_DIR"/*
else
    echo "✅ Folder $APP_DIR kosong. Siap restore."
fi

# === Unduh dan ekstrak file aplikasi ===
mega-get "$APP_BACKUP_PREFIX/${LATEST_FOLDER}/${APP_BACKUP_FILE}" /tmp/
echo "📥 File Bitdanbait berhasil diunduh."

sudo tar -xzf "/tmp/${APP_BACKUP_FILE}" -C "$APP_DIR"
echo "📂 File Bitdanbait berhasil diekstrak ke $APP_DIR."

# === Set permission ===
sudo chown -R www-data:www-data "$APP_DIR"
sudo chmod -R 755 "$APP_DIR"

# === Bersihkan file sementara ===
rm "/tmp/${APP_BACKUP_FILE}"
echo "🗑️ File backup aplikasi dihapus dari /tmp."
