#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <output_file>"
    exit 1
fi

# Input file containing results
input_file="$1"

latencyMean=0
latencyN=0
iopsMin=-1
iopsMax=-1
iopsMean=0
iopsSum=0
iopsN=0
iopsStddev=0
iterations=0

LC_NUMERIC="C"

while IFS= read -r line; do
	if [[ $line == *"latencyMean"* ]]; then
		# Extract latency mean from line
		mean=$(echo "$line" | grep -oP '[0-9.]+')

		# Add mean to the sum of previous means, increment latency N
		latencyMean=$(awk "BEGIN {printf \"%.2f\", $latencyMean + $mean}")
		latencyN=$((latencyN + 1))
	elif [[ $line == *"iopsMin"* ]]; then
		# Extract iopsMin from line
		min=$(echo "$line" | grep -oP '[0-9.]+')
		
		# If the variable has not been set, set variable
		# to first min value
		if [[ $iopsMin -eq -1 ]]; then
			iopsMin=$min
			continue
		fi

		# If this line is less than the min value,
		# set the min value to this line
		if [[ $min -lt $iopsMin ]]; then
			iopsMin=$min
		fi
	elif [[ $line == *"iopsMax"* ]]; then
		# Extract iopsMax from line
		max=$(echo $line | grep -oP '[0-9.]+')
		
		# If the variable has not been set, set variable
		# to first max value
		if [[ $iopsMax -eq -1 ]]; then
			iopsMax=$max
			continue
		fi

		# If this line is greater than the max value,
		# set the max value to this line
		if [[ $max -gt $iopsMax ]]; then
			iopsMax=$max
		fi		
	elif [[ $line == *"iopsMean"* ]]; then
		# Extract combo information and
		# split further into 'mean' and 'n'
		combo=$(echo $line | grep -oP '[0-9./]+')
		mean=$(echo $combo | cut -d'/' -f1)
		n=$(echo $combo | cut -d'/' -f2)

		iopsSum=$(awk "BEGIN {printf \"%.2f\", $iopsSum + $mean * $n}")
		iopsN=$((iopsN + n))
	elif [[ $line == *"iopsStddev"* ]]; then
		dev=$(echo $line | grep -oP '[0-9.]+')

		iopsStddev=$(awk "BEGIN {printf \"%.2f\", $iopsStddev + $dev * $dev}")
		iterations=$((iterations + 1))
	fi
done < "$input_file"

# Calculate final means
latencyMeans=$(awk "BEGIN {printf \"%.2f\", $latencyMean / $latencyN}")
iopsStddev=$(awk "BEGIN {printf \"%.2f\", $iopsStddev / $iterations}")
iopsStddev=$(echo "sqrt($iopsStddev)" | bc)

if [ $iopsN -ne 0 ]; then
    iopsMean=$(awk "BEGIN {printf \"%.2f\", $iopsSum / $iopsN}")
else
    iopsMean=0
fi

# Print the results
echo "    Average latency: $latencyMean ns"
echo "    Minimum IOPS: $iopsMin operations"
echo "    Average IOPS: $iopsMean operations"
echo "    Maximum IOPS: $iopsMax operations"
echo "    Average Standard Deviation: $iopsStddev"
