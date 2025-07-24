---@meta
--- Handle Methods - Complete Reference
--- Core object manipulation methods for all MA3 objects
--- 
--- The Handle class is the foundation of all MA3 object interaction.
--- Every object in the MA3 system (fixtures, groups, cues, etc.) is accessed
--- through a Handle, providing consistent methods for object manipulation.

---@class Handle
--- Main object handle class for all MA3 objects
--- All MA3 objects inherit from this base Handle class
Handle = {}

---Create a new Handle instance
---@return Handle handle New handle instance
function Handle:new()
    local instance = setmetatable({}, { __index = Handle })
    return instance
end

-- ========================================
-- ADDRESS AND IDENTIFICATION METHODS
-- ========================================

---Convert handle to address string for use in commands
---This is the primary method for getting command-compatible addresses
---@param baseLocationHandle? Handle Optional base location (default: root)
---@param useToAddrIndex? boolean Optional use ToAddr index instead of Addr index
---@param isCueObject? boolean Optional fix cue address resolution
---@return string numericRootAddress Command-compatible address string
---@usage
--- local fixture = Obj()
--- local address = fixture:Addr()
--- Cmd("Fixture " .. address .. " At 100")
function Handle:Addr(baseLocationHandle, useToAddrIndex, isCueObject)
    return ""
end

---Convert handle to native address string
---Returns the object's native address format
---@param baseLocationHandle? Handle Optional base location (default: root)
---@param returnNamesInQuotes? boolean Optional return names in quotes
---@return string nativeAddress Native format address string
---@usage
--- local group = Obj()
--- local nativeAddr = group:AddrNative()
--- Printf("Native address: " .. nativeAddr)
function Handle:AddrNative(baseLocationHandle, returnNamesInQuotes)
    return ""
end

---Convert handle to address string with name/index control
---@param returnName boolean true=return name, false=return type and index
---@return string address Address string in requested format
---@usage
--- local obj = Obj()
--- local nameAddr = obj:ToAddr(true)   -- "MyFixture"
--- local indexAddr = obj:ToAddr(false) -- "Fixture 1"
function Handle:ToAddr(returnName)
    return ""
end

-- ========================================
-- HIERARCHY AND NAVIGATION METHODS
-- ========================================

---Get all child objects
---Returns a table containing all immediate child objects
---@return table children Array of child Handle objects
---@usage
--- local parent = Obj()
--- local children = parent:Children()
--- for i, child in ipairs(children) do
---     Printf("Child " .. i .. ": " .. child:ToAddr(true))
--- end
function Handle:Children()
    return {}
end

---Get number of child objects
---Efficient way to check child count without loading all children
---@return integer count Number of immediate child objects
---@usage
--- local parent = Obj()
--- local childCount = parent:Count()
--- Printf("This object has " .. childCount .. " children")
function Handle:Count()
    return 0
end

---Get handle to child object by index
---Access child objects by their position in the hierarchy
---@param childIndex integer 1-based index of child object
---@return Handle|nil child Child handle or nil if index invalid
---@usage
--- local parent = Obj()
--- local firstChild = parent:Ptr(1)
--- if firstChild then
---     Printf("First child: " .. firstChild:ToAddr(true))
--- end
function Handle:Ptr(childIndex)
    return Handle:new()
end

-- ========================================
-- OBJECT INFORMATION METHODS
-- ========================================

---Get object's class name
---Returns the MA3 class type of this object
---@return string className Class name (e.g., "Fixture", "Group", "Cue")
---@usage
--- local obj = Obj()
--- local class = obj:GetClass()
--- if class == "Fixture" then
---     -- Handle fixture-specific logic
--- end
function Handle:GetClass()
    return ""
end

---Get class name of child objects
---Useful for understanding what type of children this object contains
---@return string className Class name of child objects
---@usage
--- local container = Obj()
--- local childClass = container:GetChildClass()
--- Printf("This container holds: " .. childClass .. " objects")
function Handle:GetChildClass()
    return ""
end

---Get object property value
---Primary method for reading object properties
---@param propertyName string Name of property to retrieve
---@param roleInteger? integer Optional role for text formatting
---@return string property Property value as string
---@usage
--- local fixture = Obj()
--- local name = fixture:Get("name")
--- local intensity = fixture:Get("intensity")
function Handle:Get(propertyName, roleInteger)
    return ""
end

-- ========================================
-- DEBUGGING AND INSPECTION METHODS
-- ========================================

---Print object information to Command Line History
---Displays comprehensive object information for debugging
---@usage
--- local obj = Obj()
--- obj:Dump()  -- Prints detailed object info to console
function Handle:Dump()
end

---Get object dependencies
---Returns objects that this object depends on
---@return table dependencies Array of dependent object handles
---@usage
--- local cue = Obj()
--- local deps = cue:GetDependencies()
--- Printf("This cue depends on " .. #deps .. " objects")
function Handle:GetDependencies()
    return {}
end

---Get objects referencing this object
---Returns information about what references this object
---@return string references Reference information
---@usage
--- local group = Obj()
--- local refs = group:GetReferences()
--- Printf("Referenced by: " .. refs)
function Handle:GetReferences()
    return ""
end

-- ========================================
-- USER INTERFACE METHODS
-- ========================================

---Get UI editor name for object
---Returns the name of the UI editor associated with this object type
---@return string uiEditorName Name of UI editor
---@usage
--- local obj = Obj()
--- local editor = obj:GetUIEditor()
--- Printf("Edit with: " .. editor)
function Handle:GetUIEditor()
    return ""
end

---Get UI settings name for object
---Returns the name of the UI settings panel for this object type
---@return string uiSettingsName Name of settings panel
---@usage
--- local obj = Obj()
--- local settings = obj:GetUISettings()
--- Printf("Settings panel: " .. settings)
function Handle:GetUISettings()
    return ""
end

-- ========================================
-- FADER AND PLAYBACK METHODS
-- ========================================

---Get fader value
---Retrieve current fader value for supported objects
---@param tokenAndIndex table {token="FaderMaster|FaderX|FaderRate|etc", index=number}
---@return number value Current fader value (0.0 to 1.0)
---@usage
--- local sequence = Obj()
--- local faderValue = sequence:GetFader({token="FaderMaster", index=1})
--- Printf("Fader at: " .. (faderValue * 100) .. "%")
function Handle:GetFader(tokenAndIndex)
    return 0
end

---Get fader text value
---Retrieve fader value as formatted text
---@param tokenAndIndex table {token="FaderMaster|FaderX|FaderRate|etc", index=number}
---@return string text Formatted fader text
---@usage
--- local sequence = Obj()
--- local faderText = sequence:GetFaderText({token="FaderMaster", index=1})
--- Printf("Fader: " .. faderText)
function Handle:GetFaderText(tokenAndIndex)
    return ""
end

---Set fader value
---Update fader value for supported objects
---@param settingsTable table {value=number, token="FaderMaster|etc", faderEnabled=boolean}
---@usage
--- local sequence = Obj()
--- sequence:SetFader({
---     value = 0.75,
---     token = "FaderMaster",
---     faderEnabled = true
--- })
function Handle:SetFader(settingsTable)
end

---Check if object has active playback
---Determine if object is currently playing back
---@return boolean hasActivePlayback true if object is actively playing
---@usage
--- local cue = Obj()
--- if cue:HasActivePlayback() then
---     Printf("Cue is currently active")
--- end
function Handle:HasActivePlayback()
    return true
end

-- ========================================
-- IMPORT/EXPORT METHODS
-- ========================================

---Export object to XML file
---Save object data to external XML file
---@param filePath string Directory path for export
---@param fileName string Name of file to create
---@return boolean success true if export succeeded
---@usage
--- local showdata = Obj()
--- local success = showdata:Export("/path/to/exports/", "backup.xml")
--- if success then
---     Printf("Export completed successfully")
--- end
function Handle:Export(filePath, fileName)
    return true
end

---Import XML file into object
---Load object data from external XML file
---@param filePath string Directory path containing file
---@param fileName string Name of file to import
---@return boolean success true if import succeeded
---@usage
--- local showdata = Obj()
--- local success = showdata:Import("/path/to/imports/", "data.xml")
--- if success then
---     Printf("Import completed successfully")
--- end
function Handle:Import(filePath, fileName)
    return true
end

-- ========================================
-- GLOBAL OBJECT ACCESS FUNCTION
-- ========================================

---Get handle to MA3 object
---Primary function for accessing MA3 objects
---@param objectPath? string Optional path to specific object
---@return Handle|nil handle Handle to object or nil if not found
---@usage
--- -- Get currently selected object
--- local selected = Obj()
--- 
--- -- Get specific fixture
--- local fixture1 = Obj("Fixture 1")
--- 
--- -- Get root object
--- local root = Obj("Root")
function Obj(objectPath)
    return Handle:new()
end

-- ========================================
-- USAGE EXAMPLES AND PATTERNS
-- ========================================

--[[
COMMON USAGE PATTERNS:

1. Safe Object Access:
   local obj = Obj()
   if obj then
       local name = obj:Get("name")
       Printf("Object: " .. name)
   end

2. Object Hierarchy Navigation:
   local parent = Obj()
   local children = parent:Children()
   for i, child in ipairs(children) do
       Printf("Child " .. i .. ": " .. child:ToAddr(true))
   end

3. Property Reading with Defaults:
   local function getProperty(obj, prop, default)
       if not obj then return default end
       local value = obj:Get(prop)
       return value ~= "" and value or default
   end

4. Command-Safe Addressing:
   local obj = Obj()
   if obj then
       local addr = obj:Addr()
       Cmd("Select " .. addr)
   end

5. Type-Safe Object Handling:
   local obj = Obj()
   if obj and obj:GetClass() == "Fixture" then
       -- Handle fixture-specific operations
       local intensity = obj:Get("intensity")
   end

PERFORMANCE NOTES:
- Cache object handles when possible
- Use Count() before Children() for efficiency checks
- Prefer specific property access over Dump() for performance
- Use appropriate address methods for your use case

ERROR HANDLING:
- Always check if Obj() returns a valid handle
- Validate child indices before using Ptr()
- Handle import/export failures gracefully
- Check object class before type-specific operations
]]