local E, L, C, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local Skullflower = E:NewModule('Skullflower', 'AceHook-3.0', 'AceEvent-3.0');

ElvUF_Player.Combat:SetAlpha(0.0)
ElvUF_Player.Castbar:SetFrameStrata(HIGH)
ElvUF_Target.Castbar:SetFrameStrata(HIGH)

E.PopupDialogs["VERSION_MISMATCH"] = {
	text = L["Your version of ElvUI is older than recommended to use with this plugin. Please, download the latest version from tukui.org."],
	button1 = CLOSE,
	timeout = 0,
	whileDead = 1,	
	preferredIndex = 3,
}

function Skullflower:Initialize()
	if tonumber(E.version) < 6.55 then
		E:StaticPopup_Show("VERSION_MISMATCH")
	end
end