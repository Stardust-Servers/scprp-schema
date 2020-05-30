ITEM.name = "Beer"
ITEM.model = Model("models/bioshockinfinite/hext_bottle_lager.mdl")
ITEM.description = "A bottle of the Foundation's finest beer."
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Consumables"
ITEM.permit = "consumables"
ITEM.hungerAmt = 0
ITEM.thirstAmt = 30

ITEM.functions.Drink = {
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + 10, client:GetMaxHealth()))
		client:EmitSound("npc/barnacle/barnacle_gulp2.wav", 75, 150, 0.50)
		client:GetCharacter():GetInventory():Add("bottle")

		return true
	end
}
