ITEM.name = "Banana"
ITEM.model = Model("models/bioshockinfinite/hext_banana.mdl")
ITEM.description = "A banana. Yum!"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Consumables"
ITEM.permit = "consumables"
ITEM.hungerAmt = 20
ITEM.thirstAmt = 5

ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + 10, client:GetMaxHealth()))
		client:EmitSound("npc/antlion_grub/squashed.wav", 75, 150, 0.25)

		return true
	end
}
