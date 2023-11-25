#!/bin/bash

# Install all dependencies
echo "Installing necessary components..."

echo "- Checking for <disk-read-tool>"
sudo apt-get install fio
echo
echo "- Checking for speedtest-cli"
sudo apt install speedtest-cli
echo

# Retrieve the specified disk testing file from
# fio_test.conf
disk_file="$(awk -F= '/filename/ {print $2}' fio_test.conf)"
network_output="net_results.txt"


####################
#  Disk Read Test  #
####################
echo "Beginning Disk Read Test (fio)"

#####################
#  Disk Write Test  #
#####################
echo "Beginning Disk Write Test (fio)"

##################
#  Network Test  #
##################
echo "Beginning Network Test (speedtest-cli)"
rm -f $network_output
./Network-speedtest-cli.sh $network_output
./speedtest-cli-average.sh $network_output
rm -f $network_output

####################
#  Tests Complete  #
####################
