#!/bin/bash

# === Konfigurasi ===
MEGA_EMAIL="sdnpengasinantujuh@gmail.com"
MEGA_PASS="@pgn7_2021@"
MYSQL_PASS="sekolahkita99"
APP_DIR="/var/www/html/surpress"
APP_BACKUP_PREFIX="/backup-surpress-full"
DB_BACKUP_ROOT="/backup-surpress"

# === Login ke MEGA ===
mega-login "$MEGA_EMAIL" "$MEGA_PASS"

# === Ambil folder backup database terbaru berdasarkan nama ===
LATEST_FOLDER=$(mega-ls "$DB_BACKUP_ROOT" | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' | sort | tail -n 1)

if [ -z "$LATEST_FOLDER" ]; then
    echo "❌ Tidak ditemukan folder backup dengan format tanggal."
    exit 1
fi

echo "📂 Folder backup terbaru: $LATEST_FOLDER"

# === Tentukan path backup aplikasi dan database ===
APP_BACKUP_FILE=$(mega-ls "$APP_BACKUP_PREFIX/${LATEST_FOLDER}" | grep '.tar.gz' | head -n 1)
DB_ZIP_FILE=$(mega-ls "$DB_BACKUP_ROOT/${LATEST_FOLDER}" | grep '.zip' | head -n 1)

if [ -z "$APP_BACKUP_FILE" ] || [ -z "$DB_ZIP_FILE" ]; then
    echo "❌ File backup aplikasi atau database tidak ditemukan."
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

# === Restore Database ===
echo "🧠 Memulai proses restore database Surpress..."

# Cek apakah database 'surpress' sudah ada
DB_EXIST=$(mysql -uroot -p"$MYSQL_PASS" -e "SHOW DATABASES LIKE 'surpress';" | grep surpress)

if [ -z "$DB_EXIST" ]; then
    echo "📦 Database 'surpress' belum ada. Membuat database..."
    mysql -uroot -p"$MYSQL_PASS" -e "CREATE DATABASE surpress;"
else
    echo "✅ Database 'surpress' sudah ada."
fi

# Cek apakah database sudah berisi tabel
TABLE_COUNT=$(mysql -uroot -p"$MYSQL_PASS" -Dsurpress -e "SHOW TABLES;" | wc -l)

if [ "$TABLE_COUNT" -gt 1 ]; then
    echo "⚠️ Database 'surpress' sudah berisi tabel. Menghapus semua tabel..."
    TABLES=$(mysql -uroot -p"$MYSQL_PASS" -Dsurpress -e "SHOW TABLES;" | awk 'NR>1' | paste -sd "," -)
    mysql -uroot -p"$MYSQL_PASS" -Dsurpress -e "SET FOREIGN_KEY_CHECKS = 0; DROP TABLE IF EXISTS $TABLES; SET FOREIGN_KEY_CHECKS = 1;"
else
    echo "✅ Database 'surpress' kosong. Siap restore."
fi

# === Unduh dan ekstrak file ZIP database ===
echo "📥 Mengunduh file ZIP database: $DB_ZIP_FILE"
mega-get "$DB_BACKUP_ROOT/${LATEST_FOLDER}/${DB_ZIP_FILE}" /tmp/

unzip "/tmp/${DB_ZIP_FILE}" -d /tmp/
SQL_FILE=$(unzip -l "/tmp/${DB_ZIP_FILE}" | awk '/.sql$/ {print $NF}' | head -n 1)

if [ -z "$SQL_FILE" ]; then
    echo "❌ File .sql tidak ditemukan dalam ZIP."
    exit 1
fi

# Import ke database
mysql -uroot -p"$MYSQL_PASS" surpress < "/tmp/${SQL_FILE}"
echo "✅ Database Surpress berhasil direstore dari ${SQL_FILE}"

# Bersihkan file ZIP dan SQL
rm "/tmp/${DB_ZIP_FILE}"
rm "/tmp/${SQL_FILE}"

# === Tes akses website ===
echo "🌐 Menguji akses ke http://surpress.sdnpengasinan7.sch.id ..."
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://surpress.sdnpengasinan7.sch.id)

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "✅ Akses berhasil: Surpress aktif dan merespons dengan kode 200."
else
    echo "❌ Akses gagal: Surpress merespons dengan kode $HTTP_STATUS."
fi

echo "🎉 Restore lengkap: Aplikasi + Database Surpress selesai.🥳"
