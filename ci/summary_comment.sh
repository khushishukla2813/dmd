#!/bin/bash

# Path to build output
OUTPUT_FILE="./FULL_OUTPUT.txt"

# Initialize variables
build_time=$(grep "Elapsed (wall clock) time" "$OUTPUT_FILE" | awk '{print $8}' | cut -d':' -f2)
exec_size=$(stat -c %s bin/dub 2>/dev/null || echo 0)
deprecations=$(grep -c "deprecation" "$OUTPUT_FILE" || echo 0)
warnings=$(grep -c "warning" "$OUTPUT_FILE" || echo 0)

# Convert build time to seconds
build_time_sec=$(awk "BEGIN {print $build_time}")

# Generate summary
echo "Summary of Build:"
echo "-------------------"
echo "Build Time: ${build_time_sec}s"
echo "Executable Size: ${exec_size} bytes"
echo "Total Deprecations: ${deprecations}"
echo "Total Warnings: ${warnings}"
