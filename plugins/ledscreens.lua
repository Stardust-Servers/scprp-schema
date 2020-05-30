PLUGIN.name = "Save LED Screens"
PLUGIN.description = "Saves LED screens."

function PLUGIN:LoadData()
    local data = self:GetData() or {}

    for _, v in pairs(data) do
        local sign = ents.Create("gb_rp_sign")

        sign:SetPos(v[1])
        sign:SetAngles(v[2])

        sign:Spawn()
        sign:SetMoveType(MOVETYPE_NONE)

        sign:SetText(v[3])
        sign:SetTColor(v[4])
        sign:SetType(v[5])
        sign:SetSpeed(v[6])
        sign:SetWide(v[7])
        sign:SetOn(v[8])
        sign:SetFX(v[9])
        sign:SetCollisionGroup(v[10])
    end
end

function PLUGIN:SaveData()
    local data = {}

    for _, v in pairs(ents.GetAll()) do
        if v:GetClass() == "gb_rp_sign" then
            table.insert(data, {
                v:GetPos(),
                v:GetAngles(),
                v:GetText(),
                v:GetTColor(),
                v:GetType(),
                v:GetSpeed(),
                v:GetWide(),
                v:GetOn(),
                v:GetFX(),
                v:GetCollisionGroup()
            })
        end
    end

    self:SetData(data)
end

function PLUGIN:CanProperty(client, property, entity)
	if property == "persist" 
	and entity:GetClass() == "gb_rp_sign" then
		return false
	end
end