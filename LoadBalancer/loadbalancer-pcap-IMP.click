cnt0,cnt1,cnt2 :: AverageCounter;

flowIMP :: FlowIPManagerIMP(TIMEOUT 0);
flowlb :: FlowIPLoadBalancer(VIP 10.221.0.1, DST 10.220.0.1, DST 10.220.0.2, DST 10.220.0.3);

classifier :: IPClassifier(dst host 10.220.0.1,dst host 10.220.0.2,dst host 10.220.0.3);

FromDump("test.pcap", STOP true) -> 
	//Print("Incoming",-1) -> 
	Strip(14) -> 
	CheckIPHeader(CHECKSUM false) -> 
	//Print("Stripped In",-1) -> 
	flowIMP -> 
	flowlb -> 
	//Print("Balanced",0) -> 
	classifier;

classifier[0] -> Print("1",-1) -> Unstrip(14) -> cnt0 -> Discard();
classifier[1] -> Print("2",-1) -> Unstrip(14) -> cnt1 -> Discard();
classifier[2] -> Print("3",-1) -> Unstrip(14) -> cnt2 -> Discard();

DriverManager(pause, print "$(threads) $(cnt0.count),$(cnt1.count),$(cnt2.count)", wait 0.1s, stop);
