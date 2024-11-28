#!/bin/bash

SYMBOLS_DIR="/usr/share/X11/xkb/symbols"
RULES_DIR="/usr/share/X11/xkb/rules"
HALMAK_DIR="$(dirname "$0")/halmak-linux"
IMUTABLE_SYMBOLS_DIR="/home/$USER/.config/xkb/symbols"
IMUTABLE_RULES_DIR="/home/$USER/.config/xkb/rules"

# Function to copy files and handle errors
copy_files() {
    local src_symbols="$HALMAK_DIR/evdev.xml"
    local src_rules="$HALMAK_DIR/zz"
    local dest_symbols="$1"
    local dest_rules="$2"
    
    mkdir -p "$(dirname "$dest_symbols")" "$(dirname "$dest_rules")"
    
    if ! cp "$src_symbols" "$dest_symbols" || ! cp "$src_rules" "$dest_rules"; then
        echo "Failed to copy files to $dest_symbols and $dest_rules."
        exit 1
    fi
}

# Detect OS and handle logic
if [[ -f /etc/os-release ]]; then
    . /etc/os-release

    # Handle immutable Fedora variants first
    if [[ "$ID" == "fedora" ]] && [[ "$VARIANT" =~ Kinonite|Silverblue|immutable ]]; then
        echo "Immutable Fedora variant detected (e.g., $VARIANT)."
        copy_files "$IMUTABLE_SYMBOLS_DIR/evdev.xml" "$IMUTABLE_RULES_DIR/zz"
        echo "Installation complete for immutable Fedora variant."
        echo -e "After restarting, go to System Settings -> Region & Language.\nClick '+', click 'English (United States)', scroll and click 'Halmak', then click the 'Add' green button."
        exit 0
    fi

    # Check for root privileges for other cases
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root. Use root privileges to run it."
        exit 1
    fi

    # Handle other distributions
    case "$ID" in
        fedora)
            echo "Standard Fedora detected."
            copy_files "$SYMBOLS_DIR/evdev.xml" "$RULES_DIR/zz"
            ;;
        "vanilla")
            echo "Vanilla OS detected."
            case "$VERSION_ID" in
                "22.10")
                    echo "Vanilla OS version 22.10 detected. Entering ABroot shell."
                    sudo abroot shell << EOF
mount_directories() {
    echo "Mounting the required directories to ABroot..."
    for dir in /home /home/$USER /usr /usr/share /usr/share/X11 /usr/share/X11/xkb /usr/share/X11/xkb/rules /usr/share/X11/xkb/symbols; do
        mount $dir || { echo "Failed to mount $dir"; exit 1; }
    done
}
mount_directories
EOF
                    copy_files "$SYMBOLS_DIR/evdev.xml" "$RULES_DIR/zz"
                    ;;
                "2.0")
                    echo "Vanilla OS version 2.0 detected. Immutable behavior applied."
                    copy_files "$IMUTABLE_SYMBOLS_DIR/evdev.xml" "$IMUTABLE_RULES_DIR/zz"
                    ;;
                *)
                    echo "Unsupported Vanilla OS version. Exiting."
                    exit 1
                    ;;
            esac
            ;;
        nixos)
            echo "NixOS detected. This OS is not supported by the script."
            exit 1
            ;;
        debian | ubuntu | arch | alpine | gentoo | nobara)
            echo "You are installing Halmak on $ID."
            copy_files "$SYMBOLS_DIR/evdev.xml" "$RULES_DIR/zz"
            ;;
        *)
            echo "Unknown or unsupported distribution: $ID. Exiting."
            exit 1
            ;;
    esac
else
    echo "Cannot find /etc/os-release. Exiting."
    exit 1
fi

# Success message
echo "Installation complete. Please restart your computer to apply changes."
echo -e "After restarting, go to System Settings -> Region & Language.\nClick '+', click 'English (United States)', scroll and click 'Halmak', then click the 'Add' green button."
