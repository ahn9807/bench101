#!/bin/bash

mkdir -p ./result/redis

BIN=../redis/src/
DISABLE_NUMA="numactl -N1 -m1"
DISABLE_NUMA=

echo start testing redis

read -p "type remote ip: " ip

sudo nice -n -20 taskset 1 $DISABLE_NUMA $BIN/redis-benchmark -h $ip -n 500000 -t Get,Set -c 10 | tee ./result/redis/redis.out
