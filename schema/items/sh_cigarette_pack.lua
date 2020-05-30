ITEM.name = "Cigarette Pack"
ITEM.description = "A 20-pack of some tobacco cigarettes."
ITEM.model = "models/closedboxshin.mdl"
ITEM.width = 1
ITEM.height = 1

function ITEM:PaintOver(item, w, h)
	local cigCount = item:GetData("cigCount", 20)

	surface.SetDrawColor(Color(255, 255, 255))
	draw.SimpleText(
		cigCount, 
		"DermaDefault",
		w - 5,
		h - 5, 
		Color(255, 255, 255), 
		TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 
		1, 
		Color(0, 0, 0)
	)
end

ITEM.functions.TakeOutCigarette = {
    name = "Take out a cigarette",
	OnRun = function(itemTable)
        local cigCount = itemTable:GetData("cigCount", 20)
		cigCount = cigCount - 1
		itemTable:SetData("cigCount", cigCount)

		itemTable.player:GetCharacter():GetInventory():Add("cigarette", 1)

		if cigCount <= 0 then
			return true
		end

		return false
	end,
    OnCanRun = function(item)
        return item:GetData("cigCount", 20) > 0
    end
}