#!/usr/bin/env bash
set -euo pipefail

PROTON_DIR="$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton10-10"
PROTON_PREFIX="$HOME/.local/share/ttc-client"
INSTALLER="./TTCClientSetup.exe"

if [[ ! -f "$INSTALLER" ]]; then
  echo "[!] Please manually download TTCClientSetup.exe from:"
  echo "    https://tamrieltradecentre.com/help/AddonAndClient"
  echo "And place it in this directory before continuing."
  exit 1
fi

mkdir -p "$PROTON_PREFIX"

echo "[+] Installing TTC client with Proton..."
"$PROTON_DIR/proton" run --prefix="$PROTON_PREFIX" "$INSTALLER"

# Link AddOn data
ESO_PREFIX="$HOME/.steam/steam/steamapps/compatdata/306130/pfx"
ESO_DOCS="$ESO_PREFIX/drive_c/users/steamuser/Documents/Elder Scrolls Online/live"
TTC_DOCS="$PROTON_PREFIX/drive_c/users/steamuser/Documents/Elder Scrolls Online"

mkdir -p "$TTC_DOCS"
ln -sf "$ESO_DOCS" "$TTC_DOCS/live"

echo "[+] Setup complete."