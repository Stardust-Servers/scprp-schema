local PANEL = {}

function PANEL:Init()
	self:SetSize(500, 700)	
	self:MakePopup()
	self:Center()
	self:SetTitle("Paper")

	self.controls = self:Add("DPanel")
	self.controls:Dock(BOTTOM)
	self.controls:SetTall(30)
	self.controls:DockMargin(0, 5, 0, 0)

	self.contents = self:Add("DTextEntry")
	self.contents:Dock(FILL)
	self.contents:SetMultiline(true)
	self.contents:SetEditable(true)

	self.confirm = self.controls:Add("DButton")
	self.confirm:Dock(RIGHT)
	self.confirm:SetDisabled(false)
	self.confirm:SetText("Done")

	self.controls.Paint = function(this, w, h)
		if not self.canRead then
			local text = self.contents:GetValue()
			draw.SimpleText(Format("Number of characters: %s/3000", string.len(text)), "DermaDefault", 10, h/2, color_white, TEXT_ALIGN_LEFT, 1)
		end
	end

	self.confirm.DoClick = function(this)
		if not self.canRead then
			local text = self.contents:GetValue()
			netstream.Start("paperSendText", itemID, text)
		end

		self:Close()
	end
end

function PANEL:setText(text, id)
	self.contents:SetValue(text or "")
	itemID = id
end

function PANEL:setCanRead(canRead)
	self.canRead = canRead
	if self.contents then
		self.contents:SetEditable(not self.canRead)
	end
end

vgui.Register("paperRead", PANEL, "DFrame")
