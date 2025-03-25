#!/bin/bash
set -euxo pipefail

# Ensure both arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 OLD_OUTPUT.txt NEW_OUTPUT.txt"
    exit 1
fi

OLD_OUTPUT=$1
NEW_OUTPUT=$2

# Check if files exist and are not empty
if [ ! -s "$OLD_OUTPUT" ]; then
    echo "Error: $OLD_OUTPUT does not exist or is empty. Proceeding with NEW_OUTPUT only."
    OLD_OUTPUT="/dev/null" # Empty file as fallback
fi

if [ ! -s "$NEW_OUTPUT" ]; then
    echo "Error: $NEW_OUTPUT does not exist or is empty. Exiting."
    exit 1
fi

# Start output
echo "### 🔍 **Enhanced Build Statistics Diff**"
echo "| Metric               | Old Value     | New Value     | Difference         |"
echo "|---------------------|---------------|---------------|-------------------|"

# Compare stats between OLD and NEW outputs
while IFS= read -r new_line; do
    # Process only lines that start with "STAT:"
    if [[ $new_line != STAT:* ]]; then
        continue
    fi

    # Extract the key and new value
    key=$(echo "$new_line" | cut -d':' -f2 | cut -d'=' -f1)
    new_value=$(echo "$new_line" | cut -d'=' -f2-)

    # Find the matching line in OLD_OUTPUT
    old_line=$(grep "^STAT:${key}=" "$OLD_OUTPUT" || echo "")
    
    if [ -z "$old_line" ]; then
        # New stat added
        echo "| $key            | ❌ Not available | ✅ $new_value | ➕ New Stat        |"
    else
        old_value=$(echo "$old_line" | cut -d'=' -f2-)
        if [ "$new_value" != "$old_value" ]; then
            echo "| $key            | $old_value       | $new_value    | ⬆️ Changed         |"
        else
            echo "| $key            | $old_value       | $new_value    | ➖ No Change       |"
        fi
    fi
done < "$NEW_OUTPUT"

# Check for stats that existed in OLD but are missing in NEW
while IFS= read -r old_line; do
    if [[ $old_line != STAT:* ]]; then
        continue
    fi
    key=$(echo "$old_line" | cut -d':' -f2 | cut -d'=' -f1)
    if ! grep -q "^STAT:${key}=" "$NEW_OUTPUT"; then
        old_value=$(echo "$old_line" | cut -d'=' -f2-)
        echo "| $key            | $old_value       | ❌ Removed     | 🔥 Stat Removed    |"
    fi
done < "$OLD_OUTPUT"

echo "" # Add space after the table
