---@meta
--- Display Management API Reference
--- Screen handling, layout management, and positioning for MA3 plugins
--- 
--- This module provides methods for managing displays, screen overlays,
--- window positioning, and multi-display plugin interfaces.

---@class DisplayManagement
local DisplayManagement = {}

-- ========================================
-- DISPLAY ACCESS AND INFORMATION
-- ========================================

---Get display object by index
---@param displayIndex integer Display index (1-5)
---@return table|nil display Display object or nil if invalid
---@usage
--- local display = GetDisplayByIndex(1)
--- if display then
---     Printf("Display size: " .. display.W .. "x" .. display.H)
--- end
function GetDisplayByIndex(displayIndex)
    -- Implementation depends on MA3 API
    if displayIndex >= 1 and displayIndex <= 5 then
        return {
            Index = displayIndex,
            W = 1920,  -- Example width
            H = 1080,  -- Example height
            ScreenOverlay = {
                ClearUIChildren = function() end,
                Append = function(self, elementType)
                    return {} -- Return UI element
                end
            }
        }
    end
    return nil
end

---Get the currently focused display
---@return table|nil display Currently focused display or nil
---@usage
--- local focusedDisplay = GetFocusDisplay()
--- if focusedDisplay then
---     local index = Obj.Index(focusedDisplay)
---     Printf("Focused display: " .. index)
--- end
function GetFocusDisplay()
    -- Implementation depends on MA3 API
    return GetDisplayByIndex(1) -- Default to first display
end

---Get all available displays
---@return table displays Array of display objects
---@usage
--- local displays = GetAllDisplays()
--- for i, display in ipairs(displays) do
---     Printf("Display " .. i .. ": " .. display.W .. "x" .. display.H)
--- end
function GetAllDisplays()
    local displays = {}
    for i = 1, 5 do
        local display = GetDisplayByIndex(i)
        if display then
            table.insert(displays, display)
        end
    end
    return displays
end

---Check if a display index is valid
---@param displayIndex integer Display index to check
---@return boolean valid True if display index is valid
---@usage
--- if IsValidDisplayIndex(displayIndex) then
---     local display = GetDisplayByIndex(displayIndex)
--- end
function IsValidDisplayIndex(displayIndex)
    return displayIndex >= 1 and displayIndex <= 5 and GetDisplayByIndex(displayIndex) ~= nil
end

-- ========================================
-- DISPLAY PROPERTIES AND CAPABILITIES
-- ========================================

---Get display dimensions
---@param display table Display object
---@return integer width Display width in pixels
---@return integer height Display height in pixels
---@usage
--- local width, height = GetDisplaySize(display)
--- Printf("Display resolution: " .. width .. "x" .. height)
function GetDisplaySize(display)
    return display.W or 0, display.H or 0
end

---Get display aspect ratio
---@param display table Display object
---@return number ratio Width/height aspect ratio
---@usage
--- local ratio = GetDisplayAspectRatio(display)
--- Printf("Aspect ratio: " .. string.format("%.2f", ratio))
function GetDisplayAspectRatio(display)
    local width, height = GetDisplaySize(display)
    if height > 0 then
        return width / height
    end
    return 1.0
end

---Check if display is in landscape orientation
---@param display table Display object
---@return boolean landscape True if display is landscape
---@usage
--- if IsDisplayLandscape(display) then
---     -- Use landscape-optimized layout
--- end
function IsDisplayLandscape(display)
    local width, height = GetDisplaySize(display)
    return width > height
end

---Get optimal dialog size for display
---@param display table Display object
---@param contentSize? table Optional preferred content size {width, height}
---@return integer width Optimal dialog width
---@return integer height Optimal dialog height
---@usage
--- local width, height = GetOptimalDialogSize(display, {width = 600, height = 400})
function GetOptimalDialogSize(display, contentSize)
    local displayWidth, displayHeight = GetDisplaySize(display)
    
    local maxWidth = math.floor(displayWidth * 0.8)
    local maxHeight = math.floor(displayHeight * 0.8)
    
    local width = contentSize and contentSize.width or 600
    local height = contentSize and contentSize.height or 400
    
    return math.min(width, maxWidth), math.min(height, maxHeight)
end

-- ========================================
-- SCREEN OVERLAY MANAGEMENT
-- ========================================

---Get screen overlay for a display
---@param display table Display object
---@return table overlay Screen overlay object
---@usage
--- local overlay = GetScreenOverlay(display)
--- overlay:ClearUIChildren()
function GetScreenOverlay(display)
    return display.ScreenOverlay
end

---Clear all UI elements from a display overlay
---@param display table Display object
---@usage
--- ClearDisplayOverlay(display)
function ClearDisplayOverlay(display)
    local overlay = GetScreenOverlay(display)
    if overlay and overlay.ClearUIChildren then
        overlay:ClearUIChildren()
    end
end

---Clear all UI elements from all displays
---@usage
--- ClearAllDisplays() -- Clean up before creating new UI
function ClearAllDisplays()
    for i = 1, 5 do
        local display = GetDisplayByIndex(i)
        if display then
            ClearDisplayOverlay(display)
        end
    end
end

---Check if display overlay has UI elements
---@param display table Display object
---@return boolean hasElements True if overlay has UI elements
---@usage
--- if HasOverlayElements(display) then
---     Printf("Display has active UI elements")
--- end
function HasOverlayElements(display)
    -- Implementation would check overlay children
    -- This is a placeholder implementation
    return false
end

-- ========================================
-- WINDOW POSITIONING AND LAYOUT
-- ========================================

---Calculate centered position for a window
---@param display table Display object
---@param windowWidth integer Window width
---@param windowHeight integer Window height
---@return integer x X position for centered window
---@return integer y Y position for centered window
---@usage
--- local x, y = CalculateCenteredPosition(display, 800, 600)
--- window.X = x
--- window.Y = y
function CalculateCenteredPosition(display, windowWidth, windowHeight)
    local displayWidth, displayHeight = GetDisplaySize(display)
    
    local x = math.floor((displayWidth - windowWidth) / 2)
    local y = math.floor((displayHeight - windowHeight) / 2)
    
    return math.max(0, x), math.max(0, y)
end

---Position window relative to display edges
---@param display table Display object
---@param windowWidth integer Window width
---@param windowHeight integer Window height
---@param anchor string Anchor position ("topleft", "topright", "bottomleft", "bottomright", "center")
---@param margin? integer Optional margin from edges (default: 20)
---@return integer x X position
---@return integer y Y position
---@usage
--- local x, y = PositionWindowAnchored(display, 400, 300, "topright", 50)
function PositionWindowAnchored(display, windowWidth, windowHeight, anchor, margin)
    margin = margin or 20
    local displayWidth, displayHeight = GetDisplaySize(display)
    
    local x, y = 0, 0
    
    if anchor == "topleft" then
        x, y = margin, margin
    elseif anchor == "topright" then
        x, y = displayWidth - windowWidth - margin, margin
    elseif anchor == "bottomleft" then
        x, y = margin, displayHeight - windowHeight - margin
    elseif anchor == "bottomright" then
        x, y = displayWidth - windowWidth - margin, displayHeight - windowHeight - margin
    elseif anchor == "center" then
        x, y = CalculateCenteredPosition(display, windowWidth, windowHeight)
    end
    
    return x, y
end

---Ensure window fits within display bounds
---@param display table Display object
---@param x integer Window X position
---@param y integer Window Y position
---@param width integer Window width
---@param height integer Window height
---@return integer clampedX Clamped X position
---@return integer clampedY Clamped Y position
---@return integer clampedWidth Clamped width
---@return integer clampedHeight Clamped height
---@usage
--- local x, y, w, h = ClampWindowToDisplay(display, x, y, width, height)
function ClampWindowToDisplay(display, x, y, width, height)
    local displayWidth, displayHeight = GetDisplaySize(display)
    
    -- Clamp dimensions to display size
    local clampedWidth = math.min(width, displayWidth)
    local clampedHeight = math.min(height, displayHeight)
    
    -- Clamp position to keep window within bounds
    local clampedX = math.max(0, math.min(x, displayWidth - clampedWidth))
    local clampedY = math.max(0, math.min(y, displayHeight - clampedHeight))
    
    return clampedX, clampedY, clampedWidth, clampedHeight
end

-- ========================================
-- MULTI-DISPLAY MANAGEMENT
-- ========================================

---Find best display for content based on size requirements
---@param minWidth integer Minimum required width
---@param minHeight integer Minimum required height
---@param preferredIndex? integer Optional preferred display index
---@return table|nil display Best suitable display or nil
---@usage
--- local display = FindBestDisplay(800, 600, 2)
--- if display then
---     -- Create UI on optimal display
--- end
function FindBestDisplay(minWidth, minHeight, preferredIndex)
    -- Check preferred display first
    if preferredIndex then
        local display = GetDisplayByIndex(preferredIndex)
        if display then
            local width, height = GetDisplaySize(display)
            if width >= minWidth and height >= minHeight then
                return display
            end
        end
    end
    
    -- Find any suitable display
    for i = 1, 5 do
        local display = GetDisplayByIndex(i)
        if display then
            local width, height = GetDisplaySize(display)
            if width >= minWidth and height >= minHeight then
                return display
            end
        end
    end
    
    return nil
end

---Distribute windows across multiple displays
---@param windows table Array of window definitions {width, height, content}
---@return table placements Array of placement info {display, x, y, window}
---@usage
--- local windows = {{width = 400, height = 300}, {width = 600, height = 400}}
--- local placements = DistributeWindowsAcrossDisplays(windows)
function DistributeWindowsAcrossDisplays(windows)
    local placements = {}
    local displays = GetAllDisplays()
    
    if #displays == 0 then return placements end
    
    local displayIndex = 1
    
    for i, window in ipairs(windows) do
        local display = displays[displayIndex]
        if display then
            local x, y = CalculateCenteredPosition(display, window.width, window.height)
            
            table.insert(placements, {
                display = display,
                x = x,
                y = y,
                window = window
            })
            
            -- Move to next display
            displayIndex = (displayIndex % #displays) + 1
        end
    end
    
    return placements
end

---Get display layout information
---@return table layout Display layout info {totalWidth, totalHeight, displayCount}
---@usage
--- local layout = GetDisplayLayout()
--- Printf("Total display area: " .. layout.totalWidth .. "x" .. layout.totalHeight)
function GetDisplayLayout()
    local displays = GetAllDisplays()
    local totalWidth = 0
    local totalHeight = 0
    local maxHeight = 0
    
    for _, display in ipairs(displays) do
        local width, height = GetDisplaySize(display)
        totalWidth = totalWidth + width
        maxHeight = math.max(maxHeight, height)
    end
    
    return {
        totalWidth = totalWidth,
        totalHeight = maxHeight,
        displayCount = #displays,
        displays = displays
    }
end

-- ========================================
-- DISPLAY STATE MANAGEMENT
-- ========================================

---Save current display state
---@param identifier string Unique identifier for this state
---@return table state Display state information
---@usage
--- local state = SaveDisplayState("dialog_session_1")
--- -- Later restore with RestoreDisplayState("dialog_session_1", state)
function SaveDisplayState(identifier)
    local state = {
        identifier = identifier,
        timestamp = os.time(),
        displays = {}
    }
    
    for i = 1, 5 do
        local display = GetDisplayByIndex(i)
        if display then
            state.displays[i] = {
                hasElements = HasOverlayElements(display),
                -- Additional display state could be saved here
            }
        end
    end
    
    return state
end

---Restore display state
---@param identifier string State identifier
---@param state table Previously saved state
---@usage
--- RestoreDisplayState("dialog_session_1", savedState)
function RestoreDisplayState(identifier, state)
    if not state or state.identifier ~= identifier then
        return false
    end
    
    -- Clear all displays first
    ClearAllDisplays()
    
    -- Restore state would involve recreating UI elements
    -- This is a simplified implementation
    Printf("Display state restored for: " .. identifier)
    
    return true
end

-- ========================================
-- UTILITY FUNCTIONS
-- ========================================

---Get display information for debugging
---@param display table Display object
---@return table info Display debug information
---@usage
--- local info = GetDisplayInfo(display)
--- for key, value in pairs(info) do
---     Printf(key .. ": " .. tostring(value))
--- end
function GetDisplayInfo(display)
    local width, height = GetDisplaySize(display)
    return {
        width = width,
        height = height,
        aspectRatio = GetDisplayAspectRatio(display),
        isLandscape = IsDisplayLandscape(display),
        hasOverlay = display.ScreenOverlay ~= nil,
        hasElements = HasOverlayElements(display)
    }
end

---Log display configuration
---@usage
--- LogDisplayConfiguration() -- Debug display setup
function LogDisplayConfiguration()
    Printf("=== Display Configuration ===")
    
    local displays = GetAllDisplays()
    Printf("Available displays: " .. #displays)
    
    for i, display in ipairs(displays) do
        local info = GetDisplayInfo(display)
        Printf("Display " .. i .. ": " .. info.width .. "x" .. info.height .. 
               " (AR: " .. string.format("%.2f", info.aspectRatio) .. ")")
    end
    
    local focusedDisplay = GetFocusDisplay()
    if focusedDisplay then
        local focusedIndex = 0
        for i, display in ipairs(displays) do
            if display == focusedDisplay then
                focusedIndex = i
                break
            end
        end
        Printf("Focused display: " .. focusedIndex)
    end
    
    Printf("===========================")
end

-- ========================================
-- USAGE EXAMPLES AND PATTERNS
-- ========================================

--[[
COMMON USAGE PATTERNS:

1. Simple Display Selection:
   local display = GetFocusDisplay() or GetDisplayByIndex(1)
   local overlay = GetScreenOverlay(display)
   overlay:ClearUIChildren()

2. Multi-Display Dialog Distribution:
   local displays = GetAllDisplays()
   local dialogCount = 3
   
   for i = 1, dialogCount do
       local displayIndex = ((i - 1) % #displays) + 1
       local display = displays[displayIndex]
       -- Create dialog on this display
   end

3. Responsive Dialog Sizing:
   local function createResponsiveDialog(title, minWidth, minHeight)
       local display = FindBestDisplay(minWidth, minHeight)
       if not display then
           Printf("No suitable display found")
           return
       end
       
       local width, height = GetOptimalDialogSize(display, {
           width = minWidth,
           height = minHeight
       })
       
       -- Create dialog with calculated size
   end

4. Display-Aware Positioning:
   local function positionDialog(display, dialogWidth, dialogHeight, position)
       local x, y
       
       if position == "center" then
           x, y = CalculateCenteredPosition(display, dialogWidth, dialogHeight)
       else
           x, y = PositionWindowAnchored(display, dialogWidth, dialogHeight, position)
       end
       
       -- Ensure dialog fits within display
       x, y, dialogWidth, dialogHeight = ClampWindowToDisplay(
           display, x, y, dialogWidth, dialogHeight
       )
       
       return x, y, dialogWidth, dialogHeight
   end

5. State Management for Plugin Sessions:
   local pluginDisplayState = {}
   
   function startPluginSession()
       pluginDisplayState = SaveDisplayState("my_plugin_session")
       ClearAllDisplays()
       -- Create plugin UI
   end
   
   function endPluginSession()
       RestoreDisplayState("my_plugin_session", pluginDisplayState)
   end

INTEGRATION WITH DIALOG CREATION:
- Use GetFocusDisplay() for dialog placement
- Apply GetOptimalDialogSize() for responsive dialogs
- Utilize CalculateCenteredPosition() for dialog positioning
- Clear overlays with ClearDisplayOverlay() before creating new dialogs

PERFORMANCE CONSIDERATIONS:
- Cache display objects when creating multiple UI elements
- Clear overlays when done to free resources
- Use appropriate display selection for content requirements
- Consider display aspect ratios when designing layouts

ERROR HANDLING:
- Always check if display objects are valid before use
- Handle cases where no suitable display is available
- Validate display indices before accessing displays
- Provide fallbacks for display-dependent operations
]]

return DisplayManagement