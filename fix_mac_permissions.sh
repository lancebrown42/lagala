#!/bin/bash

echo "=== Mac Permissions Fix for Godot ==="

# Find Godot application
GODOT_PATH="/Applications/Godot.app"
if [ ! -d "$GODOT_PATH" ]; then
    echo "Godot not found at $GODOT_PATH"
    echo "Please locate your Godot.app and update GODOT_PATH in this script"
    exit 1
fi

echo "Found Godot at: $GODOT_PATH"

# Remove quarantine attribute
echo "Removing quarantine attribute..."
sudo xattr -rd com.apple.quarantine "$GODOT_PATH" 2>/dev/null
echo "✓ Quarantine removed"

# Fix permissions
echo "Fixing permissions..."
sudo chmod -R 755 "$GODOT_PATH"
echo "✓ Permissions fixed"

# Check if Godot is in accessibility
echo ""
echo "=== MANUAL STEPS NEEDED ==="
echo "1. Open System Preferences > Security & Privacy > Privacy"
echo "2. Click 'Accessibility' on the left"
echo "3. Click the lock icon and enter your password"
echo "4. Click '+' and add: $GODOT_PATH"
echo ""
echo "5. Click 'Input Monitoring' on the left"
echo "6. Click '+' and add: $GODOT_PATH"
echo ""
echo "7. Restart Godot after adding permissions"
echo ""
echo "Then test the MinimalTest scene again!"
