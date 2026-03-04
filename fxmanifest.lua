fx_version 'cerulean'
game 'gta5'

name 'nc-carcontrol'
description 'NC vehicle control system'
author 'NOX'
version '1.0.0'

shared_scripts {
    'config.lua',
}

client_scripts {
    'client/main.lua',
}

server_script 'server.lua'

ui_page 'web/dist/index.html'

files {
    'web/dist/index.html',
    'web/dist/assets/*',
    'web/dist/seatbelt1.png',
    'web/dist/seatbelt2.png',
}

lua54 'yes'
