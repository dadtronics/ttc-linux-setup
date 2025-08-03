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
    echo -e "${BG_GREEN}Date of usage: $(date '+%m %B %d [%A], %Y')${RESET}"
    echo -e "${BG_BLUE}Time of usage (24h): $(date '+%T')${RESET}"
    echo -e "${BG_BLUE}Time of usage (12h): $(date '+%r')${RESET}"
    echo
}

print_footer() {
    echo
    echo -e "${BG_RED}End of Script...${RESET}"
    echo -e "${GREEN}Goodbye and thank you for using this script!${RESET}"
    echo -e "${BLUE}[https://github.com/MissAphonic/Linux-Tamriel-Trade-Center]${RESET}"
    echo -en "\033]0;Script created by APHONIC\a"
}

update_ttc_data() {
    echo -e "${BG_RED}${BOLD}${BLUE}Initializing${RESET}"
    sleep 2
    
    echo -e "${BG_GREEN}Starting TTC Update...${RESET}"
    sleep 1
    
    # Create download directory and navigate to it
    mkdir -p "$DOWNLOAD_PATH"
    cd "$DOWNLOAD_PATH" || {
        echo -e "${RED}✗ Failed to access downloads directory${RESET}"
        return 1
    }
    
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
    
    # Cleanup temporary files
    echo -e "${BG_RED}Removing temporary files...${RESET}"
    
    # Remove specific language files
    cd "$DOWNLOAD_PATH/PriceTable" || return 1
    rm -f ItemLookUpTable_*.lua PriceTable.lua
    
    # Return to downloads and remove temp directories
    cd "$DOWNLOAD_PATH" || return 1
    rm -rf PriceTable PriceTable.zip
    
    echo -e "${GREEN}${CHECK_MARK} Temporary files removed${RESET}"
    return 0
}

# Main execution
main() {
    # Set terminal title
    echo -en "\033]0;TTC One-Time Updater\a"
    
    # Show loading animation
    printf 'Loading TTC Updater '
    spinner &
    sleep 3
    kill "$!" 2>/dev/null
    printf '\n'
    clear
    
    # Print header info
    print_header
    
    # Verify paths exist
    if [ ! -d "$STEAM_PATH" ]; then
        echo -e "${RED}Error: Steam path not found at $STEAM_PATH${RESET}"
        echo -e "${YELLOW}Please edit the USER_PATH variable in the script${RESET}"
        exit 1
    fi
    
    # Run the update process
    if update_ttc_data; then
        echo -e "${GREEN}${CHECK_MARK} TTC update completed successfully!${RESET}"
        
        # Termination sequence
        echo -e "${BG_RED}Terminating process...${RESET}"
        sleep 2
        clear
        
        # Show completion message
        print_footer
        sleep 3
    else
        echo -e "${RED}✗ TTC update failed${RESET}"
        echo -e "${YELLOW}Please check your internet connection and paths${RESET}"
        exit 1
    fi
}

# Error handling
trap 'echo -e "\n${YELLOW}Script interrupted by user${RESET}"; exit 0' INT TERM

# Start the script
main