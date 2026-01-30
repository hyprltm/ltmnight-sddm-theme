#!/bin/bash
VERSION="1.2.1"
ARCHIVE_NAME="ltmnight-sddm-theme-v${VERSION}.tar.gz"

# Find the repo root
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
PROJECT_ROOT="$SCRIPT_DIR/../.."
cd "$PROJECT_ROOT" || exit 1

# Colors for a nicer output
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}:: Creating KDE Store Release: $ARCHIVE_NAME${NC}"

# Cleanup build_tmp even if something fails
trap 'rm -rf build_tmp' EXIT
rm -rf build_tmp
mkdir -p build_tmp/ltmnight-sddm-theme

# 1. Grab everything needed for the theme
cp -r Assets Backgrounds Components Themes i18n build_tmp/ltmnight-sddm-theme/

# 2. Grab core metadata and setup files
cp Main.qml metadata.desktop setup.sh LICENSE CHANGELOG.md build_tmp/ltmnight-sddm-theme/

# 3. Handle Previews
mkdir -p build_tmp/ltmnight-sddm-theme/Previews
cp Previews/ltmnight.png build_tmp/ltmnight-sddm-theme/Previews/

# 4. Create a "Lite" README for the archive (Offline-friendly)
cp README.md build_tmp/ltmnight-sddm-theme/README.md
LITE_README="build_tmp/ltmnight-sddm-theme/README.md"

echo "   Polishing the README for the archive..."

# Remove web-only badges from the top
sed -i '2,8d' "$LITE_README"

# Strip out the Previews section
sed -i '/## Previews/,/## Features/{/## Features/!d}' "$LITE_README"

# Transform HTML support badges into clean text links
sed -i 's|<a href="https://www.buymeacoffee.com/\([^"]*\)">.*</a>|* **Buy Me a Coffee**: https://www.buymeacoffee.com/\1|g' "$LITE_README"
sed -i 's|<a href="https://github.com/sponsors/\([^"]*\)">.*</a>|* **GitHub Sponsor**: https://github.com/sponsors/\1|g' "$LITE_README"

# Simplify Bitcoin section for the archive 
sed -i '/#### Bitcoin (BTC) Support/,/```text/ { /<img/d }' "$LITE_README"

# 5. Zipping it all up
cd build_tmp
tar -czf "../$ARCHIVE_NAME" ltmnight-sddm-theme
cd ..

echo -e "${GREEN}:: Done!${NC}"
echo "   File: $(pwd)/$ARCHIVE_NAME"
echo "   Size: $(du -h $ARCHIVE_NAME | cut -f1)"
echo "   Note: Archive generated with an offline-friendly README."
