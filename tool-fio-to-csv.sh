#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input_file> <cloud_provider> <[READ,WRITE]>"
    exit 1
fi

# Input file
input_file="$1"
method="$2"
operation=""

if [ "$3" == "READ" ]; then
   operation="fio_read_"
fi

if [ "$3" == "WRITE" ]; then
    operation="fio_write_"
fi

if [ "$operation" == "" ]; then
    echo "$0: Unknown operation: Operation is either \"READ\" or \"WRITE\""
    exit 1
fi

latencyMeanValuesOutput=$operation\latencyMeanValues.txt
iopsMinValuesOutput=$operation\iopsMinValues.txt
iopsMaxValuesOutput=$operation\iopsMaxValues.txt
iopsMeanValuesOutput=$operation\iopsMeanValues.txt
iopsStddevValuesOutput=$operation\iopsStddevValues.txt

rm -f "$latencyMeanValuesOutput"
rm -f "$iopsMinValuesOutput"
rm -f "$iopsMaxValuesOutput"
rm -f "$iopsMeanValuesOutput"
rm -f "$iopsStddevValuesOutput"

latencyMeanValues=""
iopsMinValues=""
iopsMaxValues=""
iopsMeanValues=""
iopsStddevValues=""

LC_NUMERIC="C"

while IFS= read -r line; do
    if [[ $line == *"latencyMean"* ]]; then
        #if [[ $latencyMeanValues != "" ]]; then
        #    latencyMeanValues="$latencyMeanValues,"
        #fi

        mean=$(echo $line | grep -oP '[0-9.]+')

        echo "$method,$mean" >> "$latencyMeanValuesOutput"

        #latencyMeanValues="$latencyMeanValues$mean"
    elif [[ $line == *"iopsMin"* ]]; then
        #if [[ $iopsMinValues != "" ]]; then
        #    iopsMinValues="$iopsMinValues,"
        #fi

        min=$(echo $line | grep -oP '[0-9.]+')

        echo "$method,$min" >> "$iopsMinValuesOutput"

        #iopsMinValues="$iopsMinValues$min"
    elif [[ $line == *"iopsMax"* ]]; then
        #if [[ $iopsMaxValues != "" ]]; then
        #    iopsMaxValues="$iopsMaxValues,"
        #fi

        max=$(echo $line | grep -oP '[0-9.]+')

        echo "$method,$max" >> "$iopsMaxValuesOutput"

        #iopsMaxValues="$iopsMaxValues$max"
    elif [[ $line == *"iopsMean"* ]]; then
        #if [[ $iopsMeanValues != "" ]]; then
        #    iopsMeanValues="$iopsMeanValues,"
        #fi

        mean=$(echo $line | grep -oP '[0-9./]+' | cut -d'/' -f1)

        echo "$method,$mean" >> "$iopsMeanValuesOutput"

        #iopsMeanValues="$iopsMeanValues$mean"
    elif [[ $line == *"iopsStddev"* ]]; then
        #if [[ $iopsStddevValues != "" ]]; then
        #    iopsStddevValues="$iopsStddevValues,"
        #fi

        dev=$(echo $line | grep -oP '[0-9.]+')

        echo "$method,$dev" >> "$iopsStddevValuesOutput"

        #iopsStddevValues="$iopsStddevValues$dev"
    fi
done < "$input_file"

#echo
#echo $latencyMeanValues
#echo $latencyMeanValues >> "$latencyMeanValuesOutput"
#echo
#echo $iopsMinValues
#echo $iopsMinValues >> "$iopsMinValuesOutput"
#echo
#echo $iopsMaxValues
#echo $iopsMaxValues >> "$iopsMaxValuesOutput"
#echo
#echo $iopsMeanValues
#echo $iopsMeanValues >> "$iopsMeanValuesOutput"
#echo
#echo $iopsStddevValues >> "$iopsStddevValuesOutput"
