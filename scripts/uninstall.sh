#!/bin/bash

#  Clipboard Manager — Uninstaller
#  Stops the service and removes everything.

set -e

APP_NAME="Clipdock"
APP_IDENTIFIER="com.rajpatel.clipdock"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="clipdock"
PLIST_DIR="$HOME/Library/LaunchAgents"
PLIST_FILE="$PLIST_DIR/$APP_IDENTIFIER.plist"
LOG_DIR="$HOME/Library/Logs"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

print_step()  { echo -e "\n${BOLD}▶ $1${NC}"; }
print_ok()    { echo -e "${GREEN}  ✔ $1${NC}"; }
print_warn()  { echo -e "${YELLOW}  ⚠ $1${NC}"; }

# Header
echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}   $APP_NAME — Uninstaller${NC}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Confirm
echo ""
read -p "  Are you sure you want to uninstall $APP_NAME? [y/N] " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "  Cancelled."
    exit 0
fi

# Step 1: Stop and unload LaunchAgent─
print_step "Stopping the service..."

if [ -f "$PLIST_FILE" ]; then
    launchctl unload "$PLIST_FILE" 2>/dev/null || true
    print_ok "Service stopped"
else
    print_warn "No LaunchAgent plist found — maybe already uninstalled"
fi

# Step 2: Remove the plist─
print_step "Removing LaunchAgent plist..."

if [ -f "$PLIST_FILE" ]; then
    rm "$PLIST_FILE"
    print_ok "Removed: $PLIST_FILE"
else
    print_warn "Plist not found, skipping"
fi

# Step 3: Remove the binary
print_step "Removing binary..."

BINARY_FULL_PATH="$INSTALL_DIR/$BINARY_NAME"
if [ -f "$BINARY_FULL_PATH" ]; then
    if [ ! -w "$INSTALL_DIR" ]; then
        print_warn "Need sudo to remove from $INSTALL_DIR"
        sudo rm "$BINARY_FULL_PATH"
    else
        rm "$BINARY_FULL_PATH"
    fi
    print_ok "Removed: $BINARY_FULL_PATH"
else
    print_warn "Binary not found at $BINARY_FULL_PATH, skipping"
fi

# Step 4: Optionally remove logs─
print_step "Cleaning up logs..."

echo ""
read -p "  Remove log files too? [y/N] " remove_logs
if [[ "$remove_logs" == "y" || "$remove_logs" == "Y" ]]; then
    rm -f "$LOG_DIR/$BINARY_NAME.log"
    rm -f "$LOG_DIR/$BINARY_NAME-error.log"
    print_ok "Logs removed"
else
    print_warn "Logs kept at: $LOG_DIR/"
fi

# Done─
echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}${BOLD}  ✔ $APP_NAME uninstalled successfully!${NC}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
