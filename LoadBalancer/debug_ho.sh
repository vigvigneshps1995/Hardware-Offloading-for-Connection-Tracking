#!/bin/bash
threads=$1
capacity=$2
offcap=$3
if [[ "$capacity" -eq "" ]]
then
  capacity=8000000
fi
if [[ "$offcap" -eq "" ]]
then
	offcap=128
fi
if [[ "$threads" -ne "" ]]
then
  cores=$(($threads-1))
  file=loadbalancerhw-IMP.click
  sudo gdb --args ../fastclick/bin/click --dpdk -l 8-9 -m 16G -a 11:0.0 --log-level=1 --file-prefix=testing -- $file threads=$threads capacity=$capacity offcap=$offcap offtype=4
  
  #../fastclick/bin/click --dpdk -l 0-$cores -m 8G -a 11:0.0 --log-level=1 -- $file threads=$threads capacity=$capacity
else
  echo "You forgot to give nr of threads!"
fi
