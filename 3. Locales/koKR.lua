--local E, L, V, P, G, _  = unpack(ElvUI)
local E, L, _, _, _, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

--[[ ColorTable
	AquaBlue : 2eb7e4
	SkyBlue : 93daff
	Red : ff0000
	Pink : ff5675
	Purple : f88ef4
	Legend Color : ff9614
]]


do	--General
	L['KF'] = KF:Color('Knight Frame')
	BINDING_HEADER_KnightFrame = L['KF']
	BINDING_NAME_InspectMouseover = '|cffffffff - |cffffffff마우스오버 살펴보기'
	
	L['raid'] = '레이드 파티'
	L['party'] = '파티'
	L['battleground'] = '전장'
	L['GAME MENU'] = '게임 메뉴'
end


do	--Frame Name
	L['FrameTag'] = '|cffffffff[|r|cff2eb7e4KF|r|cffffffff]|r : '
	L['MiddleChatPanel'] = '중앙 채팅창 패널'
	L['MeterAddonPanel'] = '미터기 애드온 패널'
	L['ActionBarPanel'] = '액션바 패널'
	L['KnightInspectFrame'] = '살펴보기 창'
end


do	--Inspect
	L[" Server's "] = ' 서버의 '
	
	L['ShowModelFrame'] = '캐릭터'
	L['ShowSpecializationFrame'] = '특성'
	L['ShowPvPInfoFrame'] = 'PvP'
	
	L['Empty'] = '비어있음'
	L['NeedLevel'] = '레벨 필요'
	
	L['This is not a inspect bug.|nI think this user is not wearing any gears.'] = '살펴보기 오류가 아닌,|n상대는 |cffff5675아무것도 걸치지 않은 변태|r입니다.'
end

do	--Print Message
	L['KnightFrame Option Pack is not exist.'] = '|cff1784d1나이트프레임 옵션 팩|r 애드온이 존재하지 않습니다.'
	
	L['Lock ExpRep Tooltip.'] = '|cff2eb7e4경험치&평판|r 상세 정보패널을 |cffceff00고정|r합니다.'
	L['Unlock ExpRep Tooltip.'] = '|cff2eb7e4경험치&평판|r 상세 정보패널의 고정을 |cffff5353해제|r합니다.'
	
	L['Cannot Inspect because target unit is out of range to inspect.'] = '대상과의 거리가 멀어 살펴보기를 실행할 수 없습니다.'
	L[" Inspect. Sometimes this work will take few second by waiting server's response."] = ' 유저를 살펴봅니다. 서버의 응답을 기다리느라 시간이 조금 걸릴 수도 있습니다.'
	L['Mouseover Inspect needs to freeze mouse moving until inspect is over.'] = '|cff2eb7e4마우스오버 살펴보기|r는 살펴보기가 끝날 때 까지 |cffff5675마우스를 유저에게서 떼면 안됩니다|r.'
	L['Mouseover Inspect is canceled because cursor left user to inspect.'] = '마우스가 살펴보던 마우스오버 대상에게서 이탈하여 |cffff5675살펴보기가 취소되었습니다|r.'
end


do	--Datatexts
	L['Friends'] = '친구'
	CRIT_ABBR = '크리'
	L['Hit'] = '적중'
	MANA_REGEN = '마젠'
	L['SpellHaste'] = '주문가속'
	L['Stats'] = '모든 능력치'
end


do	--Talent
	L['Tank'] = '탱커'
	L['Caster'] = '캐스터'
	L['Melee'] = '밀리'
	
	L['NoTalent'] = '특성없음'
	L['Warrior'] = KF:ClassColor('WARRIOR', '전사')
		L['Arms'] = '무기'
		L['Fury'] = '분노'
		L['WProtection'] = '방어'
	L['Hunter'] = KF:ClassColor('HUNTER', '사냥꾼')
		L['Beast'] = '야수'
		L['Marksmanship'] = '사격'
		L['Survival'] = '생존'
	L['Shaman'] = KF:ClassColor('SHAMAN', '주술사')
		L['Elemental'] = '정기'
		L['Enhancement'] = '고양'
		L['SRestoration'] = '복원'
	L['Monk'] = KF:ClassColor('MONK', '수도사')
		L['Brewmaster'] = '양조'
		L['Mistweaver'] = '운무'
		L['Windwalker'] = '풍운'
	L['Rogue'] = KF:ClassColor('ROGUE', '도적')
		L['Assassination'] = '암살'
		L['Combat'] = '전투'
		L['Subtlety'] = '잠행'
	L['Death Knight'] = KF:ClassColor('DEATHKNIGHT', '죽음의 기사')
		L['Blood'] = '혈기'
		L['Frost'] = '냉기'
		L['Unholy'] = '부정'
	L['Mage'] = KF:ClassColor('MAGE', '마법사')
		L['Arcane'] = '비전'
		L['Fire'] = '화염'
		L['Frost'] = '냉기'
	L['Druid'] = KF:ClassColor('DRUID', '드루이드')
		L['Balance'] = '조화'
		L['Feral'] = '야성'
		L['Guardian'] = '수호'
		L['DRestoration'] = '회복'
	L['Paladin'] = KF:ClassColor('PALADIN', '성기사')
		L['Holy'] = '신성'
		L['PProtection'] = '보호'
		L['Retribution'] = '징벌'
	L['Priest'] = KF:ClassColor('PRIEST', '사제')
		L['Discipline'] = '수양'
		L['Shadow'] = '암흑'
	L['Warlock'] = KF:ClassColor('WARLOCK', '흑마법사')
		L['Affliction'] = '고통'
		L['Demonology'] = '악마'
		L['Destruction'] = '파괴'
end


do	--Extra Function

	--<< Tracker >>--
	L['Applied'] = '적용중'
	L['Non-applied'] = '비적용중'
	L['EnableClass'] = '가능 클래스'
	
	L['Elixirs'] = '영약 도핑'
	L['Foods'] = '음식 도핑'
	L['Bloodlust Debuff'] = '블러드 디버프'
	L['Resurrection Debuff'] = '부활 디버프'
	L['Magic-Damage'] = '마법피해 증가'
	L['Armor-Reducing'] = '방어도 감소'
	L['Physical Vulnerability'] = '물리피해 증가'
	L['AP-Reducing'] = '물리공격력 감소'
	L['Increasing Casting'] = '시전시간 증가'
	L['Heal-Reducing'] = '받는치유량 감소'
	L['Dangerous Utility'] = '강화스킬'
	L['Turtle Utility'] = '생존기'
	
	L['Wolves'] = '늑대'
	L['Cats'] = '살쾡이'
	L['Hyenas'] = '하이에나'
	L['Serpents'] = '뱀'
	L['Quilen'] = '기렌|cff1784d1(특수)|r'
	L['Silithids'] = '실리시드|cff1784d1(특수)|r'
	L['Water Striders'] = '소금쟁이|cff1784d1(특수)|r'
	L['Spirit Beasts'] = '야수정령|cff1784d1(특수)|r'
	L['Shale Spiders'] = '혈암거미|cff1784d1(특수)|r'
	L['Devilsaurs'] = '데빌사우루스|cff1784d1(특수)|r'
	L['Imp'] = '임프'
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
	
	
	--<< ItemLevel >>--
	L['Average'] = '평균'
	
	
	
end

