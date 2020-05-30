
local PLAYER = FindMetaTable("Player")

function PLAYER:IsFoundation()
	return self:Team() == FACTION_SECURITY or self:Team() == FACTION_RESEARCHER or self:Team() == FACTION_ENGINEER or self:Team() == FACTION_MTF
end
