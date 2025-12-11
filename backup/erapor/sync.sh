#!/bin/bash

# === Konfigurasi ===
SRC="/home/admin1/vms/Windows/"
DEST="/mnt/extdrive/vms/Windows/"
LOG="/home/admin1/vms/logs/windows.log"
MOUNTPOINT="/mnt/extdrive"

# === Validasi mount ===
if ! mountpoint -q "$MOUNTPOINT"; then
    echo "$(date '+%F %T') [ERROR] HDD eksternal tidak terdeteksi di $MOUNTPOINT" >> "$LOG"
    exit 1
fi

# === Jalankan rsync ===
rsync -av --delete "$SRC" "$DEST" >> "$LOG" 2>&1

# === Logging sukses/gagal ===
if [ $? -eq 0 ]; then
    echo "$(date '+%F %T') [OK] Sinkronisasi berhasil dari $SRC ke $DEST" >> "$LOG"
else
    echo "$(date '+%F %T') [FAIL] Sinkronisasi gagal" >> "$LOG"
fi
