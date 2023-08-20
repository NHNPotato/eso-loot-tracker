local function Load()
    LootTracker.saveData = ZO_SavedVars:NewAccountWide(LootTracker.SAVED_VARS_NAME, LootTracker.SAVED_VARS_VERSION, nil, LootTracker.SAVED_VARS_DEFAULT)
    
    LootTracker.Load()
    
    LootTracker.LoadEvents()
end

function LootTracker.OnAddOnLoaded(event, addonName)
    if addonName == LootTracker.name then
        Load()
        EVENT_MANAGER:UnregisterForEvent(LootTracker.name, EVENT_ADD_ON_LOADED)
    end
end
EVENT_MANAGER:RegisterForEvent(LootTracker.name, EVENT_ADD_ON_LOADED, LootTracker.OnAddOnLoaded)
