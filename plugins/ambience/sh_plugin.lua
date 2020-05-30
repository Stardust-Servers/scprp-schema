local PLUGIN = PLUGIN
PLUGIN.name = "Ambience"
PLUGIN.description = "Adds support for ambient music."

// TODO: Edit me to fit SCP RP (literally just ripped this from HL2RP)
PLUGIN.types = {
	["default"] = {path = "music/hl2_song26_trainstation1.mp3", length = 90},
	["sewers"] = {path = "music/hl2_song27_trainstation2.mp3", length = 72},
	["outlands"] = {path = "music/hl2_song33.mp3", length = 84}
}

if SERVER then
    util.AddNetworkString("ixAmbienceStart")

    function PLUGIN:PlayerLoadedCharacter(client)
        net.Start("ixAmbienceStart")
        net.Send(client)
    end
end

if CLIENT then
	PLUGIN.currentType = PLUGIN.currentType or "default"

	ix.option.Add("ambientNoise", ix.type.bool, true, {
		category = "Ambience",
		OnChanged = function(oldValue, value)
			if value then
				PLUGIN:PlaySound()
			else
				if PLUGIN.sound then PLUGIN.sound:FadeOut(1) end
			end
		end
	})

	ix.option.Add("ambientVolume", ix.type.number, .2, {
		category = "Ambience",
		decimals = 2,
		min = 0,
		max = 1,
		OnChanged = function(oldValue, value)
			if PLUGIN.sound then PLUGIN.sound:ChangeVolume(value) end
		end
	})

	ix.lang.AddTable("english", {
		optAmbientNoise = "Enable Ambient Music",
		optdAmbientNoise = "Toggles ambient music.",
		optAmbientVolume = "Ambient Music Volume",
		optdAmbientVolume = "Adjusts the volume for ambient music."
	})

    function PLUGIN:PlaySound(dontRecurse)
        PLUGIN.soundCache = PLUGIN.soundCache or {}

        local path = PLUGIN.types[PLUGIN.currentType].path

        PLUGIN.soundCache[path] = 
        PLUGIN.soundCache[path] or CreateSound(game.GetWorld(), path)

        self.sound = PLUGIN.soundCache[path]
        self.sound:SetSoundLevel(0)
		self.sound:Play()
        self.sound:ChangeVolume(ix.option.Get("ambientVolume"))
        
        if not dontRecurse then self:CreateTimer() end
	end

	function PLUGIN:CreateTimer()
		if timer.Exists("ixAmbientNoise") then
			timer.Remove("ixAmbientNoise")
        end

        timer.Create("ixAmbientNoise", PLUGIN.types[PLUGIN.currentType].length, 0, function()
            self.sound:Stop()
			PLUGIN:PlaySound(true)
		end)
	end

    net.Receive("ixAmbienceStart", function()
        PLUGIN.hasSpawned = true
        PLUGIN:PlaySound()
    end)

	CreateConVar("ix_ambient_observer", "0", FCVAR_ARCHIVE)

	function PLUGIN:PostDrawTranslucentRenderables()
		local observerCvar = GetConVar("ix_ambient_observer")
		if not LocalPlayer():IsAdmin() or LocalPlayer():GetMoveType() ~= MOVETYPE_NOCLIP or not observerCvar or not observerCvar:GetBool() then return end
		local ambientPositions = GetNetVar("ambientPositions", {})

		for _, v in ipairs(ambientPositions) do
			local min, max = v.min, v.max
			render.DrawWireframeBox(min, Angle(), Vector(0, 0, 0), max - min, Color(243, 255, 54), false)
		end

		local ambientMin = LocalPlayer():GetNetVar("ixAmbientMin")

		if ambientMin ~= nil then
			render.DrawWireframeBox(ambientMin, Angle(), Vector(0, 0, 0), (EyePos() + EyeVector() * 5) - ambientMin, Color(243, 255, 54), false)
		end
	end

	function PLUGIN:HUDPaint()
		local observerCvar = GetConVar("ix_ambient_observer")
		if not LocalPlayer():IsAdmin() or LocalPlayer():GetMoveType() ~= MOVETYPE_NOCLIP or not observerCvar or not observerCvar:GetBool() then return end
		local ambientPositions = GetNetVar("ambientPositions", {})

		for _, v in ipairs(ambientPositions) do
			local scrPos = ((v.min + v.max) / 2):ToScreen()
			draw.SimpleTextOutlined(v.ambientType, "DermaDefault", scrPos.x, scrPos.y, Color(243, 255, 54), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
		end
	end

	function PLUGIN:SoundFadeIn(time)
		local startTime = CurTime()

        timer.Create("ixAmbientFadeIn", .033, 0, function()
            local delta = CurTime() - startTime
            
            PLUGIN.sound:ChangeVolume(delta / time * ix.option.Get("ambientVolume", .65))

			if delta >= time then
				timer.Remove("ixAmbientFadeIn")
			end
		end)
	end

    timer.Create("ixAmbientThink", 1, 0, function()
        if not PLUGIN.hasSpawned then return end
        if not IsValid(LocalPlayer()) then return end
        
		if not ix.option.Get("ambientNoise", false) then return end
		local ambientPositions = GetNetVar("ambientPositions", {})

		for _, v in pairs(ambientPositions) do
			if LocalPlayer():EyePos():WithinAABox(v.min, v.max) and v.ambientType ~= PLUGIN.currentType then
				PLUGIN.currentType = v.ambientType
                PLUGIN.sound:FadeOut(2)
                timer.Remove("ixAmbientNoise")

				timer.Simple(2, function()
                    PLUGIN:PlaySound()
                end)
                
				break
			end
		end
	end)
end

ix.command.Add("AddAmbientBox", {
	superAdminOnly = true,
	arguments = {ix.type.text},
	OnRun = function(self, client, ambientType)
		if PLUGIN.types[ambientType] == nil then return "That ambient noise type doesn't exist!" end
		client:SetNetVar("ixAmbientMin", client:EyePos())
		client:SetNetVar("ixAmbientType", ambientType)

		return "Starting box for " .. ambientType .. " ambient music."
	end
})

ix.command.Add("AddAmbientBoxEnd", {
	superAdminOnly = true,
	OnRun = function(self, client)
		local min = client:GetNetVar("ixAmbientMin")
        local ambientType = client:GetNetVar("ixAmbientType")
        
        if not min or not ambientType then return end

		PLUGIN.positions = PLUGIN.positions or {}

		table.insert(PLUGIN.positions, {
			ambientType = ambientType,
			min = min,
			max = client:EyePos() + client:EyeAngles():Forward() * 5
		})

		PLUGIN:SaveData()
		client:SetNetVar("ixAmbientMin")
		client:SetNetVar("ixAmbientType")

		return "Created box for " .. ambientType .. " ambient music!"
	end
})

ix.command.Add("RemoveAmbientBox", {
	description = "Removes the closest ambient music node relative to you.",
	adminOnly = true,
	OnRun = function(self, client)
		local closestDistance = -1
		local closestIndex = -1

		for idx, v in pairs(PLUGIN.positions) do
			local min, max = v.min, v.max
			local center = min + ((max - min) / 2)
			local distance = client:GetPos():Distance(center)

			if closestDistance == -1 or distance < closestDistance then
				closestDistance = distance
				closestIndex = idx
			end
		end

		if closestIndex ~= -1 then
			table.remove(PLUGIN.positions, closestIndex)
			PLUGIN:SaveData()

			return "Removed 1 ambient music node."
		else
			return "Could not find any ambient music nodes to remove!"
		end
	end
})

function PLUGIN:LoadData()
	PLUGIN.positions = self:GetData() or {}
	self:UpdateWorldData()
end

function PLUGIN:SaveData()
	self:SetData(PLUGIN.positions)
	self:UpdateWorldData()
end

function PLUGIN:UpdateWorldData()
	SetNetVar("ambientPositions", PLUGIN.positions)
end

function PLUGIN:EntityEmitSound(t)
	if string.find(t.SoundName, "ambient/") then
		t.Volume = t.Volume * .55

		return true
	end
end