#!/bin/bash

#GEN_ALLOC='"0x0000000000000000000000000000000000000000": {"balance": "100000"}"

FILE="genesis.json"
if [ -f $FILE ]; then
   echo "File $FILE exists."
   exit 1
fi

GEN_NONCE="0x000000ba9004740c"
GEN_CHAIN_ID=3963
FILE="gen_alloc"
if [ ! -f $FILE ]; then
   #echo "File $FILE does not exist."
   cp src/$FILE.template $FILE
fi

GEN_ALLOC=$(cat $FILE)

sed "s/\${GEN_NONCE}/$GEN_NONCE/g" src/genesis.json.template | sed "s/\${GEN_ALLOC}/$GEN_ALLOC/g" | sed "s/\${GEN_CHAIN_ID}/$GEN_CHAIN_ID/g" > genesis.json

