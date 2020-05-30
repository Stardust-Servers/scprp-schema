-- use GM:OnEntityWaterLevelChanged in the future when it's released
PLUGIN:AddStatus("wet", {
    description = 'Seems to be wet',
    useExpire = true,
    expireTime = 60 * 4,
    canExpire = function(ply, char)
        if ply:WaterLevel() == 0 then
            return true
        end
    end
    --[[kill = function(ply, char)
        if ply:WaterLevel() ~= 0 then
            return true
        end
    end]]
})

PLUGIN:AddStatus("smell", {
    description = 'Smells foul',
    useExpire = true,
    expireTime = 60 * 8,
    canExpire = function(ply, char)
        return true
    end
})

PLUGIN:AddStatus("hungry", {
    description = 'Appears visibly hungry',
    useExpire = false
})

PLUGIN:AddStatus("thirsty", {
    description = 'Appears visibly thirsty',
    useExpire = false
})