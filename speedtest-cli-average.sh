#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <output_file>"
    exit 1
fi

# Input file containing results from speedtest
input_file="$1"

ping_sum=0
download_sum=0
upload_sum=0
count=0

LC_NUMERIC="C"

while IFS= read -r line; do
    if [[ $line == *"Ping"* ]]; then
        # Extract the ping (in ms) from the line
        ping_speed=$(echo "$line" | grep -oP '[0-9.]+')
        ping_sum=$(awk "BEGIN {printf \"%.2f\", $ping_sum + $ping_speed}")
    elif [[ $line == *"Download"* ]]; then
        # Extract the download speed (in Mbps) from the line
        download_speed=$(echo "$line" | grep -oP '[0-9.]+' | sed 's/.$//')
        download_sum=$(awk "BEGIN {printf \"%.2f\", $download_sum + $download_speed}")
    elif [[ $line == *"Upload"* ]]; then
        # Extract the upload speed (in Mbps) from the line
        upload_speed=$(echo "$line" | grep -oP '[0-9.]+')
        upload_sum=$(awk "BEGIN {printf \"%.2f\", $upload_sum + $upload_speed}")
        count=$((count + 1))
    fi
done < "$input_file"

# Calculate averages
average_ping=$(awk "BEGIN {printf \"%.2f\", $ping_sum / $count}")
average_download=$(awk "BEGIN {printf \"%.2f\", $download_sum / $count}")
average_upload=$(awk "BEGIN {printf \"%.2f\", $upload_sum / $count}")

# Print the averages
echo
echo "    Average Ping: $average_ping ms"
echo "    Average Download Speed: $average_download Mbps"
echo "    Average Upload Speed: $average_upload Mbps"
