--local E, L, V, P, G, _  = unpack(ElvUI)
local E, L, _, _, _, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

if KF.UIParent and KF.db.Panel_Options.TopPanel ~= false then
	-----------------------------------------------------------
	-- [ Knight : BuffTracker								]--
	-----------------------------------------------------------
	local SynergyBuffs, Check, CheckingSpellName, SpellTexture, CheckAura
	if KF.db.Extra_Functions.BuffTracker ~= false or KF.db.Extra_Functions.TargetAuraTracker ~= false then
		SynergyBuffs = {
			[1] = { -- Attack Power 전투력 증가
				[1] = { -- Trueshot Aura 정조준 오라
					['ID'] = 19506,
					['Class'] = L['Hunter'],
				},
				[2] = { -- Battle Shout 전투의 외침
					['ID'] = 6673,
					['Class'] = L['Warrior'],
				},
				[3] = { -- Horn of Winter 겨울의 뿔피리
					['ID'] = 57330,
					['Class'] = L['Death Knight']
				},
			},
			[2] = { -- Attack Speed 가속 증가
				[1] = { -- Swiftblade's Cunning 스위프트블레이드의 간교함
					['ID'] = 113742,
					['Class'] = L['Rogue'],
				},
				[2] = { -- Serpent's Swiftness 독사의 신속함
					['ID'] = 128433,
					['Class'] = L['Serpents']..'('..L['Hunter']..'|r)',
				},
				[3] = { -- Cackling Howl 불쾌한 울음소리
					['ID'] = 128432,
					['Class'] = L['Hyenas']..'('..L['Hunter']..'|r)',
				},
				[4] = { -- Improved Icy Talons 부정의 오라
					['ID'] = 55610,
					['Class'] = L['Death Knight'],
				},
				[5] = { -- Unleashed Rage 해방된 분노
					['ID'] = 30809,
					['Class'] = L['Shaman']..'('..L['Enhancement']..')',
				},
			},
			[3] = { -- Spell Power 주문력 증가
				[1] = {
					['ID'] = 77747, -- Burning Wrath 불타는 분노
					['Class'] = L['Shaman'],
				},
				[2] = { -- Still Water 잔잔한 물
					['ID'] = 126309,
					['Class'] = L['Water Striders']..'('..L['Hunter']..'|r)',
				},
				[3] = { -- Dark Intent 검은 의도
					['ID'] = 109773,
					['Class'] = L['Warlock'],
				},
				[4] = { -- Dalaran Brilliance 달라란의 총명함
					['ID'] = 61316,
					['Class'] = L['Mage'],
				},
				[5] = { -- Arcane Brilliance 신비한 총명함
					['ID'] = 1459,
					['Class'] = L['Mage']
				},
			},
			[4] = { -- Spell Haste 주문가속 증가
				[1] = { -- Moonkin Aura 달빛야수 오라
					['ID'] = 24907,
					['Class'] = L['Druid']..'('..L['Balance']..')',
				},
				[2] = { -- Elemental Oath 정령의 서약
					['ID'] = 51470,
					['Class'] = L['Shaman']..'('..L['Elemental']..')',
				},
				[3] = { -- Mind Quickening 사고 촉진
					['ID'] = 49868,
					['Class'] = L['Priest']..'('..L['Shadow']..')',
				},
			},
			[5] = { -- Beacon Of Light 빛의 봉화
				[1] = { -- Beacon of Light 빛의 봉화
					['ID'] = 53563,
					['Class'] = L['Paladin']..'('..L['Holy']..')',
				},
			},
			[6] = { -- Critical 크리 5% 증가
				[1] = { -- Legacy of the White Tiger 백호의 유산
					['ID'] = 116781,
					['Class'] = L['Monk'],
				},
				[2] = { -- Feearless Roar 용맹한 울음소리
					['ID'] = 126373,
					['Class'] = L['Quilen']..'('..L['Hunter']..'|r)',
				},
				[3] = { -- Terrifying Roar 공포의 포효
					['ID'] = 90309,
					['Class'] = L['Devilsaurs']..'('..L['Hunter']..'|r)',
				},
				[4] = { -- Dalaran Brilliance 달라란의 총명함
					['ID'] = 61316,
					['Class'] = L['Mage'],
				},
				[5] = { -- Arcane Brilliance 신비한 총명함
					['ID'] = 1459,
					['Class'] = L['Mage'],
				},
				[6] = { -- Furious Howl 사나운 울음소리
					['ID'] = 24604,
					['Class'] = L['Wolves']..'('..L['Hunter']..'|r)',
				},
				[7] = { -- Leader of The Pact 무리의 우두머리
					['ID'] = 24932,
					['Class'] = L['Druid']..'('..L['Feral']..','..L['Guardian']..')',
				},
				[8] = { -- Still Water 잔잔한 물
					['ID'] = 126309,
					['Class'] = L['Water Striders']..'('..L['Hunter']..'|r)',
				},
			},
			[7] = { -- All Stats 능력치 증가
				[1] = { -- Embrace of the Shale Spider 혈암거미의 은총
					['ID'] = 90363,
					['Class'] = L['Shale Spiders']..'('..L['Hunter']..'|r)',
				},
				[2] = { --Legacy of The Emperor 황제의 유산
					['ID'] = 117667,
					['Class'] = L['Monk'],
				},
				[3] = { -- Blessing Of Kings 왕의 축복
					['ID'] = 20217,
					['Class'] = L['Paladin'],
				},
				[4] = { -- Mark of The Wild 야생의 징표
					['ID'] = 1126,
					['Class'] = L['Druid'],
				},
			},
			[8] = { -- Mastery 특화도 증가
				[1] = { --Roar of Courage 용기의 포효
					['ID'] = 93435,
					['Class'] = L['Cats']..'('..L['Hunter']..'|r)',
				},
				[2] = {  --Spirit Beast Blessing 야수 정령의 축복
					['ID'] = 128997,
					['Class'] = L['Spirit Beasts']..'('..L['Hunter']..'|r)',
				},
				[3] = { -- Blessing of Might 힘의 축복
					['ID'] = 19740,
					['Class'] = L['Paladin'],
				},
				[4] = { --Grace of Air 바람의 은총
					['ID'] = 116956,
					['Class'] = L['Shaman'],
				},
			},
			[9] = {	-- Stamina 체력 증가
				[1] = { -- Qiraji Fortitude 퀴라지의 인내
					['ID'] = 90364,
					['Class'] = L['Silithids']..'('..L['Hunter']..'|r)',
				},
				[2] = { -- Commanding Shout 지휘의 외침
					['ID'] = 469,
					['Class'] = L['Warrior'],
				},
				[3] = { -- Power Word: Fortitude 신의 권능 : 인내
					['ID'] = 21562,
					['Class'] = L['Priest'],
				},
				[4] = { -- Imp. Blood Pact 피의 서약
					['ID'] = 6307,
					['Class'] = L['Imp']..'('..L['Warlock']..'|r)',
				},
			},
		}
		
		CheckAura = function(filter, unit, CheckType)
			for Tag, Check in pairs(filter) do
				CheckingSpellName, _, SpellTexture, _, _, _, _, _, _ = GetSpellInfo(type(Check) == 'table' and Check['ID'] or Check)
				if UnitAura(unit, CheckingSpellName, nil, CheckType) then
					return true, CheckingSpellName, (type(Check) == 'table' and Check['Class'] or false)
				end
			end
			return false, nil, nil
		end
	end
	
	if KF.db.Extra_Functions.BuffTracker ~= false then		
		local limiter = 0
		local spellName = { [1] = nil, [2] = nil, [3] = nil, [4] = nil, [5] = nil, [6] = nil, [7] = nil, [8] = nil, [9] = nil, }
		local userClass = { [1] = nil, [2] = nil, [3] = nil, [4] = nil, [5] = nil, [6] = nil, [7] = nil, [8] = nil, [9] = nil, }
		local function BuffTracker_UpdateReminder()
			for i = 1, 9 do
				Check, spellName[i], userClass[i] = CheckAura(SynergyBuffs[i], 'player')
				BuffTracker['Spell'..i].t:SetTexture(SpellTexture)
				if Check then
					BuffTracker['Spell'..i].t:SetAlpha(1)
					BuffTracker['Spell'..i]:SetBackdropBorderColor(1, 0.86, 0.24)
				else
					BuffTracker['Spell'..i].t:SetAlpha(0.2)
					BuffTracker['Spell'..i]:SetBackdropBorderColor(unpack(E.media.bordercolor))
				end
			end
		end
		KF:RegisterEventList('ACTIVE_TALENT_GROUP_CHANGED', BuffTracker_UpdateReminder)
		KF:RegisterEventList('CHARACTER_POINTS_CHANGED', BuffTracker_UpdateReminder)
		KF:RegisterEventList('PLAYER_ENTERING_WORLD', BuffTracker_UpdateReminder)
		KF:RegisterEventList('UNIT_AURA', function(_, unit)
			if unit ~= 'player' or not (limiter + 0.5 < GetTime()) then return end
			limiter = GetTime()
			BuffTracker_UpdateReminder()
		end)
		
		
		CreateFrame('Frame', 'BuffTracker', KF.UIParent)
		BuffTracker:Size(250,20)
		BuffTracker:Point('TOPRIGHT', -12, -6)
		
		for i = 1, 9 do
			BuffTracker['Spell'..i] = CreateFrame('Frame', nil, BuffTracker)
			BuffTracker['Spell'..i]:SetTemplate('Default')
			BuffTracker['Spell'..i]:Size(20)
			BuffTracker['Spell'..i]:SetFrameLevel(8)
			BuffTracker['Spell'..i].t = BuffTracker['Spell'..i]:CreateTexture(nil, 'OVERLAY')
			BuffTracker['Spell'..i].t:SetTexCoord(unpack(E.TexCoords))
			BuffTracker['Spell'..i].t:SetInside()
			BuffTracker['Spell'..i]:SetScript('OnLeave', function() GameTooltip:Hide() end)
			BuffTracker['Spell'..i]:SetScript('OnEnter', function(self)
				GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT', 20, -4)
				GameTooltip:ClearLines()
				GameTooltip:AddLine(KF:Color('Synergy')..' : |cffffdc3c'..BuffTracker['Spell'..i].Tag..'|r', 1, 1, 1)
				if spellName[i] then
					GameTooltip:AddLine('|n '..KF:Color('-*')..' |cff6dd66d'..L['Applied']..'|r : ', 1, 1, 1)
					GameTooltip:AddDoubleLine(userClass[i], spellName[i], 1, 1, 1, 1, 1, 1)
				else
					GameTooltip:AddLine('|n '..KF:Color('-*')..' |cffb9062f'..L['Non-applied']..'|r|n|n <|cffceff00'..L['EnableClass']..'|r >', 1, 1, 1)
					for _, SpellTable in pairs(SynergyBuffs[i]) do
						GameTooltip:AddDoubleLine(SpellTable['Class'], select(1, GetSpellInfo(SpellTable['ID'])), 1, 1, 1, 1, 1, 1)
					end
				end
				GameTooltip:Show()
			end)
		end

		BuffTracker['Spell1']:Point('TOPRIGHT', BuffTracker['Spell2'], 'TOPLEFT', -4, 0)
		BuffTracker['Spell1'].Tag = L['AP']
		BuffTracker['Spell2']:Point('TOPRIGHT', BuffTracker['Spell3'], 'TOPLEFT', -4, 0)
		BuffTracker['Spell2'].Tag = STAT_HASTE
		BuffTracker['Spell3']:Point('TOPRIGHT', BuffTracker['Spell4'], 'TOPLEFT', -4, 0)
		BuffTracker['Spell3'].Tag = L['SP']
		BuffTracker['Spell4']:Point('TOPRIGHT', BuffTracker['Spell5'], 'TOPLEFT', -19, 0)
		BuffTracker['Spell4'].Tag = ITEM_MOD_HASTE_SPELL_RATING_SHORT

		BuffTracker['Spell5']:Point('TOP', BuffTracker, 'BOTTOM', 0, 16)
		BuffTracker['Spell5'].Tag = select(1, GetSpellInfo(53563))

		BuffTracker['Spell6']:Point('TOPLEFT', BuffTracker['Spell5'], 'TOPRIGHT', 19, 0)
		BuffTracker['Spell6'].Tag = CRIT_ABBR
		BuffTracker['Spell7']:Point('TOPLEFT', BuffTracker['Spell6'], 'TOPRIGHT', 4, 0)
		BuffTracker['Spell7'].Tag = L['Stats']
		BuffTracker['Spell8']:Point('TOPLEFT', BuffTracker['Spell7'], 'TOPRIGHT', 4, 0)
		BuffTracker['Spell8'].Tag = STAT_MASTERY
		BuffTracker['Spell9']:Point('TOPLEFT', BuffTracker['Spell8'], 'TOPRIGHT', 4, 0)
		BuffTracker['Spell9'].Tag = L['Health']
		
		BuffTracker.Group1 = CreateFrame('Frame', nil, BuffTracker)
		BuffTracker.Group1:Point('TOPLEFT', BuffTracker['Spell1'], 'TOPLEFT', -4, 4)
		BuffTracker.Group1:Point('BOTTOMRIGHT', BuffTracker['Spell4'], 'BOTTOMRIGHT', 4, 4)
		BuffTracker.Group1:SetFrameLevel(7)
		BuffTracker.Group1:SetTemplate('Default', true)

		BuffTracker.Group2 = CreateFrame('Frame', nil, BuffTracker)
		BuffTracker.Group2:Point('TOPLEFT', BuffTracker['Spell5'], 'TOPLEFT', -4, 4)
		BuffTracker.Group2:Point('BOTTOMRIGHT', BuffTracker['Spell5'], 'BOTTOMRIGHT', 4, 4)
		BuffTracker.Group2:SetFrameLevel(7)
		BuffTracker.Group2:SetTemplate('Default', true)

		BuffTracker.Group3 = CreateFrame('Frame', nil, BuffTracker)
		BuffTracker.Group3:Point('TOPLEFT', BuffTracker['Spell6'], 'TOPLEFT', -4, 4)
		BuffTracker.Group3:Point('BOTTOMRIGHT', BuffTracker['Spell9'], 'BOTTOMRIGHT', 4, 4)
		BuffTracker.Group3:SetFrameLevel(7)
		BuffTracker.Group3:SetTemplate('Default', true)
	end
	
	
	-----------------------------------------------------------
	-- [ Knight : TargetAuraTracker							]--
	-----------------------------------------------------------
	if KF.db.Extra_Functions.TargetAuraTracker ~= false then
		local SynergyDebuffs = {
			[1] = { -- 방어도 감소
				['Effect'] = 113746,
				[1] = { -- 요정의 불꽃
					['ID'] = 770,
					['Class'] = L['Druid'],
				},
				[2] = { -- 먼지 구름
					['ID'] = 50285,
					['Class'] = L['Tallstriders']..'('..L['Hunter']..'|r)',
				},
				[4] = { -- 약점 노출
					['ID'] = 8647,
					['Class'] = L['Rogue'],
				},
				[5] = { -- 압도
					['ID'] = 20243,
					['Class'] = L['Warrior']..'('..L['WProtection']..')',
				},
				[3] = { -- 방어구 가르기
					['ID'] = 7386,
					['Class'] = L['Warrior'],
				},
				[6] = { -- 갑옷 찢기
					['ID'] = 50498,
					['Class'] = L['Raptors']..'('..L['Hunter']..'|r)',
				},
			},
			[2] = { -- 물리피해 증가
				['Effect'] = 81326,
				[2] = { -- 약탈
					['ID'] = 50518,
					['Class'] = L['Ravagers']..'('..L['Hunter']..'|r)',
				},
				[4] = { -- 산성 숨결
					['ID'] = 55749,
					['Class'] = L['Worms']..'('..L['Hunter']..'|r)',
				},
				[3] = { -- 부러진 뼈
					['ID'] = 81328,
					['Class'] = L['Death Knight']..'('..L['Frost']..')',
				},
				[8] = { -- 쇄도
					['ID'] = 57386,
					['Class'] = L['Rhinos']..'('..L['Hunter']..'|r)',
				},
				[5] = { -- 칠흑의 역병인도자
					['ID'] = 51160,
					['Class'] = L['Death Knight']..'('..L['Unholy']..')',
				},
				[6] = { -- 거인의 강타
					['ID'] = 86346,
					['Class'] = L['Warrior']..'('..L['Arms']..','..L['Fury']..')',
				},
				[7] = { -- 들이받기
					['ID'] = 35290,
					['Class'] = L['Boars']..'('..L['Hunter']..'|r)',
				},
				[1] = { -- 대담한 자의 심판
					['ID'] = 111529,
					['Class'] = L['Paladin']..'('..L['Retribution']..')',
				},
			},
			[3] = { -- 물리 공격력 감소
				['Effect'] = 115798,
				[1] = { -- 난타
					['ID'] = 106832,
					['Class'] = L['Druid']..'('..L['Feral']..','..L['Guardian']..')',
				},
				[2] = { -- 정의의 망치
					['ID'] = 53595,
					['Class'] = L['Paladin']..'('..L['PProtection']..','..L['Retribution']..')',
				},
				[3] = { -- 천둥 벼락
					['ID'] = 6343,
					['Class'] = L['Warrior'],
				},
				[4] = { -- 핏빛 열병
					['ID'] = 81132,
					['Class'] = L['Death Knight']..'('..L['Blood']..')',
				},
				[5] = { -- 대지 충격
					['ID'] = 8042,
					['Class'] = L['Shaman'],
				},
				[6] = { -- 곰
					['ID'] = 50256,
					['Class'] = L['Bears']..'('..L['Hunter']..'|r)',
				},
				[7] = { -- 무력화 저주
					['ID'] = 109466,
					['Class'] = L['Warlock'],
				},
				[8] = { -- Keg Smash
					['ID'] = 121253,
					['Class'] = L['Monk']..'('..L['Brewmaster']..')',
				},
			},
			[4] = { -- 주문 시전속도 감소
				[1] = { -- 심장부사냥개
					['ID'] = 58604,
					['Class'] = L['Core Hounds']..'('..L['Hunter']..'|r)',
				},
				[2] = { -- 여우
					['ID'] = 90314,
					['Class'] = L['Foxes']..'('..L['Hunter']..'|r)',
				},
				[3] = { -- 포자날개
					['ID'] = 50274,
					['Class'] = L['Sporebats']..'('..L['Hunter']..'|r)',
				},
				[4] = { -- 무력화 저주
					['ID'] = 109466,
					['Class'] = L['Warlock'],
				},
				[5] = { -- 정신 마비 독
					['ID'] = 5761,
					['Class'] = L['Rogue'],
				},
				[6] = { -- 염소
					['ID'] = 126402,
					['Class'] = L['Goats']..'('..L['Hunter']..'|r)',
				},
			},
			[5] = { -- 마법피해 5% 증가
				[1] = { -- 불의 숨결
					['ID'] = 34889,
					['Class'] = L['Dragonhawks']..'('..L['Hunter']..'|r)',
				},
				[2] = { -- 번개 숨결
					['ID'] = 24844,
					['Class'] = L['Wind Serpents']..'('..L['Hunter']..'|r)',
				},
				[3] = { -- 원소의 저주
					['ID'] = 1490,
					['Class'] = L['Warlock'],
				},
				[4] = { -- 독의 대가
					['ID'] = 58410,
					['Class'] = L['Rogue'],
				},
			},
			[6] = { -- 치유량 감소
				['Effect'] = 115804,
				[1] = { -- 상처 감염 독
					['ID'] = 8679,
					['Class'] = L['Rogue'],
				},
				[2] = { -- 과부거미의 독
					['ID'] = 82654,
					['Class'] = L['Hunter'],
				},
				[3] = { -- 데빌사우루스
					['ID'] = 54680,
					['Class'] = L['Devilsaurs']..'('..L['Hunter']..'|r)',
				},
				[4] = { -- 난폭한 일격
					['ID'] = 100130,
					['Class'] = L['Warrior']..'('..L['Fury']..')',
				},
				[5] = { -- 필사의 일격
					['ID'] = 12294,
					['Class'] = L['Warrior']..'('..L['Arms']..')',
				},
			},
			[7] = {
				-- HUNTER
				3045,
			},
			[8] = {
				-- HUNTER
				19263,
			},
		}
		SynergyBuffs[10] = { -- Elixirs 영약도핑
			105696, --Str
			105689, --Agi
			105691, --Int
			105694, --HP
			105693, --Wis
		}
		SynergyBuffs[11] = { -- Foods 음식도핑
			104264,
		}
		SynergyBuffs[12] = { -- Bloodlust Debuff
			95809, -- Core Hounds
			80354, -- Time Warp
			57724, -- Bloodrust
		}
		SynergyBuffs[13] = { -- Resurrection Debuff
			97821, -- Deathknight 공허의 손길(전부디버프)
			95223, -- Mass Resurrection 대규모부활
		}
		
		local CurrentTarget = 'NONE'
		local limiter = 0
		local spellName = { [1] = nil, [2] = nil, [3] = nil, [4] = nil, [5] = nil, [6] = nil, [7] = nil, [8] = nil, }
		local userClass = { [1] = nil, [2] = nil, [3] = nil, [4] = nil, [5] = nil, [6] = nil, [7] = nil, [8] = nil, }
		
		local function TargetAuraTracker_UpdateReminder()
			for i = 1, 8 do
				if CurrentTarget == 'Ally' or CurrentTarget == 'NPC' then
					Check, spellName[i], userClass[i] = CheckAura(SynergyBuffs[i + 5], 'target', (i == 7 or i == 8) and 'HARMFUL')
				elseif CurrentTarget == 'Enemy' or CurrentTarget == 'Monster' then
					Check, spellName[i], userClass[i] = CheckAura(SynergyDebuffs[i], 'target', not (i == 7 or i == 8) and 'HARMFUL')
				end
				
				TargetAuraTracker['Spell'..i].t:SetTexture(SpellTexture)
				if Check then
					TargetAuraTracker['Spell'..i].t:SetAlpha(1)
					if (CurrentTarget == 'Ally' or CurrentTarget == 'NPC') and not (i == 7 or i == 8) then
						TargetAuraTracker['Spell'..i]:SetBackdropBorderColor(1, 0.86, 0.24)
					else
						TargetAuraTracker['Spell'..i]:SetBackdropBorderColor(0.6, 0, 0)
					end
				else
					TargetAuraTracker['Spell'..i].t:SetAlpha(0.2)
					TargetAuraTracker['Spell'..i]:SetBackdropBorderColor(unpack(E.media.bordercolor))
				end
			end
		end
		
		local function CheckTargetType()
			if not UnitExists('target') then
				CurrentTarget = 'NONE'
				TargetAuraTracker:Hide()
				KF.UpdateFrame.UpdateList.UpdateLocation['Action']()
				return
			else
				TargetAuraTracker:Show()
				if UnitIsPlayer('target') then
					TargetAuraTracker['Spell5']:Show()
					TargetAuraTracker['Spell6']:Show()
					TargetAuraTracker['Spell7']:Show()
					TargetAuraTracker['Spell8']:Show()
					TargetAuraTracker.Group1:Point('TOPLEFT', TargetAuraTracker['Spell5'], 'TOPLEFT', -4, 4)
					TargetAuraTracker.Group1:Point('BOTTOMRIGHT', TargetAuraTracker['Spell6'], 'BOTTOMRIGHT', 4, 4)
					if UnitCanAttack('player', 'target') then
						CurrentTarget = 'Enemy'
					else
						CurrentTarget = 'Ally'
					end
				else
					TargetAuraTracker['Spell7']:Hide()
					TargetAuraTracker['Spell8']:Hide()
					if UnitCanAttack('player', 'target') then
						CurrentTarget = 'Monster'
						TargetAuraTracker['Spell5']:Show()
						TargetAuraTracker['Spell6']:Show()
						TargetAuraTracker.Group1:Point('TOPLEFT', TargetAuraTracker['Spell5'], 'TOPLEFT', -4, 4)
						TargetAuraTracker.Group1:Point('BOTTOMRIGHT', TargetAuraTracker['Spell6'], 'BOTTOMRIGHT', 4, 4)
					else
						CurrentTarget = 'NPC'
						TargetAuraTracker['Spell5']:Hide()
						TargetAuraTracker['Spell6']:Hide()
						TargetAuraTracker.Group1:Point('TOPLEFT', TargetAuraTracker['Spell1'], 'TOPLEFT', -4, 4)
						TargetAuraTracker.Group1:Point('BOTTOMRIGHT', TargetAuraTracker['Spell4'], 'BOTTOMRIGHT', 4, 4)
					end
				end
				if KF.db.Panel_Options.TopPanel ~= false then
					TopPanel.LocationName.text:SetText((E:GetModule('Tooltip'):GetColor('target') or '')..UnitName('target'))
					
					Check = UnitClassification('target')
					if Check == "worldboss" then Check = ' |TInterface\\TargetingFrame\\UI-TargetingFrame-Skull:0|t'
					elseif Check == "rareelite" then Check = ' RE'
					elseif Check == "elite" then Check = ' E'
					elseif Check == "rare" then Check = ' R'
					else Check = '' end
					
					TopPanel.LocationX.text:SetText(format('|cff%02x%02x%02x%s%s|r',
						((UnitCanAttack('player', 'target') and (UnitClassification('target') == 'worldboss' or UnitLevel('target') == -1)) and 0.6 or GetQuestDifficultyColor(UnitLevel('target')).r) * 255,
						((UnitCanAttack('player', 'target') and (UnitClassification('target') == 'worldboss' or UnitLevel('target') == -1)) and 0 or GetQuestDifficultyColor(UnitLevel('target')).g) * 255,
						((UnitCanAttack('player', 'target') and (UnitClassification('target') == 'worldboss' or UnitLevel('target') == -1)) and 0 or GetQuestDifficultyColor(UnitLevel('target')).b) * 255, UnitLevel('target') > 0 and UnitLevel('target') or '??', Check))
					TopPanel.LocationY.text:SetText(nil)
				end
				TargetAuraTracker_UpdateReminder()
			end
		end
		KF:RegisterEventList('UNIT_AURA', function(_, unit)
			if not unit == 'target' or CurrentTarget == 'NONE' or not (limiter + 0.5 < GetTime()) then
				return
			elseif (UnitCanAttack('player', 'target') and (CurrentTarget == 'NPC' or CurrentTarget == 'Ally')) or (not UnitCanAttack('player', 'target') and (CurrentTarget == 'Monster' or CurrentTarget == 'Enemy')) then
				CheckTargetType()
			end
			limiter = GetTime()
			TargetAuraTracker_UpdateReminder()
		end)
		KF:RegisterEventList('PLAYER_TARGET_CHANGED', CheckTargetType)
		
		
		--<< Redifine TopPanel Location Update Condition >>--
		KF.UpdateFrame.UpdateList.UpdateLocation['Condition'] = function() return (CurrentTarget == 'NONE' and (TopPanel.LocationName.text:GetText() == nil or select(1, GetUnitSpeed('player')) > 0)) and true or false end
		KF.UpdateFrame.UpdateList.TopPanelItemLevel = {
			['Condition'] = function() return not InCombatLockdown() and CurrentTarget == 'Ally' and TopPanel.LocationY.text:GetText() == nil and true or false end,
			['Delay'] = 1,
			['Action'] = function()
				Check = 0
				if UnitIsUnit('target', 'player') then
					Check = E:GetModule('Tooltip'):GetItemLvL('player') or 0
				else
					for _, Cache in pairs(E:GetModule('Tooltip').InspectCache) do
						if Cache.GUID == UnitGUID('target') then
							Check = Cache.ItemLevel or 0
						end
					end
				end
				if Check > 0 then
					TopPanel.LocationY.text:SetText(Check)
					return
				elseif CanInspect('target') and not E:GetModule('Tooltip'):IsInspectFrameOpen() and (KF.UpdateFrame.UpdateList.NotifyInspect and KF.UpdateFrame.UpdateList.NotifyInspect.Condition == false) then
					if not KF.Memory['Event']['INSPECT_READY'] or not KF.Memory['Event']['INSPECT_READY']['TargetAuraTracker_ItemLevel'] then
						KF:RegisterEventList('INSPECT_READY', function(self, GUID)
							self = E:GetModule('Tooltip')
							
							Check = nil
							for _, inspectCache in ipairs(self.InspectCache) do
								if inspectCache.GUID == GUID then
									inspectCache.ItemLevel = self:GetItemLvL('target')
									inspectCache.TalentSpec = self:GetTalentSpec('target')
									inspectCache.LastUpdate = floor(GetTime())
									Check = true
									break
								end
							end

							if not Check then
								self.InspectCache[#self.InspectCache + 1] = {
									['GUID'] = GUID,
									['ItemLevel'] = self:GetItemLvL('target'),
									['TalentSpec'] = self:GetTalentSpec('target'),
									['LastUpdate'] = floor(GetTime()),
								}
							end
							
							ClearInspectPlayer()
							KF.Memory['Event']['INSPECT_READY']['TargetAuraTracker_ItemLevel'] = nil
						end, 'TargetAuraTracker_ItemLevel')
					end
					NotifyInspect('target')
				end
			end,
		}
		
		
		--<< Create TargetAuraTracker Frame >>--
		CreateFrame('Frame', 'TargetAuraTracker', KF.UIParent)
		TargetAuraTracker:Size(290,20)
		TargetAuraTracker:Hide()
		TargetAuraTracker:Point('TOP', 0, -29)
		
		for i = 1, 8 do -- Create Icons
			TargetAuraTracker['Spell'..i] = CreateFrame('Frame', nil, TargetAuraTracker)
			TargetAuraTracker['Spell'..i]:SetTemplate('Default')
			TargetAuraTracker['Spell'..i]:Size(20)
			TargetAuraTracker['Spell'..i]:SetFrameLevel(8)
			TargetAuraTracker['Spell'..i].t = TargetAuraTracker['Spell'..i]:CreateTexture(nil, 'OVERLAY')
			TargetAuraTracker['Spell'..i].t:SetTexCoord(unpack(E.TexCoords))
			TargetAuraTracker['Spell'..i].t:SetInside()
			TargetAuraTracker['Spell'..i]:SetScript('OnLeave', function() GameTooltip:Hide() end)
			TargetAuraTracker['Spell'..i]:SetScript('OnEnter', function(self)
				GameTooltip:SetOwner(self, 'ANCHOR_BOTTOM', 0, -4)
				GameTooltip:ClearLines()
				GameTooltip:AddLine(KF:Color('Aura')..' : |cffffdc3c'..TargetAuraTracker['Spell'..i][(UnitCanAttack('player', 'target') and 'Enemy' or 'Ally')]..'|r', 1, 1, 1)
				if spellName[i] then
					GameTooltip:AddLine('|n '..KF:Color('-*')..' |cff6dd66d'..L['Applied']..'|r : ', 1, 1, 1)
					if userClass[i] == false then
						GameTooltip:AddLine('   '..spellName[i]..'|n',1,1,1)
					else
						GameTooltip:AddDoubleLine(userClass[i], spellName[i], 1, 1, 1, 1, 1, 1)
					end
				else
					GameTooltip:AddLine('|n '..KF:Color('-*')..' |cffb9062f'..L['Non-applied']..'|r', 1, 1, 1)
					Check = false
					for _, SpellTable in pairs((UnitCanAttack('player', 'target') and SynergyDebuffs[i] or SynergyBuffs[i + 5])) do
						if type(SpellTable) == 'table' then
							if Check == false then
								GameTooltip:AddLine('|n <|cffceff00'..L['EnableClass']..'|r >', 1, 1, 1)
								Check = true
							end
							GameTooltip:AddDoubleLine(SpellTable['Class'], select(1, GetSpellInfo(SpellTable['ID'])), 1, 1, 1, 1, 1, 1)
						end
					end
				end
				GameTooltip:Show()
			end)
		end

		-- Setting Icon Location : [7]   [5][1][2][3][4][6]   [8]
		TargetAuraTracker['Spell7']:Point('TOPRIGHT', TargetAuraTracker['Spell5'], 'TOPLEFT', -47, 0)
		TargetAuraTracker['Spell7']['Ally'] = L['Bloodlust Debuff']
		TargetAuraTracker['Spell7']['Enemy'] = L['Dangerous Utility']
		
		TargetAuraTracker['Spell5']:Point('TOPRIGHT', TargetAuraTracker['Spell1'], 'TOPLEFT', -4, 0)
		TargetAuraTracker['Spell5']['Ally'] = L['Elixirs']
		TargetAuraTracker['Spell5']['Enemy'] = L['Magic-Damage']
		TargetAuraTracker['Spell1']:Point('TOPRIGHT', TargetAuraTracker['Spell2'], 'TOPLEFT', -4, 0)
		TargetAuraTracker['Spell1']['Ally'] = CRIT_ABBR
		TargetAuraTracker['Spell1']['Enemy'] = L['Armor-Reducing']
		TargetAuraTracker['Spell2']:Point('TOPRIGHT', TargetAuraTracker, 'BOTTOM', -2, 16)
		TargetAuraTracker['Spell2']['Ally'] = L['Stats']
		TargetAuraTracker['Spell2']['Enemy'] = L['Physical Vulnerability']
		TargetAuraTracker['Spell3']:Point('TOPLEFT', TargetAuraTracker, 'BOTTOM', 2, 16)
		TargetAuraTracker['Spell3']['Ally'] = STAT_MASTERY
		TargetAuraTracker['Spell3']['Enemy'] = L['AP-Reducing']
		TargetAuraTracker['Spell4']:Point('TOPLEFT', TargetAuraTracker['Spell3'], 'TOPRIGHT', 4, 0)
		TargetAuraTracker['Spell4']['Ally'] = L['Health']
		TargetAuraTracker['Spell4']['Enemy'] = L['Increasing Casting']
		TargetAuraTracker['Spell6']:Point('TOPLEFT', TargetAuraTracker['Spell4'], 'TOPRIGHT', 4, 0)
		TargetAuraTracker['Spell6']['Ally'] = L['Foods']
		TargetAuraTracker['Spell6']['Enemy'] = L['Heal-Reducing']
		
		TargetAuraTracker['Spell8']:Point('TOPLEFT', TargetAuraTracker['Spell6'], 'TOPRIGHT', 47, 0)
		TargetAuraTracker['Spell8']['Ally'] = L['Resurrection Debuff']
		TargetAuraTracker['Spell8']['Enemy'] = L['Turtle Utility']

		
		-- Icon's Background
		TargetAuraTracker.Group1 = CreateFrame('Frame', nil, TargetAuraTracker)
		TargetAuraTracker.Group1:SetFrameLevel(7)
		TargetAuraTracker.Group1:SetTemplate('Default', true)

		TargetAuraTracker.Group2 = CreateFrame('Frame', nil, TargetAuraTracker['Spell7'])
		TargetAuraTracker.Group2:Point('TOPLEFT', TargetAuraTracker['Spell7'], 'TOPLEFT', -4, 4)
		TargetAuraTracker.Group2:Point('BOTTOMRIGHT', TargetAuraTracker['Spell7'], 'BOTTOMRIGHT', 4, 4)
		TargetAuraTracker.Group2:SetFrameLevel(7)
		TargetAuraTracker.Group2:SetTemplate('Default', true)

		TargetAuraTracker.Group3 = CreateFrame('Frame', nil, TargetAuraTracker['Spell8'])
		TargetAuraTracker.Group3:Point('TOPLEFT', TargetAuraTracker['Spell8'], 'TOPLEFT', -4, 4)
		TargetAuraTracker.Group3:Point('BOTTOMRIGHT', TargetAuraTracker['Spell8'], 'BOTTOMRIGHT', 4, 4)
		TargetAuraTracker.Group3:SetFrameLevel(7)
		TargetAuraTracker.Group3:SetTemplate('Default', true)
	end
end