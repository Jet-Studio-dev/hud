local CURRENT_ENV = (IsDuplicityVersion() and 'server') or 'client'
local CURRENT_RESOURCE = GetCurrentResourceName()
local CACHE_FILE = {}

local CURRENT_FRAMEWORK = "esx"

local function require(path)
    if CACHE_FILE[path] then
        return CACHE_FILE[path]
    end

    if not path then
        return warn("(func: loadFile) param 'path' manquant")
    end

    local module_path = ("%s.lua"):format(path)
    local module_file = LoadResourceFile(CURRENT_RESOURCE, module_path)

    if not module_file then
        return warn(("(func: loadFile) File not found: %s"):format(module_path))
    end

    local chunk, err = load(module_file, module_path)
    if not chunk then
        return error(("(func: loadFile) Compile error in %s: %s"):format(module_path, err))
    end

    local ok, result = pcall(chunk)
    if not ok then
        return error(("(func: loadFile) Runtime error in %s: %s"):format(module_path, result))
    end

    if result == nil then
        warn(("(func: loadFile) Module %s returned nil, returning empty table"):format(module_path))
        return {}
    end

    CACHE_FILE[path] = result
    return result
end

_ENV.core = {
    require = require,
    CURRENT_RESOURCE = CURRENT_RESOURCE
}

if CURRENT_ENV == "client" then
    local nuiReady = false

    RegisterNUICallback("nui:ready", function(_, cb)
        print("^0[ " .. core.CURRENT_RESOURCE .. " ]^2 NUI prêt.^0")
        nuiReady = true
        cb({})
    end)

    Citizen.CreateThread(function()
        Wait(5000)

        local HudManager = core.require("src/client")
        local HudBridge = core.require(("src/bridge/%s"):format(CURRENT_FRAMEWORK))

        while not nuiReady do
            Wait(200)
        end
        
        HudBridge:Start()

        HudManager:RefreshMinimap()
        HudManager:Show()
    end)
elseif CURRENT_ENV == "server" then
    Citizen.CreateThread(function()
        print("^0[ " .. core.CURRENT_RESOURCE .. " ]^2 Démarrage de la ressource...^0")

        SetTimeout(1000, function()


            print("^2┌───────────────────────────────────────────────┐")
            print("^2│ ^7Hud System : ^2Démarré avec succès ^7✔            ^2│")
            print("^2│                                               │")
            print("^2│ ^3Développé par : ^7Destructor                    ^2│")
            print("^2└───────────────────────────────────────────────┘^0")

        end)
    end)
end
