# Basic Operations Examples

Fundamental GrandMA3 operations that every plugin developer needs to understand. These examples demonstrate the core concepts and essential patterns for MA3 plugin development.

## Overview

Master the basics of MA3 plugin development with these foundational examples:
- Object selection and manipulation
- Command execution and control
- Data retrieval and property access
- Basic error handling patterns

## Available Examples

### 01-object-selection.lua
**Difficulty**: Beginner  
**API Used**: `Obj()`, Handle methods, object properties  
**Description**: Learn how to select, access, and work with MA3 objects like fixtures, groups, and cues.

**Key Concepts**:
- Getting object handles with `Obj()`
- Checking object existence and validity
- Accessing object properties safely
- Working with object hierarchies and relationships

**Usage Patterns**:
```lua
-- Basic object access
local obj = Obj()
if obj then
    local name = obj.name
    Printf("Object name: " .. tostring(name))
end
```

### 02-command-execution.lua
**Difficulty**: Beginner  
**API Used**: `Cmd()`, command strings, result handling  
**Description**: Execute MA3 commands from Lua scripts with proper error handling and result processing.

**Key Concepts**:
- Using `Cmd()` function for command execution
- Building command strings dynamically
- Handling command results and errors
- Safe command execution patterns

**Usage Patterns**:
```lua
-- Safe command execution
local function safeCmd(command)
    local success, result = pcall(function()
        return Cmd(command)
    end)
    return success, result
end
```

### 03-data-retrieval.lua
**Difficulty**: Beginner  
**API Used**: Object properties, data access methods, type conversion  
**Description**: Retrieve and process data from the MA3 system, including object information and system state.

**Key Concepts**:
- Reading object properties and values
- Type checking and conversion
- Handling different data types
- Safe data access patterns

**Usage Patterns**:
```lua
-- Safe property access
local function getProperty(obj, propName, default)
    if not obj then return default end
    local value = obj[propName]
    return value ~= nil and value or default
end
```

### 04-property-access.lua
**Difficulty**: Beginner  
**API Used**: Property getters/setters, validation, type safety  
**Description**: Learn safe patterns for reading and writing object properties with proper validation.

**Key Concepts**:
- Property reading and writing
- Value validation before setting
- Type safety and conversion
- Error handling for property access

**Usage Patterns**:
```lua
-- Safe property setting
local function setProperty(obj, propName, value)
    if not obj then return false end
    
    local success, error = pcall(function()
        obj[propName] = value
    end)
    
    return success, error
end
```

### 05-basic-loops.lua
**Difficulty**: Beginner  
**API Used**: Object iteration, collections, safe looping  
**Description**: Iterate through MA3 objects and collections safely and efficiently.

**Key Concepts**:
- Looping through object collections
- Safe iteration patterns
- Performance considerations
- Early exit strategies

**Usage Patterns**:
```lua
-- Safe object iteration
local function processObjects(objects)
    for i, obj in ipairs(objects or {}) do
        if obj and obj.name then
            -- Process each object safely
            Printf("Processing: " .. obj.name)
        end
    end
end
```

## Learning Path

### Step 1: Object Fundamentals
Start with `01-object-selection.lua` to understand:
- How MA3 objects work
- Safe object access patterns
- Object property basics

### Step 2: Command Control
Move to `02-command-execution.lua` to learn:
- Command execution basics
- Error handling
- Dynamic command building

### Step 3: Data Operations
Study `03-data-retrieval.lua` for:
- Reading system data
- Type handling
- Data validation

### Step 4: Property Management
Review `04-property-access.lua` to master:
- Safe property operations
- Value validation
- Error recovery

### Step 5: Collection Processing
Finish with `05-basic-loops.lua` to understand:
- Efficient iteration
- Safe looping patterns
- Performance optimization

## Common Patterns

### Error Handling
All examples demonstrate robust error handling:
```lua
local success, result = pcall(function()
    -- Potentially risky operation
    return riskyFunction()
end)

if not success then
    Printf("Error: " .. tostring(result))
    return nil
end
```

### Object Validation
Consistent object checking patterns:
```lua
local function isValidObject(obj)
    return obj ~= nil and type(obj) == "userdata"
end
```

### Safe Property Access
Defensive programming for property access:
```lua
local function safeGetProperty(obj, prop, default)
    if not isValidObject(obj) then
        return default
    end
    
    local value = obj[prop]
    return value ~= nil and value or default
end
```

## Integration Points

### API References
These examples demonstrate APIs documented in:
- [Core API](../../api-reference/core/) - Object and handle methods
- [Commands API](../../api-reference/commands/) - Command execution
- [Data API](../../api-reference/data/) - Data access and validation

### Utility Functions
Examples show usage of utilities from:
- [Validation Utils](../../utilities/validation/) - Input validation helpers
- [Error Handling Utils](../../utilities/error-handling/) - Error management
- [String Utils](../../utilities/string-utils/) - String manipulation

### Template Usage
Patterns from these examples appear in:
- [Basic Plugin Template](../../templates/basic-plugin/) - Foundation patterns
- [UI Plugin Template](../../templates/ui-plugin/) - Object access in UI
- [Data Plugin Template](../../templates/data-plugin/) - Data processing basics

## Best Practices

### Always Validate
- Check object existence before use
- Validate data types and ranges
- Handle nil values gracefully

### Error Recovery
- Use pcall for risky operations
- Provide meaningful error messages
- Implement fallback strategies

### Performance Awareness
- Minimize object lookups in loops
- Cache frequently accessed properties
- Use early returns to avoid unnecessary work

### Code Clarity
- Use descriptive variable names
- Comment the 'why' not just the 'what'
- Keep functions focused and small

## Next Steps

After mastering basic operations:
1. **UI Creation**: Learn to build user interfaces → [UI Examples](../ui-creation/)
2. **Data Management**: Advanced data handling → [Data Examples](../data-management/)
3. **Advanced Patterns**: Complex architectures → [Advanced Examples](../advanced-patterns/)

## Testing

All examples are:
- ✅ Tested on MA3 hardware
- ✅ Compatible with MA3 API 2.2+
- ✅ Performance optimized for console use
- ✅ Error handling verified