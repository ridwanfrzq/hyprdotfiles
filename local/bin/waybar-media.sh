#!/bin/bash

status=$(playerctl status 2>/dev/null)

if [[ "$status" == "Playing" || "$status" == "Paused" ]]; then
    title=$(playerctl metadata title 2>/dev/null)
    artist=$(playerctl metadata artist 2>/dev/null)

    # gabungkan
    text="$artist - $title"

    # potong maksimal 28 karakter
    short_text=$(echo "$text" | cut -c1-28)

    # tambahkan "…" kalau panjang
    if [ ${#text} -gt 28 ]; then
        short_text="$short_text…"
    fi

    echo "{\"text\": \"󰝚  $short_text\", \"class\": \"media\"}"
else
    echo ""
fi

