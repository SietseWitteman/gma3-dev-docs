---@meta
--- Data Access API Reference
--- Methods for reading and writing MA3 object properties and values
--- 
--- This module provides comprehensive methods for accessing MA3 data,
--- including property reading/writing, object traversal, and data retrieval.

---@class DataAccess
local DataAccess = {}

-- ========================================
-- PROPERTY ACCESS METHODS
-- ========================================

---Get object property value (from Handle class)
---Primary method for reading object properties in MA3
---@param object Handle Object handle to read from
---@param propertyName string Name of property to retrieve
---@param roleInteger? integer Optional role for text formatting
---@return string property Property value as string
---@usage
--- local fixture = Obj("Fixture 1")
--- if fixture then
---     local name = fixture:Get("name")
---     local intensity = fixture:Get("intensity")
---     Printf(name .. " intensity: " .. intensity)
--- end
function DataAccess.GetProperty(object, propertyName, roleInteger)
    if not object then return "" end
    return object:Get(propertyName, roleInteger)
end

---Get multiple properties from an object efficiently
---@param object Handle Object handle to read from
---@param properties table Array of property names to retrieve
---@return table values Table mapping property names to values
---@usage
--- local fixture = Obj("Fixture 1")
--- local props = DataAccess.GetMultipleProperties(fixture, {"name", "intensity", "color"})
--- Printf("Name: " .. props.name .. ", Intensity: " .. props.intensity)
function DataAccess.GetMultipleProperties(object, properties)
    local values = {}
    if not object then return values end
    
    for _, propName in ipairs(properties) do
        values[propName] = object:Get(propName) or ""
    end
    
    return values
end

---Get property with type conversion and default value
---@param object Handle Object handle to read from
---@param propertyName string Property name
---@param dataType string Expected data type ("number", "boolean", "string")
---@param defaultValue any Default value if property is missing or invalid
---@return any value Converted property value or default
---@usage
--- local intensity = DataAccess.GetTypedProperty(fixture, "intensity", "number", 0)
--- local isActive = DataAccess.GetTypedProperty(sequence, "active", "boolean", false)
function DataAccess.GetTypedProperty(object, propertyName, dataType, defaultValue)
    if not object then return defaultValue end
    
    local rawValue = object:Get(propertyName)
    if not rawValue or rawValue == "" then
        return defaultValue
    end
    
    if dataType == "number" then
        local num = tonumber(rawValue)
        return num or defaultValue
    elseif dataType == "boolean" then
        local lower = tostring(rawValue):lower()
        return lower == "true" or lower == "yes" or lower == "1" or lower == "on"
    elseif dataType == "string" then
        return tostring(rawValue)
    end
    
    return rawValue
end

---Set object property value (conceptual - actual implementation may vary)
---@param object Handle Object handle to write to
---@param propertyName string Property name
---@param value any Property value
---@return boolean success True if property was set successfully
---@usage
--- local success = DataAccess.SetProperty(fixture, "intensity", 75)
--- if not success then
---     Printf("Failed to set intensity")
--- end
function DataAccess.SetProperty(object, propertyName, value)
    if not object then return false end
    
    local success, error = pcall(function()
        object[propertyName] = value
    end)
    
    if not success then
        Printf("Error setting property " .. propertyName .. ": " .. tostring(error))
        return false
    end
    
    return true
end

---Set multiple properties on an object
---@param object Handle Object handle to write to
---@param properties table Table mapping property names to values
---@return table results Table mapping property names to success status
---@usage
--- local results = DataAccess.SetMultipleProperties(fixture, {
---     intensity = 75,
---     color = "Red",
---     position_pan = 45
--- })
function DataAccess.SetMultipleProperties(object, properties)
    local results = {}
    if not object then return results end
    
    for propName, value in pairs(properties) do
        results[propName] = DataAccess.SetProperty(object, propName, value)
    end
    
    return results
end

-- ========================================
-- OBJECT HIERARCHY TRAVERSAL
-- ========================================

---Get all child objects from a parent handle
---@param parent Handle Parent object handle
---@return table children Array of child Handle objects
---@usage
--- local showdata = Obj("Root")
--- local children = DataAccess.GetChildren(showdata)
--- for i, child in ipairs(children) do
---     Printf("Child " .. i .. ": " .. child:ToAddr(true))
--- end
function DataAccess.GetChildren(parent)
    if not parent then return {} end
    return parent:Children()
end

---Get child object by index
---@param parent Handle Parent object handle
---@param index integer 1-based child index
---@return Handle|nil child Child handle or nil if not found
---@usage
--- local firstChild = DataAccess.GetChildByIndex(parent, 1)
--- if firstChild then
---     Printf("First child: " .. firstChild:ToAddr(true))
--- end
function DataAccess.GetChildByIndex(parent, index)
    if not parent then return nil end
    return parent:Ptr(index)
end

---Get child count efficiently
---@param parent Handle Parent object handle
---@return integer count Number of child objects
---@usage
--- local count = DataAccess.GetChildCount(parent)
--- Printf("Parent has " .. count .. " children")
function DataAccess.GetChildCount(parent)
    if not parent then return 0 end
    return parent:Count()
end

---Find child objects matching criteria
---@param parent Handle Parent object handle
---@param predicate function Function that takes a child handle and returns boolean
---@return table matches Array of matching child handles
---@usage
--- local fixtures = DataAccess.FindChildren(parent, function(child)
---     return child:GetClass() == "Fixture"
--- end)
function DataAccess.FindChildren(parent, predicate)
    local matches = {}
    if not parent then return matches end
    
    local children = parent:Children()
    for _, child in ipairs(children) do
        if predicate(child) then
            table.insert(matches, child)
        end
    end
    
    return matches
end

---Traverse object hierarchy with callback
---@param root Handle Root object to start traversal
---@param callback function Function called for each object (object, depth)
---@param maxDepth? integer Optional maximum traversal depth
---@usage
--- DataAccess.TraverseHierarchy(root, function(obj, depth)
---     local indent = string.rep("  ", depth)
---     Printf(indent .. obj:ToAddr(true) .. " (" .. obj:GetClass() .. ")")
--- end, 3)
function DataAccess.TraverseHierarchy(root, callback, maxDepth)
    maxDepth = maxDepth or 10
    
    local function traverse(obj, depth)
        if not obj or depth > maxDepth then return end
        
        callback(obj, depth)
        
        local children = obj:Children()
        for _, child in ipairs(children) do
            traverse(child, depth + 1)
        end
    end
    
    traverse(root, 0)
end

-- ========================================
-- OBJECT INFORMATION AND METADATA
-- ========================================

---Get comprehensive object information
---@param object Handle Object handle to inspect
---@return table info Object information table
---@usage
--- local info = DataAccess.GetObjectInfo(fixture)
--- Printf("Object: " .. info.name .. " (" .. info.class .. ")")
--- Printf("Address: " .. info.address .. ", Children: " .. info.childCount)
function DataAccess.GetObjectInfo(object)
    local info = {
        valid = false,
        class = "",
        name = "",
        address = "",
        childCount = 0,
        childClass = "",
        properties = {}
    }
    
    if not object then return info end
    
    info.valid = true
    info.class = object:GetClass() or ""
    info.name = object:Get("name") or ""
    info.address = object:ToAddr(true) or ""
    info.childCount = object:Count() or 0
    info.childClass = object:GetChildClass() or ""
    
    -- Get common properties
    local commonProps = {"index", "type", "id", "enabled", "locked"}
    for _, prop in ipairs(commonProps) do
        info.properties[prop] = object:Get(prop) or ""
    end
    
    return info
end

---Get object dependencies
---@param object Handle Object handle to check
---@return table dependencies Array of dependent object handles
---@usage
--- local deps = DataAccess.GetObjectDependencies(cue)
--- Printf("Cue depends on " .. #deps .. " objects")
function DataAccess.GetObjectDependencies(object)
    if not object then return {} end
    return object:GetDependencies()
end

---Get objects that reference this object
---@param object Handle Object handle to check
---@return string references Reference information
---@usage
--- local refs = DataAccess.GetObjectReferences(group)
--- if refs and refs ~= "" then
---     Printf("Referenced by: " .. refs)
--- end
function DataAccess.GetObjectReferences(object)
    if not object then return "" end
    return object:GetReferences()
end

---Check if object exists and is valid
---@param object Handle Object handle to validate
---@return boolean valid True if object is valid and accessible
---@usage
--- if DataAccess.IsValidObject(fixture) then
---     -- Safe to access object properties
--- end
function DataAccess.IsValidObject(object)
    if not object then return false end
    
    local success, result = pcall(function()
        return object:GetClass()
    end)
    
    return success and result ~= nil
end

-- ========================================
-- BATCH DATA OPERATIONS
-- ========================================

---Get properties from multiple objects efficiently
---@param objects table Array of object handles
---@param properties table Array of property names
---@return table results Array of property tables for each object
---@usage
--- local fixtures = {Obj("Fixture 1"), Obj("Fixture 2")}
--- local data = DataAccess.BatchGetProperties(fixtures, {"name", "intensity"})
--- for i, props in ipairs(data) do
---     Printf("Fixture " .. i .. ": " .. props.name .. " @ " .. props.intensity)
--- end
function DataAccess.BatchGetProperties(objects, properties)
    local results = {}
    
    for i, obj in ipairs(objects) do
        if DataAccess.IsValidObject(obj) then
            results[i] = DataAccess.GetMultipleProperties(obj, properties)
        else
            results[i] = {}
        end
    end
    
    return results
end

---Set properties on multiple objects
---@param objects table Array of object handles
---@param properties table Table mapping property names to values
---@return table results Array of success status for each object
---@usage
--- local fixtures = {Obj("Fixture 1"), Obj("Fixture 2")}
--- local results = DataAccess.BatchSetProperties(fixtures, {intensity = 75})
function DataAccess.BatchSetProperties(objects, properties)
    local results = {}
    
    for i, obj in ipairs(objects) do
        if DataAccess.IsValidObject(obj) then
            results[i] = DataAccess.SetMultipleProperties(obj, properties)
        else
            results[i] = {error = "Invalid object"}
        end
    end
    
    return results
end

---Find objects matching criteria across multiple parents
---@param parents table Array of parent object handles
---@param predicate function Function to test each object
---@return table matches Array of matching objects with parent info
---@usage
--- local parents = {Obj("ShowData"), Obj("UserData")}
--- local allFixtures = DataAccess.BatchFindObjects(parents, function(obj)
---     return obj:GetClass() == "Fixture"
--- end)
function DataAccess.BatchFindObjects(parents, predicate)
    local matches = {}
    
    for _, parent in ipairs(parents) do
        if DataAccess.IsValidObject(parent) then
            local found = DataAccess.FindChildren(parent, predicate)
            for _, obj in ipairs(found) do
                table.insert(matches, {
                    object = obj,
                    parent = parent,
                    parentAddress = parent:ToAddr(true)
                })
            end
        end
    end
    
    return matches
end

-- ========================================
-- CONFIGURATION DATA ACCESS
-- ========================================

---Get MA3 configuration table
---@return table config Configuration data table
---@usage
--- local config = DataAccess.GetConfiguration()
--- for key, value in pairs(config) do
---     Printf("Config " .. key .. ": " .. tostring(value))
--- end
function DataAccess.GetConfiguration()
    local success, config = pcall(ConfigTable)
    if success and config then
        return config
    end
    return {}
end

---Get system information safely
---@return table sysInfo System information table
---@usage
--- local info = DataAccess.GetSystemInfo()
--- Printf("MA3 Version: " .. (info.version or "Unknown"))
function DataAccess.GetSystemInfo()
    local info = {}
    
    -- Try to get system information from various sources
    local config = DataAccess.GetConfiguration()
    info.version = config.version or "Unknown"
    info.build = config.build or "Unknown"
    
    -- Add timestamp
    info.timestamp = os.time()
    info.date = os.date("%Y-%m-%d %H:%M:%S")
    
    return info
end

-- ========================================
-- DATA CACHING AND PERFORMANCE
-- ========================================

---Simple cache implementation for property values
---@class PropertyCache
local PropertyCache = {
    cache = {},
    maxAge = 5, -- seconds
    
    ---Get cached property or fetch new value
    ---@param object Handle Object handle
    ---@param property string Property name
    ---@return string value Property value
    get = function(self, object, property)
        if not object then return "" end
        
        local key = tostring(object) .. ":" .. property
        local now = os.time()
        
        -- Check if cached value is still valid
        if self.cache[key] and (now - self.cache[key].time) < self.maxAge then
            return self.cache[key].value
        end
        
        -- Fetch new value
        local value = object:Get(property) or ""
        self.cache[key] = {
            value = value,
            time = now
        }
        
        return value
    end,
    
    ---Clear cache entries
    clear = function(self)
        self.cache = {}
    end,
    
    ---Clear expired cache entries
    cleanup = function(self)
        local now = os.time()
        for key, entry in pairs(self.cache) do
            if (now - entry.time) >= self.maxAge then
                self.cache[key] = nil
            end
        end
    end
}

---Get cached property value
---@param object Handle Object handle
---@param property string Property name
---@return string value Cached or fresh property value
---@usage
--- local intensity = DataAccess.GetCachedProperty(fixture, "intensity")
function DataAccess.GetCachedProperty(object, property)
    return PropertyCache:get(object, property)
end

---Clear property cache
---@usage
--- DataAccess.ClearPropertyCache() -- Clear all cached properties
function DataAccess.ClearPropertyCache()
    PropertyCache:clear()
end

-- ========================================
-- SAFE DATA ACCESS PATTERNS
-- ========================================

---Safely access nested object properties
---@param root Handle Root object handle
---@param path table Array of property/child access steps
---@param defaultValue any Default value if path is invalid
---@return any value Retrieved value or default
---@usage
--- -- Access ShowData.Fixtures.1.Name safely
--- local name = DataAccess.SafeAccessPath(root, {"ShowData", "Fixtures", 1, "Name"}, "Unknown")
function DataAccess.SafeAccessPath(root, path, defaultValue)
    local current = root
    
    for _, step in ipairs(path) do
        if not current then
            return defaultValue
        end
        
        if type(step) == "number" then
            -- Access child by index
            current = current:Ptr(step)
        elseif type(step) == "string" then
            -- Access property or child by name
            local child = nil
            local children = current:Children()
            for _, c in ipairs(children) do
                if c:Get("name") == step then
                    child = c
                    break
                end
            end
            
            if child then
                current = child
            else
                -- Try as property
                local prop = current:Get(step)
                if prop then
                    return prop
                else
                    return defaultValue
                end
            end
        end
    end
    
    return current or defaultValue
end

---Execute function with object validation
---@param object Handle Object to validate
---@param operation function Function to execute with object
---@param errorHandler? function Optional error handler function
---@return any result Operation result or nil
---@usage
--- local result = DataAccess.WithValidObject(fixture, function(obj)
---     return obj:Get("intensity")
--- end, function(error)
---     Printf("Error: " .. error)
--- end)
function DataAccess.WithValidObject(object, operation, errorHandler)
    if not DataAccess.IsValidObject(object) then
        if errorHandler then
            errorHandler("Invalid object")
        end
        return nil
    end
    
    local success, result = pcall(operation, object)
    if not success then
        if errorHandler then
            errorHandler(result)
        end
        return nil
    end
    
    return result
end

-- ========================================
-- USAGE EXAMPLES AND PATTERNS
-- ========================================

--[[
COMMON USAGE PATTERNS:

1. Basic Property Access:
   local fixture = Obj("Fixture 1")
   if DataAccess.IsValidObject(fixture) then
       local intensity = DataAccess.GetTypedProperty(fixture, "intensity", "number", 0)
       local name = DataAccess.GetProperty(fixture, "name")
       Printf(name .. " is at " .. intensity .. "%")
   end

2. Batch Data Retrieval:
   local fixtures = {}
   for i = 1, 10 do
       table.insert(fixtures, Obj("Fixture " .. i))
   end
   
   local data = DataAccess.BatchGetProperties(fixtures, {"name", "intensity", "color"})
   for i, props in ipairs(data) do
       if props.name then
           Printf("Fixture: " .. props.name .. " @ " .. props.intensity)
       end
   end

3. Hierarchy Traversal:
   local root = Obj("Root")
   DataAccess.TraverseHierarchy(root, function(obj, depth)
       local indent = string.rep("  ", depth)
       local info = DataAccess.GetObjectInfo(obj)
       Printf(indent .. info.address .. " (" .. info.class .. ")")
   end, 3)

4. Safe Data Access with Error Handling:
   local result = DataAccess.WithValidObject(someObject, function(obj)
       return DataAccess.GetMultipleProperties(obj, {"name", "type", "value"})
   end, function(error)
       Printf("Failed to access object: " .. error)
   end)

5. Cached Property Access for Performance:
   -- For frequently accessed properties, use caching
   local intensity = DataAccess.GetCachedProperty(fixture, "intensity")
   
   -- Periodically clean up expired cache entries
   DataAccess.ClearPropertyCache()

6. Finding Objects with Criteria:
   local activeSequences = DataAccess.FindChildren(root, function(child)
       return child:GetClass() == "Sequence" and 
              DataAccess.GetTypedProperty(child, "active", "boolean", false)
   end)

INTEGRATION WITH OTHER SYSTEMS:
- Use with Handle methods for direct object manipulation
- Combine with command system for data-driven command generation
- Integrate with UI systems for data display and editing
- Connect with validation systems for data integrity

PERFORMANCE CONSIDERATIONS:
- Use batch operations for multiple objects
- Cache frequently accessed properties
- Validate objects before accessing properties
- Use typed property access to avoid repeated conversions
- Clean up caches periodically to prevent memory leaks

ERROR HANDLING BEST PRACTICES:
- Always validate objects before accessing
- Use pcall for operations that might fail
- Provide meaningful default values
- Log errors for debugging
- Implement fallback strategies for critical operations
]]

return DataAccess