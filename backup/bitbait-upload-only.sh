#!/bin/bash

# Konfigurasi
APP_DIR="/var/www/html/bitdanbait/cms/wp-content/uploads"
BACKUP_ROOT="/var/backups/bitdanbait/uploads"
YEAR=$(date +"%Y")
MONTH=$(date +"%m")
DATE_FOLDER=$(date +"%Y-%m-%d")
TIMESTAMP=$(date +"%H-%M")
ARCHIVE_NAME="bitdanbait_uploads_${YEAR}_${MONTH}_${DATE_FOLDER}_${TIMESTAMP}.tar.gz"
LOCAL_FOLDER="${BACKUP_ROOT}/${DATE_FOLDER}"

# Buat folder backup
mkdir -p "$LOCAL_FOLDER"

# Kompres folder bulan saat ini
tar -czf "$LOCAL_FOLDER/$ARCHIVE_NAME" -C "$APP_DIR/$YEAR" "$MONTH"

# Upload ke MEGA
mega-mkdir -p "/backup-bitdanbait/uploads/${YEAR}/${MONTH}/${DATE_FOLDER}"
mega-put -c "$LOCAL_FOLDER/$ARCHIVE_NAME" "/backup-bitdanbait/uploads/${YEAR}/${MONTH}/${DATE_FOLDER}"

# Hapus lokal
rm "$LOCAL_FOLDER/$ARCHIVE_NAME"
