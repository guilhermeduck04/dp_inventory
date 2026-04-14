local Tools = module("vrp","lib/Tools")
local idgens = Tools.newIDGenerator()
local actived = {}
local bandagem = {}
local pick = {}

function recarregarArma(source,user_id,item,amount,slot)
    local uweapons = vRPclient.getWeapons(source)
    local weaponuse = string.gsub(item,"wammo|","")
    local weaponusename = "wammo|"..weaponuse
    local identity = vRP.getUserIdentity(user_id)
    if uweapons[weaponuse] then
        local itemAmount = 0
        local inventory = getPlayerInventory(user_id)
        for k,v in pairs(inventory) do
            if weaponusename == v.item then
                if v.amount > 250 then
                v.amount = 250
                end

                itemAmount = v.amount
        
			    if vRP.tryGetInventoryItem(user_id,weaponusename,parseInt(amount),slot) then
				    local weapons = {}
				    weapons[weaponuse] = { ammo = amount }
				    itemAmount = amount
                    dPNclient._giveWeapons(source,weapons,false)
                    
				    SendWebhookMessage(ConfigServer['webhook'].equip,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RECARREGOU]: "..item.." \n[MUNICAO]: "..amount.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			    end
            end
        end
    end
end

function equipWeapon(source, user_id,item,amount,slot)
    if vRP.tryGetInventoryItem(user_id,item,1,slot) then
        local weapons = {}
        local identity = getUserIdentity(user_id)
        weapons[string.gsub(item,"wbody|","")] = { ammo = 0 }
        dPNclient._giveWeapons(source,weapons,false)
        SendWebhookMessage(ConfigServer['webhook'].equip,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[EQUIPOU]: "..item.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
    end
end

function itensUse(source, user_id, item, amount, type, slot)
    if amount > 0 and not actived[user_id] and actived[user_id] == nil then
        if item == "bandagem" then
            if vRPclient.getHealth(source) > 101 and vRPclient.getHealth(source) < 250 then
                if bandagem[user_id] == 0 or not bandagem[user_id] then
                    if vRP.tryGetInventoryItem(user_id,"bandagem",1,slot) then
                        bandagem[user_id] = 120
                        actived[user_id] = true
                        dPNclient._CarregarObjeto(source,"amb@world_human_clipboard@male@idle_a","idle_c","v_ret_ta_firstaid",49,60309)
                        dPNclient.updateInventory(source)
                        TriggerClientEvent('cancelando',source,true)
                        TriggerClientEvent("progress",source,20000,"bandagem")
                        SetTimeout(20000,function()
                            actived[user_id] = nil
                            TriggerClientEvent('bandagem',source)
                            --vRPclient.setHealth(source,300)
                            TriggerClientEvent('cancelando',source,false)
                            dPNclient._DeletarObjeto(source)
                            TriggerClientEvent("Notify",source,"sucesso","Bandagem utilizada com sucesso.",8000)
                            Citizen.Wait(10000)
                            TriggerEvent('resetWarfarina')
                            TriggerEvent('resetBleeding')
                            TriggerEvent('resetDiagnostic')
                        end)
                    end
                else
                    TriggerClientEvent("Notify",source,"importante","Aguarde "..vRPclient.getTimeFunction(source,parseInt(bandagem[user_id]))..".",8000)
                end
            else
            TriggerClientEvent("Notify",source,"aviso","Você não pode utilizar de vida cheia ou nocauteado.",8000)
        end

    elseif item == "identidade" then
        local user_id = vRP.getUserId(source)
        local nplayer = vRPclient.getNearestPlayer(source,2)
        if nplayer then
            local identity = vRP.getUserIdentity(user_id)
            if identity then
                TriggerClientEvent("Notify",nplayer,"Identidade","<b>Passaporte:</b> "..user_id.."<br><b>Nome:</b> "..identity.name.." "..identity.firstname.."<br><b>Idade:</b> "..identity.age.."<br><b>RG:</b> "..identity.registration.."<br><b>Telefone:</b> "..identity.phone,20000)
            end
        else
            TriggerClientEvent("Notify",source,"aviso","Não tem ninguém por perto para você mostrar!",8000)
        end

    elseif item == "rosa" then  ------- OK ------- OK
        if vRP.getInventoryItemAmount(user_id,"rosa") then
            vRPclient._CarregarObjeto(source,"anim@heists@humane_labs@finale@keycards","ped_a_enter_loop","prop_single_rose",49,18905,0.10,0.03,0.0,-100.0,0.0,-20.0)
        end
 elseif item == "chipvip" then
            dPNclient.updateInventory(source)
            local user_id = vRP.getUserId(source)
            local identity = vRP.getUserIdentity(user_id)
            local numero = vRP.prompt(source, "Novo numero para cadastro ?", "")
            if (numero:match("%d%d%d[-]%d%d%d")) then
                if vRP.PhoneExist(numero) then
                    TriggerClientEvent("Notify",source,"negado","Telefone já registrado")
                else
                    if vRP.tryGetInventoryItem(user_id,"chipvip",1) then
                        TriggerClientEvent('Creative:Update',source,'updateMochila')
                        local idjogador = user_id
                        local nuidentity = vRP.getUserIdentity(parseInt(idjogador))
                        local oldnumero = nuidentity.phone

                        vRP.execute("vRP/update_user_identity",{
                            user_id = idjogador,
                            firstname = nuidentity.firstname,
                            name = nuidentity.name,
                            age = nuidentity.age,
                            registration = nuidentity.registration,
                            phone = numero
                        })
                        TriggerClientEvent("Notify",source,"sucesso","Seu Telefone foi alterado para <b>"..numero.." </b>reconecte-se para evitar qualquer tipo de Bug.",120000)
                    end
                end
            else
                TriggerClientEvent("Notify",source,"negado","Formato inválido.<br>Use Ex: <b>147-741</b>")
            end
        elseif item == "identidadevip" then	
			local user_id = vRP.getUserId(source)
			local identity = vRP.getUserIdentity(user_id)
				
            if vRP.tryGetInventoryItem(user_id,"identidadevip",1,slot) then
					dPNclient.updateInventory(source)
					local idjogador = user_id
					local nome = vRP.prompt(source, "Novo nome", "")
					local firstname = vRP.prompt(source, "Novo sobrenome", "")
					local idade = vRP.prompt(source, "Nova idade", "")
					local nuidentity = vRP.getUserIdentity(parseInt(idjogador))

                    if nome == "" or firstname == "" or idade == "" then
                        vRP.giveInventoryItem(user_id,"identidadevip",1)
                        TriggerClientEvent("Notify",source,"negado","Alguma informação está vazia ou errada, tente novamente!")
                        return
                    end 

					vRP.execute("vRP/update_user_identity",{
					user_id = idjogador,
					firstname = firstname,
					name = nome,
					age = idade,
					registration = nuidentity.registration,
					phone = nuidentity.phone
					})
		    end


        elseif item == "xerelto" or item == "comuadin" or item == "dorflex" or item == "cicatricure" or item == "paracetanal" then
            if vRP.tryGetInventoryItem(user_id,item,1,slot) then
                dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_cs_pills",49,28422)     
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                TriggerClientEvent("progress",source,10000,"tomando")
                SetTimeout(10000,function()
                    TriggerClientEvent('cancelando',source,false)
                    TriggerClientEvent("resetBleeding",source)
                    dPNclient.playScreenEffect(source,"DrugsTrevorClownsFight",10)
                    dPNclient.playScreenEffect(source,"MP_race_crash",10)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Remédio utilizado com sucesso",8000)
                end)
            end
       
        --------------------------------------------------------   
        -- elseif item == "mochila" then
        --     if vRP.tryGetInventoryItem(user_id,"mochila",1,slot) then
        --         dPNclient.updateInventory(source)
        --         vRP.varyExp(user_id,"physical","strength",650)
        --         TriggerClientEvent("Notify",source,"sucesso","Mochila utilizada com sucesso.",8000)
        --     end

         elseif item == "mochila" then
                local exp = vRP.getBackpack(user_id)
                if exp < 51 then
                    dPNclient.updateInventory(source)
                    if vRP.tryGetInventoryItem(user_id,item,1,true,slot) then
                        vRP.setBackpack(user_id,51)
                        vRP.varyExp(user_id,"physical","strength",650)
                        TriggerClientEvent("Notify",source,"sucesso","Mochila utilizada com sucesso.",8000)
                    end
                else
                    TriggerClientEvent("Notify",source,"aviso","Você já equipou essa mochila!",5000)
                end

        elseif item == "mochila2" then
                local exp = vRP.getBackpack(user_id)
                if exp >= 51 and exp < 75 then
                    dPNclient.updateInventory(source)
                    if vRP.tryGetInventoryItem(user_id,item,1,true,slot) then
                        vRP.setBackpack(user_id,75)
                        vRP.varyExp(user_id,"physical","strength",650)
                        TriggerClientEvent("Notify",source,"sucesso","Mochila utilizada com sucesso.",8000)
                    end
                else
                    TriggerClientEvent("Notify",source,"aviso","Você já equipou essa mochila ou não equipou um modelo anterior!",5000)
                end

        elseif item == "mochila3" then
                local exp = vRP.getBackpack(user_id)
                if exp >= 75 and exp < 90 then
                    dPNclient.updateInventory(source)
                    if vRP.tryGetInventoryItem(user_id,item,1,true,slot) then
                        vRP.setBackpack(user_id,90)
                        vRP.varyExp(user_id,"physical","strength",650)
                        TriggerClientEvent("Notify",source,"sucesso","Mochila utilizada com sucesso.",8000)
                    end
                else
                    TriggerClientEvent("Notify",source,"aviso","Você já equipou essa mochila ou não equipou um modelo anterior!",5000)
                end
        
        --------------------------------------------------------   
        elseif item == "coquetelvanilla" then
            if vRP.tryGetInventoryItem(user_id,"coquetelvanilla",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
				dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_cocktail",49,28422)

                TriggerClientEvent("progress",source,10000,"Bebendo Coquetel")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
                    TriggerClientEvent("setEnergetic",source,10,1.25)
					vRP.varyThirst(user_id,10)
                    dPNclient._DeletarObjeto(source)

                    TriggerClientEvent("Notify",source,"sucesso","Coquetel utilizada com sucesso",8000)
                end)
            end	

        elseif item == "coquetelvanilla2" then
            if vRP.tryGetInventoryItem(user_id,"coquetelvanilla2",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
				dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_daiquiri",49,28422)

                TriggerClientEvent("progress",source,10000,"Bebendo Coquetel")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
                    TriggerClientEvent("setEnergetic",source,8,1.30)
					vRP.varyThirst(user_id,20)
                    vRPclient.setArmour(source,-10)
                    dPNclient._DeletarObjeto(source)

                    TriggerClientEvent("Notify",source,"sucesso","Coquetel utilizada com sucesso",8000)
                end)
            end	

      

        elseif item == "agua" then
            if vRP.tryGetInventoryItem(user_id,"agua",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
				dPNclient._CarregarObjeto(source,"mp_player_intdrink","loop_bottle","prop_ld_flow_bottle",49,60309)
                TriggerClientEvent("progress",source,15000,"Bebendo água")
                SetTimeout(15000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.varyThirst(user_id,-33)
                    vRP.giveInventoryItem(user_id,"garrafaaguavazia",1)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Água utilizada com sucesso",8000)
                end)
            end	
--[[         elseif item == "garrafaaguavazia" then
            if vRP.tryGetInventoryItem(user_id,"garrafaaguavazia",1,slot) then
                actived[user_id] = true
                TriggerClientEvent('cancelando',source,true)
                TriggerClientEvent('watercooler:use',source)
                TriggerClientEvent("progress",source,6000,"enchendo")
                SetTimeout(6000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
                    dPNclient.updateInventory(source)
                end)
            end	 ]]
        elseif item == "cafe" then
            if vRP.tryGetInventoryItem(user_id,"cafe",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@world_human_aa_coffee@idle_a", "idle_a","p_amb_coffeecup_01",49,28422)
                TriggerClientEvent("progress",source,12000,"Bebendo café")
                SetTimeout(12000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.varyThirst(user_id,-10)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Cafe utilizada com sucesso",8000)
                end)
            end	
        elseif item == "limonada" then
            if vRP.tryGetInventoryItem(user_id,"limonada",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","ng_proc_sodacup_01b",49,28422)
                TriggerClientEvent("progress",source,12000,"bebendo")
                SetTimeout(12000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.varyThirst(user_id,-33)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Limonada utilizada com sucesso",8000)
                end)
            end	
        elseif item == "refrigerante" then
            if vRP.tryGetInventoryItem(user_id,"refrigerante",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_food_bs_juice02",49,28422)
                TriggerClientEvent("progress",source,12000,"Bebendo Refrigerante")
                SetTimeout(12000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.varyThirst(user_id,-25)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Refrigerante utilizada com sucesso",8000)
                end)
            end	

        elseif item == "cerveja" then
            if vRP.tryGetInventoryItem(user_id,"cerveja",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
                TriggerClientEvent("progress",source,12000,"Bebendo Cerveja")
                SetTimeout(12000,function()
                    actived[user_id] = nil
                    dPNclient.playScreenEffect(source,"RaceTurbo",180)
                    dPNclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
                    TriggerClientEvent('cancelando',source,false)
                    vRP.varyThirst(user_id,-12)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Cerveja utilizada com sucesso",8000)
                end)
            end
        elseif item == "tequila" then
            if vRP.tryGetInventoryItem(user_id,"tequila",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
                TriggerClientEvent("progress",source,12000,"Bebendo tequila")
                SetTimeout(12000,function()
                    actived[user_id] = nil
                    dPNclient.playScreenEffect(source,"RaceTurbo",60)
                    dPNclient.playScreenEffect(source,"DrugsTrevorClownsFight",60)
                    TriggerClientEvent('cancelando',source,false)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Tequila utilizada com sucesso",8000)
                end)
            end
        elseif item == "vodka" then
            if vRP.tryGetInventoryItem(user_id,"vodka",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
                TriggerClientEvent("progress",source,12000,"Bebendo vodka")
                SetTimeout(12000,function()
                    actived[user_id] = nil
                    dPNclient.playScreenEffect(source,"RaceTurbo",60)
                    dPNclient.playScreenEffect(source,"DrugsTrevorClownsFight",60)
                    TriggerClientEvent('cancelando',source,false)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Vodka utilizada com sucesso",8000)
                end)
            end

        elseif item == "skate" then
            if vRP.getInventoryItemAmount(user_id,"skate") >= 1 then
                TriggerClientEvent("skate",source)
         end


        

        elseif item == "whisky" then
            if vRP.tryGetInventoryItem(user_id,"whisky",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","p_whiskey_notop",49,28422)
                TriggerClientEvent("progress",source,12000,"Bebendo Whisky")
                SetTimeout(12000,function()
                    actived[user_id] = nil
                    dPNclient.playScreenEffect(source,"RaceTurbo",60)
                    dPNclient.playScreenEffect(source,"DrugsTrevorClownsFight",60)
                    TriggerClientEvent('cancelando',source,false)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Whisky utilizado com sucesso",8000)
                end)
            end
        elseif item == "conhaque" then
            if vRP.tryGetInventoryItem(user_id,"conhaque",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
                TriggerClientEvent("progress",source,12000,"Bebendo conhaque")
                SetTimeout(12000,function()
                    actived[user_id] = nil
                    dPNclient.playScreenEffect(source,"RaceTurbo",60)
                    dPNclient.playScreenEffect(source,"DrugsTrevorClownsFight",60)
                    TriggerClientEvent('cancelando',source,false)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Conhaque utilizado com sucesso",8000)
                end)
            end
        elseif item == "absinto" then
            if vRP.tryGetInventoryItem(user_id,"absinto",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
                TriggerClientEvent("progress",source,12000,"Bebendo absinto")

                SetTimeout(12000,function()
                    actived[user_id] = nil
                    dPNclient.playScreenEffect(source,"RaceTurbo",60)
                    dPNclient.playScreenEffect(source,"DrugsTrevorClownsFight",60)
                    TriggerClientEvent('cancelando',source,false)
                    dPNclient._DeletarObjeto(source)

                    TriggerClientEvent("Notify",source,"sucesso","Absinto utilizado com sucesso",8000)
                end)
            end
        --------------------------------------------------------    
        elseif item == "batatinha" then
            if vRP.tryGetInventoryItem(user_id,"batatinha",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_food_bs_chips",49,60309) 
                TriggerClientEvent("progress",source,10000,"Comendo Batatinha")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.varyHunger(user_id,-25)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Você comeu batatinha",8000)
                end)
            end	   
        elseif item == "chocolate" then
            if vRP.tryGetInventoryItem(user_id,"chocolate",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_choc_ego",49,60309)  
                TriggerClientEvent("progress",source,10000,"Comendo Chocolate")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.varyHunger(user_id,-6)
                    vRP.varyThirst(user_id,5)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Você comeu um chocolate",8000)
                end)
            end	   

        elseif item == "hotdog" then
            if vRP.tryGetInventoryItem(user_id,"hotdog",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_cs_hotdog_01",49,28422)
                TriggerClientEvent("progress",source,10000,"Comendo Hotdog")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.varyHunger(user_id,-14)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Você comeu um hotdog",8000)
                end)
            end	   
        elseif item == "rosquinha" then
            if vRP.tryGetInventoryItem(user_id,"rosquinha",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_donut_02b",49,28422)
                TriggerClientEvent("progress",source,10000,"Comendo rosquinha")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.varyHunger(user_id,-5)
                    vRP.varyThirst(user_id,3)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Você comeu uma rosquinha",8000)
                end)
            end	  
        elseif item == "salgadinho" then
            if vRP.tryGetInventoryItem(user_id,"salgadinho",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","ng_proc_food_chips01b",49,28422)
                TriggerClientEvent("progress",source,10000,"Comendo salgadinho")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.varyHunger(user_id,-5)
                    vRP.varyThirst(user_id,3)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Você comeu um salgadinho",8000)
                end)
            end	  
        elseif item == "pizza" then
            if vRP.tryGetInventoryItem(user_id,"pizza",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","bag_pizza",49,28422)
                TriggerClientEvent("progress",source,10000,"Comendo pizza..")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.varyHunger(user_id,-20)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Você comeu uma pizza",8000)
                end)
            end	   

        elseif item == "coxinha" then
            if vRP.tryGetInventoryItem(user_id,"coxinha",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","bagdad_coxinha",49,28422)
                TriggerClientEvent("progress",source,10000,"Comendo coxinha..")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.varyHunger(user_id,-10)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Você comeu uma coxinha",8000)
                end)
            end	  

        elseif item == "paodequeijo" then
            if vRP.tryGetInventoryItem(user_id,"paodequeijo",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","bagdad_paodequeijo",49,28422)
                TriggerClientEvent("progress",source,10000,"Comendo Pão de queijo..")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.varyHunger(user_id,-5)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Você comeu um pão de queijo",8000)
                end)
            end	  

        elseif item == "pastel" then
            if vRP.tryGetInventoryItem(user_id,"pastel",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","bagdad_pastel",49,28422)

                
                TriggerClientEvent("progress",source,10000,"Comendo pastel..")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.varyHunger(user_id,-15)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Você comeu um pastel",8000)
                end)
            end	  

        elseif item == "sorvete" then
            if vRP.tryGetInventoryItem(user_id,"sorvete",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"mp_player_inteat@burger","mp_player_int_eat_burger","bag_sorvete",49,60309)
                
                TriggerClientEvent("progress",source,10000,"Comendo sorvete..")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.varyHunger(user_id,-5)
                    vRP.varyThirst(user_id,3)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Você chupou um sorvete",8000)
                end)
            end	


        elseif item == "taco" then
            if vRP.tryGetInventoryItem(user_id,"taco",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_taco_01",49,28422)
                TriggerClientEvent("progress",source,10000,"Comendo taco..")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.varyHunger(user_id,-20)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Você comeu taco",8000)
                end)
            end	   
        elseif item == "xburguer" then
            if vRP.tryGetInventoryItem(user_id,"xburguer",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_cs_burger_01",49,60309)
                TriggerClientEvent("progress",source,10000,"Comendo X-Burguer..")
                SetTimeout(12000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.varyHunger(user_id,-33)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Você comeu xburguer",8000)
                end)
            end	   
        elseif item == "xtudo" then
            if vRP.tryGetInventoryItem(user_id,"xtudo",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
          --      dPNclient._CarregarObjeto(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_cs_burger_01",49,60309)
                dPNclient._CarregarObjeto(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_cs_burger_01",49,28422)

                TriggerClientEvent("progress",source,10000,"Comendo X-Tudo..")
                SetTimeout(15000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
					vRP.varyHunger(user_id,-50)
                    dPNclient._DeletarObjeto(source)
                    TriggerClientEvent("Notify",source,"sucesso","Você comeu xburguer",8000)
                end)
            end	  
        --------------------------------------------------------                              	            

        elseif item == "cigarrodemaconha" then  ------- OK ------- OK
            if vRP.getInventoryItemAmount(user_id,"isqueiro") <= 0 then
                TriggerClientEvent("Notify",source,"aviso","Você não tem um isqueiro.",5000)
                return
            end
            if vRP.tryGetInventoryItem(user_id,"cigarrodemaconha",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                vRPclient._CarregarObjeto(source,"amb@world_human_aa_smoke@male@idle_a","idle_c","prop_cs_ciggy_01",49,28422)
                TriggerClientEvent("progress",source,10000,"Fumando..")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    vRPclient._stopAnim(source,false)
                    vRPclient._DeletarObjeto(source)
                    dPNclient.playScreenEffect(source,"RaceTurbo",30)
                    dPNclient.playScreenEffect(source,"DrugsTrevorClownsFight",30)
                    TriggerClientEvent("Notify",source,"sucesso","Maconha utilizada com sucesso",8000)
                end)
            end
            
        elseif item == "cocaina" then ------- OK ------- OK
            if vRP.tryGetInventoryItem(user_id,"cocaina",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                vRPclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
                TriggerClientEvent('cancelando',source,true)
                TriggerClientEvent("progress",source,10000,"Cheirando cocaina..")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    vRPclient._stopAnim(source,false)
                    TriggerClientEvent('cancelando',source,false)

                    dPNclient.playScreenEffect(source,"RaceTurbo",60)
                    dPNclient.playScreenEffect(source,"DrugsTrevorClownsFight",60)

                    TriggerClientEvent("Notify",source,"sucesso","Cocaína utilizada com sucesso",8000)
                end)
            end

        elseif item == "metanfetamina" then  ------- OK ------- OK
            if vRP.tryGetInventoryItem(user_id,"metanfetamina",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                vRPclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
                TriggerClientEvent("progress",source,10000,"Cheirando meta")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    vRPclient._stopAnim(source,false)
                    dPNclient.playScreenEffect(source,"RaceTurbo",60)
                    dPNclient.playScreenEffect(source,"DrugsTrevorClownsFight",60)
                    TriggerClientEvent("Notify",source,"sucesso","Metanfetamina utilizada com sucesso",8000)
                end)
            end	

        elseif item == "ecstasy" then  ------- OK ------- OK
            if vRP.tryGetInventoryItem(user_id,"ecstasy",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                vRPclient._playAnim(source,true,{{"mp_player_int_uppersmoke","mp_player_int_smoke"}},true)
                TriggerClientEvent("progress",source,10000,"Tomando ecstazy..")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    vRPclient._stopAnim(source,false)
                    dPNclient.playScreenEffect(source,"RaceTurbo",60)
                    dPNclient.playScreenEffect(source,"DrugsTrevorClownsFight",60)
                    TriggerClientEvent("Notify",source,"sucesso","Ecstasy utilizado com sucesso",8000)
                end)
            end	


        elseif item == "P-WEAPON_ASSAULTRIFLE" then  ------- OK ------- OK
            if vRP.tryGetInventoryItem(user_id,"P-WEAPON_ASSAULTRIFLE",1,slot) then
                    dPNclient.updateInventory(source)
                    vRP.giveInventoryItem(user_id,"wammo|WEAPON_ASSAULTRIFLE",30)
                    TriggerClientEvent("Notify",source,"sucesso","Caixa aberta!",8000)
            end	
        elseif item == "P-WEAPON_PISTOL_MK2" then  ------- OK ------- OK
            if vRP.tryGetInventoryItem(user_id,"P-WEAPON_PISTOL_MK2",1,slot) then
                    dPNclient.updateInventory(source)
                    vRP.giveInventoryItem(user_id,"wammo|WEAPON_PISTOL_MK2",30)
                    TriggerClientEvent("Notify",source,"sucesso","Caixa aberta!",8000)
            end	
        elseif item == "P-WEAPON_ASSAULTSMG" then  ------- OK ------- OK
            if vRP.tryGetInventoryItem(user_id,"P-WEAPON_ASSAULTSMG",1,slot) then
                    dPNclient.updateInventory(source)
                    vRP.giveInventoryItem(user_id,"wammo|WEAPON_ASSAULTSMG",30)
                    TriggerClientEvent("Notify",source,"sucesso","Caixa aberta!",8000)
            end	
        elseif item == "P-WEAPON_MICROSMG" then  ------- OK ------- OK
            if vRP.tryGetInventoryItem(user_id,"P-WEAPON_MICROSMG",1,slot) then
                    dPNclient.updateInventory(source)
                    vRP.giveInventoryItem(user_id,"wammo|WEAPON_MICROSMG",30)
                    TriggerClientEvent("Notify",source,"sucesso","Caixa aberta!",8000)
            end	
        elseif item == "P-WEAPON_SMG" then  ------- OK ------- OK
            if vRP.tryGetInventoryItem(user_id,"P-WEAPON_SMG",1,slot) then
                    dPNclient.updateInventory(source)
                    vRP.giveInventoryItem(user_id,"wammo|WEAPON_SMG",30)
                    TriggerClientEvent("Notify",source,"sucesso","Caixa aberta!",8000)
            end	
        elseif item == "P-WEAPON_REVOLVER" then  ------- OK ------- OK
            if vRP.tryGetInventoryItem(user_id,"P-WEAPON_REVOLVER",1,slot) then
                    dPNclient.updateInventory(source)
                    vRP.giveInventoryItem(user_id,"wammo|WEAPON_REVOLVER",30)
                    TriggerClientEvent("Notify",source,"sucesso","Caixa aberta!",8000)
            end	
        elseif item == "P-WEAPON_GUSENBERG" then  ------- OK ------- OK
            if vRP.tryGetInventoryItem(user_id,"P-WEAPON_GUSENBERG",1,slot) then
                    dPNclient.updateInventory(source)
                    vRP.giveInventoryItem(user_id,"wammo|WEAPON_GUSENBERG",30)
                    TriggerClientEvent("Notify",source,"sucesso","Caixa aberta!",8000)
            end	
        --------------------------------------------------------
   
        elseif item == "capuz" then
            if vRP.getInventoryItemAmount(user_id,"capuz") >= 1 then
                local nplayer = vRPclient.getNearestPlayer(source,2)
                if nplayer then
                    vRPclient.setCapuz(nplayer)
                    vRP.closeMenu(nplayer)
                    TriggerClientEvent("Notify",source,"sucesso","Capuz utilizado com sucesso.",8000)
                end
            end


        elseif item == "algemas" then
            if not vRPclient.inVehicle(source) then
                local nplayer = vRPclient.getNearestPlayer(source,1)
                if nplayer then
                    if vPLAYER.getHandcuff(nplayer) then
                        vPLAYER.toggleHandcuff(nplayer)
                        vRPclient._stopAnim(nplayer,false)
                        TriggerClientEvent("vrp_sound:source",source,"uncuff",0.5)
                        TriggerClientEvent("vrp_sound:source",nplayer,"uncuff",0.5)
                        --vRPclient._playAnim(source,false,{{"mp_arresting","a_uncuff"}},false)
                    else
                        actived[user_id] = true
                       dPNclient.updateInventory(source)
                       TriggerClientEvent('cancelando',source,true)
                       SetTimeout(5000,function()
                         actived[user_id] = nil
                            vPLAYER.toggleHandcuff(nplayer)
                            TriggerClientEvent("vrp_sound:source",source,"cuff",0.5)
                            TriggerClientEvent("vrp_sound:source",nplayer,"cuff",0.5)
                            vRPclient.playAnim(nplayer,true,{{"mp_arresting","idle"}},true)
                            --vRPclient._playAnim(nplayer,false,{{"mp_arrest_paired","crook_p2_back_left"}},false)
                       end)
                    end
                else
                    TriggerClientEvent("Notify",source,"negado","Não tem ninguem perto!",8000)
                end
            else
                TriggerClientEvent("Notify",source,"negado","Não pode utilizar algemas no veiculo!",8000)
            end



        elseif item == "energetico" then
            if vRP.tryGetInventoryItem(user_id,"energetico",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                TriggerClientEvent('cancelando',source,true)
                dPNclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_energy_drink",49,28422)

                TriggerClientEvent("progress",source,15000,"bebendo")
                SetTimeout(15000,function()
                    actived[user_id] = nil
                    TriggerClientEvent('cancelando',source,false)
                    TriggerClientEvent("setEnergetic",source,10,1.10)
					vRP.varyThirst(user_id,10)
                    dPNclient._DeletarObjeto(source)

                    TriggerClientEvent("Notify",source,"sucesso","Energético utilizada com sucesso",8000)
                end)
            end	


        elseif item == "lockpick" then
            local vehicle,vnetid,placa,vname,lock,banned,trunk,model,street = vRPclient.vehList(source,7)
            local policia = vRP.getUsersByPermission("policia.permissao")
            if #policia < 2 then
                TriggerClientEvent("Notify",source,"aviso","Número insuficiente de policiais no momento para iniciar o roubo")
                return true
            end
            if vRP.hasPermission(user_id,"policia.permissao") then
                TriggerEvent("setPlateEveryone",placa)
                dPNclient.vehicleClientLock(-1,vnetid,lock)
                TriggerClientEvent("vrp_sound:source",source,'lock',0.5)
                return
            end

            local taskResult = exports['c2n_taskbar']:getTaskBar(source,"facil","Arrombar Veículo")
            if taskResult then
                if vRP.getInventoryItemAmount(user_id,"lockpick") >= 1 and vRP.tryGetInventoryItem(user_id,"lockpick",1,slot) and vehicle then
                    actived[user_id] = true

                    if vRP.hasPermission(user_id,"policia.permissao") then
                        actived[user_id] = nil
                        TriggerEvent("setPlateEveryone",placa)
                        dPNclient.vehicleClientLock(-1,vnetid,lock)
                        return
                    end

                    TriggerClientEvent('cancelando',source,true)
                    vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
                    TriggerClientEvent("progress",source,20000,"Arrombando o veiculo...")
                    SetTimeout(20000,function()
                        actived[user_id] = nil
                        TriggerClientEvent('cancelando',source,false)
                        vRPclient._stopAnim(source,false)

                        if math.random(100) >= 50 then
                            TriggerEvent("setPlateEveryone",placa)
                            dPNclient.vehicleClientLock(-1,vnetid,lock)
                            TriggerClientEvent("vrp_sound:source",source,'lock',0.5)
                            TriggerClientEvent("Notify",source,"sucesso","Você conseguiu destrancar o veículo",8000)
                        else
                            TriggerClientEvent("Notify",source,"negado","Sua Lockpick quebrou tentando roubar o veículo e as autoridades foram acionadas",8000)
                            local policia = vRP.getUsersByPermission(ConfigServer['policiaPermissao'])
                            local x,y,z = vRPclient.getPosition(source)
                            for k,v in pairs(policia) do
                                local player = vRP.getUserSource(parseInt(v))
                                if player then
                                    async(function()
                                    end)
                                end
                            end
                        end
                    end)
                end
            else
                TriggerClientEvent("Notify",source,"falhou","Você infelizmente não conseguiu usar a lockpick",8000)
            end
            
        elseif item == "repairkit" then
            
            if not vRPclient.isInVehicle(source) then
                local vehicle = vRPclient.getNearestVehicle(source,3.5)
                if vehicle then
            
                        
                        if vRP.tryGetInventoryItem(user_id,"repairkit",1,slot) then

                            local taskResult = exports['c2n_taskbar']:getTaskBar(source,"facil","Arrumar Veículo")
                            if taskResult then
                                actived[user_id] = true
                                TriggerClientEvent('cancelando',source,true)
                                vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
                                TriggerClientEvent("progress",source,10000,"Reparando veículo por completo")
                                SetTimeout(10000,function()
                                    actived[user_id] = nil
                                    TriggerClientEvent('cancelando',source,false)
                                    TriggerClientEvent('reparar',source)
                                    vRPclient._stopAnim(source,false)
                                    TriggerClientEvent("Notify",source,"sucesso","Veiculo reparado com sucesso!",7000)
                                end)
                            else
                                TriggerClientEvent("Notify",source,"falhou","Você infelizmente não conseguiu utilizar o repairkit",8000)
                            end
                        end
                   
                end
            end	


        elseif item == "militec" then
            
            if not vRPclient.isInVehicle(source) then
                local vehicle = vRPclient.getNearestVehicle(source,3.5)
                if vehicle then
                   
                        
                        if vRP.tryGetInventoryItem(user_id,"militec",1,slot) then

                            local taskResult = exports['c2n_taskbar']:getTaskBar(source,"facil","Arrumar motor")
                            if taskResult then
                                actived[user_id] = true
                                TriggerClientEvent('cancelando',source,true)
                                vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
                                TriggerClientEvent("progress",source,10000,"Reparando Moto do veículo")
                                SetTimeout(10000,function()
                                    actived[user_id] = nil
                                    TriggerClientEvent('cancelando',source,false)
                                    TriggerClientEvent("Notify",source,"sucesso","Motor reparado com sucesso!",7000)
                                    TriggerClientEvent('repararmotor',source,vehicle)
                                    vRPclient._stopAnim(source,false)
                                end)
                            else
                                TriggerClientEvent("Notify",source,"falhou","Você infelizmente não conseguiu utilizar o militec",8000)
                            end
                        end
                   
                end
            end	


                        


        elseif item == "pneu" then
            if not vRPclient.isInVehicle(source) then
                local vehicle,vehNet = vRPclient.vehList(source,3)
                if vehicle then
                  

                        if vRP.tryGetInventoryItem(user_id,item,1,slot) then

                        local taskResult = exports['c2n_taskbar']:getTaskBar(source,"facil","Arrumar pneu")
                        if taskResult then

                            actived[user_id] = true
                            TriggerClientEvent('cancelando',source,true)
                            vRPclient._CarregarObjeto(source,"anim@heists@box_carry@","idle","prop_wheel_tyre",49,28422)
                            vRPclient._playAnim(source,false,{{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"}},true)
                            TriggerClientEvent("progress",source,5000,"reparando pneus")

                            SetTimeout(5000,function()
                                actived[user_id] = nil
                                TriggerClientEvent('cancelando',source,false)
                                TriggerClientEvent("repairTires",-1,vehNet)
                                vRPclient._DeletarObjeto(source)
                                vRPclient._stopAnim(source,false)
                            end)
                        else
                            TriggerClientEvent("Notify",source,"falhou","Você infelizmente não conseguiu utilizar o pneu",8000)
                         end
                     end
                  
                end
            end	


        elseif item == "placa" then
            if vRPclient.GetVehicleSeat(source) then
                if vRP.tryGetInventoryItem(user_id,"placa",1,slot) then
                    local placa = vRP.generatePlate()
                    dPNclient.updateInventory(source)
                    TriggerClientEvent('cancelando',source,true)
                    TriggerClientEvent("vehicleanchor",source)
                    TriggerClientEvent("progress",source,59500,"clonando")
                    SetTimeout(60000,function()
                        TriggerClientEvent('cancelando',source,false)
                        TriggerClientEvent("cloneplates",source,placa)
                        TriggerClientEvent("Notify",source,"sucesso","Placa clonada com sucesso.",8000)
                    end)
                end
            end    
        elseif item == "colete1" then
            if vRP.tryGetInventoryItem(user_id,"colete1",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                vRPclient._CarregarObjeto(source,"clothingshirt","try_shirt_positive_d","prop_bodyarmour_03",49,28422)
                TriggerClientEvent('cancelando',source,true)
                TriggerClientEvent("progress",source,5000,"Equipando")
                SetTimeout(5000,function()
                    actived[user_id] = nil
                    vRPclient._stopAnim(source,false)
                    vRPclient._DeletarObjeto(source)
                    TriggerClientEvent('cancelando',source,false)
                    vRPclient.setArmour(source,25)
                    TriggerClientEvent("Notify",source,"sucesso","Colete leve equipado com sucesso",8000)
                end)
            end
        elseif item == "colete2" then
            if vRP.tryGetInventoryItem(user_id,"colete2",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                vRPclient._CarregarObjeto(source,"clothingshirt","try_shirt_positive_d","prop_bodyarmour_06",49,28422)
                TriggerClientEvent('cancelando',source,true)
                TriggerClientEvent("progress",source,8000,"Equipando")
                SetTimeout(8000,function()
                    actived[user_id] = nil
                    vRPclient._stopAnim(source,false)
                    vRPclient._DeletarObjeto(source)
                    TriggerClientEvent('cancelando',source,false)
                    vRPclient.setArmour(source,50)
                    TriggerClientEvent("Notify",source,"sucesso","Colete médio equipado com sucesso",8000)
                end)
            end
        elseif item == "colete3" then
            if vRP.tryGetInventoryItem(user_id,"colete3",1,slot) then
                actived[user_id] = true
                dPNclient.updateInventory(source)
                vRPclient._CarregarObjeto(source,"clothingshirt","try_shirt_positive_d","prop_armour_pickup",49,28422)
                TriggerClientEvent('cancelando',source,true)
                TriggerClientEvent("progress",source,10000,"Equipando")
                SetTimeout(10000,function()
                    actived[user_id] = nil
                    vRPclient._stopAnim(source,false)
                    vRPclient._DeletarObjeto(source)
                    TriggerClientEvent('cancelando',source,false)
                    vRPclient.setArmour(source,100)
                    TriggerClientEvent("Notify",source,"sucesso","Colete pesado equipado com sucesso",8000)
                end)
            end
        end
    end        
end


--[ GMOCHILA ]---------------------------------------------------------------------------------------------------------------------------

RegisterCommand('retirarmochila',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	local rtime = math.random(3,8)

	if user_id then
		if vRP.getExp(user_id,"physical","strength") == 1900 then -- 90Kg
			if vRP.getBackpack(user_id) == 100 then
				TriggerClientEvent("progress",source,10000,"guardando")
				TriggerClientEvent("Notify",source,"aviso","<b>Aguarde!</b> Você está desequipando sua mochila.",9000)
				SetTimeout(1000*rtime,function()
					vRP.varyExp(user_id,"physical","strength",-580)
					vRP.giveInventoryItem(user_id,"mochila3",1)
                    vRP.setBackpack(user_id,75)
				end)
				SetTimeout(10000,function()
					TriggerClientEvent("Notify",source,"sucesso","Você desequipou uma de suas mochilas.")
				end)
			else
				TriggerClientEvent("Notify",source,"negado","Você precisa esvaziar a mochila antes de fazer isso.")
			end
		elseif vRP.getExp(user_id,"physical","strength") == 1320 then -- 75Kg
			if vRP.getBackpack(user_id) == 75 then
				TriggerClientEvent("progress",source,10000,"guardando")
				TriggerClientEvent("Notify",source,"aviso","<b>Aguarde!</b> Você está desequipando sua mochila.",9000)
				SetTimeout(1000*rtime,function()
					vRP.varyExp(user_id,"physical","strength",-650)
                    vRP.setBackpack(user_id, 51)
					vRP.giveInventoryItem(user_id,"mochila2",1)
				end)
				SetTimeout(10000,function()
					TriggerClientEvent("Notify",source,"sucesso","Você desequipou uma de suas mochilas.")
				end)
			else
				TriggerClientEvent("Notify",source,"negado","Você precisa esvaziar a mochila antes de fazer isso.")
			end
		elseif vRP.getExp(user_id,"physical","strength") == 670 then -- 51Kg
			if vRP.getBackpack(user_id) == 51 then
				TriggerClientEvent("progress",source,10000,"guardando")
				TriggerClientEvent("Notify",source,"aviso","<b>Aguarde!</b> Você está desequipando sua mochila.",9000)
				SetTimeout(1000*rtime,function()
					vRP.varyExp(user_id,"physical","strength",-650)
                    vRP.setBackpack(user_id, 6)
					vRP.giveInventoryItem(user_id,"mochila",1)
				end)
				SetTimeout(10000,function()
					TriggerClientEvent("Notify",source,"sucesso","Você desequipou uma de suas mochilas.")
				end)
			else
				TriggerClientEvent("Notify",source,"negado","Você precisa esvaziar a mochila antes de fazer isso.")
			end
		elseif vRP.getExp(user_id,"physical","strength") == 20 then -- 6Kg
			TriggerClientEvent("Notify",source,"negado","Você não tem mochilas equipadas.")
		end
	end
end)