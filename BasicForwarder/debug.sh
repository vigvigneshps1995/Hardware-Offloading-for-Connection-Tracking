# Description: Starts our forwarder application in debug mode with set parameters ...
# Parameters in use:
# -l , List of cores to run on.
# -m, Amount of memory to preallocate at startup.

gdb --args /home/csd21off/fastclick/bin/click --dpdk -l 0-15 -m 8G -- forwarder.click
