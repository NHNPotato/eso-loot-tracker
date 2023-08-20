local function registerEvent(eventName, callback)
    EVENT_MANAGER:RegisterForEvent(LootTracker.name, eventName, callback)
end

function LootTracker.LoadEvents()
    -- Looting
    registerEvent(EVENT_LOOT_RECEIVED, LootTracker.OnLootReceived)

    -- Experience
    registerEvent(EVENT_EXPERIENCE_GAIN, LootTracker.OnExperienceGain)
end
