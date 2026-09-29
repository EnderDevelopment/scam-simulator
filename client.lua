local QBCore = exports['qb-core']:GetCoreObject()

local function showPCPurchaseMenu()
    local menu = {
        {
            header = 'Buy PC',
            isMenuHeader = true
        },
        {
            header = 'Confirm Purchase',
            txt = 'Price: $' .. Config.PCPrice,
            params = {
                event = 'scamsimulator:buyPC'
            }
        }
    }
    exports['qb-menu']:openMenu(menu)
end

RegisterNetEvent('scamsimulator:openPCPurchaseMenu', function()
    showPCPurchaseMenu()
end)

RegisterNetEvent('scamsimulator:openScamMenu', function()
    local menu = {
        {
            header = 'Scam Simulator',
            isMenuHeader = true
        }
    }
    
    for _, scam in ipairs(Config.ScamTypes) do
        table.insert(menu, {
            header = scam.name,
            txt = 'Success Rate: ' .. (scam.successRate * 100) .. '%',
            params = {
                event = 'scamsimulator:runScam',
                args = {
                    scamType = scam.name
                }
            }
        })
    end
    
    exports['qb-menu']:openMenu(menu)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for _, location in ipairs(Config.ScamLocations) do
            local distance = #(playerCoords - vector3(location.x, location.y, location.z))
            
            if distance < 1.5 then
                DrawText3D(location.x, location.y, location.z, '~g~[E]~w~ Buy PC')
                
                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent('scamsimulator:checkPCPurchase')
                end
            end
        end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end