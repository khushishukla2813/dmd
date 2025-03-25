#!/bin/bash

# Build summary
echo "### 🛠️ Build Summary"
echo "Here are the results of the latest build:"
echo ""
echo "- **Build Time:** $(awk "BEGIN {printf \"%.3f\", $RUNTIME/1000}") seconds"
echo "- **RAM Usage:** ${RAM_USAGE} MB"
