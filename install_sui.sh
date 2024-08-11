#!/usr/bin/env bash

# Stop script execution on any error
set -e

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <version> <network>"
    echo "Example: $0 v1.30.1 mainnet"
    exit 1
fi

# Set the version and network from the input arguments
VERSION=$1
NETWORK=$2

# Define the download URL based on version and network
URL="https://github.com/MystenLabs/sui/releases/download/${NETWORK}-${VERSION}/sui-${NETWORK}-${VERSION}-ubuntu-x86_64.tgz"

# Create a temporary directory
TMP_DIR=$(mktemp -d)

# Define the target directory for the binary
TARGET_DIR="/usr/local/bin"
TARGET_BIN="$TARGET_DIR/sui"

# Download the file to the temporary directory
echo "Downloading Sui ${NETWORK} ${VERSION}..."
curl -L -o "${TMP_DIR}/sui.tgz" "$URL"

# Extract the downloaded tar.gz file in the temporary directory
echo "Extracting Sui binary..."
tar -xvzf "${TMP_DIR}/sui.tgz" -C "$TMP_DIR"

# Find the extracted binary (assuming it's named 'sui')
echo "Copying Sui binary to ${TARGET_BIN}..."
sudo cp "${TMP_DIR}/sui" "$TARGET_BIN"

# Clean up the temporary directory
echo "Cleaning up..."
rm -rf "$TMP_DIR"

# Check if the installation was successful
if [ -x "$TARGET_BIN" ]; then
    echo "Sui ${NETWORK} ${VERSION} has been installed successfully at ${TARGET_BIN}."
else
    echo "Installation failed."
    exit 1
fi
