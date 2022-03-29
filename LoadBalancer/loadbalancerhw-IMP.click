from :: FromDPDKDevice(0, SCALE parallel, MAXTHREADS $threads, PAINT_QUEUE 1, VERBOSE 99);
flowIMP :: FlowIPManagerHW(DEV from, CAPACITY $capacity, OFFCAP $offcap, VERBOSE 1, OFFLOAD_SCHEME $offtype, OFFLOAD_THRESHOLD $offthresh, TABLE $table);
//flowIMP :: FlowIPManagerHW(CAPACITY $capacity, OFFCAP $offcap);
flowlb :: FlowIPLoadBalancer(VIP 10.1.1.2, DST 10.1.1.10, DST 10.1.1.11, DST 10.1.1.12);

// Load Balancer
	from ->
   	EtherMirror ->
	Strip(14) -> 
	CheckIPHeader(CHECKSUM false) ->
	flowIMP -> 
	flowlb -> 
	Unstrip(14) ->
	ToDPDKDevice(0);
//Script( read from.count, read flowIMP.count, read flowIMP.hw_matched_count, read flowIMP.offloaded_count, wait 1s, loop)
