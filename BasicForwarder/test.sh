#!/bin/bash
# Description: A shell scripts that acts as test for the forwarder application.
# It starts off the forwarder by calling our shell script 'run.sh' and then verifies that traffic has been received.
sh run.sh &
sleep 10
pkill click;
size1=($(du dump1.pcap))
size2=($(du dump2.pcap))
if [[ ${size1[0]} -gt 4 ]] || [[ ${size2[0]} -gt 4 ]]; then
	echo "Basic forwarder worked successfully"
else
	echo "Basic forwarder did not work as expected"
fi
rm -f dump1.pcap
rm -f dump2.pcap
