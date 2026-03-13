Josh.CreateCallback('josh:server:getPlayerData', function(source)
    local player = Josh.GetPlayer(source)
    if not player then return nil end
    return player:GetData()
end)
