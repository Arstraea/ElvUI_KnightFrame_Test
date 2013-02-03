--local E, L, V, P, G, _ = unpack(ElvUI)
local E, _, V, P, _, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

P["hideTutorial"] = 1
if KF.UIParent then
	--Private
	V['general']['lootRoll'] = true
	V['general']['bubbles'] = false
	V['general']['pixelPerfect'] = true
	V['bags']['enable'] = false
	V['bags']['bagBar'] = true
	
	--Core
	P['general']['loginmessage'] = false
	P['general']["autoRepair"] = "GUILD"
	P['general']['vendorGrays'] = true
	P['general']['threat']['enable'] = false
	P['general']['totems']['growthDirection'] = 'HORIZONTAL'
	P['general']['minimap']['locationText'] = 'SHOW'

	--Bags
	P['bags']['bagBar']['growthDirection'] = 'HORIZONTAL'
	P['bags']['bagBar']['size'] = 24
	P['bags']['bagBar']['spacing'] = 1
	P['bags']['bagBar']['mouseover'] = true

	--Auras
	P['auras']['fontSize'] = 12
	P['auras']['fontOutline'] = 'OUTLINE'
	P['auras']['consolidatedBuffs']['enable'] = false
	
	--Chat
	P['chat']['panelWidth'] = 421
	P['chat']['chatHistory'] = false
	P['chat']['keywords'] = "%MYNAME%, ElvUI, KnightFrame"
	P['chat']['emotionIcons'] = false
	P['chat']['scrollDownInterval'] = 0

	--Tooltip
	P['tooltip']['anchor'] = 'CURSOR'
	P['tooltip']['talentSpec'] = false
end