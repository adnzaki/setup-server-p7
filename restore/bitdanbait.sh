#!/bin/bash

# === Restore Aplikasi dan Database Bitdanbait ===
# kembali ke root dulu
cd ..
# === Restore Aplikasi Bitdanbait ===
echo ""
echo "📦 Silakan pilih opsi restore aplikasi:"
echo "[1] Entire Site"
echo "[2] Entire Site without Wordpress Uploads"
echo "[3] Wordpress' uploads folder only"
read -p "Masukkan pilihan kamu [1/2/3]: " restore_choice

case "$restore_choice" in
  1)
    echo "🔁 Menjalankan restore: Entire Site..."
    bash app/bitdanbait.sh
    ;;
  2)
    echo "🔁 Menjalankan restore: Entire Site tanpa uploads..."
    bash app/bitdanbait-nouploads.sh
    ;;
  3)
    echo "🔁 Menjalankan restore: Uploads folder saja..."
    bash app/bitdanbait-uploads.sh
    ;;
  *)
    echo "❌ Pilihan tidak valid. Restore aplikasi dibatalkan."
    exit 1
    ;;
esac

# === Restore Database Bitdanbait ===
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