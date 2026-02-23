#!/usr/bin/env bash
set -e

# Load environment variables
VERSION=$(cat ./VERSION)

FILE="${VERSION}_splice-node.tar.gz"

# Download
curl -fL "https://github.com/digital-asset/decentralized-canton-sync/releases/download/v${VERSION}/${FILE}" \
    -o "$FILE"

rm -r ./splice-node || true

# Extract
tar -xvf "$FILE"

rm -r "./splice-node/docker-compose/validator" || true
cp -r "./validator" "./splice-node/docker-compose/validator"

# Cleanup
rm "$FILE"