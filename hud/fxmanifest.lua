fx_version "cerulean"
game "gta5"
version "2.0"
author "Destructor"
lua54 "yes"

ui_page 'web/build/index.html'

files {
    'web/build/index.html',
	'web/build/**/*',
    
    'src/bridge/**.lua',
    'assets/**.svg',
}

shared_script{
    'init.lua',
}

client_scripts {
    'src/client.lua',
}

