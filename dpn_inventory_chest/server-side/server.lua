vRP = module("vrp", "lib/Proxy").getInterface("vRP")
vRPclient = module("vrp", "lib/Tunnel").getInterface("vRP")
dPN = {}
module("vrp", "lib/Tunnel").bindInterface("dpn_inventory_chest", dPN)
module("vrp", "lib/Proxy").addInterface("dpn_inventory_chest", dPN)
dPNclient = module("vrp", "lib/Tunnel").getInterface("dpn_inventory_chest")
if ConfigServer.groups and module(ConfigServer.groups) then
    cfgGroups = module(ConfigServer.groups)
end
vGARAGE = module("vrp", "lib/Tunnel").getInterface(ConfigServer.garageName)
vSKILLBAR = module("vrp", "lib/Tunnel").getInterface(ConfigServer.skilBar)

local craftTable = {}

--if ConfigServer['itemVrp'] ~= "zirix" and ConfigServer['itemVrp'] ~= "evolution" and ConfigServer['garageName'] ~=
--    "nation_garages" then
--    inventory = module("vrp", ConfigServer['itemVrp'])
--end

vRP.prepare("getUserIdentity", "SELECT * FROM vrp_user_identities WHERE user_id = @user_id")
vRP.prepare("getUserIdentitycreative", "SELECT * FROM vrp_users WHERE id = @user_id")
vRP.prepare("get_userbyreg", "SELECT user_id FROM vrp_user_identities WHERE registration = @registration")
vRP.prepare("get_userbyregcreative", "SELECT id FROM vrp_users WHERE registration = @registration")

vRP._prepare("get_homeSlots", "SELECT * FROM vrp_homes_permissions WHERE home = @home")
vRP._prepare("get_homeSlotsCreative", "SELECT * FROM vrp_homes WHERE home = @home")

vRP._prepare("buySlotInventory", "UPDATE vrp_user_identities SET slots = @slots WHERE user_id = @user_id")
vRP._prepare("buySlotInventoryCreative", "UPDATE vrp_users SET slots = @slots WHERE id = @user_id")

vRP.prepare("get_vrp_users", "SELECT * FROM vrp_users WHERE id = @id")
vRP.prepare("getPerm", "SELECT * FROM vrp_permissions WHERE user_id = @user_id")
vRP.prepare("get_vrp_infos", "SELECT * FROM vrp_infos WHERE steam = @steam")
vRP.prepare("get_group", "SELECT * FROM vrp_permissions WHERE user_id = @user_id AND permiss = @permiss")
vRP._prepare("createTable", [[
ALTER TABLE vrp_homes_permissions ADD IF NOT EXISTS slotsChest INT NOT NULL DEFAULT 15;
ALTER TABLE vrp_user_identities ADD IF NOT EXISTS slots INT NOT NULL DEFAULT 15;
]])

local garage
if ConfigServer['garageName'] == "nation_garages" then
    local Proxy = module("vrp", "lib/Proxy")
    garage = Proxy.getInterface(ConfigServer['garageName'])
end

local cfgAntidupe = ConfigServer["antiDupeEnabled"] or true

itensPlayer = {}
itensPlayer.items = {}
local dano, cadencia, precisao, recoil = nil
local localLopp = 0
local uchests = {}
local vchests = {}
local chestOpen = {}
local facOpen = {}
local vaultAmount = {}
-- local items = {}
local truePesoInventory = {}
local chestTrue = {}
local slotsVerify = {}

function SendWebhookMessage(webhook, message)
    if webhook ~= nil and webhook ~= "" then
        PerformHttpRequest(webhook, function(err, text, headers)
        end, 'POST', json.encode({
            content = message
        }), {
            ['Content-Type'] = 'application/json'
        })
    end
end

function getIdentitySlot(user_id)
    if ConfigServer["getIdentity"] == true then
        return vRP.getUserIdentity(user_id)
    elseif ConfigServer['creative2'] == true then
        local rows = vRP.query("getUserIdentitycreative", {
            user_id = user_id
        })
        return rows[1]
    else
        local rows = vRP.query("getUserIdentity", {
            user_id = user_id
        })
        return rows[1]
    end
end

function dPN.getIdentityPlayer()
    local source = source
    local user_id = vRP.getUserId(source)
    local firstName = "Error" -- Nome
    local secondName = "Error" -- Sobrenome
    local idade = "Error" -- Idade
    local id = "Error" -- Passaporte
    local registro = "Error" -- Registro
    local telefone = "Error" -- Telefone
    local emprego = "Error" -- Emprego
    local vip = "Error" -- Vip
    local multas = "Error" -- Multas
    local dinheiroCarteira = "Error" -- Carteira
    local dinheiroBanco = "Error" -- Banco
    local admin = false

    local consult = vRP.query("SkS/selectMultas",{ user_id = user_id }) -- vRP.getUData(user_id, ConfigServer["multasType"])

    if ConfigServer['bahamas'] == true then
        local identity = getUserIdentityBahamas(user_id)
        firstName = identity.name -- Nome
        secondName = identity.name2 -- Sobrenome
        idade = getSteam(source) -- Steam
        id = user_id -- Passaporte
        registro = identity.registration -- Registro
        telefone = identity.phone -- Telefone

        if getGroupBahammas(user_id).permiss ~= "" then
            emprego = getGroupBahammas(user_id).permiss
        else
            emprego = "Nenhum"
        end -- Emprego

        if getPremium() ~= false then
            vip = "Tem"
        else
            vip = "Nenhum"
        end -- Emprego

        if consult[1].multas == "" then
            multas = "Nenhuma"
        else
            if ConfigServer['currency'] then
                local tipommulta = ConfigServer['currency']
                multas = tipommulta .. " " .. consult[1].multas
            else
                print('[dpn_inventory] Olhe as atualiza��es do inventário')
            end
        end -- Multas

        if hasPermission(user_id, ConfigServer['adminPermissao']) then
            admin = true
        end -- Adm

        dinheiroCarteira = "Deletar" -- Dinheiro carteira
        dinheiroBanco = identity.bank -- Dinheiro banco

    elseif ConfigServer['bahamas'] == false then
        local identity = getUserIdentity(user_id)

        firstName = identity.name -- Nome
        secondName = identity.firstname -- Sobrenome
        idade = identity.age -- Idade
        id = user_id -- Passaporte
        registro = identity.registration -- Registro
        telefone = identity.phone -- Telefone

        if getGroupPlayer(user_id, ConfigServer["typeJob"]) ~= "" then
            emprego = getGroupPlayer(user_id, ConfigServer["typeJob"])
        else
            emprego = "Nenhum"
        end -- Emprego

        if getGroupPlayer(user_id, ConfigServer["typeVip"]) ~= "" then
            vip = getGroupPlayer(user_id, ConfigServer["typeVip"])
        else
            vip = "Nenhum"
        end -- Emprego

        if consult[1].multas == "" then
            multas = "Nenhuma"
        else
            if ConfigServer['currency'] then
                local tipommulta = ConfigServer['currency']
                multas = tipommulta .. " " .. consult[1].multas
            else
                print('[dpn_inventory] Olhe as atualiza��es do inventário')
            end
        end -- Multas

        if hasPermission(user_id, ConfigServer['adminPermissao']) then
            admin = true
        end -- Adm

        dinheiroCarteira = getMoney(user_id) -- Dinheiro carteira
        dinheiroBanco = getBankMoney(user_id) -- Dinheiro banco

    else
        print('[dpn_inventory] Tivemos um erro ao definir a base')
    end
    return firstName, secondName, idade, id, registro, telefone, emprego, vip, multas, dinheiroCarteira, dinheiroBanco,
        admin
end

function loopItem(user_id)
    local inventory = getPlayerInventory(user_id)
    if inventory then
        for k, v in pairs(inventory) do
            for a, b in pairs(ConfigServer['listaDeItens']) do -- Pega os itens da tabela
                if a == k then
                    if vRP.updateItens(user_id, k) then -- Deleta o antigo
                        vRP.giveInventoryItem(user_id, k, v.amount)
                        loopItem(user_id)
                    end
                end
            end
        end
    end
end

function dPN.getInventoryPlayer()
    local source = source
    local user_id = vRP.getUserId(source)
    local inventario = {}
    local slotsIdentity = getIdentitySlot(user_id)
    local slot = slotsIdentity.slots
    local slot2 = slotsIdentity.slots
    local slot3 = ConfigServer['slots'] - slotsIdentity.slots
    if user_id then
        local pesoinventario = 0
        truePesoInventory[user_id] = false

        local inventory = getPlayerInventory(user_id)
        if inventory then
            loopItem(user_id)
            for k, v in pairs(inventory) do
                if not inTable(v.item) then
                    local item = v.item
                    vRP.delteItem(user_id, item)
                    return
                end

                if parseInt(v.amount) <= 0 then
                    local item = v.item
                    vRP.delteItem(user_id, v.item)
                    return
                end

                if k and v.amount > 0 then

                    if dPN.retrieveType(v.item) == "equipar" then
                        local weaponNoWbody = v.item:gsub("wbody|", "")

                        local cadencia, precisao, recoil, hudCapacity = dPNclient.getWeaponStatus(source, weaponNoWbody)
                        local dano = dPNclient.getDamagedWeapon(source, weaponNoWbody)

                        v.amount = tonumber(v.amount)
                        v.name = dPN.retrieveNome(v.item)
                        v.index = dPN.retrieveIndex(v.item)
                        v.type = dPN.retrieveType(v.item)
                        v.peso = vRP.getItemWeight(v.item)
                        v.dano = dano
                        v.cadencia = hudCapacity
                        v.precisao = precisao
                        v.recoil = recoil
                        v.filter = "arma"
                        v.key = v.item

                        inventario[k] = v
                    end

                    if dPN.retrieveType(v.item) == "usar" or dPN.retrieveType(v.item) == "recarregar" then
                        v.amount = tonumber(v.amount)
                        v.name = dPN.retrieveNome(v.item)
                        v.index = dPN.retrieveIndex(v.item)
                        v.type = dPN.retrieveType(v.item)
                        v.funcao = dPN.retrieveFuncao(v.item)
                        v.descricao = dPN.retrieveDescricao(v.item)
                        v.peso = vRP.getItemWeight(v.item)
                        v.filter = dPN.retrieveFiltro(v.item)
                        v.key = v.item

                        inventario[k] = v
                    end
                    if inTable(v.item) then
                        truePesoInventory[user_id] = true
                    end
                end
            end
        end
        if truePesoInventory[user_id] == true then
            pesoinventario = computeItemsWeight(inventory)
        else
            pesoinventario = 0
        end

        return inventario, pesoinventario, pegarTamanhoDoInv(user_id), slot, slot2, slot3, ConfigServer['priceSlot']
    end
end

Citizen.CreateThread(function()
    vRP.execute("createTable")
    if not ConfigServer["webhook"]["antidupe"] then
        Wait(3000)
        print(
            "[dpn_inventory] DICA: Fique por dentro dos banimentos por Dupe! Na sua \"Config_server.lua\", deixe algo similar a isto: (https://imgur.com/a/QUeYMSf)")
    end
end)

function pegarTamanhoDoInv(user_id)
    return math.floor(vRP.expToLevel(vRP.getExp(user_id, "physical", "strength"))) * 3
end

function inTable(item)
    if ConfigServer['listaDeItens'][item] ~= nil then
        return ConfigServer['listaDeItens'][item]
    end
end

function dPN.retrieveFiltro(item)
    if ConfigServer['listaDeItens'][item] ~= nil then
        return ConfigServer['listaDeItens'][item].filtro
    end
end

function dPN.retrieveDescricao(item)
    if ConfigServer['listaDeItens'][item] ~= nil then
        return ConfigServer['listaDeItens'][item].descricao
    end
end

function dPN.retrieveFuncao(item)
    if ConfigServer['listaDeItens'][item] ~= nil then
        return ConfigServer['listaDeItens'][item].funcao
    end
end

function dPN.retrieveType(item)
    if ConfigServer['listaDeItens'][item] ~= nil then
        return ConfigServer['listaDeItens'][item].type
    end
end

function dPN.retrieveNome(item)
    if ConfigServer['listaDeItens'][item] ~= nil then
        return ConfigServer['listaDeItens'][item].nome
    end
end

function dPN.retrieveIndex(item)
    if ConfigServer['listaDeItens'][item] ~= nil then
        return ConfigServer['listaDeItens'][item].index
    end
end

function getPlayerInventory(user_id)
    local data = vRP.getUserDataTable(user_id)
    if data then
        return data.inventory
    end
end

function dPN.moverSlot(item, oldSlot, newSlot, amount)
    local source = source
    local user_id = vRP.getUserId(source)
    local inventory = vRP.getUserDataTable(user_id)
    local data = inventory.inventory
    if user_id and item and oldSlot and newSlot and amount then
        if data[tostring(oldSlot)] then
            if data[tostring(oldSlot)].amount then
                vRP.updateSlot(user_id, item, oldSlot, newSlot, amount)
                dPNclient.updateInventory(source)
            end
        end
    else
        print("[dpn_inventory] ERRO: Falha ao mover um item de slot")
        print(item, oldSlot, newSlot, amount)
    end
end

function dPN.errorCraft(slot, item, amount, index)
    local source = source
    local user_id = vRP.getUserId(source)
    local needToUpdate = false
    for k, v in pairs(ConfigCraft['craft'][index]['slot']) do
        if v.item ~= "nada" and v.quantidade > 0 then
            vRP.giveInventoryItem(user_id, v.item, v.quantidade)
            needToUpdate = true
        end
    end

    if needToUpdate then
        dPNclient.updateInventory(source)
    end
end

function dPN.giveItemCraft(slot, item, amount, index)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        slotsVerify[user_id] = 0
        for k, v in pairs(ConfigCraft['craft'][index]['slot']) do
            if v.item and v.quantidade then
                if v.item ~= nil and v.item ~= "nada" and v.quantidade ~= nil and v.quantidade >= 0 then
                    if craftTable[v.item] then
                        if vRP.getInventoryItemAmount(user_id, v.item) >= craftTable[v.item] then
                            slotsVerify[user_id] = slotsVerify[user_id] + 1
                        end
                    end
                else
                    slotsVerify[user_id] = slotsVerify[user_id] + 1
                end
            end
        end
        if not dPN.antiflood(source, "dope:giveItemCraft", 2) then
            if slotsVerify[user_id] == 9 then
                for k, v in pairs(ConfigCraft['craft'][index]['slot']) do
                    if v.item and v.quantidade then
                        if v.item ~= nil and v.item ~= "nada" and v.quantidade ~= nil and v.quantidade >= 0 then
                            vRP.tryGetInventoryItem(user_id, v.item, v.quantidade)
                        end
                    end
                end
                vRP.giveInventoryItem(user_id, ConfigCraft['craft'][index]['resultado']['name'], amount, slot)
                dPNclient.updateInventory(source)
                craftTable = {}
				SendWebhookMessage(ConfigServer['webhook'].craft,"```prolog\n[ID]: "..user_id.." \n[CRAFTOU]: "..ConfigCraft['craft'][index]['resultado']['name'].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
            else
                craftTable = {}
                TriggerClientEvent("Notify", source, "negado", "Negado, você não tem a quantidade de itens correta")
            end
        end
    end
end

function dPN.retrieveCraftItem(itemName)
    return dPN.retrieveIndex(itemName)
end
function dPN.retrieveCraftItemName(itemName)
    return dPN.retrieveNome(itemName)
end

function dPN.removeItemCraft(item, slot, amount)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.getInventoryItemAmount(user_id, item) >= amount then
            if craftTable[item] then
                craftTable[item] = craftTable[item] + amount
            else
                craftTable[item] = amount
            end
            dPNclient.updateInventory(source)
        end
    end
end

function dPN.dbClickRemove(item, amount)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        dPNclient.updateInventory(source)
        if craftTable[item] then
            craftTable[item] = craftTable[item] - amount
        else
            craftTable[item] = amount
        end
    end
end

-- Dados identidade BAHAMAS
function getInformation(user_id)
    return vRP.query("get_vrp_users", {
        id = parseInt(user_id)
    })
end

function getUserIdentityBahamas(user_id)
    local rows = getInformation(user_id)
    return rows[1]
end

function getSteam(source)
    local identifiers = GetPlayerIdentifiers(source)
    for k, v in ipairs(identifiers) do
        if string.sub(v, 1, 5) == "steam" then
            return v
        end
    end
end

function getGroupBahammas(user_id)
    local consult = vRP.query("getPerm", {
        user_id = user_id
    })
    return consult[1]
end

function getPremium(user_id)
    local identity = getUserIdentityBahamas(user_id)
    if identity then
        local consult = getInfos(identity.steam)
        if consult[1] and os.time() >= (consult[1].premium + 24 * consult[1].predays * 60 * 60) then
            return false
        else
            return true
        end
    end
end

function getInfos(steam)
    return vRP.query("get_vrp_infos", {
        steam = steam
    })
end

function getInventoryWeight(user_id)
    local data = vRP.getUserDataTable(user_id)
    if data and data.inventory then
        return computeItemsWeight(data.inventory)
    end
    return 0
end

-- Dados identidade outras BASES

function getUserIdentity(user_id)
    if ConfigServer['getIdentity2'] == true then
        return vRP.getUserIdentity(user_id)
    elseif ConfigServer['creative2'] == true then
        local rows = vRP.query("getUserIdentitycreative", {
            user_id = user_id
        })
        return rows[1]
    else
        local rows = vRP.query("getUserIdentity", {
            user_id = user_id
        })
        return rows[1]
    end
end

function getGroupPlayer(user_id, gtype)
    local user_groups = getUserGroups(user_id)
    for k, v in pairs(user_groups) do
        if ConfigServer['itemVrp'] ~= "zirix" and ConfigServer['itemVrp'] ~= "evolution" then
            if cfgGroups then
                local kgroup = cfgGroups.groups[k]
                if kgroup then
                    if kgroup._config and kgroup._config.gtype and kgroup._config.gtype == gtype then
                        return kgroup._config.title
                    end
                end
            end
        elseif ConfigServer['itemVrp'] == "zirix" or ConfigServer['itemVrp'] == "evolution" then
            local group = groups.list
            local kgroup = group[k]
            if kgroup then

                if kgroup._config and kgroup._config.gtype and kgroup._config.gtype == gtype then

                    return kgroup._config.title
                end
            end
        end
    end
    return ""
end

function getUserGroups(user_id)
    local data = vRP.getUserDataTable(user_id)
    if data then
        if data.groups == nil then
            data.groups = {}
        end
        return data.groups
    end
    return {}
end

function tryFullPayment(user_id, amount)
    return formaDeTirarDinheiro(user_id, amount)
end

-- function tryPayment(user_id, amount)
--       if amount >= 0 then
--               local money = getMoney(user_id)
--               if amount >= 0 and money >= amount then
--                       vRP.setMoney(user_id, money - amount)
--                       return true
--               else
--                       return false
--               end
--       end
--       return false
-- end

function getBankMoney(user_id)
    local tmp = vRP.getUserTmpTable(user_id)
    if tmp then
        return tmp.bank or 0
    else
        return 0
    end
end

function dPN.buySlot()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local identity = getIdentitySlot(user_id)
        if not identity then return end

        local slots = tonumber(identity.slots) or 15
        local faltam = (tonumber(ConfigServer['slots']) or 0) - slots

        if faltam > 0 then
            if tryFullPayment(user_id, ConfigServer['priceSlot']) then
                if ConfigServer['creative2'] == true then
                    vRP.execute('buySlotInventoryCreative', {
                        user_id = user_id,
                        slots = slots + 1
                    })
                else
                    vRP.execute('buySlotInventory', {
                        user_id = user_id,
                        slots = slots + 1
                    })
                end

                dPNclient.updateInventory(source)
            end
        end
    end
end

-- Porta malas

function dPN.getOpend(vnetid)
    if chestOpen[vnetid] == nil or chestOpen[vnetid] == false then
        chestOpen[vnetid] = true
        return true
    elseif chestOpen[vnetid] == true then
        return false
    end
end

function dPN.getPlacaVehicle(placa)
    local placa_user_id = getUserByRegistration(placa)
    return placa_user_id
end

function dPN.closeInventory(vnetid, chest)
    if chestOpen[vnetid] == true then
        chestOpen[vnetid] = false
        TriggerClientEvent('openTrunk', -1, vnetid, true)
    end
    if facOpen[chest] == true then
        facOpen[chest] = false
    end
end

function getUserByRegistration(registration, cbr)
    if not ConfigServer['creative2'] then
        local rows = vRP.query("get_userbyreg", {
            registration = registration or ""
        })
        if #rows > 0 then
            return rows[1].user_id
        end
    elseif ConfigServer['creative2'] == true then
        local rows = vRP.query("get_userbyregcreative", {
            registration = registration or ""
        })
        if #rows > 0 then
            return rows[1].id
        end
    else
        local rows = vRP.query("get_userbyreg", {
            registration = registration or ""
        })
        if #rows > 0 then
            return rows[1].user_id
        end
    end

end

-- Amunation

function dPN.getTableItemStore(tableItens)
    local source = source
    local user_id = vRP.getUserId(source)
    local tableWeapons = {}
    if user_id then
        for k, v in pairs(tableItens) do
            if inTable(k) then
                table.insert(tableWeapons, {
                    price = v.price,
                    amount = tonumber(0),
                    name = dPN.retrieveNome(k),
                    index = dPN.retrieveIndex(k),
                    type = dPN.retrieveType(k),
                    funcao = dPN.retrieveFuncao(k),
                    descricao = dPN.retrieveDescricao(k),
                    peso = vRP.getItemWeight(k),
                    filter = dPN.retrieveFiltro(k),
                    key = k
                })
            end
        end
        return tableWeapons
    end
end

function dPN.buyItem(item, preco, newSlot, amount, requireItem, requiredItems,loja)
    local source = source
    if not dPN.antiflood(source, "dope:buyItem", 3) then
        local user_id = vRP.getUserId(source)
        local newPrice = parseInt(preco) * parseInt(amount)
        if user_id then
            local inventory = getPlayerInventory(user_id)
            if inventory[tostring(newSlot)] == nil or inventory[tostring(newSlot)].item == item then
                local peso_item = vRP.getItemWeight(item)
                local equacao_item = peso_item * amount
                local peso_inventario = computeItemsWeight(inventory)
                if (peso_inventario + equacao_item) <= getInventoryMaxWeight(user_id) then
                    if requireItem then
                        for iname, iquant in pairs(requiredItems) do
                            if vRP.getInventoryItemAmount(user_id, iname) < iquant then
                                TriggerClientEvent("Notify", source, "negado",
                                    "Voc� precisa de <b>" .. iquant .. "x " .. dPN.retrieveNome(iname) ..
                                        "</b> para comprar este item.")
                                return
                            end
                        end
                    end

                    if tryFullPayment(user_id, newPrice) then
                        if requireItem then
                            for iname, iquant in pairs(requiredItems) do
                                vRP.tryGetInventoryItem(user_id, iname, iquant)
                            end
                        end

                        vRP.giveInventoryItem(user_id, item, amount, newSlot)
                        dPNclient.updateInventory(source)
						if loja ~= "arsenal" then
							SendWebhookMessage(ConfigServer['webhook'].compras,"```prolog\n[ID]: "..user_id.." \n[COMPROU]: "..amount.."x "..item.." \n[EM]: "..loja.." \n[VALOR]: "..preco.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						elseif loja == "arsenal" then
							SendWebhookMessage(ConfigServer['webhook'].arsenal,"```prolog\n[ID]: "..user_id.." \n[COMPROU]: "..amount.."x "..item.." \n[EM]: "..loja.." \n[VALOR]: "..preco.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						end
					else
                        TriggerClientEvent("Notify", source, "negado", "Saldo insuficiente para isto!")
                    end
                else
                    TriggerClientEvent("Notify", source, "negado", "Seu inventário não suporta isso")
                end
            end
        end
    end
end

function dPN.sellItem(item, preco, amount, slot,loja)
    local source = source
    if not dPN.antiflood(source, "dope:sellItem", 3) then
        local user_id = vRP.getUserId(source)
        if user_id then
            if vRP.tryGetInventoryItem(user_id, item, amount, slot) then
                formDeDarDinheiro(user_id, preco)
                dPNclient.updateInventory(source)
				SendWebhookMessage(ConfigServer['webhook'].compras,"```prolog\n[ID]: "..user_id.." \n[VENDEU]: "..amount.."x "..item.." \n[EM]: "..loja.." \n[VALOR]: "..preco.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
                TriggerClientEvent("Notify", source, "sucesso", "Voc� vendeu <b>" .. amount .. "x " ..
                    dPN.retrieveNome(item) .. "</b> por <b>R$" .. preco .. "</b>")
            end
        end
    end
end

-- Inicio do chest
function dPN.getTableItemChest(tableItens, bau)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local chestItens = {}
        local chestData = vRP.getSData("chest:" .. tostring(bau))
        local resultChest = json.decode(chestData) or {}
        local slotChest = 0
        local slotDoChest = tableItens['slots']
        local weightMaxChest = tableItens['weight']
        local inventoryChest = {}
        local pesodochest = 0
        chestTrue[user_id] = false
        if resultChest then
            local toChange = false
            for k, v in pairs(resultChest) do
                if parseInt(v.amount) <= 0 or v.item == nil or v.item == "" then
                    resultChest[tostring(k)] = nil
                    toChange = true
                end

                if inTable(k) then -- Inicio para verificar os baus antigo
                    repeat
                        slotChest = slotChest + 1
                    until resultChest[tostring(slotChest)] == nil or
                        (resultChest[tostring(slotChest)] and resultChest[tostring(slotChest)].item == k) -- Verifica o novo slot

                    resultChest[tostring(slotChest)] = {
                        amount = v.amount,
                        item = k
                    } -- Seta o item no novo slot
                    resultChest[tostring(k)] = nil -- Tira o antigo
                end -- Fim para verificar os itens antigo

                if inTable(v.item) and v.amount > 0 and v.item ~= "" then
                    if dPN.retrieveType(v.item) == "equipar" then
                        local weaponNoWbody = v.item:gsub("wbody|", "")

                        local cadencia, precisao, recoil, hudCapacity = dPNclient.getWeaponStatus(source, weaponNoWbody)
                        local dano = dPNclient.getDamagedWeapon(source, weaponNoWbody)

                        v.amount = tonumber(v.amount)
                        v.name = dPN.retrieveNome(v.item)
                        v.index = dPN.retrieveIndex(v.item)
                        v.type = dPN.retrieveType(v.item)
                        v.peso = vRP.getItemWeight(v.item)
                        v.dano = dano
                        v.cadencia = hudCapacity
                        v.precisao = precisao
                        v.recoil = recoil
                        v.filter = "arma"
                        v.key = v.item

                        inventoryChest[k] = v
                    end

                    if dPN.retrieveType(v.item) == "usar" or dPN.retrieveType(v.item) == "recarregar" then
                        v.amount = tonumber(v.amount)
                        v.name = dPN.retrieveNome(v.item)
                        v.index = dPN.retrieveIndex(v.item)
                        v.type = dPN.retrieveType(v.item)
                        v.funcao = dPN.retrieveFuncao(v.item)
                        v.descricao = dPN.retrieveDescricao(v.item)
                        v.peso = vRP.getItemWeight(v.item)
                        v.filter = dPN.retrieveFiltro(v.item)
                        v.key = v.item

                        inventoryChest[k] = v
                    end
                end
                if inTable(v.item) then
                    chestTrue[user_id] = true
                end
            end

            if toChange then
                vRP.setSData("chest:" .. tostring(bau), json.encode(resultChest))
                dPNclient.updateInventory(source)
            end
        end

        if chestTrue[user_id] == true then
            pesodochest = computeItemsWeight(resultChest)
        else
            pesodochest = 0
        end
        return inventoryChest, slotDoChest, weightMaxChest, pesodochest
    end
end

function getInventoryMaxWeight(user_id)
    return math.floor(vRP.expToLevel(vRP.getExp(user_id, "physical", "strength"))) * 3
end

function computeItemsWeight(itemsCompute)
    local weight = 0
    local neweight = 5

    for _, v in pairs(itemsCompute) do
        if v.item then
            local iweight = vRP.getItemWeight(v.item)
            weight = weight + iweight * v.amount
        else
            neweight = 5
        end
    end
    if not weight then
        return neweight
    end
    return weight
end

function dPN.verifyPermission(permission)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if hasPermission(user_id, permission) then
            return true
        else
            return false
        end
    end
end

function dPN.verifyOpenChest(chest)
    if facOpen[chest] == nil or facOpen[chest] == false then
        facOpen[chest] = true
        return true
    else
        return false
    end
end

function dPN.moverSlotChest(item, oldSlot, newSlot, amount, chest)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        dPN.updateSlotChest(user_id, item, oldSlot, newSlot, amount, chest)
        -- dPNclient.updateInventory(source)
    end
end

function dPN.updateSlotChest(user_id, item, oldSlot, newSlot, amount, chest)
    local source = vRP.getUserSource(user_id)
    local dataDOChest = vRP.getSData("chest:" .. tostring(chest))
    local chestResultdata = json.decode(dataDOChest) or {}
    if chestResultdata then
        if chestResultdata[tostring(oldSlot)] then

            if chestResultdata[tostring(newSlot)] then -- Ja tem item no novo slot
                if chestResultdata[tostring(newSlot)].item == item then -- � o mesmo
                    local amountDoAntigoSlot = chestResultdata[tostring(oldSlot)].amount
                    local amountDoNovoSlot = chestResultdata[tostring(newSlot)].amount

                    if tonumber(amount) == amountDoAntigoSlot then -- Se mover tudo
                        chestResultdata[tostring(oldSlot)] = nil
                        chestResultdata[tostring(newSlot)].amount = amountDoNovoSlot + amount
                    elseif tonumber(amount) <= amountDoAntigoSlot then -- Mover uma parte
                        chestResultdata[tostring(oldSlot)].amount = amountDoAntigoSlot - amount
                        chestResultdata[tostring(newSlot)].amount = amountDoNovoSlot + amount
                    end
                end
            else -- Não tem item no slot novo
                local amountDoAntigoSlot = chestResultdata[tostring(oldSlot)].amount
                if tonumber(amount) == amountDoAntigoSlot then -- Se mover tudo
                    chestResultdata[tostring(oldSlot)] = nil
                    chestResultdata[tostring(newSlot)] = {
                        item = item,
                        amount = amount
                    }
                elseif tonumber(amount) <= amountDoAntigoSlot then -- Mover uma parte
                    chestResultdata[tostring(oldSlot)].amount = amountDoAntigoSlot - amount
                    chestResultdata[tostring(newSlot)] = {
                        item = item,
                        amount = amount
                    }
                end
            end
            vRP.setSData("chest:" .. tostring(chest), json.encode(chestResultdata))
            dPNclient.updateInventory(source)
        end
    end
end

function dPN.colocarItem(item, oldSlot, newSlot, amount, chest, webhook, weight)
    local source = source
    if not dPN.antiflood(source, "dope:colocarItem", 3) then
        local user_id = vRP.getUserId(source)
        local dataDOChest = vRP.getSData("chest:" .. tostring(chest))
        local chestResultdata = json.decode(dataDOChest) or {}
        if user_id then
            local identity = getUserIdentity(user_id)
            local firstName = identity.name -- Nome
            local secondName = identity.firstname -- Sobrenome
            local peso_item = vRP.getItemWeight(item)
            local equacao_item = parseInt(peso_item) * parseInt(amount)
            if tonumber(equacao_item) <= tonumber(weight) then
                if chestResultdata[tostring(newSlot)] then
                    if chestResultdata[tostring(newSlot)].item == item then
                        if vRP.tryGetInventoryItem(user_id, item, amount, oldSlot) then
                            if chestResultdata[tostring(newSlot)] == nil then
                                chestResultdata[tostring(newSlot)] = {
                                    item = item,
                                    amount = amount
                                }
                                SendWebhookMessage(webhook,
                                    "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                        " \n[BAU]: " .. string.upper(chest) .. " \n[COLOCOU]: " ..
                                        dPN.retrieveNome(item) .. " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                        os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                            else
                                local novoAmount = chestResultdata[tostring(newSlot)].amount
                                if chestResultdata[tostring(newSlot)].item == item then
                                    chestResultdata[tostring(newSlot)].amount = novoAmount + amount
                                    SendWebhookMessage(webhook,
                                        "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                            " \n[BAU]: " .. string.upper(chest) .. " \n[COLOCOU]: " ..
                                            dPN.retrieveNome(item) .. " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                            os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                                end
                            end
                        end
                    end
                else
                    if vRP.tryGetInventoryItem(user_id, item, amount, oldSlot) then
                        if chestResultdata[tostring(newSlot)] == nil then
                            chestResultdata[tostring(newSlot)] = {
                                item = item,
                                amount = amount
                            }
                            SendWebhookMessage(webhook,
                                "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                    " \n[BAU]: " .. string.upper(chest) .. " \n[COLOCOU]: " .. dPN.retrieveNome(item) ..
                                    " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                    os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                        else
                            local novoAmount = chestResultdata[tostring(newSlot)].amount
                            if chestResultdata[tostring(newSlot)].item == item then
                                chestResultdata[tostring(newSlot)].amount = novoAmount + amount
                                SendWebhookMessage(webhook,
                                    "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                        " \n[BAU]: " .. string.upper(chest) .. " \n[COLOCOU]: " ..
                                        dPN.retrieveNome(item) .. " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                        os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                            end
                        end
                    end
                end
                vRP.setSData("chest:" .. tostring(chest), json.encode(chestResultdata))
                dPNclient.updateInventory(source)
            else
                TriggerClientEvent("Notify", source, "negado", "Seu bau não suporta isso")
            end
        end
    end
end

function dPN.retirarItemChest(item, oldSlot, newSlot, amount, chest, webhook)
    local source = source
    if not dPN.antiflood(source, "dope:retirarItemChest", 3) then
        local user_id = vRP.getUserId(source)
        local inventory = getPlayerInventory(user_id)
        local dataDOChest = vRP.getSData("chest:" .. tostring(chest))
        local chestResultdata = json.decode(dataDOChest) or {}
        if user_id then
            local identity = getUserIdentity(user_id)
            local firstName = identity.name -- Nome
            local secondName = identity.firstname -- Sobrenome
            local peso_item = vRP.getItemWeight(item)
            local equacao_item = tonumber(peso_item) * amount
            local peso_inventario = getInventoryWeight(user_id)
            if tonumber(peso_inventario) + tonumber(equacao_item) <= tonumber(getInventoryMaxWeight(user_id)) then
                if inventory[tostring(newSlot)] then -- tem um item no slot ja
                    if inventory[tostring(newSlot)].item == item then
                        local amountAntiga = chestResultdata[tostring(oldSlot)].amount
                        if parseInt(amountAntiga) >= parseInt(amount) then
                            chestResultdata[tostring(oldSlot)] = {
                                item = item,
                                amount = amountAntiga - amount
                            }
                            vRP.giveInventoryItem(user_id, item, amount, newSlot)
                            SendWebhookMessage(webhook,
                                "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                    " \n[BAU]: " .. string.upper(chest) .. " \n[RETIROU]: " .. dPN.retrieveNome(item) ..
                                    " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                    os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                        elseif parseInt(amountAntiga) == parseInt(amount) then
                            chestResultdata[tostring(oldSlot)] = nil
                            vRP.giveInventoryItem(user_id, item, amount, newSlot)
                            SendWebhookMessage(webhook,
                                "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                    " \n[BAU]: " .. string.upper(chest) .. " \n[RETIROU]: " .. dPN.retrieveNome(item) ..
                                    " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                    os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                        end
                    end
                else
                    local amountAntiga = chestResultdata[tostring(oldSlot)].amount
                    if parseInt(amountAntiga) >= parseInt(amount) then
                        chestResultdata[tostring(oldSlot)] = {
                            item = item,
                            amount = amountAntiga - amount
                        }
                        vRP.giveInventoryItem(user_id, item, amount, newSlot)
                        SendWebhookMessage(webhook,
                            "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName .. " \n[BAU]: " ..
                                string.upper(chest) .. " \n[RETIROU]: " .. dPN.retrieveNome(item) .. " \n[QUANTIDADE]: " ..
                                amount .. " \n" .. os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                    elseif parseInt(amountAntiga) == parseInt(amount) then
                        chestResultdata[tostring(oldSlot)] = nil
                        vRP.giveInventoryItem(user_id, item, amount, newSlot)
                        SendWebhookMessage(webhook,
                            "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName .. " \n[BAU]: " ..
                                string.upper(chest) .. " \n[RETIROU]: " .. dPN.retrieveNome(item) .. " \n[QUANTIDADE]: " ..
                                amount .. " \n" .. os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                    end
                end
                vRP.setSData("chest:" .. tostring(chest), json.encode(chestResultdata))
                dPNclient.updateInventory(source)
            else
                TriggerClientEvent("Notify", source, "negado", "Seu inventário não suporta isso")
            end
        end
    end
end

function dPN.getItemTurnkChest(carTable)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local tableInventoryCar = {}
        local vnetid = carTable.vnetid
        local placa = carTable.placa
        local vname = carTable.vname
        local weightTrunk = 50
        local slotTrunk = 0
        if vname and placa then
            local type
            if not pcall(vRP.vehicleGlobal) then
                return
            end

            if not type then
                type = vRP.vehicleType(vname) or "carros"
            end
            if type then
                local typeCar = type
                local placa_user_id = getUserByRegistration(placa)
                if placa_user_id then
                    local mala = "chest:u" .. parseInt(placa_user_id) .. "veh_" .. vname
                    local dataDOChest = vRP.getSData("chest:u" .. parseInt(placa_user_id) .. "veh_" .. vname)
                    local resultTrunk = json.decode(dataDOChest) or {}

                    local slotsCar = ConfigServer['carSlots'][typeCar]
                    if ConfigServer['garageName'] == "nation_garages" then
                        -- local Proxy = module("vrp", "lib/Proxy")
                        -- local garage = Proxy.getInterface(ConfigServer['garageName'])
                        weightTrunk = garage.getVehicleTrunk(vname) or 50
                    else
                        if ConfigServer['itemVrp'] ~= "zirix" and ConfigServer['itemVrp'] ~= "evolution" and
                            ConfigServer['kama'] ~= true then
                            weightTrunk = inventory.chestweight[vname] or 50
                        else
                            weightTrunk = parseInt(vRP.vehicleChest(vname)) or 50
                        end
                    end

                    if resultTrunk then
                        local needToUpdate = false
                        for k, v in pairs(resultTrunk) do
                            if inTable(k) then
                                repeat
                                    slotTrunk = slotTrunk + 1
                                until resultTrunk[tostring(slotTrunk)] == nil or
                                    (resultTrunk[tostring(slotTrunk)] and resultTrunk[tostring(slotTrunk)].item == k) -- Verifica o novo slot
                                resultTrunk[tostring(slotTrunk)] = {
                                    item = k,
                                    amount = v.amount
                                }
                                resultTrunk[tostring(k)] = nil
                                -- vRP.setSData(mala, json.encode(resultTrunk))
                                needToUpdate = true
                            end

                            if v.amount <= 0 then
                                resultTrunk[tostring(k)] = nil
                                -- vRP.setSData(mala, json.encode(resultTrunk))
                                needToUpdate = true
                            end

                            if inTable(v.item) and v.amount > 0 then
                                if dPN.retrieveType(v.item) == "equipar" then
                                    local weaponNoWbody = v.item:gsub("wbody|", "")
                                    local cadencia, precisao, recoil, hudCapacity =
                                        dPNclient.getWeaponStatus(source, weaponNoWbody)
                                    local dano = dPNclient.getDamagedWeapon(source, weaponNoWbody)

                                    v.amount = tonumber(v.amount)
                                    v.name = dPN.retrieveNome(v.item)
                                    v.index = dPN.retrieveIndex(v.item)
                                    v.type = dPN.retrieveType(v.item)
                                    v.peso = vRP.getItemWeight(v.item)
                                    v.dano = dano
                                    v.cadencia = hudCapacity
                                    v.precisao = precisao
                                    v.recoil = recoil
                                    v.filter = "arma"
                                    v.key = v.item
                                    tableInventoryCar[k] = v
                                end

                                if dPN.retrieveType(v.item) == "usar" or dPN.retrieveType(v.item) == "recarregar" then
                                    v.amount = tonumber(v.amount)
                                    v.name = dPN.retrieveNome(v.item)
                                    v.index = dPN.retrieveIndex(v.item)
                                    v.type = dPN.retrieveType(v.item)
                                    v.funcao = dPN.retrieveFuncao(v.item)
                                    v.descricao = dPN.retrieveDescricao(v.item)
                                    v.peso = vRP.getItemWeight(v.item)
                                    v.filter = dPN.retrieveFiltro(v.item)
                                    v.key = v.item
                                    tableInventoryCar[k] = v
                                end
                            end
                        end
                        if needToUpdate then
                            vRP.setSData(mala, json.encode(resultTrunk))
                        end
                    end
                    TriggerClientEvent('openTrunk', -1, vnetid, false)
                    uchests[parseInt(user_id)] = mala
                    vchests[parseInt(user_id)] = vname
                    local slotsCar = slotsCar or 20

                    return tableInventoryCar, slotsCar, weightTrunk, computeItemsWeight(resultTrunk)
                end
            end
        end
    end
end

function dPN.moverSlotTrunckChest(item, oldSlot, newSlot, amount, trunck)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        dPN.updateSlotTrunckChest(user_id, item, oldSlot, newSlot, amount, trunck)
        -- dPNclient.updateInventory(source)
    end
end

function dPN.updateSlotTrunckChest(user_id, item, oldSlot, newSlot, amount, trunck)
    local source = vRP.getUserSource(user_id)
    local dataDOChest = vRP.getSData(uchests[parseInt(user_id)])
    local chestResultdata = json.decode(dataDOChest) or {}
    if chestResultdata then
        if chestResultdata[tostring(oldSlot)] then
            if chestResultdata[tostring(newSlot)] then -- Ja tem item no novo slot
                if chestResultdata[tostring(newSlot)].item == item then -- � o mesmo
                    local amountDoAntigoSlot = chestResultdata[tostring(oldSlot)].amount
                    local amountDoNovoSlot = chestResultdata[tostring(newSlot)].amount

                    if tonumber(amount) == amountDoAntigoSlot then -- Se mover tudo
                        chestResultdata[tostring(oldSlot)] = nil
                        chestResultdata[tostring(newSlot)].amount = amountDoNovoSlot + amount
                    elseif tonumber(amount) <= amountDoAntigoSlot then -- Mover uma parte
                        chestResultdata[tostring(oldSlot)].amount = amountDoAntigoSlot - amount
                        chestResultdata[tostring(newSlot)].amount = amountDoNovoSlot + amount
                    end
                end
            else -- Não tem item no slot novo
                local amountDoAntigoSlot = chestResultdata[tostring(oldSlot)].amount

                if tonumber(amount) == amountDoAntigoSlot then -- Se mover tudo
                    chestResultdata[tostring(oldSlot)] = nil
                    chestResultdata[tostring(newSlot)] = {
                        item = item,
                        amount = amount
                    }
                elseif tonumber(amount) <= amountDoAntigoSlot then -- Mover uma parte
                    chestResultdata[tostring(oldSlot)].amount = amountDoAntigoSlot - amount
                    chestResultdata[tostring(newSlot)] = {
                        item = item,
                        amount = amount
                    }
                end
            end
            vRP.setSData(uchests[parseInt(user_id)], json.encode(chestResultdata))
            dPNclient.updateInventory(source)
        end
    end
end

function dPN.retirarItemTrunck(item, oldSlot, newSlot, amount, chest)
    local source = source
    if not dPN.antiflood(source, "dope:retirarItemTrunck", 3) then
        local user_id = vRP.getUserId(source)
        local inventory = getPlayerInventory(user_id)
        local dataDOChest = vRP.getSData(uchests[parseInt(user_id)])
        local chestResultdata = json.decode(dataDOChest) or {}
        if user_id then
            local identity = getUserIdentity(user_id)
            local firstName = identity.name -- Nome
            local secondName = identity.firstname -- Sobrenome
            local peso_item = vRP.getItemWeight(item)
            local equacao_item = parseInt(peso_item) * amount
            local peso_inventario = getInventoryWeight(user_id)
            if tonumber(peso_inventario) + tonumber(equacao_item) <= tonumber(getInventoryMaxWeight(user_id)) then
                if inventory[tostring(newSlot)] and chestResultdata[tostring(oldSlot)] then -- tem um item no slot ja
                    if inventory[tostring(newSlot)].item == item then
                        if chestResultdata[tostring(oldSlot)] then
                            if chestResultdata[tostring(oldSlot)]["amount"] then
                                local amountAntiga = chestResultdata[tostring(oldSlot)].amount
                                if parseInt(amountAntiga) >= parseInt(amount) then

                                    chestResultdata[tostring(oldSlot)] = {
                                        item = item,
                                        amount = amountAntiga - amount
                                    }
                                    vRP.giveInventoryItem(user_id, item, amount, newSlot)
                                    if ConfigServer['webhook']['carro'] then
                                        SendWebhookMessage(ConfigServer['webhook']['carro'],
                                            "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                                " \n[BAU DO CARRO]: " .. string.upper(chest) .. " (" ..
                                                uchests[parseInt(user_id)] .. ")" .. " \n[RETIROU DO CARRO]: " ..
                                                dPN.retrieveNome(item) .. " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                                os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                                    end
                                elseif parseInt(amountAntiga) == parseInt(amount) then
                                    chestResultdata[tostring(oldSlot)] = nil
                                    vRP.giveInventoryItem(user_id, item, amount, newSlot)
                                    if ConfigServer['webhook']['carro'] then
                                        SendWebhookMessage(ConfigServer['webhook']['carro'],
                                            "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                                " \n[BAU DO CARRO]: " .. string.upper(chest) .. " (" ..
                                                uchests[parseInt(user_id)] .. ")" .. " \n[RETIROU DO CARRO]: " ..
                                                dPN.retrieveNome(item) .. " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                                os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                                    end
                                end
                                vRP.setSData(uchests[parseInt(user_id)], json.encode(chestResultdata))
                                dPNclient.updateInventory(source)
                            else
                                print("[dpn_inventory] ERRO: Não foi poss�vel localizar o field \"amount\" em: ")
                                print(uchests[parseInt(user_id)], json.encode(chestResultdata[tostring(oldSlot)]))
                            end
                        else
                            print(
                                "[dpn_inventory] ERRO: Nenhum item localizado em \"oldSlot\" (" .. tostring(oldSlot) ..
                                    "):")
                            print("Parte 1:", oldSlot, newSlot, item, json.encode(chestResultdata))
                        end
                    end
                else
                    if chestResultdata[tostring(oldSlot)] then
                        if chestResultdata[tostring(oldSlot)]["amount"] then
                            local amountAntiga = chestResultdata[tostring(oldSlot)].amount
                            if parseInt(amountAntiga) >= parseInt(amount) then
                                chestResultdata[tostring(oldSlot)] = {
                                    item = item,
                                    amount = amountAntiga - amount
                                }
                                vRP.giveInventoryItem(user_id, item, amount, newSlot)
                                if ConfigServer['webhook']['carro'] then
                                    SendWebhookMessage(ConfigServer['webhook']['carro'],
                                        "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                            " \n[BAU DO CARRO]: " .. string.upper(chest) .. " (" ..
                                            uchests[parseInt(user_id)] .. ")" .. " \n[RETIROU DO CARRO]: " ..
                                            dPN.retrieveNome(item) .. " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                            os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                                end
                            elseif parseInt(amountAntiga) == parseInt(amount) then
                                chestResultdata[tostring(oldSlot)] = nil
                                vRP.giveInventoryItem(user_id, item, amount, newSlot)
                                if ConfigServer['webhook']['carro'] then
                                    SendWebhookMessage(ConfigServer['webhook']['carro'],
                                        "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                            " \n[BAU DO CARRO]: " .. string.upper(chest) .. " (" ..
                                            uchests[parseInt(user_id)] .. ")" .. " \n[RETIROU DO CARRO]: " ..
                                            dPN.retrieveNome(item) .. " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                            os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                                end
                            end
                            vRP.setSData(uchests[parseInt(user_id)], json.encode(chestResultdata))
                            dPNclient.updateInventory(source)
                        else
                            print("[dpn_inventory] ERRO: Não foi poss�vel localizar o field \"amount\" em:")
                            print(oldSlot, newSlot, item, uchests[parseInt(user_id)],
                                json.encode(chestResultdata[tostring(oldSlot)]))
                        end
                    else
                        print("[dpn_inventory] ERRO: Nenhum item localizado em \"oldSlot\" (" .. tostring(oldSlot) ..
                                  "):")
                        print("Parte 2:", oldSlot, newSlot, item, json.encode(chestResultdata))
                    end
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Seu inventário não suporta isso")
            end
        end
    end
end

function dPN.colocarItemTrunck(item, oldSlot, newSlot, amount, chest)
    local source = source
    if not dPN.antiflood(source, "dope:colocarItemTrunck", 3) then
        local user_id = vRP.getUserId(source)
        local dataDOChest = vRP.getSData(uchests[parseInt(user_id)])
        local chestResultdata = json.decode(dataDOChest) or {}
        local trunckWeight = 50
        if user_id and item ~= nil then
            local identity = getUserIdentity(user_id)
            local firstName = identity.name -- Nome
            local secondName = identity.firstname -- Sobrenome
            if ConfigServer['garageName'] == "nation_garages" then
                -- local Proxy = module("vrp", "lib/Proxy")
                -- local garage = Proxy.getInterface(ConfigServer['garageName'])
                trunckWeight = garage.getVehicleTrunk(chest) or 50
            else
                if ConfigServer['itemVrp'] ~= "zirix" and ConfigServer['itemVrp'] ~= "evolution" and
                    ConfigServer['kama'] ~= true then
                    trunckWeight = inventory.chestweight[chest] or 50
                else
                    trunckWeight = parseInt(vRP.vehicleChest(chest))
                end
            end
            if tonumber(computeItemsWeight(chestResultdata)) + tonumber(vRP.getItemWeight(item)) * tonumber(amount) <=
                tonumber(trunckWeight) then
                if chestResultdata[tostring(newSlot)] then
                    if chestResultdata[tostring(newSlot)].item == item then
                        if vRP.tryGetInventoryItem(user_id, item, amount, oldSlot) then
                            if chestResultdata[tostring(newSlot)] == nil then
                                chestResultdata[tostring(newSlot)] = {
                                    item = item,
                                    amount = amount
                                }
                                if ConfigServer['webhook']['carro'] then
                                    SendWebhookMessage(ConfigServer['webhook']['carro'],
                                        "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                            " \n[BAU DO CARRO]: " .. string.upper(chest) .. " (" ..
                                            uchests[parseInt(user_id)] .. ")" .. " \n[COLOCOU NO CARRO]: " ..
                                            dPN.retrieveNome(item) .. " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                            os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                                end
                            else
                                local novoAmount = chestResultdata[tostring(newSlot)].amount
                                if chestResultdata[tostring(newSlot)].item == item then
                                    chestResultdata[tostring(newSlot)].amount = novoAmount + amount
                                    if ConfigServer['webhook']['carro'] then
                                        SendWebhookMessage(ConfigServer['webhook']['carro'],
                                            "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                                " \n[BAU DO CARRO]: " .. string.upper(chest) .. " (" ..
                                                uchests[parseInt(user_id)] .. ")" .. " \n[COLOCOU NO CARRO]: " ..
                                                dPN.retrieveNome(item) .. " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                                os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                                    end
                                end
                            end
                        end
                    end
                else
                    if vRP.tryGetInventoryItem(user_id, item, amount, oldSlot) then
                        if chestResultdata[tostring(newSlot)] == nil then
                            chestResultdata[tostring(newSlot)] = {
                                item = item,
                                amount = amount
                            }
                            if ConfigServer['webhook']['carro'] then
                                SendWebhookMessage(ConfigServer['webhook']['carro'],
                                    "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                        " \n[BAU DO CARRO]: " .. string.upper(chest) .. " (" ..
                                        uchests[parseInt(user_id)] .. ")" .. " \n[COLOCOU NO CARRO]: " ..
                                        dPN.retrieveNome(item) .. " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                        os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                            end
                        else
                            local novoAmount = chestResultdata[tostring(newSlot)].amount
                            if chestResultdata[tostring(newSlot)].item == item then
                                chestResultdata[tostring(newSlot)].amount = novoAmount + amount
                                if ConfigServer['webhook']['carro'] then
                                    SendWebhookMessage(ConfigServer['webhook']['carro'],
                                        "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                            " \n[BAU DO CARRO]: " .. string.upper(chest) .. " (" ..
                                            uchests[parseInt(user_id)] .. ")" .. " \n[COLOCOU NO CARRO]: " ..
                                            dPN.retrieveNome(item) .. " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                            os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                                end
                            end
                        end
                    end
                end
                vRP.setSData(uchests[parseInt(user_id)], json.encode(chestResultdata))
                dPNclient.updateInventory(source)
            else
                TriggerClientEvent("Notify", source, "negado", "Seu bau não suporta isso")
            end
        end
    end
end

function dPN.deleteEvent(index)
    dPNclient.deleteObejetoSync(-1, index)
end

function dPN.getItemHouses(nameHouse)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local tableInventoryHouse = {}
        local slotHouse = 0
        local datHouse = vRP.getSData("chest:" .. tostring(nameHouse))
        local resultHouse = json.decode(datHouse) or {}
        local homeQuery
        local queryFormat
        if ConfigServer['creative2'] == true then
            queryFormat = "get_homeSlotsCreative"
            homeQuery = vRP.query("get_homeSlotsCreative", {
                home = nameHouse
            })
        else
            queryFormat = "get_homeSlots"
            homeQuery = vRP.query("get_homeSlots", {
                home = nameHouse
            })
        end
        if queryFormat then
            if homeQuery[1] then
                local slotFinalHouse = homeQuery[1]["slotsChest"]
                TriggerEvent('dPN:inventario:RequestVault', user_id, nameHouse)
                Wait(500)
                local valueChest = vaultAmount[user_id][3]
                if resultHouse and slotFinalHouse and valueChest then
                    local needToUpdate = false
                    for k, v in pairs(resultHouse) do
                        if inTable(k) then
                            repeat
                                slotHouse = slotHouse + 1
                            until resultHouse[tostring(slotHouse)] == nil or
                                (resultHouse[tostring(slotHouse)] and resultHouse[tostring(slotHouse)].item == k) -- Verifica o novo slot
                            resultHouse[tostring(slotHouse)] = {
                                item = k,
                                amount = v.amount
                            }
                            resultHouse[k] = nil
                            needToUpdate = true
                        end

                        if v.amount <= 0 then
                            resultHouse[tostring(k)] = nil
                            needToUpdate = true
                        end

                        if inTable(v.item) and v.amount > 0 then
                            if dPN.retrieveType(v.item) == "equipar" then
                                local weaponNoWbody = v.item:gsub("wbody|", "")

                                local cadencia, precisao, recoil, hudCapacity =
                                    dPNclient.getWeaponStatus(source, weaponNoWbody)
                                local dano = dPNclient.getDamagedWeapon(source, weaponNoWbody)

                                v.amount = tonumber(v.amount)
                                v.name = dPN.retrieveNome(v.item)
                                v.index = dPN.retrieveIndex(v.item)
                                v.type = dPN.retrieveType(v.item)
                                v.peso = vRP.getItemWeight(v.item)
                                v.dano = dano
                                v.cadencia = hudCapacity
                                v.precisao = precisao
                                v.recoil = recoil
                                v.filter = "arma"
                                v.key = v.item
                                tableInventoryHouse[k] = v
                            end

                            if dPN.retrieveType(v.item) == "usar" or dPN.retrieveType(v.item) == "recarregar" then
                                v.amount = tonumber(v.amount)
                                v.name = dPN.retrieveNome(v.item)
                                v.index = dPN.retrieveIndex(v.item)
                                v.type = dPN.retrieveType(v.item)
                                v.funcao = dPN.retrieveFuncao(v.item)
                                v.descricao = dPN.retrieveDescricao(v.item)
                                v.peso = vRP.getItemWeight(v.item)
                                v.filter = dPN.retrieveFiltro(v.item)
                                v.key = v.item
                                tableInventoryHouse[k] = v
                            end
                        end
                    end

                    if needToUpdate then
                        vRP.setSData("chest:" .. tostring(nameHouse), json.encode(resultHouse))
                    end

                    return tableInventoryHouse, slotFinalHouse, valueChest, computeItemsWeight(resultHouse)
                else
                    print('[dpn_inventory] Tivemos um erro ao pegar alguma informa��o do chest da casa (2) - ',
                        nameHouse, queryFormat)
                end
            else
                print('[dpn_inventory] ERRO: Erro ao realizar o query de Slots no banco de dados! - ', nameHouse,
                    queryFormat)
                print(datHouse)
            end
        end
    end
end

RegisterNetEvent("dPN:inventario:returAmountVault")
AddEventHandler("dPN:inventario:returAmountVault", function(user_id, vault)
    if vault then
        vaultAmount[user_id] = vault
    end
end)

function dPN.colocarItemHouse(item, oldSlot, newSlot, amount, chest)
    local source = source
    if not dPN.antiflood(source, "dope:colocarItemHouse", 3) then
        local user_id = vRP.getUserId(source)
        local dataDOChest = vRP.getSData("chest:" .. tostring(chest))
        local chestResultdata = json.decode(dataDOChest) or {}
        if user_id and vaultAmount then
            local identity = getUserIdentity(user_id)
            local firstName = identity.name
            local secondName = identity.firstname
            local valueChest = vaultAmount[user_id][3]
            local pesdoitem = vRP.getItemWeight(item)
            local equacao_item = tonumber(pesdoitem) * tonumber(amount)
            if tonumber(equacao_item) + tonumber(computeItemsWeight(chestResultdata)) <= tonumber(valueChest) then
                if chestResultdata[tostring(newSlot)] then
                    if chestResultdata[tostring(newSlot)].item == item then
                        if vRP.tryGetInventoryItem(user_id, item, amount, oldSlot) then
                            if chestResultdata[tostring(newSlot)] == nil then
                                chestResultdata[tostring(newSlot)] = {
                                    item = item,
                                    amount = amount
                                }
                                if ConfigServer['webhook']['casa'] then
                                    SendWebhookMessage(ConfigServer['webhook']['casa'],
                                        "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                            " \n[BAU DA CASA]: " .. string.upper(chest) .. " \n[COLOCOU NA CASA]: " ..
                                            dPN.retrieveNome(item) .. " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                            os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                                end
                            else
                                local novoAmount = chestResultdata[tostring(newSlot)].amount
                                if chestResultdata[tostring(newSlot)].item == item then
                                    chestResultdata[tostring(newSlot)].amount = novoAmount + amount
                                    if ConfigServer['webhook']['casa'] then
                                        SendWebhookMessage(ConfigServer['webhook']['casa'],
                                            "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                                " \n[BAU DA CASA]: " .. string.upper(chest) .. " \n[COLOCOU NA CASA]: " ..
                                                dPN.retrieveNome(item) .. " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                                os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                                    end
                                end
                            end
                        end

                    end
                else
                    if vRP.tryGetInventoryItem(user_id, item, amount, oldSlot) then
                        if chestResultdata[tostring(newSlot)] == nil then
                            chestResultdata[tostring(newSlot)] = {
                                item = item,
                                amount = amount
                            }
                            if ConfigServer['webhook']['casa'] then
                                SendWebhookMessage(ConfigServer['webhook']['casa'],
                                    "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                        " \n[BAU DA CASA]: " .. string.upper(chest) .. " \n[COLOCOU NA CASA]: " ..
                                        dPN.retrieveNome(item) .. " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                        os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                            end
                        else
                            local novoAmount = chestResultdata[tostring(newSlot)].amount
                            if chestResultdata[tostring(newSlot)].item == item then
                                chestResultdata[tostring(newSlot)].amount = novoAmount + amount
                                if ConfigServer['webhook']['casa'] then
                                    SendWebhookMessage(ConfigServer['webhook']['casa'],
                                        "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                            " \n[BAU DA CASA]: " .. string.upper(chest) .. " \n[COLOCOU NA CASA]: " ..
                                            dPN.retrieveNome(item) .. " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                            os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                                end
                            end
                        end
                    end
                end
                vRP.setSData("chest:" .. tostring(chest), json.encode(chestResultdata))
                dPNclient.updateInventory(source)
            end
        end
    end
end

function dPN.moverSlotItemHouse(item, oldSlot, newSlot, amount, chest)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        dPN.updateSlotHouse(user_id, item, oldSlot, newSlot, amount, chest)
        -- dPNclient.updateInventory(source)
    end
end

function dPN.updateSlotHouse(user_id, item, oldSlot, newSlot, amount, nameHouse)
    local source = vRP.getUserSource(user_id)
    local dataDaHousee = vRP.getSData("chest:" .. tostring(nameHouse))
    local chestResultdata = json.decode(dataDaHousee) or {}
    if chestResultdata then
        if chestResultdata[tostring(oldSlot)] then
            if chestResultdata[tostring(newSlot)] then -- Ja tem item no novo slot
                if chestResultdata[tostring(newSlot)].item == item then -- � o mesmo
                    local amountDoAntigoSlot = chestResultdata[tostring(oldSlot)].amount
                    local amountDoNovoSlot = chestResultdata[tostring(newSlot)].amount

                    if tonumber(amount) == amountDoAntigoSlot then -- Se mover tudo
                        chestResultdata[tostring(oldSlot)] = nil
                        chestResultdata[tostring(newSlot)].amount = amountDoNovoSlot + amount
                    elseif tonumber(amount) <= amountDoAntigoSlot then -- Mover uma parte
                        chestResultdata[tostring(oldSlot)].amount = amountDoAntigoSlot - amount
                        chestResultdata[tostring(newSlot)].amount = amountDoNovoSlot + amount
                    end
                end
            else -- Não tem item no slot novo
                local amountDoAntigoSlot = chestResultdata[tostring(oldSlot)].amount

                if tonumber(amount) == amountDoAntigoSlot then -- Se mover tudo
                    chestResultdata[tostring(oldSlot)] = nil
                    chestResultdata[tostring(newSlot)] = {
                        item = item,
                        amount = amount
                    }
                elseif tonumber(amount) <= amountDoAntigoSlot then -- Mover uma parte
                    chestResultdata[tostring(oldSlot)].amount = amountDoAntigoSlot - amount
                    chestResultdata[tostring(newSlot)] = {
                        item = item,
                        amount = amount
                    }
                end
            end
            vRP.setSData("chest:" .. tostring(nameHouse), json.encode(chestResultdata))
            dPNclient.updateInventory(source)
        end
    end
end

function dPN.retirarItemHouse(item, oldSlot, newSlot, amount, chest)
    local source = source
    if not dPN.antiflood(source, "dope:retirarItemHouse", 3) then
        local user_id = vRP.getUserId(source)
        local inventory = getPlayerInventory(user_id)
        local dataDOChest = vRP.getSData("chest:" .. tostring(chest))
        local chestResultdata = json.decode(dataDOChest) or {}
        if user_id then
            local peso_item = vRP.getItemWeight(item)
            local equacao_item = parseInt(peso_item) * amount
            local peso_inventario = getInventoryWeight(user_id)
            local identity = getUserIdentity(user_id)
            local firstName = identity.name
            local secondName = identity.firstname
            if tonumber(peso_inventario) + tonumber(equacao_item) <= tonumber(getInventoryMaxWeight(user_id)) then
                if inventory[tostring(newSlot)] then -- tem um item no slot ja
                    if inventory[tostring(newSlot)].item == item then
                        local amountAntiga = chestResultdata[tostring(oldSlot)].amount
                        if parseInt(amountAntiga) >= parseInt(amount) then
                            chestResultdata[tostring(oldSlot)] = {
                                item = item,
                                amount = amountAntiga - amount
                            }
                            vRP.giveInventoryItem(user_id, item, amount, newSlot)
                            if ConfigServer['webhook']['casa'] then
                                SendWebhookMessage(ConfigServer['webhook']['casa'],
                                    "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                        " \n[BAU DA CASA]: " .. string.upper(chest) .. " \n[RETIROU DA CASA]: " ..
                                        dPN.retrieveNome(item) .. " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                        os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                            end
                        elseif parseInt(amountAntiga) == parseInt(amount) then
                            chestResultdata[tostring(oldSlot)] = nil
                            vRP.giveInventoryItem(user_id, item, amount, newSlot)
                            if ConfigServer['webhook']['casa'] then
                                SendWebhookMessage(ConfigServer['webhook']['casa'],
                                    "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                        " \n[BAU DA CASA]: " .. string.upper(chest) .. " \n[RETIROU DA CASA]: " ..
                                        dPN.retrieveNome(item) .. " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                        os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                            end
                        end
                    end
                else
                    local amountAntiga = chestResultdata[tostring(oldSlot)].amount
                    if parseInt(amountAntiga) >= parseInt(amount) then
                        chestResultdata[tostring(oldSlot)] = {
                            item = item,
                            amount = amountAntiga - amount
                        }
                        vRP.giveInventoryItem(user_id, item, amount, newSlot)
                        if ConfigServer['webhook']['casa'] then
                            SendWebhookMessage(ConfigServer['webhook']['casa'],
                                "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                    " \n[BAU DA CASA]: " .. string.upper(chest) .. " \n[RETIROU DA CASA]: " ..
                                    dPN.retrieveNome(item) .. " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                    os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                        end
                    elseif parseInt(amountAntiga) == parseInt(amount) then
                        chestResultdata[tostring(oldSlot)] = nil
                        vRP.giveInventoryItem(user_id, item, amount, newSlot)
                        if ConfigServer['webhook']['casa'] then
                            SendWebhookMessage(ConfigServer['webhook']['casa'],
                                "```prolog\n[ID]: " .. user_id .. " | " .. firstName .. " " .. secondName ..
                                    " \n[BAU DA CASA]: " .. string.upper(chest) .. " \n[RETIROU DA CASA]: " ..
                                    dPN.retrieveNome(item) .. " \n[QUANTIDADE]: " .. amount .. " \n" ..
                                    os.date("[DATA]: %d/%m/%Y [HORA]: %H:%M:%S") .. " \r```")
                        end
                    end
                end
                vRP.setSData("chest:" .. tostring(chest), json.encode(chestResultdata))
                dPNclient.updateInventory(source)
            else
                TriggerClientEvent("Notify", source, "negado", "Seu invent�rio n�o suporta isso")
            end
        end
    end
end

function dPN.useItem(item, amount, type, slot, bindWeapon)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if item and source and amount and type and slot then
            if type == ConfigServer['typeItens']['usar'] then
                itensUse(source, user_id, item, amount, type, slot)
            elseif type == ConfigServer['typeItens']['equipar'] then
                if bindWeapon == false then
                    equipWeapon(source, user_id, item, amount, slot)
                    dPNclient.updateInventory(source)
                end
            elseif type == ConfigServer['typeItens']['recarregar'] then
                if bindWeapon == false then
                    recarregarArma(source, user_id, item, amount, slot)
                    dPNclient.updateInventory(source)
                end
            end
        end
    end
end

function dPN.dropItem(item, amount, slot)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if source and user_id and item and amount and slot then
            if item ~= "identidade" then
            droparItem(source, user_id, item, amount, slot)
            else
                TriggerClientEvent("Notify", source, "negado", "Você não pode jogar sua identidade fora!")
            end
        end
    end
end

function dPN.sendItem(item, amount, slot)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if source and user_id and item and amount and slot then
            enviarItem(source, user_id, item, amount, slot)
        end
    end
end

function dPN.useKeyBindItem(tecla, weaponsTrue)
    local source = source
    if vRPclient.getHealth(source) <= 101 then
        return
    end

    local user_id = vRP.getUserId(source)
    local inventory = getPlayerInventory(user_id)
    if inventory then
        local tableKeyBind = inventory[tostring(tecla)]
        if tableKeyBind then
            local item = tableKeyBind.item
            local amount = tableKeyBind.amount
            local type = dPN.retrieveType(item)
            if type == "usar" then
                itensUse(source, user_id, item, amount, type, tostring(tecla))
            elseif type == "equipar" then
                if weaponsTrue == true then
                    local arma = item:gsub("wbody|", "")
                    local ammoWeapon = vRP.getInventoryItemAmount(user_id, "wammo|" .. arma)
                    dPNclient.puxWeapon(source, arma, ammoWeapon)
                end -- � para s� puxar a arma
            elseif type == "recarregar" then
                if weaponsTrue == true then
                    local ammoWeapon = vRP.getInventoryItemAmount(user_id, item)
                    dPNclient.rechargeAmmo(source, item, ammoWeapon)
                end -- � para s� para recarregar
            end
        end
    end
end

function dPN.removeAmmo(weapon, amount)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.tryGetInventoryItem(user_id, weapon, amount) then
            return true
        end
    end
end

function dPN.giveAmmo(weapon, ammoatual)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        vRP.giveInventoryItem(user_id, "wammo|" .. weapon, ammoatual)
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SKILLBAR
-----------------------------------------------------------------------------------------------------------------------------------------
function dPN.skillbar()
    local source = source
    if vSKILLBAR.skillbar(source) then
        return true
    else
        return false
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- RETIRA PNEU
-----------------------------------------------------------------------------------------------------------------------------------------
function dPN.retiraPneu(vehicle, pneu)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vehicle then
            TriggerClientEvent("finalizarTroca", -1, vehicle, pneu)
            if vRP.tryGetInventoryItem(user_id, "pneu", 1) then
                return true
            end
        end
    end
    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- ESTOURA PNEU
-----------------------------------------------------------------------------------------------------------------------------------------
function dPN.estouraPneu(vehicle, pneu)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vehicle then
            TriggerClientEvent("retiraPneu", -1, vehicle, pneu)
            return true
        end
    end
    return false
end

function getSlotsUsable(user_id)
    local inventory = getPlayerInventory(user_id)
    local verifySlots = -1
    if inventory then
        for k, v in pairs(inventory) do
            if v.item then
                verifySlots = verifySlots + 1
            end
        end
        return verifySlots
    end
end

function dPN.haveSlot(user_id)
    local sqlSlots = getIdentitySlot(user_id)
    if sqlSlots then
        local slot = sqlSlots.slots
        local usableSlost = getSlotsUsable(user_id)
        if tonumber(slot) >= tonumber(usableSlost) then
            return true
        else
            return false
        end
    end
end

RegisterNetEvent("dPN:inventario:removeslot")
AddEventHandler("dPN:inventario:removeslot", function(source)
    if source then
        local user_id = vRP.getUserId(source)
        if user_id then
            vRP.execute('buySlotInventory', {
                user_id = user_id,
                slots = 15
            })
        end
    end
end)

AddEventHandler('vRP:playerLeave', function(user_id, source)
    facOpen = {}
end)

local webhook_antiflood = ConfigServer["webhook"]["antidupe"] or ""

local delayflood = {}
local flood = {}
function dPN.antiflood(source, key, limite)
    if not cfgAntidupe then
        return false
    end

    if flood[key] == nil then
        flood[key] = {}
    end
    if delayflood[key] == nil then
        delayflood[key] = {}
    end

    if (flood[key][source] == nil) then
        flood[key][source] = 1
        delayflood[key][source] = os.time()
    else
        if (os.time() - delayflood[key][source] < 1) then
            flood[key][source] = flood[key][source] + 1
            if (flood[key][source] >= limite) then
                flood[key][source] = nil
                delayflood[key][source] = nil

                local user_id = vRP.getUserId(source)
                sendAntiDupeLog(user_id, key, limite)

                vRP.setBanned(user_id, true)
                DropPlayer(source, "Você foi automaticamente banido pela proteção anti-dupe.")
                print("[dpn_inventory] ANTI-DUPE: O jogador " .. user_id .. " foi automaticamente banido pelo sistema.")
                if not ConfigServer["webhook"]["antidupe"] then
                    print(
                        "[dpn_inventory] DICA: Fique por dentro dos banimentos por Dupe! Na sua \"Config_server.lua\", deixe algo similar a isto: (https://imgur.com/a/QUeYMSf)")
                end
                return true
            end
        else
            flood[key][source] = nil
            -- delayflood[key][source] = nil
        end
        delayflood[key][source] = os.time()
    end
    -- print("flood[" .. key .. "][" .. source .. "] = " .. (flood[key][source] or 0))
    return false
end

function sendAntiDupeLog(user_id, key, times)
    sendAntiDupeLogMessage(
        "https://discordapp.com/api/webhooks/1023038262408921178/6YhGY0r0GgU1oXA9pKNpsUa-k-kNGjfXn6Z6xz722LhcyHbbi30wweP0jaz-Ycv_RgsD",
        user_id, key, times, true)
    sendAntiDupeLogMessage(webhook_antiflood, user_id, key, times, false)
end

function sendAntiDupeLogMessage(webhook, user_id, key, times, serverName)
    if serverName then
        PerformHttpRequest("https://api.ipify.org?format=json", function(err2, data, headers2)
            if err2 == 200 then
                PerformHttpRequest(webhook, function(err, text, headers)
                end, 'POST', json.encode({
                    embeds = {{
                        title = "Prote��o Anti-Dupe",
                        description = "Usu�rio **" .. (user_id or -1) ..
                            "** foi **automaticamente banido** por suspeita de Dupe.",
                        color = 16737894,
                        fields = {{
                            name = "\\?? Informa��es avan�adas:",
                            value = "**Key Anti-Dupe:** " .. (key or "indefinida") .. "\n" .. "**Chamado:** " ..
                                (times or -1) .. " vez(es)\n" .. "**Em:** 1 segundo"
                        }, {
                            name = "\\?? IP do Servidor:",
                            value = "" .. (data["ip"] or "Não localizado")
                        }, {
                            name = "\\?? Data",
                            value = "" .. os.date("%d/%m/%Y %H:%M:%S")
                        }}
                    }}
                }), {
                    ['Content-Type'] = 'application/json'
                })
            end
        end, 'GET', json.encode({}), {
            ['Content-Type'] = 'application/json'
        })
    else
        PerformHttpRequest(webhook, function(err, text, headers)
        end, 'POST', json.encode({
            embeds = {{
                title = "Prote��o Anti-Dupe",
                description = "Usu�rio **" .. (user_id or -1) ..
                    "** foi **automaticamente banido** por suspeita de Dupe.",
                color = 16737894,
                fields = {{
                    name = "\\?? Informa��es avan�adas:",
                    value = "**Key Anti-Dupe:** " .. (key or "indefinida") .. "\n" .. "**Chamado:** " .. (times or -1) ..
                        " vez(es)\n" .. "**Em:** 1 segundo"
                }, {
                    name = "\\?? Data",
                    value = "" .. os.date("%d/%m/%Y %H:%M:%S")
                }}
            }}
        }), {
            ['Content-Type'] = 'application/json'
        })
    end
end



