#!/bin/bash

# Install all dependencies
echo "Installing necessary components..."
sudo apt-get install jq

echo "- Checking for fio"
sudo apt-get install fio

echo "- Checking for speedtest-cli"
sudo apt install speedtest-cli


# Respective output files
session_output="$(date +"%Y-%m-%d_%H:%M:%S")"
read_output="read_output.txt"
write_output="write_output.txt"
network_output="net_results.txt"


####################
#  Disk Read Test  #
####################
echo "Beginning Disk Read Test (fio)"
echo "=== Disk Read Test ===" >> "$session_output"
./fio-read.sh $read_output
./fio-average.sh $read_output >> "$session_output"

#####################
#  Disk Write Test  #
#####################
echo "Beginning Disk Write Test (fio)"
echo "=== Disk Write Test ===" >> "$session_output"
./fio-write.sh $write_output
./fio-average.sh $write_output >> "$session_output"

##################
#  Network Test  #
##################
echo "Beginning Network Test (speedtest-cli)"
echo "=== Network Test ==="
rm -f $network_output
./Network-speedtest-cli.sh $network_output
./speedtest-cli-average.sh $network_output >> "$session_output"
rm -f $network_output

####################
#  Tests Complete  #
####################
echo
echo ".----------------------------."
echo "|     Testing Complete!      |"
echo ".----------------------------."
echo
echo "Session results are stored in $session_output"
