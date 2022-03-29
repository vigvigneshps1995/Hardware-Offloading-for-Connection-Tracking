/**
 * Traffic Generator Module
 * ------------------------
 * Generates traffic by reading traces from MinDump files.
 * Stores metadata in the packets in order to be able to calculate latency.
 * 
 * TG Variants:
 * Size - Modify length of packets to (at the moment) a set of sizes (best sizes TBD).
 * Flows - Modify amount of flows by masking the 4 tuple (srcIP:srcPort - dstIP:dstPort).
 * 
 * Statistics are captured at @sampleRate Hz and output in csv format, according to TG-stats-sample.csv.


Arguments are (argName=value):

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
    DEFAULT /mnt/traces/csd21_traces/caida18-16x-1.mindump /mnt/traces/csd21_traces/caida18-16x-2.mindump
    OTHER /mnt/traces/csd21_traces/caida18-16x-1-np.mindump /mnt/traces/csd21_traces/caida18-16x-2-np.mindump

*/

define($verbose 3, $promisc false, $blocking true);
define($inPort 0, $srcMac b8:83:03:6f:43:40, $srcIPMask 00000000, $srcPortMask 0000);
define($outPort 0, $dstMac b8:83:03:6f:43:38, $dstIPMask 00000000, $dstPortMask 0000);
define($sizeOption 0);   // Size 0 = Default, Size 1 = 142 , Size 2 = 526, Size 3 = 1514

define($sampleRate 10, $fileName TG-stats.csv);
define($inFileOne "/mnt/traces/csd21_traces/caida18-16x-1-np.mindump", $inFileTwo "/mnt/traces/csd21_traces/caida18-16x-2-np.mindump")

DPDKInfo(4194303);

/**
 * Traffic Generator Element
*/
elementclass TrafficGenerator { $trace, $details, $elementId, $srcEthAddr, $dstEthAddr |
    recorder :: RecordTimestamp(OFFSET 54, N 268435456, DYNAMIC false, COUNTER numPack) // Ether 14 + IP 20 + TCP/UDP 20
    numPack :: NumberPacket(OFFSET 54)

    FromMinDump($trace, STOP 1, DPDK 1) // No ethernet headers are present, reads raw IP packets.
        /* TG Variant Flows: Modify srcIP:srcPort - dstIP:dstPort */
        -> StoreData(12, \<c03881b2>, MASK \<$srcIPMask>)   // Src IP Address: 192.56.129.178
        -> StoreData(16, \<b28138c0>, MASK \<$dstIPMask>)   // Dst IP Address: 178.129.56.192
        -> StoreData(20, \<1A85>, MASK \<$srcPortMask>)     // Src Port: 6789
        -> StoreData(22, \<2694>, MASK \<$dstPortMask>)     // Dst Port: 9876

        /* TG Variant Size: Send to different output depending on sizeOption variable */
        -> sw :: Switch(OUTPUT $sizeOption)
            sw[0]   // Size Option 0: Unchanged - Use non 'np' version of MinDump with this. Or Pad(MAXLENGTH 1518)
                -> Pad(0)
                -> ResetIPChecksum()
                -> EtherEncap(0x0800, $srcEthAddr, $dstEthAddr)
                -> StoreData(OFFSET 62, DATA $elementId)
                -> numPack	
                -> recorder
                -> [0]output;                  
            sw[1]   // Size Option 0: Length 128 bytes
                -> Pad(LENGTH 128)
                -> StoreData(OFFSET 2, DATA \<0080>)
                -> ResetIPChecksum()
                -> EtherEncap(0x0800, $srcEthAddr, $dstEthAddr)
                -> StoreData(OFFSET 62, DATA $elementId)
                -> numPack	
                -> recorder
                -> [0]output;            
            sw[2]   // Size Option 1: Length 512 bytes
                -> Pad(LENGTH 512)
                -> StoreData(OFFSET 2, DATA \<0200>)
                -> ResetIPChecksum()
                -> EtherEncap(0x0800, $srcEthAddr, $dstEthAddr)
                -> StoreData(OFFSET 62, DATA $elementId)
                -> numPack	
                -> recorder
                -> [0]output;
            sw[3]   // Size Option 2: Length 1500 bytes
                -> Pad(LENGTH 1500)
                -> StoreData(OFFSET 2, DATA \<05DC>)
                -> ResetIPChecksum()
                -> EtherEncap(0x0800, $srcEthAddr, $dstEthAddr)
                -> StoreData(OFFSET 62, DATA $elementId)
                -> numPack	
                -> recorder
                -> [0]output;
}


// Generator Thread Elements
TrafficGenThread1 :: TrafficGenerator($inFileOne, false, \<98>, $srcMac, $dstMac);
TrafficGenThread2 :: TrafficGenerator($inFileTwo, false, \<99>, $srcMac, $dstMac);

// Generator
GenOutPort :: AverageCounterIMP()
    -> ToDPDKDevice(PORT $outPort, BLOCKING $blocking, VERBOSE $verbose, BURST 32, TIMEOUT 0, TCO 1, IPCO 1, UCO 1);

TrafficGenThread1
    -> GenOutPort;
TrafficGenThread2
    -> GenOutPort;

/**
 * Sink Element
*/
elementclass Sink {$elementId, $recElement|
    -> Strip(14)
    -> CheckNumberPacket(OFFSET 40, COUNT 268435456)
    -> timeDiff :: TimestampDiff(RECORDER $recElement, N 268435456, SAMPLE 1000)
    -> Discard;
}

// Sink Thread Elements
SinkThread1 :: Sink(\<98>, TrafficGenThread1/recorder)
SinkThread2 :: Sink(\<99>, TrafficGenThread2/recorder)

// Sink
fromDevice::FromDPDKDevice(PORT $inPort, PROMISC $promisc, VERBOSE $verbose, SCALE parallel, MAXTHREADS 2, NDESC 1024, TCO 1, UCO 1, IPCO 1)
    -> inCounter :: AverageCounterIMP()
    -> threadClassifier :: Classifier(62/98, 62/99, -)  // ethernet 14 + 20 IP + 20 TCP/UDP + 8 packet number
    
threadClassifier[0] 
    -> SinkThread1 
threadClassifier[1]
    -> SinkThread2
threadClassifier[2]
    -> unknown::AverageCounterIMP
    -> Discard

/* ===== */

StaticThreadSched(TrafficGenThread1 0, TrafficGenThread2 1, SinkThread1 0, SinkThread2 1) 

// Handles output to file
Script(TYPE ACTIVE,
    write inCounter.reset,
    write GenOutPort.reset,

    set sampleFreq $(div 1 $sampleRate),
    set loopCount 0,
    set txPktCountPrev 0,
    set rxPktCountPrev 0,
    set packetLossPrev 0,
    set latencyPrev 0,

    wait 1s,
    set startTime $(now),
    
    label start,
    wait $(div 1 $sampleRate),
    set runTime $(sub $(now) $startTime),

    set txRate $(GenOutPort.link_rate),
    set rxRate $(inCounter.link_rate),
    set latency95 $(avg $(SinkThread1/timeDiff.perc95) $(SinkThread2/timeDiff.perc95)),
    set latency99 $(avg $(SinkThread1/timeDiff.perc99) $(SinkThread2/timeDiff.perc99)),

    goto everyTime $(ne $loopCount 0),

    set txCount $(sub $(GenOutPort.count) $txPktCountPrev),
    set rxCount $(sub $(inCounter.count) $rxPktCountPrev),
    set txPktCountPrev $(GenOutPort.count),
    set rxPktCountPrev $(inCounter.count),
    
    set packetLoss $(div $(sub $txCount $rxCount) $txCount),
    set latency $(avg $(SinkThread1/timeDiff.average) $(SinkThread2/timeDiff.average)),

    print >>$fileName "$runTime,$txCount,$rxCount,$txRate,$rxRate,$packetLoss,$latency,$latency95,$latency99",
    setq loopCount $(mod $(add $loopCount 1) $sampleRate),
    goto start,
    
    label everyTime,
    print >>$fileName "$runTime,,,$txRate,$rxRate,,,$latency95,$latency99",
    setq loopCount $(mod $(add $loopCount 1) $sampleRate),
    goto start 
);

DriverManager(
    wait,
    read fromDevice.xstats,
    print "Unknown packets received: $(unknown.count)",
    print "TX link rate: $(GenOutPort.link_rate)",
    print "TX bit rate: $(GenOutPort.bit_rate)",
    print "TX packet rate: $(GenOutPort.rate)",
    print "RX link rate: $(inCounter.link_rate)",
    print "RX packet rate: $(inCounter.rate)",
    print "",
    print "Packets (sent/received): ($(GenOutPort.count) / $(inCounter.count))",
    print "Packet loss: $(div $(sub $(GenOutPort.count) $(inCounter.count)) $(GenOutPort.count)) %)",
);
