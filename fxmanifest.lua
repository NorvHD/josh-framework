fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'josh_core'
author 'OpenAI for Joshua'
description 'Custom standalone FiveM framework core (no ESX/QBCore/Qbox)'
version '0.1.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'shared/utils.lua',
    'shared/callbacks.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/database.lua',
    'server/player.lua',
    'server/callbacks.lua',
    'server/main.lua',
    'server/commands.lua'
}

client_scripts {
    'client/main.lua'
}

dependencies {
    'ox_lib',
    'oxmysql'
}
