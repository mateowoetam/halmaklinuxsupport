#!/bin/bash

# Define the paths
SYMBOLS_DIR="/usr/share/X11/xkb/symbols"
RULES_DIR="/usr/share/X11/xkb/rules"
HALMAK_DIR="$(dirname "$0")/halmak-linux"

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
   exit 1
fi

# Copy zz to symbols directory
cp "$HALMAK_DIR/zz" "$SYMBOLS_DIR/"
if [[ $? -ne 0 ]]; then
    exit 1
fi

# Backup existing evdev.xml
if [[ -f "$RULES_DIR/evdev.xml" ]]; then
    cp "$RULES_DIR/evdev.xml" "$RULES_DIR/evdev.xml.bak"
    if [[ $? -ne 0 ]]; then
        exit 1
    fi
fi

# Copy evdev.xml to rules directory
cp "$HALMAK_DIR/evdev.xml" "$RULES_DIR/"
if [[ $? -ne 0 ]]; then
    exit 1
fi

exit 0
