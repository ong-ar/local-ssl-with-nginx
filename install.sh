#!/bin/bash

brew install mkcert

mkcert -install

mkcert -cert-file=./ssl/all.crt -key-file ./ssl/all.key "*.local.kcd.co.kr" "*.local.cashnote.kr"

docker-compose up -d

echo '127.0.0.1   merlin.local.cashnote.kr kestrel.local.cashnote.kr space.local.kcd.co.kr' | sudo tee -a /etc/hosts