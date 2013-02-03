--local E, L, V, P, G, _  = unpack(ElvUI)
local E, L, _, _, _, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

if KF.UIParent then
	-----------------------------------------------------------
	-- [ Knight : Spell List								]--
	-----------------------------------------------------------
	if KF.db.Extra_Functions.BuffTracker.Enable ~= false or KF.db.Extra_Functions.TargetAuraTracker ~= false then
		KF.Memory['Table']['SysnergyBuffs'] = {
			[1] = { -- Attack Power 전투력 증가
				[19506] = L['Hunter'], -- Trueshot Aura 정조준 오라
				[6673] = L['Warrior'], -- Battle Shout 전투의 외침
				[57330] = L['Death Knight'], -- Horn of Winter 겨울의 뿔피리
			},
			[2] = { -- Attack Speed 가속 증가
				[113742] = L['Rogue'], -- Swiftblade's Cunning 스위프트블레이드의 간교함
				[128432] = L['Hyenas']..'('..L['Hunter']..'|r)', -- Cackling Howl 불쾌한 울음소리
				[128433] = L['Serpents']..'('..L['Hunter']..'|r)', -- Serpent's Swiftness 독사의 신속함
				[55610] = L['Death Knight'], -- Improved Icy Talons 부정의 오라
				[30809] = L['Shaman']..'('..L['Enhancement']..')', -- Unleashed Rage 해방된 분노
			},
			[3] = { -- Spell Power 주문력 증가
				[77747] = L['Shaman'], -- Burning Wrath 불타는 분노
				[126309] = L['Water Striders']..'('..L['Hunter']..'|r)', -- Still Water 잔잔한 물
				[109773] = L['Warlock'], -- Dark Intent 검은 의도
				[61316] = L['Mage'], -- Dalaran Brilliance 달라란의 총명함
				[1459] = L['Mage'], -- Arcane Brilliance 신비한 총명함
			},
			[4] = { -- Spell Haste 주문가속 증가
				[24907] = L['Druid']..'('..L['Balance']..')', -- Moonkin Aura 달빛야수 오라
				[51470] = L['Shaman']..'('..L['Elemental']..')', -- Elemental Oath 정령의 서약
				[49868] = L['Priest']..'('..L['Shadow']..')', -- Mind Quickening 사고 촉진
			},
			[5] = { -- Beacon Of Light 빛의 봉화
				[53563] = L['Paladin']..'('..L['Holy']..')', -- Beacon of Light 빛의 봉화
			},
			[6] = { -- Critical 크리 5% 증가
				[116781] = L['Monk'], -- Legacy of the White Tiger 백호의 유산
				[126373] = L['Quilen']..'('..L['Hunter']..'|r)', -- Feearless Roar 용맹한 울음소리
				[90309] = L['Devilsaurs']..'('..L['Hunter']..'|r)', -- Terrifying Roar 공포의 포효
				[61316] = L['Mage'], -- Dalaran Brilliance 달라란의 총명함
				[1459] = L['Mage'], -- Arcane Brilliance 신비한 총명함
				[24604] = L['Wolves']..'('..L['Hunter']..'|r)', -- Furious Howl 사나운 울음소리
				[24932] = L['Druid']..'('..L['Feral']..','..L['Guardian']..')', -- Leader of The Pact 무리의 우두머리
				[126309] = L['Water Striders']..'('..L['Hunter']..'|r)', -- Still Water 잔잔한 물
			},
			[7] = { -- All Stats 능력치 증가
				[90363] = L['Shale Spiders']..'('..L['Hunter']..'|r)', -- Embrace of the Shale Spider 혈암거미의 은총
				[117667] = L['Monk'], --Legacy of The Emperor 황제의 유산
				[20217] = L['Paladin'], -- Blessing Of Kings 왕의 축복
				[1126] = L['Druid'], -- Mark of The Wild 야생의 징표
			},
			[8] = { -- Mastery 특화도 증가
				[93435] = L['Cats']..'('..L['Hunter']..'|r)', --Roar of Courage 용기의 포효
				[128997] = L['Spirit Beasts']..'('..L['Hunter']..'|r)', --Spirit Beast Blessing 야수 정령의 축복
				[19740] = L['Paladin'], -- Blessing of Might 힘의 축복
				[116956] = L['Shaman'], --Grace of Air 바람의 은총
			},
			[9] = {	-- Stamina 체력 증가
				[90364] = L['Silithids']..'('..L['Hunter']..'|r)', -- Qiraji Fortitude 퀴라지의 인내
				[469] = L['Warrior'], -- Commanding Shout 지휘의 외침
				[21562] = L['Priest'], -- Power Word: Fortitude 신의 권능 : 인내
				[6307] = L['Imp']..'('..L['Warlock']..'|r)', -- Imp. Blood Pact 피의 서약
			},
		}
	end
	
	if KF.db.Extra_Functions.TargetAuraTracker ~= false then
		KF.Memory['Table']['SysnergyDebuffs'] = {
			['IncreaseSpellDamage'] = { -- 마법피해 5% 증가
				[24844] = L['Wind Serpents']..'('..L['Hunter']..'|r)', -- 번개 숨결
				[1490] = L['Warlock'], -- 원소의 저주
				[34889] = L['Dragonhawks']..'('..L['Hunter']..'|r)', -- 불의 숨결
				[58410] = L['Rogue'], -- 독의 대가
			},
			['DecreaseArmor'] = { -- 방어도 감소
				['Effect'] = 113746,
				[770] = L['Druid'], -- 요정의 불꽃
				[50285] = L['Tallstriders']..'('..L['Hunter']..'|r)', -- 먼지 구름
				[8647] = L['Rogue'], -- 약점노출
				[20243] = L['Warrior']..'('..L['WProtection']..')', -- 압도
				[7386] = L['Warrior'], -- 방어구 가르기
				[50498] = L['Raptors']..'('..L['Hunter']..'|r)', -- 갑옷 찢기
			},
			['IncreaseMeleeDamage'] = { -- 물리피해 증가
				['Effect'] = 81326,
				[50518] = L['Ravagers']..'('..L['Hunter']..'|r)', -- 약탈
				[55749] = L['Worms']..'('..L['Hunter']..'|r)', -- 산성 숨결
				[81328] = L['Death Knight']..'('..L['Frost']..')', -- 부러진 뼈
				[57386] = L['Rhinos']..'('..L['Hunter']..'|r)', -- 쇄도
				[51160] = L['Death Knight']..'('..L['Unholy']..')', -- 칠흑의 역병인도자
				[86346] = L['Warrior']..'('..L['Arms']..','..L['Fury']..')', -- 거인의 강타
				[35290] = L['Boars']..'('..L['Hunter']..'|r)', -- 들이받기
				[111529] = L['Paladin']..'('..L['Retribution']..')', -- 대담한 자의 심판
			},
			['DecreaseMeleePower'] = { -- 물리 공격력 감소
				['Effect'] = 115798,
				[106832] = L['Druid']..'('..L['Feral']..','..L['Guardian']..')', -- 난타
				[53595] = L['Paladin']..'('..L['PProtection']..','..L['Retribution']..')', -- 정의의 망치
				[6343] = L['Warrior'], -- 천둥 벼락
				[81132] = L['Death Knight']..'('..L['Blood']..')', -- 핏빛 열병
				[8042] = L['Shaman'], -- 대지 충격
				[50256] = L['Bears']..'('..L['Hunter']..'|r)', -- 곰
				[109466] = L['Warlock'], -- 무력화 저주
				[121253] = L['Monk']..'('..L['Brewmaster']..')', -- 맥주통 휘두르기
			},
			['IncreaseCastTime'] = { -- 주문 시전속도 감소
				[58604] = L['Core Hounds']..'('..L['Hunter']..'|r)', -- 심장부사냥개
				[90314] = L['Foxes']..'('..L['Hunter']..'|r)', -- 여우
				[50274] = L['Sporebats']..'('..L['Hunter']..'|r)', -- 포자날개
				[109466] = L['Warlock'], -- 무력화 저주
				[5761] = L['Rogue'], -- 정신 마비 독
				[126402] = L['Goats']..'('..L['Hunter']..'|r)', -- 밟아 뭉개기
			},
			['DecreaseHealing'] = { -- 치유량 감소
				['Effect'] = 115804,
				[8679] = L['Rogue'], -- 상처 감염 독
				[82654] = L['Hunter'], -- 과부거미의 독
				[54680] = L['Devilsaurs']..'('..L['Hunter']..'|r)', -- 데빌사우루스
				[100130] = L['Warrior']..'('..L['Fury']..')', -- 난폭한 일격
				[12294] = L['Warrior']..'('..L['Arms']..')', -- 필사의 일격
			},
		}
	end
end