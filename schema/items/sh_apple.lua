
ITEM.name = "Apple"
ITEM.model = Model("models/bioshockinfinite/hext_apple.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "A red delicious apple."
ITEM.category = "Consumables"
ITEM.permit = "consumables"
ITEM.hungerAmt = 15
ITEM.thirstAmt = 5

ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player

        client:SetHealth(math.min(client:Health() + 5, 100))
        client:EmitSound("npc/barnacle/neck_snap1.wav", 75, 150, 0.35)

		return true
	end,
}
