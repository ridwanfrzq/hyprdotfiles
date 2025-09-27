#!/bin/bash

# Lokasi folder wallpaper
DIR="$HOME/Pictures/Wallpapers"

# Pastikan swww sudah jalan
pgrep swww >/dev/null || swww init

# Fungsi untuk generate thumbnail jika belum ada
generate_thumbnails() {
    THUMB_DIR="$HOME/.cache/wallpaper-thumbnails"
    mkdir -p "$THUMB_DIR"

    for img in "$DIR"/*; do
        if [[ -f "$img" ]]; then
            filename=$(basename "$img")
            thumb_path="$THUMB_DIR/${filename}.thumb.jpg"

            # Generate thumbnail jika belum ada
            if [[ ! -f "$thumb_path" ]]; then
                convert "$img" -resize 300x200^ -gravity center -extent 300x200 "$thumb_path" 2>/dev/null
            fi
        fi
    done
}

# Generate thumbnails
generate_thumbnails

# Buat list wallpaper dengan format untuk rofi
get_wallpaper_list() {
    for img in "$DIR"/*; do
        if [[ -f "$img" ]]; then
            filename=$(basename "$img")
            # Format: filename\0icon\x1f/path/to/thumbnail
            echo -en "${filename}\0icon\x1f$HOME/.cache/wallpaper-thumbnails/${filename}.thumb.jpg\n"
        fi
    done
}

# Tampilkan rofi dengan preview
FILE=$(get_wallpaper_list | rofi -sort -dmenu \
    -p "Choose Wallpaper" \
    -theme-str 'window {width: 60%;}' \
    -theme-str 'listview {columns: 3; lines: 3;}' \
    -theme-str 'element {orientation: vertical;}' \
    -theme-str 'element-icon {size: 8em;}' \
    -theme-str 'element-text {horizontal-align: 0.5;}' \
    -show-icons \
    -icon-theme "hicolor")

# Kalau ada file terpilih, jalankan swww dan pywal
if [ -n "$FILE" ]; then
    swww img "$DIR/$FILE" \
        --transition-type any \
        --transition-step 255 \
        --transition-fps 60

    # Generate warna dengan pywal tanpa set wallpaper ulang
    wal -n -i "$DIR/$FILE" --backend haishoku
    ~/.local/bin/pywal2hypr.sh
    hyprctl reload
    pkill -SIGUSR2 waybar

    # Notifikasi sukses (opsional)
    #notify-send "Wallpaper Changed" "Applied: $FILE" -i "$HOME/.cache/wallpaper-thumbnails/${FILE}.thumb.jpg"
fi
