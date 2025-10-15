#!/bin/bash

# 1. Login ke MEGA
mega-login sdnpengasinantujuh@gmail.com '@pgn7_2021@'

# 2. Tentukan tanggal hari ini sebagai folder backup
DATE_FOLDER=$(date +%Y-%m-%d)
BACKUP_PATH="/backup-surpress-full/${DATE_FOLDER}/surpress_full_${DATE_FOLDER}_03-00.tar.gz"

# 3. Hapus isi folder surpress
sudo rm -rf /var/www/html/surpress/*
echo "🧹 Folder /var/www/html/surpress dikosongkan."

# 4. Unduh file backup dari MEGA ke /tmp
mega-get "$BACKUP_PATH" /tmp/
echo "📦 File backup Surpress berhasil diunduh ke /tmp."

# 5. Ekstrak file ke direktori surpress
sudo tar -xzf /tmp/surpress_full_${DATE_FOLDER}_03-00.tar.gz -C /var/www/html/surpress
echo "📂 File Surpress berhasil diekstrak ke /var/www/html/surpress."

# 6. Set permission agar bisa diakses oleh Apache/Nginx
sudo chown -R www-data:www-data /var/www/html/surpress
sudo chmod -R 755 /var/www/html/surpress

# 7. Hapus file backup dari /tmp
echo "🗑️ Menghapus file backup Surpress dari /tmp."
sudo rm /tmp/surpress_full_${DATE_FOLDER}_03-00.tar.gz


# 8. Tes akses ke domain Surpress
echo "🌐 Menguji akses ke http://surpress.sdnpengasinan7.sch.id ..."
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://surpress.sdnpengasinan7.sch.id)

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "✅ Akses berhasil: Surpress aktif dan merespons dengan kode 200."
else
    echo "❌ Akses gagal: Surpress merespons dengan kode $HTTP_STATUS."
fi

echo "✅ Restore aplikasi Surpress selesai."