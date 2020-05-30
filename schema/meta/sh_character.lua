
-- In some cases you'll want to extend the metatables of a few classes. The standard way of doing so is to place your
-- extensions/overrides in the meta/ folder where each file pertains to one class.

local CHAR = ix.meta.character

function CHAR:IsFoundation()
	f = self:GetFaction()
	return f == FACTION_SECURITY or f == FACTION_RESEARCHER or f == FACTION_ENGINEER or f == FACTION_MTF
end