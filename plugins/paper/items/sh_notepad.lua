ITEM.name = "Notepad"
ITEM.model = "models/props_lab/clipboard.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.description = "A notepad in which you can read and write on."
ITEM.price = 10

hook.Add("CanPlayerInteractItem", "NoTakePaper", function(client, action, item, data)
	if action ~= 'take' then return end

	local canOthersWrite = item:GetData("canOthersWrite", false)
	if !canOthersWrite then
		local owner = item:GetData("PaperOwner")
		if owner == nil then return end
		if owner ~= client:GetCharacter():GetID() then
			return false
		end
	end
end)

ITEM.functions.use = {
	name = "Write",
	icon = "icon16/pencil.png",
	OnRun = function(item)
		local client = item.player
		local id = item:GetID()
		if (id) then
			local canWrite = true
			local owner = item:GetData("PaperOwner")
			if owner ~= nil and owner ~= client:GetCharacter():GetID() then
				canWrite = false
			end
			netstream.Start(client, "receivePaper", id, item:GetData("PaperData") or "", not canWrite)
		end
		return false
	end,
	OnCanRun = function(item)
		if item:GetData("readOnly", false) then return false end

		local canOthersWrite = item:GetData("canOthersWrite")
		if !canOthersWrite then
			local owner = item:GetData("PaperOwner")
			if owner == nil then return end
			if owner ~= item.player:GetCharacter():GetID() then
				return false
			end
		end

		return true
	end
}

ITEM.functions.read = {
	name = "Read",
	icon = "icon16/pencil.png",
	OnRun = function(item)
		local client = item.player
		local id = item:GetID()
		if (id) then
			local canWrite = true
			local owner = item:GetData("PaperOwner")
			if owner ~= nil and owner ~= client:GetCharacter():GetID() then
				canWrite = false
			end
			netstream.Start(client, "receivePaper", id, item:GetData("PaperData") or "", true)
		end
		return false
	end,
	OnCanRun = function(item)
		//local owner = item:GetData("PaperOwner")
		//if !owner or owner == item.player:GetCharacter():GetID() then
		//	return false
		//end

		return true
	end
}

ITEM.functions.enableWrite = {
	name = "Enable writing for others",
	icon = "icon16/lock_open.png",
	OnRun = function(item)
		item:SetData("canOthersWrite", true)
		return false
	end,
	OnCanRun = function(item)
		if item:GetData("canOthersWrite") == true then return false end

		local owner = item:GetData("PaperOwner")
		if !owner or owner != item.player:GetCharacter():GetID() then
			return false
		end

		return true
	end
}

ITEM.functions.disableWrite = {
	name = "Disable writing for others",
	icon = "icon16/lock.png",
	OnRun = function(item)
		item:SetData("canOthersWrite", false)
		return false
	end,
	OnCanRun = function(item)
		if item:GetData("canOthersWrite") ~= true then return false end

		local owner = item:GetData("PaperOwner")
		if !owner or owner != item.player:GetCharacter():GetID() then
			return false
		end

		return true
	end
}