local L = LibStub("AceLocale-3.0"):NewLocale("BigWigs", "enUS", true, "raw")

-- Core.lua
L.berserk = "Berserk"
L.berserk_desc = "Show a bar and timed warnings for when the boss will go berserk."
L.altpower = "Alternate power display"
L.altpower_desc = "Show the alternate power window, which displays the amount of alternate power that your group members have."
L.stages = "Stages"
L.stages_desc = "Enable functions related to the various stages/phases of the boss like proximity, bars, etc."
L.warmup = "Warmup"
L.warmup_desc = "Time until combat with the boss starts."

L.already_registered = "|cffff0000WARNING:|r |cff00ff00%s|r (|cffffff00%s|r) already exists as a module in BigWigs, but something is trying to register it again. This usually means you have two copies of this module in your addons folder due to some addon updater failure. It is recommended that you delete any BigWigs folders you have and then reinstall it from scratch."

-- Loader / Options.lua
L.officialRelease = "You are running an official release of BigWigs %s (%s)"
L.alphaRelease = "You are running an ALPHA RELEASE of BigWigs %s (%s)"
L.sourceCheckout = "You are running a source checkout of BigWigs %s directly from the repository."
L.getNewRelease = "Your BigWigs is old (/bwv) but you can easily update it using the Curse Client. Alternatively, you can update manually from curse.com or wowinterface.com."
L.warnTwoReleases = "Your BigWigs is 2 releases out of date! Your version may have bugs, missing features, or completely incorrect timers. It is strongly recommended you update."
L.warnSeveralReleases = "|cffff0000Your BigWigs is several releases out of date!! We HIGHLY recommend you update to prevent syncing issues with other players!|r"

L.tooltipHint = "|cffeda55fClick|r to reset all running modules.\n|cffeda55fAlt-Click|r to disable them.\n|cffeda55fRight-Click|r to access options."
L.activeBossModules = "Active boss modules:"
L.modulesReset = "All running modules have been reset."
L.modulesDisabled = "All running modules have been disabled."

L.oldVersionsInGroup = "There are people in your group with older versions or without BigWigs. You can get more details with /bwv."
L.upToDate = "Up to date:"
L.outOfDate = "Out of date:"
L.dbmUsers = "DBM users:"
L.noBossMod = "No boss mod:"
L.offline = "Offline"

L.blizzRestrictionsZone = "Waiting until combat ends to finish loading due to Blizzard combat restrictions."
L.finishedLoading = "Combat has ended, BigWigs has now finished loading."
L.blizzRestrictionsConfig = "Due to Blizzard restrictions the config must first be opened out of combat, before it can be accessed in combat."

L.missingAddOn = "Please note that this zone requires the |cFF436EEE%s|r plugin for timers to be displayed."

L.coreAddonDisabled = "BigWigs won't function properly since the addon %s is disabled. You can enable it from the addon control panel at the character selection screen."

L.removeAddon = "Please remove '|cFF436EEE%s|r' as it's been replaced by '|cFF436EEE%s|r'."

-- Options.lua
L.introduction = "Welcome to BigWigs, where the boss encounters roam. Please fasten your seatbelt, eat peanuts and enjoy the ride. It will not eat your children, but it will assist you in preparing that new boss encounter as a 7-course dinner for your raid group."
L.toggleAnchorsBtn = "Toggle Anchors"
L.toggleAnchorsBtn_desc = "Toggle showing or hiding of all the anchors."
L.testBarsBtn = "Create Test Bar"
L.testBarsBtn_desc = "Creates a bar for you to test your current display settings with."
L.sound = "Sound"
L.flashScreen = "Flash Screen"
L.flashScreenDesc = "Certain abilities are important enough to need your full attention. When these abilities affect you BigWigs can flash the screen."
L.raidIcons = "Raid icons"
L.raidIconsDesc = "Some encounter scripts use raid icons to mark players that are of special interest to your group. For example 'bomb'-type effects and mind control. If you turn this off, you won't mark anyone.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r"
L.minimapIcon = "Minimap icon"
L.minimapToggle = "Toggle show/hide of the minimap icon."
L.configure = "Configure"
L.test = "Test"
L.resetPositions = "Reset positions"
L.colors = "Colors"
L.selectEncounter = "Select encounter"
L.listAbilities = "List abilities in group chat"

L.dbmFaker = "Pretend I'm using DBM"
L.dbmFakerDesc = "If a DBM user does a version check to see who's using DBM, they will see you on the list. Useful for guilds that force using DBM."
L.chatMessages = "Chat frame messages"
L.chatMessagesDesc = "Outputs all BigWigs messages to the default chat frame in addition to the display setting."
L.zoneMessages = "Show zone messages"
L.zoneMessagesDesc = "Disabling this will stop showing messages when you enter a zone that BigWigs has timers for, but you don't have installed. We recommend you leave this turned on as it's the only notification you will get if we suddenly create timers for a new zone that you find useful."

L.slashDescTitle = "|cFFFED000Slash Commands:|r"
L.slashDescPull = "|cFFFED000/pull:|r Sends a pull countdown to your raid."
L.slashDescBreak = "|cFFFED000/break:|r Sends a break timer to your raid."
L.slashDescRaidBar = "|cFFFED000/raidbar:|r Sends a custom bar to your raid."
L.slashDescLocalBar = "|cFFFED000/localbar:|r Creates a custom bar only you can see."
L.slashDescRange = "|cFFFED000/range:|r Opens the range indicator."
L.slashDescVersion = "|cFFFED000/bwv:|r Performs a BigWigs version check."
L.slashDescConfig = "|cFFFED000/bw:|r Opens the BigWigs configuration."

L.gitHubTitle = "BigWigs is on GitHub"
L.gitHubDesc = "BigWigs is open source software hosted on GitHub. We are always looking for new people to help us out and everyone is welcome to inspect our code, make contributions and submit bug reports. BigWigs is as great as it is today largely in part to the great WoW community helping us out.\n\nIf you've committed changes to BigWigs whilst it was on SVN and would like your GitHub account linked on the Git commit log, contact us.\n\n|cFF33FF99Our API is now documented and freely readable on the GitHub wiki.|r"

L.BAR = "Bars"
L.MESSAGE = "Messages"
L.ICON = "Icon"
L.SAY = "Say"
L.FLASH = "Flash"
L.EMPHASIZE = "Emphasize"
L.ME_ONLY = "Only when on me"
L.ME_ONLY_desc = "When you enable this option messages for this ability will only be shown when they affect you. For example, 'Bomb: Player' will only be shown if it's on you."
L.PULSE = "Pulse"
L.PULSE_desc = "In addition to flashing the screen, you can also have an icon related to this specific ability momentarily shown in the middle of your screen to try grab your attention."
L.MESSAGE_desc = "Most encounter abilities come with one or more messages that BigWigs will show on your screen. If you disable this option, none of the messages attached to this option, if any, will be displayed."
L.BAR_desc = "Bars are shown for some encounter abilities when appropriate. If this ability is accompanied by a bar that you want to hide, disable this option."
L.FLASH_desc = "Some abilities might be more important than others. If you want your screen to flash when this ability is imminent or used, check this option."
L.ICON_desc = "BigWigs can mark characters affected by abilities with an icon. This makes them easier to spot."
L.SAY_desc = "Chat bubbles are easy to spot. BigWigs will use a say message to announce people nearby about an effect on you."
L.EMPHASIZE_desc = "Enabling this will emphasize any messages associated with this ability, making them larger and more visible. You can set the size and font of emphasized messages in the main options under \"Messages\"."
L.PROXIMITY = "Proximity display"
L.PROXIMITY_desc = "Abilities will sometimes require you to spread out. The proximity display will be set up specifically for this ability so that you will be able to tell at-a-glance whether or not you are safe."
L.ALTPOWER = "Alternate power display"
L.ALTPOWER_desc = "Some encounters will use the alternate power mechanic on players in your group. The alternate power display provides a quick overview of who has the least/most alternate power, which can be useful for specific tactics or assignments."
L.TANK = "Tank Only"
L.TANK_desc = "Some abilities are only important for tanks. If you want to see warnings for this ability regardless of your role, disable this option."
L.HEALER = "Healer Only"
L.HEALER_desc = "Some abilities are only important for healers. If you want to see warnings for this ability regardless of your role, disable this option."
L.TANK_HEALER = "Tank & Healer Only"
L.TANK_HEALER_desc = "Some abilities are only important for tanks and healers. If you want to see warnings for this ability regardless of your role, disable this option."
L.DISPEL = "Dispeller Only"
L.DISPEL_desc = "If you want to see warnings for this ability even when you cannot dispel it, disable this option."
L.VOICE = "Voice"
L.VOICE_desc = "If you have a voice plugin installed, this option will enable it to play a sound file that speaks this warning out loud for you."
L.COUNTDOWN = "Countdown"
L.COUNTDOWN_desc = "If enabled, a vocal and visual countdown will be added for the last 5 seconds. Imagine someone counting down \"5... 4... 3... 2... 1...\" with a big number in the middle of your screen."

L.advanced = "Advanced options"
L.back = "<< Back"

L.tank = "|cFFFF0000Tank alerts only.|r "
L.healer = "|cFFFF0000Healer alerts only.|r "
L.tankhealer = "|cFFFF0000Tank & Healer alerts only.|r "
L.dispeller = "|cFFFF0000Dispeller alerts only.|r "

L.about = "About"
L.developers = "Developers"
L.license = "License"
L.website = "Website"
L.contact = "Contact"
L.allRightsReserved = "All Rights Reserved"
L.ircChannel = "irc.freenode.net in the #bigwigs channel"
L.thanks = "Thanks to the following for all their help in various fields of development"

-- Statistics
L.statistics = "Statistics"
L.norm25 = "25"
L.heroic25 = "25h"
L.norm10 = "10"
L.heroic10 = "10h"
L.lfr = "LFR"
L.flex = "Flex"
L.normal = "Normal"
L.heroic = "Heroic"
L.mythic = "Mythic"
L.wipes = "Wipes:"
L.kills = "Kills:"
L.best = "Best:"

