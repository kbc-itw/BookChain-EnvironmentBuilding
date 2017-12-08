#!/bin/bash

#エラーが起きた際にその場で止める
set -e

apt update -y
apt upgrade -y

#fabricの必要なイメージ一覧の取得
curl -sSL https://goo.gl/5ftp2f | bash

#fabric-sample　pull
cd /opt
git clone https://github.com/hyperledger/fabric-samples.git
cd /fabric-samples/fabcar

#サンプルで使うfabric環境を作成
./startFabric.sh
npm i
node enrollAdmin.js
node registerUser.js

