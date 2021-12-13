#!/bin/bash

mkdir -p ./result_$1/gapbs

BIN=../gapbs
DISABLE_NUMA="numactl -N1 -m1"
DISABLE_NUMA=""

$BIN/converter -g 25 -b 25g.sg

echo start_testing_bc
sudo nice -n -20 taskset 1 $DISABLE_NUMA $BIN/bc -f ./25g.sg -n 5 > ./result_$1/gapbs/bc.output

echo start_testing_bfs
sudo nice -n -20 taskset 1 $DISABLE_NUMA $BIN/bfs -f ./25g.sg -n 5 > ./result_$1/gapbs/bfs.output

echo start_testing_cc
sudo nice -n -20 taskset 1 $DISABLE_NUMA $BIN/cc -f ./25g.sg -n 5 > ./result_$1/gapbs/cc.output

echo start_testing_cc_sv
sudo nice -n -20 taskset 1 $DISALBE_NUMA $BIN/cc_sv -f ./25g.sg -n 5 > ./result_$1/gapbs/cc_sv.output

echo start_testing_pr
sudo nice -n -20 taskset 1 $DISABLE_NUMA $BIN/pr -f ./25g.sg -n 5 > ./result_$1/gapbs/pr.output

echo start_testing_sssp
sudo nice -n -20 taskset 1 $DISABLE_NUMA $BIN/sssp -g 25 -n 5 > ./result_$1/gapbs/sssp.output

echo start_testing_tc
sudo nice -n -20 taskset 1 $DISABLE_NUMA $BIN/tc -g 20 -n 5 > ./result_$1/gapbs/tc.output
