local HudManager = core.require("src/client")
local QBCore = exports['qb-core']:GetCoreObject()

local InitBridge = {}

function InitBridge:Start()
    HudManager:AddState("hunger", "#C26B2E", "hunger.svg", function(ped)
        local Player = QBCore.Functions.GetPlayerData()
        local hunger = Player.metadata["hunger"]
        return hunger
    end)

    HudManager:AddState("thirst", "#2EA7C2", "thirst.svg", function(ped)
        local Player = QBCore.Functions.GetPlayerData()
        local thirst = Player.metadata["thirst"]
        return thirst
    end)
end

return InitBridge