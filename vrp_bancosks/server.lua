local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

tcRP = {}
Tunnel.bindInterface("vrp_bancosks",tcRP)
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_bancosks")
isTransfer = false





local cfg = module("vrp","cfg/groups")
local groups = cfg.groups

function tcRP.getUserGroupByType(user_id,gtype)
  local user_groups = vRP.getUserGroups(user_id)
  for k,v in pairs(user_groups) do
      local kgroup = groups[k]
      if kgroup then
          if kgroup._config and kgroup._config.gtype and kgroup._config.gtype == gtype then
              return kgroup._config.title
          end
      end
  end
  return ""
end

--  vRP._prepare("sRP/banco",[[
--   CREATE TABLE IF NOT EXISTS vrp_banco(
--     id INTEGER AUTO_INCREMENT,
--     user_id INTEGER,
--     extrato VARCHAR(255),
--     data VARCHAR(255),
--     CONSTRAINT pk_banco PRIMARY KEY(id)
--   )
-- ]]) 

vRP._prepare("sRP/inserir_table","INSERT INTO vrp_banco(user_id, extrato, data) VALUES(@user_id, @extrato, DATE_FORMAT(CURDATE(), '%d/%m/%Y') )")
vRP._prepare("sRP/get_banco_id","SELECT * FROM vrp_banco WHERE user_id = @user_id")
vRP._prepare("sRP/get_dinheiro","SELECT bank FROM vrp_user_moneys WHERE user_id = @user_id")
vRP._prepare("sRP/set_banco","UPDATE vrp_user_moneys SET bank = @bank WHERE user_id = @user_id")

-- async(function()
--   vRP.execute("sRP/banco")
-- end)

RegisterServerEvent('get:banco')
AddEventHandler('get:banco', function()
    local banco = {}
    local source = source
    local user_id = vRP.getUserId(source)
    local ban = vRP.query("sRP/get_banco_id", {user_id = user_id})
    for i=1, #ban, 1 do
      table.insert(banco, {
        extrato = ban[i].extrato,
        data = ban[i].data
      })
    end
    TriggerClientEvent('send:banco', source, banco)
end)

AddEventHandler("vRPclient:playerSpawned",function(user_id,source) 
    local bankbalance = vRP.getBankMoney(user_id)
    local debitmultas = vRP.query("SkS/selectMultas",{ user_id = user_id })
    local multasbalance = debitmultas[1].multas or 0
    local walletbalance = vRP.getBank(user_id)
    TriggerClientEvent('banking:updateBalance', source, bankbalance, multasbalance, walletbalance)
end)

RegisterServerEvent('playerSpawned')
AddEventHandler('playerSpawned', function()
  local user_id = vRP.getUserId(source)
  local bankbalance = vRP.getBankMoney(user_id)
  local walletbalance = vRP.getBank(user_id)
  local debitmultas = vRP.query("SkS/selectMultas",{ user_id = user_id })
  local multasbalance = debitmultas[1].multas or 0
  TriggerClientEvent('banking:updateBalance', source, bankbalance, multasbalance, walletbalance)
end)

function bankBalance(user_id)
  return vRP.getBankMoney(user_id)
end

function multasBalance(user_id)
  local debitmultas = vRP.query("SkS/selectMultas",{ user_id = user_id })
  return debitmultas[1].multas or 0
end

function walletbalance(user_id)
  return vRP.getMoney(user_id)
end

function Depositar(user_id, amount)
  local bankbalance = vRP.getBankMoney(user_id)
  local new_balance = bankbalance + math.abs(amount)
  TriggerClientEvent("banking:updateBalance", source, new_balance)
  vRP.tryDeposit(user_id,math.floor(math.abs(amount)))
end

function round(num, numDecimalPlaces)
  local mult = 5^(numDecimalPlaces or 0)
  if num and type(num) == "number" then
    return math.floor(num * mult + 0.5) / mult
  end
end

function addComma(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

RegisterServerEvent('bank:update')
AddEventHandler('bank:update', function()
  local source = source
  local user_id = vRP.getUserId(source)
  local bankbalance = vRP.getBankMoney(user_id)
  local identity = vRP.getUserIdentity(user_id)
  local debitmultas = vRP.query("SkS/selectMultas",{ user_id = user_id })
  local multasbalance = debitmultas[1].multas or 0
  local walletbalance = vRP.getMoney(user_id)
  local emprego = tcRP.getUserGroupByType(user_id,"job")
  TriggerClientEvent("banking:updateBalance", source, bankbalance, walletbalance, multasbalance, identity.name.." "..identity.firstname, emprego) 
end)

RegisterCommand('multas',function(source)
	local user_id = vRP.getUserId(source)
	local consult = vRP.query("SkS/selectMultas",{ user_id = user_id })

  if consult[1].multas == 0 then
    TriggerClientEvent("Notify",source,"AVISO","Você não possui multas!")
  else
	  TriggerClientEvent("Notify",source,"AVISO","Você possui: R$"..consult[1].multas.." em multas.")
  end
end)







RegisterServerEvent('bank:pagarmulta')
AddEventHandler('bank:pagarmulta', function(amount)
  local source = source
  local user_id = vRP.getUserId(source)
 -- local valor = vRP.getUData(user_id,"vRP:multas")
 local debitmultas = vRP.query("SkS/selectMultas",{ user_id = user_id })
 local valor = debitmultas[1].multas
  local int = parseInt(valor)
  if amount < 500 then TriggerClientEvent("Notify", source, "aviso","Você só pode pagar multas acima de <b>R$500</b> reais") return end
  local rounded = math.ceil(amount)
  local novamulta = int - rounded

  if novamulta >= 0 then
   if vRP.tryFullPayment(user_id,rounded) then
   -- vRP.setUData(user_id,"vRP:multas",json.encode(novamulta))

    vRP.execute("SkS/multarSKS",{ user_id = user_id, multas = novamulta}) 

    local newvalor = vRP.getUData(user_id,"vRP:multas")
    local bank = vRP.getBankMoney(user_id)
    local wallet = vRP.getMoney(user_id)
    TriggerClientEvent("banking:updateBalance", source, bank, wallet,novamulta)
    TriggerClientEvent("banking:removeMulta", source, rounded)

    vRP.execute("sRP/inserir_table", {user_id = user_id, extrato = "Você pagou <strong>$"..addComma(math.floor(rounded)).."</strong> em multas, restando <strong>$"..addComma(math.floor(novamulta)).."</strong> de multas pendentes e seu novo saldo ficou em <strong>$"..addComma(math.floor(bank)).."</strong> e o valor na carteira é de <strong>$"..wallet.."</strong>"})
    TriggerClientEvent("Notify", source, "financeiro","Voce pagou <b>R$"..rounded.." em multas, ainda faltam <b>R$"..novamulta.." reais")

    else
      TriggerClientEvent("Notify", source, "negado","<b>Dinheiro Insuficiente </b>")
    end
  else
    TriggerClientEvent("Notify", source, "negado","<b>Você não tem tudo isso de multa, confira o valor! </b>")
  end
end)


RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
  local source = source
  local user_id = vRP.getUserId(source)
  if user_id then
    if amount and type(amount) == "number" then
      local rounded = math.ceil(amount)
      if (rounded > 0) then
        local wallet = vRP.getMoney(user_id)
        local bankbalance = vRP.getBankMoney(user_id)
        if (rounded <= wallet) then
          local new_balance = bankbalance + math.abs(rounded)
          
          Depositar(user_id, rounded)
          local carteira = vRP.getMoney(user_id)
          TriggerClientEvent("banking:updateBalance", source, new_balance,carteira)
          TriggerClientEvent("banking:addBalance", source, rounded)
          vRP.execute("sRP/inserir_table", {user_id = user_id, extrato = "Você depositou <strong>$"..addComma(math.floor(rounded)).."</strong>, seu saldo ficou em <strong>$"..addComma(math.floor(bankbalance + rounded)).."</strong> e seu novo valor na carteira é de <strong>$"..carteira.."</strong"})
          TriggerClientEvent("Notify", source, "financeiro","Você acabou de depositar <b>R$" ..addComma(amount).."</b>")
        else
          TriggerClientEvent("Notify", source, "negado","<b>Dinheiro Insuficiente </b>")
        end
      end
    end
  end
end)

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
  local source = source
  local user_id = vRP.getUserId(source)
  if user_id then
    if amount and type(amount) == "number" then
      local rounded = math.ceil(amount)
      local bankbalance = vRP.getBankMoney(user_id)
      if (rounded <= bankbalance) then
        -- Saca o Dinheiro
        local new_balance = bankbalance - math.abs(rounded)

        vRP.tryWithdraw(user_id,rounded)
        local carteira = vRP.getMoney(user_id)
        vRP.execute("sRP/inserir_table", {user_id = user_id, extrato = "Você fez um saque de <strong>$"..addComma(math.floor(rounded)).."</strong>, seu saldo ficou em <strong>$" .. addComma(math.floor(bankbalance - rounded)) .. "</strong>e seu novo valor na carteira é de <strong>$"..carteira.."</strong"})
        -- Update NUI
        TriggerClientEvent("banking:updateBalance", source, new_balance, carteira)
        TriggerClientEvent("banking:removeBalance", source, rounded)
        -- Salva o extrato
        TriggerClientEvent("Notify", source, "financeiro","Você acabou de sacar <b>$" ..rounded.."</b>")
      else
        TriggerClientEvent("Notify", source, "negado","<b>Dinheiro Insuficiente </b>")
      end

    end
  end
end)

RegisterServerEvent('bank:quickdeposit0')
AddEventHandler('bank:quickdeposit0', function()
  local source = source
  local user_id = vRP.getUserId(source)
  local source = vRP.getUserSource(user_id)
  local bankbalance = vRP.getBankMoney(user_id)
  local carteira2 = vRP.getMoney(user_id)
  local quantia = 100
  if (carteira2 >= quantia) then
    vRP.tryDeposit(user_id,quantia)
    local new_balance = bankbalance + math.abs(quantia)
    local carteira = vRP.getMoney(user_id)
    TriggerClientEvent("banking:updateBalance", source, new_balance,carteira)
    TriggerClientEvent("Notify", source, "financeiro","Você acabou de Depositar <b>$100,00!</b>")
    vRP.execute("sRP/inserir_table", {user_id = user_id, extrato = "Você fez um deposito rapído de <strong>$" .. "100,00" .. "</strong>, seu saldo ficou em <strong>$" .. addComma(bankbalance + 100) .. "</strong> e seu novo valor na carteira é de <strong>$"..carteira.."</strong"})
  else
    TriggerClientEvent("Notify", source, "negado","<b>Dinheiro Insuficiente </b>")
  end
end)

RegisterServerEvent('bank:quickdeposit')
AddEventHandler('bank:quickdeposit', function()
  local source = source
  local user_id = vRP.getUserId(source)
  local source = vRP.getUserSource(user_id)
  local bankbalance = vRP.getBankMoney(user_id)
  local carteira2 = vRP.getMoney(user_id)
  local quantia = 1000
  if (carteira2 >= quantia) then
    vRP.tryDeposit(user_id,quantia)
    local new_balance = bankbalance + math.abs(quantia)
    local carteira = vRP.getMoney(user_id)
    TriggerClientEvent("banking:updateBalance", source, new_balance,carteira)
    TriggerClientEvent("Notify", source, "financeiro","Você acabou de Depositar <b>$1.000,00!</b>")
    vRP.execute("sRP/inserir_table", {user_id = user_id, extrato = "Você fez um deposito rapído de <strong>$" .. "1.000,00" .. "</strong>, seu saldo ficou em <strong>$" .. addComma(bankbalance + 1000) .. "</strong> e seu novo valor na carteira é de <strong>$"..carteira.."</strong"})
  else
    TriggerClientEvent("Notify", source, "negado","<b>Dinheiro Insuficiente </b>")
  end
end)

RegisterServerEvent('bank:quickdeposit2')
AddEventHandler('bank:quickdeposit2', function()
  local source = source
  local user_id = vRP.getUserId(source)
  local source = vRP.getUserSource(user_id)
  local bankbalance = vRP.getBankMoney(user_id)
  local carteira2 = vRP.getMoney(user_id)
  local quantia = 10000
  if (carteira2 >= quantia) then
    vRP.tryDeposit(user_id,quantia)
    local new_balance = bankbalance + math.abs(quantia)
    local carteira = vRP.getMoney(user_id)
    TriggerClientEvent("banking:updateBalance", source, new_balance,carteira)
    TriggerClientEvent("Notify", source, "financeiro","Você acabou de Depositar <b>$10.000,00!</b>")
    vRP.execute("sRP/inserir_table", {user_id = user_id, extrato = "Você fez um deposito rapído de <strong>$" .. "10.000,00" .. "</strong>, seu saldo ficou em <strong>$" .. addComma(bankbalance + 10000) .. "</strong> e seu novo valor na carteira é de <strong>$"..carteira.."</strong"})
  else
    TriggerClientEvent("Notify", source, "negado","<b>Dinheiro Insuficiente </b>")
  end
end)

RegisterServerEvent('bank:quickdeposit3')
AddEventHandler('bank:quickdeposit3', function()
  local source = source
  local user_id = vRP.getUserId(source)
  local source = vRP.getUserSource(user_id)
  local bankbalance = vRP.getBankMoney(user_id)
  local carteira2 = vRP.getMoney(user_id)
  local quantia = 100000
  if (carteira2 >= quantia) then
    vRP.tryDeposit(user_id,quantia)
    local new_balance = bankbalance + math.abs(quantia)
    local carteira = vRP.getMoney(user_id)
    TriggerClientEvent("banking:updateBalance", source, new_balance,carteira)
    TriggerClientEvent("Notify", source, "financeiro","Você acabou de Depositar <b>$100.000,00!</b>")
    vRP.execute("sRP/inserir_table", {user_id = user_id, extrato = "Você fez um deposito rapído de <strong>$" .. "100.000,00" .. "</strong>, seu saldo ficou em <strong>$" .. addComma(bankbalance + 100000) .. "</strong> e seu novo valor na carteira é de <strong>$"..carteira.."</strong"})
  else
    TriggerClientEvent("Notify", source, "negado","<b>Dinheiro Insuficiente </b>")
  end
end)

RegisterServerEvent('bank:quickCash0')
AddEventHandler('bank:quickCash0', function()
  local source = source
  local user_id = vRP.getUserId(source)
  local source = vRP.getUserSource(user_id)
  local bankbalance = vRP.getBankMoney(user_id)
  local quantia = 100
  if (bankbalance >= quantia) then
    local new_balance = bankbalance - math.abs(quantia)
    vRP.tryWithdraw(user_id,quantia)
    local carteira = vRP.getMoney(user_id)
    TriggerClientEvent("banking:updateBalance", source, new_balance,carteira)
    TriggerClientEvent("banking:removeBalance", source, quantia)
    TriggerClientEvent("Notify", source, "financeiro","Você acabou de sacar <b>$100!</b>")
    vRP.execute("sRP/inserir_table", {user_id = user_id, extrato = "Você fez um saque rapído de <strong>$" .. "100" .. "</strong>, seu saldo ficou em <strong>$" .. addComma(bankbalance - 100) .. "</strong> e seu novo valor na carteira é de <strong>$"..carteira.."</strong"})
  else
    TriggerClientEvent("Notify", source, "negado","<b>Dinheiro Insuficiente </b>")
  end
end)

RegisterServerEvent('bank:quickCash')
AddEventHandler('bank:quickCash', function()
  local source = source
  local user_id = vRP.getUserId(source)
  local source = vRP.getUserSource(user_id)
  local bankbalance = vRP.getBankMoney(user_id)
  local quantia = 500
  if (bankbalance >= quantia) then
    local new_balance = bankbalance - math.abs(quantia)
    vRP.tryWithdraw(user_id,quantia)
    local carteira = vRP.getMoney(user_id)
    TriggerClientEvent("banking:updateBalance", source, new_balance,carteira)
    TriggerClientEvent("banking:removeBalance", source, quantia)
    TriggerClientEvent("Notify", source, "financeiro","Você acabou de sacar <b>$500!</b>")
    vRP.execute("sRP/inserir_table", {user_id = user_id, extrato = "Você fez um saque rapído de <strong>$" .. "500" .. "</strong>, seu saldo ficou em <strong>$" .. addComma(bankbalance - 500) .. "</strong> e seu novo valor na carteira é de <strong>$"..carteira.."</strong"})
  else
    TriggerClientEvent("Notify", source, "negado","<b>Dinheiro Insuficiente </b>")
  end
end)

RegisterServerEvent('bank:quickCash2')
AddEventHandler('bank:quickCash2', function()
  local source = source
  local user_id = vRP.getUserId(source)
  local source = vRP.getUserSource(user_id)
  local bankbalance = vRP.getBankMoney(user_id)
  local quantia = 1000
  if (bankbalance >= quantia) then
    local new_balance = bankbalance - math.abs(quantia)
    vRP.tryWithdraw(user_id,quantia)
    local carteira = vRP.getMoney(user_id)
    TriggerClientEvent("banking:updateBalance", source, new_balance,carteira)
    TriggerClientEvent("banking:removeBalance", source, quantia)
    TriggerClientEvent("Notify", source, "financeiro","Você acabou de sacar <b>$1000!</b>")
    vRP.execute("sRP/inserir_table", {user_id = user_id, extrato = "Você fez um saque rapído de <strong>$" .. "1.000" .. "</strong>, seu saldo ficou em <strong>$" .. addComma(bankbalance - 1000) .. "</strong> e seu novo valor na carteira é de <strong>$"..carteira.."</strong"})
  else
    TriggerClientEvent("Notify", source, "negado","<b>Dinheiro Insuficiente </b>")
  end
end)

RegisterServerEvent('bank:quickCash3')
AddEventHandler('bank:quickCash3', function()
  local source = source
  local user_id = vRP.getUserId(source)
  local source = vRP.getUserSource(user_id)
  local bankbalance = vRP.getBankMoney(user_id)
  local quantia = 5000
  if (bankbalance >= quantia) then
    local new_balance = bankbalance - math.abs(quantia)
    vRP.tryWithdraw(user_id,quantia)
    local carteira = vRP.getMoney(user_id)
    TriggerClientEvent("banking:updateBalance", source, new_balance,carteira)
    TriggerClientEvent("banking:removeBalance", source, quantia)
    TriggerClientEvent("Notify", source, "financeiro","Você acabou de sacar <b>$5000!</b>")
    vRP.execute("sRP/inserir_table", {user_id = user_id, extrato = "Você fez um saque rapído de <strong>$" .. "5.000" .. "</strong>, seu saldo ficou em <strong>$" .. addComma(bankbalance - 5000) .. "</strong> e seu novo valor na carteira é de <strong>$"..carteira.."</strong"})
  else
    TriggerClientEvent("Notify", source, "negado","<b>Dinheiro Insuficiente </b>")
  end
end)

RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(toPlayer, amount)
  local source = source
  local user_id = vRP.getUserId(source)
  local nuser_id = tonumber(toPlayer)
  if user_id ~= nuser_id then
    if amount and type(amount) == "number" then
      local rounded = math.ceil(amount)
      if (rounded > 0) then
        local bankbalance = vRP.getBankMoney(user_id)
        if (rounded <= bankbalance) then
          local aleatorio = math.random(10000, 99999)
          -- user_id
          local newBalance = bankbalance - math.abs(rounded)
          -- nuser_id
          local player = vRP.getUserSource(nuser_id)
          local bank = vRP.getBankMoney(nuser_id)
          local newBalance_Player = bank + math.abs(amount)
          if player then -- Está online
            vRP.setBankMoney(user_id, newBalance)
            vRP.setBankMoney(nuser_id, newBalance_Player)

            -- Seta o dinheiro pro player
            TriggerClientEvent("banking:updateBalance", player, newBalance_Player)
            TriggerClientEvent("banking:addBalance", player, rounded)
          else
            local bank = vRP.scalar('sRP/get_dinheiro', {user_id = nuser_id})
            vRP.setBankMoney(user_id, newBalance)
            vRP.execute('sRP/set_banco', {user_id = nuser_id, bank = bank + tonumber(amount) })
          end
          -- Remove o dinheiro do player que enviou
          local carteira = vRP.getMoney(user_id)
          TriggerClientEvent("banking:updateBalance", source, newBalance, carteira)
          TriggerClientEvent("banking:removeBalance", source, rounded)
          -- Extrato
          vRP.execute("sRP/inserir_table", {user_id = user_id, extrato = "Você Transferiu <strong>$"..addComma(math.floor(rounded)).."</strong> para o ID: "..toPlayer..", seu saldo ficou em <strong>$"..addComma(math.floor(bankbalance - rounded)).."</strong> comprovante <strong>NL"..aleatorio.."</strong> e seu novo valor na carteira é de <strong>$"..carteira.."</strong"})
          TriggerClientEvent("Notify", source, "financeiro","Você transferiu <b>$"..rounded.."</b> para o <b>ID: "..nuser_id.."</b>")
        else
          TriggerClientEvent("Notify", source, "negado","<b>Dinheiro Insuficiente </b>")
        end
      else
        TriggerClientEvent("Notify", source, "negado","<b>Você não pode transferir esse valor!</b>")
      end
    end
  else
    TriggerClientEvent("Notify", source, "aviso","<b>Impossivel transferir para você mesmo!</b>")
  end
end)


function tcRP.MarcarOcorrencia()
	local source = source
	local user_id = vRP.getUserId(source)
	local x,y,z = vRPclient.getPosition(source)
	if user_id then
		TriggerClientEvent("Notify",source,"alerta","O vizinho viu sua negociação, a policia foi acionada.")
		local soldado = vRP.getUsersByPermission("Policia")
		for l,w in pairs(soldado) do
			local player = vRP.getUserSource(parseInt(w))
			if player then
				async(function()
					TriggerClientEvent("NotifyPush",player,{ code = 31, title = "Crime em progresso", x = x, y = y, z = z, badge = "Roubo de 232veículo", "teste" })
				end)
			end
		end
	end
end


function tcRP.debitCard()
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.computeInvWeight(user_id) + vRP.itemWeightList("cartaodebito") * 1 <= vRP.getBackpack(user_id) then
		if vRP.getInventoryItemAmount(user_id,"cartaodebito") > 0 then
			TriggerClientEvent("Notify",source,"negado","Você já possui um cartão de débito em sua mochila.")
		else
			local bank = vRP.getBankMoney(user_id)
			local custo = 2500
			if bank >= custo then
				vRP.setBankMoney(user_id,bank-custo)
				vRP.giveInventoryItem(user_id,"cartaodebito",1)
				TriggerClientEvent("Notify",source,"sucesso","Sucesso, você adquiriu o seu cartão de débito <br>por <b>R$"..custo.." reais</b>.")
			else
				TriggerClientEvent("Notify",source,"negado","Saldo insuficiente para contratar o seu cartão de débito.")
			end
		end
	else
		TriggerClientEvent("Notify",source,"negado","Sua mochila está cheia.")
	end
end
