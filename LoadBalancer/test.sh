#!/bin/bash

ssh csd21off@nslrack22.ssvl.kth.se "cd ~/HWConnTrackOff-21/LoadBalancer && bash -c 'run.sh 1'"& 2>/dev/null
sudo python3 test.py
ssh csd21off@nslrack22.ssvl.kth.se "sudo pkill click"
