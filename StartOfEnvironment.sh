#!/bin/bash

#エラーが起きた際にその場で止める
set -e

apt update -y
apt upgrade -y

#fabricの必要なイメージ一覧の取得
curl -sSL https://goo.gl/5ftp2f | bash

