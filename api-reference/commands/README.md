# Commands API Reference

Command system execution, building, and validation for automating GrandMA3 operations from Lua plugins.

## Overview

The Commands API enables plugins to execute MA3 commands programmatically:
- **Command Execution**: Running MA3 commands with `Cmd()` function
- **Command Building**: Constructing complex command sequences dynamically
- **Command Validation**: Syntax checking and error handling for commands

## Available Documentation

### Command Execution (`command-execution.*`)
Core command execution methods and patterns:
- **Basic Execution**: Using `Cmd()` to run simple commands
- **Command Results**: Capturing command output and success status
- **Asynchronous Commands**: Handling long-running operations
- **Command Queuing**: Managing multiple command sequences

*Files: `command-execution.lua`, `command-execution.json`, `command-execution.md`*

### Command Building (`command-building.*`)
Dynamic command construction and formatting:
- **String Formatting**: Building commands with variables and parameters
- **Command Templates**: Reusable command patterns and structures
- **Parameter Validation**: Ensuring command arguments are valid
- **Complex Sequences**: Multi-step command operations

*Files: `command-building.lua`, `command-building.json`, `command-building.md`*

### Command Validation (`command-validation.*`)
Syntax checking and error prevention:
- **Syntax Validation**: Checking command format before execution
- **Parameter Checking**: Validating command arguments and ranges
- **Error Handling**: Managing command failures and recovery
- **Debug Support**: Tools for command troubleshooting

*Files: `command-validation.lua`, `command-validation.json`, `command-validation.md`*

## Key Concepts

### Command Execution
The `Cmd()` function is the primary interface for command execution:
```lua
Cmd("Clear")  -- Execute a simple command
Cmd("Fixture 1 Thru 10 At 50")  -- Execute with parameters
```

### Command Strings
MA3 commands follow specific syntax patterns:
- **Object Selection**: `Fixture 1 Thru 10`, `Group "MyGroup"`
- **Property Setting**: `At 50`, `Color Red`, `Gobo 1`
- **Command Chaining**: `Fixture 1 At 50; Fixture 2 At 75`

### Return Values
Commands can return status information:
```lua
local result = Cmd("Fixture 1 At 50")
-- Check if command succeeded
```

## Usage Patterns

### Simple Command Execution
```lua
-- Basic command execution
Cmd("Clear")
Cmd("Fixture 1 At 100")
Cmd("Store Cue 1")
```

### Dynamic Command Building
```lua
-- Build commands with variables
local fixtureNumber = 5
local intensity = 75
Cmd(string.format("Fixture %d At %d", fixtureNumber, intensity))

-- Build selection ranges
local startFixture = 1
local endFixture = 10
Cmd(string.format("Fixture %d Thru %d At 50", startFixture, endFixture))
```

### Error Handling
```lua
-- Safe command execution with error handling
local function safeCmd(command)
    local success, result = pcall(function()
        return Cmd(command)
    end)
    
    if not success then
        Printf("Command failed: " .. command)
        return false
    end
    
    return result
end
```

### Command Sequences
```lua
-- Execute multiple related commands
local commands = {
    "Clear",
    "Fixture 1 Thru 10 At 75",
    "Color Red",
    "Store Cue 1"
}

for _, cmd in ipairs(commands) do
    if not safeCmd(cmd) then
        Printf("Command sequence failed at: " .. cmd)
        break
    end
end
```

## Command Categories

### Selection Commands
Object selection and filtering:
```lua
Cmd("Fixture 1")           -- Select single fixture
Cmd("Fixture 1 Thru 10")   -- Select range
Cmd("Group \"MyGroup\"")   -- Select by group
Cmd("All")                 -- Select all objects
```

### Property Commands
Setting object properties:
```lua
Cmd("At 50")              -- Set intensity
Cmd("Color Red")          -- Set color
Cmd("Position 45 30")     -- Set pan/tilt
Cmd("Fade 3")             -- Set fade time
```

### Storage Commands
Saving and recalling data:
```lua
Cmd("Store Cue 1")        -- Store current state
Cmd("Store Group 1")      -- Store selection
Cmd("Copy Cue 1 At 2")    -- Copy and store
```

### Playback Commands
Controlling cues and sequences:
```lua
Cmd("Go+ Cue 1")          -- Start cue
Cmd("Pause Cue 1")        -- Pause playback
Cmd("Off Sequence 1")     -- Stop sequence
```

## Cross-References

### Related Enums
- Command types and modes: `/enums/command-system.md`
- Object types for selection: `/enums/object-types.md`
- Property types and ranges: `/enums/data-types.md`

### Examples
- Basic command execution: `/examples/basic-operations/02-command-execution.lua`
- Dynamic command building: `/examples/advanced-patterns/command-sequences.lua`
- Error handling patterns: `/examples/advanced-patterns/safe-commands.lua`

### Templates
- Command-based plugins: `/templates/basic-plugin/commands.lua`
- Automation templates: `/templates/advanced-plugin/automation.lua`

### Utilities
- Command validation: `/utilities/validation/command-helpers.lua`
- String formatting: `/utilities/string-utils/command-formatting.lua`

## Best Practices

### Command Safety
- **Validation**: Always validate parameters before building commands
- **Error Handling**: Use try-catch patterns for command execution
- **User Confirmation**: Confirm destructive operations with users
- **Rollback**: Plan for command failure recovery

### Performance Optimization
- **Batch Commands**: Combine related operations where possible
- **Async Handling**: Use appropriate timing for long operations
- **Resource Management**: Clean up after command sequences

### Debugging
- **Logging**: Log commands before execution for troubleshooting
- **Step-by-Step**: Break complex operations into smaller commands
- **User Feedback**: Provide progress feedback for long operations

## Compatibility

- **MA3 API 2.2**: Full support for all command syntax
- **Command Syntax**: Compatible with console command line
- **Future Versions**: Command API designed for forward compatibility
- **Hardware**: Optimized for console performance characteristics