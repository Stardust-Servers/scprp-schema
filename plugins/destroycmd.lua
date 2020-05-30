local PLUGIN = PLUGIN

function PLUGIN:OnCharacterFallover(ply, ragdoll)
    if ply.destroyPos != nil then
        print(ply, ragdoll)
        --ragdoll:SetPos(ply.destroyPos - Vector(0, 0, 60))
        
        for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
            local physObj = ragdoll:GetPhysicsObjectNum(i)

            if (IsValid(physObj)) then
                local pos = physObj:GetPos()
                pos:Add(Vector(0, 0, ply.destroyPos.y - physObj:GetPos().y))
                physObj:SetPos(pos)
            end
        end

        timer.Simple(0.1, function()
            for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
				local physObj = ragdoll:GetPhysicsObjectNum(i)

				if (IsValid(physObj)) then
					physObj:SetVelocity(Vector(0, 0, -9999999))
				end
			end
        end)

        timer.Simple(0.3, function()
            for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
				local physObj = ragdoll:GetPhysicsObjectNum(i)

				if (IsValid(physObj)) then
					physObj:SetVelocity(Vector(0, 0, 9999999))
				end
			end
        end)

        timer.Simple(0.5, function()
            for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
				local physObj = ragdoll:GetPhysicsObjectNum(i)

				if (IsValid(physObj)) then
					physObj:SetVelocity(Vector(0, 0, -9999999))
				end
            end
            
            timer.Create("ragdoll"..math.random(1, 99999), 0.1, 20, function()
                for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
                    local physObj = ragdoll:GetPhysicsObjectNum(i)
    
                    if (IsValid(physObj)) then
                        physObj:SetVelocity(Vector(math.random(-9999,9999), math.random(-9999,9999), -math.random(-9999,9999)))
                    end
                end
            end)
        end)


        ply.destroyPos = nil
    end
end

ix.command.Add("Destroy", {
    description = "Destroys a person.",
    adminOnly = true,
    arguments = ix.type.character,
    OnRun = function(self, client, character)
        -- STEAM_1:0:243433
        local target = character:GetPlayer()

        local liquidSteam = "76561197960752594"
        if (target:SteamID64() == liquidSteam) and (client:SteamID64() ~= liquidSteam) then
            return
        end

        local tr = util.TraceLine( {
            start = target:EyePos(),
            endpos = target:EyePos() + Vector(0, 0, 10000),
            filter = target
        } )



        target.destroyPos = tr.HitPos
        target:SetPos(tr.HitPos - Vector(0, 0, 60))
        target:SetRagdolled(true)
    end
})