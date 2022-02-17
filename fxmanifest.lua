fx_version "cerulean"
game "gta5"

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server.lua',
}

client_scripts {
  '@es_extended/locale.lua',
  'typescript/build/client.js',
  'config.lua',
  'client.lua'
}

files {
  'ui/build/index.html',
  'ui/build/static/js/*.js',
  'locales/*.json',
  'peds.json'
}

provides {
  'skinchanger',
  'esx_skin'
}

ui_page 'ui/build/index.html'
