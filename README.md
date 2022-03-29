# Network configuration.
```
nslrack21: 
  role: generator/sink (TG),
  100Gbit dev: ens1f0 & ens1f1, 
  ens1f0 ip: 192.168.100.21/24 & 10.1.1.1/24 (primarily used)
  ens1f1 ip: 192.168.101.21/24 & 10.1.2.1/24
  en1 ip: 192.168.3.21/24 (servers to server ssh)

nslrack22:
  role: Load balancer (DUT),
  100Gbit dev: ens1f0 & ens1f1, 
  ens1f0 ip: 192.168.100.22/24 & 10.1.1.2/24 (primarily used)
  ens1f1 ip: 192.168.101.22/24 & 10.1.2.2/24
  en1 ip: 192.168.3.22/24 (servers to server ssh)
```
