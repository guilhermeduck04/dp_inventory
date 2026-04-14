local prompts = {}
local activePrompt = nil

-- API PRINCIPAL
exports('ShowPrompt', function(data)
    data.id = data.id or tostring(math.random(100000,999999))
    prompts[data.id] = data
end)

exports('HidePrompt', function(id)
    prompts[id] = nil
end)

-- LOOP DE SELEÇÃO (PRIORIDADE)
CreateThread(function()
    while true do
        local best = nil
        for _, p in pairs(prompts) do
            if not best or (p.priority or 1) > (best.priority or 1) then
                best = p
            end
        end
        activePrompt = best
        Wait(100)
    end
end)

-- LOOP DE RENDER / ANCORAGEM
CreateThread(function()
    while true do
        if activePrompt and activePrompt.coords then
            local camCoords = GetGameplayCamCoord()
            local dist = #(camCoords - activePrompt.coords)

            if dist < (activePrompt.maxDistance or 5.0) then
                local onScreen, x, y = World3dToScreen2d(
                    activePrompt.coords.x,
                    activePrompt.coords.y,
                    activePrompt.coords.z + (activePrompt.offset or 0.5)
                )

                if onScreen then
                SendNUIMessage({
                    action = "show",
                    key = activePrompt.key,
                    text = activePrompt.text,
                    type = activePrompt.type,
                    x = x,
                    y = y,
                    active = activePrompt.active ~= false
                })
                else
                    SendNUIMessage({ action = "hide" })
                end
            else
                SendNUIMessage({ action = "hide" })
            end
        else
            SendNUIMessage({ action = "hide" })
        end

        Wait(0)
    end
end)
