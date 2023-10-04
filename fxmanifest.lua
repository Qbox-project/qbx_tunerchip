fx_version 'cerulean'
game 'gta5'

description 'QBX-Tunerchip'
repository 'https://github.com/Qbox-project/qbx_tunerchip'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    '@qbx_core/import.lua',
    '@ox_lib/init.lua',
    '@qbx_core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
}

server_script 'server/main.lua'

client_scripts {
    'client/main.lua',
    'client/nos.lua'
}

modules {
	'qbx_core:playerdata',
    'qbx_core:utils'
}

files {
    'html/*',
}

provide 'qb-tunerchip'
lua54 'yes'
use_experimental_fxv2_oal 'yes'
