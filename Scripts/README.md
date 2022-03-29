# Scripts
This repository contains all scripts used for setup, data gathering and visualisation.

## setup-*.sh
These scripts setups the environment. Here we setup ip bindings.

## run_test.sh
This script automates testing and need ssh-keys to be setup. It is designed to run from a tmux session on nslrack21 (TG host). It ssh in to nslrack22 (LB host) and starts the basic forwarder, load balancer or load balancer with offloading. Then it starts the traffic generator on nslrack21 and waits for it to run out of packeges.

It starts the applications, collects the data, formats it for gnuplot.

Usage: `./run_test.sh [optional flags]`

These are the flags:
```
 -r <INT>    - How many test runs should be run. Default: 1
 -l <INT>    - Use loadbalancer, options 0 (use BF) / 1 (use LB) / 2 (use LB w. HO). Default: 1
 -c <INT>    - Sets amount of cores to run. If run with batching sets maximum. Default: 8
 -b          - Activates batching which makes script run test through different core counts. Starts at 1
 -f <INT>    - How many flows the traffic generator should generate. Default: 1 (Not Implemented)
 -s <INT>    - Hash table size of the load balancer. Default: 2'000'000
 -i <STRING> - Set uniqe identifier. Default: %y-%m-%dT%H%M
 -o <INT>    - Offload size
 -z <INT>    - Offload scheme 
 -t <INT>    - Table (0 or 1)  
```

### merge_runs.py
Simple script that takes the multi-run files outputed by the generator and averages the value from all runs at time x. Then saver the result in a file named as the input but with `-avg` appended to it.

Usage: `./merge_runs.py <filepath>`

### Requirements
- bash, python3
- ssh with configured ssh-key from nslrack21 to nslrack22

## run_all_tests.sh
A batching script for running multiple runs of run_test.sh after eachother. The ide ais to have a file with all tests we are interested in in one place that can be added to, commented in or uncommented depending on the needed tests at the time.

Usage: `./run_all_tests.sh`

---

### Off-topic SSHFS
basic use: 
`sshfs user@domain:. ~/folder`
This mounts the home folder of user at domain at the foldes 'folder'. 'folder' have to be created before the command is run or it will complain.

If you have added a public key to the server so you have passwordless login and have the propper entry in ~/.ssh/config you can shorten the above command to:
`sshfs server_name:. ~/folder`

example of config entry:
```
 Host nslrack21 nslrack21.ssvl.kth.se
   HostName nslrack21.ssvl.kth.se
   PreferredAuthentications publickey
   IdentityFile ~/.ssh/rsa_key
   User csd21off
 
 Host nslrack22 nslrack22.ssvl.kth.se
   HostName nslrack22.ssvl.kth.se
   PreferredAuthentications publickey
   IdentityFile ~/.ssh/rsa_key
   User csd21off
```

and with this you can mount the servers home folders with:
`sshfs nslrack21:. ~/folder21`
and
`sshfs nslrack22:. ~/folder22`

The rest of the system should act like this is just another folder which makes it easy to work with the tools you are used to. Just remmember that the files can still be accessed and modifid by everyone, so write conflicts are still a risk.
