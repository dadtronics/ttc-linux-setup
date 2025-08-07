# Tamriel Trade Centre Linux Setup

This repository provides scripts and a desktop launcher to automate the update and management of the Tamriel Trade Centre (TTC) add-on for Elder Scrolls Online on Linux (Steam/Proton).

## Contents

- `setup.sh` — Installs the desktop launcher, icon, and copies scripts to the correct locations.
- `ttc-client.desktop` — Desktop launcher for running the TTC updater in a terminal.
- `ttc.png` — Icon for the desktop launcher.
- `Scripts/5-min-loop.sh` — Main auto-updater script. Checks for and downloads the latest TTC PriceTable every 5 minutes, updating your ESO add-on folder.
- `Scripts/one-time.sh` — Runs a single update of the TTC PriceTable and updates your ESO add-on folder.

## Usage

### 1. Setup
Run the setup script to install the launcher, icon, and scripts:

```bash
bash setup.sh
```

This will:
- Copy `ttc.png` to `$HOME/.local/share/icons/ttc.png`
- Copy `ttc-client.desktop` to `$HOME/.local/share/applications/`
- Copy both scripts to your ESO add-on Scripts folder
- Run `kbuildsycoca6` if you are on KDE6 (to refresh the application menu)

### 2. Running the Updater

#### Desktop Launcher
After running `setup.sh`, you can launch the TTC updater from your desktop environment's application menu as **TTC Client**. This will open a terminal and run the auto-updater.

#### Manually via Terminal

- **Auto-updater (every 5 minutes):**
  ```bash
  bash Scripts/5-min-loop.sh
  ```
- **One-time update:**
  ```bash
  bash Scripts/one-time.sh
  ```

## What Each Script Does

### `Scripts/5-min-loop.sh`
- Runs in a loop, checking for and downloading the latest TTC PriceTable every 5 minutes.
- Extracts and copies the data to your ESO add-on folder.
- Cleans up temporary files after each update.
- Shows a countdown and status in the terminal.

### `Scripts/one-time.sh`
- Performs a single update of the TTC PriceTable.
- Extracts and copies the data to your ESO add-on folder.
- Cleans up temporary files after the update.

## Requirements
- Bash shell
- `curl`, `unzip`, and `rsync` installed
- Steam with Elder Scrolls Online installed via Proton

## Troubleshooting
- Ensure all scripts are executable: `chmod +x Scripts/*.sh setup.sh`
- If the desktop launcher does not appear, make sure you ran `setup.sh` and that your desktop environment supports `.desktop` files.
- If you encounter path errors, edit the `USER_PATH` variable at the top of the scripts to match your system.

---

**Created by APHONIC**
