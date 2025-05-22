#!/bin/bash
set -e

ARCH=${ARCH:-arm64}

echo "Building SQLite ICU extension for macOS - ${ARCH}"

echo "Downloading SQLite source..."
wget -q https://www.sqlite.org/2024/sqlite-amalgamation-3460000.zip
unzip -q sqlite-amalgamation-3460000.zip
cp sqlite-amalgamation-3460000/sqlite3ext.h .
cp sqlite-amalgamation-3460000/sqlite3.h .
rm -rf sqlite-amalgamation-3460000*

if [ "$ARCH" = "arm64" ]; then
    export PKG_CONFIG_PATH="/opt/homebrew/opt/icu4c/lib/pkgconfig:$PKG_CONFIG_PATH"
else
    export PKG_CONFIG_PATH="/usr/local/opt/icu4c/lib/pkgconfig:$PKG_CONFIG_PATH"
fi

gcc -arch ${ARCH} -fPIC -shared icu.c \
    -I. \
    -o libSqliteIcu.dylib \
    $(pkg-config --cflags icu-io) \
    $(pkg-config --libs icu-io) \
    -licui18n -licuuc

echo "Build completed successfully!"
file libSqliteIcu.dylib
ls -la libSqliteIcu.dylib

echo "macOS build for ${ARCH} completed successfully!"