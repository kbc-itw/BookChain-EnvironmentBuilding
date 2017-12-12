#!/bin/bash

set -e

curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh

apt install docker-compose -y
