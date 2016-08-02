--[[
Interface: 6.0.0
Title: LibBalancePowerTracker
Version: 2.0.1
Author: Kurohoshi (EU-Minahonda)

--INFO
	LibBalancePowerTracker is a library designed to provide the foresee energy feature to Balance Druids.
	CPU is only used when required, so the CPU usage is very low (busy waitting forbidden, always on demand).
	
	FORESEE ENERGY:
	Foresee Energy is a feature that analizes the spells you are casting but are yet to be finished, providing 
	addons with a feature to calculate the energy the player will have once they finish the cast/GCD
	This allows the library to distinguish between two kinds of energy and Eclipse direction: One real, 
	the one you have at the moment and other virtual, the one you'll have when you finish your cast.
	All the features with the 'virtual' tag (virtual Energy, virtual Eclipse ...) rely on Foresee Energy.
	
--API
	There are 7 variables related to Eclipse energy used in this addon:
		energy: The energy you have at the moment. Int = [-100,100]
		direction: The direction of the arrow. String = {"none","sun","moon"}
		virtual_energy: The energy you will have when the spell you're casting and all the flying spells land. Int = [-100,100]
		virtual_direction: The direction of the arrow when the spell you're casting and all the flying spells land. String = {"none","sun","moon"}
		peak: -100 if you have lunar, 100 if solar, false otherwise. 
		virtual_peak: -100 if it WILL proc lunar, 100 if solar, false otherwise.
		reach_End: If 100 or -100 is going to be reached

	FUNCTIONS:

	id = LibBalancePowerTracker:RegisterCallback(function(energy, direction, peak, virtual_energy, virtual_direction, virtual_peak, reachEnd))
	These callbacks will be fired when there is a change in one of the Eclipse energy variables.
	NOTE: When registering a callback, that callback will be fired once to initialize values.
		
	failed = LibBalancePowerTracker:UnregisterCallback(id)
	Tries to unregister the callback with identifier id (id is returned only when you register the callback).
	
	energy, direction, peak, virtual_energy, virtual_direction, virtual_peak, reachEnd = LibBalancePowerTracker:GetEclipseEnergyInfo()
	Gets the current state of the variables.
	
	version,subversion,revision = LibBalancePowerTracker:GetVersion()
	Gets the current working version of the library.	

	TODO list:
 		Prediction when starting at peak
		CA + AC prediction too wrong
		Improve prediction

--CHANGELOG
v 2.0.1 Improved death recognition
		Fixed Euphoria recognition on teleport

v 2.0.0 Complete overhaul for 6.00.00
--]]

local version = {2,0,1};
if (LibBalancePowerTracker and LibBalancePowerTracker.CompareVersion and LibBalancePowerTracker:CompareVersion(version)) then return; end;
if select(4, GetBuildInfo())<60000 then return; end;

--Initialize Global Lib
LibBalancePowerTracker = {}; --Public lib
function LibBalancePowerTracker:CompareVersion(versionTable) 
	-- if mine is equal or better than versionTable, return true
	for i,v in ipairs(versionTable) do
		if version[i] ~= v then
			return version[i] > v;
		end;
	end;
	return true;
end;


-----------------------------------------------------------------------------------------
----GLOBAL FUNCTIONS TO LOCALS-----------------------------------------------------------
local GetEclipseDirection,UnitPower = GetEclipseDirection,UnitPower;
local UnitGUID,UnitBuff,GetTalentInfo,GetSpellInfo,GetSpellCooldown = UnitGUID,UnitBuff,GetTalentInfo,GetSpellInfo,GetSpellCooldown
local GetInventoryItemID,abs,pairs,ipairs,tonumber,GetSpecialization,GetTime,select,GetActiveSpecGroup = GetInventoryItemID,abs,pairs,ipairs,tonumber,GetSpecialization,GetTime,select,GetActiveSpecGroup
local UnitCastingInfo,UnitChannelInfo,UnitAffectingCombat = UnitCastingInfo,UnitChannelInfo,UnitAffectingCombat;
-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------
----Local LIB table
local LBPT = {};
----FRAME--------------------------------------------------------------------------------
local frame = CreateFrame("Frame",nil,UIParent); -- loading events
local combatFrame = CreateFrame("Frame",nil,UIParent); --Combat events
----DATA---------------------------------------------------------------------------------
------CONSTS-----------------------------------------------------------------------------
local ECLIPSE = 'ECLIPSE'
local NO_DIRECTION = 'none'
local MOON_DIRECTION = 'moon'
local SUN_DIRECTION = 'sun' 
local PLAYER = 'player'
local SPELL_POWER_ECLIPSE = SPELL_POWER_ECLIPSE
------STATIC-----------------------------------------------------------------------------
local data ={
	spellsId = {
		AC	= 127663, -- Astral Comunion id
		CA	= 112071, -- Celestial Aligment buff id
		SP  = 171744, -- Solar peak buff id -- Not needed
		LP  = 171743, -- Lunar peak buff id -- Not needed
	},
	spellsNames = {},
	
	eclipse_halfcycle_total = 20,
	
	--tiers that modify anything 
	balanceTiersItemId ={ --Pieces of bonus that change things
		[12]={
			[1]={ [0]="n",[0]="h"},--head
			[3]={ [0]="n",[0]="h"},--shoulders
			[5]={ [0]="n",[0]="h"},--chest
			[7]={ [0]="n",[0]="h"},--trousers
			[10]={[0]="n",[0]="h"},--gloves
			bonus4p = true,
			tested4p = true,
		},
	},
}
for k,v in pairs(data.spellsId) do data.spellsNames[k] = GetSpellInfo(v) end
------VARS-------------------------------------------------------------------------------
local vars = {
	playerGUID = false,
	lastCallback = 0,
	callbacks = {},
	number_callbacks = 0,
	
	isDruid = nil,
	isBalance = nil,
	euforia = false,
	
	eclipseActive = false,
	
	spell_casting = 0,
	spell_num = 0,
	spellIsChannel = false,
	gcd_lockout_end = 0,
	spell_lockout_end = 0,
	celestial_lockout_end = 0,
	
	energy = 0,
	vEnergy = 0,
	peak = false,
	vPeak = false,
	reachEnd = false,
	direction = NO_DIRECTION,
	vDirection = NO_DIRECTION,

	tiers = {
		[1]=false,--head
		[3]=false,--shoulders
		[5]=false,--chest
		[7]=false,--trousers
		[10]=false,--gloves
		tierPieceCount = setmetatable({}, {__index = function () return 0 end}),
	},
	
	timer_broadcastTier = CreateFrame("Cooldown",nil,combatFrame)
}
-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------
do --API----------------------------------------------------------------------------------
	function LBPT.FireCallbacks()
		for k,v in pairs(vars.callbacks) 		
			do v(vars.energy,vars.direction,vars.peak,vars.vEnergy,vars.vDirection,vars.vPeak,vars.reachEnd); 	
		end; 
	end;
	
	function LibBalancePowerTracker:RegisterCallback(callback)
		if vars.number_callbacks==0 and LBPT.postLogin and vars.isDruid then
			LBPT.load();
		end
		
		vars.number_callbacks = vars.number_callbacks + 1
		vars.lastCallback     = vars.lastCallback     + 1
		vars.callbacks[vars.lastCallback] = callback;

		callback(vars.energy,vars.direction,vars.peak,vars.vEnergy,vars.vDirection,vars.vPeak,vars.reachEnd)
		return vars.lastCallback
	end
	function LibBalancePowerTracker:UnregisterCallback(id)
		if vars.callbacks[id] then
			vars.callbacks[id] = nil;
		else
			return true;
		end
		
		vars.number_callbacks = vars.number_callbacks - 1
		
		if vars.number_callbacks == 0 then
			LBPT.unload();
		end
	end
	function LibBalancePowerTracker:GetVersion()
		return unpack(version); 
	end;
	
	--If called once, it would be called again, so I create a callback inside this do-end block
	local results;
	local callbackId = nil
	function LibBalancePowerTracker:GetEclipseEnergyInfo()
		if not callbackId then callbackId = self:RegisterCallback(function(...) results = {...} end) end
		return unpack(results)
	end
	
	
	function LibBalancePowerTracker:NextPeakAt() return vars.nextPeakAt	end
end
-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------
do --Energy Cache-------------
	local cacheTable = {};
	LBPT.cacheTable = cacheTable;
	
	local lastEnergizeEvent = {
		timestamp = 0,
		energy = 0,
	}
	local lastCAbuff = {
		timestampGain = 0,
		timestampEnergizeEvent = 0,
		energy = 0, 
	}
	cacheTable.cacheCAproc = function(gain, timestamp)
		if gain then
			lastCAbuff.timestampGain = timestamp
			lastCAbuff.timestampEnergizeEvent = lastEnergizeEvent.timestamp
			lastCAbuff.energy = lastEnergizeEvent.energy
		else
			lastEnergizeEvent.energy = lastCAbuff.energy
			lastEnergizeEvent.timestamp = timestamp - lastCAbuff.timestampGain + lastCAbuff.timestampEnergizeEvent; 
		end
	end
	

	--## SavedVariables: BalancePowerTracker_Options
	local gathering = false
	local start = false
	function LibBalancePowerTracker:Gather()
		BalancePowerTracker_Options = BalancePowerTracker_Options or {}
		BalancePowerTracker_Options.libBPT_data = {
			total = {
				avg = {},
				sum = {},
				num = {},
				all = {},
				moda = {},
			}
		}
		gathering = true
	end

	cacheTable.gotEnergyAt = function(energy, timestamp)
		lastEnergizeEvent.timestamp = timestamp
		lastEnergizeEvent.energy = energy
		
		if gathering then
			if abs(energy) == 100 then start = timestamp end
			energy = energy +101
			if start then
				local actual = (timestamp - start) % data.eclipse_halfcycle_total
				if not BalancePowerTracker_Options.libBPT_data.total.num[energy] then
					BalancePowerTracker_Options.libBPT_data.total.num[energy] = 1
					BalancePowerTracker_Options.libBPT_data.total.sum[energy] = actual
					BalancePowerTracker_Options.libBPT_data.total.avg[energy] = actual
					
					BalancePowerTracker_Options.libBPT_data.total.all[energy] = {actual}
					BalancePowerTracker_Options.libBPT_data.total.moda[energy] = actual
				else
					BalancePowerTracker_Options.libBPT_data.total.num[energy] = BalancePowerTracker_Options.libBPT_data.total.num[energy] + 1
					BalancePowerTracker_Options.libBPT_data.total.sum[energy] = BalancePowerTracker_Options.libBPT_data.total.sum[energy] + actual
					BalancePowerTracker_Options.libBPT_data.total.avg[energy] = BalancePowerTracker_Options.libBPT_data.total.sum[energy] / BalancePowerTracker_Options.libBPT_data.total.num[energy]
				
					table.insert(BalancePowerTracker_Options.libBPT_data.total.all[energy], actual)
					table.sort(BalancePowerTracker_Options.libBPT_data.total.all[energy])
					BalancePowerTracker_Options.libBPT_data.total.moda[energy] = BalancePowerTracker_Options.libBPT_data.total.all[energy][math.floor(BalancePowerTracker_Options.libBPT_data.total.num[energy]*0.5)]
				end	
			end
		end
	end
	
	local function getFactor()
		if vars.spell_casting == data.spellsId.AC then
			return 0.25
		end
		return 1;
	end
	local function getInverseFactor()
		if vars.spell_casting == data.spellsId.AC then
			return 4
		end
		return 1;
	end

	--[[
	local accessTable = {
		0,
		3.96900000004098, -- [2]
		4.18400000000838, -- [3]
		4.34999999997672, -- [4]
		4.51999999996042, -- [5]
		4.64899999997579, -- [6]
		4.79399999999441, -- [7]
		4.96899999998277, -- [8]
		5.09999999997672, -- [9]
		5.21299999998882, -- [10]
		5.32600000000093, -- [11]
		5.44000000000233, -- [12]
		5.55499999999302, -- [13]
		5.6699999999837, -- [14]
		5.79200000001583, -- [15]
		5.89500000001863, -- [16]
		6.00800000003073, -- [17]
		6.10799999994924, -- [18]
		6.2160000000149, -- [19]
		6.32000000000699, -- [20]
		6.4100000000326, -- [21]
		6.47099999996135, -- [22]
		6.58699999999953, -- [23]
		6.67900000000373, -- [24]
		6.77000000001863, -- [25]
		6.85499999998137, -- [26]
		6.92300000000978, -- [27]
		7.0229999999865, -- [28]
		7.1140000000014, -- [29]
		7.19800000003306, -- [30]
		7.25099999998929, -- [31]
		7.35899999999674, -- [32]
		7.44599999999628, -- [33]
		7.50699999998324, -- [34]
		7.59799999999814, -- [35]
		7.67599999997765, -- [36]
		7.73399999999674, -- [37]
		7.81599999999162, -- [38]
		7.90600000001723, -- [39]
		7.9890000000014, -- [40]
		8.04700000002049, -- [41]
		8.13799999997718, -- [42]
		8.18099999998231, -- [43]
		8.2729999999865, -- [44]
		8.35300000000279, -- [45]
		8.40400000003865, -- [46]
		8.48000000003958, -- [47]
		8.5679999999702, -- [48]
		8.62699999997858, -- [49]
		8.69999999995343, -- [50]
		8.77600000001257, -- [51]
		8.83400000003167, -- [52]
		8.93599999998696, -- [53]
		8.96299999998882, -- [54]
		9.04899999999907, -- [55]
		9.09099999995669, -- [56]
		9.17999999999302, -- [57]
		9.24900000001071, -- [58]
		9.30800000001909, -- [59]
		9.38299999997253, -- [60]
		9.42200000002049, -- [61]
		9.51000000000931, -- [62]
		9.55599999998231, -- [63]
		9.62799999996787, -- [64]
		9.72300000005635, -- [65]
		9.76400000002468, -- [66]
		9.8399999999674, -- [67]
		9.87800000002608, -- [68]
		9.9539999999688, -- [69]
		10.0059999999939, -- [70]
		10.0899999999674, -- [71]
		10.1460000000079, -- [72]
		10.2069999999949, -- [73]
		10.2820000000065, -- [74]
		10.3439999999828, -- [75]
		10.405999999959, -- [76]
		10.4440000000177, -- [77]
		10.5169999999925, -- [78]
		10.6170000000275, -- [79]
		10.6429999999818, -- [80]
		10.7320000000182, -- [81]
		10.7689999999711, -- [82]
		10.8229999999749, -- [83]
		10.8960000000079, -- [84]
		10.9589999999735, -- [85]
		11.0100000000093, -- [86]
		11.0829999999842, -- [87]
		11.1300000000047, -- [88]
		11.1969999999856, -- [89]
		11.2989999999991, -- [90]
		11.3239999999641, -- [91]
		11.4239999999991, -- [92]
		11.4379999999655, -- [93]
		11.5339999999851, -- [94]
		11.5689999999595, -- [95]
		11.6129999999539, -- [96]
		11.6819999999716, -- [97]
		11.7579999999725, -- [98]
		11.8010000000359, -- [99]
		11.8740000000107, -- [100]
		11.9799999999814, -- [101]
		12.0910000000149, -- [102]
		12.0970000000088, -- [103]
		12.2060000000056, -- [104]
		12.2149999999674, -- [105]
		12.3219999999856, -- [106]
		12.3409999999567, -- [107]
		12.4469999999856, -- [108]
		12.4599999999627, -- [109]
		12.545999999973, -- [110]
		12.5960000000196, -- [111]
		12.6669999999576, -- [112]
		12.7229999999981, -- [113]
		12.7930000000051, -- [114]
		12.8379999999888, -- [115]
		12.8979999999865, -- [116]
		13.0019999999786, -- [117]
		13.0179999999818, -- [118]
		13.1239999999525, -- [119]
		13.1339999999618, -- [120]
		13.2399999999907, -- [121]
		13.2770000000019, -- [122]
		13.3499999999767, -- [123]
		13.3960000000079, -- [124]
		13.4729999999981, -- [125]
		13.5179999999818, -- [126]
		13.5690000000177, -- [127]
		13.6879999999655, -- [128]
		13.6979999999749, -- [129]
		13.8009999999777, -- [130]
		13.8329999999842, -- [131]
		13.9139999999898, -- [132]
		13.9649999999674, -- [133]
		14.0279999999912, -- [134]
		14.0960000000196, -- [135]
		14.1369999999879, -- [136]
		14.25, -- [137]
		14.2660000000033, -- [138]
		14.36599999998, -- [139]
		14.4189999999944, -- [140]
		14.4789999999921, -- [141]
		14.5920000000042, -- [142]
		14.5929999999935, -- [143]
		14.7110000000102, -- [144]
		14.7419999999693, -- [145]
		14.8189999999595, -- [146]
		14.8910000000033, -- [147]
		14.9380000000238, -- [148]
		15.0409999999683, -- [149]
		15.0839999999735, -- [150]
		15.1500000000233, -- [151]
		15.2430000000168, -- [152]
		15.274000000034, -- [153]
		15.3919999999926, -- [154]
		15.4309999999823, -- [155]
		15.5139999999665, -- [156]
		15.6059999999707, -- [157]
		15.6520000000019, -- [158]
		15.7199999999721, -- [159]
		15.8010000000359, -- [160]
		15.850999999966, -- [161]
		15.9459999999963, -- [162]
		16.0389999999898, -- [163]
		16.0749999999534, -- [164]
		16.1699999999837, -- [165]
		16.2629999999772, -- [166]
		16.3219999999856, -- [167]
		16.411999999953, -- [168]
		16.4739999999874, -- [169]
		16.5749999999534, -- [170]
		16.6339999999618, -- [171]
		16.7320000000182, -- [172]
		16.8199999999488, -- [173]
		16.9029999999912, -- [174]
		16.9739999999874, -- [175]
		17.0799999999581, -- [176]
		17.149000000034, -- [177]
		17.2509999999893, -- [178]
		17.335000000021, -- [179]
		17.4279999999562, -- [180]
		17.5249999999651, -- [181]
		17.6039999999921, -- [182]
		17.7299999999814, -- [183]
		17.8159999999916, -- [184]
		17.9199999999837, -- [185]
		18.0120000000461, -- [186]
		18.1220000000321, -- [187]
		18.2350000000442, -- [188]
		18.3399999999674, -- [189]
		18.4529999999795, -- [190]
		18.5720000000438, -- [191]
		18.6860000000452, -- [192]
		18.8180000000284, -- [193]
		18.945000000007, -- [194]
		19.0890000000363, -- [195]
		19.2189999999828, -- [196]
		19.35699999996, -- [197]
		19.5200000000186, -- [198]
		19.6779999999562, -- [199]
		19.8520000000135, -- [200]
		data.eclipse_halfcycle_total -- [201]
	}]]
	
	--Math
	local min,max,floor,pi,sin,asin = math.min,math.max,math.floor,math.pi,math.sin,math.asin
	local a1,a1i,b1,b1i,c1
	local euphoriaMathValues   = {104.5, 1/3.2, 5.87 }
	local NOeuphoriaMathValues = {104.5, pi/20, 11.89}
	cacheTable.setValues = function(euphoria)
		a1,b1,c1 = unpack((euphoria and euphoriaMathValues) or NOeuphoriaMathValues)
		a1i = 1/a1
		b1i = 1/b1
	end
	cacheTable.setValues(false);
	
	local function searchInCacheByTime(timestamp)
		local temp = sin((timestamp*getInverseFactor()-c1)*b1) * a1
		return min(max(floor(temp),-100),100)
	end
	local function searchInCacheByValue(energy)
		if energy == -100 then
			return 0
		elseif energy == 100 then 
			return data.eclipse_halfcycle_total * getFactor()
		else
			return (asin(energy * a1i)*b1i+c1) *  getFactor()
		end
	end
	local function searchInCacheLastValue()
		return searchInCacheByValue(100)
	end
	
	cacheTable.getEnergyAt = function(energy,timeStart,timeEnd,isCAevent,accurate)
		local timestampEnergize = lastEnergizeEvent.timestamp;
	
		if isCAevent then
			timestampEnergize = timeStart - lastCAbuff.timestampGain + lastCAbuff.timestampEnergizeEvent;
		end
		
		if accurate then
			energy = -100
			timestampEnergize = timeStart
		end
		
		local timeToSearch = searchInCacheByValue(energy) + timeEnd - timestampEnergize
		local eclipse_halfcycle_total = searchInCacheLastValue()
		
		if timeToSearch > eclipse_halfcycle_total then
			return 100,timeEnd - timeToSearch + eclipse_halfcycle_total,true 
		end
		
		energy = searchInCacheByTime(timeToSearch,energy)
	
		return energy,timeEnd,true
	end
end
-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------
do --Loading
	frame:SetScript("OnEvent",  function(_, event, ...) LBPT[event](...) end);
	frame:RegisterEvent("PLAYER_LOGIN");
	LBPT.postLogin = false;
	
	local function isBalance()
		return GetSpecialization() == 1
	end
	
	function LBPT.PLAYER_LOGIN()
		LBPT.postLogin = true;		
		
		vars.isDruid = select(2,UnitClass(PLAYER)) == "DRUID"; 
		vars.playerGUID = UnitGUID(PLAYER);
		
		if vars.isDruid and vars.number_callbacks ~= 0 then 
			LBPT.load()
		end
	end;
	
	function LBPT.load()
		frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
		frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
		
		--Check tier
		for k in pairs(vars.tiers) do if tonumber(k) then LBPT.PLAYER_EQUIPMENT_CHANGED(k,GetInventoryItemID("player", k)) end end
		
		LBPT.PLAYER_SPECIALIZATION_CHANGED()
	end
	
	function LBPT.unload()
		frame:UnregisterAllEvents();
		combatFrame:UnregisterAllEvents();
	end
	
	function LBPT.RegisterCombatEvents(balanceNow)
		if balanceNow then
			for k in pairs(LBPT.combat) do
				combatFrame:RegisterEvent(k);
			end
		else 
			for k in pairs(LBPT.combat) do
				combatFrame:UnregisterEvent(k);
			end
		end
	end
	
	function LBPT.PLAYER_SPECIALIZATION_CHANGED()
		local balanceNow = isBalance()
		vars.isBalance = balanceNow
		
		local euforia = balanceNow and select(4,GetTalentInfo(7,1, GetActiveSpecGroup()))
		if euforia ~= nil then
			vars.euforia = euforia
			data.eclipse_halfcycle_total = (euforia and 10) or 20
			LBPT.cacheTable.setValues(euforia)
		end
		
		LBPT.RegisterCombatEvents(balanceNow)
		LBPT.Reset(balanceNow)
	end
end

do --Combat events-------------
	local combatTable = {};
	LBPT.combat = combatTable;
	combatFrame:SetScript("OnEvent",  function(_, event, ...) combatTable[event](...) end);
	
	local function getGCDEnd()
		local start, duration = GetSpellCooldown(768) --Using cat form
		return start + duration
	end
	
	local function checkCelestialAligmentBuff()
		vars.celestial_lockout_end = select(7,UnitBuff(PLAYER,data.spellsNames.CA)) or 0
		return vars.celestial_lockout_end;
	end
	
	local function resetSpell(...)
		vars.gcd_lockout_end = getGCDEnd()
		vars.spell_casting = 0;
		vars.spell_num = 0;
		vars.spell_lockout_end = 0;
		vars.spellIsChannel = false
		LBPT.RecalcEnergy(...)
	end
	
	do -- Casting status update
		local function startSpell(unit,num,id,channeled)
			if unit == PLAYER then 
				vars.spell_casting = id;
				vars.spell_num = num;
				
				if channeled then
					vars.spell_lockout_end = (select(6,UnitChannelInfo(unit)) or 0) * 0.001
				else
					vars.spell_lockout_end = (select(6,UnitCastingInfo(unit)) or 0) * 0.001
				end
				
				vars.gcd_lockout_end = getGCDEnd()
				vars.spellIsChannel = channeled
				
				LBPT.RecalcEnergy()
				
				--if debugging then print("PREDICTED",vars.vEnergy) end
			end
		end
		local function delaySpell(unit,num,id,channeled)
			if unit == PLAYER and vars.spell_num == num and vars.spell_casting == id then
				
				if channeled then
					vars.spell_lockout_end = (select(6,UnitChannelInfo(unit)) or 0) * 0.001
				else
					vars.spell_lockout_end = (select(6,UnitCastingInfo(unit)) or 0) * 0.001
				end
				
				vars.gcd_lockout_end = getGCDEnd()
				
				LBPT.RecalcEnergy()	
				
				--if debugging then print("DELAYED",vars.vEnergy) end
			end
		end
		local function finishSpell(unit,num,id)
			if unit == PLAYER and vars.spell_num == num and vars.spell_casting == id then
				resetSpell()
			end
		end
		local function succeedSpell(unit,num,id)
			if unit == PLAYER then
				vars.gcd_lockout_end = getGCDEnd()
				
				if vars.spell_num == num and vars.spell_casting == id and not vars.spellIsChannel then
					vars.spell_casting = 0;
					vars.spell_num = 0;
					vars.spell_lockout_end = 0;
				end
				
				if not vars.spellIsChannel then
					LBPT.RecalcEnergy()
					
					--if debugging then print("SUCCEED",vars.energy,GetTime()) end
				end
			end
		end	
			
		function combatTable.UNIT_SPELLCAST_START(unit,_,_,num,id)			startSpell(unit,num,id,false) end
		function combatTable.UNIT_SPELLCAST_CHANNEL_START(unit,_,_,num,id)	startSpell(unit,num,id,true ) end
		function combatTable.UNIT_SPELLCAST_DELAYED(unit,_,_,num,id)		delaySpell(unit,num,id,false) end
		function combatTable.UNIT_SPELLCAST_CHANNEL_UPDATE(unit,_,_,num,id)	delaySpell(unit,num,id,true ) end
		function combatTable.UNIT_SPELLCAST_SUCCEEDED(unit,_,_,num,id)		succeedSpell(unit,num,id) end
		function combatTable.UNIT_SPELLCAST_FAILED(unit,_,_,num,id)			finishSpell(unit,num,id) end
		function combatTable.UNIT_SPELLCAST_CHANNEL_STOP(unit,_,_,num,id)	finishSpell(unit,num,id) --[[if debugging then print("SUCCEED",vars.energy) end]] end
		function combatTable.UNIT_SPELLCAST_INTERRUPTED(unit,_,_,num,id)	if not UnitCastingInfo(PLAYER) then finishSpell(unit,num,id) end end

		function combatTable.PLAYER_DEAD() --Reset queue & clear energy upon death 
			vars.eclipseActive = false
			resetSpell(0,"none")
		end
	end
	
	do -- Eclipse energy updates
		local throttle_energy = nil;
		local cacheStoreFun = LBPT.cacheTable.gotEnergyAt
		local function UNIT_POWER_fired(unit,power)
			if unit == PLAYER and power == ECLIPSE and vars.celestial_lockout_end == 0 then
				local e = UnitPower(unit,SPELL_POWER_ECLIPSE)
				if e ~= throttle_energy then
					throttle_energy = e;
					
					local d = nil;
					if e == 100 then
						d = SUN_DIRECTION
						cacheStoreFun(-100,GetTime())
					elseif e == -100 then 
						d = MOON_DIRECTION
						cacheStoreFun(-100,GetTime())
					else
						d = GetEclipseDirection()
						cacheStoreFun((d == SUN_DIRECTION and e) or -e,GetTime())
					end
					
					LBPT.RecalcEnergy(e,d,true)
				end
			end
		
		end
		
		function combatTable.UNIT_POWER_FREQUENT		(unit,power) UNIT_POWER_fired(unit,power) end
		function combatTable.UNIT_POWER					(unit,power) UNIT_POWER_fired(unit,power) end

		-- Eclipse state updates
		function combatTable.ECLIPSE_DIRECTION_CHANGE	() --Procs for other druids
			if (GetEclipseDirection() == NO_DIRECTION or not UnitAffectingCombat(PLAYER)) and vars.eclipseActive then
				vars.eclipseActive = false
				LBPT.RecalcEnergy()
			end
		end
		function combatTable.PLAYER_REGEN_DISABLED() 
			vars.eclipseActive = true
			local e = UnitPower(PLAYER,SPELL_POWER_ECLIPSE)
			cacheStoreFun(e,GetTime())
			LBPT.RecalcEnergy(e,GetEclipseDirection()) 
		end
		
		-- Direction & energy when teleporting
		function combatTable.PLAYER_ENTERING_WORLD()
			vars.eclipseActive = false
			resetSpell(0,"none")
		end; 

		-- Aura state update
		local cacheCAproc = LBPT.cacheTable.cacheCAproc
		local function auraStateChanged(id,event) 
			if id == data.spellsId.CA then
				checkCelestialAligmentBuff()
				cacheCAproc(event == "SPELL_AURA_APPLIED", GetTime())
				LBPT.RecalcEnergy()
			elseif id == data.spellsId.LP then
				if event == "SPELL_AURA_APPLIED" then
					vars.peak = -100
					throttle_energy = -100
					vars.peakProc = -100
					cacheStoreFun(-100,GetTime())
					LBPT.RecalcEnergy(-100,SUN_DIRECTION,true)
				else
					vars.peak = false
				end
			elseif id == data.spellsId.SP then
				if event == "SPELL_AURA_APPLIED" then
					vars.peak = 100
					throttle_energy = 100
					vars.peakProc = 100
					cacheStoreFun(-100,GetTime())
					LBPT.RecalcEnergy(100,MOON_DIRECTION,true)
				else
					vars.peak = false
				end
			end
		end
		local unfilteredCombatLogTable = {
			SPELL_AURA_APPLIED 	= auraStateChanged,
			SPELL_AURA_REMOVED 	= auraStateChanged,
		}
		
		--COMBAT LOG HANDLER -------------------------------------------------------
		function combatTable.COMBAT_LOG_EVENT_UNFILTERED(_,event,_,gUIDor,_,_,_,destGUID,_,_,_,spellId,_,_,other_spellId)
			if gUIDor == vars.playerGUID then 
				local f = unfilteredCombatLogTable[event] 
				if f then f(spellId,event) end
			elseif destGUID == vars.playerGUID and event == "SPELL_INTERRUPT" and vars.spell_casting == other_spellId then 
				resetSpell()
			end
		end
	end
	
	
	do --LBPT reset
		function LBPT.Reset(balanceNow)
			--Reset values
			vars.energy = 0
			vars.vEnergy = 0
			vars.peak = false
			vars.vPeak = false
			vars.reachEnd = false
			vars.direction = NO_DIRECTION
			vars.vDirection = NO_DIRECTION
			
			vars.eclipseActive = false;
			vars.celestial_lockout_end = 0;
			vars.gcd_lockout_end = getGCDEnd()
			
			vars.spell_casting = 0;
			vars.spell_num = 0;
			vars.spell_lockout_end = 0;
			vars.spellIsChannel = false
						
			--Propagate values
			if balanceNow then
				vars.eclipseActive = UnitAffectingCombat(PLAYER)
				checkCelestialAligmentBuff();
				vars.direction = GetEclipseDirection() or vars.direction 
				vars.energy = UnitPower(PLAYER,SPELL_POWER_ECLIPSE)
				
				LBPT.RecalcEnergy();
			else
				vars.euforia = false 
				LBPT.FireCallbacks()
			end
		end
	end
end

do --Recalc Energy function
	local cacheGetEnergyAt = LBPT.cacheTable.getEnergyAt
	local timePredicted = nil
	local timePeak = nil
	
	local function getEnergyAt(energy,direction,timeStart,timeEnd,isCAevent,noneedtopredict)
		if noneedtopredict and timeEnd == timePredicted then
			return vars.vEnergy,vars.vDirection,vars.reachEnd
		end
	
		local accurate = false;
		local prevEnergy;
		local reachEnd = false
		timePeak = nil
	
		while timeStart < timeEnd do
			prevEnergy = energy
			energy,timeStart,accurate = cacheGetEnergyAt((direction == MOON_DIRECTION and -energy) or energy, timeStart, timeEnd, isCAevent, accurate)
			if direction == MOON_DIRECTION then 
				energy = -energy
			end
			
			if prevEnergy * energy <= 0 and not vars.eclipseActive then
				energy = 0 
				direction = "moon"
			end
			
			if abs(energy) == 100 then
				direction = (energy == 100 and MOON_DIRECTION) or SUN_DIRECTION
				
				if energy ~= prevEnergy then
					reachEnd = reachEnd or energy;
					timePeak = timeStart
				end
			else
				break;
			end
		end
		
		timePredicted = timeEnd
		
		return energy,direction,reachEnd
	end
	
	local function ExtraEnergy(energy,direction,noneedtopredict) --computes extra energy
		local tim = GetTime()
		local timeToPredict = max(vars.gcd_lockout_end,vars.spell_lockout_end)
		
		if timeToPredict <= tim then
			return energy, direction, false
		end

		if vars.celestial_lockout_end <= tim then
			return getEnergyAt(energy,direction,tim,timeToPredict,false,noneedtopredict)
		end
		
		if vars.celestial_lockout_end >= timeToPredict then
			return energy, direction, false
		end
		
		if vars.celestial_lockout_end < timeToPredict then
			return getEnergyAt(energy,direction,vars.celestial_lockout_end,timeToPredict,true,noneedtopredict)
		end
	end
	
	function LBPT.RecalcEnergy(energy,direction,noneedtopredict)
		if energy then 
			vars.energy = energy;
		else
			energy = vars.energy
		end
			
		if energy == 100 then
			direction = MOON_DIRECTION
		elseif energy == -100 then
			direction = SUN_DIRECTION
		else
			vars.peakProc = false
		end
		
		if direction then
			vars.direction = direction;
		else
			direction = vars.direction
		end

		if not direction or direction == NO_DIRECTION then 
			direction = MOON_DIRECTION 
			vars.direction = direction
		end

		vars.vEnergy,vars.vDirection,vars.reachEnd = ExtraEnergy(energy,direction,noneedtopredict);
		
		if energy == vars.reachEnd then --When you gain peak mid cast, usually you dont repredict, thus needing this
			vars.reachEnd = false
		end
		vars.vPeak = vars.reachEnd or ((abs(energy)==100 and vars.peakProc ~= energy) and energy)
		vars.nextPeakAt = (vars.reachEnd and timePeak) or nil
		
		--if debugging then
		--	todo = {ee,"energy",energy,vars.vEnergy,"direction",direction,vars.vDirection,"peak",vars.peak,vars.vPeak,"reachEnd",vars.reachEnd,"nextPeak",vars.nextPeak}
		--end
		
		LBPT.FireCallbacks()
	end
end
-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------
-- TIER MODIFIER FUCNTION (At the end, so it sees and can modify all locals, sometimes I'll need to remove do-end blocks)
do --Tier bonus check
	local broadcasted = {}
	setmetatable(broadcasted, {__index = function () return 0 end})
	vars.timer_broadcastTier:SetScript("OnHide",function() 
		for k,v in pairs(vars.tiers.tierPieceCount) do
			if broadcasted[k] ~= v then --broadcast
				if broadcasted[k] < v then --gained bonus
					for i = broadcasted[k]+1,v do
						if data.balanceTiersItemId[k]["bonus"..i.."p"] then 
							if data.balanceTiersItemId[k]["tested"..i.."p"] then
								print("|c00a080ffLibBalancePowerTracker|r: Tier"..k.." "..i.."p bonus detected.") 
							else
								print("|c00a080ffLibBalancePowerTracker|r: Tier"..k.." "..i.."p bonus detected (Untested).") 
							end
						end
					end
				else --lost bonus
					for i = v+1,broadcasted[k] do
						if data.balanceTiersItemId[k]["bonus"..i.."p"] then 
							print("|c00a080ffLibBalancePowerTracker|r: No tier"..k.." "..i.."p bonus detected.") 
						end
					end
				end
				broadcasted[k] = v
			end
		end
	end)
	
	function LBPT.PLAYER_EQUIPMENT_CHANGED(slot,hasItem)
		local setInSlot = vars.tiers[slot]
		if setInSlot then						--print("retirado objeto de "..slot)
			vars.tiers[slot]=false;
			
			local num_p_tier = vars.tiers.tierPieceCount[setInSlot]-1
			vars.tiers.tierPieceCount[setInSlot]= num_p_tier  --print("Tienes "..vars.tiers.tierPieceCount[setInSlot].." piezas de tier "..setInSlot)
			
			if data.balanceTiersItemId[setInSlot]["bonus"..(num_p_tier+1).."p"] and LBPT.BonusTier[setInSlot][num_p_tier+1].Off() then 
				vars.timer_broadcastTier:SetCooldown(GetTime(),.05) 
			end	
		end
		
		if hasItem and setInSlot ~= nil then 				--print("se intenta poner una pieza en "..slot)
			local id = GetInventoryItemID("player", slot)	--print("el id de la pieza es "..tostring(id))
			for k,v in pairs(data.balanceTiersItemId) do	--print("buscando en tier "..k)
				if v[slot] and v[slot][id] then				--print("encontrado en tier "..k)
					vars.tiers[slot]=k;
					
					local num_p_tier = vars.tiers.tierPieceCount[k]+1
					vars.tiers.tierPieceCount[k]= num_p_tier --print("Tienes "..vars.tiers.tierPieceCount[k].." piezas de tier "..k);
					
					if v["bonus"..num_p_tier.."p"] and LBPT.BonusTier[k][num_p_tier].On() then 
						vars.timer_broadcastTier:SetCooldown(GetTime(),.05)
					end
					
					return
				end
			end
		end
	end
	
	LBPT.BonusTier={
		[12]={
			[4]={
				On  = 	function()
							return true;
						end,
				Off = 	function() 
							return true;
						end,
			},
		},
	}
end
-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------
do ----DEBUG---------------------
	local dbug = false;
	local dbug_init = false;
	
	function LibBalancePowerTracker:ToogleDebug()
		dbug = not dbug;
		print("|c00a080ffLibBalancePowerTracker|r: Debug:",dbug)

		LBPT_DEBUG_EVENT_LIST = {}
		LBPT_DEBUG_EVENT_LIST.insertAt = 1;
		
		if not LibBalancePowerTracker_Options or type(LibBalancePowerTracker_Options) ~= "table" then 
			LibBalancePowerTracker_Options = {}
		end	
		LibBalancePowerTracker_Options.debug_event_list = LBPT_DEBUG_EVENT_LIST
		
		if not BalancePowerTracker_Options or type(BalancePowerTracker_Options) ~= "table" then 
			BalancePowerTracker_Options = {}
		end
		BalancePowerTracker_Options.debug_event_list = LBPT_DEBUG_EVENT_LIST
				
		if not dbug_init then
			local function insert(event,drawn,...)
				if not dbug then return end
				
				LBPT_DEBUG_EVENT_LIST[LBPT_DEBUG_EVENT_LIST.insertAt] = {event,drawn,GetTime(),UnitPower(PLAYER,SPELL_POWER_ECLIPSE),vars.energy,vars.vEnergy,GetEclipseDirection(),vars.direction,vars.vDirection,vars.peak,...}
				LBPT_DEBUG_EVENT_LIST.insertAt = LBPT_DEBUG_EVENT_LIST.insertAt+1
			end
			
			function LibBalancePowerTracker.PrintDebugEvents(i)
				if (not i) or type(i) ~= "number" or i<=0 then i = 50 end
			
				for i = max(LBPT_DEBUG_EVENT_LIST.insertAt-i,1),LBPT_DEBUG_EVENT_LIST.insertAt do
					print(unpack(LBPT_DEBUG_EVENT_LIST[i] or {}))
				end
			end
			
			local drawn = false;
			local old_fireCallbacks = LBPT.FireCallbacks
			function LBPT.FireCallbacks()
				drawn = true;
				old_fireCallbacks()
			end;
			
			combatFrame:SetScript("OnEvent",  	function(_, event, ...) drawn = false;  LBPT.combat[event](...)	insert(event,drawn,...) end);
			frame:SetScript("OnEvent",  		function(_, event, ...) drawn = false;  LBPT[event](...) 		insert(event,drawn,...) end);
			
			function LibBalancePowerTracker:mySearch(s,t,n,l)
				if not n then n = 0; end
				if not l then l = "" end
				if not t then t = _G end

				for k,v in pairs(t) do
					k = tostring(k)
					if type(v) == "string" and string.find(v,s) then 
						print(l,k,v)
					elseif type(v)=="table" and k ~= "_G" then
						if n>10 then return end
						self:mySearch(s,v,n+1,l.." "..k)
					elseif string.find(k,s) then
						print(l,k,v)
					end
				end
			end
		end
		dbug_init = true;
	end
end
-----------------------------------------------------------------------------------------