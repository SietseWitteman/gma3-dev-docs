# System API Reference

System-level operations, utilities, and environment access for GrandMA3 plugin development.

## Overview

The System API provides access to MA3 console environment and system-level operations:
- **System Information**: Hardware details, software version, and environment data
- **File Operations**: File system access, reading, writing, and manipulation
- **System Configuration**: Settings, preferences, and system state management

## Available Documentation

### System Information (`system-information.*`)
Methods for accessing console and environment information:
- **Hardware Info**: Console type, capabilities, and specifications
- **Software Version**: MA3 version, API version, and build information
- **Environment Data**: User settings, system paths, and configuration
- **Performance Metrics**: Memory usage, CPU load, and system resources

*Files: `system-information.lua`, `system-information.json`, `system-information.md`*

### File Operations (`file-operations.*`)
File system access and manipulation utilities:
- **File Reading**: Reading text files, configuration files, and data files
- **File Writing**: Creating and updating files with proper encoding
- **Directory Operations**: Listing, creating, and managing directories
- **Path Management**: Working with file paths and system locations

*Files: `file-operations.lua`, `file-operations.json`, `file-operations.md`*

### System Configuration (`system-configuration.*`)
Settings and configuration management:
- **User Preferences**: Reading and writing user settings
- **System Settings**: Accessing console configuration
- **Plugin Configuration**: Managing plugin-specific settings
- **Environment Variables**: System and user environment access

*Files: `system-configuration.lua`, `system-configuration.json`, `system-configuration.md`*

## Key Concepts

### System Information Access
Getting information about the MA3 environment:
```lua
-- Get system information (API varies by MA3 implementation)
local systemInfo = GetSystemInfo()  -- Example function
local version = GetMAVersion()       -- Example function
```

### File System Operations
Working with files and directories:
```lua
-- File operations (API varies by MA3 implementation)
local content = ReadFile("path/to/file.txt")
WriteFile("path/to/output.txt", "content")
```

### Console Environment
Understanding the MA3 console environment:
- **Plugin Directory**: Where plugins are stored and executed
- **Data Directory**: User data and configuration storage
- **System Directory**: MA3 system files and resources
- **Temporary Directory**: Temporary file storage

## Usage Patterns

### System Information Retrieval
```lua
-- Get basic system information
local function getSystemInfo()
    local info = {
        version = "Unknown",
        platform = "Unknown", 
        memory = 0
    }
    
    -- Try to get actual system info (API dependent)
    local success, result = pcall(function()
        -- System info calls would go here
        return GetSystemInfo()
    end)
    
    if success and result then
        info.version = result.version or info.version
        info.platform = result.platform or info.platform
        info.memory = result.memory or info.memory
    end
    
    return info
end
```

### Safe File Operations
```lua
-- Safe file reading with error handling
local function readFileContent(filePath)
    local success, content = pcall(function()
        -- File reading implementation (API dependent)
        return ReadFile(filePath)
    end)
    
    if not success then
        Printf("Failed to read file: " .. filePath)
        return nil
    end
    
    return content
end

-- Safe file writing
local function writeFileContent(filePath, content)
    local success, error = pcall(function()
        -- File writing implementation (API dependent)
        WriteFile(filePath, content)
    end)
    
    if not success then
        Printf("Failed to write file: " .. filePath .. " - " .. tostring(error))
        return false
    end
    
    return true
end
```

### Configuration Management
```lua
-- Plugin configuration helper
local function getPluginConfig(pluginName, defaultConfig)
    local configPath = "plugins/" .. pluginName .. "/config.json"
    local configContent = readFileContent(configPath)
    
    if not configContent then
        return defaultConfig
    end
    
    local success, config = pcall(function()
        return JSON.decode(configContent)  -- If JSON library available
    end)
    
    return success and config or defaultConfig
end

local function savePluginConfig(pluginName, config)
    local configPath = "plugins/" .. pluginName .. "/config.json"
    local configContent = JSON.encode(config)  -- If JSON library available
    
    return writeFileContent(configPath, configContent)
end
```

## System Categories

### Console Information
Information about the MA3 console:
```lua
-- Console type and capabilities
local consoleType = "MA3 Full Size"  -- Example
local maxFixtures = 65536           -- Example
local screenCount = 4               -- Example
```

### File System Access
Working with the console file system:
```lua
-- Standard MA3 directories
local pluginDir = "plugins/"
local dataDir = "data/"
local tempDir = "temp/"
```

### Environment Variables
System and user environment:
```lua
-- User information
local userName = GetCurrentUser()    -- Example
local userDir = GetUserDirectory()   -- Example

-- System paths
local systemDir = GetSystemDirectory()  -- Example
local pluginPath = GetPluginPath()      -- Example
```

### Performance Monitoring
System resource monitoring:
```lua
-- Memory and performance
local memoryUsage = GetMemoryUsage()    -- Example
local cpuLoad = GetCPULoad()            -- Example
local diskSpace = GetDiskSpace()        -- Example
```

## Cross-References

### Related Enums
- System states and modes: `/enums/system-states.md`
- File types and formats: `/enums/file-types.md`
- Console types and capabilities: `/enums/console-types.md`

### Examples
- System information access: `/examples/advanced-patterns/system-info.lua`
- File operations: `/examples/data-management/file-handling.lua`
- Configuration management: `/examples/advanced-patterns/config-management.lua`

### Templates
- System-aware plugins: `/templates/advanced-plugin/system-integration.lua`
- File processing plugins: `/templates/data-plugin/file-processing.lua`

### Utilities
- File operation helpers: `/utilities/system-utils/file-helpers.lua`
- Configuration utilities: `/utilities/system-utils/config-helpers.lua`
- System information utilities: `/utilities/system-utils/info-helpers.lua`

## Best Practices

### File Operations
- **Error Handling**: Always handle file operation failures gracefully
- **Path Validation**: Validate file paths before operations
- **Encoding**: Use appropriate text encoding for file operations
- **Cleanup**: Close file handles and clean up resources

### System Integration
- **Capability Detection**: Check system capabilities before using features
- **Version Compatibility**: Handle different MA3 versions appropriately
- **Resource Limits**: Respect system memory and processing limits
- **User Permissions**: Handle file permission and access issues

### Configuration Management
- **Default Values**: Always provide sensible defaults
- **Validation**: Validate configuration data before use
- **Backward Compatibility**: Handle configuration format changes
- **User Override**: Allow users to override system defaults

### Performance
- **Resource Monitoring**: Monitor system resource usage
- **Lazy Loading**: Load system information only when needed
- **Caching**: Cache system information that doesn't change
- **Cleanup**: Clean up temporary files and resources

## Security Considerations

- **File Access**: Respect file system permissions and security
- **Input Validation**: Validate all file paths and system inputs
- **Privilege Levels**: Understand console security and privilege models
- **Safe Operations**: Avoid operations that could harm system stability

## Compatibility

- **MA3 API 2.2**: Full support for available system operations
- **Console Types**: Compatible with all MA3 console variants
- **Operating System**: Works within MA3's underlying OS constraints
- **Future Versions**: System API designed for forward compatibility
- **Security**: Follows MA3 security guidelines and best practices