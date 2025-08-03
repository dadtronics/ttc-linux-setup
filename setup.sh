#!/bin/bash
# filepath: /home/aaron/ttc-linux-setup/setup.sh

# Set variables
ICON_SRC="ttc.png"
ICON_DEST="$HOME/.local/share/icons/ttc.png"
DESKTOP_SRC="ttc-client.desktop"
DESKTOP_DEST="$HOME/.local/share/applications/ttc-client.desktop"
SCRIPTS_SRC_DIR="Scripts"
SCRIPTS_DEST_DIR="$HOME/.steam/steam/steamapps/compatdata/306130/pfx/drive_c/users/steamuser/Documents/Elder Scrolls Online/live/AddOns/TamrielTradeCentre/Scripts"

# Create destination directories if they don't exist
mkdir -p "$(dirname "$ICON_DEST")"
mkdir -p "$(dirname "$DESKTOP_DEST")"
mkdir -p "$SCRIPTS_DEST_DIR"

# Copy icon
cp "$ICON_SRC" "$ICON_DEST"

# Copy .desktop file
cp "$DESKTOP_SRC" "$DESKTOP_DEST"

# Copy scripts
cp "$SCRIPTS_SRC_DIR/5-min-loop.sh" "$SCRIPTS_DEST_DIR/"
cp "$SCRIPTS_SRC_DIR/one-time.sh" "$SCRIPTS_DEST_DIR/"

# Run kbuildsycoca6 if KDE6 is detected
if command -v kbuildsycoca6 &> /dev/null; then
    kbuildsycoca6
    echo "KDE6 detected: ran kbuildsycoca6."
else
    echo "KDE6 not detected: skipped kbuildsycoca6."
fi

echo "Setup complete."