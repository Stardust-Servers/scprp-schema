
local PLUGIN = PLUGIN

PLUGIN.name = "Business Flags"
PLUGIN.author = "liquid"
PLUGIN.description = "Configures the business tab and adds flags."

-- dear sonny:

-- ON EACH SH_ITEM.LUA YOU MUST PUT A PRICE:
--  ITEM.price = 1234

-- "v" flag: light blackmarket
-- "V" flag: heavy blackmarket

-- format:
--  ["item id"] = "flag"

BUSINESS_ITEMS = {
    ["flashlight"] = "v",
    ["zip_tie"] = "v",
    ["crowbar"] = "v",
    ["smallbattery"] = "v",
    ["bandage"] = "v",
    ["rustyshiv"] = "v",
    ["backpack"] = "v",
    ["airfilter"] = "v",
    
    ["resistance_uniform"] = "v",
    ["pistol"] = "v",
    ["smg1"] = "V",
    ["357"] = "V",
    ["shotgun"] = "V",
    ["crossbow"] = "V",
    ["gasmask"] = "v",
    ["emptool"] = "V",
    ["shotgunammo"] = "V",

    ["357ammo"] = "V",
    ["pistolammo"] = "v",
    ["smg1ammo"] = "V",
    ["crossbowammo"] = "V"
}

function PLUGIN:CanPlayerUseBusiness(client, uniqueID)
    local flag = BUSINESS_ITEMS[uniqueID]

    if flag ~= nil then
        if client:GetCharacter():HasFlags(flag) == true then
            return true
        end
    end

    return false
end