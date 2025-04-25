#!/bin/bash

# Directories to create
CONFIG_SYMBOLS_DIR="/home/$USER/.config/xkb/symbols"
CONFIG_RULES_DIR="/home/$USER/.config/xkb/rules"
HALMAK_DIR="$(dirname "$0")/halmak-linux"

# Create the necessary directories
mkdir -p "$CONFIG_SYMBOLS_DIR" "$CONFIG_RULES_DIR"

# Check if the directories were created successfully
if [[ -d "$CONFIG_SYMBOLS_DIR" && -d "$CONFIG_RULES_DIR" ]]; then
    echo "Directories created successfully:"
    echo "$CONFIG_SYMBOLS_DIR"
    echo "$CONFIG_RULES_DIR"
else
    echo "Failed to create directories."
    exit 1
fi

# Function to copy files and handle errors
copy_files() {
    local src_symbols="$HALMAK_DIR/zz"
    local src_rules="$HALMAK_DIR/evdev.xml"
    local dest_symbols="$1"
    local dest_rules="$2"

    mkdir -p "$(dirname "$dest_symbols")" "$(dirname "$dest_rules")"

    if ! cp "$src_symbols" "$dest_symbols" || ! cp "$src_rules" "$dest_rules"; then
        echo "Failed to copy files to $dest_symbols and $dest_rules."
        exit 1
    fi
}

# Create directories and copy files
copy_files "$CONFIG_SYMBOLS_DIR/zz" "$CONFIG_RULES_DIR/evdev.xml"

# Success message
echo "After restarting, open your system's keyboard settings."
echo "Add a new input source, select 'Other', and then choose 'Halmak' from the list."
