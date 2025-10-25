#!/bin/bash

# === Konfigurasi ===
bash surpress-app.sh
bash surpress-db.sh

# === Tes akses website ===
echo "🌐 Menguji akses ke http://surpress.sdnpengasinan7.sch.id ..."
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://surpress.sdnpengasinan7.sch.id)

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "✅ Akses berhasil: Surpress aktif dan merespons dengan kode 200."
else
    echo "❌ Akses gagal: Surpress merespons dengan kode $HTTP_STATUS."
fi

echo "🎉 Restore lengkap: Aplikasi + Database Surpress selesai.🥳"
