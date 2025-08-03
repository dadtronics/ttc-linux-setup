#!/usr/bin/env bash
set -euo pipefail

PROTON_DIR="$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton10-10"
PROTON_PREFIX="$HOME/.local/share/ttc-client"

mkdir -p "$PROTON_PREFIX"

echo "[+] Downloading TTC client..."
wget -O TTCClientSetup.exe "https://cdn.tamrieltradecentre.com/setup/TTCClientSetup.exe"

echo "[+] Installing TTC client with Proton..."
"$PROTON_DIR/proton" run --prefix="$PROTON_PREFIX" ./TTCClientSetup.exe

echo "[+] Linking ESO AddOn data..."
ESO_PREFIX="$HOME/.steam/steam/steamapps/compatdata/306130/pfx"
ESO_DOCS="$ESO_PREFIX/drive_c/users/steamuser/Documents/Elder Scrolls Online/live"
TTC_DOCS="$PROTON_PREFIX/drive_c/users/steamuser/Documents/Elder Scrolls Online"

mkdir -p "$TTC_DOCS"
ln -sf "$ESO_DOCS" "$TTC_DOCS/live"

echo "[+] Setup complete."