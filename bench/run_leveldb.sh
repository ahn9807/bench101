#!/bin/bash

mkdir -p ./result/leveldb
mkdir -p ./bench

BIN=../../leveldb/build/db_bench
DISABLE_NUMA="numactl -N1 -m1"
DISABLE_NUMA=""
CMD_PREFIX="sudo nice -n -20 taskset 1"
VALUE_SIZE=4096

echo run_leveldb
cd ./bench
mkdir bench
$CMD_PREFIX $DISABLE_NUMA $BIN --db=./bench --value_size=$VALUE_SIZE 2>&1 | tee ../result/leveldb/leveldb.output
cd ..

rm -rf ./bench
