#!/bin/bash

mkdir -p ./result/fio
mkdir -p ./bench

BIN=../fio/fio
DISABLE_NUMA="numactl -N1 -m1"
DISABLE_NUMA=""
CMD_PREFIX="sudo nice -n -20 taskset 1"
BLOCK_SIZE=4K
SIZE=4G

echo fio_throughput_sr
$CMD_PREFIX $DISABLE_NUMA $BIN --rw=read --directory=./bench/ --name fio_test_file --direct=1 -bs=$BLOCK_SIZE --size=$SIZE --numjobs=1 --group_reporting 2>&1 | tee ./result/fio/fio_throughput_sr.output

echo fio_throughput_sw
$CMD_PREFIX $DISABLE_NUMA $BIN --rw=write --directory=./bench/ --name fio_test_file --direct=1 -bs=$BLOCK_SIZE --size=$SIZE --numjobs=1 --group_reporting 2>&1 | tee ./result/fio/fio_throughput_sr.output

echo fio_throughput_rr
$CMD_PREFIX $DISABLE_NUMA $BIN --rw=randread --directory=./bench/ --name fio_test_file --direct=1 -bs=$BLOCK_SIZE --size=$SIZE --numjobs=1 --group_reporting 2>&1 | tee ./result/fio/fio_throughput_sr.output

echo fio_throughput_rw
$CMD_PREFIX $DISABLE_NUMA $BIN --rw=randwrite --directory=./bench/ --name fio_test_file --direct=1 -bs=$BLOCK_SIZE --size=$SIZE --numjobs=1 --group_reporting 2>&1 | tee ./result/fio/fio_throughput_sr.output

rm -rf ./bench
