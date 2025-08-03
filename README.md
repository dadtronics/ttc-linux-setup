# Tamriel Trade Centre on Linux (with Proton)

This script sets up the Tamriel Trade Centre (TTC) Windows client for Elder Scrolls Online on Linux using **GE-Proton** from [ProtonUp-Qt](https://github.com/DavidoTek/ProtonUp-Qt).

## ✅ What This Does

- Creates a Proton prefix for the TTC client
- Installs the Windows TTC client
- Symlinks your ESO addon data so TTC sync works
- Optionally installs a `.desktop` launcher for your menu

## 📥 Prerequisite: Download the TTC Client Installer Manually

Due to Tamriel Trade Centre’s Terms of Service and browser-based download requirements, you must manually download the Windows installer before running the setup script:

1. Visit: [https://tamrieltradecentre.com/help/AddonAndClient](https://tamrieltradecentre.com/help/AddonAndClient)
2. Check the **“I agree”** box
3. Click the **Download** button
4. Save the file as `TTCClientSetup.exe` in the root of this repo (next to `setup.sh`)

Once the file is in place, you can run the installer script:

```bash
chmod +x setup.sh
./setup.sh
```

## 🚀 Requirements

- Steam installed with ESO via Proton
- [ProtonUp-Qt](https://github.com/DavidoTek/ProtonUp-Qt) with a GE-Proton version installed
- `wget`, `bash`, and optionally `protontricks` for fixes

## 🛠 Installation

```bash
git clone https://github.com/dadtronics/ttc-linux-setup.git
cd ttc-linux-setup
chmod +x setup.sh
./setup.sh
````

### Optional: Add Desktop Launcher

```bash
cp ttc-client.desktop ~/.local/share/applications/
```

Edit the `Exec=` line in `ttc-client.desktop` if you're using a different Proton version.

## 🧯 Troubleshooting

* If the app crashes, install dependencies:

```bash
protontricks --no-steam --proton -c ~/.local/share/Steam/compatibilitytools.d/GE-Proton10-10 \
  -p ~/.local/share/ttc-client dotnet48 ie8
```

* If it says no saved variables found, double-check your symlink path:

  * Should link to:
    `~/.steam/steam/steamapps/compatdata/306130/pfx/drive_c/users/steamuser/Documents/Elder Scrolls Online/live`

---

## 📝 Notes

This keeps your Steam Proton environment untouched and clean. TTC is installed in its own Proton prefix under `~/.local/share/ttc-client`.

Tested with `GE-Proton10-10`.

---

## 📎 Credits

* [TTC Client](https://tamrieltradecentre.com/help/AddonAndClient)
* [ESOUI Linux Guide](https://cdn.esoui.com/downloads/info3249-LinuxTamrielTradeCenter.html)