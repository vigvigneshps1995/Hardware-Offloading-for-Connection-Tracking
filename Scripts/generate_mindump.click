define($INPUT /mnt/traces/caida-18/caida18-16x.pcap)
define($OUTPUT1 /mnt/traces/csd21_traces/caida18-16x-1.mindump)
define($OUTPUT2 /mnt/traces/csd21_traces/caida18-16x-2.mindump)


in::FromDump($INPUT, STOP true, FORCE_IP true)
out1::ToMinDump($OUTPUT1)
out2::ToMinDump($OUTPUT2)


in
-> Pad(MAXLENGTH 1518)
-> Strip(14)
-> CheckIPHeader(CHECKSUM false)
-> rr::RoundRobinSwitch

rr[0] -> out1
rr[1] -> out2
