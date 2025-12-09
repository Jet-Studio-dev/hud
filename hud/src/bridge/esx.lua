local HudManager = core.require("src/client")
local ESX = exports['es_extended']:getSharedObject()

local InitBridge = {}
InitBridge.StatusData = {}

function InitBridge:Start()
    while not ESX.PlayerLoaded do Wait(200) end

    self.StatusData["hunger"] = 0
    self.StatusData["thirst"] = 0

    HudManager:AddState("hunger", "#C26B2E", "hunger.svg", function(ped)
        TriggerEvent('esx_status:getStatus', "hunger", function(status)
            self.StatusData["hunger"] = status.getPercent()
        end)
        return InitBridge.StatusData["hunger"]
    end)

    HudManager:AddState("thirst", "#2EA7C2", "thirst.svg", function(ped)
        TriggerEvent('esx_status:getStatus', "thirst", function(status)
            self.StatusData["thirst"] = status.getPercent()
        end)
        return self.StatusData["thirst"]
    end)
end

return InitBridge