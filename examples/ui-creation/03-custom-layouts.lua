---@meta
--- Custom Layout Examples
--- Advanced UI layout techniques and responsive design patterns
--- 
--- This example covers:
--- - Dynamic layout systems and responsive design
--- - Custom UI components and composite widgets
--- - Advanced positioning and anchoring techniques
--- - Nested layouts and complex grid structures
--- - Animation and dynamic content updates

---@class CustomLayoutExamples
local CustomLayoutExamples = {}

-- ========================================
-- LAYOUT SYSTEM CONFIGURATION
-- ========================================

---Configuration for custom layout examples
local LayoutConfig = {
    -- Main window properties
    name = "CustomLayoutDemo",
    title = "Custom Layout Examples",
    icon = "application_form",
    
    -- Layout types to demonstrate
    examples = {
        {
            id = "responsive",
            name = "Responsive Grid",
            description = "Adaptive grid that responds to window size changes"
        },
        {
            id = "nested",
            name = "Nested Layouts",
            description = "Complex nested grid and frame combinations"
        },
        {
            id = "composite",
            name = "Composite Widgets",
            description = "Custom reusable UI components"
        },
        {
            id = "dynamic",
            name = "Dynamic Content",
            description = "Layouts that change based on data and user interaction"
        }
    }
}

-- ========================================
-- UTILITY FUNCTIONS FOR LAYOUTS
-- ========================================

---Calculate responsive grid dimensions based on container size
---@param containerWidth number Width of container
---@param containerHeight number Height of container
---@param itemCount number Number of items to display
---@param minItemSize number Minimum size per item
---@return number columns Number of columns
---@return number rows Number of rows
---@return number itemWidth Width per item
---@return number itemHeight Height per item
local function calculateResponsiveGrid(containerWidth, containerHeight, itemCount, minItemSize)
    minItemSize = minItemSize or 100
    
    -- Calculate optimal grid dimensions
    local aspectRatio = containerWidth / containerHeight
    local optimalCols = math.ceil(math.sqrt(itemCount * aspectRatio))
    local optimalRows = math.ceil(itemCount / optimalCols)
    
    -- Ensure minimum item sizes are respected
    local maxCols = math.floor(containerWidth / minItemSize)
    local maxRows = math.floor(containerHeight / minItemSize)
    
    local cols = math.min(optimalCols, maxCols)
    local rows = math.min(optimalRows, maxRows)
    
    -- Adjust if we can't fit all items
    while cols * rows < itemCount do
        if cols < maxCols then
            cols = cols + 1
        elseif rows < maxRows then
            rows = rows + 1
        else
            break  -- Can't fit all items
        end
    end
    
    local itemWidth = containerWidth / cols
    local itemHeight = containerHeight / rows
    
    return cols, rows, itemWidth, itemHeight
end

---Create a resizer component for layouts
---@param parent Handle Parent container
---@param onResize function Callback when resize occurs
---@return Handle resizer Resizer component
local function createResizer(parent, onResize)
    local resizer = parent:Append("ResizeCorner")
    resizer.Anchors = "0,1"
    resizer.AlignmentH = "Right"
    resizer.AlignmentV = "Bottom"
    
    -- Note: In real implementation, you would connect resize events
    Printf("Created resizer component")
    
    return resizer
end

---Create a title section with separator
---@param parent Handle Parent container
---@param title string Section title
---@param colors table Theme colors
---@return Handle titleSection Title section container
local function createTitleSection(parent, title, colors)
    local titleSection = parent:Append("UILayoutGrid")
    titleSection.Columns = 1
    titleSection.Rows = 2
    titleSection.Margin = { left = 0, right = 0, top = 5, bottom = 10 }
    
    -- Title text
    local titleText = titleSection:Append("UIObject")
    titleText.Text = title
    titleText.Font = "Medium18"
    titleText.TextalignmentH = "Center"
    titleText.HasHover = "No"
    titleText.BackColor = colors.partlySelected
    titleText.Anchors = "0,0"
    titleText.Padding = { left = 10, right = 10, top = 8, bottom = 8 }
    
    -- Separator line (simulated with colored bar)
    local separator = titleSection:Append("UIObject")
    separator.Text = ""
    separator.BackColor = colors.backgroundPlease
    separator.Anchors = "0,1"
    separator.Margin = { left = 20, right = 20, top = 5, bottom = 5 }
    
    titleSection[1][1].SizePolicy = "Fixed"
    titleSection[1][1].Size = "35"
    titleSection[1][2].SizePolicy = "Fixed"
    titleSection[1][2].Size = "5"
    
    return titleSection
end

-- ========================================
-- RESPONSIVE GRID LAYOUT EXAMPLE
-- ========================================

---Create responsive grid that adapts to container size
---@param container Handle Container for the grid
---@param colors table Theme colors
---@param signalTable table Event handler table
---@param pluginHandle Handle Plugin component handle
---@return Handle responsiveGrid The created responsive grid
local function createResponsiveGrid(container, colors, signalTable, pluginHandle)
    local gridContainer = container:Append("DialogFrame")
    gridContainer.Name = "ResponsiveGridContainer"
    gridContainer.Columns = 1
    gridContainer.Rows = 2
    gridContainer.Anchors = { left = 0, right = 0, top = 0, bottom = 0 }
    
    -- Create title section
    createTitleSection(gridContainer, "Responsive Grid Layout", colors)
    
    -- Create the actual grid
    local responsiveGrid = gridContainer:Append("UILayoutGrid")
    responsiveGrid.Name = "ResponsiveGrid"
    responsiveGrid.Anchors = { left = 0, right = 0, top = 1, bottom = 1 }
    responsiveGrid.Margin = { left = 10, right = 10, top = 10, bottom = 10 }
    
    -- Configure initial grid (will be recalculated dynamically)
    local itemCount = 24
    local cols, rows = 6, 4
    
    responsiveGrid.Columns = cols
    responsiveGrid.Rows = rows
    
    -- Create grid items
    for i = 1, itemCount do
        local row = math.floor((i-1) / cols)
        local col = (i-1) % cols
        
        if row < rows then
            local gridItem = responsiveGrid:Append("Button")
            gridItem.Text = "Item " .. i
            gridItem.Font = "Small11"
            gridItem.Icon = "application_view_tile"
            gridItem.Anchors = { left = col, right = col, top = row, bottom = row }
            gridItem.Margin = { left = 2, right = 2, top = 2, bottom = 2 }
            gridItem.PluginComponent = pluginHandle
            gridItem.Clicked = "OnResponsiveItemClicked"
            gridItem.ItemIndex = i
            
            -- Add some visual variety
            if i % 3 == 0 then
                gridItem.BackColor = colors.partlySelected
            elseif i % 5 == 0 then
                gridItem.BackColor = colors.backgroundPlease
            end
        end
    end
    
    -- Add resize handler (would be connected to actual resize events)
    local resizeInfo = responsiveGrid:Append("UIObject")
    resizeInfo.Text = "Grid: " .. cols .. "x" .. rows .. " (" .. itemCount .. " items)"
    resizeInfo.Font = "Small10"
    resizeInfo.TextalignmentH = "Center"
    resizeInfo.HasHover = "No"
    resizeInfo.BackColor = colors.transparent
    resizeInfo.Anchors = { left = 0, right = cols-1, top = rows, bottom = rows }
    
    Printf("Created responsive grid: " .. cols .. "x" .. rows .. " with " .. itemCount .. " items")
    
    return responsiveGrid
end

-- ========================================
-- NESTED LAYOUT EXAMPLE
-- ========================================

---Create complex nested layout structure
---@param container Handle Container for the nested layout
---@param colors table Theme colors
---@param signalTable table Event handler table
---@param pluginHandle Handle Plugin component handle
---@return Handle nestedLayout The created nested layout
local function createNestedLayout(container, colors, signalTable, pluginHandle)
    local nestedContainer = container:Append("DialogFrame")
    nestedContainer.Name = "NestedLayoutContainer"
    nestedContainer.Columns = 1
    nestedContainer.Rows = 2
    nestedContainer.Anchors = { left = 0, right = 0, top = 0, bottom = 0 }
    
    -- Create title section
    createTitleSection(nestedContainer, "Nested Layout Structure", colors)
    
    -- Main nested layout area
    local mainLayout = nestedContainer:Append("UILayoutGrid")
    mainLayout.Columns = 3
    mainLayout.Rows = 2
    mainLayout.Anchors = { left = 0, right = 0, top = 1, bottom = 1 }
    mainLayout.Margin = { left = 10, right = 10, top = 10, bottom = 10 }
    
    -- Configure layout proportions
    mainLayout[2][1].SizePolicy = "Fixed"
    mainLayout[2][1].Size = "200"  -- Left sidebar
    mainLayout[2][2].SizePolicy = "Stretch"  -- Main content
    mainLayout[2][3].SizePolicy = "Fixed"
    mainLayout[2][3].Size = "150"  -- Right sidebar
    
    -- Left sidebar with nested vertical layout
    local leftSidebar = mainLayout:Append("DialogFrame")
    leftSidebar.Columns = 1
    leftSidebar.Rows = 3
    leftSidebar.Anchors = { left = 0, right = 0, top = 0, bottom = 1 }
    leftSidebar.Margin = { left = 0, right = 5, top = 0, bottom = 0 }
    
    local sidebarTitle = leftSidebar:Append("UIObject")
    sidebarTitle.Text = "Navigation"
    sidebarTitle.Font = "Medium14"
    sidebarTitle.TextalignmentH = "Center"
    sidebarTitle.HasHover = "No"
    sidebarTitle.BackColor = colors.partlySelected
    sidebarTitle.Anchors = "0,0"
    sidebarTitle.Padding = { left = 5, right = 5, top = 5, bottom = 5 }
    
    -- Navigation buttons
    local navGrid = leftSidebar:Append("UILayoutGrid")
    navGrid.Columns = 1
    navGrid.Rows = 5
    navGrid.Anchors = "0,1"
    navGrid.Margin = { left = 5, right = 5, top = 5, bottom = 5 }
    
    local navItems = { "Dashboard", "Fixtures", "Groups", "Presets", "Settings" }
    for i, navItem in ipairs(navItems) do
        local navButton = navGrid:Append("Button")
        navButton.Text = navItem
        navButton.Font = "Small12"
        navButton.TextalignmentH = "Left"
        navButton.Icon = "bullet_arrow_right"
        navButton.Anchors = { left = 0, right = 0, top = i-1, bottom = i-1 }
        navButton.Margin = { left = 0, right = 0, top = 1, bottom = 1 }
        navButton.PluginComponent = pluginHandle
        navButton.Clicked = "OnNavItemClicked"
        navButton.NavItem = navItem
        
        if i == 1 then
            navButton.BackColor = colors.backgroundPlease
        end
    end
    
    -- Status area in sidebar
    local statusArea = leftSidebar:Append("UIObject")
    statusArea.Text = "Status: Ready"
    statusArea.Font = "Small10"
    statusArea.TextalignmentH = "Center"
    statusArea.HasHover = "No"
    statusArea.BackColor = colors.background
    statusArea.Anchors = "0,2"
    statusArea.Margin = { left = 5, right = 5, top = 5, bottom = 0 }
    statusArea.Padding = { left = 5, right = 5, top = 5, bottom = 5 }
    
    -- Main content area with nested grids
    local contentArea = mainLayout:Append("DialogFrame")
    contentArea.Columns = 1
    contentArea.Rows = 2
    contentArea.Anchors = { left = 1, right = 1, top = 0, bottom = 1 }
    contentArea.Margin = { left = 5, right = 5, top = 0, bottom = 0 }
    
    -- Content header
    local contentHeader = contentArea:Append("UIObject")
    contentHeader.Text = "Main Content Area"
    contentHeader.Font = "Medium16"
    contentHeader.TextalignmentH = "Center"
    contentHeader.HasHover = "No"
    contentHeader.BackColor = colors.partlySelected
    contentHeader.Anchors = "0,0"
    contentHeader.Padding = { left = 10, right = 10, top = 8, bottom = 8 }
    
    -- Content grid
    local contentGrid = contentArea:Append("UILayoutGrid")
    contentGrid.Columns = 4
    contentGrid.Rows = 3
    contentGrid.Anchors = "0,1"
    contentGrid.Margin = { left = 10, right = 10, top = 10, bottom = 10 }
    
    -- Fill content grid with sample content
    for i = 1, 12 do
        local row = math.floor((i-1) / 4)
        local col = (i-1) % 4
        
        local contentItem = contentGrid:Append("DialogFrame")
        contentItem.Columns = 1
        contentItem.Rows = 2
        contentItem.Anchors = { left = col, right = col, top = row, bottom = row }
        contentItem.Margin = { left = 2, right = 2, top = 2, bottom = 2 }
        
        local itemTitle = contentItem:Append("UIObject")
        itemTitle.Text = "Item " .. i
        itemTitle.Font = "Small11"
        itemTitle.TextalignmentH = "Center"
        itemTitle.HasHover = "No"
        itemTitle.BackColor = colors.background
        itemTitle.Anchors = "0,0"
        itemTitle.Padding = { left = 3, right = 3, top = 3, bottom = 3 }
        
        local itemContent = contentItem:Append("Button")
        itemContent.Text = "Content"
        itemContent.Font = "Small10"
        itemContent.Icon = "document"
        itemContent.Anchors = "0,1"
        itemContent.Margin = { left = 2, right = 2, top = 2, bottom = 2 }
        itemContent.PluginComponent = pluginHandle
        itemContent.Clicked = "OnContentItemClicked"
        itemContent.ItemId = i
        
        contentItem[1][1].SizePolicy = "Fixed"
        contentItem[1][1].Size = "20"
    end
    
    -- Right sidebar with tools
    local rightSidebar = mainLayout:Append("DialogFrame")
    rightSidebar.Columns = 1
    rightSidebar.Rows = 4
    rightSidebar.Anchors = { left = 2, right = 2, top = 0, bottom = 1 }
    rightSidebar.Margin = { left = 5, right = 0, top = 0, bottom = 0 }
    
    local toolsTitle = rightSidebar:Append("UIObject")
    toolsTitle.Text = "Tools"
    toolsTitle.Font = "Medium14"
    toolsTitle.TextalignmentH = "Center"
    toolsTitle.HasHover = "No"
    toolsTitle.BackColor = colors.partlySelected
    toolsTitle.Anchors = "0,0"
    toolsTitle.Padding = { left = 5, right = 5, top = 5, bottom = 5 }
    
    -- Tool buttons
    local toolButtons = { "Search", "Filter", "Sort", "Export" }
    for i, toolName in ipairs(toolButtons) do
        local toolButton = rightSidebar:Append("Button")
        toolButton.Text = toolName
        toolButton.Font = "Small12"
        toolButton.Icon = "tools"
        toolButton.Anchors = { left = 0, right = 0, top = i, bottom = i }
        toolButton.Margin = { left = 5, right = 5, top = 2, bottom = 2 }
        toolButton.PluginComponent = pluginHandle
        toolButton.Clicked = "OnToolClicked"
        toolButton.ToolName = toolName
    end
    
    Printf("Created complex nested layout with sidebars and multi-level grids")
    
    return nestedContainer
end

-- ========================================
-- COMPOSITE WIDGET EXAMPLE
-- ========================================

---Create a reusable composite widget
---@param parent Handle Parent container
---@param config table Widget configuration
---@param colors table Theme colors
---@param signalTable table Event handler table
---@param pluginHandle Handle Plugin component handle
---@return Handle widget The created composite widget
local function createCompositeWidget(parent, config, colors, signalTable, pluginHandle)
    local widget = parent:Append("DialogFrame")
    widget.Name = config.name or "CompositeWidget"
    widget.Columns = 1
    widget.Rows = 3
    widget.Margin = config.margin or { left = 5, right = 5, top = 5, bottom = 5 }
    
    -- Widget header
    local header = widget:Append("UIObject")
    header.Text = config.title or "Composite Widget"
    header.Font = "Medium14"
    header.TextalignmentH = "Center"
    header.HasHover = "No"
    header.BackColor = colors.partlySelected
    header.Anchors = "0,0"
    header.Padding = { left = 5, right = 5, top = 5, bottom = 5 }
    
    -- Widget content area
    local content = widget:Append("UILayoutGrid")
    content.Columns = config.columns or 2
    content.Rows = config.rows or 2
    content.Anchors = "0,1"
    content.Margin = { left = 5, right = 5, top = 5, bottom = 5 }
    
    -- Widget controls
    local controls = widget:Append("UILayoutGrid")
    controls.Columns = 3
    controls.Rows = 1
    controls.Anchors = "0,2"
    controls.Margin = { left = 5, right = 5, top = 5, bottom = 5 }
    
    -- Add content based on widget type
    if config.type == "parameter" then
        -- Create parameter controls
        for i = 1, (config.columns * config.rows) do
            local row = math.floor((i-1) / config.columns)
            local col = (i-1) % config.columns
            
            local fader = content:Append("UiFader")
            fader.Text = "Param " .. i
            fader.Min = 0
            fader.Max = 100
            fader.Value = 0
            fader.Anchors = { left = col, right = col, top = row, bottom = row }
            fader.Margin = { left = 2, right = 2, top = 2, bottom = 2 }
            fader.PluginComponent = pluginHandle
            fader.Changed = "OnWidgetParameterChanged"
            fader.WidgetName = config.name
            fader.ParameterId = i
        end
    elseif config.type == "selector" then
        -- Create selection buttons
        for i = 1, (config.columns * config.rows) do
            local row = math.floor((i-1) / config.columns)
            local col = (i-1) % config.columns
            
            local selector = content:Append("Button")
            selector.Text = tostring(i)
            selector.Font = "Small12"
            selector.Anchors = { left = col, right = col, top = row, bottom = row }
            selector.Margin = { left = 2, right = 2, top = 2, bottom = 2 }
            selector.PluginComponent = pluginHandle
            selector.Clicked = "OnWidgetSelectorClicked"
            selector.WidgetName = config.name
            selector.SelectorId = i
        end
    end
    
    -- Add control buttons
    local controlButtons = { "Reset", "Save", "Load" }
    for i, buttonText in ipairs(controlButtons) do
        local controlButton = controls:Append("Button")
        controlButton.Text = buttonText
        controlButton.Font = "Small11"
        controlButton.Anchors = { left = i-1, right = i-1, top = 0, bottom = 0 }
        controlButton.Margin = { left = 1, right = 1, top = 0, bottom = 0 }
        controlButton.PluginComponent = pluginHandle
        controlButton.Clicked = "OnWidgetControlClicked"
        controlButton.WidgetName = config.name
        controlButton.ControlAction = buttonText
    end
    
    -- Configure layout proportions
    widget[1][1].SizePolicy = "Fixed"
    widget[1][1].Size = "25"
    widget[1][2].SizePolicy = "Stretch"
    widget[1][3].SizePolicy = "Fixed"
    widget[1][3].Size = "30"
    
    Printf("Created composite widget: " .. (config.name or "unnamed"))
    
    return widget
end

---Create composite widget showcase
---@param container Handle Container for the widgets
---@param colors table Theme colors
---@param signalTable table Event handler table
---@param pluginHandle Handle Plugin component handle
---@return Handle compositeContainer The container with widgets
local function createCompositeWidgetShowcase(container, colors, signalTable, pluginHandle)
    local compositeContainer = container:Append("DialogFrame")
    compositeContainer.Name = "CompositeWidgetContainer"
    compositeContainer.Columns = 1
    compositeContainer.Rows = 2
    compositeContainer.Anchors = { left = 0, right = 0, top = 0, bottom = 0 }
    
    -- Create title section
    createTitleSection(compositeContainer, "Composite Widget Library", colors)
    
    -- Widget showcase area
    local widgetArea = compositeContainer:Append("UILayoutGrid")
    widgetArea.Columns = 2
    widgetArea.Rows = 2
    widgetArea.Anchors = { left = 0, right = 0, top = 1, bottom = 1 }
    widgetArea.Margin = { left = 10, right = 10, top = 10, bottom = 10 }
    
    -- Create different types of composite widgets
    local widgets = {
        {
            name = "ParameterWidget1",
            title = "Intensity Control",
            type = "parameter",
            columns = 2,
            rows = 2,
            position = { col = 0, row = 0 }
        },
        {
            name = "SelectorWidget1", 
            title = "Color Selector",
            type = "selector",
            columns = 4,
            rows = 2,
            position = { col = 1, row = 0 }
        },
        {
            name = "ParameterWidget2",
            title = "Position Control",
            type = "parameter", 
            columns = 2,
            rows = 2,
            position = { col = 0, row = 1 }
        },
        {
            name = "SelectorWidget2",
            title = "Preset Banks",
            type = "selector",
            columns = 3,
            rows = 3,
            position = { col = 1, row = 1 }
        }
    }
    
    for _, widgetConfig in ipairs(widgets) do
        local widget = widgetArea:Append("DialogFrame")
        widget.Anchors = { 
            left = widgetConfig.position.col, 
            right = widgetConfig.position.col,
            top = widgetConfig.position.row, 
            bottom = widgetConfig.position.row 
        }
        widget.Margin = { left = 5, right = 5, top = 5, bottom = 5 }
        
        createCompositeWidget(widget, widgetConfig, colors, signalTable, pluginHandle)
    end
    
    Printf("Created composite widget showcase with " .. #widgets .. " different widgets")
    
    return compositeContainer
end

-- ========================================
-- DYNAMIC CONTENT EXAMPLE
-- ========================================

---Create dynamic content layout that changes based on data
---@param container Handle Container for the dynamic layout
---@param colors table Theme colors
---@param signalTable table Event handler table
---@param pluginHandle Handle Plugin component handle
---@return Handle dynamicContainer The created dynamic layout
local function createDynamicLayout(container, colors, signalTable, pluginHandle)
    local dynamicContainer = container:Append("DialogFrame")
    dynamicContainer.Name = "DynamicLayoutContainer"
    dynamicContainer.Columns = 1
    dynamicContainer.Rows = 3
    dynamicContainer.Anchors = { left = 0, right = 0, top = 0, bottom = 0 }
    
    -- Create title section
    createTitleSection(dynamicContainer, "Dynamic Content Layout", colors)
    
    -- Control panel for dynamic changes
    local controlPanel = dynamicContainer:Append("UILayoutGrid")
    controlPanel.Columns = 5
    controlPanel.Rows = 1
    controlPanel.Anchors = { left = 0, right = 0, top = 1, bottom = 1 }
    controlPanel.Margin = { left = 10, right = 10, top = 5, bottom = 5 }
    
    -- Control buttons
    local modeButton = controlPanel:Append("Button")
    modeButton.Text = "Grid Mode"
    modeButton.Font = "Medium14"
    modeButton.Icon = "application_view_tile"
    modeButton.Anchors = "0,0"
    modeButton.PluginComponent = pluginHandle
    modeButton.Clicked = "OnLayoutModeChanged"
    modeButton.LayoutMode = "grid"
    
    local addButton = controlPanel:Append("Button")
    addButton.Text = "Add Item"
    addButton.Font = "Medium14"  
    addButton.Icon = "plus"
    addButton.Anchors = "1,0"
    addButton.PluginComponent = pluginHandle
    addButton.Clicked = "OnAddDynamicItem"
    
    local removeButton = controlPanel:Append("Button")
    removeButton.Text = "Remove Item"
    removeButton.Font = "Medium14"
    removeButton.Icon = "minus"
    removeButton.Anchors = "2,0"
    removeButton.PluginComponent = pluginHandle
    removeButton.Clicked = "OnRemoveDynamicItem"
    
    local shuffleButton = controlPanel:Append("Button")
    shuffleButton.Text = "Shuffle"
    shuffleButton.Font = "Medium14"
    shuffleButton.Icon = "reload"
    shuffleButton.Anchors = "3,0"
    shuffleButton.PluginComponent = pluginHandle
    shuffleButton.Clicked = "OnShuffleDynamicItems"
    
    local clearButton = controlPanel:Append("Button")
    clearButton.Text = "Clear All"
    clearButton.Font = "Medium14"
    clearButton.Icon = "delete"
    clearButton.BackColor = colors.partlySelected
    clearButton.Anchors = "4,0"
    clearButton.PluginComponent = pluginHandle
    clearButton.Clicked = "OnClearDynamicItems"
    
    -- Dynamic content area
    local dynamicArea = dynamicContainer:Append("DialogFrame")
    dynamicArea.Name = "DynamicContentArea"
    dynamicArea.Columns = 1
    dynamicArea.Rows = 1
    dynamicArea.Anchors = { left = 0, right = 0, top = 2, bottom = 2 }
    dynamicArea.Margin = { left = 10, right = 10, top = 10, bottom = 10 }
    
    -- Create initial dynamic grid
    local dynamicGrid = dynamicArea:Append("UILayoutGrid")
    dynamicGrid.Name = "DynamicGrid"
    dynamicGrid.Columns = 6
    dynamicGrid.Rows = 4
    dynamicGrid.Anchors = { left = 0, right = 0, top = 0, bottom = 0 }
    
    -- Add initial items to dynamic grid
    local initialItemCount = 12
    for i = 1, initialItemCount do
        local row = math.floor((i-1) / 6)
        local col = (i-1) % 6
        
        local dynamicItem = dynamicGrid:Append("Button")
        dynamicItem.Text = "Dynamic " .. i
        dynamicItem.Font = "Small11"
        dynamicItem.Icon = "application_xp"
        dynamicItem.Anchors = { left = col, right = col, top = row, bottom = row }
        dynamicItem.Margin = { left = 2, right = 2, top = 2, bottom = 2 }
        dynamicItem.PluginComponent = pluginHandle
        dynamicItem.Clicked = "OnDynamicItemClicked"
        dynamicItem.ItemId = i
        
        -- Random colors for visual variety
        if i % 4 == 0 then
            dynamicItem.BackColor = colors.backgroundPlease
        elseif i % 3 == 0 then
            dynamicItem.BackColor = colors.partlySelected
        end
    end
    
    -- Configure layout proportions
    dynamicContainer[1][1].SizePolicy = "Fixed"
    dynamicContainer[1][1].Size = "40"   -- Title
    dynamicContainer[1][2].SizePolicy = "Fixed" 
    dynamicContainer[1][2].Size = "40"   -- Controls
    dynamicContainer[1][3].SizePolicy = "Stretch"  -- Content
    
    Printf("Created dynamic layout with " .. initialItemCount .. " initial items")
    
    return dynamicContainer
end

-- ========================================
-- EVENT HANDLERS FOR CUSTOM LAYOUTS
-- ========================================

---Create event handlers for custom layout examples
---@param colors table Theme colors
---@return table handlers Event handler functions
local function createCustomLayoutHandlers(colors)
    local handlers = {}
    local dynamicItemCounter = 12
    local currentLayoutMode = "grid"
    
    -- Responsive grid handlers
    handlers.OnResponsiveItemClicked = function(caller)
        local itemIndex = caller.ItemIndex
        Printf("Responsive grid item " .. itemIndex .. " clicked")
        
        -- Toggle item color
        if caller.BackColor == colors.background then
            caller.BackColor = colors.backgroundPlease
        else
            caller.BackColor = colors.background
        end
    end
    
    -- Nested layout handlers
    handlers.OnNavItemClicked = function(caller)
        local navItem = caller.NavItem
        Printf("Navigation item clicked: " .. navItem)
        
        -- Update navigation selection visually
        local navGrid = caller.parent
        for i = 1, navGrid.ChildCount do
            local child = navGrid[i]
            if child and child.NavItem then
                if child.NavItem == navItem then
                    child.BackColor = colors.backgroundPlease
                else
                    child.BackColor = colors.background
                end
            end
        end
    end
    
    handlers.OnContentItemClicked = function(caller)
        local itemId = caller.ItemId
        Printf("Content item " .. itemId .. " clicked")
        caller.BackColor = colors.partlySelected
    end
    
    handlers.OnToolClicked = function(caller)
        local toolName = caller.ToolName
        Printf("Tool clicked: " .. toolName)
        caller.BackColor = colors.backgroundPlease
    end
    
    -- Composite widget handlers
    handlers.OnWidgetParameterChanged = function(caller)
        local widgetName = caller.WidgetName
        local parameterId = caller.ParameterId
        local value = caller.Value
        Printf("Widget " .. widgetName .. " parameter " .. parameterId .. " changed to: " .. value)
    end
    
    handlers.OnWidgetSelectorClicked = function(caller)
        local widgetName = caller.WidgetName
        local selectorId = caller.SelectorId
        Printf("Widget " .. widgetName .. " selector " .. selectorId .. " clicked")
        
        -- Toggle selector state
        if caller.BackColor == colors.background then
            caller.BackColor = colors.backgroundPlease
        else
            caller.BackColor = colors.background
        end
    end
    
    handlers.OnWidgetControlClicked = function(caller)
        local widgetName = caller.WidgetName
        local controlAction = caller.ControlAction
        Printf("Widget " .. widgetName .. " control '" .. controlAction .. "' clicked")
        
        if controlAction == "Reset" then
            Printf("Resetting widget " .. widgetName)
        elseif controlAction == "Save" then
            Printf("Saving widget " .. widgetName .. " state")
        elseif controlAction == "Load" then
            Printf("Loading widget " .. widgetName .. " state")
        end
    end
    
    -- Dynamic content handlers
    handlers.OnLayoutModeChanged = function(caller)
        local newMode = (currentLayoutMode == "grid") and "list" or "grid"
        currentLayoutMode = newMode
        
        caller.Text = string.upper(newMode:sub(1,1)) .. newMode:sub(2) .. " Mode"
        caller.Icon = (newMode == "grid") and "application_view_tile" or "application_view_list"
        
        Printf("Layout mode changed to: " .. newMode)
    end
    
    handlers.OnAddDynamicItem = function(caller)
        dynamicItemCounter = dynamicItemCounter + 1
        Printf("Adding dynamic item " .. dynamicItemCounter)
        
        -- In a real implementation, you would actually add the item to the grid
        -- This would require grid reconstruction or dynamic item management
    end
    
    handlers.OnRemoveDynamicItem = function(caller)
        if dynamicItemCounter > 0 then
            Printf("Removing dynamic item " .. dynamicItemCounter)
            dynamicItemCounter = dynamicItemCounter - 1
        else
            Printf("No items to remove")
        end
    end
    
    handlers.OnShuffleDynamicItems = function(caller)
        Printf("Shuffling dynamic items")
        -- In real implementation, would rearrange grid items
    end
    
    handlers.OnClearDynamicItems = function(caller)
        Printf("Clearing all dynamic items")
        dynamicItemCounter = 0
        -- In real implementation, would remove all grid items
    end
    
    handlers.OnDynamicItemClicked = function(caller)
        local itemId = caller.ItemId
        Printf("Dynamic item " .. itemId .. " clicked")
        
        -- Cycle through colors
        if caller.BackColor == colors.background then
            caller.BackColor = colors.backgroundPlease
        elseif caller.BackColor == colors.backgroundPlease then
            caller.BackColor = colors.partlySelected
        else
            caller.BackColor = colors.background
        end
    end
    
    return handlers
end

-- ========================================
-- MAIN CUSTOM LAYOUT CREATION FUNCTION
-- ========================================

---Create custom layout examples dialog
---@param pluginHandle? Handle Optional plugin component handle
---@param signalTable? table Optional signal table for event handlers
---@return Handle|nil dialog Created dialog handle or nil if failed
---@usage
--- -- Create custom layout examples:
--- local dialog = createCustomLayoutExamples(myHandle, signalTable)
function createCustomLayoutExamples(pluginHandle, signalTable)
    Printf("Creating custom layout examples...")
    
    -- Initialize components
    local eventTable = signalTable or {}
    local componentHandle = pluginHandle or Obj()
    
    -- Get display and colors
    local display, displayIndex = getTargetDisplay()
    if not display then
        Printf("Error: Could not get target display")
        return nil
    end
    
    local colors = getThemeColors()
    
    -- Create main dialog
    local screenOverlay = display.ScreenOverlay
    screenOverlay:ClearUIChildren()
    
    local mainDialog = screenOverlay:Append("BaseInput")
    mainDialog.Name = LayoutConfig.name
    mainDialog.W = "1000"
    mainDialog.H = "700"
    mainDialog.MaxSize = string.format("%s,%s", display.W * 0.95, display.H * 0.95)
    mainDialog.MinSize = "800,500"
    mainDialog.Columns = 1
    mainDialog.Rows = 3
    mainDialog.AutoClose = "No"
    mainDialog.CloseOnEscape = "Yes"
    mainDialog.Moveable = "Yes"
    mainDialog.Resizeable = "Yes"
    
    -- Configure layout
    mainDialog[1][1].SizePolicy = "Fixed"
    mainDialog[1][1].Size = "50"    -- Title bar
    mainDialog[1][2].SizePolicy = "Fixed"
    mainDialog[1][2].Size = "40"    -- Tab bar
    mainDialog[1][3].SizePolicy = "Stretch"  -- Content
    
    -- Create title bar
    local titleBar = mainDialog:Append("TitleBar")
    titleBar.Columns = 2
    titleBar.Rows = 1
    titleBar.Anchors = "0,0"
    titleBar.Texture = "corner2"
    
    titleBar[2][2].SizePolicy = "Fixed"
    titleBar[2][2].Size = "40"
    
    local titleButton = titleBar:Append("TitleButton")
    titleButton.Text = LayoutConfig.title
    titleButton.Icon = LayoutConfig.icon
    titleButton.Texture = "corner1"
    titleButton.Anchors = "0,0"
    titleButton.Font = "Medium18"
    titleButton.HasHover = "No"
    
    local closeButton = titleBar:Append("CloseButton")
    closeButton.Anchors = "1,0"
    closeButton.Texture = "corner2"
    closeButton.HasHover = "Yes"
    
    -- Create example selector tabs
    local exampleTabs = mainDialog:Append("UILayoutGrid")
    exampleTabs.Columns = #LayoutConfig.examples
    exampleTabs.Rows = 1
    exampleTabs.Anchors = "0,1"
    exampleTabs.Margin = { left = 5, right = 5, top = 0, bottom = 5 }
    
    local tabButtons = {}
    for i, example in ipairs(LayoutConfig.examples) do
        local tabButton = exampleTabs:Append("Button")
        tabButton.Text = example.name
        tabButton.Font = "Medium14"
        tabButton.TextalignmentH = "Centre"
        tabButton.HasHover = "Yes"
        tabButton.Anchors = { left = i-1, right = i-1, top = 0, bottom = 0 }
        tabButton.Margin = { left = 2, right = 2, top = 0, bottom = 0 }
        tabButton.BackColor = (i == 1) and colors.backgroundPlease or colors.background
        tabButton.PluginComponent = componentHandle
        tabButton.Clicked = "OnExampleTabClicked"
        tabButton.ExampleId = example.id
        
        tabButtons[example.id] = tabButton
    end
    
    -- Create content area
    local contentArea = mainDialog:Append("DialogFrame")
    contentArea.H = "100%"
    contentArea.W = "100%"
    contentArea.Columns = 1
    contentArea.Rows = 1
    contentArea.Anchors = { left = 0, right = 0, top = 2, bottom = 2 }
    
    -- Create all example layouts (initially hidden except first)
    local responsiveExample = createResponsiveGrid(contentArea, colors, eventTable, componentHandle)
    responsiveExample.Name = "responsive"
    
    local nestedExample = createNestedLayout(contentArea, colors, eventTable, componentHandle)
    nestedExample.Name = "nested"
    nestedExample.Visible = "No"
    
    local compositeExample = createCompositeWidgetShowcase(contentArea, colors, eventTable, componentHandle)
    compositeExample.Name = "composite"
    compositeExample.Visible = "No"
    
    local dynamicExample = createDynamicLayout(contentArea, colors, eventTable, componentHandle)
    dynamicExample.Name = "dynamic"
    dynamicExample.Visible = "No"
    
    -- Set up event handlers
    local handlers = createCustomLayoutHandlers(colors)
    
    -- Add tab switching handler
    handlers.OnExampleTabClicked = function(caller)
        local exampleId = caller.ExampleId
        Printf("Switching to example: " .. exampleId)
        
        -- Update tab button states
        for id, button in pairs(tabButtons) do
            if id == exampleId then
                button.BackColor = colors.backgroundPlease
            else
                button.BackColor = colors.background
            end
        end
        
        -- Show/hide example content
        responsiveExample.Visible = (exampleId == "responsive") and "Yes" or "No"
        nestedExample.Visible = (exampleId == "nested") and "Yes" or "No"
        compositeExample.Visible = (exampleId == "composite") and "Yes" or "No"
        dynamicExample.Visible = (exampleId == "dynamic") and "Yes" or "No"
    end
    
    -- Register all handlers
    for handlerName, handlerFunc in pairs(handlers) do
        eventTable[handlerName] = handlerFunc
    end
    
    -- Add resizer
    createResizer(mainDialog, function() 
        Printf("Layout resized - recalculating responsive elements")
    end)
    
    Printf("Custom layout examples created successfully on display " .. displayIndex)
    Printf("Dialog contains " .. #LayoutConfig.examples .. " layout examples")
    
    return mainDialog
end

-- ========================================
-- DEMONSTRATION FUNCTION
-- ========================================

---Run the custom layout examples demonstration
---@usage
--- -- Run the demo:
--- runCustomLayoutDemo()
function runCustomLayoutDemo()
    Printf("Starting Custom Layout Examples...")
    Printf("")
    
    -- Create demo signal table
    local demoSignalTable = {}
    
    -- Create the custom layout examples
    local dialog = createCustomLayoutExamples(nil, demoSignalTable)
    
    if dialog then
        Printf("✓ Custom layout examples created and displayed")
        Printf("✓ Dialog features:")
        Printf("  - Responsive grid that adapts to size changes")
        Printf("  - Complex nested layouts with sidebars")
        Printf("  - Reusable composite widget components")
        Printf("  - Dynamic content with real-time updates")
        Printf("  - Advanced positioning and anchoring")
        Printf("  - Professional layout patterns")
        Printf("")
        Printf("Try interacting with the examples:")
        Printf("1. Click tabs to switch between layout types")
        Printf("2. Interact with responsive grid items")
        Printf("3. Navigate nested layout sidebars")
        Printf("4. Use composite widget controls")
        Printf("5. Add/remove dynamic content items")
        Printf("6. Resize window to see responsive behavior")
    else
        Printf("✗ Failed to create custom layout examples")
    end
    
    Printf("")
    Printf("Custom Layout Examples completed!")
end

-- Export functions for external use
return {
    createCustomLayoutExamples = createCustomLayoutExamples,
    runDemo = runCustomLayoutDemo,
    LayoutConfig = LayoutConfig,
    calculateResponsiveGrid = calculateResponsiveGrid,
    createCompositeWidget = createCompositeWidget
}