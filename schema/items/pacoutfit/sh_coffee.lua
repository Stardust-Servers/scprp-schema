ITEM.name = "UU Branded Coffee"
ITEM.description = "A cup of coffee brewed by the Universal-Union"
ITEM.model = "models/shibcuppyhold.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.outfitCategory = "hands"
ITEM.hungerAmt = -10
ITEM.thirstAmt = 10
ITEM.pacData = {
	[1] = {
		["children"] = {
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
							["Bone"] = "right finger 0",
							["ScaleChildren"] = false,
							["FollowAnglesOnly"] = false,
							["AngleOffset"] = Angle(0, 0, 0),
							["Position"] = Vector(0, 0, 0),
							["AimPartUID"] = "",
							["UniqueID"] = "4124348682",
							["Hide"] = false,
							["Name"] = "",
							["Scale"] = Vector(1, 1, 1),
							["MoveChildrenToOrigin"] = false,
							["Angles"] = Angle(-38.947673797607, 7.225396156311, -58.023426055908),
							["Size"] = 1,
							["PositionOffset"] = Vector(0, 0, 0),
							["IsDisturbing"] = false,
							["EditorExpand"] = true,
							["EyeAngles"] = false,
							["ClassName"] = "bone",
						},
					},
					[2] = {
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
							["UniqueID"] = "1524096120",
							["Translucent"] = false,
							["LodOverride"] = -1,
							["BlurSpacing"] = 0,
							["Alpha"] = 1,
							["Material"] = "",
							["UseWeaponColor"] = false,
							["UsePlayerColor"] = false,
							["UseLegacyScale"] = false,
							["Bone"] = "anim_attachment_rh",
							["Color"] = Vector(255, 255, 255),
							["Brightness"] = 1,
							["BoneMerge"] = false,
							["BlurLength"] = 0,
							["Position"] = Vector(1.91015625, 0.4560546875, 0.53970336914063),
							["AngleOffset"] = Angle(0, 0, 0),
							["AlternativeScaling"] = false,
							["Hide"] = false,
							["OwnerEntity"] = false,
							["Scale"] = Vector(1, 1, 1),
							["ClassName"] = "model",
							["EditorExpand"] = false,
							["Size"] = 1,
							["ModelFallback"] = "",
							["Angles"] = Angle(-5.0632004737854, -98.97624206543, 0.79840791225433),
							["TextureFilter"] = 3,
							["Model"] = "models/shibcuppyhold.mdl",
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
							["Bone"] = "right forearm",
							["ScaleChildren"] = false,
							["FollowAnglesOnly"] = false,
							["AngleOffset"] = Angle(0, 0, 0),
							["Position"] = Vector(0, 0, 0),
							["AimPartUID"] = "",
							["UniqueID"] = "1264727972",
							["Hide"] = false,
							["Name"] = "right forearm",
							["Scale"] = Vector(1, 1, 1),
							["MoveChildrenToOrigin"] = false,
							["Angles"] = Angle(0.0021600471809506, -73.000915527344, 9.2942113876343),
							["Size"] = 1,
							["PositionOffset"] = Vector(0, 0, 0),
							["IsDisturbing"] = false,
							["EditorExpand"] = true,
							["EyeAngles"] = false,
							["ClassName"] = "bone",
						},
					},
					[4] = {
						["children"] = {
						},
						["self"] = {
							["AffectChildrenOnly"] = false,
							["Invert"] = true,
							["RootOwner"] = true,
							["OwnerName"] = "self",
							["AimPartUID"] = "",
							["TargetPartUID"] = "",
							["Hide"] = false,
							["Name"] = "",
							["EditorExpand"] = false,
							["Arguments"] = "hand@@0",
							["Event"] = "weapon_class",
							["ClassName"] = "event",
							["ZeroEyePitch"] = false,
							["IsDisturbing"] = false,
							["Operator"] = "find simple",
							["UniqueID"] = "1392840874",
							["TargetPartName"] = "",
						},
					},
				},
				["self"] = {
					["DrawOrder"] = 0,
					["UniqueID"] = "481250584",
					["AimPartUID"] = "",
					["Hide"] = false,
					["Duplicate"] = false,
					["ClassName"] = "group",
					["OwnerName"] = "self",
					["IsDisturbing"] = false,
					["Name"] = "",
					["EditorExpand"] = true,
				},
			},
		},
		["self"] = {
			["DrawOrder"] = 0,
			["UniqueID"] = "42551088",
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

hook.Add("CanPlayerEquipItem", "ixCombineCoffee", function(client, item)
	if client:IsCombine() and item.uniqueID == "coffee" then
		return false
	end
end)

ITEM.functions.Drink = {
	name = "Drink",
	icon = "icon16/drink.png",
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + 10, client:GetMaxHealth()))
		client:RestoreStamina(50)
		client:EmitSound("npc/barnacle/barnacle_gulp2.wav", 75, 90, 0.35)

		return true
	end
}