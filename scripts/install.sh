#!/bin/bash

# Clipboard Manager — macOS Installer
# Installs the app as a LaunchAgent so it runs automatically at login.

set -e  # exit on any error

# Variables
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
NOCOLOR='\033[0m'

# Common functions
print_step() {
    echo -e "\n${BOLD}▶ $1${NOCOLOR}";
}

print_ok() {
    echo -e "${GREEN}  ✔ $1${NOCOLOR}";
}

print_warn() {
    echo -e "${YELLOW}  ⚠ $1${NOCOLOR}";
}

print_error() {
    echo -e "${RED}  ✖ $1${NOCOLOR}";
}

# Header
echo ""
echo -e "${BOLD}------------------------------------${NOCOLOR}"
echo -e "${BOLD}   $APP_NAME - Installer${NOCOLOR}"
echo -e "${BOLD}------------------------------------${NOCOLOR}"

# Step 1: Find binary of Clipdock
print_step "Searching binary for Clipdock..."

# This binary file should be in same folder where this script exists
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BINARY_PATH="$SCRIPT_DIR/$BINARY_NAME"

if [ ! -f "$BINARY_PATH" ]; then
    print_error "Binary '$BINARY_NAME' not found"
    print_error "Expected at: $BINARY_PATH"
    exit 1
fi
print_ok "Found binary at: $BINARY_PATH"


# Step 2: Copy binary to /usr/local/bin
print_step "Installing binary to $INSTALL_DIR..."

# /usr/local/bin may need sudo
if [ ! -w "$INSTALL_DIR" ]; then
    print_warn "Need sudo to copy to $INSTALL_DIR"
    sudo cp "$BINARY_PATH" "$INSTALL_DIR/$BINARY_NAME"
    sudo chmod +x "$INSTALL_DIR/$BINARY_NAME"
else
    cp "$BINARY_PATH" "$INSTALL_DIR/$BINARY_NAME"
    chmod +x "$INSTALL_DIR/$BINARY_NAME"
fi
print_ok "Binary installed to $INSTALL_DIR/$BINARY_NAME"


# Step 3: Create LaunchAgents dir
print_step "Setting up LaunchAgent..."

mkdir -p "$PLIST_DIR"
mkdir -p "$LOG_DIR"

# Step 4: Write the .plist file
cat > "$PLIST_FILE" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$APP_IDENTIFIER</string>

    <key>ProgramArguments</key>
    <array>
        <string>$INSTALL_DIR/$BINARY_NAME</string>
    </array>

    <!-- Auto-start at login -->
    <key>RunAtLoad</key>
    <true/>

    <!-- Restart if it crashes -->
    <key>KeepAlive</key>
    <true/>

    <!-- Logs -->
    <key>StandardOutPath</key>
    <string>$LOG_DIR/$BINARY_NAME.log</string>
    <key>StandardErrorPath</key>
    <string>$LOG_DIR/$BINARY_NAME-error.log</string>
</dict>
</plist>
EOF

print_ok "Plist created at: $PLIST_FILE"


# ── Step 5: Load the LaunchAgent ────────────
print_step "Starting the service..."

# Unload first if already registered (safe, ignore errors)
launchctl unload "$PLIST_FILE" 2>/dev/null || true

# Load and start it now
launchctl load "$PLIST_FILE"
print_ok "Service started and registered for auto-start at login"


# ── Done ─────────────────────────────────────
echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}${BOLD}  ✔ $APP_NAME installed successfully!${NC}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "  The app is now running in the background."
echo "  Look for the icon in your menu bar."
echo ""
echo "  Logs: $LOG_DIR/$BINARY_NAME.log"
echo ""
echo "  To uninstall, run: ./uninstall.sh"
echo ""
