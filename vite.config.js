import { defineConfig } from 'vite'
import path from 'path'

export default defineConfig({
  server: {
    port: 8080,
    open: true,
    fs: {
      // Allow serving files from .build directory
      allow: ['.', '.build', 'node_modules']
    }
  },
  build: {
    target: 'esnext'
  },
  resolve: {
    alias: {
      '@bjorn3/browser_wasi_shim': path.resolve('./node_modules/@bjorn3/browser_wasi_shim/dist/index.js')
    }
  }
})
