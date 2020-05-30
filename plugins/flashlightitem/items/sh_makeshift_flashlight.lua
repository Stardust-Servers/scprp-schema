
ITEM.name = "Makeshift Flashlight"
ITEM.model = Model("models/flashlight.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "An unreliable flashlight made of scrap."
ITEM.category = "Tools"

ITEM:Hook("drop", function(item)
	item.player:Flashlight(false)
end)
