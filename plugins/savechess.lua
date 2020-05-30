PLUGIN.name = "Save Game Boards"
PLUGIN.description = "Saves game boards."
PLUGIN.classes = {
    "ent_chess_board",
    "ent_draughts_board"
}

function PLUGIN:LoadData()
    local data = self:GetData() or {}

    for _, entry in pairs(data) do
        local ent = ents.Create(entry[1])
        ent:SetPos(entry[2])
        ent:SetAngles(entry[3])
        ent:Spawn()

        --ent.TableEnt:SetPos(entry[4])
        --ent.TableEnt:SetAngles(entry[5])
        ent.WhiteSeat:SetPos(entry[4])
        ent.WhiteSeat:SetAngles(entry[5])
        ent.BlackSeat:SetPos(entry[6])
        ent.BlackSeat:SetAngles(entry[7])
    end
end

function PLUGIN:SaveData()
    local data = {}

    for _, class in pairs(self.classes) do
        for _, v in pairs(ents.FindByClass(class)) do
            table.insert(data, {
                class,
                v.TableEnt:GetPos(),
                v.TableEnt:GetAngles(),
                --v:GetAngles(),
                --v.TableEnt:GetPos(),
                --v.TableEnt:GetAngles(),
                v.WhiteSeat:GetPos(),
                v.WhiteSeat:GetAngles(),
                v.BlackSeat:GetPos(),
                v.BlackSeat:GetAngles()
            })
        end
    end

    self:SetData(data)
end

function PLUGIN:CanProperty(client, property, entity)
	if property == "persist" 
	and entity.IsChessEntity then
		return false
	end
end