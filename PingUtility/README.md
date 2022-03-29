## FastClick Ping  
A ping-like utility that tests connectivity between machines.  
Consists of two parts, the `fastPing.click` and the `fastPong.click`.  

### Quickstart  
On the second host (the one to be pinged), start the `fastPong.click`,  
```shell
sudo click fastPong.click
```

On the first host (the one to ping), start the `fastPing.click`,  
```shell
sudo click fastPing.click
```

Make sure to configure any arguments so that configuration matches your setup.  

If all works then output should be something like this:  
```shell
# fastPing
ICMPPinger :: ICMPPingSource: 0 bytes from 10.0.0.90: icmp_seq=1 ttl=255 time=0.324 ms
ICMPPinger :: ICMPPingSource: 0 bytes from 10.0.0.90: icmp_seq=2 ttl=255 time=0.266 ms
ICMPPinger :: ICMPPingSource: 0 bytes from 10.0.0.90: icmp_seq=3 ttl=255 time=0.285 ms
ICMPPinger :: ICMPPingSource: 3 packets transmitted, 3 received, 0% packet loss
ICMPPinger :: ICMPPingSource: rtt min/avg/max/mdev = 0.266/0.291/0.324/0.031
```

```shell
# fastPong
[IP] ICMP Echo: 1633433212.867875402: 10.0.0.90 > 10.0.0.10: icmp echo-reply (0, 1)
[IP] ICMP Echo: 1633433213.868181838: 10.0.0.90 > 10.0.0.10: icmp echo-reply (0, 2)
[IP] ICMP Echo: 1633433214.868575674: 10.0.0.90 > 10.0.0.10: icmp echo-reply (0, 3)
```

See respective click files for arguments and description of events handled.  