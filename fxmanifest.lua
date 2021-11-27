fx_version 'adamant'

game 'rdr3'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

client_scripts {
  'client.lua',
  'warmenu.lua',
}

server_scripts {
  'server.lua'
}

shared_scripts {
  'utils.lua'
  'config.lua',
  'locale.lua',
  'locales/*.lua',
}

dependencies {
  'vorp_core',
}