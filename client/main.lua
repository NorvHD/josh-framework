Josh = Josh or {}
Josh.PlayerData = {}

RegisterNetEvent('josh:client:setPlayerData', function(data)
    Josh.PlayerData = data or {}
end)

RegisterNetEvent('josh:client:notify', function(data)
    lib.notify(data)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function() end)
RegisterNetEvent('esx:playerLoaded', function() end)

CreateThread(function()
    Wait(1000)
    TriggerServerEvent('josh:server:playerLoaded')

    while true do
        Wait(15000)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)
        TriggerServerEvent('josh:server:updatePosition', {
            x = coords.x,
            y = coords.y,
            z = coords.z,
            w = heading
        })
    end
end)

RegisterCommand('duty', function()
    local current = Josh.PlayerData.job and Josh.PlayerData.job.onduty or false
    TriggerServerEvent('josh:server:setDuty', not current)
end)

RegisterCommand('spawnjosh', function()
    local spawn = Josh.PlayerData.position or {
        x = Josh.Config.Spawn.x,
        y = Josh.Config.Spawn.y,
        z = Josh.Config.Spawn.z,
        w = Josh.Config.Spawn.w
    }

    SetEntityCoords(PlayerPedId(), spawn.x, spawn.y, spawn.z, false, false, false, false)
    SetEntityHeading(PlayerPedId(), spawn.w or 0.0)
end)

exports('GetPlayerData', function()
    return Josh.PlayerData
end)
