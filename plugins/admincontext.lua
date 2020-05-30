
local PLUGIN = PLUGIN or {}

PLUGIN.name = "Context Menu Options"
PLUGIN.author = "Gary Tate"
PLUGIN.description = "Adds several context options on players."
PLUGIN.license = [[
The MIT License (MIT)
Copyright (c) 2020 Gary Tate
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

CAMI.RegisterPrivilege({
	Name = "Helix - Admin Context Options",
	MinAccess = "admin"
})

properties.Add("ixViewPlayerProperty", {
	MenuLabel = "#View Player",
	Order = 1,
	MenuIcon = "icon16/user.png",
	Format = "%s | %s\nHealth: %s\nArmor: %s",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil) and entity:IsPlayer()
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			local entity = net.ReadEntity()
			client:NotifyLocalized(string.format(self.Format, entity:Nick(), entity:SteamID(), entity:Health(), entity:Armor()))
		end
	end
})

properties.Add("ixSetHealthProperty", {
	MenuLabel = "#Health",
	Order = 2,
	MenuIcon = "icon16/heart.png",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil) and entity:IsPlayer()
	end,

	MenuOpen = function( self, option, ent, tr )

		local submenu = option:AddSubMenu()
		local target = IsValid( ent.AttachedEntity ) and ent.AttachedEntity or ent

		for i = 100, 0, -25 do
			local option = submenu:AddOption(i, function() self:SetHealth( ent, i ) end )
		end

	end,

	Action = function(self, entity)
		-- not used
	end,

	SetHealth = function(self, target, health)
		self:MsgStart()
			net.WriteEntity(target)
			net.WriteUInt(health, 8)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			local entity = net.ReadEntity()
			local health = net.ReadUInt(8)

			entity:SetHealth(health)
			if (entity:Health() == 0) then entity:Kill() end
		end
	end
})

properties.Add("ixSetArmorProperty", {
	MenuLabel = "#Armor",
	Order = 3,
	MenuIcon = "icon16/shield.png",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil) and entity:IsPlayer()
	end,

	MenuOpen = function( self, option, ent, tr )

		local submenu = option:AddSubMenu()
		local target = IsValid( ent.AttachedEntity ) and ent.AttachedEntity or ent

		for i = 100, 0, -25 do
			local option = submenu:AddOption(i, function() self:SetArmor( ent, i ) end )
		end

	end,

	Action = function(self, entity)
		-- not used
	end,

	SetArmor = function(self, target, armor)
		self:MsgStart()
			net.WriteEntity(target)
			net.WriteUInt(armor, 8)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			local entity = net.ReadEntity()
			local armor = net.ReadUInt(8)

			entity:SetArmor(armor)
		end
	end
})

properties.Add("ixSetDescriptionProperty", {
	MenuLabel = "#Edit Description",
	Order = 4,
	MenuIcon = "icon16/book_edit.png",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil) and entity:IsPlayer()
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			local entity = net.ReadEntity()
			client:RequestString("Set the character's description.", "New Description", function(text)
				entity:GetCharacter():SetDescription(text)
			end, entity:GetCharacter():GetDescription())
		end
	end
})

properties.Add("ixForceFalloverProperty", {
	MenuLabel = "#Force Fallover",
	Order = 5,
	MenuIcon = "icon16/book_edit.png",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - forcefallover", nil) and entity:IsPlayer()
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			ix.command.Run(client, "forcefallover", {net.ReadEntity():GetCharacter():GetName()})
		end
	end
})

properties.Add("ixForceGetUpProperty", {
	MenuLabel = "#Force Get Up",
	Order = 6,
	MenuIcon = "icon16/book_edit.png",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - forcegetup", nil) and entity:IsRagdoll()
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			ix.command.Run(client, "forcegetup", {net.ReadEntity():GetNetVar("ixPlayer"):GetCharacter():GetName()})
		end
	end
})

properties.Add("ixUndoDeathProperty", {
	MenuLabel = "#Undo Death",
	Order = 7,
	MenuIcon = "icon16/book_edit.png",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil) and entity:IsRagdoll()
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			local entity = net.ReadEntity()

			local deathPlayer = entity:GetNetVar("ixPlayer")
			
			if IsValid(deathPlayer) then
				ix.command.Run(client, "undoDeath", {deathPlayer:GetCharacter():GetName()})
			end
		end
	end
})

properties.Add("ixOpenInventoryProperty", {
	MenuLabel = "#Open Inventory",
	Order = 7,
	MenuIcon = "icon16/book_edit.png",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - charinv", nil) and entity:IsPlayer()
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			ix.command.Run(client, "charinv", {net.ReadEntity():GetCharacter():GetName()})
		end
	end
})

properties.Add("ixRestoreLastInventoryProperty", {
	MenuLabel = "#Restore Last Inventory",
	Order = 8,
	MenuIcon = "icon16/book_edit.png",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - restorelastinv", nil) and entity:IsPlayer()
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			ix.command.Run(client, "restorelastinv", {net.ReadEntity():GetCharacter():GetName()})
		end
	end
})

properties.Add("ixDestroyProperty", {
	MenuLabel = "#Destroy",
	Order = 8,
	MenuIcon = "icon16/book_edit.png",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - destroy", nil) and entity:IsPlayer()
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			ix.command.Run(client, "destroy", {net.ReadEntity():GetCharacter():GetName()})
		end
	end
})

