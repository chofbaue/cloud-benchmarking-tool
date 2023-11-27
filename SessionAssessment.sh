#!/bin/bash

# Install all dependencies

dep=0

#echo "Installing necessary components..."
#sudo apt-get install jq
if ! command -v jq --help &> /dev/null; then
    echo "Missing dependency: jq"
    dep=1
fi

#echo "- Checking for fio"
#sudo apt-get install fio
if ! command -v fio --help &> /dev/null; then
    echo "Missing dependency: fio"
    dep=1
fi

#echo "- Checking for speedtest-cli"
#sudo apt install speedtest-cli
if ! command -v speedtest-cli --help &> /dev/null; then
    echo "Missing dependency: speedtest-cli"
    dep=1
fi

if [ $dep -eq 1 ]; then
    echo "Install all required dependencies, then try again."
    exit 1
fi

# Respective output files
session_output="$(date +"Session-%Y-%m-%d_%H:%M:%S")"
read_output="read_output.txt"
write_output="write_output.txt"
network_output="net_results.txt"

# Remove files before testing (if they exist)
rm -f $read_output
rm -f $write_output
rm -f $network_output

####################
#  Disk Read Test  #
####################
echo "Beginning Disk Read Test (fio)"
echo "=== Disk Read Test ===" >> "$session_output"
./fio-read.sh $read_output
./fio-average.sh $read_output >> "$session_output"
#rm -f $read_output

#####################
#  Disk Write Test  #
#####################
echo "Beginning Disk Write Test (fio)"
echo "=== Disk Write Test ===" >> "$session_output"
./fio-write.sh $write_output
./fio-average.sh $write_output >> "$session_output"
#rm -f $write_output

##################
#  Network Test  #
##################
echo "Beginning Network Test (speedtest-cli)"
echo "=== Network Test ===" >> "$session_output"
./Network-speedtest-cli.sh $network_output
./speedtest-cli-average.sh $network_output >> "$session_output"
#rm -f $network_output

####################
#  Tests Complete  #
####################
echo
echo ".----------------------------."
echo "|     Testing Complete!      |"
echo ".----------------------------."
echo
echo "Session results are stored in $session_output"
