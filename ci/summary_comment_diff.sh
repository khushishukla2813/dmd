#!/bin/bash
# Input files
OLD_OUTPUT="$1"
NEW_OUTPUT="$2"

# Extract old stats
old_time=$(grep -oP '(?<=STAT:rough build time=)\d+(\.\d+)?(?=s)' "$OLD_OUTPUT" || echo "0")
old_size=$(grep -oP '(?<=STAT:executable size=)\d+' "$OLD_OUTPUT" || echo "0")
old_deprecations=$(grep -oP '(?<=Total deprecations:)\d+' "$OLD_OUTPUT" || echo "0")
old_warnings=$(grep -oP '(?<=Total warnings:)\d+' "$OLD_OUTPUT" || echo "0")

# Extract new stats
new_time=$(grep -oP '(?<=STAT:rough build time=)\d+(\.\d+)?(?=s)' "$NEW_OUTPUT" || echo "0")
new_size=$(grep -oP '(?<=STAT:executable size=)\d+' "$NEW_OUTPUT" || echo "0")
new_deprecations=$(grep -oP '(?<=Total deprecations:)\d+' "$NEW_OUTPUT" || echo "0")
new_warnings=$(grep -oP '(?<=Total warnings:)\d+' "$NEW_OUTPUT" || echo "0")

# Calculate differences
time_diff=$(awk "BEGIN {print $new_time - $old_time}")
size_diff=$((new_size - old_size))
deprecation_diff=$((new_deprecations - old_deprecations))
warning_diff=$((new_warnings - old_warnings))

# Prepare diff summary
echo "### 🔍 Build Statistics Diff"
echo "Comparing previous build statistics with the current build:"
echo ""
[ "$time_diff" != "0" ] && echo "- ⏱️ Build Time Difference: ${time_diff}s"
[ "$size_diff" -ne 0 ] && echo "- 📝 Executable Size Change: ${size_diff} bytes"
[ "$deprecation_diff" -ne 0 ] && echo "- ⚠️ Deprecations Changed: ${deprecation_diff}"
[ "$warning_diff" -ne 0 ] && echo "- ❗ Warnings Changed: ${warning_diff}"
