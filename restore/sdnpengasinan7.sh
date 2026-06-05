#!/bin/bash

# === Restore Aplikasi dan Database Pengasinan7 ===
# kembali ke root dulu
cd ..
# === Restore Aplikasi Pengasinan7 ===
echo ""
echo "📦 Mempersiapkan proses restore..."

# === Restore Website Pengasinan7 ===
echo "🔁 Menjalankan restore: Entire Site..."
bash app/sdnpengasinan7.sh

# === Restore Database Pengasinan7 ===
bash database/sdnpengasinan7.sh
sudo systemctl restart apache2

# === Konfirmasi sebelum tes koneksi ===
echo ""
echo "⚠️ Pastikan Cloudflare Tunnel telah non-aktif pada server lain yang masih aktif agar pengujian koneksi diarahkan ke host saat ini."
read -p "Apakah anda yakin akan melanjutkan? [Y/n]: " confirm

case "$confirm" in
  [Yy]|[Yy][Ee][Ss]|"")
    echo "🟢 Melanjutkan pengujian koneksi..."
    ;;
  [Nn]|[Nn][Oo])
    echo "⛔ Operasi dibatalkan oleh pengguna."
    exit 1
    ;;
  *)
    echo "❓ Input tidak dikenali. Operasi dibatalkan untuk keamanan."
    exit 1
    ;;
esac

# === Tes akses website ===
echo "🌐 Menguji akses ke https://sdnpengasinan7.sch.id ..."
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://sdnpengasinan7.sch.id)

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "✅ Akses berhasil: SDN Pengasinan VII aktif dan merespons dengan kode 200."
else
    echo "❌ Akses gagal: SDN Pengasinan VII merespons dengan kode $HTTP_STATUS."
fi

echo "🎉 Restore lengkap: Aplikasi + Database SDN Pengasinan VII selesai.🥳"