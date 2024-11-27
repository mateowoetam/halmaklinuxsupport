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

# Detect the system type
detect_system() {
    # Check for VanillaOS and get the version
    if command_exists apx; then
        version_id=$(grep -oP '(?<=VERSION_ID=).+' /etc/os-release | tr -d '"')
        echo "vanilla${version_id}"
        return
    fi
}

# Detect the package manager
detect_package_manager() {
    if command_exists rpm-ostree; then
        echo "rpm-ostree"
    elif [ -f /etc/NIXOS ]; then
        echo "nixos"
    elif command_exists apt-get; then
        echo "apt-get"
    elif command_exists apt; then
        echo "apt"
    elif command_exists yum; then
        echo "yum"
    elif command_exists dnf; then
        echo "dnf"
    elif command_exists zypper; then
        echo "zypper"
    elif command_exists pacman; then
        echo "pacman"
    elif command_exists paru; then
        echo "paru"
    elif command_exists yay; then
        echo "yay"
    elif command_exists emerge; then
        echo "emerge"
    elif command_exists guix; then
        echo "guix"
    elif [ -f /etc/alpine-release ]; then
        echo "alpine"
    else
        echo "unknown"
    fi
}

# Function to mount the required directories
mount_directories() {
    echo "Mounting the required directories to ABroot..."
    for dir in /home /home/$USER /usr /usr/share /usr/share/X11 /usr/share/X11/xkb /usr/share/X11/xkb/rules /usr/share/X11/xkb/symbols;
    do
        mount $dir || { echo "Failed to mount $dir"; exit 1; }
    done
}
# Function to copy the necessary files
copy_files() {
    echo "Copying zz to $SYMBOLS_DIR..."
    cp "$HALMAK_DIR/zz" "$SYMBOLS_DIR/"
    if [[ $? -ne 0 ]]; then
        echo "Failed to copy zz to $SYMBOLS_DIR"
        exit 1
    fi

    if [[ -f "$RULES_DIR/evdev.xml" ]]; then
        echo "Backing up existing evdev.xml to evdev.xml.bak..."
        cp "$RULES_DIR/evdev.xml" "$RULES_DIR/evdev.xml.bak"
        if [[ $? -ne 0 ]]; then
            echo "Failed to backup existing evdev.xml"
            exit 1
        fi
    fi

    echo "Copying evdev.xml to $RULES_DIR..."
    cp "$HALMAK_DIR/evdev.xml" "$RULES_DIR/"
    if [[ $? -ne 0 ]]; then
        echo "Failed to copy evdev.xml to $RULES_DIR"
        exit 1
    fi

    echo "Installation complete. Please restart your computer to apply changes."
    echo "After restarting, go to System Settings -> Region & Language. Click '+', click 'English (United States)', scroll and click 'Halmak', then click 'Add' green button."
}

# Detect system and package manager
system=$(detect_system)
package_manager=$(detect_package_manager)

if [[ "$system" == "vanilla2" ]]; then
    echo "You are running VanillaOS 2 Orchid."
    echo "Your distro is not yet supported by this script."
    exit 1
elif [[ "$system" == "vanilla22.10" ]]; then
    echo "You are running VanillaOS 22.10 Kinetic."
    sudo abroot shell
    mount_directories
    copy_files
elif [[ "$package_manager" == "rpm-ostree" ]]; then
    echo "Your distro is in experimental support; we cannot guarantee it works."
    CONFIG_DIR="/home/$USER/.config/xkb"
    mkdir -p "$CONFIG_DIR/symbols" "$CONFIG_DIR/rules"
    cp "$HALMAK_DIR/symbols/halmak" "$CONFIG_DIR/symbols/"
    cp "$HALMAK_DIR/rules/evdev" "$CONFIG_DIR/rules/"
    cp "$HALMAK_DIR/rules/evdev.xml" "$CONFIG_DIR/rules/"
    echo "Files have been copied to your home directory under .config/xkb."
    exit 1
elif [[ "$package_manager" == "nixos" ]]; then
    echo "Your distro is immutable or declarative. This script does not support it."
elif [[ "$package_manager" == "apt-get" || "$package_manager" == "apt" || "$package_manager" == "alpine" || "$package_manager" == "yum" || "$package_manager" == "dnf" || "$package_manager" == "zypper" || "$package_manager" == "pacman" || "$package_manager" == "paru" || "$package_manager" == "yay" || "$package_manager" == "emerge" || "$package_manager" == "guix" ]]; then
    echo "You are running a supported distro, the files will be copied."
    copy_files
else
    if [[ "$package_manager" == "unknown" ]]; then
        echo "Your distro is not recognized or supported by this script."
        exit 1
    fi

    copy_files
fi

exit 0
