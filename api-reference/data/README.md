# Data API Reference

Data handling, manipulation, and storage operations for managing information within GrandMA3 plugins.

## Overview

The Data API provides comprehensive tools for working with MA3 data:
- **Data Access**: Reading and writing MA3 object properties and values
- **Data Validation**: Input validation, type checking, and sanitization
- **Data Conversion**: Type conversion, formatting, and transformation utilities

## Available Documentation

### Data Access (`data-access.*`)
Methods for reading and writing MA3 data structures:
- **Property Access**: Getting and setting object properties
- **Value Retrieval**: Reading numeric, string, and boolean values
- **Batch Operations**: Efficient bulk data operations
- **Data Persistence**: Storing and retrieving plugin data

*Files: `data-access.lua`, `data-access.json`, `data-access.md`*

### Data Validation (`data-validation.*`)
Input validation and type checking utilities:
- **Type Validation**: Ensuring data matches expected types
- **Range Checking**: Validating numeric ranges and bounds
- **Format Validation**: Checking string formats and patterns
- **Constraint Checking**: Business rule validation

*Files: `data-validation.lua`, `data-validation.json`, `data-validation.md`*

### Data Conversion (`data-conversion.*`)
Type conversion and formatting operations:
- **Type Conversion**: Converting between data types safely
- **Number Formatting**: Formatting numeric values for display
- **String Processing**: Text manipulation and formatting
- **Data Transformation**: Converting between different data structures

*Files: `data-conversion.lua`, `data-conversion.json`, `data-conversion.md`*

## Key Concepts

### MA3 Data Types
MA3 works with several core data types:
```lua
-- Numeric values (integers and floats)
local intensity = 75.5
local cueNumber = 1

-- String values
local objectName = "MyFixture"
local colorName = "Red"

-- Boolean values
local isActive = true
local isSelected = false

-- Handle objects
local fixtureHandle = Obj()
```

### Property System
All MA3 objects have properties accessible through handles:
```lua
local fixture = Obj()
if fixture then
    -- Read property
    local intensity = fixture.intensity
    
    -- Write property (if writable)
    fixture.intensity = 50
end
```

### Data Persistence
Plugins can store data for later retrieval:
```lua
-- Store data (varies by MA3 implementation)
-- Read stored data
```

## Usage Patterns

### Safe Property Access
Always validate data access operations:
```lua
local function getProperty(obj, propertyName, defaultValue)
    if not obj then
        return defaultValue
    end
    
    local success, value = pcall(function()
        return obj[propertyName]
    end)
    
    return success and value or defaultValue
end
```

### Data Validation
Validate input before processing:
```lua
local function validateIntensity(value)
    -- Convert to number if string
    local numValue = tonumber(value)
    if not numValue then
        return false, "Invalid number format"
    end
    
    -- Check range
    if numValue < 0 or numValue > 100 then
        return false, "Intensity must be between 0 and 100"
    end
    
    return true, numValue
end
```

### Type Conversion
Safe conversion between types:
```lua
local function toNumber(value, default)
    local num = tonumber(value)
    return num or default or 0
end

local function toString(value, default)
    if value == nil then
        return default or ""
    end
    return tostring(value)
end

local function toBoolean(value)
    if type(value) == "boolean" then
        return value
    elseif type(value) == "string" then
        local lower = value:lower()
        return lower == "true" or lower == "yes" or lower == "1"
    elseif type(value) == "number" then
        return value ~= 0
    else
        return false
    end
end
```

### Batch Data Operations
Efficiently process multiple objects:
```lua
local function updateMultipleFixtures(fixtures, property, value)
    local results = {}
    
    for i, fixture in ipairs(fixtures) do
        local success, error = pcall(function()
            fixture[property] = value
        end)
        
        results[i] = {
            success = success,
            error = error
        }
    end
    
    return results
end
```

## Data Categories

### Numeric Data
Working with numbers and calculations:
```lua
-- Intensity values (0-100)
local intensity = 75.5

-- Position values (degrees)
local pan = 45.0
local tilt = -30.5

-- Time values (seconds)
local fadeTime = 2.5
```

### String Data
Text and name handling:
```lua
-- Object names
local objectName = "Moving Light 1"

-- Color names
local colorName = "Red"

-- Command strings
local command = "Fixture 1 At 50"
```

### Boolean Data
True/false values and states:
```lua
-- Object states
local isActive = true
local isSelected = false

-- Feature flags
local hasColor = true
local canMove = false
```

### Complex Data
Structured data and collections:
```lua
-- Arrays/tables
local fixtureList = {1, 2, 3, 4, 5}
local colorTable = {r = 255, g = 0, b = 0}

-- Nested structures
local cueData = {
    number = 1,
    name = "Opening Look",
    fadeTime = 3.0,
    fixtures = {
        {id = 1, intensity = 100},
        {id = 2, intensity = 75}
    }
}
```

## Cross-References

### Related Enums
- Data types and formats: `/enums/data-types.md`
- Validation rules and constraints: `/enums/validation-types.md`
- Object property types: `/enums/object-properties.md`

### Examples
- Data access patterns: `/examples/data-management/`
- Validation examples: `/examples/data-management/validation.lua`
- Type conversion: `/examples/data-management/conversion.lua`

### Templates
- Data processing plugin: `/templates/data-plugin/`
- Validation patterns: `/templates/data-plugin/validation.lua`

### Utilities
- Data validation helpers: `/utilities/validation/`
- Type conversion utilities: `/utilities/string-utils/conversion.lua`
- Table manipulation: `/utilities/table-utils/`

## Best Practices

### Data Safety
- **Validation**: Always validate input data before processing
- **Type Checking**: Verify data types match expectations
- **Range Checking**: Ensure numeric values are within valid ranges
- **Null Checking**: Handle nil/null values gracefully

### Performance
- **Batch Operations**: Process multiple items efficiently
- **Caching**: Cache frequently accessed data
- **Lazy Loading**: Load data only when needed
- **Memory Management**: Clean up large data structures

### Error Handling
- **Graceful Degradation**: Provide sensible defaults when data is invalid
- **User Feedback**: Inform users of data validation errors
- **Logging**: Log data processing errors for debugging
- **Recovery**: Implement recovery strategies for data corruption

## Compatibility

- **MA3 API 2.2**: Full support for all data access methods
- **Data Types**: Compatible with Lua and MA3 type systems
- **Future Versions**: Data API designed for forward compatibility
- **Performance**: Optimized for console memory and processing constraints