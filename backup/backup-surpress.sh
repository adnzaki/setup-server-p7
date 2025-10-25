#!/bin/bash

# Konfigurasi
DB_NAME="surpress"
DB_USER="root"
DB_PASS="sekolahkita99"
BACKUP_DIR="/var/backups/surpress"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
FILENAME="db_surpress_${TIMESTAMP}.sql"
ZIPFILE="${FILENAME}.zip"
DATE_FOLDER=$(date +"%Y-%m-%d")

# Buat folder backup kalau belum ada
mkdir -p "$BACKUP_DIR"

# Dump database
mysqldump -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$BACKUP_DIR/$FILENAME"

# Kompres
zip -j "$BACKUP_DIR/$ZIPFILE" "$BACKUP_DIR/$FILENAME"
rm "$BACKUP_DIR/$FILENAME"

# Buat folder di MEGA kalau belum ada
mega-mkdir "/backup-surpress/${DATE_FOLDER}"

# Upload ke MEGA
mega-put "$BACKUP_DIR/$ZIPFILE" "/backup-surpress/${DATE_FOLDER}"

# Opsional: hapus file lokal setelah upload
rm "$BACKUP_DIR/$ZIPFILE"