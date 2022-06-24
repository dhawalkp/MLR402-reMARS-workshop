#!/usr/bin/env bash

set -ex

MODEL_PATH=$2

DIR=$1

rm -rf $DIR
mkdir -p $DIR || echo "Dir exists"

aws s3 cp $MODEL_PATH $DIR

cd $DIR

tar -xvf model.tar.gz
rm model.tar.gz
mv gptj.pt pytorch_model.bin