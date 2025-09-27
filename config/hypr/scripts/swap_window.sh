#!/bin/bash

# Ambil ID window aktif
active=$(hyprctl activewindow -j | jq -r '.address')

# Ambil semua client
clients=$(hyprctl clients -j)

# Cari tetangga terdekat (berdasarkan posisi X)
neighbor=$(echo "$clients" | jq -r --arg active "$active" '
  map(select(.address != $active))        # semua selain window aktif
  | sort_by(.at[0])                       # urutkan berdasarkan posisi X (horizontal)
  | if length > 0 then .[0].address else empty end
')

# Kalau ketemu tetangga, swap
if [ -n "$neighbor" ]; then
  hyprctl dispatch swapwindow address:$neighbor
fi

