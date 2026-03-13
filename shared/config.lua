Josh = Josh or {}
Josh.Config = {}

Josh.Config.FrameworkName = 'Joshua Framework'
Josh.Config.Debug = true
Josh.Config.IdentifierType = 'license'
Josh.Config.StartingJob = {
    name = 'unemployed',
    label = 'Unemployed',
    grade = 0,
    grade_name = 'Worker',
    onduty = false
}

Josh.Config.StartingMoney = {
    cash = 500,
    bank = 5000,
    black_money = 0
}

Josh.Config.Spawn = vec4(-1037.77, -2737.99, 20.17, 328.58)

Josh.Config.PlayerDefaults = {
    firstname = 'Joshua',
    lastname = 'Citizen',
    birthdate = '2000-01-01',
    gender = 'm',
    nationality = 'US',
    metadata = {
        hunger = 100,
        thirst = 100,
        stress = 0,
        isdead = false,
        injail = 0,
        playtime = 0
    }
}

Josh.Config.Jobs = {
    unemployed = {
        label = 'Unemployed',
        defaultDuty = false,
        grades = {
            [0] = { name = 'worker', label = 'Worker', payment = 0 }
        }
    },
    police = {
        label = 'Police',
        defaultDuty = true,
        grades = {
            [0] = { name = 'cadet', label = 'Cadet', payment = 300 },
            [1] = { name = 'officer', label = 'Officer', payment = 450 },
            [2] = { name = 'sergeant', label = 'Sergeant', payment = 650 }
        }
    },
    ambulance = {
        label = 'EMS',
        defaultDuty = true,
        grades = {
            [0] = { name = 'emt', label = 'EMT', payment = 300 },
            [1] = { name = 'paramedic', label = 'Paramedic', payment = 450 }
        }
    }
}

Josh.Config.AdminGroups = {
    owner = true,
    admin = true,
    mod = true
}
