#!/usr/bin/env bash
set -e

VERSION="$1"

if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

FILE="${VERSION}_splice-node.tar.gz"

# Download
curl -fL "https://github.com/digital-asset/decentralized-canton-sync/releases/download/v${VERSION}/${FILE}" \
    -o "$FILE"

# Extract
tar -xvf "$FILE"

ORIGINAL_FOLDER="./splice-node/docker-compose/validator"
DESTINATION_FOLDER="./validator"

if [ -d "$ORIGINAL_FOLDER" ]; then
  if [ -d "$DESTINATION_FOLDER" ]; then
    rm -r "$DESTINATION_FOLDER"
  fi

  mv "$ORIGINAL_FOLDER" "$DESTINATION_FOLDER"
  mv "./splice-node/VERSION" "./VERSION"
fi

# Cleanup
rm "$FILE"
rm -r "./splice-node"

echo "Import completed for version $VERSION"