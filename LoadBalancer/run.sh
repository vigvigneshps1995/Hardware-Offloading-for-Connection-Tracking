#!/bin/bash
# run by ./run.sh core_count table_size 
threads=$1
capacity=$2
if [[ "$capacity" -eq "" ]]
then
  capacity=8000000
fi
if [[ "$threads" -ne "" ]]
then
  cores=$(($threads-1))
  file=loadbalancer-IMP.click
  sudo ../fastclick/bin/click --dpdk -l 0-$cores -m 4G -a 11:0.0 --log-level=1 -- $file threads=$threads capacity=$capacity
else
  echo "You forgot to give nr of threads!"
fi
