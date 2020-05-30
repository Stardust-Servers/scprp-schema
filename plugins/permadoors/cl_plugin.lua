function ShowPermadoorMenu()
    local player = LocalPlayer()
    local lookingAt = LocalPlayer():GetEyeTrace().Entity
    if not lookingAt:IsDoor() then
        return
    end

    if lookingAt:GetNetVar("disabled") then
        return
    end

    local owner = IsValid(lookingAt:GetDTEntity(0)) and lookingAt:GetDTEntity(0) or nil

    local canSell = false
    local oldDoorType = false
    
    if owner then
        oldDoorType = true
        if owner == LocalPlayer() then
            canSell = true
        end
    end

    local pdoor = lookingAt:GetNetVar("pdoor")
    if pdoor and pdoor.owner == LocalPlayer():GetCharacter():GetID() then
        canSell = true
    end
    if (player:Team() == FACTION_STAFF) and pdoor.owned then 
        canSell = true
    
    end 
    local options = {}

    if not canSell and not oldDoorType then
        options["rent"] = function() RunConsoleCommand("ix", "DoorBuy") end
        if pdoor then
            options["permanent rent"] = function() end
        end
    end

    if canSell then
        options["sell"] = function() end
        if not oldDoorType and pdoor then
            options['add tenant'] = function() end
            options['remove tenant'] = function() end
        end
    end

    if oldDoorType then
        options['door menu'] = function() end
    end

    ix.menu.Open(options, lookingAt)
end

function OpenAddTenantMenu()
    local door = net.ReadEntity()

    local menu = DermaMenu()
    for k, v in ipairs(player.GetAll()) do
        if v ~= LocalPlayer() and v:GetCharacter() ~= nil then
            menu:AddOption(v:GetCharacter():GetName(), function()
                net.Start("permadoorAddTenant")
                net.WriteEntity(door)
                net.WriteEntity(v)
                net.SendToServer()
            end)
        end
    end
    menu:Open()
    menu:SetPos(ScrW() / 2, ScrH() / 2)
end

function OpenRemoveTenantMenu()
    local door = net.ReadEntity()
    local tenants = net.ReadTable()

    local menu = DermaMenu()
    for k, v in pairs(tenants) do
        menu:AddOption(v, function()
            net.Start("permadoorRemoveTenant")
            net.WriteEntity(door)
            net.WriteInt(k, 32)
            net.SendToServer()
        end)
    end
    menu:Open()
    menu:SetPos(ScrW() / 2, ScrH() / 2)
end

net.Receive("permadoorMenu", ShowPermadoorMenu)
net.Receive("permadoorAddTenantMenu", OpenAddTenantMenu)
net.Receive("permadoorRemoveTenantMenu", OpenRemoveTenantMenu)