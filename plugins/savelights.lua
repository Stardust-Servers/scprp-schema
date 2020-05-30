local PLUGIN = PLUGIN

PLUGIN.name = "Save Lights"
PLUGIN.description = "Saves advanced light entities."
PLUGIN.saveTable = {
    ["cheap_light"] = {
        "ActiveState",
        "DrawHelper",
        "DrawSprite",
        "LightModels",
        "LightWorld",
        "LightSize",
        "Bightness",
        "LightStyle",
        "LightColor",
        "DisableDuringDay"
    },
    ["expensive_light"] = {
        "ActiveState",
        "DrawHelper",
        "DrawSprite",
        "LightWorld",
        "Shadows",
        "Brightness",
        "FarZ",
        "NearZ",
        "LightColor",
        "DisableDuringDay"
    },
    ["expensive_light_new"] = {
        "ActiveState",
        "DrawHelper",
        "DrawSprite",
        "Shadows",
        "Brightness",
        "FarZ",
        "NearZ",
        "LightColor",
        "DisableDuringDay"
    },
    ["projected_light"] = {
        "ActiveState",
        "DrawHelper",
        "DrawSprite",
        "LightWorld",
        "Shadows",
        "Brightness",
        "FarZ",
        "LightFOV",
        "NearZ",
        "LightTexture",
        "LightColor",
        "DisableDuringDay"
    },
    ["projected_light_new"] = {
        "ActiveState",
        "DrawHelper",
        "DrawSprite",
        "Orthographic",
        "Shadows",
        "Brightness",
        "FarZ",
        "LightFOV",
        "NearZ",
        "OrthoBottom",
        "OrthoLeft",
        "OrthoRight",
        "OrthoTop",
        "LightTexture",
        "LightColor",
        "DisableDuringDay"
    },
    ["spot_light"] = {
        "ActiveState",
        "DrawHelper",
        "DrawSprite",
        "LightModels",
        "LightWorld",
        "Distance",
        "InnerFOV",
        "OuterFOV",
        "Radius",
        "LightStyle",
        "LightColor",
        "DisableDuringDay"
    }
}

function PLUGIN:LoadData()
    local data = self:GetData() or {}

    for _, v in pairs(data) do
        local ent = ents.Create(v.classname)
        ent:SetPos(v.pos)
        ent:SetAngles(v.angs)

        for lightKey, lightValue in pairs(v.lightData) do
            local func = ent["Set" .. lightKey]

            if func ~= nil and isfunction(func) then
                func(ent, lightValue)
            end
        end

        ent:Spawn()
    end
end

function PLUGIN:SaveData()
    local data = {}

    for k, v in pairs(self.saveTable) do
        for _, ent in pairs(ents.FindByClass(k)) do
            local lightData = {}

            for _, lightKey in pairs(v) do
                local func = ent["Get" .. lightKey]

                if func ~= nil and isfunction(func) then
                    lightData[lightKey] = func(ent)
                end
            end

            table.insert(data, {
                classname = k,
                pos = ent:GetPos(),
                angs = ent:GetAngles(),
                lightData = lightData
            })
        end
    end

    self:SetData(data)
end

function PLUGIN:CanProperty(client, property, entity)
	if property == "persist" then
        for k, _ in pairs(PLUGIN.saveTable) do
            if entity:GetClass() == k then
                return false
            end
        end
	end
end

if SERVER then
    function PLUGIN:Think()
        self.nextRunTime = self.nextRunTime or 0
        if self.nextRunTime > CurTime() then return end
        self.nextRunTime = CurTime() + 1

        local time = AtmosGlobal:GetTime()
        local isDayTime = time >= 7 and time <= 19

        for k, _ in pairs(self.saveTable) do
            for _, v in pairs(ents.FindByClass(k)) do
                if isfunction(v.GetDisableDuringDay) then
                    if v:GetDisableDuringDay() then
                        v:SetActiveState(not isDayTime)
                    end
                end
            end
        end
    end
end