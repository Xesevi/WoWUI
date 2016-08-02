local FONT = [=[Fonts\FRIZQT__.TTF]=]
local TEXTURE = [=[Interface\AddOns\Headline\minimalist]=]
local OVERLAY = [=[Interface\TargetingFrame\UI-TargetingFrame-Flash]=]

local combat = false

local numChildren = -1
local frames = {}

local function QueueObject(parent, object)
	parent.queue = parent.queue or {}
	parent.queue[object] = true
end

local function HideObjects(parent)
	for object in pairs(parent.queue) do
		if(object:GetObjectType() == 'Texture') then
			object:SetTexture(nil)
		else
			object:Hide()
		end
	end
end

local function UpdatePlates(frame)
	if(HeadlineGlobalSettings.target) then
		if(UnitName('target') and frame:GetAlpha() == 1) then
			frame.bg:SetTexture(1, 1, 1)
		else
			frame.bg:SetTexture(0, 0, 0)
		end
	end
	if(frame.hostile) then
		if(combat) then
			if(frame.region:IsShown()) then
				local r, g, b = frame.region:GetVertexColor()
				if(g + b == 0) then
					frame.hp:SetStatusBarColor(1, 0, 0)
				else
					frame.hp:SetStatusBarColor(1, 1, 0.3)
				end
			else
				frame.hp:SetStatusBarColor(0.3, 1, 0.3)
			end
		else
			frame.hp:SetStatusBarColor(1, 0, 0)
		end
	end
end

local function UpdateObjects(frame)
	frame = frame:GetParent()

	local r, g, b = frame.hp:GetStatusBarColor()
	frame.hostile = g + b == 0

	frame.hp:SetHeight(HeadlineGlobalSettings.height)
	frame.hp:SetWidth(HeadlineGlobalSettings.width)
	frame.hp:ClearAllPoints()
	frame.hp:SetPoint('CENTER', frame)

	if(HeadlineGlobalSettings.level) then
		local r, g, b = frame.level:GetTextColor()
		if(frame.bossicon:IsShown()) then
			frame.name:SetText('|cffff0000??|r ' .. frame.oldname:GetText())
		else
			frame.name:SetText(format('|cff%02x%02x%02x', r*255, g*255, b*255) .. (frame.elite:IsShown() and '+' or '') .. tonumber(frame.level:GetText()) .. '|r ' .. frame.oldname:GetText())
		end
	else
		frame.name:SetText(frame.oldname:GetText())
	end

	HideObjects(frame)
end

local function UpdateCastbar(frame)
	frame:SetHeight(HeadlineGlobalSettings.height)
	frame:SetWidth(HeadlineGlobalSettings.width)
	frame:ClearAllPoints()
	frame:SetPoint('TOP', frame:GetParent().hp, 'BOTTOM', 0, -5)

	frame.icon:SetHeight(0.01)
	frame.icon:SetWidth(0.01)

	if(not frame.shield:IsShown()) then
		frame:SetStatusBarColor(1, 0.35, 0.2)
	end
end	

local function SkinObjects(frame)
	local hp, cb = frame:GetChildren()
	local threat, hpborder, cbshield, cbborder, cbicon, overlay, oldname, level, bossicon, raidicon, elite = frame:GetRegions()

	local offset = UIParent:GetScale() / hp:GetEffectiveScale()
	local hpbg = hp:CreateTexture(nil, 'BACKGROUND')
	hpbg:SetPoint('BOTTOMRIGHT', offset, -offset)
	hpbg:SetPoint('TOPLEFT', -offset, offset)
	hpbg:SetTexture(0, 0, 0)
	frame.bg = hpbg

	local hpbg2 = hp:CreateTexture(nil, 'BORDER')
	hpbg2:SetAllPoints(hp)
	hpbg2:SetTexture(1/3, 1/3, 1/3)

	hp:HookScript('OnShow', UpdateObjects)
	hp:SetStatusBarTexture(TEXTURE)
	frame.hp = hp
	
	local offset = UIParent:GetScale() / cb:GetEffectiveScale()
	local cbbg = cb:CreateTexture(nil, 'BACKGROUND')
	cbbg:SetPoint('BOTTOMRIGHT', offset, -offset)
	cbbg:SetPoint('TOPLEFT', -offset, offset)
	cbbg:SetTexture(0, 0, 0)

	local cbbg2 = cb:CreateTexture(nil, 'BORDER')
	cbbg2:SetAllPoints(cb)
	cbbg2:SetTexture(1/3, 1/3, 1/3)

	cb.icon = cbicon
	cb.shield = cbshield
	cb:HookScript('OnShow', UpdateCastbar)
	cb:HookScript('OnSizeChanged', UpdateCastbar)

	cb:SetStatusBarTexture(TEXTURE)
	frame.cb = cb

	local name = hp:CreateFontString(nil, 'OVERLAY')
	name:SetPoint('BOTTOMLEFT', hp, 'TOPLEFT', 0, 2)
	name:SetPoint('BOTTOMRIGHT', hp, 'TOPRIGHT', 0, 2)
	name:SetFont(FONT, HeadlineGlobalSettings.fsize, 'OUTLINE')
	frame.oldname = oldname
	frame.name = name
	
	raidicon:ClearAllPoints()
	raidicon:SetPoint('CENTER', hp, 'CENTER', 0, 5)
	raidicon:SetSize(20, 20)
	
	if(HeadlineGlobalSettings.level) then
		frame.bossicon = bossicon
		frame.elite = elite
		frame.level = level
	end
	
	QueueObject(frame, threat)
	QueueObject(frame, hpborder)
	QueueObject(frame, cbshield)
	QueueObject(frame, cbborder)
	QueueObject(frame, overlay)
	QueueObject(frame, oldname)
	QueueObject(frame, level)
	QueueObject(frame, bossicon)
	QueueObject(frame, elite)

	UpdateObjects(hp)
	UpdateCastbar(cb)

	frames[frame] = true
end

local select = select
local function HookFrames(...)
	for index = 1, select('#', ...) do
		local frame = select(index, ...)
		local region = frame:GetRegions()
		if(not frames[frame] and not frame:GetName() and region and region:GetObjectType() == 'Texture' and region:GetTexture() == OVERLAY) then
			SkinObjects(frame)
			frame.region = region
		end
	end
end

local f = CreateFrame'Frame'
f:RegisterEvent('ADDON_LOADED')
f:RegisterEvent('PLAYER_REGEN_ENABLED')
f:RegisterEvent('PLAYER_REGEN_DISABLED')

f:SetScript('OnUpdate', function(self, elapsed)
	if(WorldFrame:GetNumChildren() ~= numChildren) then
		numChildren = WorldFrame:GetNumChildren()
		HookFrames(WorldFrame:GetChildren())
	end
	if(self.elapsed and self.elapsed > 0.1) then
		for frame in pairs(frames) do
			UpdatePlates(frame)
		end
		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end
end)

f:SetScript('OnEvent', function(self, e, name) 
	if(e == 'PLAYER_REGEN_DISABLED') then
		combat = true
	elseif(e == 'PLAYER_REGEN_ENABLED') then
		combat = false
	elseif(name == 'Headline' and e == 'ADDON_LOADED') then
		if not HeadlineGlobalSettings then HeadlineGlobalSettings = { width = 110, height = 5, fsize = 9, level = true, target = true } end
		SetCVar('ShowClassColorInNameplate', 1)
		SetCVar('bloattest', 0)
		SetCVar('spreadnameplates', 0)
		SetCVar('bloatnameplates', 0)
		SetCVar('bloatthreat', 0)
	end
end)

SLASH_HEADLINE1 = '/headline';
function SlashCmdList.HEADLINE(args)
	local arg = string.split(' ', args):lower() or args:lower()
	if(arg == 'width') then
		arg = tonumber(select(2, string.split(' ', args)))
		if(arg and arg > 49 and arg < 301) then
			HeadlineGlobalSettings.width = arg
			ReloadUI()
		end
	elseif(arg == 'height') then
		arg = tonumber(select(2, string.split(' ', args)))
		if(arg and arg > 1 and arg < 51) then
			HeadlineGlobalSettings.height = arg
			ReloadUI()
		end
	elseif(arg == 'fontsize') then
		arg = tonumber(select(2, string.split(' ', args)))
		if(arg and arg > 4 and arg < 31) then
			HeadlineGlobalSettings.fsize = arg
			ReloadUI()
		end
	elseif(arg == 'level') then
		HeadlineGlobalSettings.level = not HeadlineGlobalSettings.level
		ReloadUI()
	elseif(arg == 'target') then
		HeadlineGlobalSettings.target = not HeadlineGlobalSettings.target
		ReloadUI()
	else
		print('Headline')
		print(' - |cFF33FF99width <num>|r: current width is '..HeadlineGlobalSettings.width)
		print(' - |cFF33FF99height <num>|r: current height is '..HeadlineGlobalSettings.height)
		print(' - |cFF33FF99fontsize <num>|r: current font size is '..HeadlineGlobalSettings.fsize)
		print(' - |cFF33FF99level|r: toggles the level display')
		print(' - |cFF33FF99target|r: amplify target display')
	end
end