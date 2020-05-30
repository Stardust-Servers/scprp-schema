local PLUGIN = PLUGIN

PLUGIN.name = "Hide HL2 Crosshair"
PLUGIN.description = "Hides the HL2 Crosshair"

hook.Add("HUDShouldDraw", function(element)
    if element == "CHudCrosshair" then
        return false
    end
end)

hook.Add("PrePlayerDraw", "liquidEyeFix", function(ply)
    local tr = ply:GetEyeTrace()
    if tr ~= nil then
        ply:SetEyeTarget(tr.HitPos)
    end
end)

local firstTime = true

function PLUGIN:PrePlayerDraw(ply)
    -- allows rehooking on code refresh
    if firstTime and ply.flashlightFix then
        ply:RemoveCallback("BuildBonePositions", ply.flashlightFix)
        ply.flashlightFix = nil
        firstTime = false
    end

    if not ply.flashlightFix then
        ply.flashlightFix = ply:AddCallback("BuildBonePositions", function(ent, numbones)
            if ent:FlashlightIsOn() then
                local rightHandAttachment = ent:LookupBone("ValveBiped.Anim_Attachment_RH")
                if rightHandAttachment ~= nil then
                    local matrix = ent:GetBoneMatrix(rightHandAttachment)
                    if matrix then
                        matrix:SetAngles(ent:EyeAngles())
                        matrix:Rotate(Angle(90, 0, 0))
                        ent:SetBoneMatrix(rightHandAttachment, matrix)
                    end
                end
            end
        end)
    end
end