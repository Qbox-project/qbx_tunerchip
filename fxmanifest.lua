fx_version 'cerulean'
game 'gta5'

description 'QB-TunerChip'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
}

server_script 'server/main.lua'

client_scripts {
    'client/main.lua',
    'client/nos.lua'
}

files {
    'html/*',
}

provide 'qb-tunerchip'
lua54 'yes'
use_experimental_fxv2_oal 'yes'
