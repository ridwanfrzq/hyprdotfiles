#!/bin/bash

COLORS="$HOME/.cache/wal/colors"
OUT="$HOME/.cache/wal/colors-hyprland.conf"

# kalau file colors tidak ada, keluar
[ ! -f "$COLORS" ] && echo "File $COLORS tidak ditemukan" && exit 1

# kosongkan file output
> "$OUT"

i=0
while read -r line && [ $i -lt 16 ]; do
    # hapus tanda '#' dan jadikan uppercase
    hex="${line#\#}"
    hex="${hex^^}"

    # tambahkan alpha FF (full opacity)
    echo "\$color$i = rgba(${hex}FF)" >> "$OUT"

    i=$((i+1))
done < "$COLORS"
