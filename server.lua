local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('scamsimulator:checkPCPurchase', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local playerId = Player.PlayerData.citizenid
    
    MySQL.Async.fetchScalar('SELECT COUNT(*) FROM player_pcs WHERE player_id = ?', {playerId}, function(count)
        if count > 0 then
            cb(false)
            TriggerClientEvent('QBCore:Notify', source, 'You already own a PC!', 'error')
        else
            cb(true)
        end
    end)
end)

RegisterNetEvent('scamsimulator:buyPC', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local playerId = Player.PlayerData.citizenid
    
    if Player.Functions.RemoveMoney('cash', Config.PCPrice) then
        MySQL.Async.execute('INSERT INTO player_pcs (player_id, pc_id) VALUES (?, ?)', {playerId, 1}, function()
            TriggerClientEvent('QBCore:Notify', src, 'You have successfully purchased a PC!', 'success')
            TriggerClientEvent('scamsimulator:openScamMenu', src)
        end)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You do not have enough money!', 'error')
    end
end)

RegisterNetEvent('scamsimulator:runScam', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local playerId = Player.PlayerData.citizenid
    local scamType = data.scamType
    
    local scamConfig = nil
    for _, scam in ipairs(Config.ScamTypes) do
        if scam.name == scamType then
            scamConfig = scam
            break
        end
    end
    
    if not scamConfig then
        TriggerClientEvent('QBCore:Notify', src, 'Invalid scam type!', 'error')
        return
    end
    
    local success = math.random() < scamConfig.successRate
    local reward = success and scamConfig.reward or 0
    
    MySQL.Async.execute('INSERT INTO scam_attempts (player_id, scam_type, success, reward) VALUES (?, ?, ?, ?)', {playerId, scamType, success, reward}, function()
        if success then
            Player.Functions.AddMoney('cash', reward)
            TriggerClientEvent('QBCore:Notify', src, 'Scam successful! You earned $' .. reward, 'success')
        else
            TriggerClientEvent('QBCore:Notify', src, 'Scam failed! You earned nothing.', 'error')
        end
    end)
end)