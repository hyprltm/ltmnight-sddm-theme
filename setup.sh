#!/bin/bash
set -e

THEME_NAME="ltmnight"
THEME_DIR="/usr/share/sddm/themes/$THEME_NAME"
VERSION="1.2.0"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m'

show_help() {
    echo "LTMNight SDDM Theme Installer"
    echo ""
    echo "Usage: ./setup.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help      Show this help message"
    echo "  -v, --version   Show version"
    echo "  --no-deps       Skip dependency installation"
    echo ""
    echo "One-liner:"
    echo "  curl -sSL https://raw.githubusercontent.com/hyprltm/ltmnight-sddm-theme/main/setup.sh | sudo bash"
}

print_banner() {
    echo -e "${PURPLE}"
    echo "    __  ________  ____   ___       __    __ "
    echo "   / / /_  __/  |/  / | / (_)___ _/ /_  / /_"
    echo "  / /   / / / /|_/ /  |/ / / __ \`/ __ \/ __/"
    echo " / /___/ / / /  / / /|  / / /_/ / / / / /_  "
    echo "/_____/_/ /_/  /_/_/ |_/_/\__, /_/ /_/\__/  "
    echo "                         /____/             "
    echo -e "${NC}"
    echo -e "${BLUE}:: LTMNight SDDM Theme v${VERSION}${NC}"
}

SKIP_DEPS=false
for arg in "$@"; do
    case $arg in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--version)
            echo "ltmnight-sddm-theme v${VERSION}"
            exit 0
            ;;
        --no-deps)
            SKIP_DEPS=true
            ;;
    esac
done

print_banner

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run as root (sudo).${NC}"
    exit 1
fi

install_deps() {
    echo -e ":: Checking dependencies..."
    
    if [ -f /etc/arch-release ]; then
        echo -e ":: Arch Linux detected"
        pacman -S --needed --noconfirm sddm qt6-declarative qt6-svg qt6-virtualkeyboard ttf-jetbrains-mono git
    elif [ -f /etc/fedora-release ]; then
        echo -e ":: Fedora detected"
        dnf install -y sddm qt6-qtdeclarative qt6-qtsvg qt6-qtvirtualkeyboard jetbrains-mono-fonts git
    elif [ -f /etc/debian_version ]; then
        echo -e ":: Debian/Ubuntu detected"
        apt update
        apt install -y sddm qml6-module-qtquick-controls qml6-module-qtquick-layouts qml6-module-qtqml-workerscript qml6-module-qtquick-templates qml6-module-qtquick-virtualkeyboard libqt6svg6 fonts-jetbrains-mono git
    elif [ -f /etc/os-release ] && grep -q "openSUSE" /etc/os-release; then
        echo -e ":: openSUSE detected"
        zypper install -y sddm libQt6Core6 libQt6Gui6 libQt6Quick6 libQt6QuickControls2-6 libQt6Svg6 libQt6Sql6 qt6-virtualkeyboard jetbrains-mono-fonts git
    else
        echo -e "${RED}Unsupported distro. Install dependencies manually: Qt6, SDDM, JetBrains Mono.${NC}"
    fi
}

if [ "$SKIP_DEPS" = false ]; then
    install_deps
fi

# Determine run mode
REAL_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$REAL_PATH")

if [ "$SCRIPT_DIR" == "$THEME_DIR" ]; then
    echo -e ":: Running in Configurator Mode"
    IS_INSTALLED=true
else
    IS_INSTALLED=false
fi

if [ "$IS_INSTALLED" = false ]; then
    if [ -f "Main.qml" ]; then
        echo -e ":: Local install"
        SOURCE_DIR="."
    else
        echo -e ":: Cloning repository..."
        TEMP_DIR=$(mktemp -d)
        git clone --depth 1 https://github.com/hyprltm/ltmnight-sddm-theme.git "$TEMP_DIR"
        SOURCE_DIR="$TEMP_DIR"
        trap 'rm -rf "$TEMP_DIR"' EXIT
    fi

    if [ -d "$THEME_DIR" ]; then
        echo -e ":: Removing old installation..."
        rm -rf "$THEME_DIR"
    fi

    echo -e ":: Installing to $THEME_DIR..."
    mkdir -p "$THEME_DIR"
    cp -r "$SOURCE_DIR/Assets" \
          "$SOURCE_DIR/Backgrounds" \
          "$SOURCE_DIR/Components" \
          "$SOURCE_DIR/Themes" \
          "$SOURCE_DIR/i18n" \
          "$SOURCE_DIR/Main.qml" \
          "$SOURCE_DIR/metadata.desktop" \
          "$SOURCE_DIR/setup.sh" \
          "$THEME_DIR/"
    
    chmod +x "$THEME_DIR/setup.sh"
fi

if [ ! -f "$THEME_DIR/Main.qml" ]; then
    echo -e "${RED}Installation failed.${NC}"
    exit 1
fi

echo
read -p ":: Apply theme to sddm.conf? [y/N] " -n 1 -r < /dev/tty
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    mkdir -p "/etc/sddm.conf.d"
    echo -e "[Theme]\nCurrent=$THEME_NAME" > /etc/sddm.conf.d/theme.conf
    echo -e "${GREEN}:: Theme set in /etc/sddm.conf.d/theme.conf${NC}"
else
    echo -e ":: Skipped"
fi

echo
echo -e ":: Background selection:"
echo -e "   1) Static Image (Recommended for speed)"
echo -e "   2) Live Video"
echo -e "   3) Animated LTMNight Shader (GLSL)"
read -p ":: Select [1/2/3]: " -n 1 -r BG_CHOICE < /dev/tty
echo

USER_CONF="$THEME_DIR/Themes/hyprltm.conf.user"
# Reset user config and start [General] section
echo -e "[General]" > "$USER_CONF"

if [[ $BG_CHOICE =~ ^[2]$ ]]; then
    if [ -f "$THEME_DIR/Backgrounds/ltmnight.mp4" ]; then
        echo -e "Background=\"Backgrounds/ltmnight.mp4\"\nBackgroundSpeed=\"1.0\"" >> "$USER_CONF"
        echo -e "${GREEN}:: Live background enabled${NC}"
    else
        echo -e "${RED}:: Video file not found. Keeping static background.${NC}"
    fi
elif [[ $BG_CHOICE =~ ^[3]$ ]]; then
    echo -e "Background=\"ltmnight\"" >> "$USER_CONF"
    echo -e "${GREEN}:: LTMNight GLSL background enabled${NC}"
else
    echo -e ":: Static background kept (default)"
fi

echo
echo -e ":: Virtual keyboard setup:"
echo -e "   1) Disabled (no virtual keyboard)"
echo -e "   2) Manual only (toggle button, no auto-show)"
echo -e "   3) Touch/Tablet (auto-show on focus)"
read -p ":: Select [1/2/3]: " -n 1 -r VK_CHOICE < /dev/tty
echo

case $VK_CHOICE in
    2)
        mkdir -p "/etc/sddm.conf.d"
        echo -e "[General]\nInputMethod=qtvirtualkeyboard" > /etc/sddm.conf.d/virtualkeyboard.conf
        echo -e "HideVirtualKeyboard=\"false\"\nVirtualKeyboardAutoShow=\"false\"" >> "$USER_CONF"
        echo -e "${GREEN}:: Virtual keyboard: Manual mode enabled${NC}"
        ;;
    3)
        mkdir -p "/etc/sddm.conf.d"
        echo -e "[General]\nInputMethod=qtvirtualkeyboard" > /etc/sddm.conf.d/virtualkeyboard.conf
        echo -e "HideVirtualKeyboard=\"false\"\nVirtualKeyboardAutoShow=\"true\"" >> "$USER_CONF"
        echo -e "${GREEN}:: Virtual keyboard: Touch/Tablet mode enabled${NC}"
        ;;
    *)
        echo -e ":: Virtual keyboard disabled (default)"
        ;;
esac

echo -e "${GREEN}:: Done!${NC}"
echo -e ":: Test with: sddm-greeter-qt6 --test-mode --theme $THEME_DIR"
