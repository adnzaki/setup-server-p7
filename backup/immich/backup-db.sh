#!/bin/bash

# === Konfigurasi ===
DB_NAME="immich"
DB_USER="postgres"
CONTAINER="immich_postgres"
MEGA_FOLDER="/immich/database"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
BACKUP_FILE="immich_db_${TIMESTAMP}.sql"

# === Dump database ===
docker exec "$CONTAINER" pg_dump -U "$DB_USER" "$DB_NAME" > "/tmp/$BACKUP_FILE"

# === Upload ke Mega ===
megaput "/tmp/$BACKUP_FILE" --path "$MEGA_FOLDER"

# === Bersihkan file lokal ===
rm "/tmp/$BACKUP_FILE"
