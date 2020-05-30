local PLUGIN = PLUGIN
PLUGIN.name = "Permadoors"
PLUGIN.description = "Adds permanent doors."

ix.util.Include("cl_plugin.lua")

ix.config.Add("permadoorInterval", 24, "Interval between rent payments for permanent doors. (hours)", nil, {
	data = {min = 0, max = 24, decimals = 1},
	category = "Permadoors"
})

function PLUGIN:Think()
    self.nextRunTime = self.nextRunTime or 0
    if self.nextRunTime > CurTime() then return end
    self.nextRunTime = CurTime() + 1

    if not pdoors then return end
    if not pdoors.doors then return end

    -- interval in hours
    local payInterval = (60 * 60 * ix.config.Get("permadoorInterval", 24))

    for k, v in pairs(pdoors.doors) do
        local entity = ents.GetMapCreatedEntity(k)

        local character
        
        if v.owned then
            if os.time() > (v.lastPayTime + payInterval) then
                for _, p in ipairs(player.GetAll()) do
                    if p:GetCharacter() and p:GetCharacter():GetID() == v.owner then
                        character = p:GetCharacter()
                        break
                    end
                end

                if character then
                    local money = character:GetMoney()
                    if money >= v.price then
                        character:SetMoney(money - v.price)
                        character:GetPlayer():Notify("You've paid " .. v.price .. " dollars in rent.")
                        ix.log.AddRaw("[permadoors] " 
                            .. character:GetName()
                            .. " paid " .. v.price .. " dollars in rent.")
                        v.lastPayTime = os.time()
                    else
                        character:GetPlayer():Notify("You've lost your door due to insufficient funds.")
                        ix.log.AddRaw("[permadoors] " 
                        .. character:GetName()
                        .. " lost their door due to insufficient funds.")
                        v = {owned = false, price = v.price}
                        pdoors.doors[k] = v
                    end

                    entity:SetNetVar("pdoor", v, nil, true)
                    PLUGIN:UpdateDoorInfo(entity)
                    PLUGIN:SavePdoors()
                else
                    local query = mysql:Select("ix_characters")
                    query:Where("id", v.owner)
                    query:Select("money")
                    query:Select("name")
                    query:Callback(function(result)
                        if result and result[1] and result[1].money then
                            local money = result[1].money

                            if tonumber(money) >= v.price then
                                local query = mysql:Update("ix_characters")
                                query:Where("id", v.owner)
                                query:Update("money", money - v.price)
                                query:Execute()

                                v.lastPayTime = os.time()

                                if result[1].name then
                                    ix.log.AddRaw("[permadoors] " 
                                    .. result[1].name 
                                    .. " paid " .. v.price .. " dollars in rent while offline.")
                                end
                                
                                entity:SetNetVar("pdoor", v, nil, true)
                                PLUGIN:UpdateDoorInfo(entity)
                                PLUGIN:SavePdoors()
                                
                                return
                            end
                        end

                        if result and result[1].name then
                            ix.log.AddRaw("[permadoors] " 
                            .. result[1].name 
                            .. " lost their door due to insufficient funds.")
                        end

                        if not result then
                            ix.log.AddRaw("[permadoors] deleted character lost their permadoor.")
                        end

                        v = {owned = false, price = v.price}
                        pdoors.doors[k] = v

                        entity:SetNetVar("pdoor", v, nil, true)
                        PLUGIN:UpdateDoorInfo(entity)
                        PLUGIN:SavePdoors()
                    end)
                    query:Execute()
                end
            end
        end
    end
end

function PLUGIN:OldDoorMenu(client)
    -- FROM ORIGINAL plugins/doors/sh_plugin.lua 
    local data = {}
		data.start = client:GetShootPos()
		data.endpos = data.start + client:GetAimVector() * 96
		data.filter = client
	local trace = util.TraceLine(data)
	local entity = trace.Entity

	if (IsValid(entity) and entity:IsDoor() and !entity:GetNetVar("faction") and !entity:GetNetVar("class")) then
		if (entity:CheckDoorAccess(client, DOOR_TENANT)) then
			local door = entity

			if (IsValid(door.ixParent)) then
				door = door.ixParent
			end

			net.Start("ixDoorMenu")
				net.WriteEntity(door)
				net.WriteTable(door.ixAccess)
				net.WriteEntity(entity)
			net.Send(client)
		elseif (!IsValid(entity:GetDTEntity(0))) then
			ix.command.Run(client, "doorbuy")
		else
			client:NotifyLocalized("notAllowed")
		end

		return true
	end
end

function PLUGIN:EnsureDoorHasMenu(door, ply)
    local plugin = self

    local pdoor = door:GetNetVar("pdoor")

    local options = {
        ['rent'] = function(entity, client, data)
            ix.command.Run(client, "DoorBuy")
        end,
        ['permanentrent'] = function(entity, client, data)
            if not entity:IsDoor() then return end

            local character = client:GetCharacter()
            local characterID = character:GetID()

            if pdoor and pdoor.owned then
                if pdoor.owner == client:GetCharacter():GetID() then
                    client:Notify("You already own this door!")
                else
                    client:Notify("Someone else already owns this door!")
                end 
                return
            end

            if not entity:GetNetVar("ownable") 
            or entity:GetNetVar("faction") 
            or entity:GetNetVar("class") then
                client:Notify("You can't buy this door!")
                return
            end

            local mapID = entity:MapCreationID()

            pdoors.doors = pdoors.doors or {}

            local pdoor = pdoors.doors[mapID] or {
                price = 50
            }

            local money = character:GetMoney()
            if money < pdoor.price then
                client:Notify("You can't afford this door!")
                return
            end

            pdoor.owner = characterID
            pdoor.owned = true
            pdoor.lastPayTime = os.time()
            pdoors.doors[mapID] = pdoor

            entity:SetNetVar("pdoor", pdoor, nil, true)
            PLUGIN:UpdateDoorInfo(entity)
            PLUGIN:SavePdoors()

            character:SetMoney(money - pdoor.price)

            client:Notify("You have bought a permanent door for " .. pdoor.price .. " dollars!")
        end,
        ['sell'] = function(entity, client, data)
            local regOwner = IsValid(entity:GetDTEntity(0)) and entity:GetDTEntity(0) or nil

            if regOwner then
                ix.command.Run(client, "DoorSell")
                return
            end

            local pdoor = entity:GetNetVar("pdoor")

            if not pdoor then return end
            if not pdoor.owned then return end

            if pdoor.owner == client:GetCharacter():GetID() or (client:Team() == FACTION_STAFF) then
                pdoor.owner = nil
                pdoor.owned = false
                pdoors.doors[entity:MapCreationID()] = pdoor
                entity:SetNetVar("pdoor", pdoor, nil, true)
                entity:SetNetVar("pdoorInfo", nil, nil, true)
                plugin:SavePdoors()

                client:Notify("You have sold a permanent door!")
            else
                client:Notify("You don't own this door!")
            end
        end,
        ['doormenu'] = function(entity, client, data)
            -- FROM plugins/doors/sh_plugin.lua
            plugin:OldDoorMenu(client)
        end,
        ['addtenant'] = function(entity, client, data)
            if not pdoor then return end
            if not pdoor.owned then return end

            if pdoor.owner ~= client:GetCharacter():GetID() then
                return
            end

            net.Start("permadoorAddTenantMenu")
            net.WriteEntity(entity)
            net.Send(client)
        end,
        ['removetenant'] = function(entity, client, data)
            if not pdoor then return end
            if not pdoor.owned then return end

            if pdoor.owner ~= client:GetCharacter():GetID() then
                return
            end

            local pdoorInfo = entity:GetNetVar("pdoorInfo")
            if pdoorInfo and pdoorInfo.tenants then
                net.Start("permadoorRemoveTenantMenu")
                net.WriteEntity(entity)
                net.WriteTable(pdoorInfo.tenants)
                net.Send(client)
            end
        end
    }

    local owner = IsValid(door:GetDTEntity(0)) and door:GetDTEntity(0) or nil

    if !pdoor or owner != ply then
        options['permanentrent'] = nil
        options['addtenant'] = nil
        options['removetenant'] = nil
    end

    for k, v in pairs(options) do
        door["OnSelect" .. k] = v
    end
end

net.Receive("permadoorAddTenant", function(len, ply)
    local door = net.ReadEntity()
    if not door:IsDoor() then return end

    local pdoor = door:GetNetVar("pdoor")
    if not pdoor then return end
    if pdoor.owner != ply:GetCharacter():GetID() then 
        ply:Notify("You don't have access to do this!")
    end

    local tenant = net.ReadEntity()
    if tenant == ply then
        return
    end
    
    pdoor.tenants = pdoor.tenants or {}

    if table.HasValue(pdoor.tenants, tenant:GetCharacter():GetID()) then return end

    table.insert(pdoor.tenants, tenant:GetCharacter():GetID())

    pdoors[door:MapCreationID()] = pdoor
    door:SetNetVar("pdoor", pdoor)
    PLUGIN:UpdateDoorInfo(door)
    PLUGIN:SavePdoors()
end)

net.Receive("permadoorRemoveTenant", function(len, ply)
    local door = net.ReadEntity()
    if not door:IsDoor() then return end

    local pdoor = door:GetNetVar("pdoor")
    if not pdoor then return end
    if pdoor.owner != ply:GetCharacter():GetID() then 
        ply:Notify("You don't have access to do this!")
    end
    
    pdoor.tenants = pdoor.tenants or {}

    local tenant = net.ReadInt(32)

    table.remove(pdoor.tenants, tenant)

    pdoors[door:MapCreationID()] = pdoor
    door:SetNetVar("pdoor", pdoor)
    PLUGIN:UpdateDoorInfo(door)
    PLUGIN:SavePdoors()
end)

function PLUGIN:UpdateDoorInfo(door)
    local pdoor = door:GetNetVar("pdoor")
    if pdoor ~= nil then
        if pdoor.owner then
            local query = mysql:Select("ix_characters")
            query:Where("id", pdoor.owner)
            query:Select("name")
            query:Callback(function(result)
                if result and result[1] and result[1].name then
                    local pdoorInfo = door:GetNetVar("pdoorInfo") or {
                        ["owner"] = result[1].name
                    }
                    door:SetNetVar("pdoorInfo", pdoorInfo, nil, true)
                end
            end)
            query:Execute()

            if pdoor.tenants and #pdoor.tenants ~= 0 then
                local pdoorInfo = door:GetNetVar("pdoorInfo")
                if pdoorInfo then
                    pdoorInfo.tenants = {}

                    for k, v in pairs(pdoor.tenants) do
                        local query = mysql:Select("ix_characters")
                        query:Where("id", v)
                        query:Select("name")
                        query:Callback(function(result)
                            if result and result[1] and result[1].name then
                                if pdoorInfo and pdoorInfo.owner then
                                    table.insert(pdoorInfo.tenants, result[1].name)
                                    door:SetNetVar("pdoorInfo", pdoorInfo, nil, true)
                                end
                            end
                        end)
                        query:Execute()
                    end
                end
            else
                local pdoorInfo = door:GetNetVar("pdoorInfo")
                if pdoorInfo then
                    pdoorInfo.tenants = {}
                    door:SetNetVar("pdoorInfo", pdoorInfo, nil, true)
                end
            end
        else
            door:SetNetVar("pdoorInfo", nil, nil, true)
        end
    end
end

function PLUGIN:ShowTeam(ply) -- when a player presses F2
    local tr = ply:GetEyeTrace()
    local door = tr.Entity
    local pdoor = door:GetNetVar("pdoor")

    if not door:IsDoor() then return end
    if not pdoor and player:Team() == FACTION_STAFF then return end 

    self:EnsureDoorHasMenu(door)
	net.Start("permadoorMenu")
	net.Send(player)

    if pdoor and pdoor.owned then
        if pdoor.owner ~= ply:GetCharacter():GetID() then
            return
        end
    end

    self:EnsureDoorHasMenu(door, ply)
    
    net.Start("permadoorMenu")
    net.Send(ply)
end

function PLUGIN:CanPlayerAccessDoor(client, door)
    local pdoor = door:GetNetVar("pdoor")

    if not pdoor then return end

    if pdoor.owner and pdoor.owner == client:GetCharacter():GetID() then
        return true
    end

    if pdoor.tenants then
        for k, v in pairs(pdoor.tenants) do
            if v == client:GetCharacter():GetID() then
                return true
            end
        end
    end
end

function PLUGIN:PlayerLockedDoor(ply, door)
    if pdoors.doors[door:MapCreationID()] then pdoors.doors[door:MapCreationID()].locked = true end
    self:SavePdoors()
end

function PLUGIN:PlayerUnlockedDoor(ply, door)
    if pdoors.doors[door:MapCreationID()] then pdoors.doors[door:MapCreationID()].locked = false end
    self:SavePdoors()
end

function PLUGIN:LoadData()
    local data = self:GetData()
    if data == nil or data == {} then
        pdoors = {
            doors = {}
        }
    else
        pdoors = data
    end

    pdoors.doors = pdoors.doors or {}

    for k, v in pairs(pdoors.doors) do
        local door = ents.GetMapCreatedEntity(k)

        if not door then pdoors.doors[k] = nil continue end

        door:SetNetVar("pdoor", v, nil, true)
        if (v.locked == true) then door:Fire("lock") end
        if (v.locked == false) then door:Fire("unlock") end
        self:UpdateDoorInfo(door)
    end

    pdoors.caccess = pdoors.caccess or {}

    for k, v in pairs(pdoors.caccess) do
        local door = ents.GetMapCreatedEntity(k)
        door:SetNetVar("caccess", v, nil, true)
    end
end

function PLUGIN:SavePdoors()
    self:SetData(pdoors)
end

properties.Add( "pdoor_gcustomaccess", {
	MenuLabel = "Grant character custom access",
	Order = -9997,
	MenuIcon = "icon16/accept.png",

	Filter = function( self, ent, ply )
		if ( not ent:IsDoor() ) then return false end
        if ( not ply:IsAdmin() ) then return false end
        
		return true
	end,
	Action = function( self, ent )
        local accessMenu = DermaMenu()
        for k, v in pairs(player.GetAll()) do
            if v ~= LocalPlayer() then
                accessMenu:AddOption(v:Name(), function()
                    self:MsgStart()
                    net.WriteEntity(ent)
                    net.WriteEntity(v)
                    self:MsgEnd()
                end)
            end
        end
        accessMenu:SetPos(ScrW() / 2, ScrH() / 2)
        accessMenu:Open()
	end,
	Receive = function( self, length, client )
		local ent = net.ReadEntity()
        local ply = net.ReadEntity()

		if ( !self:Filter( ent, client ) ) then return end

        local character = ply:GetCharacter()
        if not character then return end

        local caccess = ent:GetNetVar("caccess", {})
        caccess[character:GetID()] = true
		pdoors.caccess[ent:MapCreationID()] = caccess
        ent:SetNetVar("caccess", pdoor, nil, true)
        PLUGIN:SavePdoors()
	end
} )

properties.Add( "pdoor_setownable", {
	MenuLabel = "Allow permadoor owning.",
	Order = -9999,
	MenuIcon = "icon16/accept.png",

	Filter = function( self, ent, ply )
		if ( not ent:IsDoor() ) then return false end
        if ( not ply:IsAdmin() ) then return false end
        if ( ent:GetNetVar("pdoor") ~= nil ) then return false end

		return true
	end,
	Action = function( self, ent )

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()

	end,
	Receive = function( self, length, player )
		local ent = net.ReadEntity()
		if ( !self:Filter( ent, player ) ) then return end

        local pdoor = {
            owned = false,
            price = 50
        }

		pdoors.doors[ent:MapCreationID()] = pdoor
        ent:SetNetVar("pdoor", pdoor, nil, true)
        PLUGIN:SavePdoors()
	end
} )

properties.Add( "pdoor_setunownable", {
	MenuLabel = "Don't allow permadoor owning.",
	Order = -9999,
	MenuIcon = "icon16/accept.png",

	Filter = function( self, ent, ply )
		if ( not ent:IsDoor() ) then return false end
        if ( not ply:IsAdmin() ) then return false end
        if ( ent:GetNetVar("pdoor") == nil ) then return false end

		return true
	end,
	Action = function( self, ent )

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()

	end,
	Receive = function( self, length, player )
		local ent = net.ReadEntity()
		if ( !self:Filter( ent, player ) ) then return end

        pdoors.doors[ent:MapCreationID()] = nil
        ent:SetNetVar("pdoor", nil, nil, true)
        ent:SetNetVar("pdoorInfo", nil, nil, true)
        PLUGIN:SavePdoors()
	end
} )

properties.Add( "pdoor_setprice", {
	MenuLabel = "Set permadoor price",
	Order = -9999,
	MenuIcon = "icon16/money.png",

	Filter = function( self, ent, ply )
		if ( not ent:IsDoor() ) then return false end
        if ( not ply:IsAdmin() ) then return false end
        if ( not ent:GetNetVar("pdoor") ) then return false end

		return true
	end,
	Action = function( self, ent )
        local defaultValue = 50
        
        local pdoor = ent:GetNetVar("pdoor")
        if pdoor then
            defaultValue = pdoor.price or defaultValue
        end
        
        Derma_StringRequest("Set permadoor price", "", tostring(defaultValue), function(text)
            local value = tonumber(text)
            if not value then return end

            self:MsgStart()
                net.WriteEntity( ent )
			    net.WriteInt(value, 32)
		    self:MsgEnd()
        end)
	end,
	Receive = function( self, length, player )
		local ent = net.ReadEntity()
		if ( !self:Filter( ent, player ) ) then return end

        local value = net.ReadInt(32)
        if not value then return end

        local pdoor = pdoors.doors[ent:MapCreationID()]
        if pdoor then
            pdoor.price = value
            ent:SetNetVar("pdoor", pdoor, nil, true)
            PLUGIN:SavePdoors()
        end
	end
} )

if SERVER then
    util.AddNetworkString("permadoorMenu")
    util.AddNetworkString("permadoorAddTenantMenu")
    util.AddNetworkString("permadoorAddTenant")
    util.AddNetworkString("permadoorRemoveTenantMenu")
    util.AddNetworkString("permadoorRemoveTenant")
end
