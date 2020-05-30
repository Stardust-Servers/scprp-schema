
ITEM.name = "Can of soda"
ITEM.model = Model("models/props_lunk/popcan01a.mdl")
ITEM.description = "A blue aluminium can carbonated soda."
ITEM.category = "Consumables"
ITEM.hungerAmt = 5
ITEM.thirstAmt = 25

ITEM.functions.Drink = {
	OnRun = function(itemTable)
		local client = itemTable.player

		client:RestoreStamina(35)
		client:SetHealth(math.Clamp(client:Health() + 10, 0, client:GetMaxHealth()))
		client:EmitSound("npc/barnacle/barnacle_gulp2.wav", 75, 90, 0.40)
		
		client:GetCharacter():GetInventory():Add("can", 1)
	end,
	OnCanRun = function(itemTable)
		return !itemTable.player:IsCombine()
	end
}
