#!/bin/bash

# === Load konfigurasi dari .env ===
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "❌ File .env tidak ditemukan."
    exit 1
fi

if [[ -z "$MEGA_EMAIL" || -z "$MEGA_PASS" ]]; then
    echo "❌ MEGA_EMAIL atau MEGA_PASS belum diatur di .env."
    exit 1
fi


# === Login ke MEGA ===
mega-logout 2>/dev/null
mega-login "$MEGA_EMAIL" "$MEGA_PASS"

# Tunggu hingga login selesai
for i in {1..10}; do
    STATUS=$(mega-whoami 2>&1)
    if [[ "$STATUS" != *"Not logged in"* ]]; then
        echo "✅ Login MEGA berhasil."
        break
    fi
    echo "⏳ Menunggu login MEGA selesai..."
    sleep 2
done

if [[ "$STATUS" == *"Not logged in"* ]]; then
    echo "❌ Gagal login ke MEGA setelah menunggu."
    exit 1
fi

# === Cari folder backup terbaru ===
LATEST_FOLDER=$(mega-ls "$APP_BACKUP_PREFIX" | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' | sort | tail -n 1)

if [ -z "$LATEST_FOLDER" ]; then
    echo "❌ Tidak ditemukan folder backup dengan format tanggal."
    exit 1
fi

echo "📂 Folder backup terbaru: $LATEST_FOLDER"

# === Tentukan file backup aplikasi ===
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
