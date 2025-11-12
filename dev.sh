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

echo "✅ Initial build complete!"
echo "🔥 Starting Vite dev server and watching for changes..."
echo ""

# Run Vite and nodemon concurrently
# nodemon watches Swift files and rebuilds on change
# Vite serves the app and hot-reloads when .build changes
npx concurrently \
  --names "VITE,SWIFT" \
  --prefix-colors "cyan,magenta" \
  "vite" \
  "nodemon --watch Sources --watch Tests --ext swift --exec 'swift package --swift-sdk swift-6.2-RELEASE_wasm js || exit 1'"
