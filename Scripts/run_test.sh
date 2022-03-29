#!/bin/bash

# Usage ./run_test.sh [flags]
# Uses ~/HWConnTrackOff-21 folder on servers. Make sure it is set on the correct branch
# on both servers before use.

help_text() {
  echo -e "
  -r <INT>    - How many test runs should be run. Default: 1
  -l <INT>    - Use loadbalancer, options 0 (use BF) / 1 (use LB) / 2 (use LB w. HO). Default: 1
  -c <INT>    - Sets amount of cores to run. If run with batching sets maximum. Default: 8
  -b          - Activates batching which makes script run test with 1 2 4 and 8 cores.
  -f <INT>    - How many flows the traffic generator should generate, options 0 (unfiltered) / 2 (million flows) / 8 (million flows). Default: 0
  -s <INT>    - Hash table size, in millions, of the load balancer. Default: 2 (= 2 milion)
  -i <STRING> - Set uniqe identifier. Default: %y-%m-%dT%H%M
  -o <INT>    - Offload table size(max number of flows to offload).
  -z <INT>    - Offload scheme. 1 = flow size (bytes), 2 = number of packets, 3 = flow duration, 4 = first offload size flows (naive offloading).
  -n <INT>    - Offload threshold. When offload scheme is 1, 2 or 3, then flows will be oflloaded when the flow statistics reach the threshold. 
  -t <INT>    - Offload table 
  "
}

# Default Values
loadbalancer=1                      # use loadbalancer as default.
core_max=8                          # 1 indexed
batching=0                          # no batching as default
core_min=1                          # 1 indexed
runs=1
flows=0                             # milions
table_size=2                        # 2 million
time=$(date +%y-%m-%dT%H%M)         # added to file names to not overwrite different runs.
project_folder=~/andreas  	    # Project root folder location. Helps against spelling errors.
offload_size=1				
offload_scheme=0
offload_threshold=0
table=1


while getopts "hl:r:c:bf:s:i:o:z:n:t:" OPTION # lists all options : after meens it's expecting a value
do
    case $OPTION in
    h) 
      help_text
      exit
      ;;
    l) # use loadbalancer (1) otherwise forwarder (0)
      loadbalancer=$OPTARG
      ;;
    r) # -r runs
      runs=$OPTARG
      ;;
    c) # -c cores
      core_max=$OPTARG
      ;;
    b) # -b batching
      batching=1
      ;;
    f) # -f flows
      flows=$OPTARG
      ;;
    s) # -s table_size
      table_size=$OPTARG
      ;;
    i) # -i identifier
      time=$OPTARG
      ;;
    o)
      offload_size=$OPTARG
      ;;
    z)
      offload_scheme=$OPTARG
      ;;
    n)
      offload_threshold=$OPTARG
      ;;
    t)
      table=$OPTARG
      ;;
    *) # -* nonexisting flag catch all
      help_text
      exit
      ;;
    esac
done

if [ $batching = 1 ]; then
  core_range="1 2 4 8"
else
  core_range=$core_max
fi

if [[ "$table" -eq "1" ]];then
	offmul=1000000
else
	offmul=1000
fi

echo "
Options used:
  Runs:           $runs
  LoadBalancer:   $loadbalancer
  Cores:          $core_range
  Flows:          $flows
  Hashtable Size: $table_size
  Time:           $time
  Offload size:   $offload_size
  Offload scheme: $offload_scheme
  Offload thresh: $offload_threshold
  Table:	  $table
"

cd $project_folder/Scripts/
mkdir Data -p
mkdir Results -p

### Run Click on the servers to generate and fetch data. ###
for cores in $core_range; do
  echo "### Starting test with $cores cores out of $core_range ###"
  if [ $loadbalancer = 0 ]; then output_file="$time-BF-c$cores-F$flows"
  elif [ $loadbalancer = 1 ]; then output_file="$time-LB-c$cores-ht$(($table_size))M-T$table-F$flows"
  elif [ $loadbalancer = 2 ]; then output_file="$time-LBwHO-c$cores-ht$(($table_size))M-$(($offload_size))M-R$offload_scheme-T$table-F$flows-#"
  fi
  echo "### Saving output to Data/$output_file.csv ###"

  for run in $(seq 1 $runs); do
    echo "### Starting run $run of $runs for $output_file ###"

    # (nslrack22)
    if [ $loadbalancer = 0 ]; then # Forwarder
      ssh csd21off@192.168.3.22 "cd $project_folder/BasicForwarder && ./run.sh $cores" &
    elif [ $loadbalancer = 1 ]; then # Load Balancer
      echo "Output from LB is piped to the void so it wont be shown here."
      ssh csd21off@192.168.3.22 "cd $project_folder/LoadBalancer && ./run_ho.sh $cores $(($table_size*1000000)) 1 0 $table >/dev/null 2>&1 &" &
    elif [ $loadbalancer = 2 ]; then # Load Balancer with hardware offloading
      ssh csd21off@192.168.3.22 "cd $project_folder/LoadBalancer && ./run_ho.sh $cores $(($table_size*1000000)) $(($offload_size*$offmul)) $offload_scheme $offload_threshold $table >/dev/null 2>&1 &" &
    fi
    sleep 30

    # (nslrack21) Traffic Generator - Runs in forground to make the script wait.
    # If load balancer with hardware offloading -> run 2 times.
    if [ $loadbalancer = 2 ]; then
	    cd $project_folder/TrafficGenerator && ./run_generator.sh $output_file"1" $flows && sleep 30 && ./run_generator.sh $output_file"2" $flows
    else
    	cd $project_folder/TrafficGenerator && ./run_generator.sh $output_file $flows
    fi

    echo "### Cleaning up run $run ###"
    sudo pkill click
    ssh csd21off@192.168.3.22 "sudo pkill click"
    sleep 20 # To give things time to clean up propper.
  done

  echo "### Mergeing data from $cores core runs for $output_file ###"
  cd $project_folder/Scripts/
  if [ $loadbalancer = 2 ]; then
  	./merge_runs.py Data/$output_file"1".csv && ./merge_runs.py Data/$output_file"2".csv
  else
	./merge_runs.py Data/$output_file.csv
  fi
done

