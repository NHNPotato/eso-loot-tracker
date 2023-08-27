LootTracker = {}
LootTracker.name = "LootTracker"

LootTracker.SAVED_VARS_NAME = "LootTrackerSaveData"
LootTracker.SAVED_VARS_VERSION = 2 -- Changing this value will purge the data
LootTracker.SAVED_VARS_DEFAULT = {
    window = { x = 0, y = 0 },
    loots = {
        [150731] = { itemName = "Dragon's Blood ", quantity = 0, groupQuantity = 0, unitPrice = 4599 },
        [150671] = { itemName = "Dragon Rheum   ", quantity = 0, groupQuantity = 0, unitPrice = 9199 },
    },
    timer = 0,
    enabled = true,
}
