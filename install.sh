#!/usr/bin/env bash
set -e

# Load environment variables
. ./.env
VERSION=$(cat ./VERSION)

if [ -z "$INSTALL_PATH" ]; then
  echo "INSTALL_PATH is not set. Please set it in the .env file."
  exit 1
fi

# remove the old installation if it exists
rm -r "$INSTALL_PATH" || true

FILE="${VERSION}_splice-node.tar.gz"

# Download
curl -fL "https://github.com/digital-asset/decentralized-canton-sync/releases/download/v${VERSION}/${FILE}" \
    -o "$FILE"

# Extract
tar -xvf "$FILE"

mv "./splice-node" "$INSTALL_PATH"
rm -r "$INSTALL_PATH/splice-node/docker-compose/validator" || true
cp -r "./validator" "$INSTALL_PATH/splice-node/docker-compose/validator"

# Cleanup
rm "$FILE"
rm -r "./splice-node"