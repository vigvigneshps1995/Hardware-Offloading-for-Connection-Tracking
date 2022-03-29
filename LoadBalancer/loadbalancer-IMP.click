flowIMP :: FlowIPManagerIMP(TIMEOUT 0, CAPACITY $capacity);
flowlb :: FlowIPLoadBalancer(VIP 10.1.1.2, DST 10.1.1.10, DST 10.1.1.11, DST 10.1.1.12);

// Load Balancer
FromDPDKDevice(0, SCALE parallel, MAXTHREADS $threads, PAINT_QUEUE 1) ->
    EtherMirror ->
	Strip(14) -> 
	CheckIPHeader(CHECKSUM false) -> 
	flowIMP -> 
	flowlb -> 
	ResetIPChecksum(L4 true) ->
	Unstrip(14) ->
	ToDPDKDevice(0, BLOCKING true, IPCO 1, TCO 1, UCO 1);
