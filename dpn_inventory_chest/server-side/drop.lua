function droparItem(source, user_id, item, amount, slot)
    if item then
		local identity = getUserIdentity(user_id)
        local x,y,z = vRPclient.getPosition(source)
		local webhookLink = ConfigServer['webhook'].dropar
		if parseInt(amount) > 0 and vRP.tryGetInventoryItem(user_id,item,amount,slot) then
            TriggerEvent("DropSystem:create",item,amount,x,y,z,3600)
                
            SendWebhookMessage(webhookLink,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DROPOU]: "..item.." \n[QUANTIDADE]: "..parseInt(amount).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			vRPclient._playAnim(source,true,{{"pickup_object","pickup_low"}},false)
			dPNclient.updateInventory(source)
			return true
		else
            local inv = getPlayerInventory(user_id)
			for k,v in pairs(inv) do
				if item == k then
					if vRP.tryGetInventoryItem(user_id,item,parseInt(v.amount),slot) then
                        TriggerEvent("DropSystem:create",item,parseInt(v.amount),x,y,z,3600)
                        SendWebhookMessage(webhookLink,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DROPOU]: "..item.." \n[QUANTIDADE]: "..vRP.format(parseInt(v.amount)).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
                        vRPclient._playAnim(source,true,{{"pickup_object","pickup_low"}},false)
						dPNclient.updateInventory(source)
						return true
						end
					end
				end
			end
		end
	return false
end

