ConfigClient = {
    unidades = 20,
    distance = 2, -- Distancia que poderá abrir as lojas
    keyBind = true, -- Se o inventário terá key bind ou seja os 5 primeiros itens ele poderá usar com as teclas 1,2,3,4,5 respectivamente
    keyBindWeapon = true, -- Se o inventário terá a opção e pegar a arma na mão e desativar o tab ao usar a keybind
    ip = "http://127.0.0.1/inventario", -- caso use ip por xammp bote o caminho assim http://ip/caminho e tire as iamgens do fx_manifest
    percentual = 0.85, -- Percentual para venda de itens nesse caso padrão está para 85% do valor do item
    tecla = 'oem_3', -- tecla que abrirá o inventario padrão é o aspas
    disableIncludedShop = true,
    disableIncludedTrunk = true,

    separatedShop = true,
    separatedTrunk = true,

    keybindTrunk = "PAGEUP",

    blackItemList = {
        trunckchest = {
            "identidade",
            "nada"
        }, -- Itens que não poderá colocar no chest das dos carros
        chest = {
            "identidade",
            "nada"
        },-- Itens que não poderá colocar no chest das facções
        homes = {
            "identidade",
            "nada"
        }, -- Itens que não poderá colocar no chest das casas
      
    }, -- Itens que não poderá colocar nos trunckchests, chests, homes


    lojas = {
		Mecanico = {
            locs = { 
                { 914.17, -2099.58, 30.46 },
                { 916.0, -2100.99, 30.46 },
            }, 
            perm = "mecanico.permissao",
            itens = {
             --  ['nitro'] = {price = 30000},
               ['repairkit'] = {price = 10000},
               ['militec'] = {price = 5000},
               ['pneu'] = {price = 2500},
               ['ferramenta'] = {price = 30},
               ['rastreador'] = {price = 10000},
            },
        }, 	

        Driftking = {
            locs = { 
                { 121.86, -3029.7, 7.05 }
            }, 
            perm = "driftking.permissao",
            itens = {
               ['nitro'] = {price = 30000},
               ['pneu'] = {price = 2500},
               ['suspensaoar'] = {price = 20000},
               ['raceticket'] = {price = 5000},
               ['moduloxenon'] = {price = 10000},
               ['moduloneon'] = {price = 10000},
            },
        }, 	

        Itens_Ilegais = {
            locs = { 
                { 4504.34, -4554.52, 4.18 }
            }, 
            perm = "farc.permissao",
            itens = {
               ['algemas'] = {price = 20000},
               ['corda'] = {price = 10000},
               ['capuz'] = {price = 20000},
               ['lockpick'] = {price = 10000},
               ['pendrive'] = {price = 35000},
               ['pano'] = {price = 5000},
               ['linha'] = {price = 500},
               ['bombaadesiva'] = {price = 15000},
               ['ziplock'] = {price = 20},
            },
        }, 
        Contrabandista = {
            locs = { 
                { 44.57, 6303.42, 31.22 }
            }, 
            perm = "contrabandista.permissao",
            itens = {
               ['gatilho'] = {price = 2000},
               ['mola'] = {price = 1250},
               ['placademetal'] = {price = 1500},
               ['capsula'] = {price = 250},
            },
        }, 	
        Loja_Casino = {
            locs = { -- Casino Store
                { 1116.06, 219.73, -49.43 }
            }, 
            perm = nil,
            itens = {
               ['ficha'] = {price = 100},
               ['ticketroleta'] = {price = 10000},
            },
        }, 	
       

        Venda_Minerios = {
            locs = { -- Venda minerios
                { -622.35, -229.87, 38.06 }
            }, 
            perm = nil,
            itens = {
               ['ferro2'] = {price = 30},
               ['ouro'] = {price = 50},
               ['diamante2'] = {price = 100},
            },
        }, 
        
        Venda_Acougue = {
            locs = { -- Venda peixes
                { 75.96, -1748.84, 29.3 }
            }, 
            perm = nil,
            itens = {
               ['dourado'] = {price = 140},
               ['corvina'] = {price = 110},
               ['pacu'] = {price = 110},
               ['pintado'] = {price = 110},
               ['pirarucu'] = {price = 125},
               ['tilapia'] = {price = 110},
               ['tucunare'] = {price = 115},
               ['salmao'] = {price = 120},
               ['carnecrua'] = {price = 100},
               ['couro'] = {price = 25},
            },
        }, 	

        Venda_Graos = {
            locs = { -- Venda Graos
                { 69.22, -1757.12, 29.3 }
            }, 
            perm = nil,
            itens = {
               ['graos'] = {price = 50},
            },
        }, 	
        
        Farmacia = {
            locs = { 
                { -492.39, -340.79, 42.33 }
            }, 
            perm = "paramedico.permissao",
            itens = {
               ['xerelto'] = {price = 0},
               ['dorflex'] = {price = 0},
               ['cicatricure'] = {price = 0},
               ['rebite'] = {price = 0},
               ['paracetanal'] = {price = 0},
               ['bandagem'] = {price = 0},
            },
        }, 


        DigitalDen = {
            locs = { 
                { -657.44, -857.41, 24.5 }
            }, 
            perm = nil,
            itens = {
               ['celular'] = {price = 2500},
               ['smartwatch'] = {price = 5000},
               ['radio'] = {price = 2500},
               ['notebook'] = {price = 25000},
            },
        }, 

        Aeroporto = {
            locs = { 
                { -1069.47, -2835.66, 27.71 }
            }, 
            perm = nil,
            itens = {
               ['celular'] = {price = 3000},
               ['chocolate'] = {price = 250},
               ['cafe'] = {price = 150},

            },
        }, 

        carrefour = {
            locs = {
                { 66.05, -1734.77, 29.3 },
                { 64.07, -1736.91, 29.3 },
                { 62.29, -1739.27, 29.3 },
            },
            perm = nil,
            itens = {
               ['hamburguer'] = {price = 90},
               ['frango'] = {price = 50},
               ['salsicha'] = {price = 50},
               ['alface'] = {price = 50},
               ['tomate'] = {price = 50},
               ['farinha'] = {price = 25},
               ['calabresa'] = {price = 50},
               ['queijo'] = {price = 60},
               ['salgadinho'] = {price = 150},
               ['rosquinha'] = {price = 150},
               ['chocolate'] = {price = 150},
               ['batata'] = {price = 90},

               ['limonada'] = {price = 110},
               ['agua'] = {price = 125},
               ['whisky'] = {price = 200},
               ['vodka'] = {price = 250},
               ['refrigerante'] = {price = 110},
               ['cafe'] = {price = 90},
            },
        }, 

        burguershot = {
            locs = {
                { -1198.88, -895.26, 14.0 },
            }, -- 
            perm = "burguershot.permissao",
            itens = {
               ['limonada'] = {price = 33},
               ['agua'] = {price = 40},
               ['refrigerante'] = {price = 20},
               ['cafe'] = {price = 30},
               ['sorvete'] = {price = 100},
            
            },
        }, 

        lojaderoupa = {
            locs = {
                { -1126.1, -1438.73, 5.23 },
            }, -- 
            perm = nil,
            itens = {
             --  ['mochila'] = {price = 30000},
               ['roupas'] = {price = 5000},
               ['chapeu'] = {price = 2000},
               ['oculos'] = {price = 2000},
               ['mascara'] = {price = 2000},
               ['skate'] = {price = 10000},
               ['isqueiro'] = {price = 250},
               ['seda'] = {price = 25},
            },
        }, 

        
        
        Cacadores = {
            locs = {
                { -678.88, 5837.86, 17.34 },
            }, -- 
            perm = nil,
            itens = {
               ['wbody|WEAPON_MUSKET'] = {price = 20000},
               ['wbody|WEAPON_KNIFE'] = {price = 10000},
               ['wammo|WEAPON_MUSKET'] = {price = 20},
               ['mascara'] = {price = 2000},
            },
        }, 
        

        ammunation = {
            locs = {
                { 1692.62,3759.50,34.70 },
                { 252.89,-49.25,69.94 },
                { 843.28,-1034.02,28.19 },
                { -331.35,6083.45,31.45 },
                { -663.15,-934.92,21.82 },
                { -1305.18,-393.48,36.69 },
                { -1118.80,2698.22,18.55 },
                { 2568.83,293.89,108.73 },
                { -3172.68,1087.10,20.83 },
                { 21.32,-1106.44,29.79 },
                { 811.19,-2157.67,29.61 }
            }, -- 
            perm = nil,
            itens = {
               ['wbody|WEAPON_KNIFE'] = {price = 10000},
               ['wbody|WEAPON_DAGGER'] = {price = 10000},
               ['wbody|WEAPON_KNUCKLE'] = {price = 10000},
               ['wbody|WEAPON_MACHETE'] = {price = 10000},
               ['wbody|WEAPON_SWITCHBLADE'] = {price = 10000},
               ['wbody|WEAPON_WRENCH'] = {price = 10000},
               ['wbody|WEAPON_HAMMER'] = {price = 10000},
               ['wbody|WEAPON_GOLFCLUB'] = {price = 10000},
               ['wbody|WEAPON_CROWBAR'] = {price = 10000},
               ['wbody|WEAPON_HATCHET'] = {price = 10000},
               ['wbody|WEAPON_BAT'] = {price = 10000},
               ['wbody|WEAPON_BATTLEAXE'] = {price = 10000},
               ['wbody|WEAPON_POOLCUE'] = {price = 10000},
               ['wbody|WEAPON_STONE_HATCHET'] = {price = 10000},
            },
        }, 

        pescaria = {
            locs = {
                { 1527.0, 3782.21, 34.54 },
            }, -- 
            perm = nil,
            itens = {
                ['isca'] = {price = 50},
                ['vara'] = {price = 250},
             
            },
        }, 

        Venda_Cartoes = {
            locs = {
                { 148.02, 6361.9, 31.53 },
            }, -- 
            perm = "anonymous.permissao",
            itens = {
                ['cartao1'] = {price = 50},
                ['cartao2'] = {price = 75},
                ['cartao3'] = {price = 100},
                ['cartao4'] = {price = 150},
             
            },
        }, 

        ammunation2 = {
            locs = {
                { 18.07, -1111.09, 29.8 },
            },
            perm = nil,
            itens = {
               
               ['garrafavazia'] = {price = 20},
               ['ferramenta'] = {price = 50},
               ['borrifador'] = {price = 100},
               ['furadeira'] = {price = 10000},
               ['serra'] = {price = 10000},
            },
        }, 

    },

    chestFac = {
        ['Bau-Anoymous'] = {
            loc = {747.17315673828,-1905.1430664062,29.461990356445},
            weight = 5000, 
            perm = "anonymous.permissao",
            slots = 100, 
            webhook = "",
        },      
		
        ['Bau-Verdes'] = {
            loc = {147.9, -1707.67, 22.21},
            weight = 500, 
            perm = "verdes.permissao",
            slots = 30, 
            webhook = "",
        },

        ['Bau-Verdes2'] = {
            loc = {-2399.82, 1736.41, 197.15},
            weight = 5000, 
            perm = "verdes.permissao",
            slots = 100, 
            webhook = "",
        },

        ['Bau-Roxos'] = {
            loc = {583.65, -427.91, 17.63},
            weight = 500, 
            perm = "roxos.permissao",
            slots = 30, 
            webhook = "",
        },

        ['Bau-Roxos2'] = {
            loc = {1260.65, -216.97, 99.99},
            weight = 5000, 
            perm = "roxos.permissao",
            slots = 100, 
            webhook = "",
        },

        ['Bau-Amarelos'] = {
            loc = {-1256.76, -1126.27, 0.79},
            weight = 500, 
            perm = "amarelos.permissao",
            slots = 30, 
            webhook = "",
        },

        ['Bau-Amarelos2'] = {
            loc = {678.92, 2367.31, 51.51},
            weight = 5000, 
            perm = "amarelos.permissao",
            slots = 100, 
            webhook = "",
        },

        ['Bau-Casino'] = {
            loc = {943.21, -1486.78, 23.05},
            weight = 5000, 
            perm = "casino.permissao",
            slots = 100, 
            webhook = "",
        },

        ['Bau-Bratva'] = {
            loc = {-1521.26, 121.48, 48.65},
            weight = 5000, 
            perm = "bratva.permissao",
            slots = 100, 
            webhook = "",
        },	

        ['Bau-Cartel'] = {
            loc = {-1863.39, 2054.27, 135.46},
            weight = 5000, 
            perm = "cartel.permissao",
            slots = 100, 
            webhook = "",
        },	

        ['Bau-Farc'] = {
            loc = {4434.1, -4471.04, 4.33},
            weight = 5000, 
            perm = "farc.permissao",
            slots = 100, 
            webhook = "",
        },	

        ['Bau-TheLost'] = {
            loc = {2519.4, 4100.73, 35.59},
            weight = 5000, 
            perm = "thelost.permissao",
            slots = 100, 
            webhook = "",
        },

        ['Bau-SOA'] = {
            loc = {977.1, -104.05, 74.85},
            weight = 5000, 
            perm = "soa.permissao",
            slots = 100, 
            webhook = "",
        },

        ['Bau-Vanilla'] = {
            loc = {106.88, -1299.24, 28.77},
            weight = 5000, 
            perm = "vanilla.permissao",
            slots = 100, 
            webhook = "",
        },
       
        ['Bau-DriftKing'] = {
            loc = {153.37, -3011.68, 10.71},
            weight = 5000, 
            perm = "driftking.permissao",
            slots = 100, 
            webhook = "",
        },

        ['Bau-Burguershot'] = {
            loc = {-1203.05, -895.46, 14.0},
            weight = 5000, 
            perm = "burguershot.permissao",
            slots = 100, 
            webhook = "",
        },

        ['Bau-Policia'] = {
            loc = {1317.99, -774.66, 65.67},
            weight = 50000, 
            perm = "pmesp.permissao",
            slots = 200, 
            webhook = "",
        },

        ['Bau-FT'] = {
            loc = {1301.4, -766.38, 65.67},
            weight = 50000, 
            perm = "ft.permissao",
            slots = 200, 
            webhook = "",
        },

        ['Bau-BAEP'] = {
            loc = {55.5, 6542.53, 32.5},
            weight = 50000, 
            perm = "baep.permissao",
            slots = 200, 
            webhook = "",
        },

        ['Bau-PoliciaCivil'] = {
            loc = {278.0, -349.27, 49.58},
            weight = 50000, 
            perm = "policia.permissao",
            slots = 200, 
            webhook = "",
        },

        ['Bau-Rota'] = {
            loc = {-2009.71, -503.87, 12.23},
            weight = 50000, 
            perm = "rota.permissao",
            slots = 200, 
            webhook = "",
        },

        ['Bau-FT'] = {
            loc = {106.06, 6546.5, 32.5},
            weight = 50000, 
            perm = "ft.permissao",
            slots = 200, 
            webhook = "",
        },

        
    } 

}

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS
-----------------------------------------------------------------------------------------------------------------------------------------
local marcacoes = {
	vec3(25.65,-1346.58,29.49-1.20),
	vec3(2556.75,382.01,108.62-1.20),
	vec3(1163.54,-323.04,69.20-1.20),
	vec3(-707.37,-913.68,19.21-1.20),
	vec3(-48.07,-1757.51,29.43-1.20),
	vec3(373.90,326.91,103.56-1.20),
	vec3(-3243.10,1001.23,12.83-1.20),
	vec3(1729.38,6415.54,35.03-1.20),
	vec3(547.90,2670.36,42.15-1.20),
	vec3(1960.75,3741.33,32.34-1.20),
	vec3(2677.90,3280.88,55.24-1.20),
	vec3(1698.45,4924.15,42.06-1.20),
	vec3(-1820.93,793.18,138.11-1.20),
	vec3(1392.46,3604.95,34.98-1.20),
	vec3(-2967.82,390.93,15.04-1.20),
	vec3(-3040.10,585.44,7.90-1.20),
	vec3(1135.56,-982.20,46.41-1.20),
	vec3(1165.91,2709.41,38.15-1.20),
	vec3(-1487.61,-379.09,40.17-1.20),
	vec3(-1222.91,-906.95,12.33-1.20),
    vec3(1692.62,3759.50,34.70-1.20),
	vec3(252.89,-49.25,69.94-1.20),
	vec3(843.28,-1034.02,28.19-1.20),
	vec3(-331.35,6083.45,31.45-1.20),
	vec3(-663.15,-934.92,21.82-1.20),
	vec3(-1305.18,-393.48,36.69-1.20),
	vec3(-1118.80,2698.22,18.55-1.20),
	vec3(2568.83,293.89,108.73-1.20),
	vec3(-3172.68,1087.10,20.83-1.20),
	vec3(21.32,-1106.44,29.79-1.20),
	vec3(811.19,-2157.67,29.6-1.20),
	vec3(75.34,-1392.87,29.38-1.20),
	vec3(-709.92,-152.96,37.42-1.20),
	vec3(-163.4,-302.85,39.74-1.20),
	vec3(425.54,-806.25,29.5-1.20),
	vec3(-822.37,-1073.6,11.33-1.20),
	vec3(-1450.42,-237.53,49.82-1.20),
	vec3(4.81,6512.5,31.88-1.20),
	vec3(125.83,-223.8,54.56-1.20),
	vec3(-1101.52,2710.54,19.11-1.20),
	vec3(-3170.59,1043.71,20.87-1.20),
	vec3(1196.64,2710.27,38.23-1.20),
	vec3(614.19,2762.81,42.09-1.20),
	vec3(1693.96,4822.78,42.07-1.20),
	vec3(-1193.15,-767.93,17.32-1.20),
    vec3(-620.75,-224.76,38.06-1.20),

    vec3(2525.7,-342.33,101.9-1.20),

     
    
}

-- Citizen.CreateThread(function()
-- 	while true do
-- 	local idle = 1000
-- 		if not menuactive then 
-- 			local ped = PlayerPedId()
-- 			local pCords = GetEntityCoords(ped)
-- 			for i = 1,#marcacoes do 
-- 				local distance = #(pCords - marcacoes[i])
-- 				if distance < 10 then 
-- 					idle = 3
-- 					if distance < 2.0 then 
-- 						DrawText3Ds(marcacoes[i].x,marcacoes[i].y,marcacoes[i].z +1.25,"~p~APERTE~w~ ~g~[']~w~ | Acessar a Loja")
-- 						if IsControlJustPressed(0,9999) then
-- 							ToggleActionMenu()
-- 						end
-- 					end
-- 				end
-- 			end 
-- 		end
-- 		Wait(idle)
-- 	end
-- end)

local promptId = "dpn_global_prompt"

CreateThread(function()
    while true do
        local idle = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        local showing = false

        -- 🔹 LOJAS (Config)
        for shopType, typeData in pairs(ConfigClient.lojas) do
            for _, shopLocs in pairs(typeData.locs) do
                local dist = #(coords - vector3(shopLocs[1], shopLocs[2], shopLocs[3]))

                if dist <= ConfigClient.distance then
                    idle = 0
                    showing = true

                    exports["ghost_ui"]:ShowPrompt({
                        id = promptId,
                        coords = vector3(shopLocs[1], shopLocs[2], shopLocs[3]),
                        key = "E",
                        text = "Abrir loja",
                        type = "default",
                        maxDistance = 2.5,
                        offset = 0.5,
                        priority = 5,
                        active = true
                    })
                end
            end
        end

        -- 🔹 BAÚ FAC (Config)
        for chest, chestData in pairs(ConfigClient.chestFac) do
            local loc = chestData.loc
            local dist = #(coords - vector3(loc[1], loc[2], loc[3]))

            if dist <= ConfigClient.distance then
                idle = 0
                showing = true

                exports["ghost_ui"]:ShowPrompt({
                    id = promptId,
                    coords = vector3(loc[1], loc[2], loc[3]),
                    key = "E",
                    text = "Abrir baú",
                    type = "default",
                    maxDistance = 2.5,
                    offset = 0.5,
                    priority = 6,
                    active = true
                })
            end
        end

        -- 🔹 LOJINHAS CUSTOM (array antigo)
        for _, v in pairs(lojinhas or {}) do
            local dist = #(coords - vector3(v[1], v[2], v[3]))

            if dist <= 2.0 then
                idle = 0
                showing = true

                exports["ghost_ui"]:ShowPrompt({
                    id = promptId,
                    coords = vector3(v[1], v[2], v[3]),
                    key = "E",
                    text = "Abrir loja",
                    type = "default",
                    maxDistance = 2.5,
                    offset = 0.5,
                    priority = 7,
                    active = true
                })
            end
        end

        -- 🔹 BAÚS CUSTOM
        for _, v in pairs(bausfacs or {}) do
            local dist = #(coords - vector3(v[1], v[2], v[3]))

            if dist <= 2.0 then
                idle = 0
                showing = true

                exports["ghost_ui"]:ShowPrompt({
                    id = promptId,
                    coords = vector3(v[1], v[2], v[3]),
                    key = "E",
                    text = "Abrir baú",
                    type = "default",
                    maxDistance = 2.5,
                    offset = 0.5,
                    priority = 8,
                    active = true
                })
            end
        end

        -- 🔻 ESCONDE QUANDO NÃO ESTÁ PERTO
        if not showing then
            exports["ghost_ui"]:HidePrompt(promptId)
        end

        Wait(idle)
    end
end)

function DrawText3Ds(x,y,z,text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.34, 0.34)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370 +0.02
    DrawRect(_x,_y+0.0125, 0.001+ factor, 0.028, 0, 0, 0, 78)
end
