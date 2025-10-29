#!/bin/bash

# Konfigurasi
APP_DIR="/var/www/html/bitdanbait"
BACKUP_ROOT="/var/backups/bitdanbait"
DATE_FOLDER=$(date +"%Y-%m-%d")
TIMESTAMP=$(date +"%H-%M")
ARCHIVE_NAME="bitdanbait_site_${DATE_FOLDER}_${TIMESTAMP}.tar.gz"
LOCAL_FOLDER="${BACKUP_ROOT}/${DATE_FOLDER}"

# Buat folder backup harian
mkdir -p "$LOCAL_FOLDER"

# Kompres seluruh aplikasi
tar --exclude='writable/session/*' -czf "$LOCAL_FOLDER/$ARCHIVE_NAME" -C "$APP_DIR" .


# Buat folder di MEGA kalau belum ada
mega-mkdir "/backup-bitdanbait/website/${DATE_FOLDER}"

# Upload ke MEGA
mega-put "$LOCAL_FOLDER/$ARCHIVE_NAME" "/backup-bitdanbait/website/${DATE_FOLDER}"

# Opsional: hapus file lokal setelah upload
rm "$LOCAL_FOLDER/$ARCHIVE_NAME"
