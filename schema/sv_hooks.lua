function Schema:LoadData()
	self:LoadVendingMachines()
	self:LoadCoffeeMachines()
end

function Schema:SaveData()
	self:SaveVendingMachines()
	self:SaveCoffeeMachines()
end

function Schema:PlayerUse(client, entity)
	if (!client:IsRestricted() and entity:IsPlayer() and entity:IsRestricted() and !entity:GetNetVar("untying")) then
		entity:SetAction("@beingUntied", 5)
		entity:SetNetVar("untying", true)

		client:SetAction("@unTying", 5)

		client:DoStaredAction(entity, function()
			entity:SetRestricted(false)
			entity:SetNetVar("untying")
			entity:RemovePart(entity.ziptieID)
		end, 5, function()
			if (IsValid(entity)) then
				entity:SetNetVar("untying")
				entity:SetAction()
			end

			if (IsValid(client)) then
				client:SetAction()
			end
		end)
	end
end

function Schema:PlayerLoadout(client)
	client:SetNetVar("restricted")
end

function Schema:PostPlayerLoadout(client)
	if (client:IsFoundation()) then
		if (client:Team() == FACTION_MTF) then
			client:SetArmor(100)
		elseif (client:Team() == FACTION_SECURITY) then
			client:SetArmor(50)
		else
			client:SetArmor(0)
		end

		local factionTable = ix.faction.Get(client:Team())
		local character = client:GetCharacter()

		if (factionTable.OnNameChanged) then
			factionTable:OnNameChanged(client, "", character:GetName())
		end
	end
end

function Schema:CharacterVarChanged(character, key, oldValue, value)
	local client = character:GetPlayer()
	if (key == "name") then
		local factionTable = ix.faction.Get(client:Team())

		if (factionTable.OnNameChanged) then
			factionTable:OnNameChanged(client, oldValue, value)
		end
	end
end

function Schema:PlayerFootstep(client, position, foot, soundName, volume)
	local factionTable = ix.faction.Get(client:Team())

	if (factionTable.runSounds and client:IsRunning()) then
		client:EmitSound(factionTable.runSounds[foot])
		return true
	end

	local soundLevel = 75

	if soundName:find("metal") then
		volume = volume * 2
		soundLevel = 90
	else
		volume = volume * .7
	end

	client:EmitSound(soundName, soundLevel, 100, volume)
	return true
end

function Schema:OnNPCKilled(npc, attacker, inflictor)
	if (IsValid(npc.ixPlayer)) then
		hook.Run("PlayerDeath", npc.ixPlayer, inflictor, attacker)
	end
end

function Schema:CanPlayerJoinClass(client, class, info)
	if client:IsRestricted() then
		client:Notify("You cannot change classes when you are restrained!")

		return false
	end
end

function Schema:PlayerSpawnObject(client)
	if client:IsRestricted() then
		return false
	end
end

function Schema:ShowSpare2(client)
	netstream.Start(client, "ToggleThirdPerson")
end
