
PLUGIN.name = "Flashlight item"
PLUGIN.author = "SleepyMode"
PLUGIN.description = "Adds an item allowing players to toggle their flashlight."

function PLUGIN:PlayerSwitchFlashlight(client, bEnabled)
	local character = client:GetCharacter()
	local inventory = character and character:GetInventory()

	if (inventory and (inventory:HasItem("flashlight") or inventory:HasItem("makeshift_flashlight"))) then
		return true
	end
end
--[[
if SERVER then
	hook.Add("PlayerSwitchFlashlight", "makeshift_flashlight", function(ply, enabled)
		local character = ply:GetCharacter()
		local inventory = character and character:GetInventory()	

		print('timertest0 ' .. (enabled and "true" or "false"))

		print('timertest1')

		if not enabled then return end

		if not inventory:HasItem("makeshift_flashlight") then return end
		if inventory:HasItem("flashlight") then return end
		if ply:IsCombine() then return end

		print('timertest2')

		timer.Create("makeshift_flashlight_" .. ply:SteamID64(), 1, 0, function()
			if not ply:FlashlightIsOn() then return end
			
			if inventory:HasItem("makeshift_flashlight") and not inventory:HasItem("flashlight") and not ply:IsCombine() then
				print('timertest3')
				if math.random() < 0.4 then
					print('timertest4')
					Player:Flashlight(false)
				end
			else
				print('timertest5')
				timer.Destroy("makeshift_flashlight_" .. ply:SteamID64())
			end
		end)

		return true
	end)
end]]