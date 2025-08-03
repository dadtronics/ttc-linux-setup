#!/usr/bin/env bash
set -euo pipefail

PROTON_DIR="$HOME/.local/share/Steam/compatibilitytools.d/GE-Proton10-10"
PROTON_PREFIX="$HOME/.local/share/ttc-client"
INSTALLER="./TTCClientSetup.exe"

# Required for Proton to run standalone
export STEAM_COMPAT_DATA_PATH="$PROTON_PREFIX"
export STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam/steam"

if [[ ! -f "$INSTALLER" ]]; then
  echo "[!] Please manually download TTCClientSetup.exe from:"
  echo "    https://tamrieltradecentre.com/help/AddonAndClient"
  echo "And place it in this directory before continuing."
  exit 1
fi

mkdir -p "$PROTON_PREFIX"

echo "[+] Installing TTC client with Proton..."
"$PROTON_DIR/proton" run "$INSTALLER"

# Link AddOn data
ESO_PREFIX="$HOME/.steam/steam/steamapps/compatdata/306130/pfx"
ESO_DOCS="$ESO_PREFIX/drive_c/users/steamuser/Documents/Elder Scrolls Online/live"
TTC_DOCS="$PROTON_PREFIX/drive_c/users/steamuser/Documents/Elder Scrolls Online"

mkdir -p "$TTC_DOCS"
ln -sf "$ESO_DOCS" "$TTC_DOCS/live"

echo "[+] Installing desktop entry..."

if [[ ! -f ttc-client.desktop ]]; then
  echo "[!] ttc-client.desktop not found in repo. Skipping desktop entry installation."
else
  echo "[+] Installing desktop entry..."
  install -Dm644 ttc-client.desktop "$HOME/.local/share/applications/ttc-client.desktop"
  chmod +x "$HOME/.local/share/applications/ttc-client.desktop"
  kbuildsycoca5 &>/dev/null || true
fi

echo "[+] Desktop entry installed. You should now see Tamriel Trade Centre in your application menu."


echo "[+] Setup complete."
