function enviarItem(source, user_id, item, amount, slot)
	if item then
		local user_id = vRP.getUserId(source)
		local nplayer = vRPclient.getNearestPlayer(source,2)
		local nuser_id = vRP.getUserId(nplayer)
		local identity = getUserIdentity(user_id)
        local identitynu = getUserIdentity(nuser_id)
        local webhookLink = ConfigServer['webhook'].send
		if nuser_id and inTable(item) and item ~= "identidade" then
			if parseInt(amount) > 0 then
				if getInventoryWeight(nuser_id) + vRP.getItemWeight(item) * amount <= vRP.getInventoryMaxWeight(nuser_id) then
					if vRP.tryGetInventoryItem(user_id,item,amount,slot) then
						vRP.giveInventoryItem(nuser_id,item,amount)
						SendWebhookMessage(webhookLink,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ENVIOU]: "..vRP.format(amount).." "..item.." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						vRPclient._playAnim(source,true,{{"mp_common","givetake1_a"}},false)
						vRPclient._playAnim(nplayer,true,{{"mp_common","givetake1_a"}},false)
						dPNclient.updateInventory(source)
						dPNclient.updateInventory(nplayer)
						return true
					end
				end
				else
					local inv = getPlayerInventory(user_id)
					for k,v in pairs(inv) do
						if item == k then
							if getInventoryWeight(nuser_id) + vRP.getItemWeight(item) * parseInt(v.amount) <= vRP.getInventoryMaxWeight(nuser_id) then
								if vRP.tryGetInventoryItem(user_id,item,parseInt(v.amount),slot) then
									vRP.giveInventoryItem(nuser_id,item,parseInt(v.amount))
									vRPclient._playAnim(source,true,{{"mp_common","givetake1_a"}},false)
									TriggerClientEvent("Notify",source,"sucesso","Enviou <b>"..vRP.format(parseInt(v.amount)).."x "..vRP.itemList(item).."</b>.",8000)
									TriggerClientEvent("Notify",nplayer,"sucesso","Recebeu <b>"..vRP.format(parseInt(v.amount)).."x "..vRP.itemList(item).."</b>.",8000)
									SendWebhookMessage(webhookLink,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ENVIOU]: "..vRP.format(parseInt(v.amount)).." "..item.." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
									vRPclient._playAnim(nplayer,true,{{"mp_common","givetake1_a"}},false)
									dPNclient.updateInventory(source)
									dPNclient.updateInventory(nplayer)
									return true
								end
							end
						end
					end
				end
			end
		end
	return false
end

