local PLUGIN = PLUGIN
PLUGIN.name = "Admin Utilities"
PLUGIN.description = "Various utilities for administrators."

local hideWeaponList = {
    "weapon_physgun",
    "gmod_tool"
}

function PLUGIN:PlayerConnect(name, ip)
    ix.log.AddRaw("[PLAYER CONNECTED] [" .. name .. "] " .. ip)
end

function PLUGIN:PlayerDisconnected(ply)
    ix.log.AddRaw("[PLAYER DISCONNECTED] [" .. ply:GetName() .. "] " .. ply:IPAddress())
end

local function ShouldHideWeapon(wep)
    if !IsValid(wep) then return false end
    if !wep.Owner:IsAdmin() then return false end
    --if wep.Owner:IsCombine() then return false end

    for _, name in pairs(hideWeaponList) do
        if wep:GetClass() == name then
            return true
        end
    end
    return false
end

function PLUGIN:PrePlayerDraw(player)
    if not IsValid(player:GetActiveWeapon()) then return end

    if (ShouldHideWeapon(player:GetActiveWeapon())) then
        player:GetActiveWeapon():SetNoDraw(true)
    end
end

function PLUGIN:UpdateAnimation(ply)
    --if LocalPlayer() == ply and ply:Name() == "Anne Kryukov" then
    --    print(ply:GetSequenceName(ply:GetSequence()))
    --end
    if (ShouldHideWeapon(ply:GetActiveWeapon())) then
        if !ply:IsOnGround() then
            ply:SetSequence(ply:LookupSequence("jump_fist"))
        elseif ply:GetVelocity():Length() >= 135 then
            ply:SetSequence(ply:LookupSequence("run_all_01"))
        elseif ply:Crouching() then
            ply:SetSequence(ply:LookupSequence("cwalk_all"))
        else
            ply:SetSequence(ply:LookupSequence(ply:GetVelocity():Length() == 0 and "idle_all_01" or "walk_all"))
        end
    end
end

function PLUGIN:DrawPhysgunBeam(ply)
    return ply == LocalPlayer()
end

function PLUGIN:GetVoidIndicatorPosition(client)
    local head

    for i = 1, client:GetBoneCount() do
        local name = client:GetBoneName(i)

        if (string.find(name:lower(), "head")) then
            head = i
            break
        end
    end

    local position = head and client:GetBonePosition(head) or (client:Crouching() and crouchingOffset or standingOffset)
    return (position or (client:GetPos() + Vector(0, 0, 0, 64))) + Vector(0, 0, 22)
end

function PLUGIN:PostPlayerDraw(client)
    if (client == LocalPlayer()) then
        return
    end

    if (client:Team() != FACTION_STAFF) then return end

    local distance = client:GetPos():DistToSqr(LocalPlayer():GetPos())
    local moveType = client:GetMoveType()

    --[[if (!IsValid(client) or !client:Alive() or
        (moveType == MOVETYPE_NOCLIP) or
        distance >= 400) then
            print("wtf")
        return
    end]]

    local angle = EyeAngles()
    angle:RotateAroundAxis(angle:Forward(), 90)
    angle:RotateAroundAxis(angle:Right(), 90)

    cam.Start3D2D(self:GetVoidIndicatorPosition(client), Angle(0, angle.y, 90), 0.05)
        surface.SetFont("ixTypingIndicator")
        draw.SimpleTextOutlined("VOID", "ixTypingIndicator", 0,
            10,
            ColorAlpha(Color(255, 255, 255), 255),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER, 4,
            ColorAlpha(Color(255, 255, 255), 255)
        )
    cam.End3D2D()
end

ix.command.Add("ForceFallOver", {
    description = "Force a character to fall over.",
    adminOnly = true,
    arguments = {
        ix.type.character,
        bit.bor(ix.type.number, ix.type.optional)
    },
    OnRun = function(self, client, target, time)
        if (time and time > 0) then
            time = math.Clamp(time, 1, 60)
        end

        if (!IsValid(target.ixRagdoll)) then
			target:GetPlayer():SetRagdolled(true, time)
		end
    end
})

ix.command.Add("ForceGetUp", {
    description = "Force a character to get up",
    adminOnly = true,
    arguments = {
        ix.type.character
    },
    OnRun = function(self, client, target)
        target:GetPlayer():SetRagdolled(false)
    end
})

PLUGIN.tempFlags = PLUGIN.tempFlags or {}

function PLUGIN:CharacterHasFlags(character, flags)
    local tempFlags = PLUGIN.tempFlags[character:GetID()]
    if not tempFlags then return end
    
    local hasFlagCount = 0
    for i = 1, #flags do
        local checkFlag = flags:sub(i, i)
        if string.find(tempFlags, checkFlag) then
            hasFlagCount = hasFlagCount + 1
        end
    end

    return hasFlagCount == #flags
end

ix.command.Add("CharTempFlags", {
    description = "Give a player temporary flags",
    adminOnly = true,
    arguments = {
        ix.type.character,
        ix.type.string,
        ix.type.number
    },
    OnRun = function(self, client, target, flags, time)
        ix.util.Notify(client:GetName() .. " has given " .. target:GetName() .. " '" .. flags .. "' flags for " .. time .. " minutes.")

        if not PLUGIN.tempFlags[target:GetID()] then
            PLUGIN.tempFlags[target:GetID()] = flags
        else 
            PLUGIN.tempFlags[target:GetID()] = PLUGIN.tempFlags[target:GetID()] .. flags
        end
        
        for i = 1, #flags do
            local flag = flags:sub(i, i)
            local info = ix.flag.list[flag]
            if (info and info.callback) then
                info.callback(target:GetPlayer(), true)
            end
        end

        timer.Simple(time * 60, function()
            if PLUGIN.tempFlags[target:GetID()] then
                for i = 1, #flags do
                    local flag = flags:sub(i, i)
                    if (target:GetFlags():find(flag) ~= nil) then continue end

                    PLUGIN.tempFlags[target:GetID()] = string.Replace(PLUGIN.tempFlags[target:GetID()], flag, "")
                    local info = ix.flag.list[flag]
                    if (info and info.callback) then
                        info.callback(target:GetPlayer(), false)
                    end
                end
            end

            ix.util.Notify("Your '" .. flags .. "' flags have expired.", target:GetPlayer())
        end)
    end
})

ix.config.Add(
    "afkTime", 
    300, 
    "The amount of seconds it takes for someone to be flagged as AFK.", 
    function(oldValue, newValue)
    end, 
    {
        data = {min = 60, max = 3600},
        category = "antiafk"
    }
)

function PLUGIN:CanProperty(ply, property, ent)
    if ply:GetUserGroup() == "moderator" then
        if property == "persist" then
            return true
        end
    end
end

ix.command.Add("ItemBring", {
    description = "Transfers an item to your inventory from it's ID.",
    adminOnly = true,
    arguments = {
        ix.type.number
    },
    OnRun = function(self, client, itemID)
        local item = ix.item.instances[itemID]
        if not item then return "Could not find that item!" end

        client.ixAdminBringItems = client.ixAdminBringItems or {}
        client.ixAdminBringItems[item.id] = true

        local success, err = item:Transfer(client:GetCharacter():GetInventory():GetID(), nil, nil, client)
        if success then
            local ent = item:GetEntity()
            if IsValid(ent) then
                ent:Remove()
            end
            return string.format("'%s' #%d has been transferred to your inventory.", item.name or item.uniqueID, item.id)
        end

        return string.format("Could not transfer item! %s", err)
    end
})

ix.command.Add("ItemDelete", {
    description = "Deletes an item by it's ID.",
    adminOnly = true,
    arguments = {
        ix.type.number
    },
    OnRun = function(self, client, itemID)
        local item = ix.item.instances[itemID]
        if not item then return "Could not find that item!" end

        client.ixAdminBringItems = client.ixAdminBringItems or {}
        client.ixAdminBringItems[item.id] = true

        local success = item:Remove()
        if success then
            return string.format("'%s' #%d has been deleted.", item.name or item.uniqueID, item.id)
        end

        return "Could not delete item!"
    end
})

ix.command.Add("GoToPos", {
    description = "Transfers an item to your inventory from it's ID.",
    adminOnly = true,
    arguments = {
        ix.type.number,
        ix.type.number,
        ix.type.number
    },
    OnRun = function(self, client, x, y, z)
        client:SetPos(Vector(x, y, z))
        client:UnStuck()
    end
})

function PLUGIN:CanTransferItem(item, curInventory, inventory)
    if !isfunction(inventory.GetOwner) then return end

    local ply = inventory:GetOwner()
    if not IsValid(ply) then return end

    ply.ixAdminBringItems = ply.ixAdminBringItems or {}

    if ply.ixAdminBringItems[item.id] then
        ply.ixAdminBringItems[item.id] = nil
        return true
    end
end

if SERVER then
    timer.Create('AfkCheck', 1, 0, function()
        for _, v in ipairs(player.GetAll()) do
            local aim = v:GetAimVector()
            local pos = v:GetPos()
            
            if v.lastPos ~= pos or v.lastAim ~= aim then
                v.lastMoveTime = CurTime()
                v.lastPos = pos
                v.lastAim = aim
                v.isAFK = false
            elseif CurTime() - v.lastMoveTime > ix.config.Get("afkTime", 300) then
                v.isAFK = true
            end
        end
    end)

    function PLUGIN:CanPlayerEarnSalary(client, faction)
        if (client.isAFK) then
            return false
        else
            return true
        end
    end
end

ix.util.Include("sv_plugin.lua")

if CLIENT then concommand.Remove("act") end
