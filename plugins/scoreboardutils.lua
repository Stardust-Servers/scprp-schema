PLUGIN.name = "Scoreboard Utilities"
PLUGIN.description = "Adds various admin capabilities to the scoreboard."

hook.Add("PopulateScoreboardPlayerMenu", "scoreboard_utils", 
function(client, menu)
    if (LocalPlayer():IsAdmin()) then
        menu:AddOption("Set name", function()
            Derma_StringRequest(
                "Set name",
                "",
                client:GetName(),
                function( text ) 
                    RunConsoleCommand("ix", "CharSetName", client:GetName(), text) 
                end
            )
        end)
        menu:AddOption("Set model (browse)", function()
            pace.AssetBrowser(function(path) 
                RunConsoleCommand("ix", "CharSetModel", client:GetName(), path) 
            end, "models")
        end)
        menu:AddOption("Set model (text)", function()
            Derma_StringRequest(
                "Set model",
                "",
                client:GetModel(),
                function( text ) 
                    RunConsoleCommand("ix", "CharSetModel", client:GetName(), text) 
                end
            )
        end)
        menu:AddOption("Set description", function()
            Derma_StringRequest(
                "Set description",
                "",
                client:GetCharacter():GetDescription(),
                function( text )
                    RunConsoleCommand("ix", "CharSetDesc", client:GetName(), text)
                end
            )
        end)

        local submenuWhitelist = menu:AddSubMenu("Whitelist")
        local submenuUnwhitelist = menu:AddSubMenu("Unwhitelist")

        local whitelists = client:GetData("whitelists", {})
        whitelists[Schema.folder] = whitelists[Schema.folder] or {}

        for _, v in ipairs(ix.faction.indices) do
            local hasWhitelist = whitelists[Schema.folder][v.uniqueID] == true
            if (not v.isDefault) then
                submenuWhitelist:AddOption( v.name, function() 
                    RunConsoleCommand( "ix", "PlyWhitelist", client:GetName(), v.name ) 
                end )
            end
        end

        for _, v in ipairs(ix.faction.indices) do
            local hasWhitelist = whitelists[Schema.folder][v.uniqueID] == true
            if (not v.isDefault) then
                submenuUnwhitelist:AddOption( v.name, function() 
                    RunConsoleCommand( "ix", "PlyUnwhitelist", client:GetName(), v.name ) 
                end )
            end
        end
        
        local transfer = menu:AddSubMenu("Transfer")
        for k, v in ipairs(ix.faction.indices) do
            if k ~= client:GetCharacter():GetFaction() then
                transfer:AddOption( v.name, function() 
                    RunConsoleCommand( "ix", "PlyTransfer", client:GetName(), v.name ) 
                end )
            end
        end

        local giveFlag = menu:AddSubMenu("Give flag")
        for k, v in pairs(ix.flag.list) do
            if client:GetCharacter():HasFlags(k) ~= true then
                giveFlag:AddOption( k .. " - " .. v.description, function() 
                    RunConsoleCommand( "ix", "CharGiveFlag", client:GetName(), k ) 
                end )
            end
        end

        local takeFlag = menu:AddSubMenu("Take flag")
        for k, v in pairs(ix.flag.list) do
            if client:GetCharacter():HasFlags(k) == true then
                takeFlag:AddOption( k .. " - " .. v.description, function() 
                    RunConsoleCommand( "ix", "CharTakeFlag", client:GetName(), k ) 
                end )
            end
        end

        --[[for _, v in ipairs(ix.faction.indices) do
            submenuWhitelist:AddOption( v.name, function() 
                RunConsoleCommand( "ix", "PlyWhitelist", client:GetName(), v.name ) 
            end )
        end--]]
        --[[menu:AddOption("Unwhitelist from faction", function()
            local ctxmenu = DermaMenu()
            for _, v in ipairs(ix.faction.indices) do
                print(v.name)
                ctxmenu:AddOption( v.name, function() 
                    RunConsoleCommand( "ix", "PlyUnwhitelist", client:GetName(), v.name ) 
                end )
			end
            ctxmenu:Open()
        end)]]
        menu:AddOption("Ban character (permakill)", function()
            RunConsoleCommand("ix", "CharBan", client:GetName())
        end)
        menu:AddOption("Goto", function()
            RunConsoleCommand("ulx", "goto", client:GetName())
        end)
        menu:AddOption("Bring", function()
            RunConsoleCommand("ulx", "bring", client:GetName())
        end)
        menu:AddOption("Force fall over", function()
            RunConsoleCommand("ix", "ForceFallOver", client:GetName())
        end)
        menu:AddOption("Force get up", function()
            RunConsoleCommand("ix", "ForceGetUp", client:GetName())
        end)
        menu:AddOption("Restore last inventory", function()
            RunConsoleCommand("ix", "RestoreLastInv", client:GetName())
        end)
        menu:AddOption("Undo last death", function()
            RunConsoleCommand("ix", "UndoDeath", client:GetName())
        end)
        

        --[[
            for _, v in ipairs(ix.faction.indices) do
				if (ix.util.StringMatches(L(v.name, client), name) or ix.util.StringMatches(v.uniqueID, name)) then
					faction = v

					break
				end
			end
        ]]
    end
end)