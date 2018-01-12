#!/bin/bash
#fabricを立ち上げるためのshell
set -ev

CHANNEL_NAME="bookchain"

# fabricを動作させるのに必要なセッティング
# fabricがすでにある場合に落とす必要がある
cd ../fabric-samples/basic-network

configtxgen -profile OneOrgChannel -outputCreateChannelTx ./config/channel.tx -channelID $CHANNEL_NAME

docker-compose -f docker-compose.yml down
# fabricを立ち上げる
docker-compose -f docker-compose.yml up -d ca.example.com orderer.example.com peer0.org1.example.com couchdb

# fabricを動作させる
# fabricが立ち上がるまでの待機時間
sleep 5
