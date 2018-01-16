#!/bin/bash

#エラーが起きた際にその場で止める
set -ev

export MSYS_NO_PATHCONV=1

# このBookChain-EnvironmentBuildingプロジェクトのルートパス
BOOKCHAIN_ENV_PATH=$PWD

# ルートパスをROOT_PATHに設定
cd ../
ROOT_PATH=$PWD

#BookChain-Chaincode 準備
cd /$ROOT_PATH
git clone https://github.com/kbc-itw/BookChain-Chaincode.git
cd ./BookChain-Chaincode
npm install
#プロジェクトルートにlibフォルダにビルドする
#必要なchaincodeのjsFileはlibFolderの中にあるchaincodeFolderにある
npm run build

#fabric-sample　pull
cd $ROOT_PATH
git clone https://github.com/kbc-itw/fabric-samples.git
cd ./fabric-samples

git checkout --track origin/test

# fabric-samplesのプロジェクトルートのパス
FABRIC_SAMPLES_PATH=$PWD

#fabricの必要なイメージ一覧の取得
curl -sSL https://goo.gl/fMh2s3 | bash

#.txファイル・.blockを作成するプログラムのパスを通す
export PATH=$PATH:$ROOT_PATH/fabric-samples/bin

# FABRIC_CFG_PATH
export FABRIC_CFG_PATH=$FABRIC_SAMPLES_PATH/basic-network

cd $BOOKCHAIN_ENV_PATH
bash startFabric.sh

#サンプルで使うfabric環境を作成
cd $ROOT_PATH/fabric-samples/fabcar
./startFabric.sh
npm install
node enrollAdmin.js
node registerUser.js

cd $ROOT_PATH/BookChain-EnvironmentBuilding
docker build -f ./Dockerfile-platform -t platform .
docker run -d --name platform -v $ROOT_PATH/fabric-samples/fabcar/hfc-key-store:/opt/BookChain/hfc-key-store -t -i -p 80:80 platform


echo  "
oooooooooooo ooooo      ooo oooooooooo.   
`888'     `8 `888b.     `8' `888'   `Y8b  
 888          8 `88b.    8   888      888 
 888oooo8     8   `88b.  8   888      888 
 888    "     8     `88b.8   888      888 
 888       o  8       `888   888     d88' 
o888ooooood8 o8o        `8  o888bood8P'   
                                          
                                          
                                          "
