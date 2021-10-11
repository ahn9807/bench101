#!/bin/bash

mkdir -p ./result/gapbs

BIN=../gapbs
DISABLE_NUMA="numactl -N1 -m1"
DISABLE_NUMA=""

echo start_testing_bc
sudo nice -n -20 taskset 1 $DISABLE_NUMA $BIN/bc -g 25 -n 20 > ./result/gapbs/bc.output

echo start_testing_bfs
sudo nice -n -20 taskset 1 $DISABLE_NUMA $BIN/bfs -g 25 -n 20 > ./result/gapbs/bfs.output

echo start_testing_cc
sudo nice -n -20 taskset 1 $DISABLE_NUMA $BIN/cc -g 25 -n 20 > ./result/gapbs/cc.output

echo start_testing_cc_sv
sudo nice -n -20 taskset 1 $DISALBE_NUMA $BIN/cc_sv -g 25 -n  10 > ./result/gapbs/cc_sv.output

echo start_testing_pr
sudo nice -n -20 taskset 1 $DISABLE_NUMA $BIN/pr -g 25 -n 20 > ./result/gapbs/pr.output

echo start_testing_sssp
sudo nice -n -20 taskset 1 $DISABLE_NUMA $BIN/sssp -g 25 -n 20 > ./result/gapbs/sssp.output

echo start_testing_tc
sudo nice -n -20 taskset 1 $DISABLE_NUMA $BIN/tc -g 20 -n 20 > ./result/gapbs/tc.output
