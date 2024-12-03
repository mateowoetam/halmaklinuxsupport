#!/bin/sh

SYMBOLS_DIR="/usr/share/X11/xkb/symbols"
RULES_DIR="/usr/share/X11/xkb/rules"
HALMAK_DIR="$(pwd)/halmak-linux"
IMUTABLE_SYMBOLS_DIR="/home/$USER/.config/xkb/symbols"
IMUTABLE_RULES_DIR="/home/$USER/.config/xkb/rules"

# Function to copy files and handle errors
copy_files() {
    local src_symbol="$HALMAK_DIR/zz"  # Corrected source for symbols
    local src_rule="$HALMAK_DIR/evdev.xml"  # Corrected source for rules
    local dest_symbol="$1"
    local dest_rule="$2"
    
    mkdir -p "$(dirname "$dest_symbol")" "$(dirname "$dest_rule")"
    
    if ! cp "$src_symbol" "$dest_symbol" || ! cp "$src_rule" "$dest_rule"; then
        echo "Failed to copy files to $dest_symbol and $dest_rule."
        exit 1
    fi
}

# Detect OS and handle logic
if [ -f /etc/os-release ]; then
    . /etc/os-release

    # Handle immutable Fedora variants first
    if [ "$ID" = "fedora" ] && echo "$VARIANT" | grep -qE "Kinonite|Silverblue|immutable"; then
        echo "Immutable Fedora variant detected (e.g., $VARIANT)."
        copy_files "$IMUTABLE_SYMBOLS_DIR/zz" "$IMUTABLE_RULES_DIR/evdev.xml"
        echo "Installation complete for immutable Fedora variant."
        echo "After restarting, go to System Settings -> Region & Language."
        echo "Click '+', click 'English (United States)', scroll and click 'Halmak', then click the 'Add' green button."
        exit 0
    fi

    # Check for root privileges for other cases
    if [ "$(id -u)" -ne 0 ]; then
        echo "This script must be run as root. Use root privileges to run it."
        exit 1
    fi

    # Handle other distributions
    case "$ID" in
        fedora)
            echo "Standard Fedora detected."
            copy_files "$SYMBOLS_DIR/zz" "$RULES_DIR/evdev.xml"
            ;;
        vanilla)
            echo "Vanilla OS detected."
            case "$VERSION_ID" in
                "22.10")
                    echo "Vanilla OS version 22.10 detected. Entering ABroot shell."
                    sudo abroot shell << 'EOF'
mount_directories() {
    echo "Mounting the required directories to ABroot..."
    for dir in /home /home/$USER /usr /usr/share /usr/share/X11 /usr/share/X11/xkb /usr/share/X11/xkb/rules /usr/share/X11/xkb/symbols; do
        mount $dir || { echo "Failed to mount $dir"; exit 1; }
    done
}
mount_directories
EOF
                    copy_files "$SYMBOLS_DIR/zz" "$RULES_DIR/evdev.xml"
                    ;;
                "2.0")
                    echo "Vanilla OS version 2.0 detected. Immutable behavior applied."
                    copy_files "$IMUTABLE_SYMBOLS_DIR/zz" "$IMUTABLE_RULES_DIR/evdev.xml"
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
        debian | ubuntu | arch | alpine | gentoo | nobara | pop)
            echo "You are installing Halmak on $ID."
            copy_files "$SYMBOLS_DIR/zz" "$RULES_DIR/evdev.xml"
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
echo "After restarting, go to System Settings -> Region & Language."
echo "Click '+', click 'English (United States)', scroll and click 'Halmak', then click the 'Add' green button."
