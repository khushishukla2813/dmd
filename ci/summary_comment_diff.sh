#!/bin/bash

OLD_FILE="$1"
NEW_FILE="$2"

# Compare old and new statistics
echo "### 🔍 Build Comparison"
echo "Here’s a comparison of previous and current builds:"
echo ""

# Extract relevant data
old_time=$(grep -oP '(?<=STAT:rough build time=)\d+(\.\d+)?(?=s)' "$OLD_FILE" || echo "0")
new_time=$(grep -oP '(?<=STAT:rough build time=)\d+(\.\d+)?(?=s)' "$NEW_FILE" || echo "0")
old_size=$(grep -oP '(?<=STAT:executable size=)\d+' "$OLD_FILE" || echo "0")
new_size=$(grep -oP '(?<=STAT:executable size=)\d+' "$NEW_FILE" || echo "0")

# Calculate differences
time_diff=$(awk "BEGIN {print $new_time - $old_time}")
size_diff=$((new_size - old_size))

# Output results
echo "- **Build Time:** Previous: ${old_time}s, Current: ${new_time}s, Difference: ${time_diff}s"
echo "- **Executable Size:** Previous: ${old_size} bytes, Current: ${new_size} bytes, Difference: ${size_diff} bytes"
