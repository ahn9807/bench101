#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "You have to run this code as root"
	exit 1
fi

DIR_ROOT=$PWD
DIR_LEVELDB=./leveldb
DIR_SYSBENCH=./sysbench
DIR_FIO=./fio
DIR_REDIS=./redis
DIR_GAPBS=./gapbs

## init git
git submodule init
git submodule update --init --recursive

## install lmbench
cd ./lmbench
cd src
make 
cd $DIR_ROOT

## install fio
cd $DIR_FIO
./configure
make
make install
cd $DIR_ROOT

## install leveldb
mkdir -p $DIR_LEVELDB/build && cd $DIR_LEVELDB/build
cmake -DCMAKE_BUILD_TYPE=Release .. && cmake .
make
cd $DIR_ROOT

## install sysbench
apt -y install make automake libtool pkg-config libaio-dev
apt -y install libmysqlclient-dev libssl-dev    
apt -y install libpq-dev
cd ./sysbench
./autogen.sh
./configure --without-mysql
make install
cd $DIR_ROOT

## install Gapbs
cd $DIR_GAPBS 
make clean
export SERIAL=1
make
make test
cd $DIR_ROOT

## install Redis (Redis-benchmark)
cd $DIR_REDIS
make
cd $ROOT_DIR

echo "It's times for run_bench!"
