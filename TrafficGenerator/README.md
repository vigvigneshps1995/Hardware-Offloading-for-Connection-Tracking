## Traffic Generator
This fastclick script acts as the Traffic Generator (TG) in the testbed configuration.  
By being responsible for both generating traffic, and having a sink capable of receiving traffic  
it can compute throughput (TX/RX), packet latencies and loss.  
These statistics are output to file, in CSV format.

In short, the traffic generator operates by,
- Reading traffic traces from pcap files (MinDumps),
- Performing packet manipulation, either size or flow adjustments,
- Adding metadata in the packets so that latency can be computed

The traffic generator ends after the trace file has been replayed to its entirety,
and then prints summary statistics to stdout.  

At every period, the statistics include values on the amount of packets sent and lost,
since the previous period.

The following arguments are accepted by the Traffic Generator (argName=value):
```
[Name, type, description and options, default value]

verbose - INTEGER, Specifies logging verbosity - Default 3.

promisc - BOOLEAN, If receiving interface should be in promiscuous mode - Default false.

blocking - BOOLEAN, Some fancy description - Default true.

inPort - INTEGER, DPDK Port [0,1] - Default 0.

outPort - INTEGER DPDK Port [0,1] - Default 0.
        Should be same as inPort.

srcMac - MAC ADDRESS, Source MAC address - Default b8:83:03:6f:43:40 (ens1f0, nslrack21)

srcIPMask - BITMASK, Source IP Bitmask [00000000 -> FFFFFFFF] - Default 00000000.
    Where setting the most strict bitmask (FFFF) would set it to: 192.56.129.178

srcPortMask - BITMASK, Source Port Bitmask [0000 -> FFFF] - Default 0000.
    Where setting the most strict bitmask (FFFF) would set it to: 6789

dstMac -  MAC ADDRESS, Destination MAC address - Default b8:83:03:6f:43:38 (ens1f0, nslrack22)

dstIPMask - BITMASK, Destination IP Bitmask [00000000 -> FFFFFFFF] - Default 00000000.
    Where setting the most strict bitmask (FFFF) would set it to: 178.129.56.192

dstPortMask - BITMASK, Destination Port Bitmask [0000 -> FFFF] - Default 0000.
    Where setting the most strict bitmask (FFFF) would set it to: 9876

sizeOption - INTEGER, Size of packets [0, 1, 2, 3] - Default 0
    0 - Unchanged
    1 - 142 bytes
    2 - 526 bytes
    3 - 1514 bytes

sampleRate - INTEGER, How often to log statistics - Default 10 (Hz)

fileName - STRING, File to save statistics to - Default TG-stats.csv

inFileOne, inFileTwo - STRING, Trace files to read traffic from. Workaround for now .. until a better fix is found.
    DEFAULT /mnt/traces/csd21_traces/caida18-16x-1.mindump /mnt/traces/csd21_traces/caida18-16x-2-np.mindump
    OTHER /mnt/traces/csd21_traces/caida18-16x-1-np.mindump /mnt/traces/csd21_traces/caida18-16x-2-np.mindump
```

A minimal starting configuration would be:  
```sh
sudo click --dpdk -l 0-7 -m 16G -a 11:0.0 --log-level=8 -- generator.click
```

Or as seen in `run_generator.sh`.  

### Traffic Generation Variants
The traffic generator is currently capable of performing two variants of packet manipulation,

**Packet Size**  
The traffic generator can pad packets to, currently, three different predefined lengths  
which can be set by the `sizeOption=X` argument. Current set sizes are not final.

A configuration to alter size would be:   
```sh
sudo click --dpdk -l 0-7 -m 16G -a 11:0.0 --log-level=8 -- generator.click sizeOption=0
```

**Amount of flows**  
The traffic generator can perform bit manipulation on the 4-tuple in order to  
adjust the number of flows. This is done by adjusting the bitmask to a more strict (0xF..F) or less strict (0x0..0)  
bitmask, resulting to more or less numbers in the source and destination IP and ports being set.

A configuration to preserve original flows would be:
```sh
sudo click --dpdk -l 0-7 -m 16G -a 11:0.0 --log-level=8 -- generator.click srcIPMask=00000000 srcPortMask=0000 dstIPMask=00000000 dstPortMask=0000
```

While the most strict configuration, setting IP and ports to two single IP:Port predefined values, would be:
```sh
sudo click --dpdk -l 0-7 -m 16G -a 11:0.0 --log-level=8 -- generator.click srcIPMask=FFFFFFFF srcPortMask=FFFF dstIPMask=FFFFFFFF dstPortMask=FFFF
```

### Output format
The CSV format that the Traffic Generator uses is as following,
```csv
Time, TxCount, RxCount, TxRate, RxRate, PacketLoss, LAT, LAT95, LAT99
0.100093364716,13801248,7199623,98370037156.4,54482521156.4,0.478335365034,478.469808399,514,522
0.200629472733,,,98359969665.3,54423126361.4,,,514,522
0.301160097122,,,98430566339.7,54436659603.4,,,514,522
0.401570796967,,,98399875286.7,54387731709,,,514,522
0.501852989197,,,98150658285,54413005038.6,,,514,522
0.602178812027,,,98194427086.1,54392855295.9,,,515,522
0.70280122757,,,98207674250.1,54363278219.6,,,515,522
0.803261995316,,,98207275073.2,54302250984.5,,,515,522
0.904241085052,,,98202259355.4,54245073297.6,,,515,522
1.00493526459,,,98132680690.3,54217669929.2,,,515,522
1.10568475723,12592992,6526821,98134461796.8,54176656683.8,0.481710065408,474.343645088,515,522
```

As seen in the `TG-stats-sample.csv` file.  
