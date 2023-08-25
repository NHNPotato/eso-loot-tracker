LootTracker.MainWindow = {}

---- Private variables ----

local LOOT_ROW_TYPE = 1
local LOOT_ROW_HEIGHT = 20
local mainWindow = nil
local lootsTableScrollList = nil
local mainWindowFragment = nil

---- Private Functions ----

local function updateMoreInfo(loots, timer)
    local total = 0
    local groupTotal = 0
    local sellValue = 0
    local groupSellValue = 0

    for _, loot in pairs(loots) do
        total = total + loot.quantity;
        groupTotal = groupTotal + loot.groupQuantity;

        sellValue = sellValue + (loot.quantity * loot.unitPrice);
        groupSellValue = groupSellValue + (loot.groupQuantity * loot.unitPrice);
    end

    local timeInMinute = math.ceil(timer / 60);
    if timeInMinute <= 0 then
        timeInMinute = 1;
    end

    local goldPerMin = math.floor(sellValue / timeInMinute)
    local groupGoldPerMinute = math.floor(groupSellValue / timeInMinute)
    
    -- Update Texts
    local moreInfoControl = mainWindow:GetNamedChild("MoreInfo")

    -- Totals
    local totalLootsControl = moreInfoControl:GetNamedChild("TotalLoots")
    totalLootsControl:GetNamedChild("Personal"):SetText(total)
    totalLootsControl:GetNamedChild("Group"):SetText(groupTotal)

    -- Sell value
    local sellValueControl = moreInfoControl:GetNamedChild("SellValue")
    sellValueControl:GetNamedChild("Personal"):SetText(sellValue)
    sellValueControl:GetNamedChild("Group"):SetText(groupSellValue)
    
    -- Totals
    local totalLootsControl = moreInfoControl:GetNamedChild("GainOverTime")
    totalLootsControl:GetNamedChild("Personal"):SetText(goldPerMin)
    totalLootsControl:GetNamedChild("Group"):SetText(groupGoldPerMinute)
end

local function updateLootsTable(loots)
    local scrollData = ZO_ScrollList_GetDataList(lootsTableScrollList)
    ZO_ScrollList_Clear(lootsTableScrollList)

    for _, loot in pairs(loots) do
        scrollData[#scrollData + 1] = ZO_ScrollList_CreateDataEntry(1, {
            title = loot.itemName,
            quantity = loot.quantity,
            groupQuantity = loot.groupQuantity
        })
    end

    ZO_ScrollList_Commit(lootsTableScrollList)
end

local function updateTimer(timer)
    local hours = math.floor(timer / 3600)
    local minutes = math.floor(timer % 3600 / 60)

    local timeSeparator = ":"
    if timer % 2 >= 1 then
        timeSeparator = " "
    end

    mainWindow:GetNamedChild("Title"):SetText(string.format("Loot Tracker %02d%s%02d", hours, timeSeparator, minutes))
end

local function saveWindowPosition()
    local x, y = mainWindow:GetScreenRect()
    LootTracker.Data.window.x = x
    LootTracker.Data.window.y = y
end

local function initializeLootsTableRow(control, data)
    control:GetNamedChild("Title"):SetText(data.title)
    control:GetNamedChild("Quantity"):SetText(data.quantity)
    control:GetNamedChild("GroupQuantity"):SetText(data.groupQuantity)
end

function LootTracker.MainWindow.UpdateLootsInfoUI()
    updateLootsTable(LootTracker.Data.loots)
end

function LootTracker.MainWindow.UpdateMoreInfoUI()
    updateMoreInfo(LootTracker.Data.loots, LootTracker.Data.timer)
end 

function LootTracker.MainWindow.UpdateTimerUI()
    updateTimer(LootTracker.Data.timer)
end

function LootTracker.MainWindow.UpdateVisibility(visible)
    if visible then
        HUD_SCENE:AddFragment(mainWindowFragment)
        HUD_UI_SCENE:AddFragment(mainWindowFragment)
    else
        HUD_SCENE:RemoveFragment(mainWindowFragment)
        HUD_UI_SCENE:RemoveFragment(mainWindowFragment)
    end
end

function LootTracker.MainWindow.Initialize()
    mainWindow = LootTrackerMainWindow
    mainWindowFragment = ZO_SimpleSceneFragment:New(mainWindow)

    -- Initialize Main Window
    mainWindow:ClearAnchors()
    mainWindow:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LootTracker.Data.window.x, LootTracker.Data.window.y)
    mainWindow:SetHandler("OnMoveStop", saveWindowPosition)

    --Initialize Loots Table
    lootsTableScrollList = mainWindow:GetNamedChild("LootsTable")
    ZO_ScrollList_AddDataType(lootsTableScrollList, LOOT_ROW_TYPE, "LootTrackerLootsTableRowTemplate", LOOT_ROW_HEIGHT, initializeLootsTableRow)

    updateLootsTable(LootTracker.Data.loots)
    updateMoreInfo(LootTracker.Data.loots, LootTracker.Data.timer)
    updateTimer(LootTracker.Data.timer)
end