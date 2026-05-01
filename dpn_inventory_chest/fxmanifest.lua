fx_version "cerulean"
game "gta5"
lua54 "yes"

dependency "ghost_ui"

ui_page "nui/index.html"

client_scripts {
    "@vrp/lib/utils.lua",
    "client-side/*.lua",
    "craft.lua"
}

server_scripts {
    "@vrp/lib/utils.lua",
    "server-side/*.lua",
    "craft.lua"
}

files {
    "nui/index.html",
    "nui/config.js",
    "nui/css.css",
    "nui/jquery.js",
    "nui/progressbar.min.js",
    "nui/client.lua",
    "nui/*.ogg",
    "nui/app/*"
}