local PLUGIN = PLUGIN
PLUGIN.name = "PAC3 Flag"
PLUGIN.desc = "Adds a flag for PAC3 access."

ix.flag.Add("P", "Access to PAC3.")

function PLUGIN:PrePACEditorOpen()
    if not LocalPlayer():GetCharacter():HasFlags("P") then
        return false
    end
end

function PLUGIN:pac_CanWearParts(ply, outfit)
    if not ply then return end
    if not ply:GetCharacter() then return end

    if not ply:GetCharacter():HasFlags("P") then
        return false
    end
end