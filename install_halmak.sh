#!/bin/bash

# Define the paths
SYMBOLS_DIR="/usr/share/X11/xkb/symbols"
RULES_DIR="/usr/share/X11/xkb/rules"
HALMAK_DIR="$(dirname "$0")/halmak-linux"

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Use sudo to run it."
   exit 1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect the package manager
detect_package_manager() {
# Detecting Imutables
    if command_exists rpm-ostree; then
        echo "rpm-ostree"
    elif command_exists apx; then
        echo "apx"
# Detecting Declaratives
        elif [ -f /etc/NIXOS ]; then
        echo "nixos"
# Detecting deb
        elif command_exists apt-get; then
        echo "apt-get"
    elif command_exists apt; then
        echo "apt"
# Detecting rhel/fedora
    elif command_exists yum; then
        echo "yum"
    elif command_exists dnf; then
        echo "dnf"
    elif command_exists zypper; then
        echo "zypper"
# Detecting Arch Linux
    elif command_exists pacman; then
        echo "pacman"
    elif command_exsists paru; then
        echo "paru"
    elif comman_exisists yay; then
        echo "yay"
# Detecting Gentoo/Portage
    elif command_exists emerge; then
        echo "emerge"
# Detecting Guix
    elif command_exists guix; then
        echo "guix"
# Detecting Alpine Linux
    elif [ -f /etc/alpine-release ]; then
        echo "alpine"
    else
        echo "unknown"
    fi
}

# Detect the system type
package_manager=$(detect_package_manager)

if [[ "$package_manager" == "rpm-ostree" || "$package_manager" == "apx" || "$package_manager" == "nixos" ]]; then
    echo "Your distro is immutable or declarative. This script does not support it."
    exit 1
elif [[ "$package_manager" == "apt-get" || "$package_manager" == "apt" || "$package_manager" == "alpine" || "$package_manager" == "yum" || "$package_manager" == "dnf" || "$package_manager" == "zypper" || "$package_manager" == "pacman" || "$package_manager" == "paru" || "$package_manager" == "yay" || "$package_manager" == "emerge" || "$package_manager" == "guix" ]]; then
    # Copy zz to symbols directory
    echo "Copying zz to $SYMBOLS_DIR..."
    cp "$HALMAK_DIR/zz" "$SYMBOLS_DIR/"
    if [[ $? -ne 0 ]]; then
        echo "Failed to copy zz to $SYMBOLS_DIR"
        exit 1
    fi

    # Backup existing evdev.xml
    if [[ -f "$RULES_DIR/evdev.xml" ]]; then
        echo "Backing up existing evdev.xml to evdev.xml.bak..."
        cp "$RULES_DIR/evdev.xml" "$RULES_DIR/evdev.xml.bak"
        if [[ $? -ne 0 ]]; then
            echo "Failed to backup existing evdev.xml"
            exit 1
        fi
    fi

    # Copy evdev.xml to rules directory
    echo "Copying evdev.xml to $RULES_DIR..."
    cp "$HALMAK_DIR/evdev.xml" "$RULES_DIR/"
    if [[ $? -ne 0 ]]; then
        echo "Failed to copy evdev.xml to $RULES_DIR"
        exit 1
    fi

    # Inform user to restart
    echo "Installation complete. Please restart your computer to apply changes."
    echo "After restarting, go to System Settings -> Region & Language. Click '+', click 'English (United States)', scroll and click 'Halmak', then click 'Add' green button."
else
    echo "Your distro is not recognized or supported by this script."
    exit 1
fi

exit 0
