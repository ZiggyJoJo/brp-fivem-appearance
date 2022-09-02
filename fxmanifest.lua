fx_version "cerulean"
game { "gta5" }

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server.lua',
}

client_scripts {
  '@es_extended/locale.lua',
  'typescript/build/client.js',
  'client.lua',
  'config.lua',
}

provides {
  'skinchanger',
  'esx_skin'
}

ui_page 'ui/build/index.html'