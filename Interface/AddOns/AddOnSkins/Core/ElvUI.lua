local AS, ASL = unpack(AddOnSkins)
if not AS:CheckAddOn('ElvUI') then return end

local E, L, V, P, G, LSM, ES, S
local select = select

function AS:CheckOption(optionName, ...)
	for i = 1, select('#', ...) do
		local addon = select(i, ...)
		if not addon then break end
		if not IsAddOnLoaded(addon) then return false end
	end

	return E.private.addonskins[optionName]
end

function AS:SetOption(optionName, value)
	E.private.addonskins[optionName] = value
end

function AS:ToggleOption(optionName)
	E.private.addonskins[optionName] = not E.private.addonskins[optionName]
end

function AS:DisableOption(optionName)
	AS:SetOption(optionName, false)
end

function AS:EnableOption(optionName)
	AS:SetOption(optionName, true)
end

local ElvUISkinTable = {
	['Blizzard_CharacterFrame'] = {
		['blizzard'] = 'character'
	}
}

function AS:DisableElvUIOption(skin)
	if ElvUISkinTable[skin] then
		for location, option in pairs(ElvUISkinTable[skin]) do
			E.private.skins[location][option] = false
		end
	end
end

function AS:InjectProfile()
	E, L, V, P, G = unpack(ElvUI)

	V['addonskins'] = {
	-- Embeds
		['EmbedOoC'] = false, 
		['EmbedOoCDelay'] = 10,
		['EmbedCoolLine'] = false,
		['EmbedSexyCooldown'] = false,
		['EmbedSystem'] = false,
		['EmbedSystemDual'] = false,
		['EmbedMain'] = 'Skada',
		['EmbedLeft'] = 'Skada',
		['EmbedRight'] = 'Skada',
		['EmbedRightChat'] = true,
		['EmbedLeftWidth'] = 200,
		['EmbedBelowTop'] = false,
		['EmbedIsHidden'] = false,
		['TransparentEmbed'] = false,
	-- Misc
		['RecountBackdrop'] = true,
		['SkadaBackdrop'] = true,
		['OmenBackdrop'] = true,
		['DetailsBackdrop'] = true,
		['MiscFixes'] = true,
		['DBMSkinHalf'] = false,
		['DBMFont'] = 'ElvUI Norm',
		['DBMFontSize'] = 12,
		['DBMFontFlag'] = 'OUTLINE',
		['WeakAuraAuraBar'] = false,
		['WeakAuraIconCooldown'] = true,
		['AuctionHouse'] = true,
		['SkinTemplate'] = 'Transparent',
		['HideChatFrame'] = 'NONE',
		['SkinDebug'] = false,
		['Parchment'] = true,
		['LoginMsg'] = true,
		['EmbedSystemMessage'] = true,
	}

	do
		for k, _ in pairs(AS.register) do
			if not V['addonskins'][k] then
				if strfind(k, 'Blizzard_') then
					V['addonskins'][k] = false
				else
					V['addonskins'][k] = true
				end
			end
		end
		V['addonskins']['ParchmentRemover'] = false
	end
end

function AS:UpdateMedia()
	E, L, V, P, G = unpack(ElvUI)

	LSM, ES = AS.LSM, E:GetModule('EnhancedShadows', true)
	AS.SLE = AS:CheckAddOn('ElvUI_SLE')
	S = E:GetModule('Skins')
	AS.Blank = LSM:Fetch('background', 'ElvUI Blank')
	AS.Font = LSM:Fetch('font', E.db.general.font)
	AS.ActionBarFont = LSM:Fetch('font', 'Arial')
	AS.PixelFont = LSM:Fetch('font', 'ElvUI Pixel')
	AS.NormTex = LSM:Fetch('statusbar', E.private.general.normTex)
	AS.BackdropColor = E['media'].backdropcolor
	AS.BorderColor = E['media'].bordercolor
	AS.PixelPerfect = E.PixelMode
	AS.ValueColor = E["media"].rgbvaluecolor
	AS.HideShadows = false

	E:GetModule('DataTexts'):RegisterLDB()
	E:GetModule('DataTexts'):LoadDataTexts()
	E:UpdateMedia()
end

function AS:ElvUISkinModule()

	function S:SetModifiedBackdrop()
		if self.backdrop then self = self.backdrop end
		self:SetBackdropBorderColor(unpack(E["media"].rgbvaluecolor))
	end

	function S:SetOriginalBackdrop()
		if self.backdrop then self = self.backdrop end
		self:SetBackdropBorderColor(unpack(E["media"].bordercolor))
	end

	function S:HandleButton(f, strip)
		assert(f, "doesn't exist!")
		if f.Left then f.Left:SetAlpha(0) end
		if f.Middle then f.Middle:SetAlpha(0) end
		if f.Right then f.Right:SetAlpha(0) end

		if f.SetNormalTexture then f:SetNormalTexture("") end

		if f.SetHighlightTexture then f:SetHighlightTexture("") end

		if f.SetPushedTexture then f:SetPushedTexture("") end

		if f.SetDisabledTexture then f:SetDisabledTexture("") end

		if strip then f:StripTextures() end

		f:SetTemplate("Default", true)
		f:HookScript("OnEnter", S.SetModifiedBackdrop)
		f:HookScript("OnLeave", S.SetOriginalBackdrop)
	end

	function S:HandleScrollBar(frame, thumbTrim)
		if _G[frame:GetName().."BG"] then _G[frame:GetName().."BG"]:SetTexture(nil) end
		if _G[frame:GetName().."Track"] then _G[frame:GetName().."Track"]:SetTexture(nil) end

		if _G[frame:GetName().."Top"] then
			_G[frame:GetName().."Top"]:SetTexture(nil)
		end

		if _G[frame:GetName().."Bottom"] then
			_G[frame:GetName().."Bottom"]:SetTexture(nil)
		end

		if _G[frame:GetName().."Middle"] then
			_G[frame:GetName().."Middle"]:SetTexture(nil)
		end

		if _G[frame:GetName().."ScrollUpButton"] and _G[frame:GetName().."ScrollDownButton"] then
			_G[frame:GetName().."ScrollUpButton"]:StripTextures()
			if not _G[frame:GetName().."ScrollUpButton"].icon then
				S:HandleNextPrevButton(_G[frame:GetName().."ScrollUpButton"])
				SquareButton_SetIcon(_G[frame:GetName().."ScrollUpButton"], 'UP')
				_G[frame:GetName().."ScrollUpButton"]:Size(_G[frame:GetName().."ScrollUpButton"]:GetWidth() + 7, _G[frame:GetName().."ScrollUpButton"]:GetHeight() + 7)
			end

			_G[frame:GetName().."ScrollDownButton"]:StripTextures()
			if not _G[frame:GetName().."ScrollDownButton"].icon then
				S:HandleNextPrevButton(_G[frame:GetName().."ScrollDownButton"])
				SquareButton_SetIcon(_G[frame:GetName().."ScrollDownButton"], 'DOWN')
				_G[frame:GetName().."ScrollDownButton"]:Size(_G[frame:GetName().."ScrollDownButton"]:GetWidth() + 7, _G[frame:GetName().."ScrollDownButton"]:GetHeight() + 7)
			end

			if not frame.trackbg then
				frame.trackbg = CreateFrame("Frame", nil, frame)
				frame.trackbg:Point("TOPLEFT", _G[frame:GetName().."ScrollUpButton"], "BOTTOMLEFT", 0, -1)
				frame.trackbg:Point("BOTTOMRIGHT", _G[frame:GetName().."ScrollDownButton"], "TOPRIGHT", 0, 1)
				frame.trackbg:SetTemplate("Transparent")
			end

			if frame:GetThumbTexture() then
				if not thumbTrim then thumbTrim = 3 end
				frame:GetThumbTexture():SetTexture(nil)
				if not frame.thumbbg then
					frame.thumbbg = CreateFrame("Frame", nil, frame)
					frame.thumbbg:Point("TOPLEFT", frame:GetThumbTexture(), "TOPLEFT", 2, -thumbTrim)
					frame.thumbbg:Point("BOTTOMRIGHT", frame:GetThumbTexture(), "BOTTOMRIGHT", -2, thumbTrim)
					frame.thumbbg:SetTemplate("Default", true, true)
					frame.thumbbg.backdropTexture:SetVertexColor(0.6, 0.6, 0.6)
					if frame.trackbg then
						frame.thumbbg:SetFrameLevel(frame.trackbg:GetFrameLevel())
					end
				end
			end
		end
	end

	--Tab Regions
	local tabs = {
		"LeftDisabled",
		"MiddleDisabled",
		"RightDisabled",
		"Left",
		"Middle",
		"Right",
	}

	function S:HandleTab(tab)
		if not tab then return end
		for _, object in pairs(tabs) do
			local tex = _G[tab:GetName()..object]
			if tex then
				tex:SetTexture(nil)
			end
		end

		if tab.GetHighlightTexture and tab:GetHighlightTexture() then
			tab:GetHighlightTexture():SetTexture(nil)
		else
			tab:StripTextures()
		end

		tab.backdrop = CreateFrame("Frame", nil, tab)
		tab.backdrop:SetTemplate("Default")
		tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
		tab.backdrop:Point("TOPLEFT", 10, E.PixelMode and -1 or -3)
		tab.backdrop:Point("BOTTOMRIGHT", -10, 3)
	end

	function S:HandleNextPrevButton(btn, buttonOverride)
		local norm, pushed, disabled
		local inverseDirection = btn:GetName() and (find(btn:GetName():lower(), 'left') or find(btn:GetName():lower(), 'prev') or find(btn:GetName():lower(), 'decrement') or find(btn:GetName():lower(), 'back'))

		btn:StripTextures()
		btn:SetNormalTexture(nil)
		btn:SetPushedTexture(nil)
		btn:SetHighlightTexture(nil)
		btn:SetDisabledTexture(nil)

		if not btn.icon then
			btn.icon = btn:CreateTexture(nil, 'ARTWORK')
			btn.icon:Size(13)
			btn.icon:Point('CENTER')
			btn.icon:SetTexture([[Interface\Buttons\SquareButtonTextures]])
			btn.icon:SetTexCoord(0.01562500, 0.20312500, 0.01562500, 0.20312500)

			btn:SetScript('OnMouseDown', function(self)
				if self:IsEnabled() then
					self.icon:Point("CENTER", -1, -1);
				end
			end)

			btn:SetScript('OnMouseUp', function(self)
				self.icon:Point("CENTER", 0, 0);
			end)

			btn:SetScript('OnDisable', function(self)
				SetDesaturation(self.icon, true);
				self.icon:SetAlpha(0.5);
			end)

			btn:SetScript('OnEnable', function(self)
				SetDesaturation(self.icon, false);
				self.icon:SetAlpha(1.0);
			end)

			if not btn:IsEnabled() then
				btn:GetScript('OnDisable')(btn)
			end
		end

		if buttonOverride then
			if inverseDirection then
				SquareButton_SetIcon(btn, 'UP')
			else
				SquareButton_SetIcon(btn, 'DOWN')
			end
		else
			if inverseDirection then
				SquareButton_SetIcon(btn, 'LEFT')
			else
				SquareButton_SetIcon(btn, 'RIGHT')
			end
		end

		S:HandleButton(btn)
		btn:Size(btn:GetWidth() - 7, btn:GetHeight() - 7)
	end

	function S:HandleRotateButton(btn)
		btn:SetTemplate("Default")
		btn:Size(btn:GetWidth() - 14, btn:GetHeight() - 14)

		btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)
		btn:GetPushedTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)

		btn:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)

		btn:GetNormalTexture():SetInside()
		btn:GetPushedTexture():SetAllPoints(btn:GetNormalTexture())
		btn:GetHighlightTexture():SetAllPoints(btn:GetNormalTexture())
	end

	function S:HandleEditBox(frame)
		frame:CreateBackdrop("Default")

		if frame.TopLeftTex then frame.TopLeftTex:Kill() end
		if frame.TopRightTex then frame.TopRightTex:Kill() end
		if frame.TopTex then frame.TopTex:Kill() end
		if frame.BottomLeftTex then frame.BottomLeftTex:Kill() end
		if frame.BottomRightTex then frame.BottomRightTex:Kill() end
		if frame.BottomTex then frame.BottomTex:Kill() end
		if frame.LeftTex then frame.LeftTex:Kill() end
		if frame.RightTex then frame.RightTex:Kill() end
		if frame.MiddleTex then frame.MiddleTex:Kill() end

		if frame:GetName() then
			if _G[frame:GetName().."Left"] then _G[frame:GetName().."Left"]:Kill() end
			if _G[frame:GetName().."Middle"] then _G[frame:GetName().."Middle"]:Kill() end
			if _G[frame:GetName().."Right"] then _G[frame:GetName().."Right"]:Kill() end
			if _G[frame:GetName().."Mid"] then _G[frame:GetName().."Mid"]:Kill() end

			if frame:GetName():find("Silver") or frame:GetName():find("Copper") then
				frame.backdrop:Point("BOTTOMRIGHT", -12, -2)
			end
		end

		if(frame.Left) then
			frame.Left:Kill()
		end

		if(frame.Right) then
			frame.Right:Kill()
		end

		if(frame.Middle) then
			frame.Middle:Kill()
		end
	end

	function S:HandleDropDownBox(frame, width)
		local button = _G[frame:GetName().."Button"]
		if not button then return end

		if not width then width = 155 end

		frame:StripTextures()
		frame:Width(width)

		if(_G[frame:GetName().."Text"]) then
			_G[frame:GetName().."Text"]:ClearAllPoints()
			_G[frame:GetName().."Text"]:Point("RIGHT", button, "LEFT", -2, 0)
		end

		if(button) then
			button:ClearAllPoints()
			button:Point("RIGHT", frame, "RIGHT", -10, 3)
			hooksecurefunc(button, "SetPoint", function(self, point, attachTo, anchorPoint, xOffset, yOffset, noReset)
				if not noReset then
					button:ClearAllPoints()
					button:SetPoint("RIGHT", frame, "RIGHT", E:Scale(-10), E:Scale(3), true)
				end
			end)

			self:HandleNextPrevButton(button, true)
		end
		frame:CreateBackdrop("Default")
		frame.backdrop:Point("TOPLEFT", 20, -2)
		frame.backdrop:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
	end

	function S:HandleCheckBox(frame, noBackdrop)
		assert(frame, 'does not exist.')
		frame:StripTextures()
		if noBackdrop then
			frame:SetTemplate("Default")
			frame:Size(16)
		else
			frame:CreateBackdrop('Default')
			frame.backdrop:SetInside(nil, 4, 4)
		end

		if frame.SetCheckedTexture then
			frame:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
			if noBackdrop then
				frame:GetCheckedTexture():SetInside(nil, -4, -4)
			end
		end

		if frame.SetDisabledTexture then
			frame:SetDisabledTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
			if noBackdrop then
				frame:GetDisabledTexture():SetInside(nil, -4, -4)
			end
		end

		frame:HookScript('OnDisable', function(self)
			if not self.SetDisabledTexture then return; end
			if self:GetChecked() then
				self:SetDisabledTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
			else
				self:SetDisabledTexture("")
			end
		end)

		hooksecurefunc(frame, "SetNormalTexture", function(self, texPath)
			if texPath ~= "" then
				self:SetNormalTexture("");
			end
		end)

		hooksecurefunc(frame, "SetPushedTexture", function(self, texPath)
			if texPath ~= "" then
				self:SetPushedTexture("");
			end
		end)

		hooksecurefunc(frame, "SetHighlightTexture", function(self, texPath)
			if texPath ~= "" then
				self:SetHighlightTexture("");
			end
		end)
	end

	function S:HandleIcon(icon, parent)
		parent = parent or icon:GetParent();

		icon:SetTexCoord(unpack(E.TexCoords))
		parent:CreateBackdrop('Default')
		icon:SetParent(parent.backdrop)
		parent.backdrop:SetOutside(icon)
	end

	function S:HandleItemButton(b, shrinkIcon)
		if b.isSkinned then return; end

		local icon = b.icon or b.IconTexture or b.iconTexture
		local texture
		if b:GetName() and _G[b:GetName()..'IconTexture'] then
			icon = _G[b:GetName()..'IconTexture']
		elseif b:GetName() and _G[b:GetName()..'Icon'] then
			icon = _G[b:GetName()..'Icon']
		end

		if(icon and icon:GetTexture()) then
			texture = icon:GetTexture()
		end

		b:StripTextures()
		b:CreateBackdrop('Default', true)
		b:StyleButton()

		if icon then
			icon:SetTexCoord(unpack(E.TexCoords))

			-- create a backdrop around the icon

			if shrinkIcon then
				b.backdrop:SetAllPoints()
				icon:SetInside(b)
			else
				b.backdrop:SetOutside(icon)
			end
			icon:SetParent(b.backdrop)

			if(texture) then
				icon:SetTexture(texture)
			end
		end
		b.isSkinned = true
	end

	function S:HandleCloseButton(f, point, text)
		f:StripTextures()

		if not f.backdrop then
			f:CreateBackdrop('Default', true)
			f.backdrop:Point('TOPLEFT', 7, -8)
			f.backdrop:Point('BOTTOMRIGHT', -8, 8)
			f:HookScript('OnEnter', S.SetModifiedBackdrop)
			f:HookScript('OnLeave', S.SetOriginalBackdrop)
		end
		if not text then text = 'x' end
		if not f.text then
			f.text = f:CreateFontString(nil, 'OVERLAY')
			f.text:SetFont([[Interface\AddOns\ElvUI\media\fonts\PT_Sans_Narrow.ttf]], 16, 'OUTLINE')
			f.text:SetText(text)
			f.text:SetJustifyH('CENTER')
			f.text:Point('CENTER', f, 'CENTER')
		end

		if point then
			f:Point("TOPRIGHT", point, "TOPRIGHT", 2, 2)
		end
	end

	function S:HandleSliderFrame(frame)
		assert(frame)
		local orientation = frame:GetOrientation()
		local SIZE = 12
		frame:StripTextures()
		frame:CreateBackdrop('Default')
		frame.backdrop:SetAllPoints()
		hooksecurefunc(frame, "SetBackdrop", function(self, backdrop)
			if backdrop ~= nil then
				frame:SetBackdrop(nil)
			end
		end)
		frame:SetThumbTexture(E["media"].blankTex)
		frame:GetThumbTexture():SetVertexColor(0.3, 0.3, 0.3)
		frame:GetThumbTexture():Size(SIZE-2,SIZE-2)
		if orientation == 'VERTICAL' then
			frame:Width(SIZE)
		else
			frame:Height(SIZE)

			for i=1, frame:GetNumRegions() do
				local region = select(i, frame:GetRegions())
				if region and region:GetObjectType() == 'FontString' then
					local point, anchor, anchorPoint, x, y = region:GetPoint()
					if anchorPoint:find('BOTTOM') then
						region:Point(point, anchor, anchorPoint, x, y - 4)
					end
				end
			end
		end
	end
end

function AS:EmbedSystemHooks()
	hooksecurefunc(E:GetModule('Chat'), 'PositionChat', function(self, override)
		if override then
			AS:Embed_Check()
		end
	end)
	hooksecurefunc(E:GetModule('Layout'), 'ToggleChatPanels', function() AS:Embed_Check() end)

	if RightChatToggleButton and LeftChatToggleButton then
		RightChatToggleButton:RegisterForClicks('AnyDown')
		RightChatToggleButton:SetScript('OnClick', function(self, btn)
			if btn == 'RightButton' then
				if AS:CheckOption('EmbedRightChat') then
					if EmbedSystem_MainWindow:IsShown() then
						AS:SetOption('EmbedIsHidden', true)
						EmbedSystem_MainWindow:Hide()
					else
						AS:SetOption('EmbedIsHidden', false)
						EmbedSystem_MainWindow:Show()
					end
				end
			else
				if E.db[self.parent:GetName()..'Faded'] then
					E.db[self.parent:GetName()..'Faded'] = nil
					UIFrameFadeIn(self.parent, 0.2, self.parent:GetAlpha(), 1)
					UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
					if AS:CheckOption('EmbedRightChat') and not AS:CheckOption('EmbedIsHidden') then
						EmbedSystem_MainWindow:Show()
					end
				else
					E.db[self.parent:GetName()..'Faded'] = true
					UIFrameFadeOut(self.parent, 0.2, self.parent:GetAlpha(), 0)
					UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
					self.parent.fadeInfo.finishedFunc = self.parent.fadeFunc
				end
			end
		end)

		RightChatToggleButton:HookScript('OnEnter', function(self, ...)
			if AS:CheckOption('EmbedRightChat') then
				GameTooltip:AddDoubleLine(L['Right Click:'], L['Toggle Embedded Addon'], 1, 1, 1)
				GameTooltip:Show()
			end
		end)

		LeftChatToggleButton:RegisterForClicks('AnyDown')
		LeftChatToggleButton:SetScript('OnClick', function(self, btn)
			if btn == 'RightButton' then
				if not AS:CheckOption('EmbedRightChat') then
					if EmbedSystem_MainWindow:IsShown() then
						AS:SetOption('EmbedIsHidden', true)
						EmbedSystem_MainWindow:Hide()
					else
						AS:SetOption('EmbedIsHidden', false)
						EmbedSystem_MainWindow:Show()
					end
				end
			else
				if E.db[self.parent:GetName()..'Faded'] then
					E.db[self.parent:GetName()..'Faded'] = nil
					UIFrameFadeIn(self.parent, 0.2, self.parent:GetAlpha(), 1)
					UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
					if not AS:CheckOption('EmbedRightChat') and not AS:CheckOption('EmbedIsHidden') then
						EmbedSystem_MainWindow:Show()
					end
				else
					E.db[self.parent:GetName()..'Faded'] = true
					UIFrameFadeOut(self.parent, 0.2, self.parent:GetAlpha(), 0)
					UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
					self.parent.fadeInfo.finishedFunc = self.parent.fadeFunc
				end
			end
		end)

		LeftChatToggleButton:HookScript('OnEnter', function(self, ...)
			if not AS:CheckOption('EmbedRightChat') then
				GameTooltip:AddDoubleLine(L['Right Click:'], L['Toggle Embedded Addon'], 1, 1, 1)
				GameTooltip:Show()
			end
		end)

		function HideLeftChat()
			LeftChatToggleButton:Click()
		end

		function HideRightChat()
			RightChatToggleButton:Click()
		end

		function HideBothChat()
			LeftChatToggleButton:Click()
			RightChatToggleButton:Click()
		end
	end
end

function AS:EmbedSystem_WindowResize()
	if UnitAffectingCombat('player') or not AS.EmbedSystemCreated then return end
	local ChatPanel = AS:CheckOption('EmbedRightChat') and RightChatPanel or LeftChatPanel
	local ChatTab = AS:CheckOption('EmbedRightChat') and RightChatTab or LeftChatTab
	local ChatData = AS:CheckOption('EmbedRightChat') and RightChatDataPanel or LeftChatToggleButton
	local TopRight = ChatData == RightChatDataPanel and (E.db.datatexts.rightChatPanel and 'TOPLEFT' or 'BOTTOMLEFT') or ChatData == LeftChatToggleButton and (E.db.datatexts.leftChatPanel and 'TOPLEFT' or 'BOTTOMLEFT')
	local yOffset = (ChatData == RightChatDataPanel and E.db.datatexts.rightChatPanel and (E.PixelMode and 1 or 0)) or (ChatData == LeftChatToggleButton and E.db.datatexts.leftChatPanel and (E.PixelMode and 1 or 0)) or (E.PixelMode and 0 or -1)

	EmbedSystem_MainWindow:SetParent(ChatPanel)
	EmbedSystem_MainWindow:ClearAllPoints()
	EmbedSystem_MainWindow:SetPoint('BOTTOMLEFT', ChatData, TopRight, 0, yOffset)
	EmbedSystem_MainWindow:SetPoint('TOPRIGHT', ChatTab, AS:CheckOption('EmbedBelowTop') and 'BOTTOMRIGHT' or 'TOPRIGHT', 0, AS:CheckOption('EmbedBelowTop') and -1 or 0)
	
	EmbedSystem_LeftWindow:SetSize(AS:CheckOption('EmbedLeftWidth'), EmbedSystem_MainWindow:GetHeight())
	EmbedSystem_RightWindow:SetSize((EmbedSystem_MainWindow:GetWidth() - AS:CheckOption('EmbedLeftWidth')) - 1, EmbedSystem_MainWindow:GetHeight())

	EmbedSystem_LeftWindow:SetPoint('LEFT', EmbedSystem_MainWindow, 'LEFT', 0, 0)
	EmbedSystem_RightWindow:SetPoint('RIGHT', EmbedSystem_MainWindow, 'RIGHT', 0, 0)

	-- Dynamic Range
	if IsAddOnLoaded('ElvUI_Config') then
		E.Options.args.addonskins.args.embed.args.EmbedLeftWidth.min = floor(EmbedSystem_MainWindow:GetWidth() * .25)
		E.Options.args.addonskins.args.embed.args.EmbedLeftWidth.max = floor(EmbedSystem_MainWindow:GetWidth() * .75)
	end
end

if AS:CheckAddOn('CoolLine') then
	function AS:Embed_CoolLine()
		if not CoolLineDB.vertical then
			CoolLine:SetPoint('BOTTOMRIGHT', ElvUI_Bar1, 'TOPRIGHT', 0, 4)
			CoolLine:SetPoint("BOTTOMLEFT", ElvUI_Bar1, "TOPLEFT", 0, 4)
		end
	end
end

function AS:CreateDataText()
	DT = E:GetModule('DataTexts')

	local function OnClick(self, button)
		if EmbedSystem_MainWindow:IsShown() then
			EmbedSystem_MainWindow:Hide()
		else
			EmbedSystem_MainWindow:Show()
		end
	end

	local function OnEnter(self)
		DT:SetupTooltip(self)
		DT.tooltip:AddLine(ASL.DataText.LeftClick)
		DT.tooltip:AddLine(ASL.DataText.RightClick)
		DT.tooltip:Show()
	end

	local function OnEvent(self, event)
		self.text:SetText(ASL.DataText.ToggleEmbed)
	end

	DT:RegisterDatatext('AddOnSkins', { 'PLAYER_ENTERING_WORLD' }, OnEvent, nil, OnClick, OnEnter)
end