---@meta
--- Basic Data Retrieval Examples
--- Demonstrates fundamental data access and retrieval patterns in MA3
--- 
--- This example covers:
--- - Accessing show data and configuration
--- - Reading object properties and attributes
--- - Navigating the MA3 object hierarchy
--- - Extracting system information
--- - Safe data access with error handling

---@class DataRetrievalExamples
local DataRetrievalExamples = {}

-- ========================================
-- CORE SYSTEM DATA ACCESS
-- ========================================

---Get basic system information
---@return table systemInfo Table containing system details
---@usage
--- local info = getSystemInfo()
--- Printf("MA3 Version: " .. info.version)
local function getSystemInfo()
    local systemInfo = {}
    
    -- Safe system property access
    local function safeGetSystemProperty(propertyPath, description)
        local success, value = pcall(function()
            local current = Root()
            for part in string.gmatch(propertyPath, "[^%.]+") do
                current = current[part]
            end
            return current
        end)
        
        if success and value ~= nil then
            Printf("System " .. description .. ": " .. tostring(value))
            return value
        else
            Printf("Warning: Could not retrieve " .. description)
            return "Unknown"
        end
    end
    
    Printf("=== System Information ===")
    
    -- Gather system information
    systemInfo.buildDate = safeGetSystemProperty("BuildDate", "Build Date")
    systemInfo.buildNumber = safeGetSystemProperty("BuildNumber", "Build Number")
    systemInfo.buildDetails = safeGetSystemProperty("BuildDetails", "Build Details")
    systemInfo.buildVersion = safeGetSystemProperty("BuildVersion", "Version")
    
    Printf("==========================")
    
    return systemInfo
end

---Get current show information
---@return table showInfo Table containing show details
---@usage
--- local show = getShowInfo()
--- Printf("Show: " .. show.name)
local function getShowInfo()
    local showInfo = {}
    
    Printf("=== Show Information ===")
    
    -- Access show data safely
    local success, showData = pcall(function()
        return Root().ShowData
    end)
    
    if not success or not showData then
        Printf("Error: Cannot access show data")
        return { error = "Show data not accessible" }
    end
    
    -- Gather show information
    showInfo.name = showData.name or "Unnamed Show"
    showInfo.version = showData.version or "Unknown Version"
    
    Printf("Show Name: " .. showInfo.name)
    Printf("Show Version: " .. showInfo.version)
    
    -- Get datapool information
    local defaultPool = showData.DataPools and showData.DataPools.Default
    if defaultPool then
        Printf("Default DataPool found")
        showInfo.hasDefaultDataPool = true
    else
        Printf("Warning: Default DataPool not found")
        showInfo.hasDefaultDataPool = false
    end
    
    Printf("========================")
    
    return showInfo
end

-- ========================================
-- FIXTURE DATA RETRIEVAL
-- ========================================

---Get comprehensive fixture information
---@param fixtureId number Fixture ID to examine
---@return table|nil fixtureInfo Fixture information or nil if not found
---@usage
--- local info = getFixtureInfo(1)
--- if info then
---   Printf("Fixture Type: " .. info.fixtureType)
--- end
local function getFixtureInfo(fixtureId)
    if not fixtureId then
        Printf("Error: Fixture ID is required")
        return nil
    end
    
    -- Get fixture handle
    local fixture = Root().ShowData.DataPools.Default.Fixtures[tostring(fixtureId)]
    if not fixture then
        Printf("Warning: Fixture " .. fixtureId .. " not found")
        return nil
    end
    
    Printf("=== Fixture " .. fixtureId .. " Information ===")
    
    local fixtureInfo = {}
    
    -- Safe property retrieval function
    local function getFixtureProperty(propertyName, description, defaultValue)
        local success, value = pcall(function()
            return fixture[propertyName]
        end)
        
        if success and value ~= nil then
            Printf(description .. ": " .. tostring(value))
            return value
        else
            Printf(description .. ": " .. tostring(defaultValue or "Not Available"))
            return defaultValue
        end
    end
    
    -- Gather fixture properties
    fixtureInfo.id = getFixtureProperty("id", "ID", fixtureId)
    fixtureInfo.name = getFixtureProperty("name", "Name", "Fixture " .. fixtureId)
    fixtureInfo.fixtureType = getFixtureProperty("fixtureType", "Fixture Type", "Unknown")
    fixtureInfo.patch = getFixtureProperty("patch", "Patch Address", "Not Patched")
    fixtureInfo.mode = getFixtureProperty("mode", "Mode", "Unknown")
    
    -- Get addressing information
    fixtureInfo.addr = fixture:Addr() or "No Address"
    fixtureInfo.addrNative = fixture:AddrNative() or "No Native Address"
    
    Printf("Command Address: " .. fixtureInfo.addr)
    Printf("Native Address: " .. fixtureInfo.addrNative)
    
    Printf("=====================================")
    
    return fixtureInfo
end

---Get current fixture values (intensity, color, etc.)
---@param fixtureId number Fixture ID to examine
---@return table|nil fixtureValues Current fixture values or nil if not found
---@usage
--- local values = getFixtureValues(1)
--- if values and values.intensity then
---   Printf("Current intensity: " .. values.intensity .. "%")
--- end
local function getFixtureValues(fixtureId)
    if not fixtureId then
        Printf("Error: Fixture ID is required")
        return nil
    end
    
    local fixture = Root().ShowData.DataPools.Default.Fixtures[tostring(fixtureId)]
    if not fixture then
        Printf("Warning: Fixture " .. fixtureId .. " not found")
        return nil
    end
    
    Printf("=== Fixture " .. fixtureId .. " Current Values ===")
    
    local values = {}
    
    -- Function to safely get attribute values
    local function getAttributeValue(attributeName, description)
        local success, value = pcall(function()
            -- Note: This is a simplified example - actual attribute access
            -- may require different methods depending on MA3 API structure
            return fixture[attributeName]
        end)
        
        if success and value ~= nil then
            Printf(description .. ": " .. tostring(value))
            return value
        else
            Printf(description .. ": Not Available")
            return nil
        end
    end
    
    -- Try to get common attribute values
    values.intensity = getAttributeValue("intensity", "Intensity")
    values.red = getAttributeValue("red", "Red")
    values.green = getAttributeValue("green", "Green")
    values.blue = getAttributeValue("blue", "Blue")
    values.pan = getAttributeValue("pan", "Pan")
    values.tilt = getAttributeValue("tilt", "Tilt")
    
    Printf("=====================================")
    
    return values
end

-- ========================================
-- GROUP AND PRESET DATA
-- ========================================

---Get group information and contents
---@param groupId number Group ID to examine
---@return table|nil groupInfo Group information or nil if not found
---@usage
--- local info = getGroupInfo(1)
--- if info then
---   Printf("Group contains " .. #info.fixtures .. " fixtures")
--- end
local function getGroupInfo(groupId)
    if not groupId then
        Printf("Error: Group ID is required")
        return nil
    end
    
    local group = Root().ShowData.DataPools.Default.Groups[tostring(groupId)]
    if not group then
        Printf("Warning: Group " .. groupId .. " not found")
        return nil
    end
    
    Printf("=== Group " .. groupId .. " Information ===")
    
    local groupInfo = {}
    
    -- Get basic group properties
    groupInfo.id = group.id or groupId
    groupInfo.name = group.name or ("Group " .. groupId)
    groupInfo.addr = group:Addr() or "No Address"
    
    Printf("ID: " .. tostring(groupInfo.id))
    Printf("Name: " .. groupInfo.name)
    Printf("Address: " .. groupInfo.addr)
    
    -- Try to get group contents (fixtures)
    groupInfo.fixtures = {}
    local success, fixtures = pcall(function()
        return group.Fixtures or {}
    end)
    
    if success and fixtures then
        Printf("Group Contents:")
        for fixtureId, _ in pairs(fixtures) do
            table.insert(groupInfo.fixtures, fixtureId)
            Printf("  - Fixture " .. tostring(fixtureId))
        end
    else
        Printf("Group contents: Not accessible")
    end
    
    Printf("===============================")
    
    return groupInfo
end

---List all available presets of a specific type
---@param presetType string Preset type to list (e.g., "Intensity", "Color")
---@return table presetList Array of preset information
---@usage
--- local colorPresets = listPresets("Color")
--- Printf("Found " .. #colorPresets .. " color presets")
local function listPresets(presetType)
    if not presetType or presetType == "" then
        Printf("Error: Preset type is required")
        return {}
    end
    
    Printf("=== " .. presetType .. " Presets ===")
    
    local presetList = {}
    
    -- Access preset pool
    local success, presetPool = pcall(function()
        return Root().ShowData.DataPools.Default[presetType .. "Presets"]
    end)
    
    if not success or not presetPool then
        Printf("Warning: Cannot access " .. presetType .. " presets")
        return presetList
    end
    
    -- List all presets
    for presetId, preset in pairs(presetPool) do
        if preset then
            local presetInfo = {
                id = presetId,
                name = preset.name or ("Preset " .. presetId),
                addr = preset:Addr() or "No Address"
            }
            
            table.insert(presetList, presetInfo)
            Printf("Preset " .. presetId .. ": " .. presetInfo.name)
        end
    end
    
    Printf("Found " .. #presetList .. " " .. presetType:lower() .. " presets")
    Printf("===========================")
    
    return presetList
end

-- ========================================
-- SEQUENCE AND CUE DATA
-- ========================================

---Get sequence information including cue list
---@param sequenceId number Sequence ID to examine
---@return table|nil sequenceInfo Sequence information or nil if not found
---@usage
--- local info = getSequenceInfo(1)
--- if info then
---   Printf("Sequence has " .. #info.cues .. " cues")
--- end
local function getSequenceInfo(sequenceId)
    if not sequenceId then
        Printf("Error: Sequence ID is required")
        return nil
    end
    
    local sequence = Root().ShowData.DataPools.Default.Sequences[tostring(sequenceId)]
    if not sequence then
        Printf("Warning: Sequence " .. sequenceId .. " not found")
        return nil
    end
    
    Printf("=== Sequence " .. sequenceId .. " Information ===")
    
    local sequenceInfo = {}
    
    -- Get basic sequence properties
    sequenceInfo.id = sequence.id or sequenceId
    sequenceInfo.name = sequence.name or ("Sequence " .. sequenceId)
    sequenceInfo.addr = sequence:Addr() or "No Address"
    
    Printf("ID: " .. tostring(sequenceInfo.id))
    Printf("Name: " .. sequenceInfo.name)
    Printf("Address: " .. sequenceInfo.addr)
    
    -- Get cue information
    sequenceInfo.cues = {}
    local success, cues = pcall(function()
        return sequence.Cues or {}
    end)
    
    if success and cues then
        Printf("Cues in sequence:")
        for cueId, cue in pairs(cues) do
            if cue then
                local cueInfo = {
                    id = cueId,
                    name = cue.name or ("Cue " .. cueId),
                    fadeTime = cue.fadeTime or "Default"
                }
                
                table.insert(sequenceInfo.cues, cueInfo)
                Printf("  Cue " .. cueId .. ": " .. cueInfo.name .. " (Fade: " .. tostring(cueInfo.fadeTime) .. ")")
            end
        end
    else
        Printf("Cues: Not accessible")
    end
    
    Printf("===================================")
    
    return sequenceInfo
end

-- ========================================
-- DISPLAY AND UI DATA
-- ========================================

---Get information about available displays
---@return table displayInfo Array of display information
---@usage
--- local displays = getDisplayInfo()
--- Printf("Found " .. #displays .. " displays")
local function getDisplayInfo()
    Printf("=== Display Information ===")
    
    local displayInfo = {}
    
    -- Try different methods to get display information
    local success, focusDisplay = pcall(function()
        return GetFocusDisplay()
    end)
    
    if success and focusDisplay then
        local focusIndex = focusDisplay.Index or "Unknown"
        Printf("Focus Display Index: " .. tostring(focusIndex))
        
        displayInfo.focusDisplay = {
            index = focusIndex,
            handle = focusDisplay
        }
    else
        Printf("Focus Display: Not accessible")
    end
    
    -- Try to get display by index
    for i = 1, 8 do
        local displaySuccess, display = pcall(function()
            return GetDisplayByIndex(i)
        end)
        
        if displaySuccess and display then
            local displayData = {
                index = i,
                handle = display,
                name = display.name or ("Display " .. i)
            }
            
            table.insert(displayInfo, displayData)
            Printf("Display " .. i .. ": " .. displayData.name)
        end
    end
    
    Printf("Found " .. #displayInfo .. " accessible displays")
    Printf("===========================")
    
    return displayInfo
end

-- ========================================
-- MAIN DEMONSTRATION FUNCTION
-- ========================================

---Run all basic data retrieval examples
---This function demonstrates all the patterns above
---@usage
--- -- Run from plugin or command line:
--- runDataRetrievalDemo()
function runDataRetrievalDemo()
    Printf("Starting Basic Data Retrieval Examples...")
    Printf("")
    
    -- Example 1: System information
    Printf("1. System Information:")
    getSystemInfo()
    Printf("")
    
    -- Example 2: Show information
    Printf("2. Show Information:")
    getShowInfo()
    Printf("")
    
    -- Example 3: Fixture information
    Printf("3. Fixture Information:")
    getFixtureInfo(1)
    getFixtureValues(1)
    Printf("")
    
    -- Example 4: Group information
    Printf("4. Group Information:")
    getGroupInfo(1)
    Printf("")
    
    -- Example 5: Preset information
    Printf("5. Preset Information:")
    listPresets("Intensity")
    listPresets("Color")
    Printf("")
    
    -- Example 6: Sequence information
    Printf("6. Sequence Information:")
    getSequenceInfo(1)
    Printf("")
    
    -- Example 7: Display information
    Printf("7. Display Information:")
    getDisplayInfo()
    
    Printf("")
    Printf("Basic Data Retrieval Examples completed!")
end

-- Export functions for external use
return {
    runDemo = runDataRetrievalDemo,
    getSystemInfo = getSystemInfo,
    getShowInfo = getShowInfo,
    getFixtureInfo = getFixtureInfo,
    getFixtureValues = getFixtureValues,
    getGroupInfo = getGroupInfo,
    listPresets = listPresets,
    getSequenceInfo = getSequenceInfo,
    getDisplayInfo = getDisplayInfo
}