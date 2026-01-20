fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'SirRezi'
description 'SirRezi Banking System'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/script.js'
}

dependencies {
    'es_extended',
    'ox_lib',
    'ox_target'
}
