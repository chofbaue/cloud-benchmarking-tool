#!/bin/bash

# Check if missing output file
if [ -z "$1" ]; then
    echo "Usage: $0 <output_file>"
    exit 1
fi

output="$1"
config_file="fio_test.conf"
test_file="$(egrep 'filename=[^ ]+' $config_file | cut -d'=' -f2)"
iterations=30

# Perform testing
for ((i = 1; i <= iterations; i++)); do
    echo "Testing iteration $i/$iterations..."
    echo "=== Iteration $i ===" >> "$output"

    # Extract trial output in JSON format
    # If using JSON format, might need to install jq as well
    raw=$(fio --output-format=json $config_file)
    t=$(echo $raw | jq '.jobs[0].write')

    # Parse JSON into latency (in NS) and iops statistics
    lat_ns=$(echo $t | jq '.lat_ns.mean')
    iops_min=$(echo $t | jq '.iops_min')
    iops_max=$(echo $t | jq '.iops_max')
    iops_mean=$(echo $t | jq '.iops_mean')
    iops_stddev=$(echo $t | jq '.iops_stddev')
    iops_samples=$(echo $t | jq '.iops_samples')

    # Output information into stdout
    echo "    Latency (avg): $lat_ns"
    echo "    IOPS (min): $iops_min"
    echo "    IOPS (max): $iops_max"
    echo "    IOPS (avg): $iops_mean"
    echo "    IOPS (stddev): $iops_stddev"
    echo "    IOPS (N): $iops_samples"

    # Output information into output file

    echo "latencyMean $lat_ns" >> "$output"
    echo "iopsMin $iops_min" >> "$output"
    echo "iopsMax $iops_max" >> "$output"
    echo "iopsMean $iops_mean/$iops_samples" >> "$output"
    echo "iopsStddev $iops_stddev" >> "$output"
done

# Clean up test file
echo "Removing \"$test_file\""
rm "$test_file"
