local PLUGIN = PLUGIN
PLUGIN.name = "Toolgun Restictor"
PLUGIN.description = "Restricts access to STOOLs."

ix.flag.Add("w", "Access to wiremod tools.")

function PLUGIN:CanTool(ply, tr, tool)
    if string.sub(tool, 0, 5) == "wire_" then
        local character = ply:GetCharacter()
        return --[[ply:IsAdmin() or]] (character and character:HasFlags("w"))
    end
end