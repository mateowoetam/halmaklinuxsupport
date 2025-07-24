#!/bin/bash

# Define the paths
SYMBOLS_DIR="/usr/share/X11/xkb/symbols"
RULES_DIR="/usr/share/X11/xkb/rules"
HALMAK_DIR="$(dirname "$0")/../halmak-linux"

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Use sudo to run it."
   exit 1
fi

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

exit 0
