#!/bin/bash

# Define the service name and paths
SERVICE_NAME="com.google.gemini.cli.update"
TEMPLATE_PLIST_PATH="./${SERVICE_NAME}.plist"
TARGET_DIR="$HOME/Library/LaunchAgents"
TARGET_PLIST_PATH="${TARGET_DIR}/${SERVICE_NAME}.plist"

echo "Starting Gemini CLI updater setup..."

# 1. Find the absolute path to npm
echo "🔍 Finding npm executable..."
NPM_PATH=$(which npm)

if [ -z "$NPM_PATH" ]; then
    echo "❌ Error: npm not found in your PATH. Please ensure Node.js and npm are installed."
    exit 1
fi
echo "✅ Found npm at: ${NPM_PATH}"

# 2. Update the .plist file with the correct npm path
echo "📝 Updating configuration file with the correct npm path..."
# Use a temporary file and move it to handle permissions and in-place editing safely
sed "s|__NPM_PATH__|${NPM_PATH}|g" "${TEMPLATE_PLIST_PATH}" > "${SERVICE_NAME}.plist.tmp" && mv "${SERVICE_NAME}.plist.tmp" "${TARGET_PLIST_PATH}"

if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to update the .plist file."
    exit 1
fi
echo "✅ Configuration file created at ${TARGET_PLIST_PATH}"

# 3. Unload any existing version of the service to ensure a clean start
if [ -f "${TARGET_PLIST_PATH}" ]; then
    echo "🔄 Unloading any existing version of the service..."
    launchctl unload "${TARGET_PLIST_PATH}" >/dev/null 2>&1
fi

# 4. Load the new launchd agent
echo "🚀 Loading the update service..."
launchctl load "${TARGET_PLIST_PATH}"

if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to load the launchd service."
    exit 1
fi

echo "✅ Success! The Gemini CLI auto-update service is installed and loaded."
echo "🗓️ It will run automatically every Sunday at 2:00 PM."
echo "🪵 You can check the update log at: /tmp/gemini-cli-update.log"
