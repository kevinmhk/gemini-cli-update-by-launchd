#!/bin/bash

# Define the service name and path
SERVICE_NAME="com.google.gemini.cli.update"
TARGET_DIR="$HOME/Library/LaunchAgents"
TARGET_PLIST_PATH="${TARGET_DIR}/${SERVICE_NAME}.plist"

echo "Starting Gemini CLI updater uninstallation..."

# 1. Check if the service file exists
if [ ! -f "${TARGET_PLIST_PATH}" ]; then
    echo "ℹ️ Service file not found at ${TARGET_PLIST_PATH}. Nothing to do."
    exit 0
fi

# 2. Unload the launchd agent
echo "🛑 Stopping and unloading the service..."
launchctl unload "${TARGET_PLIST_PATH}" >/dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "⚠️ Warning: Could not unload the service. It might have already been unloaded."
fi

# 3. Remove the .plist file
echo "🗑️ Removing configuration file..."
rm "${TARGET_PLIST_PATH}"

if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to remove the .plist file. You may need to remove it manually."
    exit 1
fi

echo "✅ Success! The Gemini CLI auto-update service has been uninstalled."
