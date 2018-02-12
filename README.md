# BookChain-EnvironmentBuilding 

ubuntu:16.04とwindows10(git bash) で動かすことを想定していますので他のバージョンでの動作は保証しません。

gitcloneを使う前提でshell等を書いております。  
` git clone https://github.com/kbc-itw/BookChain-EnvironmentBuilding.git  `

## 事前環境

### ubuntu

#### Docker install

` bash dockerinstall.sh `

#### fabric start

` bash ubuntu.sh `

### windows

Docker 17.03.0-ce 以上  
Docker-compose 1.8 以上  
Node.js 8.x lts  
[curl](https://curl.haxx.se/download.html) 新しいバージョンをいれてください

準備ができたら  
クローンしたフォルダの中にあるwindows.shを動作してください。  
` bash windows.sh `  
もしくは  
`git config --global core.autocrlf false `  
`git config --global core.longpaths true `  
`npm install --global windows-build-tools`  
`npm install --global grpc `   

## Fabric Start

`bash startEnvironment.sh `

## secret.json

クローンされたBookChain/config/secret-template.jsonを編集する

## Platform Start

> bash runPlatform.sh
