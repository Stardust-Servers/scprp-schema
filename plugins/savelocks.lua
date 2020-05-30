PLUGIN.name = "Save Locks"
PLUGIN.description = "Saves locked doors."

function PLUGIN:LoadData()
    local data = self:GetData() or {}

    for id, locked in pairs(data) do
        local ent = ents.GetMapCreatedEntity(id)
        
        if IsValid(ent) and ent:IsDoor() then
            ent:Fire(locked and "Lock" or "Unlock")
        end
    end
end

function PLUGIN:SaveData()
    local data = {}

    for _, v in pairs(ents.GetAll()) do
        if v:IsDoor() then
            local saveTable = v:GetSaveTable()
            if not saveTable then continue end

            local locked = saveTable.m_bLocked
            data[v:MapCreationID()] = locked
        end
    end

    self:SetData(data)
end