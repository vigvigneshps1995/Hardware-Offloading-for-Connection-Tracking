/*
 * Description: 
 * ------------
 * This fastClick program acts as a simple Ping-utility.
 * It receives ICMP Echo requests, and replies with ICMP Echo-reply.
 * It also responds to any ARP queries should the pinging host not
 * know of this host:IP.
 *
 * Arguments:
 * debug  - Enable/Disable more debugg printing, Default: false
 * srcDev - Source interface, Default: ens1f0
 * srcIP  - Source IP Address, Default: 10.1.1.90
 * srcMac - Source MAC Address, Default: b8:83:03:6f:43:42
 *
 * Co-Authored: Johan Edman & Vignesh Purushotham Srinivas 
*/

define ($debug false)
define ($srcDev ens1f0, $srcIP 10.1.1.90, $srcMac b8:83:03:6f:43:42);

// ======= //

// Classify packets according to EtherTypes,
//      [0] 0x0806 	Address Resolution Protocol (ARP), ARP Queries
//      [1] 0x0806 	Address Resolution Protocol (ARP), ARP Replies
//      [2] 0x0002  Internet Protocol version 4 (IPv4), IPv4 Packets
devInClassifier :: Classifier(12/0806 20/0001, 12/0806 20/0002, 12/0800, -);
ipAddrEchoClassifier :: IPClassifier(proto icmp && icmp type echo, -);

devIn :: FromDevice($srcDev, PROMISC true);
devInARPResponder :: ARPResponder($srcIP $srcMac);

devOut :: ToDevice($srcDev);

outQueue :: Queue;

// ======= //

devIn                                               // Classify packets according to specified filter
    -> Print("[Received]", -1, ACTIVE $debug)
    -> devInClassifier;

devInClassifier[0]                                  // Classified according to output [0], ARP Query
    -> Print("[ARP Packet, 0]", -1, ACTIVE $debug)  
    -> ARPPrint("[ARP Query]", ACTIVE $debug)
    -> devInARPResponder[0]  
    -> outQueue;

devInClassifier[1]                                  // Classified according to output [1], ARP Response   
    -> Print("[ARP Packet, 1]", -1, ACTIVE $debug)  
    -> ARPPrint("[ARP Response]", ACTIVE $debug)
    -> devInARPResponder[1] 
    -> outQueue;

devInClassifier[2]                                  // Classified according to output [2], IPv4 Packet
    -> Print("[IP Packet, 2]", -1, ACTIVE $debug)
    -> Strip(14)
    -> CheckIPHeader
    -> IPPrint("[IP]", ACTIVE $debug)
    -> ipAddrEchoClassifier; 

devInClassifier[3]                                  // Classified according to output [3], other
    -> Discard;                                     // i.e. discard non-IP, non-ARP packets


ipAddrEchoClassifier[0]                             // Packets that match ICMP, ECHO
    -> ICMPPingResponder
    -> IPPrint("[IP] ICMP Echo")
    -> Unstrip(14)
    -> EtherMirror
    -> Print("IP", ACTIVE $debug)
    -> outQueue;

ipAddrEchoClassifier[1]                             // Non ICMP packets.
    -> Print("[IP] Other", -1, ACTIVE $debug)
    -> Discard;

// ======= //

outQueue
    -> Print("[Sending]", -1, ACTIVE $debug)
    -> devOut;
