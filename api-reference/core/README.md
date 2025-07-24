# Core API Reference

Fundamental GrandMA3 objects, handle methods, and core system operations. This section contains the essential building blocks that every MA3 plugin needs.

## Overview

The Core API provides the foundation for all MA3 plugin development:
- **Handle System**: The primary object interface for all MA3 entities
- **Object Management**: Creating, accessing, and manipulating MA3 objects
- **Basic Operations**: Essential functions for plugin functionality

## Available Documentation

### Handle Methods (`handle-methods.*`)
Complete reference for the Handle object and its methods:
- **Address Resolution**: `Addr()`, `ToAddr()` methods for object addressing
- **Property Access**: Getting and setting object properties
- **Object Hierarchy**: Parent-child relationships and navigation
- **Object Information**: Type checking, existence validation

*Files: `handle-methods.lua`, `handle-methods.json`, `handle-methods.md`*

### Object System (`object-system.*`)
Core object creation and management:
- **Object Creation**: `Obj()` function and object instantiation
- **Object Lifecycle**: Creation, modification, deletion patterns
- **Object References**: Handle management and memory considerations

*Files: `object-system.lua`, `object-system.json`, `object-system.md`*

### Basic Operations (`basic-operations.*`)
Essential functions for common plugin tasks:
- **Selection Operations**: Working with selected objects
- **Property Queries**: Getting object information and states
- **Error Handling**: Safe object access patterns

*Files: `basic-operations.lua`, `basic-operations.json`, `basic-operations.md`*

## Key Concepts

### Handle Objects
The Handle class is the primary interface for all MA3 objects:
```lua
local myObject = Obj()  -- Get a handle to an object
local address = myObject:Addr()  -- Get object's address
```

### Object Addressing
MA3 uses address-based object identification:
- **Numeric Addresses**: `1.2.3` format for precise object location
- **Named References**: String-based object identification
- **Relative Addressing**: Context-dependent object references

### Property System
All MA3 objects have properties accessible through handles:
- **Property Reading**: Getting current values
- **Property Writing**: Setting new values with validation
- **Property Types**: Understanding data types and constraints

## Usage Patterns

### Safe Object Access
Always validate object existence before accessing properties:
```lua
local obj = Obj()
if obj then
    local value = obj.someProperty
end
```

### Error Handling
Implement proper error checking for robust plugins:
```lua
local success, result = pcall(function()
    return obj:SomeMethod()
end)
```

## Cross-References

### Related Enums
- Object types and categories: `/enums/object-types.md`
- Property data types: `/enums/data-types.md`

### Examples
- Basic object operations: `/examples/basic-operations/`
- Object selection patterns: `/examples/basic-operations/01-object-selection.lua`

### Utilities
- Object validation helpers: `/utilities/validation/`
- Safe property access: `/utilities/error-handling/`

## Compatibility

- **MA3 API 2.2**: Full support for all documented methods
- **Future Versions**: Core API designed for backward compatibility
- **Performance**: All operations optimized for MA3 hardware constraints