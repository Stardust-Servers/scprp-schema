function Schema:PopulateCharacterInfo(client, character, tooltip)
	if (client:IsRestricted()) then
		local panel = tooltip:AddRowAfter("name", "ziptie")
		panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		panel:SetText(L("tiedUp"))
		panel:SizeToContents()
	elseif (client:GetNetVar("tying")) then
		local panel = tooltip:AddRowAfter("name", "ziptie")
		panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		panel:SetText(L("beingTied"))
		panel:SizeToContents()
	elseif (client:GetNetVar("untying")) then
		local panel = tooltip:AddRowAfter("name", "ziptie")
		panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		panel:SetText(L("beingUntied"))
		panel:SizeToContents()
	end
end

local COMMAND_PREFIX = "/"

function Schema:ChatTextChanged(text)
	if (LocalPlayer():IsFoundation()) then
		local key = nil

		if (text == COMMAND_PREFIX .. "radio ") then
			key = "r"
		elseif (text == COMMAND_PREFIX .. "w ") then
			key = "w"
		elseif (text == COMMAND_PREFIX .. "y ") then
			key = "y"
		elseif (text:sub(1, 1):match("%w")) then
			key = "t"
		end

		if (key) then
			netstream.Start("PlayerChatTextChanged", key)
		end
	end
end

function Schema:CanPlayerJoinClass(client, class, info)
	return false
end

function Schema:PlayerFootstep(client, position, foot, soundName, volume)
	return true
end

netstream.Hook("PlaySound", function(sound)
	surface.PlaySound(sound)
end)

netstream.Hook("Frequency", function(oldFrequency)
	Derma_StringRequest("Frequency", "What would you like to set the frequency to?", oldFrequency, function(text)
		ix.command.Send("SetFreq", text)
	end)
end)

netstream.Hook("ViewObjectives", function(data)
	vgui.Create("ixViewObjectives"):Populate(data)
end)

netstream.Hook("ToggleThirdPerson", function(data)
	RunConsoleCommand("ix_togglethirdperson")
end)

function GM:LoadFonts(font, genericFont)
	
	font = genericFont

	surface.CreateFont("ixChatFontYell", {
		font = font,
		size = math.max(ScreenScale(8), 20) * ix.option.Get("chatFontScale", 1),
		extended = true,
		weight = 600,
		antialias = true
	})

	surface.CreateFont("ixChatFontYellItalics", {
		font = font,
		size = math.max(ScreenScale(8), 20) * ix.option.Get("chatFontScale", 1),
		extended = true,
		weight = 600,
		antialias = true,
		italic = true
	})

	surface.CreateFont("ixChatFontWhisper", {
		font = font,
		size = math.max(ScreenScale(6), 13) * ix.option.Get("chatFontScale", 1),
		extended = true,
		weight = 600,
		antialias = true
	})

	surface.CreateFont("ixChatFontWhisperItalics", {
		font = font,
		size = math.max(ScreenScale(6), 13) * ix.option.Get("chatFontScale", 1),
		extended = true,
		weight = 600,
		antialias = true,
		italic = true
	})

end