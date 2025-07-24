# Handle Methods Reference

Complete documentation for all Handle object methods in the GrandMA3 API. The Handle class is the foundation of all MA3 object interaction, providing consistent methods for accessing and manipulating fixtures, groups, cues, and all other MA3 objects.

## Overview

Every object in the MA3 system is accessed through a Handle, which provides:
- **Consistent Interface**: All objects share the same basic methods
- **Safe Access**: Built-in validation and error handling
- **Flexible Addressing**: Multiple ways to reference objects
- **Hierarchy Navigation**: Methods to traverse object relationships

## Object Access

### Obj() Function

The primary function for accessing MA3 objects.

```lua
Obj(objectPath?)
```

**Parameters:**
- `objectPath` (string, optional): Path to specific object

**Returns:**
- `Handle` or `nil`: Handle to object or nil if not found

**Examples:**
```lua
-- Get currently selected object
local selected = Obj()

-- Get specific fixture
local fixture1 = Obj("Fixture 1")

-- Get root object
local root = Obj("Root")
```

## Address and Identification Methods

### Addr()

Convert handle to address string for use in commands.

```lua
Handle:Addr(baseLocationHandle?, useToAddrIndex?, isCueObject?)
```

**Parameters:**
- `baseLocationHandle` (Handle, optional): Base location (default: root)
- `useToAddrIndex` (boolean, optional): Use ToAddr index instead of Addr index
- `isCueObject` (boolean, optional): Fix cue address resolution

**Returns:**
- `string`: Command-compatible address string

**Usage:**
```lua
local fixture = Obj()
local address = fixture:Addr()
Cmd("Fixture " .. address .. " At 100")
```

### AddrNative()

Convert handle to native address string.

```lua
Handle:AddrNative(baseLocationHandle?, returnNamesInQuotes?)
```

**Parameters:**
- `baseLocationHandle` (Handle, optional): Base location (default: root)
- `returnNamesInQuotes` (boolean, optional): Return names in quotes

**Returns:**
- `string`: Native format address string

**Usage:**
```lua
local group = Obj()
local nativeAddr = group:AddrNative()
Printf("Native address: " .. nativeAddr)
```

### ToAddr()

Convert handle to address string with name/index control.

```lua
Handle:ToAddr(returnName)
```

**Parameters:**
- `returnName` (boolean, required): true=return name, false=return type and index

**Returns:**
- `string`: Address string in requested format

**Usage:**
```lua
local obj = Obj()
local nameAddr = obj:ToAddr(true)   -- "MyFixture"
local indexAddr = obj:ToAddr(false) -- "Fixture 1"
```

## Hierarchy and Navigation Methods

### Children()

Get all child objects.

```lua
Handle:Children()
```

**Returns:**
- `table`: Array of child Handle objects

**Usage:**
```lua
local parent = Obj()
local children = parent:Children()
for i, child in ipairs(children) do
    Printf("Child " .. i .. ": " .. child:ToAddr(true))
end
```

### Count()

Get number of child objects efficiently.

```lua
Handle:Count()
```

**Returns:**
- `integer`: Number of immediate child objects

**Usage:**
```lua
local parent = Obj()
local childCount = parent:Count()
Printf("This object has " .. childCount .. " children")
```

### Ptr()

Get handle to child object by index.

```lua
Handle:Ptr(childIndex)
```

**Parameters:**
- `childIndex` (integer, required): 1-based index of child object

**Returns:**
- `Handle` or `nil`: Child handle or nil if index invalid

**Usage:**
```lua
local parent = Obj()
local firstChild = parent:Ptr(1)
if firstChild then
    Printf("First child: " .. firstChild:ToAddr(true))
end
```

## Object Information Methods

### GetClass()

Get object's class name.

```lua
Handle:GetClass()
```

**Returns:**
- `string`: Class name (e.g., "Fixture", "Group", "Cue")

**Usage:**
```lua
local obj = Obj()
local class = obj:GetClass()
if class == "Fixture" then
    -- Handle fixture-specific logic
end
```

### GetChildClass()

Get class name of child objects.

```lua
Handle:GetChildClass()
```

**Returns:**
- `string`: Class name of child objects

**Usage:**
```lua
local container = Obj()
local childClass = container:GetChildClass()
Printf("This container holds: " .. childClass .. " objects")
```

### Get()

Get object property value - the primary method for reading object properties.

```lua
Handle:Get(propertyName, roleInteger?)
```

**Parameters:**
- `propertyName` (string, required): Name of property to retrieve
- `roleInteger` (integer, optional): Role for text formatting

**Returns:**
- `string`: Property value as string

**Usage:**
```lua
local fixture = Obj()
local name = fixture:Get("name")
local intensity = fixture:Get("intensity")
```

## Debugging and Inspection Methods

### Dump()

Print comprehensive object information to Command Line History.

```lua
Handle:Dump()
```

**Usage:**
```lua
local obj = Obj()
obj:Dump()  -- Prints detailed object info to console
```

### GetDependencies()

Get objects that this object depends on.

```lua
Handle:GetDependencies()
```

**Returns:**
- `table`: Array of dependent object handles

**Usage:**
```lua
local cue = Obj()
local deps = cue:GetDependencies()
Printf("This cue depends on " .. #deps .. " objects")
```

### GetReferences()

Get information about what references this object.

```lua
Handle:GetReferences()
```

**Returns:**
- `string`: Reference information

**Usage:**
```lua
local group = Obj()
local refs = group:GetReferences()
Printf("Referenced by: " .. refs)
```

## User Interface Methods

### GetUIEditor()

Get the name of the UI editor associated with this object type.

```lua
Handle:GetUIEditor()
```

**Returns:**
- `string`: Name of UI editor

**Usage:**
```lua
local obj = Obj()
local editor = obj:GetUIEditor()
Printf("Edit with: " .. editor)
```

### GetUISettings()

Get the name of the UI settings panel for this object type.

```lua
Handle:GetUISettings()
```

**Returns:**
- `string`: Name of settings panel

**Usage:**
```lua
local obj = Obj()
local settings = obj:GetUISettings()
Printf("Settings panel: " .. settings)
```

## Fader and Playback Methods

### GetFader()

Retrieve current fader value for supported objects.

```lua
Handle:GetFader(tokenAndIndex)
```

**Parameters:**
- `tokenAndIndex` (table, required): `{token="FaderMaster|FaderX|FaderRate|etc", index=number}`

**Returns:**
- `number`: Current fader value (0.0 to 1.0)

**Usage:**
```lua
local sequence = Obj()
local faderValue = sequence:GetFader({token="FaderMaster", index=1})
Printf("Fader at: " .. (faderValue * 100) .. "%")
```

### GetFaderText()

Retrieve fader value as formatted text.

```lua
Handle:GetFaderText(tokenAndIndex)
```

**Parameters:**
- `tokenAndIndex` (table, required): `{token="FaderMaster|FaderX|FaderRate|etc", index=number}`

**Returns:**
- `string`: Formatted fader text

**Usage:**
```lua
local sequence = Obj()
local faderText = sequence:GetFaderText({token="FaderMaster", index=1})
Printf("Fader: " .. faderText)
```

### SetFader()

Update fader value for supported objects.

```lua
Handle:SetFader(settingsTable)
```

**Parameters:**
- `settingsTable` (table, required): `{value=number, token="FaderMaster|etc", faderEnabled=boolean}`

**Usage:**
```lua
local sequence = Obj()
sequence:SetFader({
    value = 0.75,
    token = "FaderMaster",
    faderEnabled = true
})
```

### HasActivePlayback()

Determine if object is currently playing back.

```lua
Handle:HasActivePlayback()
```

**Returns:**
- `boolean`: true if object is actively playing

**Usage:**
```lua
local cue = Obj()
if cue:HasActivePlayback() then
    Printf("Cue is currently active")
end
```

## Import/Export Methods

### Export()

Save object data to external XML file.

```lua
Handle:Export(filePath, fileName)
```

**Parameters:**
- `filePath` (string, required): Directory path for export
- `fileName` (string, required): Name of file to create

**Returns:**
- `boolean`: true if export succeeded

**Usage:**
```lua
local showdata = Obj()
local success = showdata:Export("/path/to/exports/", "backup.xml")
if success then
    Printf("Export completed successfully")
end
```

### Import()

Load object data from external XML file.

```lua
Handle:Import(filePath, fileName)
```

**Parameters:**
- `filePath` (string, required): Directory path containing file
- `fileName` (string, required): Name of file to import

**Returns:**
- `boolean`: true if import succeeded

**Usage:**
```lua
local showdata = Obj()
local success = showdata:Import("/path/to/imports/", "data.xml")
if success then
    Printf("Import completed successfully")
end
```

## Common Usage Patterns

### Safe Object Access

Always validate object handles before use:

```lua
local obj = Obj()
if obj then
    local name = obj:Get("name")
    Printf("Object: " .. name)
else
    Printf("Object not found")
end
```

### Property Access with Defaults

Provide fallback values for missing properties:

```lua
local function getProperty(obj, prop, default)
    if not obj then return default end
    local value = obj:Get(prop)
    return value ~= "" and value or default
end

local fixture = Obj()
local name = getProperty(fixture, "name", "Unknown Fixture")
```

### Hierarchy Navigation

Safely iterate through object hierarchies:

```lua
local parent = Obj()
if parent then
    local childCount = parent:Count()
    for i = 1, childCount do
        local child = parent:Ptr(i)
        if child then
            Printf("Child " .. i .. ": " .. child:ToAddr(true))
        end
    end
end
```

### Command-Safe Addressing

Build commands with proper addressing:

```lua
local obj = Obj()
if obj then
    local addr = obj:Addr()
    local success = pcall(Cmd, "Select " .. addr)
    if not success then
        Printf("Command failed for object: " .. addr)
    end
end
```

### Type-Safe Object Handling

Check object types before type-specific operations:

```lua
local obj = Obj()
if obj then
    local objClass = obj:GetClass()
    if objClass == "Fixture" then
        -- Handle fixture-specific operations
        local intensity = obj:Get("intensity")
        Printf("Fixture intensity: " .. intensity)
    elseif objClass == "Group" then
        -- Handle group-specific operations
        local members = obj:Children()
        Printf("Group has " .. #members .. " members")
    end
end
```

## Performance Considerations

### Efficiency Tips

1. **Cache Handles**: Store frequently used object handles instead of calling `Obj()` repeatedly
2. **Use Count() First**: Check `Count()` before calling `Children()` for large hierarchies
3. **Minimize Dump() Usage**: Use specific property access instead of `Dump()` for performance
4. **Batch Operations**: Group multiple property accesses together when possible

```lua
-- Good: Cache the handle
local fixture = Obj("Fixture 1")
if fixture then
    local name = fixture:Get("name")
    local intensity = fixture:Get("intensity")
    local color = fixture:Get("color")
end

-- Less efficient: Multiple Obj() calls
local name = Obj("Fixture 1"):Get("name")
local intensity = Obj("Fixture 1"):Get("intensity")
local color = Obj("Fixture 1"):Get("color")
```

### Memory Management

- Handle objects are managed by the MA3 system
- No explicit cleanup required for handles
- Avoid holding references to handles across long operations

## Error Handling Best Practices

### Robust Object Access

```lua
local function safeObjectOperation(objectPath, operation)
    local obj = Obj(objectPath)
    if not obj then
        Printf("Error: Object not found: " .. tostring(objectPath))
        return nil
    end
    
    local success, result = pcall(operation, obj)
    if not success then
        Printf("Error processing object: " .. tostring(result))
        return nil
    end
    
    return result
end

-- Usage
local result = safeObjectOperation("Fixture 1", function(fixture)
    return fixture:Get("intensity")
end)
```

### Property Access with Validation

```lua
local function safeGetProperty(obj, propertyName, expectedType, default)
    if not obj then
        return default
    end
    
    local success, value = pcall(obj.Get, obj, propertyName)
    if not success then
        Printf("Error accessing property: " .. propertyName)
        return default
    end
    
    if expectedType == "number" then
        local numValue = tonumber(value)
        return numValue or default
    end
    
    return value or default
end
```

## Integration with Other APIs

### Command Integration

Handle methods work seamlessly with the Command API:

```lua
local function selectAndModify(objectPath, property, value)
    local obj = Obj(objectPath)
    if obj then
        local addr = obj:Addr()
        Cmd("Select " .. addr)
        Cmd(property .. " " .. value)
    end
end
```

### UI Integration

Use handle methods in dialog callbacks:

```lua
CreateInputDialog("Select Fixture", "Enter fixture number:", function(result)
    if result then
        local fixture = Obj("Fixture " .. result)
        if fixture then
            local name = fixture:Get("name")
            Printf("Selected: " .. name)
        else
            Printf("Fixture not found: " .. result)
        end
    end
end)
```

## See Also

- [Basic Operations Examples](../../examples/basic-operations/) - Practical usage examples
- [Object System Documentation](./object-system.md) - Object creation and lifecycle
- [Core API Overview](./README.md) - Complete core API reference
- [Commands API](../commands/) - Command execution methods