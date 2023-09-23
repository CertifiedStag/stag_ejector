fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'CertifiedStag'
name 'Ejector Seat'
description 'Ejecto Seato'
github 'https://github.com/CertifiedStag/cs_ejector'
version '2.0'

client_scripts {
	'config.lua',
	'client/main.lua',
}
server_scripts {
  'server/main.lua' 
}
escrow_ignore {
	'config.lua',
	'client/main.lua',
	'server/main.lua',
}

fivem_checker 'yes'

dependency '/assetpacks'
dependency '/assetpacks'