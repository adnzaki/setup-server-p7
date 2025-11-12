#!/bin/bash

# Konfigurasi
APP_DIR="/var/www/html/bitdanbait"
BACKUP_ROOT="/var/backups/bitdanbait/nouploads"
DATE_FOLDER=$(date +"%Y-%m-%d")
TIMESTAMP=$(date +"%H-%M")
ARCHIVE_NAME="bitdanbait_nouploads_${DATE_FOLDER}_${TIMESTAMP}.tar.gz"
LOCAL_FOLDER="${BACKUP_ROOT}/${DATE_FOLDER}"

# Buat folder backup
mkdir -p "$LOCAL_FOLDER"

# Kompres tanpa folder uploads
tar --exclude='writable/session/*' \
    --exclude='cms/wp-content/uploads/*' \
    -czf "$LOCAL_FOLDER/$ARCHIVE_NAME" -C "$APP_DIR" .

# Upload ke MEGA
mega-mkdir "/backup-bitdanbait/nouploads/${DATE_FOLDER}"
mega-put "$LOCAL_FOLDER/$ARCHIVE_NAME" "/backup-bitdanbait/nouploads/${DATE_FOLDER}"

# Hapus lokal
rm "$LOCAL_FOLDER/$ARCHIVE_NAME"
