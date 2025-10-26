#!/bin/bash

# === Konfigurasi ===
bash app/surpress.sh
bash database/surpress.sh

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
echo "🌐 Menguji akses ke http://surpress.sdnpengasinan7.sch.id ..."
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://surpress.sdnpengasinan7.sch.id)

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "✅ Akses berhasil: Surpress aktif dan merespons dengan kode 200."
else
    echo "❌ Akses gagal: Surpress merespons dengan kode $HTTP_STATUS."
fi

echo "🎉 Restore lengkap: Aplikasi + Database Surpress selesai.🥳"
