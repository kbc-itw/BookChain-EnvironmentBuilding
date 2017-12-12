#!/bin/bash

#エラーが起きた際にその場で止める
set -e

apt update -y
apt upgrade -y

#git
apt install git -y

#Nodejs LTS
apt install npm -y
npm install -g n
n lts

#fabric-sample　pull
cd /opt
git clone https://github.com/hyperledger/fabric-samples.git
cd ./fabric-samples

#fabricの必要なイメージ一覧の取得
curl -sSL https://goo.gl/5ftp2f | bash

export PATH=$PATH:/opt/fabric-samples/bin
cd ./fabric-samples/fabcar

#サンプルで使うfabric環境を作成
./startFabric.sh
npm install
node enrollAdmin.js
node registerUser.js

