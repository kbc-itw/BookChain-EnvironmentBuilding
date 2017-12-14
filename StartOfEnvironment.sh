#!/bin/bash

#エラーが起きた際にその場で止める
set -e

#Nodejs 8.x 
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
apt-get install -y nodejs

npm config set user 0
npm config set unsafe-perm true

#make install
apt install make -y
#g++ install
apt install g++ -y
#gcc install
apt install gcc -y

#fabric-sample　pull
cd /opt
git clone https://github.com/hyperledger/fabric-samples.git
cd ./fabric-samples

#fabricの必要なイメージ一覧の取得
curl -sSL https://goo.gl/5ftp2f | bash

export PATH=$PATH:/opt/fabric-samples/bin
cd ./fabcar

#サンプルで使うfabric環境を作成
./startFabric.sh
npm install
node enrollAdmin.js
node registerUser.js

cd /opt/BookChain-EnvironmentBuilding/
docker build -f ./Dockerfile-platform -t platform .
docker run -d --name platform -t -i -p 80:80 platform
