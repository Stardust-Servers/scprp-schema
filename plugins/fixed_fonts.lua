PLUGIN.name = "Fixed Fonts for /y and /w"
PLUGIN.author = "Mazzie Dookbold"
PLUGIN.license = /* This Source Code Form is subject to the terms of the Mozilla Public
                    License, v. 2.0. If a copy of the MPL was not distributed with this
                    file, You can obtain one at https://mozilla.org/MPL/2.0/. */

-- Whisper chat.
ix.chat.Register("w", {
	format = "%s whispers \"%s\"",
	GetColor = function(self, speaker, text)
		local color = ix.chat.classes.ic:GetColor(speaker, text)

		-- Make the whisper chat slightly darker than IC chat.
		return Color(color.r - 35, color.g - 35, color.b - 35)
	end,
	CanHear = ix.config.Get("chatRange", 280) * 0.25,
	prefix = {"/W", "/Whisper"},
	description = "@cmdW",
	indicator = "chatWhispering",
    font = "ixChatFontWhisper"
})

-- Yelling out loud.
ix.chat.Register("y", {
	format = "%s yells \"%s\"",
	GetColor = function(self, speaker, text)
		local color = ix.chat.classes.ic:GetColor(speaker, text)

		-- Make the yell chat slightly brighter than IC chat.
		return Color(color.r + 35, color.g + 35, color.b + 35)
    end,
	CanHear = ix.config.Get("chatRange", 280) * 2,
	prefix = {"/Y", "/Yell"},
	description = "@cmdY",
	indicator = "chatYelling",
    font = "ixChatFontYell"
})