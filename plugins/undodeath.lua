
local PLUGIN = PLUGIN

PLUGIN.name = "Undo Death"
PLUGIN.description = "Easy death undo."

local opts = {
    description = "Easy undo death.",
    adminOnly = true,
    arguments = ix.type.character,
    OnRun = function(self, client, character)
        local victim = character:GetPlayer()

        if not victim.ixLastDeathPoint then return end

        if not victim:Alive() then
            victim:Spawn()
        end

        ix.command.Run(client, "restorelastinv", {character:GetName()})
        
        if victim.oldHunger ~= nil then
            character:SetHunger(victim.oldHunger)
        end
        if victim.oldThirst ~= nil then
            character:SetThirst(victim.oldThirst)
        end

		timer.Simple(0, function() 
            victim:SetPos(victim.ixLastDeathPoint + Vector(0, 0, 20))
            victim:UnStuck()
            victim:SetEyeAngles(victim.ixLastDeathAngles)
            if victim.ixLastDeathEntity then
                victim.ixLastDeathEntity:Remove()
            end
            victim.ixLastDeathPoint = nil
            victim.ixLastDeathAngles = nil
            victim.ixLastDeathEntity = nil
		end)
    end
}

ix.command.Add("UndoDeath", opts)
ix.command.Add("ud", opts)

function PLUGIN:OnPlayerCorpseCreated(victim, entity)
    victim.ixLastDeathPoint = victim:GetPos()
    victim.ixLastDeathAngles = victim:EyeAngles()
    victim.ixLastDeathEntity = entity
end