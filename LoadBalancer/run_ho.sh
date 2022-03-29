#!/bin/bash
threads=$1
capacity=$2
offcap=$3
offtype=$4
offthresh=$5
table=$6

if [[ "$capacity" -eq "" ]]
then
  capacity=8000000
fi
if [[ "$offcap" -eq "" ]]
then
	offcap=128
fi
if [[ "$offtype" -eq "" ]]
then
	offtype=0
fi
if [[ "$offthresh" -eq "" ]]
then
        offthresh=0
fi
if [[ "$table" -eq "" ]]
then
	table=0
fi
if [[ "$threads" -ne "" ]]
then
  cores=$(($threads-1))
  file=loadbalancerhw-IMP.click
  sudo ../fastclick/bin/click --dpdk -l 0-$cores -m 8G -a 11:0.0 --log-level=1 -- $file threads=$threads capacity=$capacity offcap=$offcap offtype=$offtype table=$table offthresh=$offthresh
else
  echo "You forgot to give nr of threads!"
fi
