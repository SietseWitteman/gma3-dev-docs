---@meta
--- Basic Object Selection Examples
--- Demonstrates fundamental object selection and manipulation patterns in MA3
--- 
--- This example covers:
--- - Getting handles to different object types
--- - Object identification and addressing
--- - Basic object property access
--- - Safe object operations with error handling

---@class ObjectSelectionExamples
local ObjectSelectionExamples = {}

-- ========================================
-- BASIC OBJECT SELECTION PATTERNS
-- ========================================

---Get a fixture by ID number
---@param fixtureId number Fixture ID to retrieve
---@return Handle|nil fixture Fixture handle or nil if not found
---@usage
--- local fixture = getFixtureById(1)
--- if fixture then
---   Printf("Found fixture: " .. fixture:AddrNative())
--- end
local function getFixtureById(fixtureId)
    -- Safe method to get fixture handle
    local fixtureHandle = Root().ShowData.DataPools.Default.Fixtures[tostring(fixtureId)]
    
    if fixtureHandle then
        Printf("Successfully retrieved Fixture " .. fixtureId)
        return fixtureHandle
    else
        Printf("Warning: Fixture " .. fixtureId .. " not found")
        return nil
    end
end

---Get a group by ID number
---@param groupId number Group ID to retrieve
---@return Handle|nil group Group handle or nil if not found
---@usage
--- local group = getGroupById(1)
--- if group then
---   Printf("Group address: " .. group:Addr())
--- end
local function getGroupById(groupId)
    -- Access group from the default datapool
    local groupHandle = Root().ShowData.DataPools.Default.Groups[tostring(groupId)]
    
    if groupHandle then
        Printf("Successfully retrieved Group " .. groupId)
        return groupHandle
    else
        Printf("Warning: Group " .. groupId .. " not found")
        return nil
    end
end

---Get a cue by sequence and cue number
---@param sequenceId number Sequence ID containing the cue
---@param cueId number Cue ID to retrieve
---@return Handle|nil cue Cue handle or nil if not found
---@usage
--- local cue = getCueById(1, 1)
--- if cue then
---   Printf("Cue name: " .. cue.name)
--- end
local function getCueById(sequenceId, cueId)
    -- Navigate to specific cue in sequence
    local sequenceHandle = Root().ShowData.DataPools.Default.Sequences[tostring(sequenceId)]
    
    if not sequenceHandle then
        Printf("Warning: Sequence " .. sequenceId .. " not found")
        return nil
    end
    
    local cueHandle = sequenceHandle.Cues[tostring(cueId)]
    
    if cueHandle then
        Printf("Successfully retrieved Cue " .. cueId .. " from Sequence " .. sequenceId)
        return cueHandle
    else
        Printf("Warning: Cue " .. cueId .. " not found in Sequence " .. sequenceId)
        return nil
    end
end

-- ========================================
-- OBJECT IDENTIFICATION METHODS
-- ========================================

---Get object information including ID, name, and type
---@param objectHandle Handle Object to examine
---@return table objectInfo Table containing object details
---@usage
--- local fixture = getFixtureById(1)
--- local info = getObjectInfo(fixture)
--- Printf("Object: " .. info.name .. " (ID: " .. info.id .. ")")
local function getObjectInfo(objectHandle)
    if not objectHandle then
        return { error = "Invalid object handle" }
    end
    
    -- Gather basic object information
    local objectInfo = {
        id = objectHandle.id or "Unknown",
        name = objectHandle.name or "Unnamed",
        addr = objectHandle:Addr() or "No Address",
        addrNative = objectHandle:AddrNative() or "No Native Address",
        class = objectHandle.class or "Unknown Class"
    }
    
    return objectInfo
end

---Display comprehensive object information
---@param objectHandle Handle Object to analyze
---@usage
--- local group = getGroupById(1)
--- displayObjectDetails(group)
local function displayObjectDetails(objectHandle)
    if not objectHandle then
        Printf("Error: Cannot display details for invalid object")
        return
    end
    
    local info = getObjectInfo(objectHandle)
    
    Printf("=== Object Details ===")
    Printf("ID: " .. tostring(info.id))
    Printf("Name: " .. tostring(info.name))
    Printf("Command Address: " .. tostring(info.addr))
    Printf("Native Address: " .. tostring(info.addrNative))
    Printf("Class: " .. tostring(info.class))
    Printf("=====================")
end

-- ========================================
-- OBJECT PROPERTY ACCESS PATTERNS
-- ========================================

---Safely get object property with fallback
---@param objectHandle Handle Object to read from
---@param propertyName string Property name to retrieve
---@param defaultValue any Default value if property doesn't exist
---@return any propertyValue Property value or default
---@usage
--- local fixture = getFixtureById(1)
--- local patchAddress = safeGetProperty(fixture, "patch", "Not Patched")
local function safeGetProperty(objectHandle, propertyName, defaultValue)
    if not objectHandle then
        Printf("Warning: Cannot get property from invalid object")
        return defaultValue
    end
    
    -- Use pcall for safe property access
    local success, value = pcall(function()
        return objectHandle[propertyName]
    end)
    
    if success and value ~= nil then
        return value
    else
        Printf("Warning: Property '" .. propertyName .. "' not found, using default")
        return defaultValue
    end
end

---Check if object exists and is valid
---@param objectHandle Handle Object to validate
---@return boolean isValid True if object is valid and accessible
---@usage
--- local fixture = getFixtureById(999)
--- if not isValidObject(fixture) then
---   Printf("Fixture does not exist")
--- end
local function isValidObject(objectHandle)
    if not objectHandle then
        return false
    end
    
    -- Try to access a basic property to verify object validity
    local success, _ = pcall(function()
        return objectHandle.class
    end)
    
    return success
end

-- ========================================
-- PRACTICAL USAGE EXAMPLES
-- ========================================

---Example: Find and display information about multiple fixtures
---@usage
--- -- Find fixtures 1-5 and display their information
--- findAndDisplayFixtures({1, 2, 3, 4, 5})
local function findAndDisplayFixtures(fixtureIds)
    Printf("=== Fixture Search Results ===")
    
    for _, fixtureId in ipairs(fixtureIds) do
        local fixture = getFixtureById(fixtureId)
        
        if isValidObject(fixture) then
            local info = getObjectInfo(fixture)
            Printf("Fixture " .. fixtureId .. ": " .. info.name .. " (" .. info.addr .. ")")
        else
            Printf("Fixture " .. fixtureId .. ": Not found")
        end
    end
    
    Printf("=============================")
end

---Example: Get all groups and display basic information
---@usage
--- -- Display information about all existing groups
--- displayAllGroups()
local function displayAllGroups()
    Printf("=== All Groups ===")
    
    local groupsPool = Root().ShowData.DataPools.Default.Groups
    
    -- Iterate through groups pool
    for groupId, groupHandle in pairs(groupsPool) do
        if isValidObject(groupHandle) then
            local info = getObjectInfo(groupHandle)
            Printf("Group " .. groupId .. ": " .. info.name)
        end
    end
    
    Printf("==================")
end

-- ========================================
-- MAIN DEMONSTRATION FUNCTION
-- ========================================

---Run all basic object selection examples
---This function demonstrates all the patterns above
---@usage
--- -- Run from plugin or command line:
--- runObjectSelectionDemo()
function runObjectSelectionDemo()
    Printf("Starting Basic Object Selection Examples...")
    Printf("")
    
    -- Example 1: Get specific objects
    Printf("1. Getting specific objects:")
    local fixture1 = getFixtureById(1)
    local group1 = getGroupById(1)
    local cue = getCueById(1, 1)
    Printf("")
    
    -- Example 2: Display object details
    Printf("2. Displaying object details:")
    if fixture1 then
        displayObjectDetails(fixture1)
    end
    Printf("")
    
    -- Example 3: Safe property access
    Printf("3. Safe property access:")
    if fixture1 then
        local patchInfo = safeGetProperty(fixture1, "patch", "No patch info")
        Printf("Fixture 1 patch info: " .. tostring(patchInfo))
    end
    Printf("")
    
    -- Example 4: Multiple object search
    Printf("4. Multiple fixture search:")
    findAndDisplayFixtures({1, 2, 3, 10, 50})
    Printf("")
    
    -- Example 5: Display all groups
    Printf("5. All groups overview:")
    displayAllGroups()
    
    Printf("")
    Printf("Basic Object Selection Examples completed!")
end

-- Export the demo function for external use
return {
    runDemo = runObjectSelectionDemo,
    getFixtureById = getFixtureById,
    getGroupById = getGroupById,
    getCueById = getCueById,
    getObjectInfo = getObjectInfo,
    displayObjectDetails = displayObjectDetails,
    safeGetProperty = safeGetProperty,
    isValidObject = isValidObject
}