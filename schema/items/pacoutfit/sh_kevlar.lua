ITEM.name = "Kevlar Vest"
ITEM.description = "A black vest made of kevlar that protects the torso."
ITEM.model = "models/sal/acc/armor01.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.outfitCategory = "armor_torso"
ITEM.pacData = {
    [1] = {
        ["children"] = {
            [1] = {
                ["children"] = {
                },
                ["self"] = {
                    ["Skin"] = 0,
                    ["Invert"] = false,
                    ["LightBlend"] = 1,
                    ["CellShade"] = 0,
                    ["OwnerName"] = "self",
                    ["AimPartName"] = "",
                    ["IgnoreZ"] = false,
                    ["AimPartUID"] = "",
                    ["Passes"] = 1,
                    ["Name"] = "",
                    ["NoTextureFiltering"] = false,
                    ["DoubleFace"] = false,
                    ["PositionOffset"] = Vector(0, 0, 0),
                    ["IsDisturbing"] = false,
                    ["Fullbright"] = false,
                    ["EyeAngles"] = false,
                    ["DrawOrder"] = 0,
                    ["TintColor"] = Vector(0, 0, 0),
                    ["UniqueID"] = "1446396420",
                    ["Translucent"] = false,
                    ["LodOverride"] = -1,
                    ["BlurSpacing"] = 0,
                    ["Alpha"] = 1,
                    ["Material"] = "",
                    ["UseWeaponColor"] = false,
                    ["UsePlayerColor"] = false,
                    ["UseLegacyScale"] = false,
                    ["Bone"] = "spine 2",
                    ["Color"] = Vector(255, 255, 255),
                    ["Brightness"] = 1,
                    ["BoneMerge"] = false,
                    ["BlurLength"] = 0,
                    ["Position"] = Vector(-44.403228759766, 3.466064453125, -0.006591796875),
                    ["AngleOffset"] = Angle(0, 0, 0),
                    ["AlternativeScaling"] = false,
                    ["Hide"] = false,
                    ["OwnerEntity"] = false,
                    ["Scale"] = Vector(1.0499999523163, 1, 1.0249999761581),
                    ["ClassName"] = "model",
                    ["EditorExpand"] = false,
                    ["Size"] = 0.9,
                    ["ModelFallback"] = "",
                    ["Angles"] = Angle(0, 90, 90),
                    ["TextureFilter"] = 3,
                    ["Model"] = "models/sal/acc/armor01.mdl",
                    ["BlendMode"] = "",
                },
            },
        },
        ["self"] = {
            ["DrawOrder"] = 0,
            ["UniqueID"] = "513258946",
            ["AimPartUID"] = "",
            ["Hide"] = false,
            ["Duplicate"] = false,
            ["ClassName"] = "group",
            ["OwnerName"] = "self",
            ["IsDisturbing"] = false,
            ["Name"] = "my outfit",
            ["EditorExpand"] = true,
        },
    }    
}

local defaultArmor = 80

ITEM:PostHook("Equip", function(item)
    local armor = item:GetData("armor")
    if not armor then
        item.player:SetArmor(defaultArmor)
        item:SetData("armor", defaultArmor)
    else
        item.player:SetArmor(math.min(armor, defaultArmor))
    end
end)

ITEM:PostHook("EquipUn", function(item)
    item:SetData(item.player:Armor())
    item.player:SetArmor(0)
end)

ITEM:PostHook("drop", function(item)
    item:SetData(item.player:Armor())
    item.player:SetArmor(0)
end)

-- may be unnecessary but just in case
hook.Add("EntityTakeDamage", "ixKevlarDamage", function(target, dmg)
    if not IsValid(target) then return end
    if not target:IsPlayer() then return end
    if not target.GetCharacter or not target:GetCharacter() then return end
    
    local inventory = target:GetCharacter():GetInventory()
    
    local kevlar = inventory:HasItem("kevlar")
    if kevlar ~= false then
        kevlar:SetData("armor", target:Armor())
    end
end)