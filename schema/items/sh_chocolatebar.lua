ITEM.name = "Chocolate Bar"
ITEM.model = Model("models/bioshockinfinite/hext_candy_chocolate.mdl")
ITEM.description = "A Hershey's chocolate bar."
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Consumables"
ITEM.permit = "consumables"
ITEM.hungerAmt = 10
ITEM.thirstAmt = 0

ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + 15, client:GetMaxHealth()))
		client:EmitSound("gmodtower/inventory/move_paper.wav", 75, 150, 0.50)

		return true
	end
}
