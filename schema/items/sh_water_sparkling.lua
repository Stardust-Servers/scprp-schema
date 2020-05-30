
ITEM.name = "Sparkling Water"
ITEM.model = Model("models/props_lunk/popcan01a.mdl")
ITEM.skin = 2
ITEM.description = "A red aluminium can of carbonated water."
ITEM.category = "Consumables"
ITEM.hungerAmt = 0
ITEM.thirstAmt = 30

ITEM.functions.Drink = {
	OnRun = function(itemTable)
		local client = itemTable.player

		client:RestoreStamina(50)
		client:SetHealth(math.Clamp(client:Health() + 8, 0, client:GetMaxHealth()))
		client:EmitSound("npc/barnacle/barnacle_gulp2.wav", 75, 90, 0.35)
		
		client:GetCharacter():GetInventory():Add("can", 1)
	end,
}
