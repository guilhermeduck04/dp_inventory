fx_version 'adamant'
game 'gta5'




ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/ui.css',
	'html/*.js',
	'html/assets/*.ttf',
	'html/**/*',
	'html/assets/*.svg',
}

client_script {
	"@vrp/lib/utils.lua",
	"client.lua"
}

server_scripts{ 
	"@vrp/lib/utils.lua",
	"server.lua"
}
