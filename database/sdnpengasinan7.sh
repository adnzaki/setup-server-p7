#!/bin/bash

# === Konfigurasi ===
MEGA_EMAIL="sdnpengasinantujuh@gmail.com"
MEGA_PASS="@pgn7_2021@"
MYSQL_PASS="sekolahkita99"
DB_BACKUP_ROOT="/backup-sdnpengasinan7/database"

# === Login ke MEGA ===
mega-login "$MEGA_EMAIL" "$MEGA_PASS"

# === Ambil folder backup database terbaru berdasarkan nama ===
LATEST_FOLDER=$(mega-ls "$DB_BACKUP_ROOT" | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' | sort | tail -n 1)

if [ -z "$LATEST_FOLDER" ]; then
    echo "❌ Tidak ditemukan folder backup dengan format tanggal."
    exit 1
fi

echo "📂 Folder backup terbaru: $LATEST_FOLDER"

# === Ambil file ZIP database terbaru ===
DB_ZIP_FILE=$(mega-ls "$DB_BACKUP_ROOT/${LATEST_FOLDER}" | grep '.zip' | sort | tail -n 1)

if [ -z "$DB_ZIP_FILE" ]; then
    echo "❌ File ZIP database tidak ditemukan."
    exit 1
fi

echo "📥 Mengunduh file ZIP database: $DB_ZIP_FILE"
mega-get "$DB_BACKUP_ROOT/${LATEST_FOLDER}/${DB_ZIP_FILE}" /tmp/

# === Ekstrak dan cari file .sql ===
unzip "/tmp/${DB_ZIP_FILE}" -d /tmp/
SQL_FILE=$(unzip -l "/tmp/${DB_ZIP_FILE}" | awk '/.sql$/ {print $NF}' | head -n 1)

if [ -z "$SQL_FILE" ]; then
    echo "❌ File .sql tidak ditemukan dalam ZIP."
    exit 1
fi

# === Restore Database ===
echo "🧠 Memulai proses restore database sdnpengasinan7..."

DB_EXIST=$(mysql -uroot -p"$MYSQL_PASS" -e "SHOW DATABASES LIKE 'pengasinan7';" | grep pengasinan7)

if [ -z "$DB_EXIST" ]; then
    echo "📦 Database 'pengasinan7' belum ada. Membuat database..."
    mysql -uroot -p"$MYSQL_PASS" -e "CREATE DATABASE pengasinan7;"
else
    echo "✅ Database 'pengasinan7' sudah ada."
fi

TABLE_COUNT=$(mysql -uroot -p"$MYSQL_PASS" -Dpengasinan7 -e "SHOW TABLES;" | wc -l)

if [ "$TABLE_COUNT" -gt 1 ]; then
    echo "⚠️ Database 'pengasinan7' sudah berisi tabel. Menghapus semua tabel..."
    TABLES=$(mysql -uroot -p"$MYSQL_PASS" -Dpengasinan7 -e "SHOW TABLES;" | awk 'NR>1' | paste -sd "," -)
    mysql -uroot -p"$MYSQL_PASS" -Dpengasinan7 -e "SET FOREIGN_KEY_CHECKS = 0; DROP TABLE IF EXISTS $TABLES; SET FOREIGN_KEY_CHECKS = 1;"
else
    echo "✅ Database 'pengasinan7' kosong. Siap restore."
fi

mysql -uroot -p"$MYSQL_PASS" pengasinan7 < "/tmp/${SQL_FILE}"
echo "✅ Database SDN Pengasinan 7 berhasil direstore dari ${SQL_FILE}"

rm "/tmp/${DB_ZIP_FILE}"
rm "/tmp/${SQL_FILE}"
