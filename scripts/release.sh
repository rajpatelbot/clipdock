#!/bin/bash

#  Clipboard Manager — Release Builder
#  Run this on YOUR machine to produce a distributable package for end users.

set -e

APP_NAME="Clipdock"
BINARY_NAME="clipdock"
VERSION="${1:-1.0.0}"
OUTPUT_DIR="./release"
PACKAGE_DIR="$OUTPUT_DIR/$APP_NAME-$VERSION-macOS"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

print_step() { echo -e "\n${BOLD}▶ $1${NC}"; }
print_ok()   { echo -e "${GREEN}  ✔ $1${NC}"; }
print_info() { echo -e "${YELLOW}  ℹ $1${NC}"; }
print_warn()  { echo -e "${YELLOW}  ⚠ $1${NC}"; }

# Header
echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}   $APP_NAME — Release Builder v$VERSION${NC}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Step 1: Clean output dir─
print_step "Cleaning previous release..."
rm -rf "$OUTPUT_DIR"
mkdir -p "$PACKAGE_DIR"
print_ok "Clean output dir: $PACKAGE_DIR"

# Step 2: Build the Go binary
print_step "Building Go binary for macOS..."

# Detect current architecture
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
    print_info "Detected Apple Silicon (arm64) — building natively..."
else
    print_info "Detected Intel (amd64) — building natively..."
fi

# Build natively (required for systray — uses CGO/Objective-C, can't cross-compile)
go build -ldflags="-s -w -X main.Version=$VERSION" -o "$PACKAGE_DIR/$BINARY_NAME" .

chmod +x "$PACKAGE_DIR/$BINARY_NAME"
print_ok "Binary built for $ARCH: $PACKAGE_DIR/$BINARY_NAME"
print_warn "Note: This binary only works on $ARCH Macs."
print_warn "To support both architectures, build on an Intel Mac too and combine with 'lipo'."

# Step 3: Copy installer scripts─
print_step "Copying installer scripts..."

cp ./scripts/install.sh   "$PACKAGE_DIR/install.sh"
cp ./scripts/uninstall.sh "$PACKAGE_DIR/uninstall.sh"
chmod +x "$PACKAGE_DIR/install.sh"
chmod +x "$PACKAGE_DIR/uninstall.sh"
print_ok "Scripts copied"

# Step 4: Write a README for the user
print_step "Writing README..."

cat > "$PACKAGE_DIR/README.txt" <<EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  $APP_NAME v$VERSION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

INSTALL
  1. Open Terminal
  2. Drag this folder into Terminal (or cd into it)
  3. Run: ./install.sh
  4. Done! The icon will appear in your menu bar.

UNINSTALL
  Run: ./uninstall.sh

The app starts automatically at login.
No manual setup required.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

print_ok "README written"

# Step 5: Zip it up
print_step "Creating distributable zip..."

cd "$OUTPUT_DIR"
zip -r "$APP_NAME-$VERSION-macOS.zip" "$APP_NAME-$VERSION-macOS/"
cd - > /dev/null

print_ok "Zip created: $OUTPUT_DIR/$APP_NAME-$VERSION-macOS.zip"

# Show final package contents
echo ""
print_step "Package contents:"
ls -lh "$PACKAGE_DIR/"

# Done─
echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}${BOLD}  ✔ Release ready!${NC}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "  Distribute this file:"
echo "  👉  $OUTPUT_DIR/$APP_NAME-$VERSION-macOS.zip"
echo ""
echo "  User just unzips and runs: ./install.sh"
echo ""
