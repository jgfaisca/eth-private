#!/bin/bash

#GEN_ALLOC='"0x0000000000000000000000000000000000000000": {"balance": "100000"}"

FILE="genesis.json"
if [ -f $FILE ]; then
   echo "File $FILE exists. Aborting..."
   exit 1
else
   echo "File $FILE does not exist. Creating..."
fi

GEN_NONCE="0x0000000000000042"
GEN_CHAIN_ID=3963
FILE="gen_alloc"
if [ ! -f $FILE ]; then
   echo "File $FILE does not exist. Creating..."
   cp src/$FILE.template $FILE
else
   echo "File $FILE exists."
fi

GEN_ALLOC=$(cat $FILE)

sed "s/\${GEN_NONCE}/$GEN_NONCE/g" src/genesis.json.template | sed "s/\${GEN_ALLOC}/$GEN_ALLOC/g" | sed "s/\${GEN_CHAIN_ID}/$GEN_CHAIN_ID/g" > genesis.json

