#!/bin/bash

# Simpan file status
STATE_FILE="/tmp/wofi_state"

# Cek apakah ada wofi jalan
if pgrep -x "wofi" > /dev/null; then
    CURRENT=$(cat "$STATE_FILE" 2>/dev/null)
    if [ "$CURRENT" == "$1" ]; then
        # Kalau tombol sama ditekan lagi → tutup saja
        pkill -x wofi
        rm -f "$STATE_FILE"
        exit 0
    else
        # Kalau beda → kill dulu, nanti lanjut buka yang baru
        pkill -x wofi
        sleep 0.1
    fi
fi

# Jalankan sesuai argumen
if [ "$1" == "app" ]; then
    echo "app" > "$STATE_FILE"
    wofi --show drun --gtk-dark
elif [ "$1" == "wallpaper" ]; then
    echo "wallpaper" > "$STATE_FILE"
    ~/.local/bin/wallpaper_switcher.sh
fi

