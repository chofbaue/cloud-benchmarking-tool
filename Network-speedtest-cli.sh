#!/bin/bash

# Check if missing output file
if [ -z "$1" ]; then
    echo "Usage: $0 <output_file>"
    exit 1
fi

iterations=30

output="$1"

for ((i = 1; i < iterations; i++)); do
    echo "Testing iteration $i/$iterations..."
    echo "=== Iteration $i ===" >> "$output"

    speedtest-cli --simple >> "$output";
done;

echo "Speedtest completed $i iterations."
