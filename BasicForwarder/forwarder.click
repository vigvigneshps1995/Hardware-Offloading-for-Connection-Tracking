//InCounter,OutCounter :: Counter()
PacketClassifier :: Classifier(12/0800, -) // [0] = only ip packets, [1] = all other protocols

//network interface
//network interface
nicIn  :: FromDPDKDevice (0, SCALE parallel, MAXTHREADS $threads);
nicOut :: ToDPDKDevice (0);

//Forwarder
nicIn -> PacketClassifier;

PacketClassifier[0] -> EtherMirror -> Strip(14) -> CheckIPHeader2 -> IPMirror -> Unstrip(14) -> nicOut;
PacketClassifier[1] -> Discard;


/* //Report
DriverManager(pause,
print "
============= $iface0 -> $iface1 stats ===========
Reciving packet  rate  (pps): $(InCounter0.rate)
Total # of   packets recived: $(InCounter0.count)
Sending packet  rate  (pps): $(OutCounter1.rate)
Total # of   packets sent: $(OutCounter1.count)
============= $iface1 -> $iface0 stats ===========
Reciving packet  rate  (pps): $(InCounter1.rate)
Total # of   packets recived: $(InCounter1.count)
Sending packet  rate  (pps): $(OutCounter0.rate)
Total # of   packets sent: $(OutCounter0.count)
==================================================
", wait 0.1s, stop); */
