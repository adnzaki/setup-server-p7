#!/bin/bash

# Konfigurasi
BACKUP_DIR="/var/backups/nextcloud"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
FILENAME="db_nextcloud_${TIMESTAMP}.sql"
ZIPFILE="${FILENAME}.zip"
DATE_FOLDER=$(date +"%Y-%m-%d")

# Buat folder backup kalau belum ada
mkdir -p "$BACKUP_DIR"

# Dump database Nextcloud snap
# Gunakan mysql-client bawaan snap dengan opsi -e untuk eksekusi query
sudo nextcloud.mysql-client -e "USE nextcloud; \
  SET autocommit=0; \
  FLUSH TABLES WITH READ LOCK; \
  SHOW MASTER STATUS; \
  EXIT;" >/dev/null

# Dump isi database
sudo nextcloud.mysqldump nextcloud > "$BACKUP_DIR/$FILENAME"

# Lepaskan lock
sudo nextcloud.mysql-client -e "UNLOCK TABLES;"

# Kompres hasil dump
zip -j "$BACKUP_DIR/$ZIPFILE" "$BACKUP_DIR/$FILENAME"
rm "$BACKUP_DIR/$FILENAME"

# Buat folder di MEGA kalau belum ada
mega-mkdir "/nextcloud/${DATE_FOLDER}"

# Upload ke MEGA
mega-put "$BACKUP_DIR/$ZIPFILE" "/nextcloud/${DATE_FOLDER}"

# Opsional: hapus file lokal setelah upload
rm "$BACKUP_DIR/$ZIPFILE"
