#!/bin/bash
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
  sudo gdb --args ../fastclick/bin/click --dpdk -l 0-$cores -m 1G -a 11:0.0 --log-level=8 -- $file threads=$threads capacity=$capacity
else
  echo "You forgot to give nr of threads!"
fi
