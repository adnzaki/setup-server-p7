#!/bin/bash

# Konfigurasi
BACKUP_DIR="/var/backups/nextcloud"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
FILENAME="db_nextcloud_${TIMESTAMP}.sql"
ZIPFILE="${FILENAME}.zip"
DATE_FOLDER=$(date +"%Y-%m-%d")

# Buat folder backup kalau belum ada
mkdir -p "$BACKUP_DIR"

echo "📦 Membuat backup database..."

# Dump isi database Nextcloud snap
# Gunakan mysqldump bawaan snap
sudo nextcloud.mysqldump --databases nextcloud > "$BACKUP_DIR/$FILENAME"

# Kompres hasil dump
zip -j "$BACKUP_DIR/$ZIPFILE" "$BACKUP_DIR/$FILENAME"
rm "$BACKUP_DIR/$FILENAME"

# Buat folder di MEGA kalau belum ada
mega-mkdir "/nextcloud/${DATE_FOLDER}"

# Upload ke MEGA
mega-put "$BACKUP_DIR/$ZIPFILE" "/nextcloud/${DATE_FOLDER}"

# Opsional: hapus file lokal setelah upload
rm "$BACKUP_DIR/$ZIPFILE"

echo "📦 Database berhasil diarsipkan dan diupload ke MEGA."
