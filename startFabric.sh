#!/bin/bash
#fabricを立ち上げるためのshell
set -ev

Bookchain_EB=${PWD}
cd ../
ROOT=${PWD}
FABRIC_SAMPLES=$ROOT/fabric-samples
FABRIC_CFG_PATH=$FABRIC_SAMPLES/basic-network
BOOKCHAIN_CC=$ROOT/BookChain-Chaincode
CHANNEL_NAME="bookchain"

# fabricを動作させるのに必要なセッティング
# fabricがすでにある場合に落とす必要がある
cd $FABRIC_SAMPLES/basic-network

$FABRIC_SAMPLES/bin/configtxgen -profile OneOrgChannel -outputCreateChannelTx ./config/channel.tx -channelID $CHANNEL_NAME
export MSYS_NO_PATHCONV=1

docker-compose -f docker-compose.yml down
# fabricを立ち上げる
docker-compose -f docker-compose.yml up -d ca.example.com orderer.example.com peer0.org1.example.com couchdb

# fabricを動作させる
# fabricが立ち上がるまでの待機時間
sleep 10

# チャンネル作成
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f /etc/hyperledger/configtx/channel.tx
# peer0.org1.example.com にチャンネルをつなぐ
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel join -b $CHANNEL_NAME.block

# userのkeyをリセット
rm -rf ../fabcar/hfc-key-store

# chaincodeはnodeで動かす
LANGUAGE="node"

docker-compose -f ./docker-compose.yml up -d cli


# chancodeをセットする
cd $BOOKCHAIN_CC
CORE_PEER_LOCALMSPID=Org1MSP
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp

# install
# 作成したchaincodeのパスは/opt/BookChain-Chaincodeにある

# BookChain-Chaincodeのフォルダの名前を取得
files="./out/*"
dirary=()
for filepath in $files; do
    if [ -d $filepath ] ; then
        bn=$(basename $filepath)
        dirary+=( $(basename $filepath) )
    fi
done

# フォルダ名をchaincode名でinstall
# インスタンスを立ち上げ
for ccname in ${dirary[@]}; do
	bash $ROOT/BookChain-EnvironmentBuilding/setChaincode.sh $ccname
done

sleep 10
