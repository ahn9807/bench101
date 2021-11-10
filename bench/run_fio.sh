#!/bin/bash

mkdir -p ./result/fio
mkdir -p ../nvme_mnt/bench/ 

BIN=../fio/fio
DISABLE_NUMA="numactl -N1 -m1"
DISABLE_NUMA=""
CMD_PREFIX="sudo nice -n -20 taskset 1"
BLOCK_SIZE=4K
SIZE=16G
CMD_POSTFIX="--directory=../nvme_mnt/bench/ --name fio_test_file --direct=1 -bs=$BLOCK_SIZE --size=$SIZE --numjobs=1 --group_reporting"
# Use this to bench ramdisk!
# CMD_POSTFIX="--directory=../nvme_mnt/bench/ --name fio_test_file --direct=0 -bs=$BLOCK_SIZE --size=$SIZE --numjobs=1 --group_reporting"

echo fio_throughput_sr
sudo sh -c "echo 1 > /proc/sys/vm/drop_caches"
$CMD_PREFIX $DISABLE_NUMA $BIN --rw=read $CMD_POSTFIX 2>&1 | tee ./result/fio/fio_sr.output

echo fio_throughput_sw
sudo sh -c "echo 1 > /proc/sys/vm/drop_caches"
$CMD_PREFIX $DISABLE_NUMA $BIN --rw=write $CMD_POSTFIX 2>&1 | tee ./result/fio/fio_sw.output

echo fio_throughput_rr
sudo sh -c "echo 1 > /proc/sys/vm/drop_caches"
$CMD_PREFIX $DISABLE_NUMA $BIN --rw=randread $CMD_POSTFIX 2>&1 | tee ./result/fio/fio_rr.output

echo fio_throughput_rw
sudo sh -c "echo 1 > /proc/sys/vm/drop_caches"
$CMD_PREFIX $DISABLE_NUMA $BIN --rw=randwrite $CMD_POSTFIX 2>&1 | tee ./result/fio/fio_rw.output

rm -rf ./bench
