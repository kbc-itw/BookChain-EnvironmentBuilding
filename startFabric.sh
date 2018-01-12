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

# チャンネル作成
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f /etc/hyperledger/configtx/channel.tx
# peer0.org1.example.com にチャンネルをつなぐ
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel join -b $CHANNEL_NAME.block

# userのkeyをリセット
rm -rf ../fabcar/hfc-key-store

# chaincodeはnodeで動かす
LANGUAGE="node"
