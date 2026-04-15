local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_bancosks")
vRPNserver = Tunnel.getInterface("vrp_bancosks")

tcRP = Tunnel.getInterface("vrp_bancosks")

local giveCashAnywhere = false 
local withdraWAnywhere = false 
local depositAnywhere = false 
local displayBankBlips = true 
local enableBankingGui = true 

local banks = {
  {name="Banco", id=108, x=150.266, y=-1040.203, z=29.374},
  {name="Banco", id=108, x=-1212.980, y=-330.841, z=37.787},
  {name="Banco", id=108, x=-2962.582, y=482.627, z=15.703},
  {name="Banco", id=108, x=-112.202, y=6469.295, z=31.626},
  {name="Banco", id=108, x=314.187, y=-278.621, z=54.170},
  {name="Banco", id=108, x=-351.534, y=-49.529, z=49.042},
  {name="Banco", id=108, x=237.44, y=217.82, z=106.28},
  {name="Banco", id=108,  x = -1040.44, y = -2845.98, z = 27.72},

  local function nearBanco(maxDistance)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    maxDistance = maxDistance or 2.0

    for _, v in pairs(banks) do
        local bankVec = vector3(v.x, v.y, v.z)
        local dist = #(coords - bankVec)

        if dist <= maxDistance then
            return true, bankVec, dist
        end
    end

    return false, nil, nil
end


--[[   {name="ATM", id=277, x=-386.733, y=6045.953, z=31.501},
  {name="ATM", id=277, x=-283.23, y=6226.21, z=31.5},
  {name="ATM", id=277, x=-135.165, y=6365.738, z=31.101},
  {name="ATM", id=277, x=-110.753, y=6467.703, z=31.784},
  {name="ATM", id=277, x=-94.9690, y=6455.301, z=31.784},
  {name="ATM", id=277, x=155.8, y=6642.86, z=31.61}, 
  {name="ATM", id=277, x=174.2, y=6637.86, z=31.58}, 
  {name="ATM", id=277, x=1701.31, y=6426.56, z=32.77}, 
  {name="ATM", id=277, x=1735.28, y=6410.6, z=35.04}, 
  {name="ATM", id=277, x=1702.842, y=4933.593, z=42.051},
  {name="ATM", id=277, x=1968.01, y=3743.61, z=32.35}, 
  {name="ATM", id=277, x=1821.917, y=3683.483, z=34.244},
  {name="ATM", id=277, x=1174.532, y=2705.278, z=38.027},
  {name="ATM", id=277, x=540.0420, y=2671.007, z=42.177},
  {name="ATM", id=277, x=2564.399, y=2585.100, z=38.016},
  {name="ATM", id=277, x=2558.683, y=349.6010, z=108.050},
  {name="ATM", id=277, x=2558.051, y=389.4817, z=108.660},
  {name="ATM", id=277, x=1077.692, y=-775.796, z=58.218},
  {name="ATM", id=277, x=-577.08, y=-194.76, z=38.21},
  {name="ATM", id=277, x= 947.79, y=-965.18, z=39.76},
  {name="ATM", id=277, x= 1123.24, y=-653.7, z=56.75},
  {name="ATM", id=277, x= 417.78, y= 6471.53, z= 28.82},
  {name="ATM", id=277, x= 38.44, y=6544, z=31.55},
  {name="ATM", id=277, x= 645.7, y=-3014.66, z=6.24},
  {name="ATM", id=277, x= -425.75, y=-2788.2, z=38.21},
  {name="ATM", id=277, x= 324.97, y=-224.34, z=54.08},
  {name="ATM", id=277, x= -207.56, y=-1337.97, z=34.9},
  {name="ATM", id=277, x= -425.51, y= -2787.94, z= 6.01},
  {name="ATM", id=277, x=1153.884, y=-326.540, z=69.245},
  {name="ATM", id=277, x=-1074.31, y=-827.41, z=27.03},
  {name="ATM", id=277, x=-1073.90, y=-827.74, z=19.03},
  {name="ATM", id=277, x=-1110.88, y=-836.32, z=19.00},
  {name="ATM", id=277, x=129.66, y=-1291.97, z=29.26},
  {name="ATM", id=277, x=-809.4, y=-1238.18, z=7.34},
  {name="ATM", id=277, x=-1810.58, y=-1208.23, z=14.30},
  {name="ATM", id=277, x=381.2827, y=323.2518, z=103.270},
  {name="ATM", id=277, x=265.0043, y=212.1717, z=106.780},
  {name="ATM", id=277, x=285.43, y=143.5, z=104.18},
  {name="ATM", id=277, x= 158.64, y=234.12, z=106.63}, 
  {name="ATM", id=277, x=-164.568, y=233.5066, z=94.919},
  {name="ATM", id=277, x=-1827.04, y=785.5159, z=138.020},
  {name="ATM", id=277, x=-1409.39, y=-99.2603, z=52.473},
  {name="ATM", id=277, x=-1205.35, y=-325.579, z=37.870},
  {name="ATM", id=277, x=-2975.09, y=380.26, z=15.0},
  {name="ATM", id=277, x= -3044.16, y=594.51, z=7.74}, 
  {name="ATM", id=277, x=-3144.13, y=1127.415, z=20.868},
  {name="ATM", id=277, x=-3241.10, y=996.6881, z=12.500},
  {name="ATM", id=277, x=-3241.11, y=1009.152, z=12.877},
  {name="ATM", id=277, x=-1305.40, y=-706.240, z=25.352},
  {name="ATM", id=277, x=-538.225, y=-854.423, z=29.234},
  {name="ATM", id=277, x=-711.156, y=-818.958, z=23.768},
  {name="ATM", id=277, x=-717.614, y=-915.880, z=19.268},
  {name="ATM", id=277, x=-526.566, y=-1222.90, z=18.434},
  {name="ATM", id=277, x=-256.831, y=-719.646, z=33.444},
  {name="ATM", id=277, x=112.4102, y=-776.162, z=31.427},
  {name="ATM", id=277, x=112.71, y=-819.37, z=31.34},
  {name="ATM", id=277, x=119.9000, y=-883.826, z=31.191},
  {name="ATM", id=277, x=-56.91, y=-1752.17, z=29.43},
  {name="ATM", id=277, x=-261.692, y=-2012.64, z=30.121},
  {name="ATM", id=277, x=-273.001, y=-2025.60, z=30.197},
  {name="ATM", id=277, x=314.187, y=-278.621, z=54.170},
  {name="ATM", id=277, x=-351.534, y=-49.529, z=49.042},
  {name="ATM", id=277, x=24.589, y=-946.056, z=29.357},
  {name="ATM", id=277, x=-254.112, y=-692.483, z=33.616},
  {name="ATM", id=277, x=-1570.197, y=-546.651, z=34.955},
  {name="ATM", id=277, x=-1415.909, y=-211.825, z=46.500},
  {name="ATM", id=277, x=-1430.112, y=-211.014, z=46.500},
  {name="ATM", id=277, x=33.232, y=-1347.849, z=29.497}, 
  {name="ATM", id=277, x=288.76, y=-1282.39, z=29.66}, 
  {name="ATM", id=277, x=289.012, y=-1256.545, z=29.440},
  {name="ATM", id=277, x=295.839, y=-895.640, z=29.217},
  {name="ATM", id=277, x=1686.753, y=4815.809, z=42.008},
  {name="ATM", id=277, x=5.134, y=-919.949, z=29.557},
  {name="ATM", id=277, x=419.07, y=-986.37, z=29.38},
  {name="ATM", id=277, x=-31.548, y=-1121.443, z=26.547},
  {name="ATM", id=277, x=-1391.021, y=-590.427, z=30.319},
  {name="ATM", id=277, x=2683.11, y=3286.63, z=55.24},
  {name="ATM", id=277, x=296.17, y=-591.19, z=43.27},
  {name="ATM", id=277, x=315.15, y=-593.73, z=43.29},
  {name="ATM", id=277, x=527.29, y=-160.79, z=57.09},
  {name="ATM", id=277, x=-203.71, y=-861.32, z=30.27},
  {name="ATM", id=277, x=-1109.71, y=-1690.81, z=4.38},
  {name="ATM", id=277, x=-1315.31, y=-835.33, z=16.97},
  {name="ATM", id=277, x=-721.15, y=-415.58, z=34.99}, 
  {name="ATM", id=277, x=-2038.06, y=-469.17, z=12.25}, 
  {name="ATM", id=277, x=-2072.42, y=-317.12, z=13.32},
   {name="ATM", id=277, x=-3040.83, y=593.16, z=7.91},
   {name="ATM", id=277, x=1493.14, y=-2278.67, z=72.18}, ]]
} 



function CalculateTimeToDisplay()
	hora = GetClockHours()
	if hora <= 9 then
		hora = "0" .. hora
	end
end

Citizen.CreateThread(function()
  if displayBankBlips then
    for k,v in ipairs(banks)do
      local blip = AddBlipForCoord(v.x, v.y, v.z)
      SetBlipSprite(blip, v.id)
      SetBlipScale(blip, 0.4)
      SetBlipColour(blip, 66)
      SetBlipAsShortRange(blip, true)
      BeginTextCommandSetBlipName("STRING");
      AddTextComponentString(tostring(v.name))
      EndTextCommandSetBlipName(blip)
    end
  end
end)

local atBank = false
local bankOpen = false

local salario = "10"

RegisterNetEvent('send:banco')
AddEventHandler('send:banco', function(banco, salario)
  TransitionToBlurred(1000)
  SetNuiFocus(true, true)
  SendNUIMessage({
    openBank = true,
    banco = banco,
    salario = salario
  })
end)


function closeGui()
  TransitionFromBlurred(1000)
  SetNuiFocus(false)
  SendNUIMessage({openBank = false})
  bankOpen = false
  atmOpen = false
end

--[[ Citizen.CreateThread(function()
  while true do
    local alta = 1000
    local pos = GetEntityCoords(PlayerPedId(), true)
    for k, j in pairs(banks) do
      if(Vdist(pos.x, pos.y, pos.z, j.x, j.y, j.z) < 150.0) then
        if(Vdist(pos.x, pos.y, pos.z, j.x, j.y, j.z) < 2.0) then
		-- if vRPclient.getStandBY() > 0 then 
		-- alta = 1
    --       --DrawText3D(j.x, j.y, j.z+0.3,"~r~[Banco   QR]\n~w~Pressione [~r~E~w~] para acessar o banco")
    --     end
      end
    end
	Citizen.Wait(alta)
    end
  end  
end) ]]

local bankPromptId = "bank_prompt"

CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()

        if not IsPedInAnyVehicle(ped) then
            local coords = GetEntityCoords(ped)

            for _, j in pairs(banks) do
                local bankVec = vector3(j.x, j.y, j.z)
                local dist = #(coords - bankVec)

                if dist <= 2.0 then
                    sleep = 0

                    exports["ghost_ui"]:ShowPrompt({
                        id = bankPromptId,
                        coords = bankVec,
                        key = "E",
                        text = "Abrir banco",
                        offset = 0.6,
                        maxDistance = 2.0,
                        priority = 10,
                        active = true
                    })

                    -- ABRIR BANCO
                    if IsControlJustPressed(0, 38) then -- E
                        SetNuiFocus(true, true)
                        SendNUIMessage({ action = "showMenu" })
                    end

                    -- CARTÃO (tecla G)
                    if IsControlJustPressed(0, 47) then -- G
                        TriggerServerEvent("bank:requestCard") -- ajusta se tiver outro nome
                    end

                    break
                end
            end
        end

        -- ESCONDE SE NÃO ESTIVER PERTO
        if sleep == 1000 then
            exports["ghost_ui"]:HidePrompt(bankPromptId)
        end

        Wait(sleep)
    end
end)




function xpkMarker(x, y, z, sizex, sizey, sizez, src, id)
  if not HasStreamedTextureDictLoaded(src) then
      RequestStreamedTextureDict(src, true)
      while not HasStreamedTextureDictLoaded(src) do
          Wait(1)
      end
  else
      DrawMarker(9, x, y, z, 0.0, 0.0, 0.0, 90.0, 90.0, 0.0, sizex, sizey, sizez, 255, 255, 255, 255,false, true, 2, false, src, id, false)
  end
end

if enableBankingGui then
    Citizen.CreateThread(
        function()
            while true do
                local skips = 1000
                if (IsNearBank()) then
                    skips = 1
                    atBank = true
                    if IsControlJustPressed(1, 51) then
                        skips = 1

                        CalculateTimeToDisplay()
                      if parseInt(hora) >= 07 and parseInt(hora) <= 20 then
                          if bankOpen then
                              closeGui()

                              bankOpen = false
                          else
                              TriggerServerEvent("bank:update")
                              TriggerServerEvent("get:banco")
                              bankOpen = true
                          end
                        else
                          TriggerEvent("Notify","negado","O funcionamento dos bancos é das <b>07:00</b> às <b>21:00</b>.") 
                        end
                    end

                    if IsControlJustPressed(1, 47) then
                      CalculateTimeToDisplay()
                      if parseInt(hora) >= 07 and parseInt(hora) <= 20 then
                        tcRP.debitCard()
                      else
                        TriggerEvent("Notify","negado","O funcionamento dos bancos é das <b>07:00</b> às <b>21:00</b>.") 
                      end
                    end


                else
                    if (bankOpen) then
                        closeGui()
                    end
                    atBank = false
                    bankOpen = false
                end
                Citizen.Wait(skips)


            end
        end
    )
end



Citizen.CreateThread(function()
  while true do
    if bankOpen then
      local ply = PlayerPedId()
      local active = true
      DisableControlAction(0, 1, active) 
      DisableControlAction(0, 2, active) 
      DisableControlAction(0, 24, active) 
      DisablePlayerFiring(ply, true) 
      DisableControlAction(0, 142, active)
      DisableControlAction(0, 106, active) 
    end
    Citizen.Wait(3000)
  end
end)

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
  closeGui()
end)

RegisterNUICallback('balance', function(data, cb)
  SendNUIMessage({openSection = "balance"})
  --TriggerServerEvent("get:banco")
end)

RegisterNUICallback('multasbalance', function(data, cb)
  SendNUIMessage({openSection = "multasbalance"})
  cb('ok')
end)

RegisterNUICallback('withdraw', function(data, cb)
  SendNUIMessage({openSection = "withdraw"})
 TriggerServerEvent("get:banco")
end)

RegisterNUICallback('deposit', function(data, cb)
  SendNUIMessage({openSection = "deposit"})
  --TriggerServerEvent("get:banco")
end)

RegisterNUICallback('transfer', function(data, cb)
  SendNUIMessage({openSection = "transfer"})
 -- TriggerServerEvent("get:banco")
end)

RegisterNUICallback('quickCash0', function(data, cb)
  TriggerServerEvent('bank:quickCash0')
 -- TriggerServerEvent("get:banco")
end)

RegisterNUICallback('quickCash', function(data, cb)
  TriggerServerEvent('bank:quickCash')
 -- TriggerServerEvent("get:banco")
end)

RegisterNUICallback('quickCash2', function(data, cb)
  TriggerServerEvent('bank:quickCash2')
 -- TriggerServerEvent("get:banco")
end)

RegisterNUICallback('quickCash3', function(data, cb)
  TriggerServerEvent('bank:quickCash3')
 -- TriggerServerEvent("get:banco")
end)

RegisterNUICallback('quickdeposit0', function(data, cb)
  TriggerServerEvent('bank:quickdeposit0')
 -- TriggerServerEvent("get:banco")
end)

RegisterNUICallback('quickdeposit', function(data, cb)
  TriggerServerEvent('bank:quickdeposit')
 -- TriggerServerEvent("get:banco")
end)

RegisterNUICallback('quickdeposit2', function(data, cb)
  TriggerServerEvent('bank:quickdeposit2')
 -- TriggerServerEvent("get:banco")
end)

RegisterNUICallback('quickdeposit3', function(data, cb)
  TriggerServerEvent('bank:quickdeposit3')
 -- TriggerServerEvent("get:banco")
end)

RegisterNUICallback('erroMulta', function()
  TriggerEvent('Notify',"negado","Você não tem nenhuma multa para pagar")
end)
RegisterNUICallback('erroMulta2', function()
  TriggerEvent('Notify',"negado","Valor desejado inexistente")
end)

RegisterNUICallback('withdrawSubmit', function(data, cb)
  TriggerEvent('bank:withdraw', data.amount)
  --TriggerServerEvent("get:banco")
end)

RegisterNUICallback('pagarMulta', function(data,cb)
  TriggerEvent('bank:pagarmulta', tonumber(data.amount))
  cb('ok')
end)

RegisterNUICallback('depositSubmit', function(data, cb)
  TriggerEvent('bank:deposit', data.amount)
  --TriggerServerEvent("get:banco")
end)

RegisterNUICallback('multaSubmit', function(data, cb)
  --vRPNserver.Multas()
  vRPNserver.Multas(data.amount)
  vRP.getMoney(user_id)
  --TriggerServerEvent("get:banco")
end)

RegisterNUICallback('transferSubmit', function(data, cb)
  local toPlayer = data.toPlayer
  local amount = data.amount
  TriggerServerEvent("bank:transfer", toPlayer, tonumber(amount))
end)


function IsNearBank()
  local ply = PlayerPedId()
  local plyCoords = GetEntityCoords(ply, 0)
  for _, item in pairs(banks) do
    local distance = GetDistanceBetweenCoords(item.x, item.y, item.z,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
    if (distance <= 3) then
      return true
    end
  end
end


function IsNearPlayer(player)
  local ply = PlayerPedId()
  local plyCoords = GetEntityCoords(ply, 0)
  local ply2 = GetPlayerPed(GetPlayerFromServerId(player))
  local ply2Coords = GetEntityCoords(ply2, 0)
  local distance = GetDistanceBetweenCoords(ply2Coords["x"], ply2Coords["y"], ply2Coords["z"],  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
  if (distance <= 5) then
    return true
  end
end


RegisterNetEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
  if(IsNearBank() == true or depositAnywhere == true ) then
    TriggerServerEvent("bank:deposit", tonumber(amount))
  else
    TriggerClientEvent("Notify",source,"negado","Você só pode depositar em um banco!")
  end
end)


RegisterNetEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
  if(IsNearBank() == true or withdraWAnywhere == true) then
      TriggerServerEvent("bank:withdraw", tonumber(amount))
      vRP.notify("Você acabou de sacar $" ..amount)
  else
    TriggerClientEvent("Notify",source,"negado","Você só pode sacar em um banco!")
  end
end)

RegisterNetEvent('bank:pagarmulta')
AddEventHandler('bank:pagarmulta', function(amount)
  if(IsNearBank() == true or depositAnywhere == true ) then
    TriggerServerEvent("bank:pagarmulta", tonumber(amount))
  else
    vRP.notifyError("Você só pode pagar multa em um banco!")
  end
end)

RegisterNetEvent('bank:transfer')
AddEventHandler('bank:transfer', function(toPlayer, amount)
  if(IsNearPlayer(toPlayer) == true or giveCashAnywhere == true) then
    local player2 = GetPlayerFromServerId(toPlayer)
    local playing = IsPlayerPlaying(player2)
    if (playing ~= false) then
      TriggerServerEvent("bank:givecash", toPlayer, tonumber(amount))
      vRP.notify("Você transferiu " .. tonumber(amount) .. " para " .. toPlayer)
    else
      vRP.notifyWarning("Cidadão fora da cidade!")
    end
  else
    vRP.notifyWarning("Cidadão não mora nessa cidade!")
  end
end)

RegisterNetEvent('banking:updateBalance')
AddEventHandler('banking:updateBalance', function(balance, walletbalance, multasbalance,   identidade, emprego)
	SendNUIMessage({
		updateBalance = true,
    balance = balance,
    walletbalance = walletbalance,
    multasbalance = multasbalance,   
    identidade = identidade,
    emprego = emprego
	})
end)


RegisterNetEvent("banking:addBalance")
AddEventHandler("banking:addBalance", function(amount)
  SendNUIMessage({
    addBalance = true,
    amount = amount
  })
end)


RegisterNetEvent("banking:removeBalance")
AddEventHandler("banking:removeBalance", function(amount)
  SendNUIMessage({
    removeBalance = true,
    amount = amount
  })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAW3DS
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z, text)
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
end