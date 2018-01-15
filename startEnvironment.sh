#!/bin/bash

#エラーが起きた際にその場で止める
set -e

export MSYS_NO_PATHCONV=1

# このBookChain-EnvironmentBuildingプロジェクトのルートパス
BOOKCHAIN_ENV_PATH=$PWD

# ルートパスをANYPATHに設定
cd ../
ANYPATH=$PWD

#fabric-sample　pull
cd $ANYPATH
git clone https://github.com/kbc-itw/fabric-samples.git
cd ./fabric-samples

git checkout --track origin/test

# fabric-samplesのプロジェクトルートのパス
FABRIC_SAMPLES_PATH=$PWD

#fabricの必要なイメージ一覧の取得
curl -sSL https://goo.gl/5ftp2f | bash

#.txファイル・.blockを作成するプログラムのパスを通す
export PATH=$PATH:$ANYPATH/fabric-samples/bin

#bookchain.txを作成する
export CHANNEL_NAME=bookchain

cd ./fabcar

#サンプルで使うfabric環境を作成
./startFabric.sh
npm install
node enrollAdmin.js
node registerUser.js

cd $ANYPATH/BookChain-EnvironmentBuilding
docker build -f ./Dockerfile-platform -t platform .
docker run -d --name platform -v $ANYPATH/fabric-samples/fabcar/hfc-key-store:/opt/BookChain/hfc-key-store -t -i -p 80:80 platform
