#!/bin/sh
set -e

# Get architecture from environment or default to amd64
ARCH=${ARCH:-amd64}

echo "Building SQLite ICU extension for Alpine Linux - ${ARCH}"

# Build the extension
gcc -fPIC -shared icu.c \
    $(pkg-config --libs --cflags icu-io) \
    -I. \
    -o libSqliteIcu-linux-alpine-${ARCH}.so

# Verify the build
echo "Build completed successfully!"
file libSqliteIcu-linux-alpine-${ARCH}.so
ls -la libSqliteIcu-linux-alpine-${ARCH}.so

# Test the extension
echo "Testing the extension..."
sqlite3 <<EOF
.load ./libSqliteIcu-linux-alpine-${ARCH}.so
SELECT 'Extension loaded successfully' as result;
.quit
EOF

echo "Test completed successfully!"