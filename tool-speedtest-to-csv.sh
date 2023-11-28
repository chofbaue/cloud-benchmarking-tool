#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_file> <cloud_provider>"
    exit 1
fi

# Input file
input_file="$1"
method="$2"

pingValuesOutput="speedtest_pingValues.txt"
downloadValuesOutput="speedtest_downloadValues.txt"
uploadValuesOutput="speedtest_uploadValues.txt"

rm -f "$pingValuesOutput"
rm -f "$downloadValuesOutput"
rm -f "$uploadValuesOutput"

LC_NUMERIC="C"

while IFS= read -r line; do
    if [[ $line == *"Ping"* ]]; then
        ping=$(echo $line | grep -oP '[0-9.]+')

        echo "$method,$ping" >> "$pingValuesOutput"
    elif [[ $line == *"Download"* ]]; then
        download=$(echo $line | grep -oP '[0-9.]+')

        echo "$method,$download" >> "$downloadValuesOutput"
    elif [[ $line == *"Upload"* ]]; then
        upload=$(echo $line | grep -oP '[0-9.]+')

        echo "$method,$upload" >> "$uploadValuesOutput"
    fi
done < "$input_file"
