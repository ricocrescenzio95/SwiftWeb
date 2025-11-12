#!/bin/bash

# SwiftWeb Development Server
# Builds Swift, starts Vite, and watches for changes

# Load nvm and use version from .nvmrc
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm use

echo "👀 Starting SwiftWeb in dev mode..."
echo "📦 Building Swift package initially..."

# Initial build
swift package --swift-sdk swift-6.2-RELEASE_wasm js

if [ $? -ne 0 ]; then
  echo "❌ Initial Swift build failed!"
  exit 1
fi

# Error file for communicating with Vite plugin
ERROR_FILE=".swift-build-error"
STATUS_FILE=".swift-build-status"

# Clean up error files on exit
trap "rm -f $ERROR_FILE $STATUS_FILE" EXIT

echo "🔥 Starting Vite dev server and watching for changes..."
echo ""

# JSON escape function (fallback if jq not available)
json_escape() {
  # Escape quotes, newlines, and backslashes for JSON
  sed 's/\\/\\\\/g; s/"/\\"/g' | awk '{printf "%s\\n", $0}' | sed '$ s/\\n$//'
}

# Build Swift with error capture
build_swift() {
  # Capture stderr to error file
  swift package --swift-sdk swift-6.2-RELEASE_wasm js 2> "$ERROR_FILE"

  if [ $? -eq 0 ]; then
    # Build succeeded - write success status
    echo '{"success":true,"error":null}' > "$STATUS_FILE"
    rm -f "$ERROR_FILE"
    echo "✅ Swift build succeeded"
  else
    # Build failed - write error status
    if command -v jq &> /dev/null; then
      # Use jq if available (better JSON escaping)
      ERROR_TEXT=$(cat "$ERROR_FILE" | jq -Rs .)
    else
      # Fallback manual escaping
      ERROR_TEXT="\"$(cat "$ERROR_FILE" | json_escape)\""
    fi
    echo "{\"success\":false,\"error\":$ERROR_TEXT}" > "$STATUS_FILE"
    echo "❌ Swift build failed - check browser for details"
    return 1
  fi
}

export -f build_swift
export -f json_escape
export ERROR_FILE
export STATUS_FILE

# Run Vite and nodemon concurrently
# nodemon watches Swift files and rebuilds on change
# Vite serves the app and hot-reloads when .build changes
npx concurrently \
  --names "VITE,SWIFT" \
  --prefix-colors "cyan,magenta" \
  "vite" \
  "nodemon --watch Sources --watch Tests --ext swift --exec bash -c 'build_swift || exit 0'"
