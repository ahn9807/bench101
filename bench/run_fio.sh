#!/bin/bash

mkdir -p ./result

BIN=../fio
DISABLE_NUMA="numactl -N1 -m1"
DISABLE_NUMA=""
CMD_PREFIX="sudo nice -n -20 taskset 1"

echo fio_throughput_sr
$CMD_PREFIX $DISABLE_NUMA $BIN
echo fio_throughput_sw

echo fio_throughput_rr

echo fio_throughput_rw

echo fio_latency_rw

echo fio_latency_sw

echo fio_latency_rr

echo fio_latency_rw


