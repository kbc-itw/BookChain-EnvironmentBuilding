#!/bin/bash
#ubuntuの環境を整えるシェルです

set -e

apt install curl -y

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
