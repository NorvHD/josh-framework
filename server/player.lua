Josh = Josh or {}
Josh.Players = {}
Josh.Player = {}
Josh.Player.__index = Josh.Player

local function buildJob(jobName, jobGrade, onduty)
    local jobData = Josh.Config.Jobs[jobName] or Josh.Config.Jobs.unemployed
    local gradeData = jobData.grades[tonumber(jobGrade) or 0] or jobData.grades[0]

    return {
        name = jobName,
        label = jobData.label,
        grade = tonumber(jobGrade) or 0,
        grade_name = gradeData.name,
        grade_label = gradeData.label,
        payment = gradeData.payment or 0,
        onduty = onduty == nil and jobData.defaultDuty or onduty
    }
end

function Josh.Player:new(source, row)
    local self = setmetatable({}, Josh.Player)

    self.source = source
    self.identifier = row.identifier
    self.citizenid = row.citizenid
    self.name = {
        firstname = row.firstname,
        lastname = row.lastname,
        birthdate = row.birthdate,
        gender = row.gender,
        nationality = row.nationality
    }
    self.money = Josh.DB.Decode(row.money, Josh.Utils.DeepCopy(Josh.Config.StartingMoney))
    self.job = buildJob(row.job, row.job_grade, row.onduty == 1)
    self.metadata = Josh.Utils.TableMerge(Josh.Config.PlayerDefaults.metadata, Josh.DB.Decode(row.metadata, {}))
    self.group = row.permission_group or 'user'
    self.position = Josh.DB.Decode(row.position, {
        x = Josh.Config.Spawn.x,
        y = Josh.Config.Spawn.y,
        z = Josh.Config.Spawn.z,
        w = Josh.Config.Spawn.w
    })

    return self
end

function Josh.Player:GetData()
    return {
        source = self.source,
        identifier = self.identifier,
        citizenid = self.citizenid,
        charinfo = self.name,
        money = self.money,
        job = self.job,
        metadata = self.metadata,
        group = self.group,
        position = self.position
    }
end

function Josh.Player:UpdateClient()
    TriggerClientEvent('josh:client:setPlayerData', self.source, self:GetData())
    Player(self.source).state:set('josh:data', self:GetData(), true)
end

function Josh.Player:Save()
    MySQL.update.await([[
        UPDATE josh_players
        SET money = ?, job = ?, job_grade = ?, onduty = ?, metadata = ?, position = ?, permission_group = ?
        WHERE citizenid = ?
    ]], {
        Josh.DB.Encode(self.money),
        self.job.name,
        self.job.grade,
        self.job.onduty and 1 or 0,
        Josh.DB.Encode(self.metadata),
        Josh.DB.Encode(self.position),
        self.group,
        self.citizenid
    })
end

function Josh.Player:SetPosition(coords)
    self.position = { x = coords.x, y = coords.y, z = coords.z, w = coords.w or 0.0 }
end

function Josh.Player:SetMeta(key, value)
    self.metadata[key] = value
    self:UpdateClient()
end

function Josh.Player:AddMoney(account, amount)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return false end
    self.money[account] = (self.money[account] or 0) + amount
    self:UpdateClient()
    return true
end

function Josh.Player:RemoveMoney(account, amount)
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 then return false end
    if (self.money[account] or 0) < amount then return false end
    self.money[account] = self.money[account] - amount
    self:UpdateClient()
    return true
end

function Josh.Player:SetJob(jobName, grade)
    if not Josh.Config.Jobs[jobName] then return false, 'Job does not exist' end
    grade = tonumber(grade) or 0
    if not Josh.Config.Jobs[jobName].grades[grade] then return false, 'Grade does not exist' end
    self.job = buildJob(jobName, grade)
    self:UpdateClient()
    return true
end

function Josh.Player:SetGroup(group)
    self.group = group
    self:UpdateClient()
end

function Josh.GetPlayer(source)
    return Josh.Players[source]
end

exports('GetPlayer', Josh.GetPlayer)

function Josh.GetPlayerByCitizenId(citizenid)
    for _, player in pairs(Josh.Players) do
        if player.citizenid == citizenid then
            return player
        end
    end
    return nil
end

local function createPlayerRow(source, identifier)
    local default = Josh.Config.PlayerDefaults
    local citizenid = ('JOSH%06d'):format(math.random(0, 999999))

    MySQL.insert.await([[
        INSERT INTO josh_players
        (identifier, citizenid, firstname, lastname, birthdate, gender, nationality, money, job, job_grade, onduty, metadata, position, permission_group)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ]], {
        identifier,
        citizenid,
        default.firstname,
        default.lastname,
        default.birthdate,
        default.gender,
        default.nationality,
        Josh.DB.Encode(Josh.Config.StartingMoney),
        Josh.Config.StartingJob.name,
        Josh.Config.StartingJob.grade,
        Josh.Config.StartingJob.onduty and 1 or 0,
        Josh.DB.Encode(default.metadata),
        Josh.DB.Encode({ x = Josh.Config.Spawn.x, y = Josh.Config.Spawn.y, z = Josh.Config.Spawn.z, w = Josh.Config.Spawn.w }),
        'user'
    })

    return MySQL.single.await('SELECT * FROM josh_players WHERE identifier = ? LIMIT 1', { identifier })
end

function Josh.LoadPlayer(source)
    local identifier = Josh.DB.GetIdentifier(source)
    if not identifier then
        DropPlayer(source, 'Framework could not find a valid identifier.')
        return
    end

    local row = MySQL.single.await('SELECT * FROM josh_players WHERE identifier = ? LIMIT 1', { identifier })
    if not row then
        row = createPlayerRow(source, identifier)
    end

    local player = Josh.Player:new(source, row)
    Josh.Players[source] = player
    player:UpdateClient()
    Josh.Utils.Debug(('Loaded player %s (%s)'):format(GetPlayerName(source), player.citizenid))
end

function Josh.SavePlayer(source)
    local player = Josh.GetPlayer(source)
    if not player then return end
    player:Save()
    Josh.Utils.Debug(('Saved player %s (%s)'):format(GetPlayerName(source), player.citizenid))
end

function Josh.UnloadPlayer(source)
    Josh.SavePlayer(source)
    Josh.Players[source] = nil
end
