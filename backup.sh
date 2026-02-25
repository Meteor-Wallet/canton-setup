#!/usr/bin/env bash
set -e

. ./validator/.env

mkdir -p ./backup
docker exec -i splice-validator-postgres-splice-1 pg_dump -U cnadmin validator > ./backup/validator-"$(date -u +"%Y-%m-%dT%H:%M:%S%:z")".dump
active_participant_db=$(docker exec splice-validator-participant-1 bash -c 'echo $CANTON_PARTICIPANT_POSTGRES_DB')
docker exec splice-validator-postgres-splice-1 pg_dump -U cnadmin "${active_participant_db}" > "./backup/${active_participant_db}-$(date -u +"%Y-%m-%dT%H:%M:%S%:z").dump"

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