# Enums API Reference

All GrandMA3 enumerations organized by category with usage examples and cross-references.

## Overview

MA3 enumerations provide predefined constants for various system operations:
- **Object Types**: Categories and types of MA3 objects (fixtures, groups, cues, etc.)
- **UI Elements**: Dialog types, button states, input modes, and interface elements
- **System States**: Connection states, operation modes, status flags, and system conditions

## Available Documentation

### Object Types (`object-types.*`)
Enumerations for MA3 object categories and types:
- **Fixture Types**: Different fixture categories and classifications
- **Object Categories**: Groups, presets, cues, sequences, and other object types
- **Selection Types**: Object selection modes and filters
- **Storage Types**: Different ways objects can be stored and referenced

*Files: `object-types.lua`, `object-types.json`, `object-types.md`*

### UI Elements (`ui-elements.*`)
User interface related enumerations:
- **Dialog Types**: Input, checkbox, fader, and custom dialog types
- **Button States**: Pressed, released, active, inactive states
- **Input Modes**: Text, numeric, selection input types
- **Display Properties**: Screen modes, resolutions, and layout options

*Files: `ui-elements.lua`, `ui-elements.json`, `ui-elements.md`*

### System States (`system-states.*`)
System and operational state enumerations:
- **Connection States**: Network, device, and communication states
- **Operation Modes**: Console modes, playback states, and system modes
- **Status Flags**: Error conditions, warning states, and status indicators
- **Performance States**: Load levels, resource usage, and system health

*Files: `system-states.lua`, `system-states.json`, `system-states.md`*

### Data Types (`data-types.*`)
Data type and format enumerations:
- **Property Types**: Different property data types and formats
- **Value Ranges**: Numeric ranges and constraints for various properties
- **Format Types**: String formats, encoding types, and data representations
- **Validation Types**: Input validation rules and constraint types

*Files: `data-types.lua`, `data-types.json`, `data-types.md`*

### Command System (`command-system.*`)
Command-related enumerations:
- **Command Types**: Different categories of MA3 commands
- **Parameter Types**: Command parameter formats and types
- **Execution Modes**: Command execution states and modes
- **Result Types**: Command return values and status codes

*Files: `command-system.lua`, `command-system.json`, `command-system.md`*

## Key Concepts

### Enumeration Usage
Enumerations provide named constants instead of magic numbers:
```lua
-- Instead of using magic numbers
local dialogType = 1  -- What does 1 represent?

-- Use named enumerations
local dialogType = DialogType.INPUT  -- Clear and self-documenting
```

### Type Safety
Enumerations help prevent errors and improve code clarity:
```lua
-- Check object type safely
if obj.type == ObjectType.FIXTURE then
    -- Handle fixture-specific logic
elseif obj.type == ObjectType.GROUP then
    -- Handle group-specific logic
end
```

### Cross-Platform Consistency
Enumerations ensure consistent values across different MA3 versions:
```lua
-- Values are guaranteed to be consistent
local status = ConnectionStatus.CONNECTED
```

## Usage Patterns

### Object Type Checking
```lua
-- Safe object type validation
local function isFixture(obj)
    return obj and obj.type == ObjectType.FIXTURE
end

local function isGroup(obj)
    return obj and obj.type == ObjectType.GROUP
end

-- Use in conditional logic
local selectedObj = GetSelectedObject()  -- Example function
if isFixture(selectedObj) then
    -- Process fixture
    Printf("Selected fixture: " .. selectedObj.name)
elseif isGroup(selectedObj) then
    -- Process group
    Printf("Selected group: " .. selectedObj.name)
end
```

### UI State Management
```lua
-- Dialog state handling
local function handleDialogResult(dialogType, result)
    if dialogType == DialogType.INPUT then
        if result and result ~= "" then
            -- Process input
            ProcessUserInput(result)
        end
    elseif dialogType == DialogType.CHECKBOX then
        if result then
            -- Process checkbox selections
            ProcessCheckboxSelections(result)
        end
    end
end
```

### System State Monitoring
```lua
-- Monitor system status
local function checkSystemHealth()
    local status = {
        connection = ConnectionStatus.UNKNOWN,
        performance = PerformanceStatus.UNKNOWN,
        errors = {}
    }
    
    -- Check connection status
    local connStatus = GetConnectionStatus()  -- Example function
    if connStatus == ConnectionStatus.CONNECTED then
        status.connection = connStatus
    elseif connStatus == ConnectionStatus.DISCONNECTED then
        status.connection = connStatus
        table.insert(status.errors, "Network disconnected")
    end
    
    -- Check performance
    local perfStatus = GetPerformanceStatus()  -- Example function
    if perfStatus == PerformanceStatus.HIGH_LOAD then
        status.performance = perfStatus
        table.insert(status.errors, "High system load")
    end
    
    return status
end
```

## Enumeration Categories

### Core Object Enums
Basic MA3 object type identification:
```lua
ObjectType = {
    FIXTURE = 1,
    GROUP = 2,
    PRESET = 3,
    CUE = 4,
    SEQUENCE = 5,
    -- ... additional types
}
```

### UI State Enums
User interface element states:
```lua
DialogType = {
    INPUT = 1,
    CHECKBOX = 2,
    FADER = 3,
    CUSTOM = 4
}

ButtonState = {
    RELEASED = 0,
    PRESSED = 1,
    ACTIVE = 2,
    INACTIVE = 3
}
```

### System Status Enums
System and operational states:
```lua
ConnectionStatus = {
    DISCONNECTED = 0,
    CONNECTING = 1,
    CONNECTED = 2,
    ERROR = 3
}

PerformanceStatus = {
    LOW_LOAD = 0,
    NORMAL_LOAD = 1,
    HIGH_LOAD = 2,
    CRITICAL_LOAD = 3
}
```

### Data Format Enums
Data types and validation rules:
```lua
PropertyType = {
    INTEGER = 1,
    FLOAT = 2,
    STRING = 3,
    BOOLEAN = 4,
    HANDLE = 5
}

ValidationRule = {
    REQUIRED = 1,
    RANGE = 2,
    FORMAT = 3,
    CUSTOM = 4
}
```

## Cross-References

### API Usage
Each enumeration category links to related API sections:
- **Object Types** → [Core API](../core/) and [Data API](../data/)
- **UI Elements** → [UI API](../ui/)
- **System States** → [System API](../system/)
- **Command System** → [Commands API](../commands/)

### Examples
Practical usage examples in the examples library:
- Object type checking: `/examples/basic-operations/object-types.lua`
- UI state management: `/examples/ui-creation/dialog-states.lua`
- System monitoring: `/examples/advanced-patterns/system-monitoring.lua`

### Templates
Template usage of enumerations:
- Type-safe plugins: `/templates/basic-plugin/type-safety.lua`
- UI state management: `/templates/ui-plugin/state-management.lua`

### Utilities
Helper functions using enumerations:
- Type checking utilities: `/utilities/validation/type-checking.lua`
- Enum validation helpers: `/utilities/validation/enum-validation.lua`

## Best Practices

### Use Named Constants
Always use enumeration names instead of raw values:
```lua
-- Good: Self-documenting and maintainable
if obj.type == ObjectType.FIXTURE then
    -- Handle fixture
end

-- Bad: Magic numbers are unclear
if obj.type == 1 then
    -- What is 1?
end
```

### Validation Patterns
Validate enumeration values before use:
```lua
local function isValidObjectType(type)
    for name, value in pairs(ObjectType) do
        if value == type then
            return true
        end
    end
    return false
end
```

### Switch-Style Logic
Use enumeration-based conditional logic:
```lua
local function handleObjectType(obj)
    local objType = obj.type
    
    if objType == ObjectType.FIXTURE then
        return handleFixture(obj)
    elseif objType == ObjectType.GROUP then
        return handleGroup(obj)
    elseif objType == ObjectType.CUE then
        return handleCue(obj)
    else
        return handleUnknownType(obj)
    end
end
```

### Documentation
Document enumeration usage in your code:
```lua
---@param dialogType DialogType The type of dialog to create
---@param options table Dialog configuration options
---@return boolean success Whether dialog was created successfully
local function createDialog(dialogType, options)
    -- Implementation
end
```

## Compatibility

- **MA3 API 2.2**: All enumerations match official MA3 API definitions
- **Version Stability**: Enumeration values remain consistent across MA3 updates
- **Future Compatibility**: New enumerations added without breaking existing values
- **Cross-Platform**: Enumeration values consistent across all MA3 console types