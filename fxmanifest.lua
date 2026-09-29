fx_version 'cerulean'
game 'gta5'

description 'ScamSimulatorSystem'
version '1.0.0'

author 'YourName'

dependency 'qb-core'

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

shared_scripts {
    'config.lua'
}