#!/bin/bash

# ambil volume sekarang (pakai wpctl bawaan PipeWire)
VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

# cek apakah mute
if [[ "$VOL" == *"[MUTED]"* ]]; then
    notify-send -h string:x-dunst-stack-tag:volume "󰖁 Muted" -h int:value:0
else
    # ambil angka volume (misalnya "Volume: 0.45" → 45%)
    PERCENT=$(echo "$VOL" | awk '{print int($2*100)}')
    notify-send -r 1 -t 2000 -h String:x-dunst-stack-tag:volume "󰕾 Volume: ${PERCENT}%" -h int:value:$PERCENT
fi
