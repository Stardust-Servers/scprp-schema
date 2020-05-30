
ITEM.name = "Bag of chips"
ITEM.model = Model("models/bioshockinfinite/bag_of_hhips.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "A small bag of potato chips."
ITEM.category = "Consumables"
ITEM.permit = "consumables"
ITEM.hungerAmt = 25
ITEM.thirstAmt = -10

ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player

        client:SetHealth(math.min(client:Health() + 5, 100))
        client:EmitSound("npc/headcrab/headbite.wav", 75, 150, 0.30)

		return true
	end,
}
