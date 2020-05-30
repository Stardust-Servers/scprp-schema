PLUGIN.name = "Save Ammo"
PLUGIN.description = "Saves loaded ammo on switch char/leave."

function PLUGIN:SaveCharacterAmmo(character)
    if not character then return end

    local ply = character:GetPlayer()
    if not ply then return end

    local ammoTable = {}

    local ammoTypes = game.GetAmmoTypes()

    for _, ammoType in pairs(ammoTypes) do
        ammoTable[ammoType] = ply:GetAmmoCount(ammoType)
    end
    
    character:SetData("ammo", ammoTable)
end

function PLUGIN:PrePlayerLoadedCharacter(client, character, currentCharacter)
    if not currentCharacter then return end

    self:SaveCharacterAmmo(currentCharacter)
end

function PLUGIN:PlayerLoadedCharacter(client, character, oldCharacter)
    local ammoTable = character:GetData("ammo", {})

    for k, v in pairs(ammoTable) do
        client:SetAmmo(v, k)
    end
end

function PLUGIN:PlayerDisconnected(ply)
    local char = ply:GetCharacter()
    if not char then return end 
    
    self:SaveCharacterAmmo(char)
end