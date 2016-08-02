if not Media then return end
local revision = tonumber(string.sub("$Revision: 63551 $", 12, -3))
Media.revision = (revision > Media.revision) and revision or Media.revision

--   STATUSBAR
Media:Register("statusbar", "Dajova",			[[Interface\AddOns\DSM\statusbar\statusbar]])
--   FONTS
Media:Register("font", "Dajova",				[[Interface\AddOns\DSM\font\font.ttf]])
--   BORDER
Media:Register("border", "Dajova",				[[Interface\AddOns\DSM\border\border]])
--   BACKGROUND
Media:Register("background", "Dajova",			[[Interface\AddOns\DSM\background\background]])
--	TUKUI SUPPORT
if IsAddOnLoaded("Tukui") then
	local T, C, L = unpack(Tukui) 				-- Import Functions/Constants/Variables, Config, Locales

	Media:Register("font", "TukuiUF",			[[Interface\AddOns\Tukui\medias\fonts\uf_font.ttf]])
	Media:Register("font", "TukuiDMG",			[[Interface\AddOns\Tukui\medias\fonts\combat_font.ttf]])
	Media:Register("statusbar", "TukuiBar",		[[Interface\AddOns\Tukui\medias\textures\normTex.tga]])
	Media:Register("border", "TukuiBorder",		[[Interface\AddOns\Tukui\medias\textures\glowTex.tga]])
		
	if C["media"].pixelfont then				-- in case someone wants to use pixelfont instead :)
		Media:Register("font", "TukuiPixel",	[[Interface\AddOns\Tukui\medias\fonts\pixel_font.ttf]])
	end
		
	if C["media"].datafont then					-- my own data font, just adding it here
		Media:Register("font", "TukuiData",		[[Interface\AddOns\Tukui\medias\fonts\data_font.ttf]])
	end		
		
	if C["media"].overlay then					-- adding my overlay texture for my edit (both as statusbar and background).
		Media:Register("statusbar", "TukuiOverlay",		[[Interface\AddOns\Tukui\medias\textures\overTex.tga]])
		Media:Register("background", "TukuiOverlay",	[[Interface\AddOns\Tukui\medias\textures\overTex.tga]])
	end
		
	if not IsAddOnLoaded("TelUI_AddonSkins") then	-- just to be sure we dont get 2 font of the same.
		Media:Register("font", "TukuiFont",			[[Interface\AddOns\Tukui\medias\fonts\normal_font.ttf]])
	end
end