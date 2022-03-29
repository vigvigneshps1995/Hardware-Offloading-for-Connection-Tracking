#!/bin/bash

project_folder=~/andreas
runs=5                              # Default value for good (enough) accuracy
time=$(date +%y-%m-%dT%H%M)         # Make the whole run share the same identifier 
cd $project_folder/Scripts

# Basic Forwarder tests
./run_test.sh -l0 -r$runs -b -i$time -f2
./run_test.sh -l0 -r$runs -b -i$time -f8

# Loadbalancer tests
./run_test.sh -l1 -r$runs -b -s2 -i$time -f2 -z0 -t1
./run_test.sh -l1 -r$runs -b -s4 -i$time -f2 -z0 -t1
./run_test.sh -l1 -r$runs -b -s8 -i$time -f2 -z0 -t1
./run_test.sh -l1 -r$runs -b -s16 -i$time -f2 -z0 -t1

./run_test.sh -l1 -r$runs -b -s2 -i$time -f8 -z0 -t1
./run_test.sh -l1 -r$runs -b -s4 -i$time -f8 -z0 -t1
./run_test.sh -l1 -r$runs -b -s8 -i$time -f8 -z0 -t1
./run_test.sh -l1 -r$runs -b -s16 -i$time -f8 -z0 -t1

# Loadbalancer with hardware offloading without logicz
./run_test.sh -l2 -r$runs -b -s2 -i$time -o1 -f2 -z4 -n20000 -t1
./run_test.sh -l2 -r$runs -b -s4 -i$time -o1 -f2 -z4 -n20000 -t1
./run_test.sh -l2 -r$runs -b -s8 -i$time -o1 -f2 -z4 -n20000 -t1
./run_test.sh -l2 -r$runs -b -s16 -i$time -o1 -f2 -z4 -n20000 -t1

./run_test.sh -l2 -r$runs -b -s2 -i$time -o1 -f8 -z4 -n20000 -t1
./run_test.sh -l2 -r$runs -b -s4 -i$time -o1 -f8 -z4 -n20000 -t1
./run_test.sh -l2 -r$runs -b -s8 -i$time -o1 -f8 -z4 -n20000 -t1
./run_test.sh -l2 -r$runs -b -s16 -i$time -o1 -f8 -z4 -n20000 -t1

# Loadbalancer with hardware offloading and logicz
./run_test.sh -l2 -r$runs -b -s2 -i$time -o1 -f2 -z1 -n20000 -t1
./run_test.sh -l2 -r$runs -b -s4 -i$time -o1 -f2 -z1 -n20000 -t1
./run_test.sh -l2 -r$runs -b -s8 -i$time -o1 -f2 -z1 -n20000 -t1
./run_test.sh -l2 -r$runs -b -s16 -i$time -o1 -f2 -z1 -n20000 -t1

./run_test.sh -l2 -r$runs -b -s2 -i$time -o1 -f8 -z1 -n20000 -t1
./run_test.sh -l2 -r$runs -b -s4 -i$time -o1 -f8 -z1 -n20000 -t1
./run_test.sh -l2 -r$runs -b -s8 -i$time -o1 -f8 -z1 -n20000 -t1
./run_test.sh -l2 -r$runs -b -s16 -i$time -o1 -f8 -z1 -n20000 -t1
