import { readFileSync, existsSync, watchFile, unwatchFile } from 'fs'
import path from 'path'

const ERROR_FILE = '.swift-build-error'
const STATUS_FILE = '.swift-build-status'
const VIRTUAL_MODULE_ID = 'virtual:swift-build-status'
const RESOLVED_VIRTUAL_MODULE_ID = '\0' + VIRTUAL_MODULE_ID

/**
 * Vite plugin to display Swift compilation errors in the browser
 */
export function swiftErrorOverlay() {
  let server
  let lastError = null
  let lastModified = 0

  return {
    name: 'swift-error-overlay',

    resolveId(id) {
      if (id === VIRTUAL_MODULE_ID) {
        return RESOLVED_VIRTUAL_MODULE_ID
      }
    },

    load(id) {
      if (id === RESOLVED_VIRTUAL_MODULE_ID) {
        const status = readBuildStatus()
        return `export default ${JSON.stringify(status)}`
      }
    },

    configureServer(devServer) {
      server = devServer

      // Add status file to Vite's watcher
      if (existsSync(STATUS_FILE)) {
        server.watcher.add(STATUS_FILE)
      }

      // Watch status file for changes
      server.watcher.on('change', (file) => {
        if (file === path.resolve(STATUS_FILE)) {
          handleBuildStatusChange()
        }
      })

      // Also use Node's watchFile as backup
      watchFile(STATUS_FILE, { interval: 1000 }, () => {
        handleBuildStatusChange()
      })

      function handleBuildStatusChange() {
        const status = readBuildStatus()

        if (status.error && status.error !== lastError) {
          lastError = status.error

          // Send error to browser
          server.ws.send({
            type: 'error',
            err: {
              message: 'Swift Compilation Error',
              stack: status.error,
              plugin: 'swift-error-overlay',
              id: STATUS_FILE,
              frame: ''
            }
          })
        } else if (!status.error && lastError) {
          // Build succeeded after a failure - reload
          lastError = null
          server.ws.send({
            type: 'full-reload',
            path: '*'
          })
        }

        // Invalidate the virtual module
        const mod = server.moduleGraph.getModuleById(RESOLVED_VIRTUAL_MODULE_ID)
        if (mod) {
          server.moduleGraph.invalidateModule(mod)
        }
      }
    },

    closeBundle() {
      unwatchFile(STATUS_FILE)
    }
  }
}

/**
 * Read and parse the build status file
 */
function readBuildStatus() {
  if (!existsSync(STATUS_FILE)) {
    return { success: true, error: null }
  }

  try {
    const content = readFileSync(STATUS_FILE, 'utf-8')
    return JSON.parse(content)
  } catch (err) {
    // If can't parse, try reading error file directly
    if (existsSync(ERROR_FILE)) {
      const errorContent = readFileSync(ERROR_FILE, 'utf-8').trim()
      if (errorContent) {
        return {
          success: false,
          error: formatSwiftError(errorContent)
        }
      }
    }
    return { success: true, error: null }
  }
}

/**
 * Format Swift compiler errors for display
 */
function formatSwiftError(errorOutput) {
  const lines = errorOutput.split('\n')
  const formatted = []
  let currentError = null

  for (const line of lines) {
    // Match error/warning lines: /path/to/file.swift:line:col: error: message
    const match = line.match(/^(.+\.swift):(\d+):(\d+):\s*(error|warning|note):\s*(.+)$/)

    if (match) {
      const [, file, lineNum, col, type, message] = match
      const relativePath = path.relative(process.cwd(), file)

      if (type === 'error' || type === 'warning') {
        if (currentError) {
          formatted.push(formatError(currentError))
        }
        currentError = {
          type,
          file: relativePath,
          line: lineNum,
          col,
          message,
          details: []
        }
      } else if (currentError) {
        currentError.details.push(message)
      }
    } else if (line.trim() && currentError && !line.startsWith('error:') && !line.startsWith('warning:')) {
      // Append code context
      currentError.details.push(line)
    }
  }

  if (currentError) {
    formatted.push(formatError(currentError))
  }

  return formatted.length > 0 ? formatted.join('\n\n') : cleanOutput
}

function formatError(err) {
  const icon = err.type === 'error' ? '❌' : '⚠️'
  const header = `${icon} ${err.message}`
  const location = `   ${err.file}:${err.line}:${err.col}`
  const details = err.details.length > 0
    ? '\n\n' + err.details.slice(0, 5).map(d => '   ' + d).join('\n')
    : ''

  return `${header}\n${location}${details}`
}
