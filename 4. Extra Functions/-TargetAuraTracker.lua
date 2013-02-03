local E, L, V, P, G, _  = unpack(ElvUI);
local KF = E:GetModule('KnightFrame');
local c1,c2,c3 = unpack(E.media.rgbvaluecolor)
local b1,b2,b3 = unpack(E.media.bordercolor)
local KFTAT = E:NewModule('KFTargetAuraTracker', 'AceEvent-3.0')

if not (E.db.KnightFrame.Install_Complete == nil or E.db.KnightFrame.Install_Complete == 'NotInstalled') then
	--Target Aura Tracker
	L['KFTAT1'] = '크리 5% 증가'
	L['KFTAT2'] = '능력치 증가'
	L['KFTAT3'] = '특화도 증가'
	L['KFTAT4'] = '체력 증가'
	L['KFTAT5'] = '영약 도핑'
	L['KFTAT6'] = '음식 도핑'
	L['KFTAT7'] = '딜쿨기 버프'
	L['KFTAT8'] = '생존기 버프'
	L['KFTAT1HARMFUL'] = '마법 피해 증가'
	L['KFTAT2HARMFUL'] = '방어도 감소'
	L['KFTAT3HARMFUL'] = '물리 피해 증가'
	L['KFTAT4HARMFUL'] = '물리 공격력 감소'
	L['KFTAT5HARMFUL'] = '주문 시전속도 감소'
	L['KFTAT6HARMFUL'] = '치유량 감소'
	L['KFTAT7HARMFUL'] = '블러드 디버프'
	L['KFTAT8HARMFUL'] = '부활 디버프'
	
	L['Dragonhawks'] = '용매'
	L['Wind Serpents'] = '천둥매'
	L['Tallstriders'] = '타조'
	L['Raptors'] = '랩터'
	L['Boars'] = '멧돼지'
	L['Ravagers'] = '칼날발톱'
	L['Worms'] = '벌레|cff1784d1(특수)|r'
	L['Rhinos'] = '코뿔소|cff1784d1(특수)|r'
	L['Bears'] = '곰'
	L['Foxes'] = '여우'
	L['Sporebats'] = '포자날개'
	L['Goats'] = '염소'
	L['Core Hounds'] = '심장부사냥개|cff1784d1(특수)|r'
	L['Devilsaurs'] = '데빌사우루스|cff1784d1(특수)|r'

	L["Target Aura Tracker"] = '대상 오라 추적기'
	L["Use |cff1874d1KnightFrame|r's custom tracker.|n  = Target Aura Tracker."] = '대상의 구분에 따라 중요한 오라들의 유무를 확인하는 추적기를 활성화합니다.'
	
	E.Options.args.KnightFrame.args.Extra_Function.args.TargetAuraTracker = {
		name = " |cff2eb7e4"..L["Target Aura Tracker"],
		desc = L["Use |cff1874d1KnightFrame|r's custom tracker.|n  = Target Aura Tracker."],
		type = "toggle",
		order = 12,
		get = function(info)
			return E.db.KnightFrame.Extra_Function.TargetAuraTracker
		end,
		set = function(info, value)
			E.db.KnightFrame.Extra_Function.TargetAuraTracker = value
			KF:TargetAuraTracker_Initialize()
		end,
	}
	P["KnightFrame"]["Extra_Function"]["TargetAuraTracker"] = true
	E:RegisterModule(KFTAT:GetName())
if (E.db.KnightFrame.Enable == nil or E.db.KnightFrame.Enable == true) then
-----------------------------------------------------------
-- [ Knight : 대상 오라 추적기							]--
-----------------------------------------------------------
	--마법피해 5% 증가 모음
	KFTAT.Spell1Enemy = {
		[1] = { -- 번개 숨결
			["ID"] = 24844,
			["Class"] = L["Wind Serpents"]..'('..L["Hunter"]..'|r)',
		},
		[3] = { -- 원소의 저주
			["ID"] = 1490,
			["Class"] = L["Warlock"],
		},
		[2] = { -- 불의 숨결
			["ID"] = 34889,
			["Class"] = L["Dragonhawks"]..'('..L["Hunter"]..'|r)',
		},
		[4] = { -- 독의 대가
			["ID"] = 58410,
			["Class"] = L["Rogue"],
		},
	}

	--방어도 감소 모음
	KFTAT.Spell2Enemy = {
		['GoalDebuff'] = {
			["ID"] = 113746,
			["Class"] = '',
		},
		[1] = { -- 요정의 불꽃
			["ID"] = 770,
			["Class"] = L["Druid"],
		},
		[2] = { -- 먼지 구름
			["ID"] = 50285,
			["Class"] = L["Tallstriders"]..'('..L["Hunter"]..'|r)',
		},
		[3] = { -- 약점노출
			["ID"] = 8647,
			["Class"] = L["Rogue"],
		},
		[4] = { -- 압도
			["ID"] = 20243,
			["Class"] = L["Warrior"]..'('..L["WProtection"]..')',
		},
		[5] = { -- 방어구 가르기
			["ID"] = 7386,
			["Class"] = L["Warrior"],
		},
		[6] = { -- 갑옷 찢기
			["ID"] = 50498,
			["Class"] = L["Raptors"]..'('..L["Hunter"]..'|r)',
		},
	}

	--물리피해 증가 모음
	KFTAT.Spell3Enemy = {
		['GoalDebuff'] = {
			["ID"] = 81326,
			["Class"] = '',
		},
		[1] = { -- 약탈
			["ID"] = 50518,
			["Class"] = L["Ravagers"]..'('..L["Hunter"]..'|r)',
		},
		[2] = { -- 산성 숨결
			["ID"] = 55749,
			["Class"] = L["Worms"]..'('..L["Hunter"]..'|r)',
		},
		[3] = { -- 부러진 뼈
			["ID"] = 81328,
			["Class"] = L["Death Knight"]..'('..L["Frost"]..')',
		},
		[4] = { -- 쇄도
			["ID"] = 57386,
			["Class"] = L["Rhinos"]..'('..L["Hunter"]..'|r)',
		},
		[5] = { -- 칠흑의 역병인도자
			["ID"] = 51160,
			["Class"] = L["Death Knight"]..'('..L["Unholy"]..')',
		},
		[6] = { -- 거인의 강타
			["ID"] = 86346,
			["Class"] = L["Warrior"]..'('..L["Arms"]..','..L["Fury"]..')',
		},
		[7] = { -- 들이받기
			["ID"] = 35290,
			["Class"] = L["Boars"]..'('..L["Hunter"]..'|r)',
		},
		[8] = { -- 대담한 자의 심판
			["ID"] = 111529,
			["Class"] = L["Paladin"]..'('..L["Retribution"]..')',
		},
	}
	
	--물리 공격력 감소 모음
	KFTAT.Spell4Enemy = {
		['GoalDebuff'] = {
			["ID"] = 115798,
			["Class"] = '',
		},
		[1] = { -- 난타
			["ID"] = 106832,
			["Class"] = L["Druid"]..'('..L["Feral"]..','..L["Guardian"]..')',
		},
		[2] = { -- 정의의 망치
			["ID"] = 53595,
			["Class"] = L["Paladin"]..'('..L["PProtection"]..','..L["Retribution"]..')',
		},
		[3] = { -- 천둥 벼락
			["ID"] = 6343,
			["Class"] = L["Warrior"],
		},
		[4] = { -- 핏빛 열병
			["ID"] = 81132,
			["Class"] = L["Death Knight"]..'('..L["Blood"]..')',
		},
		[5] = { -- 대지 충격
			["ID"] = 8042,
			["Class"] = L["Shaman"],
		},
		[6] = { -- 곰
			["ID"] = 50256,
			["Class"] = L["Bears"]..'('..L["Hunter"]..'|r)',
		},
		[7] = { -- 무력화 저주
			["ID"] = 109466,
			["Class"] = L["Warlock"],
		},
		--[[
		[8] = { -- Keg Smash
			["ID"] = ,
			["Class"] = L["Monk"]..'('..L["Brewmaster"]..')',
		},]]
	}
	
	--주문 시전속도 감소 모음
	KFTAT.Spell5Enemy = {
		[1] = { -- 심장부사냥개
			["ID"] = 58604,
			["Class"] = L['Core Hounds']..'('..L["Hunter"]..'|r)',
		},
		[2] = { -- 여우
			["ID"] = 90314,
			["Class"] = L["Foxes"]..'('..L["Hunter"]..'|r)',
		},
		[3] = { -- 포자날개
			["ID"] = 50274,
			["Class"] = L["Sporebats"]..'('..L["Hunter"]..'|r)',
		},
		[4] = { -- 무력화 저주
			["ID"] = 109466,
			["Class"] = L["Warlock"],
		},
		[5] = { -- 정신 마비 독
			["ID"] = 5761,
			["Class"] = L["Rogue"],
		},
		--[[
		[6] = { -- 염소
			["ID"] = ,
			["Class"] = L["Goats"]..'('..L["Hunter"]..'|r)',
		},]]
	}

	--치유량 감소 모음
	KFTAT.Spell6Enemy = {
		['GoalDebuff'] = {
			["ID"] = 115804,
			["Class"] = '',
		},
		[1] = { -- 상처 감염 독
			["ID"] = 8679,
			["Class"] = L["Rogue"],
		},
		[2] = { -- 과부거미의 독
			["ID"] = 82654,
			["Class"] = L["Hunter"],
		},
		[3] = { -- 데빌사우루스
			["ID"] = 54680,
			["Class"] = L["Devilsaurs"]..'('..L["Hunter"]..'|r)',
		},
		[4] = { -- 난폭한 일격
			["ID"] = 100130,
			["Class"] = L["Warrior"]..'('..L["Fury"]..')',
		},
		[5] = { -- 필사의 일격
			["ID"] = 12294,
			["Class"] = L["Warrior"]..'('..L["Arms"]..')',
		},
	}
	
	--딜쿨기 버프 모음
	KFTAT.Spell7Enemy = {
		3045, --냥꾼 - 속사
	}

	--생존기 버프 모음
	KFTAT.Spell8Enemy = {
		19263, --냥꾼 - 공격저지
	}
	
	--크리 5% 증가 모음
	KFTAT.Spell1Ally = {
		[1] = { -- Legacy of the White Tiger 백호의 유산
			["ID"] = 116781,
			["Class"] = L["Monk"],
		},
		[2] = { -- Feearless Roar 용맹한 울음소리
			["ID"] = 126373,
			["Class"] = L["Quilen"]..'('..L["Hunter"]..'|r)',
		},
		[3] = { -- Terrifying Roar 공포의 포효
			["ID"] = 90309,
			["Class"] = L["Devilsaurs"]..'('..L["Hunter"]..'|r)',
		},
		[4] = { -- Dalaran Brilliance 달라란의 총명함
			["ID"] = 61316,
			["Class"] = L["Mage"],
		},
		[5] = { -- Arcane Brilliance 신비한 총명함
			["ID"] = 1459,
			["Class"] = L["Mage"],
		},
		[6] = { -- Furious Howl 사나운 울음소리
			["ID"] = 24604,
			["Class"] = L["Wolves"]..'('..L["Hunter"]..'|r)',
		},
		[7] = { -- Leader of The Pact 무리의 우두머리
			["ID"] = 24932,
			["Class"] = L["Druid"]..'('..L["Feral"]..','..L["Guardian"]..')',
		},
		[8] = { -- Still Water 잔잔한 물
			["ID"] = 126309,
			["Class"] = L['Water Striders']..'('..L["Hunter"]..'|r)',
		},
	}
	
	--능력치 증가 모음
	KFTAT.Spell2Ally = {
		[1] = { -- Embrace of the Shale Spider 혈암거미의 은총
			["ID"] = 90363,
			["Class"] = L["Shale Spiders"]..'('..L["Hunter"]..'|r)',
		},
		[2] = { --Legacy of The Emperor 황제의 유산
			["ID"] = 117667,
			["Class"] = L["Monk"],
		},
		[3] = { -- Blessing Of Kings 왕의 축복
			["ID"] = 20217,
			["Class"] = L["Paladin"],
		},
		[4] = { -- Mark of The Wild 야생의 징표
			["ID"] = 1126,
			["Class"] = L["Druid"],
		},
	}
	
	--특화도 증가 모음
	KFTAT.Spell3Ally = {		
		[1] = { --Roar of Courage 용기의 포효
			["ID"] = 93435,
			["Class"] = L["Cats"]..'('..L["Hunter"]..'|r)',
		},
		[2] = {  --Spirit Beast Blessing 야수 정령의 축복
			["ID"] = 128997,
			["Class"] = L["Spirit Beasts"]..'('..L["Hunter"]..'|r)',
		},
		[3] = { -- Blessing of Might 힘의 축복
			["ID"] = 19740,
			["Class"] = L["Paladin"],
		},
		[4] = { --Grace of Air 바람의 은총
			["ID"] = 116956,
			["Class"] = L["Shaman"],
		},
	}
	
	--체력 증가 모음
	KFTAT.Spell4Ally = {
		[1] = { -- Qiraji Fortitude 퀴라지의 인내
			["ID"] = 90364,
			["Class"] = L["Silithids"]..'('..L["Hunter"]..'|r)',
		},
		[2] = { -- Commanding Shout 지휘의 외침
			["ID"] = 469,
			["Class"] = L["Warrior"],
		},
		[3] = { -- Power Word: Fortitude 신의 권능 : 인내
			["ID"] = 21562,
			["Class"] = L["Priest"],
		},
		[4] = { -- Imp. Blood Pact 피의 서약
			["ID"] = 6307,
			["Class"] = L["Imp"]..'('..L["Warlock"]..'|r)',
		},
	}
	
	--영약도핑 모음
	KFTAT.Spell5Ally = {
		105696, --힘영약
		105689, --민첩영약
		105691, --지능영약
		105694, --체력영약
		105693, --정신력영약
	}
	
	--음식도핑 모음
	KFTAT.Spell6Ally = {
		104264, --250 int
	}
	
	--블러드디버프 모음
	KFTAT.Spell7Ally = {
		95809, --정신 이상(심장부사냥개)
		80354, --시간왜곡 디버프
		57724, --블러드러스트 디버프
	}
	
	--부활디버프 모음
	KFTAT.Spell8Ally = {
		97821, --죽기 - 공허의 손길(전부디버프)
		95223, --대규모부활 디버프
	}

	local checktext, currenttargetmode
	local TT = E:GetModule('Tooltip')
	function KFTAT:TATracker_CheckPlayerTarget()
		local frame = self.frame
		if UnitExists('target') == nil then
			frame:Hide()
			currenttargetmode = 'NONE'
			if (E.db.KnightFrame.Panel_Option.Toppanel == (nil or true)) or (KFTPholder and not KFTPholder:IsShown()) then KFTPlocation:Show() KFTPlocX:Show() KFTPlocY:Show() end
			return
		else
			frame:Show()
			if (E.db.KnightFrame.Panel_Option.Toppanel == (nil or true)) or (KFTPholder and KFTPholder:IsShown()) then KFTPlocation:Hide() KFTPlocX:Hide() KFTPlocY:Hide() end
			local level = UnitLevel("target")
			local color = TT:GetColor("target")
			local classif = UnitClassification("target")
			
			if  classif == "worldboss" then	classif = ' B'
			elseif classif == "rareelite" then classif = ' RE'
			elseif classif == "elite" then classif = ' E'
			elseif classif == "rare" then classif = ' R'
			else classif = '' end
			
			if not color then color = "|CFFFFFFFF" end
			local r, g, b = GetQuestDifficultyColor(level).r, GetQuestDifficultyColor(level).g, GetQuestDifficultyColor(level).b
			if UnitCanAttack('player', 'target') and (UnitClassification("target") == 'worldboss' or level == -1) then r = 0.6 g = 0 b = 0 end
			KFTATlevelplate.text:SetText(format("|cff%02x%02x%02x%s%s|r", r*255, g*255, b*255, level > 0 and level or "??", classif.."|r"))
			KFTATnameplate.text:SetText(format("%s%s", color, UnitName("target")).."|r")
			KFTATetcplate.text:SetText('')
			checktext = false
		end
		if UnitCanAttack("player", "target") == 1 then
			KFTATetcplate.text:Hide()
			KFTAT.Spell1List = KFTAT.Spell1Enemy
			KFTAT.Spell2List = KFTAT.Spell2Enemy
			KFTAT.Spell3List = KFTAT.Spell3Enemy
			KFTAT.Spell4List = KFTAT.Spell4Enemy
			KFTAT.Spell5List = KFTAT.Spell5Enemy
			KFTAT.Spell6List = KFTAT.Spell6Enemy
			KFTAT.Spell7List = KFTAT.Spell7Enemy
			KFTAT.Spell8List = KFTAT.Spell8Enemy
			if UnitIsPlayer('target') == 1 then
				frame.spell7:Show()
				frame.spell8:Show()
				currenttargetmode = 'enemy'
			else
				frame.spell7:Hide()
				frame.spell8:Hide()
				currenttargetmode = 'monster'
			end
		else
			KFTAT.Spell1List = KFTAT.Spell1Ally
			KFTAT.Spell2List = KFTAT.Spell2Ally
			KFTAT.Spell3List = KFTAT.Spell3Ally
			KFTAT.Spell4List = KFTAT.Spell4Ally
			KFTAT.Spell5List = KFTAT.Spell5Ally
			KFTAT.Spell6List = KFTAT.Spell6Ally
			KFTAT.Spell7List = KFTAT.Spell7Ally
			KFTAT.Spell8List = KFTAT.Spell8Ally
			if UnitIsPlayer('target') == 1 then
				KFTATetcplate.text:Show()
				frame.spell7:Show()
				frame.spell8:Show()
				currenttargetmode = 'friend'
				KFTATetcplate:SetScript('OnUpdate', function(self, elapsed)
					if KFTATetcplate:IsShown() and checktext == false and UnitExists("target") == 1 then
						local iLevel = 0
						if UnitIsUnit('target', 'player') then
							iLevel = TT:GetItemLvL('player') or 0
						else
							for index, _ in pairs(TT.InspectCache) do
								local inspectCache = TT.InspectCache[index]
									if inspectCache.GUID == UnitGUID('target') then
									iLevel = inspectCache.ItemLevel or 0
								end
							end
						end
						if iLevel > 0 then KFTATetcplate.text:SetText('|cffffffff'..iLevel) checktext = true return end
						if (self.elapsed and self.elapsed > 1) then
							local isInspectOpen = (InspectFrame and InspectFrame:IsShown()) or (Examiner and Examiner:IsShown())
							if (CanInspect("target")) and (not isInspectOpen) then
								NotifyInspect("target")
							else
								KFTATetcplate.text:SetText('??')
							end
							self.elapsed = 0
						else
							self.elapsed = (self.elapsed or 0) + elapsed
						end
					end
				end)
			else
				currenttargetmode = 'npc'
				KFTATetcplate.text:Hide()
				frame.spell7:Hide()
				frame.spell8:Hide()
			end
		end
		KFTAT:TATracker_UpdateReminder()
	end

	function KFTAT:TATracker_CheckFilterForActiveBuff(filter, checktype)
		local spellName, texture, class
		for tag, check in pairs(filter) do
			spellName, _, texture = GetSpellInfo(type(check) == 'table' and filter[tag]["ID"] or check)
			if UnitAura("target", spellName, nil, checktype) then
				return true, tag, texture, spellName, type(check) == 'table' and filter[tag]["Class"] or false
			end
		end
		return false, _, texture
	end
	
	function KFTAT:TATracker_UpdateReminder(event, unit)
		if (event == "UNIT_AURA" and unit ~= "target") or currenttargetmode == 'NONE' then return end
		local frame = self.frame
		for i = 1, 8 do
			local checktype, hasBuff, tag, texture, spellname, class
			checktype = ''
			if currenttargetmode == 'friend' then if (i == 7 or i == 8) then checktype = "HARMFUL" end
			elseif currenttargetmode == 'enemy' or currenttargetmode == 'monster' then if not (i == 7 or i == 8) then checktype = "HARMFUL" end end
			hasBuff, tag, texture, spellname, class = KFTAT:TATracker_CheckFilterForActiveBuff(KFTAT['Spell'..i..'List'], checktype)
			frame['spell'..i].t:SetTexture(texture)
			if hasBuff then
				frame['spell'..i].t:SetAlpha(1)
				if checktype == "HARMFUL" then frame['spell'..i]:SetBackdropBorderColor(0.6, 0, 0) else frame['spell'..i]:SetBackdropBorderColor(1, 0.86, 0.24) end
				frame['spell'..i]:SetScript('OnEnter',function(self)
					GameTooltip:SetOwner(self,'ANCHOR_BOTTOM', 20, -4);
					GameTooltip:ClearLines()
					GameTooltip:AddLine(KF:Colortext('Aura')..' : |cffffdc3c'..L["KFTAT"..i..checktype]..'|r',1,1,1)
					GameTooltip:AddLine('|n '..KF:Colortext('-*')..' |cff6dd66d적용중|r : ',1,1,1)
					if not class or type(tag) == "string" then
						GameTooltip:AddLine('   '..spellname..'|n',1,1,1)
					else
						GameTooltip:AddDoubleLine(class, spellname, 1,1,1,1,1,1)
					end
					GameTooltip:Show()
				end)
				frame['spell'..i]:SetScript('OnLeave',function() GameTooltip:Hide() end)
				if currenttargetmode == 'friend' or currenttargetmode == 'enemy' and (i == 7 or i == 8) then frame['spell'..i]:Show() end
			else
				frame['spell'..i].t:SetAlpha(0.2)
				frame['spell'..i]:SetBackdropBorderColor(unpack(E.media.bordercolor))
				frame['spell'..i]:SetScript('OnEnter',function(self)
					GameTooltip:SetOwner(self,'ANCHOR_BOTTOM', 20, -4);
					GameTooltip:ClearLines()
					GameTooltip:AddLine(KF:Colortext('Aura')..' : |cffffdc3c'..L["KFTAT"..i..checktype]..'|r',1,1,1)
					GameTooltip:AddLine('|n '..KF:Colortext('-*')..' |cffb9062f미적용중|r',1,1,1)
					local isFirst = true
					for tooltiptag, check in pairs(KFTAT['Spell'..i..'List']) do
						if type(check) == 'table' and type(tooltiptag) == 'number' then
							if isFirst == true then GameTooltip:AddLine('|n <|cffceff00가능 클래스|r >',1,1,1) isFirst = false end
							GameTooltip:AddDoubleLine(KFTAT['Spell'..i..'List'][tooltiptag]["Class"], GetSpellInfo(KFTAT['Spell'..i..'List'][tooltiptag]["ID"]),1,1,1,1,1,1)
						end
					end
					GameTooltip:Show()
				end)
				frame['spell'..i]:SetScript('OnLeave',function() GameTooltip:Hide() end)
				if (currenttargetmode == 'monster' and (i == 7 or i == 8)) then frame['spell'..i]:Hide() end
			end
		end
		
	end
	
	function KFTAT:TATracker_CreateButton(name, relativeTo, arrow, isFirst, sizetype)
		local button = CreateFrame("Frame", name, KFTATHolder)
		button:SetTemplate('Default')
		button:SetFrameLevel(8)
		if sizetype =="debuff" then button:Size(28,24) else button:Size(20,20) end
		if arrow == "right" and isFirst then
			button:Point("TOPRIGHT", relativeTo, "TOPRIGHT", -4, -4)
		elseif arrow == "left" and isFirst then
			button:Point("TOPLEFT", relativeTo, "TOPLEFT", 4, -4)
		elseif arrow == "center" and isFirst then
			button:Point("BOTTOMLEFT", relativeTo, "BOTTOM", -22, -4)
		elseif arrow == "left" then
			button:Point("RIGHT", relativeTo, "LEFT", -4, 0)
		elseif arrow == "right" then
			button:Point("LEFT", relativeTo, "RIGHT", 4, 0)
		end
		button.t = button:CreateTexture(nil, "OVERLAY")
		button.t:SetTexCoord(unpack(E.TexCoords))
		button.t:Point("TOPLEFT", 2, -2)
		button.t:Point("BOTTOMRIGHT", -2, 2)
		button.t:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
		return button
	end

	function KF:TargetAuraTracker_Initialize()
		local frame = KFTATHolder
		if not frame then
			frame = CreateFrame('Frame', 'KFTATHolder', KF.UIParent)
			frame:SetFrameStrata('BACKGROUND')
			frame:SetSize(290,20)
			frame:Point('TOP', E.UIParent, 'TOP', 0, -30)
		
			local nameplate = CreateFrame('Frame', 'KFTATnameplate', frame)
			nameplate:SetSize(200,20)
			nameplate:Point('BOTTOM', frame, 'BOTTOM', 0, 20)
			nameplate:SetFrameLevel(10)
			nameplate:SetTemplate('Default', true)
			KF:TextSetting(nameplate, 'CENTER', '', nil, 'CENTER')
		
			local levelplate = CreateFrame('Frame', 'KFTATlevelplate', nameplate)
			levelplate:SetSize(46,20)
			levelplate:Point('RIGHT', nameplate, 'LEFT', -4, 0)
			levelplate:SetFrameLevel(10)
			levelplate:SetTemplate('Default', true)
			KF:TextSetting(levelplate, 'CENTER', '', nil, 'CENTER')
		
			local etc = CreateFrame('Frame', 'KFTATetcplate', nameplate)
			etc:SetSize(46,20)
			etc:Point('LEFT', nameplate, 'RIGHT', 4, 0)
			etc:SetFrameLevel(10)
			etc:SetTemplate('Default', true)
			KF:TextSetting(etc, 'CENTER', '', nil, 'CENTER')
			
			frame.spell3 = KFTAT:TATracker_CreateButton('KFTATspell3', frame, "center", true)		--특화도
			frame.spell2 = KFTAT:TATracker_CreateButton(nil, frame.spell3, "left")		--능력치
			frame.spell1 = KFTAT:TATracker_CreateButton(nil, frame.spell2, "left")		--크리5%
			frame.spell4 = KFTAT:TATracker_CreateButton(nil, frame.spell3, "right")		--체력
			frame.spell5 = KFTAT:TATracker_CreateButton(nil, frame.spell4, "right")		--영약도핑
			frame.spell6 = KFTAT:TATracker_CreateButton(nil, frame.spell5, "right")		--음식도핑
			frame.spell7 = KFTAT:TATracker_CreateButton('KFTATspell7', frame, "left", true, "debuff")		--딜쿨기버프/블러드디버프
			frame.spell8 = KFTAT:TATracker_CreateButton('KFTATspell8', frame, "right", true, "debuff")		--생존기버프/부활디버프

			E:CreateMover(KFTATHolder, 'KFTATMover', 'TargetAuraTracker', nil, nil)
		
			frame:Hide()
		
			local f1 = CreateFrame('Frame', nil, frame)
			f1:Point('TOPLEFT', frame.spell7, 'TOPLEFT', -4, 4)
			f1:Point('BOTTOMRIGHT', frame.spell7, 'BOTTOMRIGHT', 4, 4)
			f1:SetParent('KFTATspell7')
			f1:SetFrameLevel(7)
			f1:SetTemplate('Default', true)
		
			local f2 = CreateFrame('Frame', nil, frame)
			f2:Point('TOPLEFT', frame.spell1, 'TOPLEFT', -5, 4)
			f2:Point('BOTTOMRIGHT', frame.spell6, 'BOTTOMRIGHT', 5, 4)
			f2:SetFrameLevel(7)
			f2:SetTemplate('Default', true)
		
			local f3 = CreateFrame('Frame', nil, frame)
			f3:Point('TOPLEFT', frame.spell8, 'TOPLEFT', -4, 4)
			f3:Point('BOTTOMRIGHT', frame.spell8, 'BOTTOMRIGHT', 4, 4)
			f3:SetParent('KFTATspell8')
			f3:SetFrameLevel(7)
			f3:SetTemplate('Default', true)
		
			local f4 = CreateFrame('Frame', 'KFTATNoTPHolder', frame)
			f4:SetFrameStrata('BACKGROUND')
			f4:CreateBackdrop('Transparent')
			f4:Point('TOPLEFT', levelplate, 'TOPLEFT', -10, -10)
			f4:Point('BOTTOMRIGHT', etc, 'BOTTOMRIGHT', 10, 10)
			
			if KFTopPanel and KFTopPanel:IsShown() then f4:Hide() end
			
			WorldStateAlwaysUpFrame:Point('TOP', UIParent, 'TOP', -18, -50)
			KFTAT.frame = frame
		end
		if E.db.KnightFrame.Extra_Function.TargetAuraTracker == false then
			KFTAT:UnregisterEvent("UNIT_AURA")
			KFTAT:UnregisterEvent("PLAYER_TARGET_CHANGED")
			KFTATHolder:Hide()
			KFTATnameplate:Hide()
			KFTATlevelplate:Hide()
			KFTATetcplate:Hide()
			KFTPlocation.text:Show()
			KFTPlocX.text:Show()
			KFTPlocY.text:Show()
		else
			KFTAT:RegisterEvent("UNIT_AURA", 'TATracker_UpdateReminder')
			KFTAT:RegisterEvent("PLAYER_TARGET_CHANGED", 'TATracker_CheckPlayerTarget')
			KFTAT:TATracker_CheckPlayerTarget()
			KFTAT:TATracker_UpdateReminder()
		end
		local mover = KFTATMover
		mover:ClearAllPoints()
		if (E.db.KnightFrame.Panel_Option.Toppanel == (nil or true)) or (KFTopPanel and KFTopPanel:IsShown()) then
			mover:Point('TOP', E.UIParent, 'TOP', 0, -30)
			mover.text:SetText("|cff838383"..L["Target Aura Tracker"].."|r |cffffffff(|r|cffb9062fTopPanel Lock!!|r|cffffffff)|r")
			mover:Disable()
		else
			mover:Enable()
			if E:HasMoverBeenMoved('KFTATMover') then
				local point, anchor, secondaryPoint, x, y = string.split('\031', E.db['movers']['KFTATMover'])
				mover:SetPoint(point, anchor, secondaryPoint, x, y)
			else
				mover:Point('TOP', E.UIParent, 'TOP', 0, -6)
			end
			mover.text:SetText(L["Target Aura Tracker"])
		end
	end
end	--knightframe enable, 닫는 end
end --버전확인 닫는 end ,맨 마지막 전 줄에 둘 것.