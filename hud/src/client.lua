local HudManager = {}
HudManager.active = false
HudManager.state = {}

function HudManager:SendReactMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

local function ComputeViewportCorrection(ratio)
    local target = 16 / 9
    local vwc = 1.0
    local vhc = 1.0

    if ratio > target then
        vwc = target / ratio
    else
        vhc = ratio / target
    end

    return vwc, vhc
end

function HudManager:RefreshMinimap()
    local ratio = GetAspectRatio(false)
    local vwc, vhc = ComputeViewportCorrection(ratio)

    HudManager:SendReactMessage("hud:setRatio", {
        ratio = ratio,
        vwc = vwc,
        vhc = vhc,
    })

    RequestStreamedTextureDict("squaremap", false)
    while not HasStreamedTextureDictLoaded("squaremap") do Wait(0) end

    SetMinimapClipType(0)

    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "squaremap", "radarmasksm")
    AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "squaremap", "radarmasksm")

    SetMinimapComponentPosition("minimap", "L", "B",
        -0.005 * vhc,    -- left (x)
        -0.040 * vhc,    -- bottom offset (y)
         0.160 * vhc,    -- width
         0.190 * vhc     -- height
    )

    SetMinimapComponentPosition("minimap_mask", "L", "B",
        -0.004 * vwc,
         0.044 * vhc,
         0.128 * vwc,
         0.200 * vhc
    )

    SetMinimapComponentPosition("minimap_blur", "L", "B",
        -0.015 * vhc,
         0.030 * vhc,
         0.262 * vhc,
         0.295 * vhc
    )

    SetBlipAlpha(GetNorthRadarBlip(), 0)
    SetRadarBigmapEnabled(true, false)
    Wait(50)
    SetRadarBigmapEnabled(false, false)
    SetRadarZoom(1000)
end

function HudManager:AddState(id, color, icon, getState)
    table.insert(self.state, {
        type = id, 
        color = color, 
        icon = icon, 
        getState = getState
    })
end

function HudManager:AddState(id, color, icon, getState)
    table.insert(self.state, {
        type = id,
        color = color,
        icon = icon,
        getState = getState
    })
end

function HudManager:RemoveState(id)
    for i, v in ipairs(self.state) do
        if v.type == id then
            table.remove(self.state, i)
            break
        end
    end
end

function HudManager:Show()
    if self.active then return end 

    CreateThread(function()
        self:SendReactMessage('setVisible', true)
        self.active = true

        while self.active do
            local ped = PlayerPedId()
            local statuses = {}

            local health = GetEntityHealth(ped) - 100
            local shield = GetPedArmour(ped)
            if health < 0 then health = 0 end

            table.insert(statuses, {
                type = "health",
                color = "#2EC25A",
                icon = "health.svg",
                state = health
            })

            for _, s in ipairs(HudManager.state) do
                local value = s.getState(ped)

                if (s.type ~= "shield" or value > 0) 
                and (s.type ~= "oxygen" or value) then
                    table.insert(statuses, {
                        type = s.type,
                        color = s.color,
                        icon = s.icon,
                        state = value
                    })
                end
            end

            if shield > 0 then
                table.insert(statuses, {
                    type = "shield",
                    color = "#c2c2c2ff",
                    icon = "shield.svg",
                    state = shield
                })
            end

            if IsPedSwimmingUnderWater(ped) then
                local breath = GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10
                if breath > 100 then breath = 100 end
                table.insert(statuses, {
                    type = "oxygen",
                    color = "#FFC86B",
                    icon = "oxygen.svg",
                    state = breath
                })
            end

            HudManager:SendReactMessage('hud:setStatues', statuses)

            Wait(1000)
        end
    end)
end

function HudManager:Hide()
    self.active = false
    self:SendReactMessage('setVisible', false)
end

RegisterCommand("refreshhud", function()
    print(1)
    HudManager:RefreshMinimap()
    HudManager:Show()
end)

return HudManager