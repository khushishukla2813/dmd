#!/bin/bash
set -euxo pipefail

# Output the build date/time
build_date=$(date '+%Y-%m-%d %H:%M:%S')
echo "STAT:build date=${build_date}"

# Output rough build time.
# Check if RUNTIME is set and not empty
if [ -n "${RUNTIME:-}" ]; then
    runtime_sec=$(awk "BEGIN {printf \"%.3f\", $RUNTIME/1000}")
    echo "STAT:rough build time=${runtime_sec}s (${RUNTIME} ms)"
else
    echo "STAT:rough build time=unknown"
fi

# Output RAM usage.
# Check if RAM_USAGE is set and not empty
if [ -n "${RAM_USAGE:-}" ]; then
    echo "STAT:RAM usage=${RAM_USAGE} MB"
else
    echo "STAT:RAM usage=unknown"
fi

# Output the executable size if the file exists.
# Check for bin/dub or fallback
if [ -f "bin/dub" ]; then
    exe_size=$(stat -c%s "bin/dub" 2>/dev/null || echo "0")
    echo "STAT:executable size=${exe_size} bytes (bin/dub)"
else
    echo "STAT:executable size=not found"
fi

# Parse warnings and deprecations from the full build log.
# Check if FULL_OUTPUT.txt exists
if [ -f "FULL_OUTPUT.txt" ]; then
    warnings=$(grep -i "warning:" FULL_OUTPUT.txt | wc -l || echo "0")
    deprecations=$(grep -i "deprecated:" FULL_OUTPUT.txt | wc -l || echo "0")
    echo "STAT:total warnings=${warnings}"
    echo "STAT:total deprecations=${deprecations}"
else
    echo "STAT:total warnings=unknown"
    echo "STAT:total deprecations=unknown"
fi
