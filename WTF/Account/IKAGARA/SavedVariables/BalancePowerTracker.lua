
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
		["iconBigScale"] = 1.2,
		["iconGlow"] = true,
		["iconSpellReady"] = false,
		["arrowTextureFile"] = "Interface\\PlayerFrame\\UI-DruidEclipse",
		["moveTextOutOfTheWay"] = true,
		["strata"] = "HIGH",
		["borderColor"] = {
			["a"] = 1,
			["r"] = 1,
			["g"] = 1,
			["b"] = 1,
		},
		["SolarIconTextureFile"] = "Interface\\Icons\\Ability_Druid_EclipseOrange",
		["big_icons"] = false,
		["y"] = -100,
		["insets"] = {
			["top"] = 2,
			["right"] = 2,
			["left"] = 2,
			["bottom"] = 2,
		},
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
		["sparkYOffset"] = -1,
		["growBar"] = false,
		["SolarIconHighlightTextureFile"] = "Interface\\GLUES\\CHARACTERCREATE\\UI-CharacterCreate-IconGlow",
		["predictOnIcons"] = true,
		["backGroundColor"] = {
			["a"] = 0,
			["r"] = 0,
			["g"] = 0,
			["b"] = 0,
		},
		["predictedSolarColor"] = {
			["a"] = 1,
			["r"] = 1,
			["g"] = 0.66,
			["b"] = 0.16,
		},
		["moving"] = false,
		["font"] = "Fonts\\FRIZQT__.TTF",
		["width"] = 140,
		["showEdge"] = true,
		["lunarColor"] = {
			["a"] = 1,
			["r"] = 0.05,
			["g"] = 0.21,
			["b"] = 0.73,
		},
		["arrowYOffset"] = 1,
		["load"] = true,
		["none"] = {
			["a"] = 0,
			["r"] = 0,
			["g"] = 0,
			["b"] = 0,
		},
		["lx"] = -5,
		["fontSize"] = 14,
		["point"] = "CENTER",
		["vertical"] = false,
		["scale"] = 1,
		["showPredictBar"] = true,
		["sparkTextureFile"] = "Interface\\CastingBar\\UI-CastingBar-Spark",
		["absoluteText"] = true,
		["showValue"] = true,
		["gainSpark"] = true,
		["edgeFile"] = "Interface\\Tooltips\\UI-Tooltip-Border",
		["solarColor"] = {
			["a"] = 1,
			["r"] = 1,
			["g"] = 0.55,
			["b"] = 0,
		},
		["iconSize"] = 20,
		["showIcons"] = true,
		["edgeSize"] = 12,
		["arrowXOffset"] = 0,
		["alphaOOC"] = 0.65,
		["barTextureFile"] = "Interface\\TARGETINGFRAME\\UI-TargetingFrame-BarFill",
		["autoFontSize"] = true,
		["barModeCastBar"] = false,
		["barModeColorAll"] = false,
		["sx"] = 5,
		["alpha"] = 1,
		["sparkXOffset"] = 0,
		["LunarIconTextureFile"] = "Interface\\Icons\\Ability_Druid_Eclipse",
		["predictedLunarColor"] = {
			["a"] = 1,
			["r"] = 0.12,
			["g"] = 0.56,
			["b"] = 1,
		},
		["sy"] = 0,
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
			}, -- [1]
			[0] = {
				["sun"] = {
					0.914, -- [1]
					1, -- [2]
					0.641, -- [3]
					0.82, -- [4]
				},
				["none"] = {
					0.922, -- [1]
					1, -- [2]
					0.82, -- [3]
					1, -- [4]
				},
				["moon"] = {
					1, -- [1]
					0.914, -- [2]
					0.641, -- [3]
					0.82, -- [4]
				},
			},
		},
		["height"] = 16,
		["x"] = 0,
		["LunarIconHighlightTextureFile"] = "Interface\\GLUES\\CHARACTERCREATE\\UI-CharacterCreate-IconGlow",
		["textColor"] = {
			["a"] = 1,
			["r"] = 1,
			["g"] = 1,
			["b"] = 1,
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
				["r"] = 1,
				["g"] = 0.55,
				["b"] = 0,
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
				["r"] = 0.05,
				["g"] = 0.21,
				["b"] = 0.73,
			},
			["text"] = "Eclipse (Lunar)",
			["flashThis"] = false,
			["warnThis"] = true,
			["showTexture"] = true,
			["sound"] = "Interface\\Quiet.ogg",
			["texture"] = "Interface\\Icons\\Ability_Druid_Eclipse",
		},
		["testing"] = false,
		["flashAlpha"] = 0.5,
		["x"] = 0,
		["y"] = 120,
		["font"] = "Fonts\\FRIZQT__.TTF",
		["fontSize"] = 30,
		["PredictedSolarEclipse"] = {
			["playThis"] = false,
			["MSBTThis"] = true,
			["color"] = {
				["a"] = 1,
				["r"] = 1,
				["g"] = 0.66,
				["b"] = 0.16,
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
				["r"] = 0.12,
				["g"] = 0.56,
				["b"] = 1,
			},
			["text"] = "Eclipse (Lunar) soon!",
			["flashThis"] = false,
			["warnThis"] = true,
			["showTexture"] = true,
			["sound"] = "Interface\\Quiet.ogg",
			["texture"] = "Interface\\Icons\\Ability_Druid_Eclipse",
		},
		["scale"] = 1,
		["load"] = true,
		["MSBT_outlineIndex"] = 0,
	},
}
