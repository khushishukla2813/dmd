#!/bin/bash
set -euxo pipefail

# Output the build date/time
build_date=$(date '+%Y-%m-%d %H:%M:%S')
echo "### 🛠️ Build Date: $build_date"

# Output rough build time.
# Check if RUNTIME is set and not empty
if [ -n "${RUNTIME:-}" ]; then
    runtime_sec=$(awk "BEGIN {printf \"%.4f\", $RUNTIME/1000}")
    echo "STAT: Rough Build Time  | ${runtime_sec}s  (${RUNTIME} ms)"
else
    echo "STAT: Rough Build Time  | Unknown"
fi

# Output RAM usage.
# Check if RAM_USAGE is set and not empty
if [ -n "${RAM_USAGE:-}" ]; then
    echo "STAT: RAM Usage         | ${RAM_USAGE} MB"
else
    echo "STAT: RAM Usage         | Unknown"
fi

# Output the executable size if the file exists.
# Check for bin/dub or fallback
if [ -f "bin/dub" ]; then
    exe_size=$(stat -c%s "bin/dub" 2>/dev/null || echo "0")
    echo "STAT: Executable Size   | ${exe_size} bytes"
else
    echo "STAT: Executable Size   | Not Found"
fi

# Parse warnings and deprecations from the full build log.
# Check if FULL_OUTPUT.txt exists
if [ -f "FULL_OUTPUT.txt" ]; then
    warnings=$(grep -i "warning:" FULL_OUTPUT.txt | wc -l || echo "0")
    deprecations=$(grep -i "deprecated:" FULL_OUTPUT.txt | wc -l || echo "0")
    echo "STAT: Total Warnings     | ${warnings}"
    echo "STAT: Total Deprecations | ${deprecations}"
else
    echo "STAT: Total Warnings     | Unknown"
    echo "STAT: Total Deprecations | Unknown"
fi
