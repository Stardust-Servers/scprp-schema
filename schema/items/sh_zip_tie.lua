


ITEM.name = "Zip Tie"
ITEM.description = "An sturdy zip-tie used to restrict people."
ITEM.price = 20
ITEM.model = "models/freeman/flexcuffs.mdl"
ITEM.factions = {FACTION_MPF, FACTION_OTA}
ITEM.functions.Use = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client

		local entity = util.TraceLine(data).Entity	
		local target = entity

		if target:IsRagdoll() then
			target = target:GetNetVar("ixPlayer")
		end

		if (IsValid(target) and target:IsPlayer() and target:GetCharacter()
		and !target:GetNetVar("tying") and !target:IsRestricted()
		and target:Team() != FACTION_STAFF
		and target:GetMoveType() != MOVETYPE_NOCLIP) then
			itemTable.bBeingUsed = true

			client:SetAction("@tying", 5)

			local uID = itemTable.uniqueID

			client:DoStaredAction(target, function()
				target:SetRestricted(true)
				target:SetNetVar("tying")
				target:NotifyLocalized("fTiedUp")
				target:AddPart(uID, itemTable)

				if (target:IsCombine()) then
					Schema:AddCombineDisplayMessage("@cLosingContact", Color(255, 255, 255, 255))
					Schema:AddCombineDisplayMessage("@cLostContact", Color(255, 0, 0, 255))
				end

				target.ziptieID = uID

				itemTable:Remove()
			end, 5, function()
				client:SetAction()

				target:SetAction()
				target:SetNetVar("tying")

				itemTable.bBeingUsed = false
			end, nil, entity:IsRagdoll())

			target:SetNetVar("tying", true)
			target:SetAction("@fBeingTied", 5)
		else
			itemTable.player:NotifyLocalized("plyNotValid")
		end

		return false
	end,
	OnCanRun = function(itemTable)
		return !IsValid(itemTable.entity) or itemTable.bBeingUsed
	end
}

function ITEM:CanTransfer(inventory, newInventory)
	return !self.bBeingUsed
end

if CLIENT then
	local ziptieOutfit = {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["Jiggle"] = false,
						["DrawOrder"] = 0,
						["AlternativeBones"] = false,
						["FollowPartName"] = "",
						["OwnerName"] = "self",
						["AimPartName"] = "",
						["FollowPartUID"] = "",
						["Bone"] = "right finger 11",
						["ScaleChildren"] = false,
						["FollowAnglesOnly"] = false,
						["AngleOffset"] = Angle(0, 0, 0),
						["Position"] = Vector(0, 0, 0),
						["AimPartUID"] = "",
						["UniqueID"] = "1326428684",
						["Hide"] = false,
						["Name"] = "",
						["Scale"] = Vector(1, 1, 1),
						["MoveChildrenToOrigin"] = false,
						["Angles"] = Angle(0, -33.599998474121, 0),
						["Size"] = 1,
						["PositionOffset"] = Vector(0, 0, 0),
						["IsDisturbing"] = false,
						["EditorExpand"] = false,
						["EyeAngles"] = false,
						["ClassName"] = "bone",
					},
				},
				[2] = {
					["children"] = {
						[1] = {
							["children"] = {
							},
							["self"] = {
								["UniqueID"] = "3451574858",
								["SequenceName"] = "",
								["InvertFrames"] = false,
								["WeaponHoldType"] = "revolver",
								["Offset"] = 0,
								["OwnerName"] = "self",
								["ResetOnHide"] = true,
								["Max"] = 1,
								["AimPartUID"] = "",
								["Hide"] = false,
								["Min"] = 0,
								["IsDisturbing"] = false,
								["ClassName"] = "animation",
								["OwnerCycle"] = false,
								["Rate"] = 1,
								["Loop"] = true,
								["PingPongLoop"] = false,
								["EditorExpand"] = true,
								["Name"] = "",
							},
						},
					},
					["self"] = {
						["SlotWeight"] = 1,
						["UniqueID"] = "2756104856",
						["AimPartUID"] = "",
						["Hide"] = false,
						["Name"] = "",
						["ClassName"] = "gesture",
						["OwnerName"] = "self",
						["EditorExpand"] = true,
						["IsDisturbing"] = false,
						["Loop"] = false,
						["SlotName"] = "custom",
						["GestureName"] = "",
					},
				},
				[3] = {
					["children"] = {
					},
					["self"] = {
						["Jiggle"] = false,
						["DrawOrder"] = 0,
						["AlternativeBones"] = false,
						["FollowPartName"] = "",
						["OwnerName"] = "self",
						["AimPartName"] = "",
						["FollowPartUID"] = "",
						["Bone"] = "right finger 1",
						["ScaleChildren"] = false,
						["FollowAnglesOnly"] = false,
						["AngleOffset"] = Angle(0, 0, 0),
						["Position"] = Vector(0, 0, 0),
						["AimPartUID"] = "",
						["UniqueID"] = "165806720",
						["Hide"] = false,
						["Name"] = "",
						["Scale"] = Vector(1, 1, 1),
						["MoveChildrenToOrigin"] = false,
						["Angles"] = Angle(0, -70.199996948242, -8.5),
						["Size"] = 1,
						["PositionOffset"] = Vector(0, 0, 0),
						["IsDisturbing"] = false,
						["EditorExpand"] = false,
						["EyeAngles"] = false,
						["ClassName"] = "bone",
					},
				},
				[4] = {
					["children"] = {
					},
					["self"] = {
						["Jiggle"] = false,
						["DrawOrder"] = 0,
						["AlternativeBones"] = false,
						["FollowPartName"] = "",
						["OwnerName"] = "self",
						["AimPartName"] = "",
						["FollowPartUID"] = "",
						["Bone"] = "left upperarm",
						["ScaleChildren"] = false,
						["FollowAnglesOnly"] = false,
						["AngleOffset"] = Angle(0, 0, 0),
						["Position"] = Vector(0, 0, 0),
						["AimPartUID"] = "",
						["UniqueID"] = "919112558",
						["Hide"] = false,
						["Name"] = "",
						["Scale"] = Vector(1, 1, 1),
						["MoveChildrenToOrigin"] = false,
						["Angles"] = Angle(35.200000762939, 62.599998474121, 0),
						["Size"] = 1,
						["PositionOffset"] = Vector(0, 0, 0),
						["IsDisturbing"] = false,
						["EditorExpand"] = false,
						["EyeAngles"] = false,
						["ClassName"] = "bone",
					},
				},
				[5] = {
					["children"] = {
					},
					["self"] = {
						["Jiggle"] = false,
						["DrawOrder"] = 0,
						["AlternativeBones"] = false,
						["FollowPartName"] = "",
						["OwnerName"] = "self",
						["AimPartName"] = "",
						["FollowPartUID"] = "",
						["Bone"] = "right upperarm",
						["ScaleChildren"] = false,
						["FollowAnglesOnly"] = false,
						["AngleOffset"] = Angle(0, 0, 0),
						["Position"] = Vector(0, 0, 0),
						["AimPartUID"] = "",
						["UniqueID"] = "1217936257",
						["Hide"] = false,
						["Name"] = "",
						["Scale"] = Vector(1, 1, 1),
						["MoveChildrenToOrigin"] = false,
						["Angles"] = Angle(-43.099998474121, 32, 0),
						["Size"] = 1,
						["PositionOffset"] = Vector(0, 0, 0),
						["IsDisturbing"] = false,
						["EditorExpand"] = false,
						["EyeAngles"] = false,
						["ClassName"] = "bone",
					},
				},
				[6] = {
					["children"] = {
						[1] = {
							["children"] = {
							},
							["self"] = {
								["ModelIndex"] = 1,
								["UniqueID"] = "2344013574",
								["AimPartUID"] = "",
								["Hide"] = false,
								["Name"] = "",
								["ClassName"] = "bodygroup",
								["OwnerName"] = "self",
								["IsDisturbing"] = false,
								["EditorExpand"] = false,
								["BodyGroupName"] = "UsedOrNot",
							},
						},
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
						["PositionOffset"] = Vector(1.7999999523163, -2.7000000476837, -1.7999999523163),
						["IsDisturbing"] = false,
						["Fullbright"] = false,
						["EyeAngles"] = false,
						["DrawOrder"] = 0,
						["TintColor"] = Vector(0, 0, 0),
						["UniqueID"] = "2612275900",
						["Translucent"] = false,
						["LodOverride"] = -1,
						["BlurSpacing"] = 0,
						["Alpha"] = 1,
						["Material"] = "",
						["UseWeaponColor"] = false,
						["UsePlayerColor"] = false,
						["UseLegacyScale"] = false,
						["Bone"] = "right hand",
						["Color"] = Vector(255, 255, 255),
						["Brightness"] = 1,
						["BoneMerge"] = false,
						["BlurLength"] = 0,
						["Position"] = Vector(-2.6397705078125, -0.38926696777344, 0.70751953125),
						["AngleOffset"] = Angle(4.9000000953674, 5.0999999046326, 335.60000610352),
						["AlternativeScaling"] = false,
						["Hide"] = false,
						["OwnerEntity"] = false,
						["Scale"] = Vector(1.3999999761581, 1.1000000238419, 1.2000000476837),
						["ClassName"] = "model",
						["EditorExpand"] = true,
						["Size"] = 1.1000000238419,
						["ModelFallback"] = "",
						["Angles"] = Angle(0, -0.5, 0),
						["TextureFilter"] = 3,
						["Model"] = "models/freeman/flexcuffs.mdl",
						["BlendMode"] = "",
					},
				},
			},
			["self"] = {
				["DrawOrder"] = 0,
				["UniqueID"] = "3664270947",
				["AimPartUID"] = "",
				["Hide"] = false,
				["Duplicate"] = false,
				["ClassName"] = "group",
				["OwnerName"] = "self",
				["IsDisturbing"] = false,
				["Name"] = "cuffs",
				["EditorExpand"] = true,
			},
		}		
	}

	hook.Add("Think", "ZipTieThink", function()
		--[[for _, v in ipairs(player.GetAll()) do
			if v:IsRestricted() == true then
				if not isfunction(v.AttachPACPart) then
					pac.SetupENT(v)
				end

				if not v.ziptiePart
				and isfunction(v.AttachPACPart) then
					v:AttachPACPart(ziptieOutfit)
					v.ziptiePart = true
				end
			else
				if isfunction(v.RemovePACPart) then
					v:RemovePACPart(ziptieOutfit)
					v.ziptiePart = nil
				end
			end
		end]]
	end) 
end

ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Walk"] = "walk_passive",
					["UniqueID"] = "3350150360",
					["AlternativeRate"] = false,
					["Jump"] = "jump_passive",
					["AttackStandPrimaryfire"] = "",
					["Run"] = "run_passive",
					["OwnerName"] = "self",
					["CrouchWalk"] = "cwalk_passive",
					["CrouchIdle"] = "cidle_passive",
					["SwimIdle"] = "swim_idle_passive",
					["Sitting"] = "",
					["ReloadCrouch"] = "",
					["EditorExpand"] = false,
					["Fallback"] = "",
					["StandIdle"] = "idle_passive",
					["AimPartUID"] = "",
					["Noclip"] = "",
					["Hide"] = false,
					["Name"] = "",
					["Override"] = false,
					["AttackCrouchPrimaryfire"] = "",
					["ClassName"] = "holdtype",
					["Air"] = "",
					["Swim"] = "swimming_passive",
					["IsDisturbing"] = false,
					["ReloadStand"] = "",
					["ActRangeAttack1"] = "",
					["ActLand"] = "",
				},
			},
			[2] = {
				["children"] = {
					[1] = {
						["children"] = {
						},
						["self"] = {
							["ModelIndex"] = 1,
							["UniqueID"] = "91030319",
							["AimPartUID"] = "",
							["Hide"] = false,
							["Name"] = "",
							["ClassName"] = "bodygroup",
							["OwnerName"] = "self",
							["IsDisturbing"] = false,
							["EditorExpand"] = false,
							["BodyGroupName"] = "UsedOrNot",
						},
					},
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
					["UniqueID"] = "3428123188",
					["Translucent"] = false,
					["LodOverride"] = -1,
					["BlurSpacing"] = 0,
					["Alpha"] = 1,
					["Material"] = "",
					["UseWeaponColor"] = false,
					["UsePlayerColor"] = false,
					["UseLegacyScale"] = false,
					["Bone"] = "right hand",
					["Color"] = Vector(255, 255, 255),
					["Brightness"] = 1,
					["BoneMerge"] = false,
					["BlurLength"] = 0,
					["Position"] = Vector(1.1494140625, -2.8875732421875, -2.59326171875),
					["AngleOffset"] = Angle(0, 0, 0),
					["AlternativeScaling"] = false,
					["Hide"] = false,
					["OwnerEntity"] = false,
					["Scale"] = Vector(1, 1, 1),
					["ClassName"] = "model",
					["EditorExpand"] = true,
					["Size"] = 1.125,
					["ModelFallback"] = "",
					["Angles"] = Angle(-8.7568264007568, -144.64170837402, -12.609498977661),
					["TextureFilter"] = 3,
					["Model"] = "models/freeman/flexcuffs.mdl",
					["BlendMode"] = "",
				},
			},
			[3] = {
				["children"] = {
				},
				["self"] = {
					["Jiggle"] = false,
					["DrawOrder"] = 0,
					["AlternativeBones"] = false,
					["FollowPartName"] = "",
					["OwnerName"] = "self",
					["AimPartName"] = "",
					["FollowPartUID"] = "",
					["Bone"] = "left forearm",
					["ScaleChildren"] = false,
					["FollowAnglesOnly"] = false,
					["AngleOffset"] = Angle(0, 0, 0),
					["Position"] = Vector(0, 0, 0),
					["AimPartUID"] = "",
					["UniqueID"] = "542396526",
					["Hide"] = false,
					["Name"] = "",
					["Scale"] = Vector(1, 1, 1),
					["MoveChildrenToOrigin"] = false,
					["Angles"] = Angle(17.692123413086, -31.06616973877, 7.6070599555969),
					["Size"] = 1,
					["PositionOffset"] = Vector(0, 0, 0),
					["IsDisturbing"] = false,
					["EditorExpand"] = false,
					["EyeAngles"] = false,
					["ClassName"] = "bone",
				},
			},
			[4] = {
				["children"] = {
				},
				["self"] = {
					["Jiggle"] = false,
					["DrawOrder"] = 0,
					["AlternativeBones"] = false,
					["FollowPartName"] = "",
					["OwnerName"] = "self",
					["AimPartName"] = "",
					["FollowPartUID"] = "",
					["Bone"] = "left hand",
					["ScaleChildren"] = false,
					["FollowAnglesOnly"] = false,
					["AngleOffset"] = Angle(0, 0, 0),
					["Position"] = Vector(0, 0, 0),
					["AimPartUID"] = "",
					["UniqueID"] = "2868597002",
					["Hide"] = false,
					["Name"] = "",
					["Scale"] = Vector(1, 1, 1),
					["MoveChildrenToOrigin"] = false,
					["Angles"] = Angle(-1.3009829521179, 1.5553275346756, 142.71371459961),
					["Size"] = 1,
					["PositionOffset"] = Vector(0, 0, 0),
					["IsDisturbing"] = false,
					["EditorExpand"] = false,
					["EyeAngles"] = false,
					["ClassName"] = "bone",
				},
			},
			[5] = {
				["children"] = {
				},
				["self"] = {
					["Jiggle"] = false,
					["DrawOrder"] = 0,
					["AlternativeBones"] = false,
					["FollowPartName"] = "",
					["OwnerName"] = "self",
					["AimPartName"] = "",
					["FollowPartUID"] = "",
					["Bone"] = "right forearm",
					["ScaleChildren"] = false,
					["FollowAnglesOnly"] = false,
					["AngleOffset"] = Angle(0, 0, 0),
					["Position"] = Vector(0, 0, 0),
					["AimPartUID"] = "",
					["UniqueID"] = "1979525607",
					["Hide"] = false,
					["Name"] = "",
					["Scale"] = Vector(1, 1, 1),
					["MoveChildrenToOrigin"] = false,
					["Angles"] = Angle(13.977096557617, -1.8177415132523, -6.8510966300964),
					["Size"] = 1,
					["PositionOffset"] = Vector(0, 0, 0),
					["IsDisturbing"] = false,
					["EditorExpand"] = false,
					["EyeAngles"] = false,
					["ClassName"] = "bone",
				},
			},
			[6] = {
				["children"] = {
				},
				["self"] = {
					["Jiggle"] = false,
					["DrawOrder"] = 0,
					["AlternativeBones"] = false,
					["FollowPartName"] = "",
					["OwnerName"] = "self",
					["AimPartName"] = "",
					["FollowPartUID"] = "",
					["Bone"] = "left hand",
					["ScaleChildren"] = false,
					["FollowAnglesOnly"] = false,
					["AngleOffset"] = Angle(0, 0, 0),
					["Position"] = Vector(0, 0, 0),
					["AimPartUID"] = "",
					["UniqueID"] = "2224204500",
					["Hide"] = false,
					["Name"] = "",
					["Scale"] = Vector(1, 1, 1),
					["MoveChildrenToOrigin"] = false,
					["Angles"] = Angle(0, 0, 0),
					["Size"] = 1,
					["PositionOffset"] = Vector(0, 0, 0),
					["IsDisturbing"] = false,
					["EditorExpand"] = false,
					["EyeAngles"] = false,
					["ClassName"] = "bone",
				},
			},
		},
		["self"] = {
			["DrawOrder"] = 0,
			["UniqueID"] = "1684682279",
			["AimPartUID"] = "",
			["Hide"] = false,
			["Duplicate"] = false,
			["ClassName"] = "group",
			["OwnerName"] = "self",
			["IsDisturbing"] = false,
			["Name"] = "my outfit",
			["EditorExpand"] = true,
		},
	},
	
}
ITEM.pac = true

// re-strip weapons when they get up if they were tied while ragdolled
hook.Add("OnCharacterFallover", "ixZipTieRestrict", function(ply, ragdoll, state)
	if state == false and ply:IsRestricted() then
		timer.Simple(.1, function()
			ply:SetRestricted(true)
		end)
	end
end)

hook.Add("PlayerUse", "ixZipTieUse", function(ply, ent)
	if ply:IsRestricted() and ent:IsDoor() then
		return false
	end
end)