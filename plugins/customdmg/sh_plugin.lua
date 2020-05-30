local PLUGIN = PLUGIN

PLUGIN.name = "Custom Damage"
PLUGIN.description = "Allows easily configurable damage scaling"

PLUGIN.config = {
    ["weapon_pistol"] = 300.0,
    ["weapon_hl2pipe"] = 50.0,
    ["weapon_shotgun"] = 250,
    ["weapon_357"] = 100,
    ["weapon_smg1"] = 195,
    ["weapon_crowbar"] = 100,
    ["weapon_frag"] = 150,
    ["weapon_ar2"] = 350
}

--[[PLUGIN.configAttackTimes = {
    ["weapon_crowbar"] = 5
}
--]]

function PLUGIN:EntityTakeDamage(target, dmg)
    if target:GetPersistent() then
        return false
    end
    
    if IsValid(target) and target:IsPlayer() and target:GetMoveType() ~= MOVETYPE_NOCLIP then

        if dmg:IsFallDamage() then 
            dmg:ScaleDamage(1.15)
        end
        
        local after = (target:Health() - dmg:GetDamage())

        if (after <= 20 and after > 0) and target.SetRagdolled and not IsValid(target.ixRagdoll)  then
            timer.Simple(0, function()
                target:SetRagdolled(true, 45)
                target.ixUnconcious = true
            end)
        end
    end

    local attacker = dmg:GetAttacker()
    if not IsValid(attacker) then return end

    if attacker:GetClass() == "npc_turret_floor" then
        dmg:ScaleDamage(5)
    end

    local weapon = isfunction(attacker.GetActiveWeapon) and attacker:GetActiveWeapon()
    if not IsValid(weapon) then return end
    local weaponClass = weapon:GetClass()
    if not weaponClass then return end

    if dmg:GetDamage() <= 0 then return end

    --[[for k, v in pairs(PLUGIN.configAttackTimes) do
        if weaponClass == k then
            print("yesss")
            weapon:SetNextPrimaryFire(CurTime() + v)
        end
    end]]

    for k, v in pairs(PLUGIN.config) do
        if k == weaponClass then
            dmg:ScaleDamage(v / 100.0)
        end
    end

    if weaponClass == "ix_hands" then return end

    local dmgPos = dmg:GetDamagePosition()
    local targetPos = target:GetPos()

    local yDelta = math.abs(dmgPos.z - targetPos.z)

    local maxDist = 30

    if target.Crouching and target:Crouching() then
        maxDist = 20
    end

    if yDelta < maxDist
    and not IsValid(target.ixRagdoll) and target:GetMoveType() ~= MOVETYPE_NOCLIP then
        target.legShotCounter = target.legShotCounter or 0
        target.legShotCounter = target.legShotCounter + 1

        if target.legShotCounter >= 3
        and target.SetRagdolled != nil then
            target:SetRagdolled(true, nil, 7) 
            target.legShotCounter = 0
        end
    end

    if target:IsRagdoll() and IsValid(target.ixPlayer) then
        local headIndex = target:LookupBone("ValveBiped.Bip01_Head1")
        if headIndex ~= nil then
            local headPos = target:GetBonePosition(headIndex)

            if headPos:Distance(dmgPos) <= 15 then
                dmg:ScaleDamage(3.75)
            end
        end
    end
end

function PLUGIN:EntityEmitSound(t)
    if t.Entity:IsPlayer() and t.Entity:Crouching() and string.find(t.SoundName, "player/footsteps") then
        t.Volume = t.Volume * .25
        return true
    end
end

function PLUGIN:PlayerLoadedCharacter(client, character)
    client:SetCrouchedWalkSpeed(.5)
end

function PLUGIN:PlayerSpawn(client)
    client.ixUnconcious = nil
end

function PLUGIN:PlayerDeath(victim)
    victim.ixUnconcious = nil
end

function PLUGIN:OnCharacterFallover(client, entity, bFallenOver)
    if not bFallenOver then
        timer.Simple(0, function()
            client.ixUnconcious = nil
            client:SetAction()
        end)
    end
end

function PLUGIN:StartCommand(ent, cmd)
    if IsValid(ent) and ent:IsPlayer() then
        if SERVER and !IsValid(ent.ixRagdoll) then ent.ixUnconcious = nil end

        local wep = ent:GetActiveWeapon()
        if IsValid(wep) and wep:GetClass() == "weapon_crowbar" then
            if wep:GetNextPrimaryFire() > CurTime() and not ent.isStoppingCrowbar then
                wep:SetNextPrimaryFire(CurTime() + 1)
                ent.isStoppingCrowbar = true
                timer.Simple(1, function()
                    ent.isStoppingCrowbar = nil
                end)
            end
        elseif IsValid(wep) and wep:GetClass() == "weapon_knife" then
            if wep:GetNextPrimaryFire() > CurTime() and not ent.isStoppingKnife then
                wep:SetNextPrimaryFire(CurTime() + 1)
                ent.isStoppingKnife = true
                timer.Simple(1, function()
                    ent.isStoppingKnife = nil
                end)
            end

            if wep:GetNextSecondaryFire() > CurTime() and not ent.isStoppingKnife then
                wep:SetNextSecondaryFire(CurTime() + 2)
                ent.isStoppingKnife = true
                timer.Simple(2, function()
                    ent.isStoppingKnife = nil
                end)
            end
        elseif IsValid(wep) and wep:GetClass() == "weapon_nmrih_molotov" then
            if wep.Throwing and !wep.MarkedForDeletion then
                wep.MarkedForDeletion = true
                timer.Simple(0, function()
                    if isfunction(wep:GetOwner().StripWeapon) then
                        wep:GetOwner():StripWeapon("weapon_nmrih_molotov")
                    end

                    if wep and wep.ixItem then wep.ixItem:Remove() end
                end)
            end
        end
    end
end