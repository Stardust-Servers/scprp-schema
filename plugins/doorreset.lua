local PLUGIN = PLUGIN

PLUGIN.name = "Door Reset"
PLUGIN.description = "Adds a command to reset a door."

ix.command.Add("DoorReset", {
    description = "Resets a door",
    adminOnly = true,
    OnRun = function(self, client)
        local entity = client:GetEyeTrace().Entity

        if not IsValid(entity) or not entity:IsDoor() then
            return
        end

        entity:SetNetVar("class", nil)
        entity:SetNetVar("name", nil)
        entity:SetNetVar("ownable", nil)
        entity:SetNetVar("faction", nil)
        entity:SetNetVar("class", nil)
        entity:SetNetVar("disabled", nil)
    end
})