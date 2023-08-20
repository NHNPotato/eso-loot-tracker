local loots = {
    [150731] = { itemName = "Dragon's Blood ", quantity = 0, unitPrice = 4599 },
    [150671] = { itemName = "Dragon Rheum   ", quantity = 0, unitPrice = 9199 },
}
local window = LootTrackerWindow
local saveData = nil

local function updateTotalCoins()
    local total = 0
    for _, v in pairs(loots) do
        total = total + (v.quantity * v.unitPrice);
    end
    
    local totalCoinLabel = window:GetNamedChild("TotalCoins")
    totalCoinLabel:SetText("Total value     : " .. total )
end

local function updateLootTrackerUI()
    local indexContainer = window:GetNamedChild("Index")
    local scrollData = ZO_ScrollList_GetDataList(indexContainer)
    ZO_ScrollList_Clear(indexContainer)

    for _, v in pairs(loots) do
        scrollData[#scrollData + 1] = ZO_ScrollList_CreateDataEntry(1, v)
    end

    ZO_ScrollList_Commit(indexContainer)

    updateTotalCoins()
end

local function saveWindowRect()
    local x, y = window:GetScreenRect()
    local width, height = window:GetDimensions()
    saveData.window = { x = x, y = y, width = width, height = height }

    updateLootTrackerUI()
end

function LootTracker.OnLootReceived(eventId, receivedBy, itemName, quantity, soundCategory, lootType, self,
                                    isPickpocketLoot, questItemIcon, itemId, isStolen)
    if loots[itemId] == nil then
        return
        -- loots[itemId] = { quantity = 0, itemName = itemName }w
    end

    loots[itemId].quantity = loots[itemId].quantity + quantity

    updateLootTrackerUI()
end

function LootTracker.OnExperienceGain(eventId, reason, level, previousExperience, currentExperience, championPoints)
    if (reason == PROGRESS_REASON_OVERLAND_BOSS_KILL) then
        --d("OVERLAND BOSS KILLED")
    end
end

local function InitializeRow(control, data)
    control:SetText(data.itemName .. ": " .. data.quantity)
end

local function reset()
    for k in pairs(loots) do
        loots[k].quantity = 0
    end

    updateLootTrackerUI()
end

function LootTracker.Load()
    saveData = LootTracker.saveData

    if saveData.window then
        window:ClearAnchors()
        window:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, saveData.window.x, saveData.window.y)
        window:SetDimensions(saveData.window.width, saveData.window.height)
    else
        saveWindowRect()
    end

    window:SetHandler("OnMoveStop", saveWindowRect)
    window:SetHandler("OnResizeStop", saveWindowRect)

    local fragment = ZO_SimpleSceneFragment:New(window)
    HUD_SCENE:AddFragment(fragment)
    HUD_UI_SCENE:AddFragment(fragment)

    local NOTE_TYPE = 1
    local indexContainer = window:GetNamedChild("Index")
    ZO_ScrollList_AddDataType(indexContainer, NOTE_TYPE, "LootTrackerIndexTemplate", 20, InitializeRow)

    updateLootTrackerUI()

    SLASH_COMMANDS["/ltreset"] = reset
end