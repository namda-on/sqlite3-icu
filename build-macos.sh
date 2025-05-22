#!/bin/bash
set -e

# Get architecture from environment or default to x86_64
ARCH=${ARCH:-x86_64}

echo "Building SQLite ICU extension for macOS - ${ARCH}"

# Download SQLite source if needed
if [ ! -f sqlite3ext.h ]; then
    echo "Downloading SQLite source..."
    wget -q https://www.sqlite.org/2024/sqlite-amalgamation-3460000.zip
    unzip -q sqlite-amalgamation-3460000.zip
    cp sqlite-amalgamation-3460000/sqlite3ext.h .
    cp sqlite-amalgamation-3460000/sqlite3.h .
    rm -rf sqlite-amalgamation-3460000*
fi

# Download ICU extension source if needed
if [ ! -f icu.c ]; then
    echo "Downloading ICU extension source..."
    wget -q https://www.sqlite.org/src/raw/ext/icu/icu.c
fi

# Set PKG_CONFIG_PATH for ICU
if [ "$ARCH" = "arm64" ]; then
    export PKG_CONFIG_PATH="/opt/homebrew/opt/icu4c/lib/pkgconfig:$PKG_CONFIG_PATH"
else
    export PKG_CONFIG_PATH="/usr/local/opt/icu4c/lib/pkgconfig:$PKG_CONFIG_PATH"
fi

# Build the extension
gcc -arch ${ARCH} -fPIC -shared icu.c \
    $(pkg-config --libs --cflags icu-io) \
    -I. \
    -o icu.dylib

# Verify the build
echo "Build completed successfully!"
file icu.dylib
ls -la icu.dylib

echo "macOS build for ${ARCH} completed successfully!"