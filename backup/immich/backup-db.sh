#!/bin/bash

# === Konfigurasi ===
DB_NAME="immich"
DB_USER="postgres"
CONTAINER="immich_postgres"
MEGA_FOLDER="/immich/database"
DATE_FOLDER=$(date +"%Y-%m-%d")
MEGA_DEST_FOLDER="$MEGA_FOLDER/$DATE_FOLDER"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
BACKUP_FILE="immich_db_${TIMESTAMP}.sql"

mega-mkdir -p "$MEGA_DEST_FOLDER"

echo "📦 Membuat backup database..."

# === Dump database ===
docker exec "$CONTAINER" pg_dump -U "$DB_USER" "$DB_NAME" > "/tmp/$BACKUP_FILE"

# === Upload ke Mega ===
mega-put "/tmp/$BACKUP_FILE" "$MEGA_DEST_FOLDER"

# === Bersihkan file lokal ===
rm "/tmp/$BACKUP_FILE"

echo "📦 Database berhasil diarsipkan dan diupload ke MEGA."
