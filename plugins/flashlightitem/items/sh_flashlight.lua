
ITEM.name = "Flashlight"
ITEM.model = Model("models/flashlight.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "A standard flashlight that can be toggled."
ITEM.category = "Tools"
ITEM.price = 25

ITEM:Hook("drop", function(item)
	item.player:Flashlight(false)
end)
