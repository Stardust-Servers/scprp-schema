
ITEM.name = "Can of Sardines"
ITEM.model = Model("models/bioshockinfinite/cardine_can_open.mdl")
ITEM.width = 2
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(0, 200, 84.335273742676),
	ang = Angle(22.575902938843, 270, 0),
	fov = 3.1494392921703
}
ITEM.description = "A can of freshly packed sardines."
ITEM.category = "Consumables"
ITEM.permit = "consumables"
ITEM.hungerAmt = 30
ITEM.thirstAmt = 10

ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + 10, client:GetMaxHealth()))
		client:EmitSound("npc/barnacle/neck_snap2.wav", 75, 105, 0.40)

		return true
	end,
}
