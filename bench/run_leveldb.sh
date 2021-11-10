#!/bin/bash
if [[ $EUID -ne 0 ]]; then
	echo "You have to run this code as root"
	exit 1
fi

read -p "type DB path: " DB
DB=$(readlink -f $DB)
mkdir -p ./result/leveldb
mkdir -p $DB

WORKING_DIR=$PWD
BIN=$PWD/../leveldb/build/db_bench
DISABLE_NUMA="numactl -N1 -m1"
DISABLE_NUMA=""
CMD_PREFIX="sudo nice -n -20 taskset 1"
VALUE_SIZE=4096
declare -a LEVELDB_TESTS=("fillseq" "fillsync" "fillrandom" "overwrite" "readrandom" "readrandom" "readseq" "readreverse" "compact" "readrandom" "readseq" "readreverse" "fill100K" "crc32c")

echo "If you run bench101 in docker or xen..."
echo "Host machine's page cache must be deleted to bench accurate device speed without page caches"
echo "Then run this test one by one and delete page cache of your host machine manually"
read -p "Do you want to test leveldb one by one? [yn] " yn

if [ "$yn" != "${yn#[Yy]}" ] ;then
	echo run_leveldb_one_by_one
	cd $DB
	mkdir -p bench
	PRINT_META=1 
	for test in "${LEVELDB_TESTS[@]}"
	do 
		if [[ $PRINT_META == 1 ]] ;then
			if [[ $test == *"fill"* ]]; then
				$CMD_PREFIX $DISABLE_NUMA $BIN --db=./bench --value_size=$VALUE_SIZE --clear_page_cache=1 --benchmarks=$test 2>&1 | tee $WORKING_DIR/result/leveldb/leveldb.output
			else
				$CMD_PREFIX $DISABLE_NUMA $BIN --db=./bench --value_size=$VALUE_SIZE --clear_page_cache=1 --use_existing_db=1 --benchmarks=$test 2>&1 | tee $WORKING_DIR/result/leveldb/leveldb.output
			fi
		else
			if [[ $test == *"fill"* ]]; then
				$CMD_PREFIX $DISABLE_NUMA $BIN --db=./bench --value_size=$VALUE_SIZE --clear_page_cache=1 --benchmarks=$test 2>&1 | grep -e $test | tee -a $WORKING_DIR/result/leveldb/leveldb.output
			else
				$CMD_PREFIX $DISABLE_NUMA $BIN --db=./bench --value_size=$VALUE_SIZE --clear_page_cache=1 --use_existing_db=1 --benchmarks=$test 2>&1 | grep -e $test | tee -a $WORKING_DIR/result/leveldb/leveldb.output
			fi
		fi
		PRINT_META=0
		read -p "please enter to run next test"
	done
	cd ..
else
	echo run_leveldb
	cd $DB
	mkdir -p bench
	PRINT_META=1 
	for test in "${LEVELDB_TESTS[@]}"
	do 
		if [[ $PRINT_META == 1 ]] ;then
			if [[ $test == *"fill"* ]]; then
				$CMD_PREFIX $DISABLE_NUMA $BIN --db=./bench --value_size=$VALUE_SIZE --clear_page_cache=1 --benchmarks=$test 2>&1 | tee $WORKING_DIR/result/leveldb/leveldb.output
			else
				$CMD_PREFIX $DISABLE_NUMA $BIN --db=./bench --value_size=$VALUE_SIZE --clear_page_cache=1 --use_existing_db=1 --benchmarks=$test 2>&1 | tee $WORKING_DIR/result/leveldb/leveldb.output
			fi
		else
			if [[ $test == *"fill"* ]]; then
				$CMD_PREFIX $DISABLE_NUMA $BIN --db=./bench --value_size=$VALUE_SIZE --clear_page_cache=1 --benchmarks=$test 2>&1 | grep -e $test |  tee -a $WORKING_DIR/result/leveldb/leveldb.output
			else
				$CMD_PREFIX $DISABLE_NUMA $BIN --db=./bench --value_size=$VALUE_SIZE --clear_page_cache=1 --use_existing_db=1 --benchmarks=$test 2>&1 | grep -e $test | tee -a $WORKING_DIR/result/leveldb/leveldb.output
			fi
		fi
		PRINT_META=0
	done
	cd ..
fi

rm -r $DB/bench
