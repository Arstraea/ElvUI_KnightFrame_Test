--local E, L, V, P, G, _ = unpack(ElvUI)
local E, _, V, P, _, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

if KF.UIParent and E.db.KnightFrame.Installed_UI_Layout == 'ArstraeaMod' then
	--<< KnightFrame : Moonlight Default Setting >>--
	KF.LayoutDB = {
		['Panel_Options'] = {
			['MiddleChatPanel'] = {
				['Enable'] = true,
				['Width'] = 442,
				['Height'] = 180,
				['Location'] = 'BOTTOMLEFTLeftChatPanelBOTTOMRIGHT50',
			},
			['MeterAddonPanel'] = {
				['Enable'] = true,
				['Width'] = 442,
				['Height'] = 180,
				['Location'] = 'BOTTOMRIGHTRightChatPanelBOTTOMLEFT-50',
			},
			['ActionBarPanel'] = {
				['Enable'] = false,
			},
		},
	}
	
	
	--UnitFrame
	local U = P['unitframe']
	U['fontOutline'] = 'OUTLINE'
	U['OORAlpha'] = 0.25
	U["smartRaidFilter"] = false

	U = U['colors']
	U['colorhealthbyvalue'] = false
	U['customhealthbackdrop'] = true
	U['health'] = {b = 0.81, g = 0.88, r = 0.83}
	U['health_backdrop'] = {b = 0.07, g = 0.07, r = 0.07}
	U['tapped'] = { r = 0, g = 0, b = 0}
	U['disconnected'] = { r = 0.49, g = 0.51, b = 0.07}
	U['auraBarBuff'] = {b = 0.81, g = 0.88, r = 0.83}
	U['auraBarByType'] = false

	U = P['unitframe']['units']['player']
	U['width'] = 260
	U['health']['position'] = 'BOTTOMRIGHT'
	U['power']['offset'] = 8
	U['power']['position'] = 'BOTTOMLEFT'
	U['name']['text_format'] = '[difficultycolor][level] [namecolor][name]'
	U['portrait']['enable'] = true
	U['portrait']['overlay'] = true
	U['debuffs']['perrow'] = 14
	U['castbar']['width'] = 260
	U['castbar']['height'] = 20
	U['castbar']['color'] = {b = 0.82, g = 0.82, r = 0.82}
	U['castbar']['format'] = 'CURRENTMAX'

	U = P['unitframe']['units']['target']
	U['width'] = 260
	U['smartAuraDisplay'] = 'DISABLED'
	U['health']['position'] = 'BOTTOMRIGHT'
	U['power']['offset'] = 8
	U['power']['position'] = 'BOTTOMLEFT'
	U['power']['hideonnpc'] = false
	U['name']['text_format'] = '[namecolor][name:medium] [difficultycolor][level] [shortclassification]'
	U['portrait']['enable'] = true
	U['portrait']['overlay'] = true
	U['buffs']['perrow'] = 14
	U['buffs']['playerOnly']['friendly'] = false
	U['debuffs']['enable'] = true
	U['debuffs']['perrow'] = 14
	U['debuffs']['playerOnly']['enemy'] = false
	U['castbar']['width'] = 260
	U['castbar']['height'] = 20
	U['castbar']['color'] = {b = 0.82, g = 0.82, r = 0.82}
	U['castbar']['format'] = 'CURRENTMAX'
	U['aurabar']['attachTo'] = 'DEBUFFS'

	U = P['unitframe']['units']['targettarget']
	U['width'] = 140
	U['height'] = 31
	U['health']['text_format'] = '[healthcolor][health:percent]'
	U['power']['height'] = 4
	U['debuffs']['perrow'] = 6
	U['debuffs']['anchorPoint'] = 'BOTTOMLEFT'
	
	U = P['unitframe']['units']['focus']
	U['width'] = 140
	U['height'] = 31
	U['health']['text_format'] = '[healthcolor][health:percent]'
	U['power']['height'] = 4
	U['debuffs']['playerOnly']['enemy'] = false
	U['castbar']['width'] = 400
	U['castbar']['height'] = 24
	U['castbar']['color'] = {b = 0.82, g = 0.82, r = 0.82}
	U['castbar']['format'] = 'CURRENTMAX'

	U = P['unitframe']['units']['focustarget']
	U['enable'] = true
	U['width'] = 140
	U['height'] = 31
	U['health']['text_format'] = '[healthcolor][health:percent]'
	U['power']['height'] = 4
	U['power']['enable'] = true

	U = P['unitframe']['units']['pet']
	U['height'] = 31
	U['power']['height'] = 4
	U['buffs']['enable'] = true
	U['buffs']['yOffset'] = -1
	U['buffs']['sizeOverride'] = 0
	U['debuffs']['enable'] = true
	U['debuffs']['yOffset'] = 1
	U['debuffs']['anchorPoint'] = 'TOPLEFT'

	U = P['unitframe']['units']['boss']
	U['width'] = 260
	U['height'] = 53
	U['health']['text_format'] = '[healthcolor][health:current-percent]'
	U['health']['position'] = 'BOTTOMRIGHT'
	U['power']['text_format'] = '[powercolor][power:percent]'
	U['power']['offset'] = 8
	U['power']['position'] = 'BOTTOMLEFT'
	U['portrait']['enable'] = true
	U['portrait']['overlay'] = true
	U['name']['position'] = 'CENTER'
	U['buffs']['fontSize'] = 16
	U['buffs']['playerOnly'] = false
	U['buffs']['sizeOverride'] = 30
	U['buffs']['xOffset'] = -4
	U['buffs']['yOffset'] = 1
	U['debuffs']['numrows'] = 1
	U['debuffs']['perrow'] = 14
	U['debuffs']['anchorPoint'] = 'TOPRIGHT'
	U['debuffs']['playerOnly'] = false
	U['debuffs']['yOffset'] = -12
	U['debuffs']['sizeOverride'] = 0
	U['castbar']['width'] = 260
	U['castbar']['color'] = {b = 0.82, g = 0.82, r = 0.82}
	U['castbar']['format'] = 'CURRENTMAX'		

	U = P['unitframe']['units']['arena']
	U['width'] = 260
	U['height'] = 53
	U['health']['position'] = 'BOTTOMRIGHT'
	U['power']['offset'] = 8
	U['power']['position'] = 'BOTTOMLEFT'			
	U['name']['position'] = 'CENTER'
	U['buffs']['fontSize'] = 16
	U['buffs']['sizeOverride'] = 30
	U['buffs']['yOffset'] = 0
	U['debuffs']['perrow'] = 11
	U['debuffs']['anchorPoint'] = 'TOPLEFT'
	U['debuffs']['xOffset'] = 8
	U['debuffs']['sizeOverride'] = 0
	U['castbar']['width'] = 260
	U['castbar']['color'] = {b = 0.82, g = 0.82, r = 0.82}
	U['castbar']['format'] = 'CURRENTMAX'
	U['pvpTrinket']['size'] = 38
	U['pvpTrinket']['yOffset'] = -4

	U = P['unitframe']['units']['party']
	U['point'] = 'BOTTOM'
	U['yOffset'] = 15
	U["healPrediction"] = true
	U['columnAnchorPoint'] = 'BOTTOM'
	U['width'] = 230
	U['height'] = 53
	U['health']['position'] = 'BOTTOMRIGHT'
	U['power']['offset'] = 8
	U['power']['position'] = 'BOTTOMLEFT'
	U['name']['position'] = 'CENTER'
	U['buffs']['anchorPoint'] = 'RIGHT'
	U['buffs']['yOffset'] = -15
	U['buffs']['sizeOverride'] = 23
	U['debuffs']['perrow'] = 8
	U['debuffs']['attachTo'] = 'BUFFS'
	U['debuffs']['anchorPoint'] = 'BOTTOMLEFT'
	U['debuffs']['yOffset'] = 24
	U['debuffs']['sizeOverride'] = 23
	U['roleIcon']['position'] = 'TOPRIGHT'
	U['targetsGroup']['enable'] = true
	U['targetsGroup']['height'] = 26
	U['targetsGroup']['anchorPoint'] = 'TOPRIGHT'
	U['targetsGroup']['xOffset'] = 105
	U['targetsGroup']['yOffset'] = -26

	U = P['unitframe']['units']['raid10']
	U['columnSpacing'] = 5
	U['xOffset'] = 5
	U['healPrediction'] = true
	U['height'] = 56
	U['health']['text_format'] = '[healthcolor][health:current]'
	U['power']['offset'] = 6
	U['buffIndicator']['size'] = 10
	U['buffIndicator']['fontSize'] = 15
	U['rdebuffs']['fontSize'] = 12
	U['rdebuffs']['size'] = 35
	U['roleIcon']['position'] = 'CENTER'

	U = P['unitframe']['units']['raid25']
	U['columnSpacing'] = 5
	U['xOffset'] = 5
	U['healPrediction'] = true
	U['height'] = 56
	U['health']['text_format'] = '[healthcolor][health:current]'
	U['power']['offset'] = 6
	U['buffIndicator']['size'] = 10
	U['buffIndicator']['fontSize'] = 15
	U['rdebuffs']['fontSize'] = 12
	U['rdebuffs']['size'] = 35
	U['roleIcon']['position'] = 'CENTER'

	U = P['unitframe']['units']['raid40']
	U['columnSpacing'] = 4
	U['xOffset'] = 5
	U['yOffset'] = 0
	U['healPrediction'] = true
	U['height'] = 34
	U['health']['text_format'] = '[healthcolor][health:percent]'
	U['power']['enable'] = true
	U['power']['offset'] = 4
	U['name']['position'] = 'TOP'
	U['rdebuffs']['enable'] = true
	U['rdebuffs']['size'] = 24
	U['roleIcon']['enable'] = true
	U['roleIcon']['position'] = 'TOPRIGHT'
	U['buffIndicator']['size'] = 10
	U['buffIndicator']['fontSize'] = 15

	U = P['unitframe']['units']
	U['tank']['enable'] = false
	U['tank']['targetsGroup']['enable'] = false
	U['assist']['enable'] = false
	U['assist']['targetsGroup']['enable'] = false

	--Actionbar
	P['actionbar']['fontOutline'] = 'OUTLINE'
	P['actionbar']["macrotext"] = true

	P['actionbar']['bar1']['point'] = 'TOPLEFT'
	P['actionbar']['bar1']['buttonsize'] = 27

	P['actionbar']['bar2']['enabled'] = true
	P['actionbar']['bar2']['point'] = 'TOPLEFT'
	P['actionbar']['bar2']['buttonsize'] = 27
	P['actionbar']['bar2']['backdrop'] = true

	P['actionbar']['bar3']['buttons'] = 12
	P['actionbar']['bar3']['buttonsPerRow'] = 12
	P['actionbar']['bar3']['buttonsize'] = 27
	P['actionbar']['bar3']['backdrop'] = false

	P['actionbar']['bar4']['point'] = 'TOPLEFT'
	P['actionbar']['bar4']['buttonsize'] = 27

	P['actionbar']['bar5']['point'] = 'TOPLEFT'
	P['actionbar']['bar5']['buttons'] = 12
	P['actionbar']['bar5']['buttonsize'] = 27

	P['actionbar']['barPet']['buttonsPerRow'] = 10
	P['actionbar']['barPet']['point'] = 'TOPLEFT'
	P['actionbar']['barPet']['buttonsize'] = 16
	P['actionbar']['barPet']['buttonspacing'] = 3

	P['actionbar']['stanceBar']['buttonsize'] = 16
	P['actionbar']['stanceBar']['buttonspacing'] = 3
	P['actionbar']['stanceBar']['backdrop'] = true

	if E.db.KnightFrame.Installed_UI_Layout == 'ArstraeaMod' then
		P['actionbar']['bar1']['heightMult'] = 2
		P['actionbar']['bar2']['buttonsPerRow'] = 6
	elseif E.db.KnightFrame.Installed_UI_Layout == 'KimsungjaeMod' then
		P['actionbar']['bar1']['backdrop'] = false	
		P['actionbar']['bar2']['buttonsPerRow'] = 3
		P['actionbar']['bar4']['backdrop'] = false
		P['actionbar']['bar4']['buttonsPerRow'] = 12
		P['actionbar']['bar5']['buttonsPerRow'] = 3
	end
end

--knight Action Bar Default Position
KF.ABP = {
	['ArstraeaMod'] = {
		['ElvAB_1'] = 'BOTTOMUIParentBOTTOM0188',
		['ElvAB_2'] = 'BOTTOMUIParentBOTTOM-288188',
		['ElvAB_3'] = 'BOTTOMUIParentBOTTOM0188',
		['ElvAB_4'] = 'RIGHTUIParentRIGHT-40',
		['ElvAB_5'] = 'BOTTOMUIParentBOTTOM288188',
		
		['ShiftAB'] = 'BOTTOMLEFTUIParentBOTTOM-383256',
		['PetAB'] = 'BOTTOMElvUIParentBOTTOM0256',
	},
	['KimsungjaeMod'] = {
		['ElvAB_1'] = 'BOTTOMUIParentBOTTOM092',
		['ElvAB_2'] = 'BOTTOMUIParentBOTTOM-23730',
		['ElvAB_3'] = 'BOTTOMUIParentBOTTOM061',
		['ElvAB_4'] = 'BOTTOMUIParentBOTTOM030',
		['ElvAB_5'] = 'BOTTOMUIParentBOTTOM23730',
		
		['ShiftAB'] = 'BOTTOMLEFTUIParentBOTTOM-383256',
		['PetAB'] = 'BOTTOMElvUIParentBOTTOM0256',
	},
	['ArstraeaMod_NoPanel'] = {
		['ElvAB_1'] = 'BOTTOMUIParentBOTTOM04',
		['ElvAB_2'] = 'BOTTOMUIParentBOTTOM-2894',
		['ElvAB_3'] = 'BOTTOMUIParentBOTTOM04',
		['ElvAB_4'] = 'RIGHTUIParentRIGHT-40',
		['ElvAB_5'] = 'BOTTOMUIParentBOTTOM2894',
		
		['ShiftAB'] = 'BOTTOMLEFTUIParentBOTTOM-383256',
		['PetAB'] = 'BOTTOMElvUIParentBOTTOM0256',
	},
}

function KF:ActionBarSetting(force)
	local SelectUI, p1, p2, p3, p4, p5
	if force == 'KimsungjaeMod' or KF:IfMod('KimsungjaeMod', 'Panel') then
		if force then
			E.db['actionbar']['bar1']['buttons'] = 12
			E.db['actionbar']['bar1']['buttonsPerRow'] = 12
			E.db['actionbar']['bar1']['backdrop'] = false
			E.db['actionbar']['bar1']['heightMult'] = 1
			E.db['actionbar']['bar1']['widthMult'] = 1
			E.db['actionbar']['bar1']['buttonsize'] = 27
			E.db['actionbar']['bar1']['buttonspacing'] = 4
			
			E.db['actionbar']['bar2']['buttons'] = 12
			E.db['actionbar']['bar2']['buttonsPerRow'] = 3
			E.db['actionbar']['bar2']['backdrop'] = true
			E.db['actionbar']['bar2']['heightMult'] = 1
			E.db['actionbar']['bar2']['widthMult'] = 1
			E.db['actionbar']['bar2']['buttonsize'] = 27
			E.db['actionbar']['bar2']['buttonspacing'] = 4
			
			E.db['actionbar']['bar3']['buttons'] = 12
			E.db['actionbar']['bar3']['buttonsPerRow'] = 12
			E.db['actionbar']['bar3']['backdrop'] = false
			E.db['actionbar']['bar3']['heightMult'] = 1
			E.db['actionbar']['bar3']['widthMult'] = 1
			E.db['actionbar']['bar3']['buttonsize'] = 27
			E.db['actionbar']['bar3']['buttonspacing'] = 4
			
			E.db['actionbar']['bar4']['buttons'] = 12
			E.db['actionbar']['bar4']['buttonsPerRow'] = 12
			E.db['actionbar']['bar4']['backdrop'] = false
			E.db['actionbar']['bar4']['heightMult'] = 1
			E.db['actionbar']['bar4']['widthMult'] = 1
			E.db['actionbar']['bar4']['buttonsize'] = 27
			E.db['actionbar']['bar4']['buttonspacing'] = 4
			
			E.db['actionbar']['bar5']['buttons'] = 12
			E.db['actionbar']['bar5']['buttonsPerRow'] = 3
			E.db['actionbar']['bar5']['backdrop'] = true
			E.db['actionbar']['bar5']['heightMult'] = 1
			E.db['actionbar']['bar5']['widthMult'] = 1
			E.db['actionbar']['bar5']['buttonsize'] = 27
			E.db['actionbar']['bar5']['buttonspacing'] = 4
			
			E:GetModule('ActionBars'):UpdateButtonSettings()
		end
		SelectUI = 'KimsungjaeMod'
	elseif force == 'ArstraeaMod' or KF:IfMod('ArstraeaMod', 'Panel') then
		if force then
			E.db['actionbar']['bar1']['buttons'] = 12
			E.db['actionbar']['bar1']['buttonsPerRow'] = 12
			E.db['actionbar']['bar1']['backdrop'] = true
			E.db['actionbar']['bar1']['heightMult'] = 2
			E.db['actionbar']['bar1']['widthMult'] = 1
			E.db['actionbar']['bar1']['buttonsize'] = 27
			E.db['actionbar']['bar1']['buttonspacing'] = 4
			
			E.db['actionbar']['bar2']['buttons'] = 12
			E.db['actionbar']['bar2']['buttonsPerRow'] = 6
			E.db['actionbar']['bar2']['backdrop'] = true
			E.db['actionbar']['bar2']['heightMult'] = 1
			E.db['actionbar']['bar2']['widthMult'] = 1
			E.db['actionbar']['bar2']['buttonsize'] = 27
			E.db['actionbar']['bar2']['buttonspacing'] = 4
			
			E.db['actionbar']['bar3']['buttons'] = 12
			E.db['actionbar']['bar3']['buttonsPerRow'] = 12
			E.db['actionbar']['bar3']['backdrop'] = false
			E.db['actionbar']['bar3']['heightMult'] = 1
			E.db['actionbar']['bar3']['widthMult'] = 1
			E.db['actionbar']['bar3']['buttonsize'] = 27
			E.db['actionbar']['bar3']['buttonspacing'] = 4
			
			E.db['actionbar']['bar4']['buttons'] = 12
			E.db['actionbar']['bar4']['buttonsPerRow'] = 1
			E.db['actionbar']['bar4']['backdrop'] = true
			E.db['actionbar']['bar4']['heightMult'] = 1
			E.db['actionbar']['bar4']['widthMult'] = 1
			E.db['actionbar']['bar4']['buttonsize'] = 27
			E.db['actionbar']['bar4']['buttonspacing'] = 4
			
			E.db['actionbar']['bar5']['buttons'] = 12
			E.db['actionbar']['bar5']['buttonsPerRow'] = 6
			E.db['actionbar']['bar5']['backdrop'] = true
			E.db['actionbar']['bar5']['heightMult'] = 1
			E.db['actionbar']['bar5']['widthMult'] = 1
			E.db['actionbar']['bar5']['buttonsize'] = 27
			E.db['actionbar']['bar5']['buttonspacing'] = 4
			
			E:GetModule('ActionBars'):UpdateButtonSettings()
		end
		if E.db.KnightFrame.Panel_Option.Newpanel == false then SelectUI = 'ArstraeaMod_NoPanel' else SelectUI = 'ArstraeaMod' end
	end
	for i = 1, 7 do
		local f
		if i < 6 then f = 'ElvAB_'..i elseif i == 6 then f = 'ShiftAB' elseif i == 7 then f = 'PetAB' end
		if force then E.db.movers[f] = nil end
		if E:HasMoverBeenMoved(f) == false and KF.ABP[SelectUI][f] then
			p1, p2, p3, p4, p5 = string.split('\031', KF.ABP[SelectUI][f])
			_G[f]:ClearAllPoints()
			_G[f]:Point(p1, p2, p3, p4, p5)
			E:SaveMoverPosition(f)
		end
	end
end