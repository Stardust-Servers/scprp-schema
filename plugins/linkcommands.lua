
local PLUGIN = PLUGIN

PLUGIN.name = "Links"
PLUGIN.description = "Adds link commands (/website, /forums, /discord)"

if CLIENT then
	net.Receive("openLink", function()
		local url = net.ReadString()
		gui.OpenURL(url)	
	end)
else
	util.AddNetworkString("openLink")
end


/*
ix.command.Add("Discord", {
	description = "Opens Stardust's Discord",
	OnRun = function(self, client, text, scale)
		client:SendLua([[gui.OpenUrl("https://discord.gg/sgBzzWH")]])
	end
})

ix.command.Add("Content", {
	description = "Opens Stardust's content pack.",
	OnRun = function(self, client, text, scale)
		client:SendLua([[gui.OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=2097949135")]])
	end
})

ix.command.Add("GitHub", {
	description = "Opens Stardust's source code!"
		OnRun = function(self, client, text, scale)
		client:SendLua([[gui.OpenUrl("https://github.com/Stardust-Servers/hl2rp")]])
	end
}) */
