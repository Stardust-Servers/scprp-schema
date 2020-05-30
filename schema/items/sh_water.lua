
ITEM.name = "Water"
ITEM.model = Model("models/props_lunk/popcan01a.mdl")
ITEM.description = "A blue aluminium can of plain water."
ITEM.category = "Consumables"
ITEM.hungerAmt = 0
ITEM.thirstAmt = 20

ITEM.functions.Drink = {
	OnRun = function(itemTable)
		local client = itemTable.player

		client:RestoreStamina(25)
		client:SetHealth(math.Clamp(client:Health() + 6, 0, client:GetMaxHealth()))
		client:EmitSound("npc/barnacle/barnacle_gulp2.wav", 75, 90, 0.35)

		client:GetCharacter():GetInventory():Add("can", 1)
	end
}
