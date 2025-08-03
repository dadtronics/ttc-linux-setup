#!/bin/bash

# Configuration - Edit these paths as needed
USER_PATH="$HOME"  # Change this to customize the user path
STEAM_PATH="$USER_PATH/.steam/steam"
ESO_ADDON_PATH="$STEAM_PATH/steamapps/compatdata/306130/pfx/drive_c/users/steamuser/My Documents/Elder Scrolls Online/live/AddOns/TamrielTradeCentre"
DOWNLOAD_PATH="$USER_PATH/Downloads"

# Colors and formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BG_GREEN='\033[0;102m'
BG_RED='\033[0;101m'
BG_BLUE='\033[0;104m'
BOLD='\033[1m'
RESET='\033[0m'
CHECK_MARK="\033[0;32m\xE2\x9C\x94\033[0m"

# Functions
spinner() {
    local i sp n
    sp='/-\|'
    n=${#sp}
    printf ' '
    while sleep 0.1; do
        printf "%s\b" "${sp:i++%n:1}"
    done
}

print_header() {
    echo -e "${GREEN}[Script created by APHONIC]${RESET}"
    echo -e "${BLUE}[https://github.com/MissAphonic/Linux-Tamriel-Trade-Center]${RESET}"
    echo
    echo -e "${BG_GREEN}Date of usage: $(date '+%m %B %d [%A], %Y')${RESET}"
    echo -e "${BG_BLUE}Time of usage (24h): $(date '+%T')${RESET}"
    echo -e "${BG_BLUE}Time of usage (12h): $(date '+%r')${RESET}"
    echo
}

update_ttc_data() {
    echo -e "${BG_RED}${BOLD}${BLUE}Initializing${RESET}"
    sleep 2
    
    echo -e "${BG_GREEN}Starting TTC Update Sequence...${RESET}"
    sleep 1
    
    # Create download directory
    mkdir -p "$DOWNLOAD_PATH"
    cd "$DOWNLOAD_PATH" || exit 1
    
    # Download PriceTable
    echo -e "${BG_RED}Downloading PriceTable...${RESET}"
    if curl -o "$DOWNLOAD_PATH/PriceTable.zip" 'https://us.tamrieltradecentre.com/download/PriceTable'; then
        echo -e "${GREEN}${CHECK_MARK} PriceTable Downloaded${RESET}"
    else
        echo -e "${RED}✗ Failed to download PriceTable${RESET}"
        return 1
    fi
    
    # Extract PriceTable
    echo -e "${BG_RED}Unzipping PriceTable...${RESET}"
    if unzip -o "$DOWNLOAD_PATH/PriceTable.zip" -d "$DOWNLOAD_PATH/PriceTable"; then
        echo -e "${GREEN}${CHECK_MARK} PriceTable Unzipped${RESET}"
    else
        echo -e "${RED}✗ Failed to unzip PriceTable${RESET}"
        return 1
    fi
    
    # Update ESO addon
    echo -e "${BG_RED}Updating ESO TTC AddOn data...${RESET}"
    mkdir -p "$ESO_ADDON_PATH"
    
    if rsync -auvzhP "$DOWNLOAD_PATH/PriceTable/" "$ESO_ADDON_PATH/"; then
        echo -e "${GREEN}${CHECK_MARK} Update completed successfully${RESET}"
    else
        echo -e "${RED}✗ Failed to update addon data${RESET}"
        return 1
    fi
    
    # Cleanup
    echo -e "${BG_RED}Removing temporary files...${RESET}"
    cd "$DOWNLOAD_PATH/PriceTable" || return 1
    rm -f ItemLookUpTable_*.lua PriceTable.lua
    cd "$DOWNLOAD_PATH" || return 1
    rm -rf PriceTable PriceTable.zip
    echo -e "${GREEN}${CHECK_MARK} Temporary files removed${RESET}"
    
    return 0
}

countdown_timer() {
    local minutes=${1:-5}  # Default 5 minutes
    local total_seconds=$((minutes * 60))
    
    echo -e "${BG_RED}Next update in:${RESET}"
    
    while [ $total_seconds -gt 0 ]; do
        local hours=$((total_seconds / 3600))
        local mins=$(((total_seconds % 3600) / 60))
        local secs=$((total_seconds % 60))
        
        printf "\r${BG_RED}${BOLD}${BLUE}Next update: %02d:%02d:%02d${RESET}" $hours $mins $secs
        sleep 1
        ((total_seconds--))
    done
    echo
}

# Main execution
main() {
    while true; do
        # Set terminal title
        echo -en "\033]0;TTC Auto-Updater\a"
        clear
        
        # Show loading animation
        printf 'Loading TTC Updater '
        spinner &
        sleep 3
        kill "$!" 2>/dev/null
        printf '\n'
        clear
        
        # Print header
        print_header
        
        # Update TTC data
        if update_ttc_data; then
            echo -e "${GREEN}${CHECK_MARK} TTC update cycle completed successfully${RESET}"
        else
            echo -e "${RED}✗ TTC update cycle failed${RESET}"
        fi
        
        echo
        echo -e "${YELLOW}Waiting 5 minutes before next update...${RESET}"
        echo -e "${CYAN}Press Ctrl+C to stop the updater${RESET}"
        echo
        
        # Countdown to next update
        countdown_timer 5
        
        clear
    done
}

# Error handling
trap 'echo -e "\n${YELLOW}TTC Updater stopped by user${RESET}"; exit 0' INT TERM

# Verify paths exist
if [ ! -d "$STEAM_PATH" ]; then
    echo -e "${RED}Error: Steam path not found at $STEAM_PATH${RESET}"
    echo -e "${YELLOW}Please edit the USER_PATH variable in the script${RESET}"
    exit 1
fi

# Start the main loop
main