#!/bin/bash

# Argument $1: Output filename, '.csv' if omitted.
# Argument $2: ruleCount, predefined rule count amounts, 0 - default, 2 - 2 Million flows, 8 - 8 Million flows

fileName=$1
ruleCount=$2
file=~/andreas/Scripts/Data/$fileName.csv

if [ ! -f $file ]; then
    echo "Time, TxCount, RxCount, TxRate, RxRate, PacketLoss, LAT, LAT95, LAT99" >> $file
fi

if [ $ruleCount -eq 2 ]; then
    sudo click --dpdk -l 0-7 -m 16G -a 11:0.0 --log-level=8 -- generator.click sizeOption=3 srcIPMask=0000FFFF srcPortMask=FFFF dstIPMask=0000FFFF dstPortMask=FFFF sampleRate=10 inFileOne="/mnt/traces/csd21_traces/caida18-16x-1-np.mindump" inFileTwo="/mnt/traces/csd21_traces/caida18-16x-2-np.mindump" fileName=$file
elif [ $ruleCount -eq 8 ]; then
    sudo click --dpdk -l 0-7 -m 16G -a 11:0.0 --log-level=8 -- generator.click sizeOption=3 srcIPMask=0000FFFF srcPortMask=EFFF dstIPMask=000009FF dstPortMask=FFFF sampleRate=10 inFileOne="/mnt/traces/csd21_traces/caida18-16x-1-np.mindump" inFileTwo="/mnt/traces/csd21_traces/caida18-16x-2-np.mindump" fileName=$file
else
    sudo click --dpdk -l 0-7 -m 16G -a 11:0.0 --log-level=8 -- generator.click sizeOption=3 srcIPMask=00000000 srcPortMask=0000 dstIPMask=00000000 dstPortMask=0000 sampleRate=10 inFileOne="/mnt/traces/csd21_traces/caida18-16x-1-np.mindump" inFileTwo="/mnt/traces/csd21_traces/caida18-16x-2-np.mindump" fileName=$file
fi
