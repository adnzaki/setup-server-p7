#!/bin/bash

# Konfigurasi
APP_DIR="/var/www/html/bitdanbait"
BACKUP_ROOT="/var/backups/bitdanbait/full"
DATE_FOLDER=$(date +"%Y-%m-%d")
TIMESTAMP=$(date +"%H-%M")
ARCHIVE_NAME="bitdanbait_full_${DATE_FOLDER}_${TIMESTAMP}.tar.gz"
LOCAL_FOLDER="${BACKUP_ROOT}/${DATE_FOLDER}"

# Buat folder backup
mkdir -p "$LOCAL_FOLDER"

# Kompres seluruh aplikasi
tar --exclude='writable/session/*' -czf "$LOCAL_FOLDER/$ARCHIVE_NAME" -C "$APP_DIR" .

# Upload ke MEGA
mega-mkdir -p "/backup-bitdanbait/full/${DATE_FOLDER}"
mega-put -c "$LOCAL_FOLDER/$ARCHIVE_NAME" "/backup-bitdanbait/full/${DATE_FOLDER}"

# Hapus lokal
rm "$LOCAL_FOLDER/$ARCHIVE_NAME"
