fx_version 'cerulean'
game 'gta5'

description 'QBX_Tunerchip'
repository 'https://github.com/Qbox-project/qbx_tunerchip'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/utils.lua',
    '@qbx_core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'client/main.lua',
    'client/nos.lua',
}

server_script 'server/main.lua'

ui_page 'html/index.html'

files {
    'html/*',
}

provide 'qb-tunerchip'
lua54 'yes'
use_experimental_fxv2_oal 'yes'
