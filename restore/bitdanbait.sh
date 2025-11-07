#!/bin/bash

# === Restore Aplikasi dan Database Bitdanbait ===
cd ..
bash app/bitdanbait.sh
bash database/bitdanbait.sh
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
echo "🌐 Menguji akses ke https://bitdanbait.web.id ..."
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://bitdanbait.web.id)

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "✅ Akses berhasil: Bitdanbait aktif dan merespons dengan kode 200."
else
    echo "❌ Akses gagal: Bitdanbait merespons dengan kode $HTTP_STATUS."
fi

echo "🎉 Restore lengkap: Aplikasi + Database Bitdanbait selesai.🥳"
