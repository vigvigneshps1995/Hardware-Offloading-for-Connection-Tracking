/*
 * Description: 
 * ------------
 * This fastClick program acts as a simple Ping-utility.
 * It sends an ICMP Echo to the given destination IP address:
 * (1) If the host is known (MAC-IP), the ICMP ECHO is sent.
 *   When a reply is received, it is sent back into the ICMPPinger that prints stats.
 * (2) If the host is not known, the IP packet is buffered and an ARP query is sent. 
 *     When the ARP reply is received, it is cached and and any buffered IP packets are sent.
 *
 * Arguments:
 * debug  - Enable/Disable more debugg printing, Default: false
 * srcDev - Source interface, Default: ens1f0
 * srcIP  - Source IP Address, Default: 10.1.1.10
 * srcMac - Source MAC Address, Default: b8:83:03:6f:43:40
 * dstIP  - Destination IP Address, Default: 10.1.1.90
*/

define ($debug false);
define ($srcDev ens1f0, $srcIP 10.1.1.10, $srcMac b8:83:03:6f:43:40);
define ($dstIP 10.1.1.90);

// ======= //

// Classify packets according to EtherTypes,
//      [0] 0x0806 	Address Resolution Protocol (ARP), ARP Queries
//      [1] 0x0806 	Address Resolution Protocol (ARP), ARP Replies
//      [2] 0x0002  Internet Protocol version 4 (IPv4), IPv4 Packets

devClassifier :: Classifier(12/0806 20/0001, 12/0806 20/0002, 12/0800, -);
ipAddrEchoClassifier :: IPClassifier(proto icmp && icmp type echo-reply, -);

devIn :: FromDevice($srcDev, PROMISC true);
devOut :: ToDevice($srcDev);

devArpQuerier :: ARPQuerier($srcIP, $srcMac);
ICMPPinger :: ICMPPingSource($srcIP, $dstIP) 

outQueue :: Queue;

// ======= //

ICMPPinger                                            // Create an ICMP Echo
    -> IPPrint("[ICMP]", ACTIVE $debug)
    -> devArpQuerier                                  // If Host:IP known: push packet port 0, else ARP Query
    -> outQueue;

outQueue
    -> Print("[Sending]", -1, ACTIVE $debug)
    -> devOut;

// ======= //

devIn                                               // Classify packets according to specified filter     
    -> Print("[Received]", -1, ACTIVE $debug)
    -> devClassifier;

devClassifier[0]
    -> Print("[ARP Packet, 0]", -1, ACTIVE $debug)  
    -> ARPPrint("[ARP Query]", ACTIVE $debug)
    -> Discard;

devClassifier[1]
    -> Print("[ARP Packet, 1]", -1, ACTIVE $debug)  
    -> ARPPrint("[ARP Response]", ACTIVE $debug)
    -> [1]devArpQuerier;

devClassifier[2]                                    // Classified according to output [2], IPv4 Packet
    -> Print("[IP Packet, 2]", -1, ACTIVE $debug)
    -> Strip(14)
    -> CheckIPHeader
    -> IPPrint("[IP]", ACTIVE $debug)
    -> ipAddrEchoClassifier;

devClassifier[3]                                    // Classified according to output [3], other
    -> Discard;                                     // i.e. discard non-IP, non-ARP packets

ipAddrEchoClassifier[0]                             // Packets that match ICMP, ECHO-REPLY
    -> IPPrint("[ICMP]", ACTIVE $debug)
    -> ICMPPinger;                                  // Return reply to ICMPPinger to get stats.

ipAddrEchoClassifier[1]                             // Non ICMP packets.
    -> Print("[IP] Other", -1, ACTIVE $debug)
    -> Discard;
