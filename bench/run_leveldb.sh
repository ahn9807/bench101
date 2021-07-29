#!/bin/bash

mkdir -p ./result/leveldb
mkdir -p ./bench

BIN=../../leveldb/build/db_bench
DISABLE_NUMA="numactl -N1 -m1"
DISABLE_NUMA=""
CMD_PREFIX="sudo nice -n -20 taskset 1"
VALUE_SIZE=4096
declare -a LEVELDB_TESTS=("fillseq" "fillsync" "fillrandom" "overwrite" "readrandom" "readrandom" "readseq" "readreverse" "compact" "readrandom" "readseq" "readreverse" "fill100K" "crc32c")

if [[ $EUID -ne 0 ]]; then
	echo "You have to run this code as root"
	exit 1
fi

echo "If you run bench101 in docker or xen..."
echo "Host machine's page cache must be deleted to bench accurate device speed without page caches"
echo "Then run this test one by one and delete page cache of your host machine manually"
read -p "Do you want to test leveldb one by one? [yn] " yn

if [ "$yn" != "${answer#{Yy]}" ] ;then
	echo run_leveldb_one_by_one
	cd ./bench
	mkdir bench
	for test in "${LEVELDB_TESTS[@]}"
	do 
		$CMD_PREFIX $DISABLE_NUMA $BIN --db=./bench --value_size=$VALUE_SIZE --clear_page_cache=1 --benchmarks=$test 2>&1 | tee ../result/leveldb/leveldb.output
		read -p "please enter to run next test..."
	done
fi

echo run_leveldb
cd ./bench
mkdir bench
$CMD_PREFIX $DISABLE_NUMA $BIN --db=./bench --value_size=$VALUE_SIZE --clear_page_cache=1 2>&1 | tee ../result/leveldb/leveldb.output
cd ..

rm -rf ./bench
