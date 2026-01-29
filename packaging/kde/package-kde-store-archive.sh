#!/bin/bash
VERSION="1.2.0"
ARCHIVE_NAME="ltmnight-sddm-theme-v${VERSION}.tar.gz"

# Find the repo root (we might be running from anywhere)
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
PROJECT_ROOT="$SCRIPT_DIR/../.."

# Jump to root
cd "$PROJECT_ROOT" || exit 1

# Colors
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}:: Creating KDE Store Release: $ARCHIVE_NAME${NC}"

# Clear previous builds
rm -f "$ARCHIVE_NAME"
rm -rf build_tmp

# Prepare staging area
mkdir -p build_tmp/ltmnight-sddm-theme

# Copy theme files
cp -r Assets \
      Backgrounds \
      Components \
      Themes \
      i18n \
      Main.qml \
      metadata.desktop \
      setup.sh \
      README.md \
      LICENSE \
      CHANGELOG.md \
      build_tmp/ltmnight-sddm-theme/

# Add previews (Image & Video)
mkdir -p build_tmp/ltmnight-sddm-theme/Previews
cp Previews/ltmnight.png Previews/ltmnight-shader.mp4 build_tmp/ltmnight-sddm-theme/Previews/

# Zipping it up (tar.gz)
cd build_tmp
tar -czf "../$ARCHIVE_NAME" ltmnight-sddm-theme
cd ..

# Trash the temp folder

echo -e "${GREEN}:: Done!${NC}"
echo "   File: $(pwd)/$ARCHIVE_NAME"
echo "   Size: $(du -h $ARCHIVE_NAME | cut -f1)"
echo "   Upload this file to pling.com / KDE Store."
