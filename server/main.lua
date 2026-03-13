AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    Wait(500)
    local players = GetPlayers()
    for i = 1, #players do
        local src = tonumber(players[i])
        Josh.LoadPlayer(src)
    end
end)

RegisterNetEvent('josh:server:playerLoaded', function()
    local src = source
    Josh.LoadPlayer(src)
end)

RegisterNetEvent('josh:server:updatePosition', function(coords)
    local src = source
    local player = Josh.GetPlayer(src)
    if not player or type(coords) ~= 'table' then return end
    player:SetPosition(coords)
end)

RegisterNetEvent('josh:server:setDuty', function(state)
    local src = source
    local player = Josh.GetPlayer(src)
    if not player then return end
    player.job.onduty = state and true or false
    player:UpdateClient()
    Josh.Utils.Notify(src, {
        title = 'Joshua Framework',
        description = ('Duty status: %s'):format(player.job.onduty and 'On Duty' or 'Off Duty'),
        type = 'success'
    })
end)

AddEventHandler('playerDropped', function()
    Josh.UnloadPlayer(source)
end)

CreateThread(function()
    while true do
        Wait(60000)
        for _, player in pairs(Josh.Players) do
            player.metadata.playtime = (player.metadata.playtime or 0) + 1
        end
    end
end)

CreateThread(function()
    while true do
        Wait(300000)
        for source, _ in pairs(Josh.Players) do
            Josh.SavePlayer(source)
        end
    end
end)
