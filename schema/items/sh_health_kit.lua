
ITEM.name = "Health Kit"
ITEM.model = Model("models/items/healthkit.mdl")
ITEM.description = "A red first aid kit; it's filled with medical supplies."
ITEM.category = "Medical"
ITEM.price = 65

ITEM.functions.Apply = {
	sound = "items/medshot4.wav",
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + 50, 100))
	end
}

ITEM.functions.ApplyTo = {
	sound = "items/medshot4.wav",
	OnRun = function(itemTable)
		local client = itemTable.player
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity
		if IsValid(target) and target:IsPlayer() then
			target:SetHealth(math.min(target:Health() + 50, target:GetMaxHealth()))
		else 
			itemTable.player:NotifyLocalized("plyNotValid")
		end
	end
}