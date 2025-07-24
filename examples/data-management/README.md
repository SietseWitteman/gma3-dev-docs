# Data Management Examples

Data handling, validation, and processing patterns for managing information effectively within GrandMA3 plugins.

## Overview

Master data operations in MA3 plugins with examples covering:
- Input validation and sanitization
- Data transformation and processing
- Persistent data storage and retrieval
- Import/export operations and data exchange

## Available Examples

### 01-data-validation.lua
**Difficulty**: Beginner  
**API Used**: Type checking, validation functions, error handling  
**Description**: Comprehensive input validation patterns for ensuring data quality and preventing errors.

**Key Concepts**:
- Type validation for different data types
- Range checking for numeric values
- Format validation for strings
- Custom validation rules and business logic

**Usage Patterns**:
```lua
-- Comprehensive validation function
local function validateInput(value, validationType, constraints)
    if validationType == "number" then
        return validateNumber(value, constraints)
    elseif validationType == "string" then
        return validateString(value, constraints)
    else
        return false, "Unknown validation type"
    end
end
```

### 02-data-processing.lua
**Difficulty**: Intermediate  
**API Used**: Data transformation, table operations, mathematical functions  
**Description**: Transform and manipulate data efficiently with common processing patterns and algorithms.

**Key Concepts**:
- Data type conversion and casting
- Array and table manipulation
- Mathematical operations and calculations
- Data aggregation and summarization

**Usage Patterns**:
```lua
-- Data transformation pipeline
local function processData(inputData, processors)
    local result = inputData
    for _, processor in ipairs(processors) do
        result = processor(result)
        if not result then break end
    end
    return result
end
```

### 03-data-storage.lua
**Difficulty**: Intermediate  
**API Used**: Persistent storage, configuration management, data serialization  
**Description**: Store and retrieve plugin data persistently with proper error handling and data integrity.

**Key Concepts**:
- Plugin configuration storage
- User preference management
- Data serialization and deserialization
- File-based data persistence

**Usage Patterns**:
```lua
-- Plugin data storage
local function savePluginData(pluginName, data)
    local serialized = serializeData(data)
    return writeToStorage(pluginName, serialized)
end

local function loadPluginData(pluginName, defaultData)
    local stored = readFromStorage(pluginName)
    return stored and deserializeData(stored) or defaultData
end
```

### 04-import-export.lua
**Difficulty**: Intermediate  
**API Used**: File operations, data parsing, format conversion  
**Description**: Handle external data sources and export plugin data in various formats.

**Key Concepts**:
- File format detection and parsing
- Data format conversion (CSV, JSON, XML)
- Import validation and error recovery
- Export formatting and optimization

**Usage Patterns**:
```lua
-- Generic import function
local function importData(filePath, format)
    local rawData = readFile(filePath)
    if not rawData then
        return nil, "File not found"
    end
    
    local parser = getParser(format)
    return parser(rawData)
end
```

### 05-data-structures.lua
**Difficulty**: Advanced  
**API Used**: Complex data structures, algorithms, memory management  
**Description**: Work with complex data structures efficiently for advanced plugin functionality.

**Key Concepts**:
- Custom data structure implementation
- Efficient search and sort algorithms
- Memory-conscious data handling
- Performance optimization techniques

**Usage Patterns**:
```lua
-- Efficient data structure for MA3 objects
local ObjectCache = {
    data = {},
    indices = {},
    
    add = function(self, obj)
        local key = obj.id or #self.data + 1
        self.data[key] = obj
        self.indices[#self.indices + 1] = key
    end,
    
    find = function(self, predicate)
        for _, key in ipairs(self.indices) do
            if predicate(self.data[key]) then
                return self.data[key]
            end
        end
        return nil
    end
}
```

### 06-batch-operations.lua
**Difficulty**: Advanced  
**API Used**: Bulk operations, performance optimization, error aggregation  
**Description**: Process large amounts of data efficiently with batch operations and error handling.

**Key Concepts**:
- Batch processing strategies
- Performance monitoring and optimization
- Error aggregation and reporting
- Progress tracking and user feedback

**Usage Patterns**:
```lua
-- Batch operation with progress tracking
local function batchProcess(items, processor, batchSize, progressCallback)
    local results = {}
    local errors = {}
    
    for i = 1, #items, batchSize do
        local batch = {}
        for j = i, math.min(i + batchSize - 1, #items) do
            batch[#batch + 1] = items[j]
        end
        
        local batchResults, batchErrors = processBatch(batch, processor)
        mergeResults(results, batchResults)
        mergeErrors(errors, batchErrors)
        
        if progressCallback then
            progressCallback(i + #batch - 1, #items)
        end
    end
    
    return results, errors
end
```

## Learning Path

### Phase 1: Data Fundamentals (Examples 01-02)
- Input validation and sanitization
- Basic data transformation
- Type safety and error handling
- Simple processing algorithms

### Phase 2: Storage and Exchange (Examples 03-04)
- Persistent data storage
- Configuration management
- File import/export operations
- Data format conversion

### Phase 3: Advanced Techniques (Examples 05-06)
- Complex data structures
- Performance optimization
- Batch processing strategies
- Memory management

## Common Data Patterns

### Validation Pipeline
```lua
local function createValidationPipeline(validators)
    return function(data)
        for _, validator in ipairs(validators) do
            local isValid, error = validator(data)
            if not isValid then
                return false, error
            end
        end
        return true, data
    end
end
```

### Safe Data Access
```lua
local function safeGet(data, path, default)
    local current = data
    for _, key in ipairs(path) do
        if type(current) ~= "table" or current[key] == nil then
            return default
        end
        current = current[key]
    end
    return current
end
```

### Data Transformation Chain
```lua
local function chain(value, ...)
    local transformers = {...}
    for _, transformer in ipairs(transformers) do
        value = transformer(value)
        if value == nil then break end
    end
    return value
end
```

## Validation Patterns

### Numeric Validation
```lua
local function validateNumber(value, min, max)
    local num = tonumber(value)
    if not num then
        return false, "Must be a number"
    end
    if min and num < min then
        return false, "Must be at least " .. min
    end
    if max and num > max then
        return false, "Must be at most " .. max
    end
    return true, num
end
```

### String Validation
```lua
local function validateString(value, pattern, minLength, maxLength)
    if type(value) ~= "string" then
        return false, "Must be a string"
    end
    if minLength and #value < minLength then
        return false, "Must be at least " .. minLength .. " characters"
    end
    if maxLength and #value > maxLength then
        return false, "Must be at most " .. maxLength .. " characters"
    end
    if pattern and not value:match(pattern) then
        return false, "Invalid format"
    end
    return true, value
end
```

## Integration Points

### API References
Data examples demonstrate APIs from:
- [Data API](../../api-reference/data/) - Data access and validation methods
- [Core API](../../api-reference/core/) - Object property handling
- [System API](../../api-reference/system/) - File operations and persistence

### Utility Functions
Examples use utilities from:
- [Validation Utils](../../utilities/validation/) - Input validation helpers
- [Table Utils](../../utilities/table-utils/) - Table manipulation functions
- [String Utils](../../utilities/string-utils/) - String processing utilities

### Template Integration
Data patterns appear in:
- [Data Plugin Template](../../templates/data-plugin/) - Complete data processing plugin
- [Advanced Plugin Template](../../templates/advanced-plugin/) - Complex data management
- [Basic Plugin Template](../../templates/basic-plugin/) - Simple data handling

## Best Practices

### Data Safety
- **Always Validate**: Check all input data before processing
- **Type Safety**: Ensure data types match expectations
- **Range Checking**: Validate numeric ranges and string lengths
- **Null Handling**: Handle missing or nil values gracefully

### Performance
- **Lazy Loading**: Load data only when needed
- **Caching**: Cache frequently accessed data
- **Batch Processing**: Process large datasets efficiently
- **Memory Management**: Clean up large data structures

### Error Handling
- **Graceful Degradation**: Provide fallbacks for invalid data
- **Clear Messages**: Give users helpful error messages
- **Error Aggregation**: Collect and report multiple errors together
- **Recovery Strategies**: Allow users to correct errors and retry

### Code Organization
- **Modular Validation**: Create reusable validation functions
- **Separation of Concerns**: Keep validation, processing, and storage separate
- **Configuration**: Make validation rules configurable
- **Documentation**: Document data formats and validation rules

## Advanced Techniques

### Schema Validation
```lua
local function validateSchema(data, schema)
    for field, rules in pairs(schema) do
        local value = data[field]
        for _, rule in ipairs(rules) do
            local isValid, error = rule(value)
            if not isValid then
                return false, field .. ": " .. error
            end
        end
    end
    return true
end
```

### Data Migration
```lua
local function migrateData(oldData, migrations)
    local version = oldData._version or 1
    local currentData = deepCopy(oldData)
    
    for v = version, #migrations do
        currentData = migrations[v](currentData)
        currentData._version = v + 1
    end
    
    return currentData
end
```

### Efficient Searching
```lua
local function createIndex(data, keyFunction)
    local index = {}
    for i, item in ipairs(data) do
        local key = keyFunction(item)
        if not index[key] then
            index[key] = {}
        end
        table.insert(index[key], i)
    end
    return index
end
```

## Testing and Validation

All data examples include:
- ✅ **Edge Case Testing**: Validated with boundary conditions and invalid input
- ✅ **Performance Testing**: Benchmarked with large datasets
- ✅ **Memory Testing**: Verified for memory efficiency and cleanup
- ✅ **Error Testing**: Tested with various error conditions
- ✅ **Integration Testing**: Verified with actual MA3 data types

## Next Steps

After mastering data management:
1. **Advanced Patterns**: Complex architectures → [Advanced Examples](../advanced-patterns/)
2. **Complete Plugins**: Full implementations → [Complete Plugins](../complete-plugins/)
3. **UI Integration**: Combine with user interfaces → [UI Examples](../ui-creation/)

## Common Use Cases

### Plugin Configuration
- User preference storage
- Plugin settings management
- Default value handling
- Configuration validation

### Data Processing Pipelines
- Multi-step data transformation
- Error handling and recovery
- Progress tracking
- Result aggregation

### External Data Integration
- File import/export
- Format conversion
- Data synchronization
- Validation and cleanup