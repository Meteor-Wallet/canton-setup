#!/usr/bin/env bash
set -e

. ./validator/.env

BEARER_TOKEN=$(
  curl -s -X POST "$AUTH_URL/protocol/openid-connect/token" \
    -d "grant_type=client_credentials" \
    -d "client_id=$VALIDATOR_AUTH_CLIENT_ID" \
    -d "client_secret=$VALIDATOR_AUTH_CLIENT_SECRET" \
    -d "audience=$VALIDATOR_AUTH_AUDIENCE" \
    -d "scope=$LEDGER_API_AUTH_SCOPE" \
  | jq -r .access_token
)

curl "http://wallet.localhost:$HOST_BIND_PORT/api/validator/v0/admin/participant/identities" -H "authorization: Bearer $BEARER_TOKEN" | jq