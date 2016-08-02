--------------------------------------------------------
-- Credits --
--------------------------------------------------------
-- Elv
-- the Tuk/Elv community for making this possible!
-- 
--
--------------------------------------------------------
-- System Settable Variables --
--------------------------------------------------------
local E, L, V, DF, P, G =  unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local DT = E:GetModule('DataTexts')
local LO = E:GetModule('Layout')

E.Layout = LO;

P['dtPanels'] = {
	--['enable'] = true,
	['enableTop'] = true,
	['enableBottom'] = true,
	['topCenter'] = true,
	['bottomBar'] = true,
	['leftChat'] = true,
	['rightChat'] = true,
	['topSize'] = 22,
	['bottomSize'] = 22,
	['topWidth'] = 350,
	['bottomWidth'] = 400,
	['expMouseover'] = true,
}

P['datatexts'] = {
	['panels'] = {
		['Extra One'] = {
			['left'] = '',
			['middle'] = '',
			['right'] = '',
		},
		['Extra Two'] = {
			['left'] = '',
			['middle'] = '',
			['right'] = '',
		},
		['Extra Three'] = {
			['left'] = '',
			['middle'] = '',
			['right'] = '',
		},
	}
}

Broker = CreateFrame('Frame', 'Broker', E.UIParent)
Broker.ldb = LibStub:GetLibrary("LibDataBroker-1.1")
pluginObjects = {}

ElvUI_DTbar = CreateFrame('Frame', 'ElvUI_DTbar', E.UIParent)
ElvUI_DTbar.version = '2'

local top_bar, bottom_bar, exp_rep, extra_bar, top_panel
local lchat_tab, rchat_tab, rchat_tab2, ldb_one, ldb_two, ldb_three
local PANEL_HEIGHT = 22 -- taken from Layout.lua

db = db or {} 

-------------
---  LDB  ---
-------------
-- Use 'LDB_name', format here.  if unsure do a /dtbar showldb in game.  CASE SENSITIVE
-------------

DTBar_ldb = {
	
}
-------------
--------------------------------------------------------
-- Language Variables --
--------------------------------------------------------

-- description as shown in /ec -> datatext;  L['panel name'] = 'description';
L['TOP_TESTPANEL'] = 'Top Center Data Panel';
L['Bottom_Datatext_Panel'] = 'Action Bar 1 (Bottom) Data Panel';
L['EXP_REP_TESTPANEL'] = 'EXP/REP Data Panel';
L['LeftChatTab_Datatext_Panel'] = 'Upper Left Chat';
L['RightChatTab_Datatext_Panel'] = 'Upper Right Chat';
L['RightChatTab_Datatext_Panel2'] = 'Upper Right Chat 2';
L['LDB_One'] = 'Extra One';
L['LDB_Two'] = 'Extra Two';
L['LDB_Three'] = 'Extra Three';
--------------------------------------------------------


--------------------------------------------------------
-- default values for datatext
--------------------------------------------------------


DF.datatexts.panels.LDB_One = {
	left = '',
	middle = '',
	right = '',
}

DF.datatexts.panels.LDB_Two = {
	left = '',
	middle = '',
	right = '',
}

DF.datatexts.panels.LDB_Three = {
	left = '',
	middle = '',
	right = '',
}


DF.datatexts.panels.TOP_TESTPANEL = {
	left = 'Friends',
	middle = 'Spec Switch',
	right = 'Guild',
}

--Bottom_Datatext_Panel
DF.datatexts.panels.Bottom_Datatext_Panel = {
	left = 'Currency',
	middle = 'Call to Arms',
	right = 'Bags',
}

--Experience_Datatext_Panel
DF.datatexts.panels.EXP_REP_TESTPANEL = 'DPS'
 
DF.datatexts.panels.LeftChatTab_Datatext_Panel = 'Durability'

DF.datatexts.panels.RightChatTab_Datatext_Panel = 'Gold'

DF.datatexts.panels.RightChatTab_Datatext_Panel2 = 'Bags'

--------------------------------------------------


--------------------------------------------------------
-- Code  --
--------------------------------------------------------


--------------------------------------------------------
-- left chat tabbar
--------------------------------------------------------
local function lchat_tab_setup()
	do
		lchat_tab:Size(LeftChatTab:GetWidth() / 3, PANEL_HEIGHT)
		lchat_tab:Point("TOPRIGHT", LeftChatTab, "TOPRIGHT", 0, -E.mult);
		lchat_tab:SetFrameStrata('LOW')
		LeftChatTab:HookScript("OnHide", function() lchat_tab:Hide() end)
		LeftChatTab:HookScript("OnShow", function() lchat_tab:Show() end)		
	end
end
do
	lchat_tab = CreateFrame('Frame', 'LeftChatTab_Datatext_Panel', E.UIParent)
	lchat_tab.db = {key='LeftChatTab_Datatext_Panel', value = true}
	DT:RegisterPanel(lchat_tab, 1, 'ANCHOR_BOTTOM', 0, -4)
	lchat_tab:Hide()
end
 
 
--------------------------------------------------------
 -- right chat tabbar
--------------------------------------------------------
local function rchat_tab_setup()
	do
		rchat_tab:Size(RightChatPanel:GetWidth() /3,PANEL_HEIGHT)
		rchat_tab:Point("RIGHT", RightChatTab_Datatext_Panel2, "LEFT")
		rchat_tab:SetFrameStrata('LOW')

		rchat_tab2:Size((RightChatPanel:GetWidth() / 3),PANEL_HEIGHT)
		rchat_tab2:Point("TOPRIGHT", RightChatTab, "TOPRIGHT", 0, 0) -- if you use the skada embed code you might need to adjust the x-offset to allow room for the arrow button
		rchat_tab2:SetFrameStrata('LOW')

		RightChatTab:HookScript("OnHide", function() 
			rchat_tab:Hide() 
			rchat_tab2:Hide() 
		end)
		RightChatTab:HookScript("OnShow", function() 
			rchat_tab:Show() 
			rchat_tab:SetAlpha(RightChatTab:GetAlpha()) 
			rchat_tab2:Show() 
			rchat_tab2:SetAlpha(RightChatTab:GetAlpha()) 
		end)
	end
end

 do
	rchat_tab = CreateFrame('Frame', 'RightChatTab_Datatext_Panel', E.UIParent)
	rchat_tab.db ={key='RightChatTab_Datatext_Panel', value = true}
	DT:RegisterPanel(rchat_tab, 1, 'ANCHOR_BOTTOM', 0, -4)
	rchat_tab:Hide()
end

--------------------------------------------------------
-- right chat tabbar2
--------------------------------------------------------
 do
	rchat_tab2 = CreateFrame('Frame', 'RightChatTab_Datatext_Panel2', E.UIParent)
	rchat_tab2.db = {key='RightChatTab_Datatext_Panel2', value = true}
	DT:RegisterPanel(rchat_tab2, 1, 'ANCHOR_BOTTOM', 0, -4)
	rchat_tab2:Hide()
end

--------------------------------------------------------
-- extra bar					
--------------------------------------------------------

do
	extra_bar = CreateFrame('Frame', 'Extra_Datatext_Panel', E.UIParent)
	extra_bar.db = {key ='Extra_Datatext_Panel', value = true}
	extra_bar:SetTemplate('Transparent', true)
	extra_bar:SetFrameLevel(0)
	extra_bar:SetFrameStrata('BACKGROUND')
	extra_bar:SetPoint("BOTTOMLEFT", E.UIParent, "BOTTOMLEFT", -E.mult, -E.mult)
	extra_bar:SetPoint("BOTTOMRIGHT", E.UIParent, "BOTTOMRIGHT", E.mult, -E.mult) 
		
	top_panel = CreateFrame('Frame', 'Top_Panel', E.UIParent)
	top_panel.db = { key='Top_Panel', value = true }
	top_panel:SetPoint("TOPLEFT", E.UIParent, "TOPLEFT", -E.mult, E.mult)
	top_panel:SetPoint("TOPRIGHT", E.UIParent, "TOPRIGHT", E.mult, E.mult)
	top_panel:SetTemplate('Transparent', true)
	top_panel:SetFrameStrata('BACKGROUND')
	top_panel:SetFrameLevel(0)
end	

function DT:MoveChats()
	if E.db.datatexts.moveChats then
		LeftChatPanel:Point('BOTTOMLEFT', E.UIParent, 4, E.db.datatexts.chatOffset)
		RightChatPanel:Point('BOTTOMRIGHT', E.UIParent, -4, E.db.datatexts.chatOffset)
	else
		LeftChatPanel:Point('BOTTOMLEFT', E.UIParent, 4, 4)
		RightChatPanel:Point('BOTTOMRIGHT', E.UIParent, -4, 4)
	end
end


function DT:CheckLayout()
	if E.db.datatexts.enableBottom then
		RightChatPanel:SetFrameStrata('BACKGROUND')
		RightChatPanel:SetFrameLevel(3)
	end
	
	if E.db.datatexts.enableBottom then
		LeftChatPanel:SetFrameStrata('BACKGROUND')
		LeftChatPanel:SetFrameLevel(3)
	end
end

function DT:CheckExtra()
	if E.db.datatexts.enableTop then
		top_panel:Show()
	else
		top_panel:Hide()
	end
	
	if E.db.datatexts.enableBottom then
		extra_bar:Show()
	else
		extra_bar:Hide()
	end
end

function DT:ChangePanelSize()
	top_panel:Size(E.UIParent:GetWidth() + (E.mult * 2), E.db.datatexts.topSize)
	extra_bar:Size(E.UIParent:GetWidth() + (E.mult * 2), E.db.datatexts.bottomSize)
	bottom_bar:Size(E.db.datatexts.bottomWidth, PANEL_HEIGHT)
	top_bar:Size(E.db.datatexts.topWidth, PANEL_HEIGHT)
	ldb_one:Size(E.db.datatexts.ldbOneWidth, PANEL_HEIGHT)
	ldb_two:Size(E.db.datatexts.ldbTwoWidth, PANEL_HEIGHT)
	ldb_three:Size(E.db.datatexts.ldbThreeWidth, PANEL_HEIGHT)
	DT:UpdateAllDimensions()
end

--------------------------------------------------------
-- bottom bar					
--------------------------------------------------------
bottom_bar = CreateFrame('Frame', 'Bottom_Datatext_Panel', E.UIParent)
bottom_bar.db = {key ='Bottom_Datatext_Panel', value = true}
DT:RegisterPanel(bottom_bar, 3, 'ANCHOR_BOTTOM', 0, -4)
function DT:BottomBarDP()
	bottom_bar:SetTemplate('Default', true)
	bottom_bar:SetFrameStrata('LOW')
	bottom_bar:SetFrameLevel(1)
	bottom_bar:Point('BOTTOM', E.UIParent, 'BOTTOM', 0, -E.mult - 3)
	bottom_bar:SetScript('OnShow', function(self) 
		self:Size(E.db.datatexts.bottomWidth, PANEL_HEIGHT); 
		E:CreateMover(self, "BottomBarMover", "Bottom Datatext Frame") 
	end)
	bottom_bar:Hide()
end



--------------------------------------------------------
-- top bar
--------------------------------------------------------
top_bar = CreateFrame('Frame', 'TOP_TESTPANEL', E.UIParent)
top_bar.db = { key='TOP_TESTPANEL', value = true }
DT:RegisterPanel(top_bar, 3, 'ANCHOR_BOTTOM', 0, -4)
function DT:TopBarDP()
	top_bar:Size(E.db.datatexts.topWidth, PANEL_HEIGHT)
	top_bar:Point("TOP", E.UIParent, "TOP", 0, -E.mult)
	top_bar:SetTemplate('Default', true)
	top_bar:SetFrameStrata('LOW')
	E:CreateMover(top_bar, "TopBarMover", "Top Datatext Frame")
	top_bar:Hide()
end



	
--------------------------------------------------------
-- exp/rep bar	
--------------------------------------------------------
local function exp_rep_tab_setup()
	ElvUI_ReputationBar:HookScript('OnUpdate', function() 
		local parent_alpha = ElvUI_ReputationBar:GetAlpha()
		local parent_alpha = ElvUI_ReputationBar:GetAlpha()
		if exp_rep:GetAlpha() ~= parent_alpha then exp_rep:SetAlpha( parent_alpha) end
	end )	
end

--Look at bottom panel for comments
exp_rep = CreateFrame('Frame', 'EXP_REP_TESTPANEL', E.UIParent)
exp_rep.db = {key='EXP_REP_TESTPANEL', value = true}
DT:RegisterPanel(exp_rep, 1, 'ANCHOR_BOTTOM', 0, -4)
function DT:ExpRepBarDP()
	exp_rep:Point("TOPLEFT", ElvUI_ReputationBar, "BOTTOMLEFT", 0, -E.mult)
	exp_rep:SetTemplate('Default', true)
	exp_rep:Point("TOPLEFT", ElvUI_ReputationBar, "BOTTOMLEFT", 0, -E.mult); 
	exp_rep:SetFrameStrata('BACKGROUND')
	exp_rep:Hide()
	exp_rep:SetScript('OnShow', function(self) 
		self:Size(ElvUI_ReputationBar:GetWidth(), PANEL_HEIGHT)
		E:CreateMover(exp_rep, "ExpBarMover", "Exp/Rep Datatext Frame") 
	end)
end

function DT:ExpRepMouseOver()
	if E.db.datatexts.expMouseover then
			exp_rep:SetScript("OnUpdate", function(self,event,...)
				if MouseIsOver(EXP_REP_TESTPANEL) then
					exp_rep:SetAlpha(1)
				else
					exp_rep:SetAlpha(0)
				end
			end)
		
	end
	
	if not E.db.datatexts.expMouseover then
		exp_rep:SetScript("OnUpdate", nil)
		exp_rep:SetAlpha(1)
	end
	
end

--------------------------------------------------------
-- Extra Bars for Addon LDBs
--------------------------------------------------------

function DT:CheckAPanels()
	if E.db.datatexts.ldbOne then
		ldb_one:Show()
	else
		ldb_one:Hide()
	end
	
	if E.db.datatexts.ldbTwo then
		ldb_two:Show()
	else
		ldb_two:Hide()
	end
	
	if E.db.datatexts.ldbThree then
		ldb_three:Show()
	else
		ldb_three:Hide()
	end
end

function DT:CheckLDBMouseover()
	if E.db.datatexts.ldbOneMouseover then
		ldb_one:SetScript("OnUpdate", function (self,event,...)
			if MouseIsOver(LDB_One) then
				ldb_one:SetAlpha(1)
			else
				ldb_one:SetAlpha(0)
			end
		end)
	else
		ldb_one:SetScript("OnUpdate", nil)
		ldb_one:SetAlpha(1)
	end
	
	if E.db.datatexts.ldbTwoMouseover then
		ldb_two:SetScript("OnUpdate", function (self,event,...)
			if MouseIsOver(LDB_Two) then
				ldb_two:SetAlpha(1)
			else
				ldb_two:SetAlpha(0)
			end
		end)
	else
		ldb_two:SetScript("OnUpdate", nil)
		ldb_two:SetAlpha(1)
	end
	
	if E.db.datatexts.ldbThreeMouseover then
		ldb_three:SetScript("OnUpdate", function (self,event,...)
			if MouseIsOver(LDB_Three) then
				ldb_three:SetAlpha(1)
			else
				ldb_three:SetAlpha(0)
			end
		end)
	else
		ldb_three:SetScript("OnUpdate", nil)
		ldb_three:SetAlpha(1)
	end
	
end


if E.db.datatexts.ldbOneDataPanel == 1 then
	ldb_one = CreateFrame('Frame', 'LDB_One', E.UIParent)
	ldb_one.db = { key='LDB_One', value = true }
	DT:RegisterPanel(ldb_one, 1, 'ANCHOR_BOTTOM', 0, -4)
	function DT:LDBOneDP()
		ldb_one:SetTemplate('Default', true)
		ldb_one:SetFrameStrata('HIGH')
		ldb_one:SetFrameLevel(1)
		ldb_one:Point("LEFT", Bottom_Datatext_Panel, "RIGHT", 1, 1)
		ldb_one:SetScript('OnShow', function(self)
			self:Size(E.db.datatexts.ldbOneWidth, PANEL_HEIGHT);
			E:CreateMover(ldb_one, "ExtraOneMover", "Extra One")
		end)
		ldb_one:Hide()
	end
end

if E.db.datatexts.ldbOneDataPanel == 2 then
	ldb_one = CreateFrame('Frame', 'LDB_One', E.UIParent)
	ldb_one.db = { key='LDB_One', value = true }
	DT:RegisterPanel(ldb_one, 1, 'ANCHOR_BOTTOM', 0, -4)
	function DT:LDBOneDP()
		ldb_one:SetTemplate('Default', true)
		ldb_one:SetFrameStrata('HIGH')
		ldb_one:SetFrameLevel(1)
		ldb_one:Point("LEFT", Bottom_Datatext_Panel, "RIGHT", 1, 1)
		ldb_one:SetScript('OnShow', function(self)
			self:Size(E.db.datatexts.ldbOneWidth, PANEL_HEIGHT);
			E:CreateMover(ldb_one, "ExtraOneMover", "Extra One")
		end)
		ldb_one:Hide()
	end
end

if E.db.datatexts.ldbOneDataPanel == 3 then
	ldb_one = CreateFrame('Frame', 'LDB_One', E.UIParent)
	ldb_one.db = { key='LDB_One', value = true }
	DT:RegisterPanel(ldb_one, 3, 'ANCHOR_BOTTOM', 0, -4)
	function DT:LDBOneDP()
		ldb_one:SetTemplate('Default', true)
		ldb_one:SetFrameStrata('HIGH')
		ldb_one:SetFrameLevel(1)
		ldb_one:Point("LEFT", Bottom_Datatext_Panel, "RIGHT", 1, 1)
		ldb_one:SetScript('OnShow', function(self)
			self:Size(E.db.datatexts.ldbOneWidth, PANEL_HEIGHT);
			E:CreateMover(ldb_one, "ExtraOneMover", "Extra One")
		end)
		ldb_one:Hide()
	end
end

if E.db.datatexts.ldbTwoDataPanel == 1 then
	ldb_two = CreateFrame('Frame', 'LDB_Two', E.UIParent)
	ldb_two.db = { key='LDB_Two', value = true }
	DT:RegisterPanel(ldb_two, 1, 'ANCHOR_BOTTOM', 0, -4)
	function DT:LDBTwoDP()
		ldb_two:SetTemplate('Default', true)
		ldb_two:SetFrameStrata('HIGH')
		ldb_two:SetFrameLevel(1)
		ldb_two:Point("LEFT", LDB_One, "RIGHT", 0, 0)
		ldb_two:SetScript('OnShow', function(self)
			self:Size(E.db.datatexts.ldbTwoWidth, PANEL_HEIGHT);
			E:CreateMover(ldb_two, "ExtraTwoMover", "Extra Two")
		end)
		ldb_two:Hide()
	end
end

if E.db.datatexts.ldbTwoDataPanel == 2 then
	ldb_two = CreateFrame('Frame', 'LDB_Two', E.UIParent)
	ldb_two.db = { key='LDB_Two', value = true }
	DT:RegisterPanel(ldb_two, 1, 'ANCHOR_BOTTOM', 0, -4)
	function DT:LDBTwoDP()
		ldb_two:SetTemplate('Default', true)
		ldb_two:SetFrameStrata('HIGH')
		ldb_two:SetFrameLevel(1)
		ldb_two:Point("LEFT", LDB_One, "RIGHT", 0, 0)
		ldb_two:SetScript('OnShow', function(self)
			self:Size(E.db.datatexts.ldbTwoWidth, PANEL_HEIGHT);
			E:CreateMover(ldb_two, "ExtraTwoMover", "Extra Two")
		end)
		ldb_two:Hide()
	end
end

if E.db.datatexts.ldbTwoDataPanel == 3 then
	ldb_two = CreateFrame('Frame', 'LDB_Two', E.UIParent)
	ldb_two.db = { key='LDB_Two', value = true }
	DT:RegisterPanel(ldb_two, 3, 'ANCHOR_BOTTOM', 0, -4)
	function DT:LDBTwoDP()
		ldb_two:SetTemplate('Default', true)
		ldb_two:SetFrameStrata('HIGH')
		ldb_two:SetFrameLevel(1)
		ldb_two:Point("LEFT", LDB_One, "RIGHT", 0, 0)
		ldb_two:SetScript('OnShow', function(self)
			self:Size(E.db.datatexts.ldbTwoWidth, PANEL_HEIGHT);
			E:CreateMover(ldb_two, "ExtraTwoMover", "Extra Two")
		end)
		ldb_two:Hide()
	end
end

if E.db.datatexts.ldbThreeDataPanel == 1 then
	ldb_three = CreateFrame('Frame', 'LDB_Three', E.UIParent)
	ldb_three.db = { key='LDB_Three', value = true }
	DT:RegisterPanel(ldb_three, 1, 'ANCHOR_BOTTOM', 0, -4)
	
	function DT:LDBThreeDP()
		ldb_three:SetTemplate('Default', true)
		ldb_three:SetFrameStrata('HIGH')
		ldb_three:SetFrameLevel(1)
		ldb_three:Point("RIGHT", Bottom_Datatext_Panel, "LEFT", -1, 1)
		ldb_three:SetScript('OnShow', function(self)
			self:Size(E.db.datatexts.ldbThreeWidth, PANEL_HEIGHT);
			E:CreateMover(ldb_three, "ExtraThreeMover", "Extra Three")
		end)
		ldb_three:Hide()
	end
end	

if E.db.datatexts.ldbThreeDataPanel == 2 then
	ldb_three = CreateFrame('Frame', 'LDB_Three', E.UIParent)
	ldb_three.db = { key='LDB_Three', value = true }
	DT:RegisterPanel(ldb_three, 1, 'ANCHOR_BOTTOM', 0, -4)
	
	function DT:LDBThreeDP()
		ldb_three:SetTemplate('Default', true)
		ldb_three:SetFrameStrata('HIGH')
		ldb_three:SetFrameLevel(1)
		ldb_three:Point("RIGHT", Bottom_Datatext_Panel, "LEFT", -1, 1)
		ldb_three:SetScript('OnShow', function(self)
			self:Size(E.db.datatexts.ldbThreeWidth, PANEL_HEIGHT);
			E:CreateMover(ldb_three, "ExtraThreeMover", "Extra Three")
		end)
		ldb_three:Hide()
	end
end	

if E.db.datatexts.ldbThreeDataPanel == 3 then
	ldb_three = CreateFrame('Frame', 'LDB_Three', E.UIParent)
	ldb_three.db = { key='LDB_Three', value = true }
	DT:RegisterPanel(ldb_three, 3, 'ANCHOR_BOTTOM', 0, -4)
	
	function DT:LDBThreeDP()
		ldb_three:SetTemplate('Default', true)
		ldb_three:SetFrameStrata('HIGH')
		ldb_three:SetFrameLevel(1)
		ldb_three:Point("RIGHT", Bottom_Datatext_Panel, "LEFT", -1, 1)
		ldb_three:SetScript('OnShow', function(self)
			self:Size(E.db.datatexts.ldbThreeWidth, PANEL_HEIGHT);
			E:CreateMover(ldb_three, "ExtraThreeMover", "Extra Three")
		end)
		ldb_three:Hide()
	end
end	
	
--------------------------------------------------------
-- Toggling via ingame config
--------------------------------------------------------

function DT:CheckTop()
	if E.db.datatexts.topCenter then
		top_bar:Show()
	else
		top_bar:Hide()
	end	
end

function DT:CheckBottom()
	if E.db.datatexts.bottomBar then
		bottom_bar:Show()
	else
		bottom_bar:Hide()
	end
end

function DT:CheckXP()
	if E.db.datatexts.xpRep then
		exp_rep:Show()
	else
		exp_rep:Hide()
	end
end

function DT:CheckLeftChat()
	if E.db.datatexts.leftChat then
		lchat_tab:Show()
	else
		lchat_tab:Hide()
	end
end

function DT:CheckRightChat()
	if E.db.datatexts.rightChat then
		rchat_tab:Show()
		rchat_tab2:Show()
	else
		rchat_tab:Hide()
		rchat_tab2:Hide()
	end
end
--
-- Table O' Frame tables! we parse and check for GetName() to toggle show/hide :) saves some very nasty lines of code.
--
ElvUI_DTbar._table = {
	top_bar,
	bottom_bar,
	exp_rep,
	lchat_tab,
	rchat_tab,
	rchat_tab2,
	ldb_one,
	ldb_two,
	ldb_three,
}
 
function DT:Loading() 
	SlashCmdList["ElvUI_DTbar"] = SlashHandler
	SLASH_ElvUI_DTbar1 = "/dtbar"
	DT:BottomBarDP()
	DT:TopBarDP()
	DT:LDBOneDP()
	DT:MoveChats()
	DT:LDBTwoDP()
	DT:LDBThreeDP()
	lchat_tab_setup()
	rchat_tab_setup()
	exp_rep_tab_setup()
	DT:ExpRepBarDP()
	DT:CheckLDBMouseover()
	DT:CheckAPanels()
	DT:CheckExtra() 
	DT:CheckTop()
	DT:CheckBottom()
	DT:CheckXP()
	DT:CheckLeftChat()
	DT:CheckRightChat()
	DT:ChangePanelSize()
	DT:CheckLayout()

	for name, obj in Broker.ldb:DataObjectIterator() do
		if obj.OnCreate then obj.OnCreate(obj, Frame) end
		pluginObject[name] = obj
	end
	
	-- this is 'pass #2' here we setup call back functions for whatever ldb's we have listed.
	-- problem is we can't reg the callback's on pass #1 because not all of the ldb's are loaded at that tiem.
	for k,v in ipairs(DTBar_ldb) do
		local textUpdate = function(_, name, _, data)
			if Broker.ldb[v] and Broker.ldb[v].Update then
				pluginObjects[v] = data
				Broker.ldb[v].Update(data)
			end
		end
		
		local ValueUpdate = function(_, name, _, data, obj)
			if Broker.ldb[v] then 
				pluginObjects[v] = data
			end
		end
		
		print ('LDB registered call back: '..v)
		Broker.ldb.RegisterCallback(Broker, "LibDataBroker_AttributeChanged_"..v.."_text", textUpdate)
		Broker.ldb.RegisterCallback(Broker, "LibDataBroker_AttributeChanged_"..v.."_value", ValueUpdate)
	end
	----------

	
	--ElvUF_Player.Castbar:SetParent(Castbar)
	
	--Castbar:SetParent(ElvUF_Player)
	
	--E:CreateMover(Castbar, "Player Castbar Mover", "CastMover Frame")	
	----------
	self:UnregisterEvent("PLAYER_ENTERING_WORLD");
end









Broker:SetScript("OnEvent", function(_, event, ...) Broker[event](Broker, ...) end)

local _self = {}  --local table to discover WTF we are.

pluginObject = pluginObject or {}

local Frame = CreateFrame('Frame', 'ldb frame', E.UIParent)
	Frame:EnableMouse(true)
	Frame:SetBackdropColor(0,0,0,0) 
	Frame:Hide()

Broker.ldb.frame = Frame
Broker.ldb.obj = pluginObject

function DT:DefaultsSet() 
	if E.db.datatexts.enableTop == nil then
		E.db.datatexts.enableTop = false
	end
	
	if E.db.datatexts.enableBottom == nil then
		E.db.datatexts.enableBottom = false
	end
	
	if E.db.datatexts.topCenter == nil then
		E.db.datatexts.topCenter = false
	end

	if E.db.datatexts.bottomBar == nil then
		E.db.datatexts.bottomBar = false
	end
	
	if E.db.datatexts.leftChat == nil then
		E.db.datatexts.leftChat = false
	end
	
	if E.db.datatexts.rightChat == nil then
		E.db.datatexts.rightChat = false
	end
	
	if E.db.datatexts.xpRep == nil then
		E.db.datatexts.xpRep = false
	end
	
	if E.db.datatexts.topSize == nil then
		E.db.datatexts.topSize = 22
	end	
	
	if E.db.datatexts.bottomSize == nil then
		E.db.datatexts.bottomSize = 22
	end
	
	if E.db.datatexts.topWidth == nil then
		E.db.datatexts.topWidth = 350
	end
	
	if E.db.datatexts.bottomWidth == nil then
		E.db.datatexts.bottomWidth = 400
	end
	
	if E.db.datatexts.expMouseover == nil then
		E.db.datatexts.expMouseover = false
	end
	
	if E.db.datatexts.ldbOne == nil then
		E.db.datatexts.ldbOne = false
	end
	
	if E.db.datatexts.ldbOneWidth == nil then
		E.db.datatexts.ldbOneWidth = 330
	end
	
	if E.db.datatexts.ldbOneMouseover == nil then
		E.db.datatexts.ldbOneMouseover = false
	end
	
	if E.db.datatexts.ldbTwo == nil then
		E.db.datatexts.ldbTwo = false
	end
	
	if E.db.datatexts.ldbTwoWidth == nil then
		E.db.datatexts.ldbTwoWidth = 330
	end
	
	if E.db.datatexts.ldbTwoMouseover == nil then
		E.db.datatexts.ldbTwoMouseover = false
	end
	
	if E.db.datatexts.ldbThree == nil then
		E.db.datatexts.ldbThree = false
	end
	
	if E.db.datatexts.ldbThreeWidth == nil then
		E.db.datatexts.ldbThreeWidth = 330
	end
	
	if E.db.datatexts.ldbThreeMouseover == nil then
		E.db.datatexts.ldbThreeMouseover = false
	end
	
	if E.db.datatexts.moveChats == nil then
		E.db.datatexts.moveChats = false
	end
	
	if E.db.datatexts.chatOffset == nil then
		E.db.datatexts.chatOffset = 4
	end
	
	if E.db.datatexts.ldbOneDataPanel == nil then
		E.db.datatexts.ldbOneDataPanel = 3
	end
	
	if E.db.datatexts.ldbTwoDataPanel == nil then
		E.db.datatexts.ldbTwoDataPanel = 3
	end
	
	if E.db.datatexts.ldbThreeDataPanel == nil then
		E.db.datatexts.ldbThreeDataPanel = 3
	end
end

--Hooking to DT module initialize function
DT.InitializeBar = DT.Initialize
function DT:Initialize()
	DT.InitializeBar(self)
	DT:DefaultsSet()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "Loading")
end