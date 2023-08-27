local lastTimerUpdate = 0

function LootTracker.OnLootReceived(eventId, receivedBy, itemName, quantity, soundCategory, lootType, mine,
                                    isPickpocketLoot, questItemIcon, itemId, isStolen)
    if LootTracker.Data.loots[itemId] == nil then
        return
        -- LootTracker.Data.loots[itemId] = { quantity = 0, itemName = itemName }
    end

    if mine then
        LootTracker.Data.loots[itemId].quantity = LootTracker.Data.loots[itemId].quantity + quantity
    end

    LootTracker.Data.loots[itemId].groupQuantity = LootTracker.Data.loots[itemId].groupQuantity + quantity


    LootTracker.MainWindow.UpdateLootsInfoUI()
    LootTracker.MainWindow.UpdateMoreInfoUI()
end

function LootTracker.OnExperienceGain(eventId, reason, level, previousExperience, currentExperience, championPoints)
    if (reason == PROGRESS_REASON_OVERLAND_BOSS_KILL) then
        --d("OVERLAND BOSS KILLED")
    end
end

function LootTracker.OnUpdateTimer()
    if not LootTracker.Data.enabed then return end

    local gameTime = GetGameTimeSeconds();
    LootTracker.Data.timer = gameTime - lastTimerUpdate + LootTracker.Data.timer
    lastTimerUpdate = gameTime

    LootTracker.MainWindow.UpdateTimerUI()
    LootTracker.MainWindow.UpdateMoreInfoUI()
end

local function reset()
    LootTracker.Data.timer = 0

    for k in pairs(LootTracker.Data.loots) do
        LootTracker.Data.loots[k].quantity = 0
        LootTracker.Data.loots[k].groupQuantity = 0
    end

    LootTracker.MainWindow.UpdateLootsInfoUI()
    LootTracker.MainWindow.UpdateMoreInfoUI()
    LootTracker.MainWindow.UpdateTimerUI()
end

local function enable()
    LootTracker.Data.enabled = true

    -- Setup Timer
    lastTimerUpdate = GetGameTimeSeconds()
    EVENT_MANAGER:RegisterForUpdate(LootTracker.name .. "Update", 1000, LootTracker.OnUpdateTimer)

    -- Events
    EVENT_MANAGER:RegisterForEvent(LootTracker.name, EVENT_LOOT_RECEIVED, LootTracker.OnLootReceived)
    EVENT_MANAGER:RegisterForEvent(LootTracker.name, EVENT_EXPERIENCE_GAIN, LootTracker.OnExperienceGain)

    LootTracker.MainWindow.UpdateVisibility(true)
end

local function disable()
    LootTracker.Data.enabled = false

    -- Setup Timer
    lastTimerUpdate = GetGameTimeSeconds()
    EVENT_MANAGER:UnregisterForUpdate(LootTracker.name .. "Update")

    -- Events
    EVENT_MANAGER:UnregisterForEvent(LootTracker.name, EVENT_LOOT_RECEIVED)
    EVENT_MANAGER:UnregisterForEvent(LootTracker.name, EVENT_EXPERIENCE_GAIN)

    LootTracker.MainWindow.UpdateVisibility(false)
end

local function toggle()
    if LootTracker.Data.enabled then
        disable()
    else
        enable()
    end
end

function LootTracker.Load()
    LootTracker.MainWindow.Initialize()

    if LootTracker.Data.enabled then
        enable()
    end

    SLASH_COMMANDS["/ltreset"] = reset
    SLASH_COMMANDS["/lttoggle"] = toggle
end
