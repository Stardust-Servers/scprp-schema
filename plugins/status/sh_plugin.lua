PLUGIN.name = "Status System"
PLUGIN.author = "liquid"
PLUGIN.description = "Adds an advanced and configurable status system."

PLUGIN.statusList = PLUGIN.statusList or {}

function PLUGIN:AddStatus(name, config)
    self.statusList[name] = config
end

local charMeta = ix.meta.character

function charMeta:GetStatusList()
    return self:GetPlayer():GetNetVar("statusList", {})
end

function charMeta:HasStatus(name)
    return self:GetPlayer():GetStatusList()[name]
end

ix.config.Add("hungerStatusThreshold", 25, "", nil, {
    data = {min = 1, max = 100},
    category = "Status System"
})

ix.config.Add("thirstStatusThreshold", 25, "", nil, {
    data = {min = 1, max = 100},
    category = "Status System"
})

if SERVER then
    function charMeta:GiveStatus(name)
        local statusList = self:GetData("statusList", {})
        statusList[name] = {
            startTime = self:GetStatusTimePlayed()
        }
        self:SetData("statusList", statusList)
        self:GetPlayer():SetNetVar("statusList", statusList)
    end

    function charMeta:TakeStatus(name)
        local statusList = self:GetData("statusList", {})
        statusList[name] = nil
        self:SetData("statusList", statusList)
        self:GetPlayer():SetNetVar("statusList", statusList)
    end

    function charMeta:ClearStatuses()
        self:SetData("statusList", statusList)
        self:GetPlayer():SetNetVar("statusList", statusList)
    end

    function charMeta:GetStatusTimePlayed()
        return self:GetData("statusTimePlayed", 0)
    end

    function charMeta:SetStatusTimePlayed(timePlayed)
        return self:SetData("statusTimePlayed", timePlayed)
    end

    --[[ 
        we need to accurately control statuses based on the character's played time,
        so that they can leave/rejoin per character and the status will still behave normally
    --]]
    function PLUGIN:Think()
        --self.nextThink = self.nextThink or CurTime() + 1
        --if (CurTime() < self.nextThink) then return end
--
        --self.nextThink = CurTime() + 1
--
        --for _, v in ipairs(player.GetAll()) do
        --    local character = v:GetCharacter()
        --    
        --    if not character then continue end
        --    
        --    local statusTimePlayed = character:GetStatusTimePlayed() + 1
        --    character:SetStatusTimePlayed(statusTimePlayed)
--
        --    for statusName, charStatus in pairs(character:GetStatusList()) do
        --        local status = self.statusList[statusName]
        --        if not status then character:TakeStatus(name) continue end
--
        --        if status.useExpire 
        --        and statusTimePlayed > charStatus.startTime + status.expireTime then
        --            if status.canExpire(v, character) == true then
        --                character:TakeStatus(statusName)
        --            end--elseif (not status.dontReset) then
        --            --    -- overrides the old status, resetting the time
        --            --    character:GiveStatus(statusName)
        --            --end
        --        end
        --    end
--
        --    -- don't do any of these if they're in noclip
        --    if v:GetMoveType() == MOVETYPE_NOCLIP then
        --        return
        --    end
--
        --    -- wet status
        --    if (v:WaterLevel() != 0) then
        --        character:GiveStatus("wet")
        --    end
--
        --    -- smelly status
        --    --if (v.inToxicGas) then
        --    --    character:GiveStatus("smell")
        --    --end
--
        --    local hunger = character:GetHunger()
        --    local thirst = character:GetThirst()
--
        --    if hunger ~= nil then
        --        if character:GetHunger() <= ix.config.Get("hungerStatusThreshold") then
        --            character:GiveStatus("hungry")
        --        else
        --            character:TakeStatus("hungry")
        --        end
        --    end
--
        --    if thirst ~= nil then
        --        if character:GetThirst() <= ix.config.Get("thirstStatusThreshold") then
        --            character:GiveStatus("thirsty")
        --        else
        --            character:TakeStatus("thirsty")
        --        end
        --    end
        --end
    end

    function PLUGIN:PlayerLoadedCharacter(client, character)
        client:SetNetVar("statusList", character:GetData("statusList", {}))
    end
end

ix.util.Include("sh_statuses.lua")

function PLUGIN:InitializedPlugins()
    hook.Call("PopulateStatusList", self)
end

function PLUGIN:PopulateCharacterInfo(client, character, container)
    local statusList = character:GetStatusList()
    
    for statusName, _ in pairs(statusList) do
        local status = self.statusList[statusName]
        if not status then continue end

        local name = container:AddRow("status_" .. statusName)
        name:SetText(status.description)
        name:SetBackgroundColor(Color(255, 255, 255))
        name:SizeToContents()
    end
end

-- config