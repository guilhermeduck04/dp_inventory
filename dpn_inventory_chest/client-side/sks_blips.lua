local showBlip = false
local blipCoords = {}

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		local playerCoords = GetEntityCoords(PlayerPedId())
		if not showBlip then
			local stop = false
			for shopType, typeData in pairs(ConfigClient.lojas) do
				if stop then break end
				for _, shopLocs in pairs(typeData.locs) do
					if GetDistanceBetweenCoords(shopLocs[1], shopLocs[2], shopLocs[3], playerCoords, true) <= ConfigClient.distance then
						showBlip = true
						stop = true
						blipCoords = shopLocs
						idle = 1
						startBlipThread()
						break
					end
				end
			end

			for chest, chestData in pairs(ConfigClient.chestFac) do
				if stop then break end

				chestData = chestData.loc
				if GetDistanceBetweenCoords(chestData[1], chestData[2], chestData[3], playerCoords, true) <= ConfigClient.distance then
					showBlip = true
					stop = true
					blipCoords = chestData
					blipCoords[4] = true
					idle = 1
					startBlipThread()
					break
				end
			end
		else
			idle = 1
			if GetDistanceBetweenCoords(blipCoords[1], blipCoords[2], blipCoords[3], playerCoords, true) > ConfigClient.distance then
				showBlip = false
			end
		end
		Citizen.Wait(idle)
	end
end)

function startBlipThread()
	Citizen.CreateThread(function()
		while showBlip do
			DrawMarker(27, blipCoords[1], blipCoords[2], blipCoords[3]-1.0,0,0,0,0.0,0,0,1.0,1.0,1.0,255,255,255,100,0,0,0,1)
			Citizen.Wait(0)
		end
	end)
end



-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHOVERFY LOJAS
-----------------------------------------------------------------------------------------------------------------------------------------
local lojinhas = { -- adicione abaixo as coordenadas para aparecer o atalho dos blips
    { 66.05, -1734.77, 29.3 }, -- carrefour
    { 64.07, -1736.91, 29.3 }, -- carrefour
    { 62.29, -1739.27, 29.3 }, -- carrefour
	{ 914.17, -2099.58, 30.46 }, -- mecanica
	{ 916.0, -2100.99, 30.46 },  -- mecanica
	{ 121.86, -3029.7, 7.05 }, -- driftking
	{ 4504.34, -4554.52, 4.18 }, --farc
	{ 44.57, 6303.42, 31.22 }, -- contrabandista
	{ 1116.06, 219.73, -49.43 }, -- casino
	{ -622.35, -229.87, 38.06 }, -- venda de minerios
	{ 75.96, -1748.84, 29.3 },-- venda de peixe
	{ 69.22, -1757.12, 29.3 }, -- venda de graos
	{ -492.39, -340.79, 42.33 }, -- farmacia
	{ -657.44, -857.41, 24.5 }, -- digitalden
	{ -1069.47, -2835.66, 27.71 }, -- aeroporto
	{ -1198.88, -895.26, 14.0 },-- burguershot
	{ -1126.1, -1438.73, 5.23 },-- loja de roupa
	{ -678.88, 5837.86, 17.34 },-- loja caçador

	{ 1692.62,3759.50,34.70 },  -- ammunation
	{ 252.89,-49.25,69.94 }, -- ammunation 
	{ 843.28,-1034.02,28.19 }, -- ammunation
	{ -331.35,6083.45,31.45 },-- ammunation
	{ -663.15,-934.92,21.82 },-- ammunation
	{ -1305.18,-393.48,36.69 },-- ammunation
	{ -1118.80,2698.22,18.55 },-- ammunation
	{ 2568.83,293.89,108.73 },-- ammunation
	{ -3172.68,1087.10,20.83 },-- ammunation
	{ 21.32,-1106.44,29.79 },-- ammunation
	{ 811.19,-2157.67,29.61 }, -- ammunation
	{ 18.07, -1111.09, 29.8 }, -- ammunation2
	{ 1527.0, 3782.21, 34.54 }, -- pescaria

	{ 148.08, 6361.76, 31.53 }, -- venda cartões
}

Citizen.CreateThread(function()
	local innerTable = {}
	for k,v in pairs(lojinhas) do
		table.insert(innerTable,{ v[1],v[2],v[3],1.75,"ASPAS","Atalho","para Abrir a loja" })
	end

	TriggerEvent("hoverfy:insertTable",innerTable)
end)

----------------------------------------------------------------------------
----------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHOVERFY BAUS
-----------------------------------------------------------------------------------------------------------------------------------------

local bausfacs = { -- adicione abaixo as coordenadas para aparecer o atalho dos blips
    { 747.39, -1905.08, 29.47 }, 
	{147.9, -1707.67, 22.21}, -- 
	{-2399.82, 1736.41, 197.15}, 
	{583.65, -427.91, 17.63}, -- 
	{1260.65, -216.97, 99.99}, --
	{-1256.76, -1126.27, 0.79},
	{678.92, 2367.31, 51.51},
	{943.21, -1486.78, 23.05},
	{-1521.26, 121.48, 48.65},
	{-1863.39, 2054.27, 135.46},
	{4434.1, -4471.04, 4.33},
	{2519.4, 4100.73, 35.59},
	{977.1, -104.05, 74.85},
	{106.88, -1299.24, 28.77},
	{153.37, -3011.68, 10.71},
	{-1203.05, -895.46, 14.0},
	{1317.99, -774.66, 65.67},
	{1301.4, -766.38, 65.67},
	{55.5, 6542.53, 32.5},
	{278.0, -349.27, 49.58},
	{-2009.71, -503.87, 12.23},
	{106.06, 6546.5, 32.5},
}

Citizen.CreateThread(function()
	local innerTable = {}
	for k,v in pairs(bausfacs) do
		table.insert(innerTable,{ v[1],v[2],v[3],1.75,"ASPAS","Atalho","para Abrir o báu" })
	end

	TriggerEvent("hoverfy:insertTable",innerTable)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHOVERFY CRAFT
-----------------------------------------------------------------------------------------------------------------------------------------
--[[ 
local craftitens = { -- adicione abaixo as coordenadas para aparecer o atalho dos blips

     {-1870.55, 2061.79, 135.44}, --armas 
	{-1518.26, 125.34, 48.66},-- armas

	{2518.78, 4107.43, 35.592}, -- munição
     {1002.54, -128.21, 74.07},  --munição

	 {129.49, -1283.82, 29.27}, -- drinks
	 {135.38, -3050.54, 7.05}, -- peças driftking

	 { 713.2, -967.78, 30.4 }, -- costura farc
     { 713.25, -969.86, 30.4 }, -- costura farc 
     { 713.21, -972.11, 30.4 },-- costura farc

	 {-1197.32, -899.93, 14.0}, -- burguershot

}

Citizen.CreateThread(function()
	local innerTable = {}
	for k,v in pairs(craftitens) do
		table.insert(innerTable,{ v[1],v[2],v[3],1.75,"ASPAS","Mochila","para Abrir e vá em craft" })
	end

	TriggerEvent("hoverfy:insertTable",innerTable)
end) ]]