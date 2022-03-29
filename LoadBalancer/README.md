# Configs
We have two config files. One for testing without DPDK and one which are to be used in the project that uses DPDK.

Package Generator port is set to 11:00.0
Forwarder port is set to 11:00.1

## loadbalancer-IMP.click
Is the file that listens on DPDK ports and uses a set number of threads. Must be run with a run script, as part of the config is generated and added in the run script.

## loadbalancer-pcap-IMP.click
Is our test version of the LB. It uses test.pcap and discard to test its implementation. Does not need a run script and does not use DPDK.

## loadbalancerhw-IMP.click
Is the file that listens on DPDK ports and uses a set number of threads. Offloads flows to hardware for classifying depending on imput.

# Run scripts
These scripts adds the missing parts to the configs and runs them.

## run.sh
The dedicated run script for the loadbalancer-IMP.click.
bash run.sh <nthreads> <flowtable_size>

## debug.sh
The dedicated script to debug loadbalancer-IMP.click.
bash debug.sh <nthreads> <flowtable_size>

## run_ho.sh
The dedicated run script for the loadbalancerhw-IMP.click.
bash run_ho.sh <nthreads> <flowtable_size> <offload_size> <offload_scheme> <offload_table>

## debug_ho.sh
The dedicated script to debug loadbalancerhw-IMP.click.
bash debug_ho.sh <nthreads> <flowtable_size> <offload_size> <offload_scheme> <offload_table>
