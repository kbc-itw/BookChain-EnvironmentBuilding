#!/bin/bash

set -ev

COUCH=$(cat ./../BookChain/config/secrets.json | jq '.couch')

USER_NAME=$(echo $COUCH | jq -r '.USER_NAME')
USER_PASSWORD=$(echo $COUCH | jq -r '.USER_PASSWORD')
PORT=$(echo $COUCH | jq -r '.PORT')
AUTH_DB_NAME=$(echo $COUCH | jq -r '.AUTH_DB_NAME')
SSESSION_DB_NAME=$(echo $COUCH | jq -r '.SESSION_DB_NAME')

curl -X PUT localhost:5984/_node/nonode@nohost/_config/admins/$USER_NAME -d \"$USER_PASSWORD\"

curl -X PUT $USER_NAME:$USER_PASSWORD@localhost:$PORT/$AUTH_DB_NAME
curl -X PUT $USER_NAME:$USER_PASSWORD@localhost:$PORT/$SSESSION_DB_NAME
