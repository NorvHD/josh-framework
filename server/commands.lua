local function isAdmin(src)
    if src == 0 then return true end
    local player = Josh.GetPlayer(src)
    return player and Josh.Config.AdminGroups[player.group] == true
end

lib.addCommand('joshdata', {
    help = 'Show your Joshua Framework data',
}, function(source)
    local player = Josh.GetPlayer(source)
    if not player then return end

    TriggerClientEvent('chat:addMessage', source, {
        color = { 255, 200, 50 },
        multiline = true,
        args = {
            'Joshua Framework',
            json.encode(player:GetData())
        }
    })
end)

lib.addCommand('setjob', {
    help = 'Set a player job',
    params = {
        { name = 'target', type = 'number', help = 'Player ID' },
        { name = 'job', type = 'string', help = 'Job name' },
        { name = 'grade', type = 'number', help = 'Grade' }
    }
}, function(source, args)
    if not isAdmin(source) then return end

    local target = Josh.GetPlayer(args.target)
    if not target then return end

    local ok, reason = target:SetJob(args.job, args.grade)
    if not ok then
        return Josh.Utils.Notify(source, {
            title = 'Joshua Framework',
            description = reason,
            type = 'error'
        })
    end

    Josh.Utils.Notify(args.target, {
        title = 'Joshua Framework',
        description = ('Your job is now %s [%s]'):format(target.job.label, target.job.grade_label),
        type = 'success'
    })
end)

lib.addCommand('givemoney', {
    help = 'Give money to a player',
    params = {
        { name = 'target', type = 'number', help = 'Player ID' },
        { name = 'account', type = 'string', help = 'cash / bank / black_money' },
        { name = 'amount', type = 'number', help = 'Amount' }
    }
}, function(source, args)
    if not isAdmin(source) then return end

    local target = Josh.GetPlayer(args.target)
    if not target then return end

    if not target:AddMoney(args.account, args.amount) then
        return Josh.Utils.Notify(source, {
            title = 'Joshua Framework',
            description = 'Failed to add money.',
            type = 'error'
        })
    end

    Josh.Utils.Notify(args.target, {
        title = 'Joshua Framework',
        description = ('Received $%s into %s.'):format(args.amount, args.account),
        type = 'success'
    })
end)

lib.addCommand('setgroup', {
    help = 'Set a permission group',
    params = {
        { name = 'target', type = 'number', help = 'Player ID' },
        { name = 'group', type = 'string', help = 'user/admin/owner/mod' }
    }
}, function(source, args)
    if not isAdmin(source) then return end

    local target = Josh.GetPlayer(args.target)
    if not target then return end

    target:SetGroup(args.group)
    Josh.Utils.Notify(args.target, {
        title = 'Joshua Framework',
        description = ('Your group is now %s'):format(args.group),
        type = 'success'
    })
end)
