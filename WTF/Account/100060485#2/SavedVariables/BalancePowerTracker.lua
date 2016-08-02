
BalancePowerTracker_Options = {
	["hide_default"] = {
		["load"] = true,
	},
	["pipe"] = {
		["load"] = false,
	},
	["global"] = {
		["enabled"] = true,
		["slashShown"] = true,
		["version"] = {
			"1", -- [1]
			"3", -- [2]
			"4", -- [3]
		},
	},
	["default_art"] = {
		["load"] = false,
	},
	["eclipse_bar"] = {
		["showInAllStances"] = true,
		["ly"] = 0,
		["predictOnArrow"] = true,
		["insets"] = {
			["top"] = 2,
			["right"] = 2,
			["left"] = 2,
			["bottom"] = 2,
		},
		["iconGlow"] = true,
		["iconSpellReady"] = false,
		["arrowTextureFile"] = "Interface\\PlayerFrame\\UI-DruidEclipse",
		["x"] = 0,
		["height"] = 16,
		["borderColor"] = {
			["a"] = 1,
			["b"] = 1,
			["g"] = 1,
			["r"] = 1,
		},
		["SolarIconTextureFile"] = "Interface\\Icons\\Ability_Druid_EclipseOrange",
		["big_icons"] = false,
		["eclipseMarkerCoords"] = {
			{
				["sun"] = {
					1, -- [1]
					0.641, -- [2]
					0.914, -- [3]
					0.641, -- [4]
					1, -- [5]
					0.82, -- [6]
					0.914, -- [7]
					0.82, -- [8]
				},
				["moon"] = {
					0.914, -- [1]
					0.641, -- [2]
					1, -- [3]
					0.641, -- [4]
					0.914, -- [5]
					0.82, -- [6]
					1, -- [7]
					0.82, -- [8]
				},
				["none"] = {
					1, -- [1]
					0.82, -- [2]
					0.922, -- [3]
					0.82, -- [4]
					1, -- [5]
					1, -- [6]
					0.922, -- [7]
					1, -- [8]
				},
			}, -- [1]
			[0] = {
				["sun"] = {
					0.914, -- [1]
					1, -- [2]
					0.641, -- [3]
					0.82, -- [4]
				},
				["moon"] = {
					1, -- [1]
					0.914, -- [2]
					0.641, -- [3]
					0.82, -- [4]
				},
				["none"] = {
					0.922, -- [1]
					1, -- [2]
					0.82, -- [3]
					1, -- [4]
				},
			},
		},
		["iconBigScale"] = 1.2,
		["arrowScale"] = 1,
		["custom"] = {
			false, -- [1]
			nil, -- [2]
			false, -- [3]
			false, -- [4]
			false, -- [5]
			[0] = true,
			[31] = true,
			[29] = false,
			[27] = false,
		},
		["lx"] = -5,
		["moveTextOutOfTheWay"] = true,
		["SolarIconHighlightTextureFile"] = "Interface\\GLUES\\CHARACTERCREATE\\UI-CharacterCreate-IconGlow",
		["predictOnIcons"] = true,
		["backGroundColor"] = {
			["a"] = 0,
			["b"] = 0,
			["g"] = 0,
			["r"] = 0,
		},
		["LunarIconTextureFile"] = "Interface\\Icons\\Ability_Druid_Eclipse",
		["y"] = -100,
		["font"] = "Fonts\\FRIZQT__.TTF",
		["sparkXOffset"] = 0,
		["showEdge"] = true,
		["lunarColor"] = {
			["a"] = 1,
			["b"] = 0.73,
			["g"] = 0.21,
			["r"] = 0.05,
		},
		["arrowYOffset"] = 1,
		["load"] = true,
		["none"] = {
			["a"] = 0,
			["b"] = 0,
			["g"] = 0,
			["r"] = 0,
		},
		["sparkYOffset"] = -1,
		["predictedSolarColor"] = {
			["a"] = 1,
			["b"] = 0.16,
			["g"] = 0.66,
			["r"] = 1,
		},
		["point"] = "CENTER",
		["gainSpark"] = true,
		["scale"] = 1,
		["showPredictBar"] = true,
		["sparkTextureFile"] = "Interface\\CastingBar\\UI-CastingBar-Spark",
		["absoluteText"] = true,
		["showValue"] = true,
		["vertical"] = false,
		["sx"] = 5,
		["edgeFile"] = "Interface\\Tooltips\\UI-Tooltip-Border",
		["iconSize"] = 20,
		["showIcons"] = true,
		["arrowXOffset"] = 0,
		["alphaOOC"] = 0.65,
		["barTextureFile"] = "Interface\\TARGETINGFRAME\\UI-TargetingFrame-BarFill",
		["edgeSize"] = 12,
		["autoFontSize"] = true,
		["barModeCastBar"] = false,
		["barModeColorAll"] = false,
		["solarColor"] = {
			["a"] = 1,
			["b"] = 0,
			["g"] = 0.55,
			["r"] = 1,
		},
		["alpha"] = 1,
		["width"] = 140,
		["strata"] = "HIGH",
		["predictedLunarColor"] = {
			["a"] = 1,
			["b"] = 1,
			["g"] = 0.56,
			["r"] = 0.12,
		},
		["sy"] = 0,
		["moving"] = false,
		["fontSize"] = 14,
		["growBar"] = false,
		["LunarIconHighlightTextureFile"] = "Interface\\GLUES\\CHARACTERCREATE\\UI-CharacterCreate-IconGlow",
		["textColor"] = {
			["a"] = 1,
			["b"] = 1,
			["g"] = 1,
			["r"] = 1,
		},
	},
	["warning_text"] = {
		["strata"] = "HIGH",
		["point"] = "CENTER",
		["spellEffects"] = true,
		["RealSolarEclipse"] = {
			["playThis"] = false,
			["MSBTThis"] = false,
			["color"] = {
				["a"] = 1,
				["b"] = 0,
				["g"] = 0.55,
				["r"] = 1,
			},
			["text"] = "Eclipse (Solar)",
			["flashThis"] = false,
			["warnThis"] = true,
			["showTexture"] = true,
			["sound"] = "Interface\\Quiet.ogg",
			["texture"] = "Interface\\Icons\\Ability_Druid_EclipseOrange",
		},
		["MSBT_sticky"] = true,
		["RealLunarEclipse"] = {
			["playThis"] = false,
			["MSBTThis"] = false,
			["color"] = {
				["a"] = 1,
				["b"] = 0.73,
				["g"] = 0.21,
				["r"] = 0.05,
			},
			["text"] = "Eclipse (Lunar)",
			["flashThis"] = false,
			["warnThis"] = true,
			["showTexture"] = true,
			["sound"] = "Interface\\Quiet.ogg",
			["texture"] = "Interface\\Icons\\Ability_Druid_Eclipse",
		},
		["testing"] = false,
		["MSBT_outlineIndex"] = 0,
		["font"] = "Fonts\\FRIZQT__.TTF",
		["y"] = 120,
		["x"] = 0,
		["scale"] = 1,
		["PredictedSolarEclipse"] = {
			["playThis"] = false,
			["MSBTThis"] = true,
			["color"] = {
				["a"] = 1,
				["b"] = 0.16,
				["g"] = 0.66,
				["r"] = 1,
			},
			["text"] = "Eclipse (Solar) soon!",
			["flashThis"] = false,
			["warnThis"] = true,
			["showTexture"] = true,
			["sound"] = "Interface\\Quiet.ogg",
			["texture"] = "Interface\\Icons\\Ability_Druid_EclipseOrange",
		},
		["PredictedLunarEclipse"] = {
			["playThis"] = false,
			["MSBTThis"] = true,
			["color"] = {
				["a"] = 1,
				["b"] = 1,
				["g"] = 0.56,
				["r"] = 0.12,
			},
			["text"] = "Eclipse (Lunar) soon!",
			["flashThis"] = false,
			["warnThis"] = true,
			["showTexture"] = true,
			["sound"] = "Interface\\Quiet.ogg",
			["texture"] = "Interface\\Icons\\Ability_Druid_Eclipse",
		},
		["fontSize"] = 30,
		["load"] = true,
		["flashAlpha"] = 0.5,
	},
}
