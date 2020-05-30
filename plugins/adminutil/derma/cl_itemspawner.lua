-- i copy pasted the help tab as a base, sorry.

local backgroundColor = Color(0, 0, 0, 66)

local PANEL = {}

AccessorFunc(PANEL, "maxWidth", "MaxWidth", FORCE_NUMBER)

function PANEL:Init()
	self:SetWide(180)
	self:Dock(LEFT)

	self.maxWidth = ScrW() * 0.2
end

function PANEL:Paint(width, height)
	surface.SetDrawColor(backgroundColor)
	surface.DrawRect(0, 0, width, height)
end

function PANEL:SizeToContents()
	local width = 0

	for _, v in ipairs(self:GetChildren()) do
		width = math.max(width, v:GetWide())
	end

	self:SetSize(math.max(32, math.min(width, self.maxWidth)), self:GetParent():GetTall())
end

vgui.Register("adminSpawnerMenuCategories", PANEL, "EditablePanel")

PANEL = {}

function PANEL:Init()
	self:Dock(FILL)

	self.categories = {}
	self.categorySubpanels = {}
	self.categoryPanel = self:Add("adminSpawnerMenuCategories")

	self.canvasPanel = self:Add("EditablePanel")
    self.canvasPanel:Dock(FILL)

	local categories = {}
	hook.Run("PopulateCraftingMenu", categories)

	for k, v in SortedPairs(categories) do
		if (!isstring(k)) then
			ErrorNoHalt("expected string for help menu key\n")
			continue
		elseif (!isfunction(v)) then
			ErrorNoHalt(string.format("expected function for help menu entry '%s'\n", k))
			continue
		end

		self:AddCategory(k)
		self.categories[k] = v
	end

	self.categoryPanel:SizeToContents()

    for k, _ in pairs(categories) do
        self:OnCategorySelected(k)
        break
    end
end

function PANEL:AddCategory(name)
	local button = self.categoryPanel:Add("ixMenuButton")
    button:SetText(L(name))
    
	button:Dock(TOP)
	button.DoClick = function()
		self:OnCategorySelected(name)
	end

	local panel = self.canvasPanel:Add("DScrollPanel")
	panel:SetVisible(false)
	panel:Dock(FILL)
	panel:DockMargin(8, 0, 0, 0)
	panel:GetCanvas():DockPadding(8, 8, 8, 8)
	panel.Paint = function(_, width, height)
		surface.SetDrawColor(backgroundColor)
		surface.DrawRect(0, 0, width, height)
	end

	self.categorySubpanels[name] = panel
end

function PANEL:OnCategorySelected(name)
	local panel = self.categorySubpanels[name]

	if (!IsValid(panel)) then
		return
	end

	if (!panel.bPopulated) then
		self.categories[name](panel)
		panel.bPopulated = true
	end

	if (IsValid(self.activeCategory)) then
		self.activeCategory:SetVisible(false)
	end

	panel:SetVisible(true)

	self.activeCategory = panel
	ix.gui.lastHelpMenuTab = name
end

vgui.Register("adminSpawnerMenu", PANEL, "EditablePanel")

function FindItemByUID(uid)
    for _, v in pairs(ix.item.list) do
        if (v.uniqueID == uid) then return v end
    end

    return nil
end

function BuildRecipeString(recipe)
    local str = ""

    for _, req in pairs(recipe) do
        local item = FindItemByUID(req.type)
        if item then
            str = str .. item.name .. " (" .. req.amount .. ")" .. (_ ~= #recipe and ", " or "")
        end
    end

    return str
end

function CanCraftItem(player, recipe)
    local character = player:GetCharacter()
    local inventoryID = character:GetInventory():GetID()
    local inventory = ix.item.inventories[inventoryID]

    local itemsInInventory = {}

    for x, items in pairs(inventory.slots) do
        for y, data in pairs(items) do
            local entryIndex = 0    

            for k, v in pairs(itemsInInventory) do
                if (v.type == data.uniqueID) then
                    entryIndex = k
                end
            end

            if entryIndex ~= 0 then
                itemsInInventory[entryIndex].amount = itemsInInventory[entryIndex].amount + 1
            else
                table.insert(itemsInInventory, {type = data.uniqueID, amount = 1})
            end
        end
    end

    local requirementCount = 0
    for _, req in pairs(recipe) do
        local foundRequirement = false
        for _, item in pairs(itemsInInventory) do
            
            if item.type == req.type then
                foundRequirement = item.amount >= req.amount
            end
        end
        if foundRequirement then requirementCount = requirementCount + 1 end
    end

    return requirementCount >= #recipe 
end

function OnCraft(recipe)
    net.Start( "liquidCraft" )
        net.WriteString( recipe.item )
    net.SendToServer()
end

function OnBreakdown(recipe)
    net.Start( "liquidBreakdown" )
        net.WriteString( recipe.item )
    net.SendToServer()
end

net.Receive("adminSpawnerSuccess", function()
    if ix.gui.menu then
        ix.gui.menu:Remove()
    end
end)

hook.Add("CreateMenuButtons", "adminSpawnerMenu", function(tabs)
    --[[if LocalPlayer():IsSuperAdmin() then
        tabs["items"] = function(container)
            container:Add("adminSpawnerMenu")
        end
    end]]
end)

hook.Add("PopulateItemMenu", "adminSpawnerMenu", function(tabs)
    
end)