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
cd $ROOT_PATH
if [  ! -e BookChain-Chaincode ]; then
git clone https://github.com/kbc-itw/BookChain-Chaincode.git
fi
cd ./BookChain-Chaincode
npm install
#プロジェクトルートにlibフォルダにビルドする
#必要なchaincodeのjsFileはlibFolderの中にあるchaincodeFolderにある
npm run build

#fabric-sample　pull
cd $ROOT_PATH
if [  ! -e fabric-samples ]; then
git clone https://github.com/kbc-itw/fabric-samples.git
fi
cd ./fabric-samples

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
npm install
node enrollAdmin.js
node registerUser.js

#BookChain-Clientをpull
cd $ROOT_PATH
if [  ! -e BookChain-Client ]; then
git clone https://github.com/kbc-itw/BookChain-Client.git
fi
cd ./BookChain-Client
npm install
npm run build

#BookChain
cd $ROOT_PATH
if [  ! -e BookChain ]; then
git clone https://github.com/kbc-itw/BookChain.git
fi
cd ./BookChain
npm install
npm run build
if [ -e hfc-key-store ]; then
rm -f ./hfc-key-store/*
else
mkdir hfc-key-store
fi
cp $FABRIC_SAMPLES_PATH/fabcar/hfc-key-store/* $ROOT_PATH/BookChain/hfc-key-store

echo  "
oooooooooooo ooooo      ooo oooooooooo.   
 888       8  888b.      8   888     Y8b  
 888          8  88b.    8   888      888 
 888oooo8     8    88b.  8   888      888 
 888    8     8      88b.8   888      888 
 888       o  8        888   888     d88  
o888ooooood8 o8o         8  o888bood8P    
                                          
"
