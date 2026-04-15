fx_version "bodacious"
game "gta5"

dependency "ghost_ui"

ui_page "nui/index.html"

client_scripts {
    "@vrp/lib/utils.lua",
    "client-side/*",
    "craft.lua"
}

server_scripts {
    "@vrp/lib/utils.lua",
    "server-side/*",
    "craft.lua"
}

files {
    "nui/*.*",
    "nui/app/*",
}