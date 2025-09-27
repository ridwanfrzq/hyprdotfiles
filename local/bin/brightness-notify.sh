#!/bin/bash

# ambil brightness sekarang (pakai brightnessctl)
BRIGHT=$(brightnessctl get)
MAX=$(brightnessctl max)

# hitung persen brightness
PERCENT=$(( BRIGHT * 100 / MAX ))

# tampilkan notifikasi pakai dunst
notify-send -r 2 -t 2000 -h string:x-dunst-stack-tag:brightness \
    "󰃠 Brightness: ${PERCENT}%" \
    -h int:value:$PERCENT

