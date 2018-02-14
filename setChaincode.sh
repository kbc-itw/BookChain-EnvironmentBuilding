#!/bin/bash

set -e

CORE_PEER_LOCALMSPID=Org1MSP
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp

CCNAME=$1
LANGUAGE=NODE
docker exec -e "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID" -e "CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH" cli peer chaincode install -n $CCNAME -v 1.0 -p "/opt/gopath/src/github.com/BookChain-Chaincode/out/$CCNAME" -l $LANGUAGE
docker exec -e "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID" -e "CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH" cli peer chaincode instantiate -o orderer.example.com:7050 -C bookchain -n $CCNAME -l $LANGUAGE -v 1.0 -c '{"Args":[""]}' -P "OR ('Org1MSP.member')"