from scapy import all as scapy
from scapy.sendrecv import sr
from time import sleep

iface="ens1f0"
srcIP="10.1.1.1"
dstIP="10.1.1.2"
srcMAC="b8:83:03:6f:43:40"
dstMAC="b8:83:03:6f:43:38"
flow1IP="10.220.0.1"
flow2IP="10.220.0.2"
flow3IP="10.220.0.3"
flowDst=[0,0,0]
flowNum=[3,1,2]
verbose=False

print("Destination 1 IP: {}".format(flow1IP))
print("Destination 2 IP: {}".format(flow2IP))
print("Destination 3 IP: {}".format(flow3IP))
sleep(1)
flowCommon=scapy.Ether(src=srcMAC,dst=dstMAC)/scapy.IP(src=srcIP,dst=dstIP)
f1P=flowCommon/scapy.TCP(sport=55555,dport=5000)
f2P=flowCommon/scapy.TCP(sport=55556,dport=5000)
f3P=flowCommon/scapy.TCP(sport=55557,dport=5000)

def countFlow(pkt):
    dst=pkt.getlayer(scapy.IP).dst
    if dst == flow1IP:
        flowDst[0] = flowDst[0]+1
    elif dst == flow2IP:
        flowDst[1] = flowDst[1]+1
    elif dst == flow3IP:
        flowDst[2] = flowDst[2]+1
    print("Receive packet destination IP: {}".format(dst))
    print(flowDst)

t=scapy.AsyncSniffer(iface=iface,filter="dst net 10.220.0.0/24",prn=lambda x: countFlow(x))#lambda x: print(x.getlayer(scapy.IP).dst))
t.start()
print("Sending 3 packets in first flow, 1 packet in second flow, and 2 packets in third flow")

sleep(1)
print("Send packet flow 1")
scapy.sendp(f1P,iface=iface, verbose=verbose)
sleep(2)
print("Send packet flow 2")
scapy.sendp(f2P,iface=iface, verbose=verbose)
sleep(2)
print("Send packet flow 1")
scapy.sendp(f1P,iface=iface, verbose=verbose)
sleep(2)
print("Send packet flow 3")
scapy.sendp(f3P,iface=iface, verbose=verbose)
sleep(2)
print("Send packet flow 1")
scapy.sendp(f1P,iface=iface, verbose=verbose)
sleep(2)
print("Send packet flow 3")
scapy.sendp(f3P,iface=iface, verbose=verbose)
if flowNum == flowDst:
    print("Success!")
