#!/bin/bash

#エラーが起きた際にその場で止める
set -e

export MSYS_NO_PATHCONV=1

ANYPATH=$PWD
echo $ANYPATH

#fabric-sample　pull
cd $ANYPATH
git clone https://github.com/hyperledger/fabric-samples.git
cd ./fabric-samples

#fabricの必要なイメージ一覧の取得
curl -sSL https://goo.gl/5ftp2f | bash

export PATH=$PATH:$ANYPATH/fabric-samples/bin

cd ./fabcar

#サンプルで使うfabric環境を作成
./startFabric.sh
npm install
node enrollAdmin.js
node registerUser.js

cd $ANYPATH/BookChain-EnvironmentBuilding
docker build -f ./Dockerfile-platform -t platform .
docker run -d --name platform -v $ANYPATH/fabric-samples/fabcar/hfc-key-store:/opt/BookChain/hfc-key-store -t -i -p 80:80 platform
