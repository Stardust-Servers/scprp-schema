local PLUGIN = PLUGIN
PLUGIN.name = "Paper"
PLUGIN.author = "Subleader"
PLUGIN.desc = "Adds paper into the game that you can write on and edit. Reworked completely working without entity."
PAPERLIMIT = 3000

if (CLIENT) then
	netstream.Hook("receivePaper", function(id, contents, canRead)
		local paper = vgui.Create("paperRead")
		paper:setText(contents, id)
		paper:setCanRead(canRead)
	end)
else
	netstream.Hook("paperSendText", function(client, id, contents)
		if (string.len(contents) <= PAPERLIMIT) then
			local char = client:GetCharacter()
			local inv = char:GetInventory()
			local items = inv:GetItems()
			for k, v in pairs(items) do
				if (v:GetID() == id) then
					local owner = v:GetData("PaperOwner")
					if v:GetData("canOthersWrite") == true or owner == nil or owner == char:GetID() then
						client:Notify("You have written something!")
						v:SetData("PaperData", contents)
						v:SetData("PaperOwner", client:GetCharacter():GetID())
					end
				end
			end
			for k, v in pairs(ents.GetAll()) do
				if v:GetClass() == "ix_item" then
					local itemID = v.ixItemID
					local item = ix.item.instances[itemID]
					if (itemID == id) then
						local owner = item:GetData("PaperOwner")
						if v:GetData("canOthersWrite") == true or owner == nil or owner == char:GetID() then
							client:Notify("You have written something!")
							item:SetData("PaperData", contents)
							item:SetData("PaperOwner", client:GetCharacter():GetID())
						end
					end
				end
			end
		end
	end)
end