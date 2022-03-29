#!/bin/bash
# Description: Starts our forwarder application w/o debugging, with set parameters ...
# Parameters in use:
# -l , List of cores to run on.
# -m, Amount of memory to preallocate at startup.

# run by ./run.sh core_count
threads=$1
if [ 1 -gt $# ]; then
  echo "You forgot to give nr of threads."
  exit
fi

if (( $threads > 0 )); then
  cores=$(($threads-1))
  echo "using $threads threads"
  sudo ../fastclick/bin/click --dpdk -l 0-$cores -m 4G -a 11:00.0 --log-level=8 -- forwarder.click threads=$threads
else 
  echo 'Must use more than 0 cores.'
fi
