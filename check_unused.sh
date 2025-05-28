#!/bin/bash

echo "🔍 Scanning for unused packages..."

# Read all package names from pubspec.yaml (ignoring flutter-related entries)
packages=$(grep -E '^\s*[a-zA-Z_]+:' pubspec.yaml | grep -vE 'sdk:|flutter:' | awk -F: '{print $1}' | xargs)

for package in $packages; do
    # Look for any file importing this package
    result=$(grep -r "package:$package" lib/)
    if [ -z "$result" ]; then
        echo "❌ Possibly unused: $package"
    else
        echo "✅ Used: $package"
    fi
done
