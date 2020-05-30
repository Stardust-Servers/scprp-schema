ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Incinerator"
ENT.Author = "Mazzie"
ENT.Category = "SCP RP"
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Spawnable = true
ENT.AdminOnly = true

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_wasteland/laundry_basket002.mdl")
		self:SetMaterial("models/props_combine/metal_combinebridge001")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		local phys = self:GetPhysicsObject()

		if (phys:IsValid()) then
			phys:Wake()
		end
	end

	util.AddNetworkString("ixIncinerate")

	function ENT:Use(activator, caller)
		local selfPos = self:GetPos() + Vector(0, 0, -17.75)
		local selfPos2D = Vector(selfPos.x, selfPos.y, 0)
		local incinerated = false

		for _, v in pairs(ents.FindByClass("ix_item")) do
			local pos = v:GetPos()
			local pos2D = Vector(pos.x, pos.y, 0)

			if selfPos2D:Distance(pos2D) <= 25 and pos.z >= selfPos.z and pos.z <= selfPos.z + 38 then
				local item = ix.item.instances[v.ixItemID]

				if item then
					item.ixIsDestroying = true
					item.ixDamageInfo = {activator, 100, activator}
					item:Remove()
					incinerated = true
				end
			end
		end

		if incinerated then
			self:EmitSound("weapons/physcannon/energy_disintegrate5.wav")
			net.Start("ixIncinerate")
			net.WriteEntity(self)
			net.SendPVS(self:GetPos())
		end
	end
end

if CLIENT then
	net.Receive("ixIncinerate", function()
		local incinerator = net.ReadEntity()
		local effectdata = EffectData()
		effectdata:SetOrigin(incinerator:GetPos())
		effectdata:SetNormal(Vector(0, 0, 1))
		effectdata:SetRadius(22)
		util.Effect("AR2Explosion", effectdata)
	end)
end