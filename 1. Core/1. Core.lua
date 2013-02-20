--local E, L, V, P, G, _ = unpack(ElvUI)
local E = select(1, unpack(ElvUI))
local KF = E:GetModule('KnightFrame')
	
if KF.UIParent then
	-----------------------------------------------------------
	-- [ Knight : Check Player's Role						]--
	-----------------------------------------------------------
	KF.Memory['Table']['ClassRole'] = {
		['PALADIN'] = {
			[select(2, GetSpecializationInfoByID(65))] = {	--신성
				['ClassColor'] = '|cfff48cba',
				['Rule'] = 'Healer',
			},		
			[select(2, GetSpecializationInfoByID(66))] = {	--보호
				['ClassColor'] = '|cff198cee',
				['Rule'] = 'Tank',
			},
			[select(2, GetSpecializationInfoByID(70))] = {	--징벌
				['ClassColor'] = '|cffe60000',
				['Rule'] = 'Melee',
			},
		},
		['PRIEST'] = {
			[select(2, GetSpecializationInfoByID(256))] = {	--수양
				['ClassColor'] = '|cffffffff',
				['Rule'] = 'Healer',
			},
			[select(2, GetSpecializationInfoByID(257))] = {	--신성
				['ClassColor'] = '|cff6bdaff',
				['Rule'] = 'Healer',
			},
			[select(2, GetSpecializationInfoByID(258))] = {	--암흑
				['ClassColor'] = '|cff7e52c1',
				['Rule'] = 'Caster',
			},
		},
		['WARLOCK'] = {
			[select(2, GetSpecializationInfoByID(265))] = {	--고통
				['ClassColor'] = '|cff00ff10',
				['Rule'] = 'Caster',
			},
			[select(2, GetSpecializationInfoByID(266))] = {	--악마
				['ClassColor'] = '|cff9482c9',
				['Rule'] = 'Caster',
			},
			[select(2, GetSpecializationInfoByID(267))] = {	--파괴
				['ClassColor'] = '|cffba1706',
				['Rule'] = 'Caster',
			},
		},
		['WARRIOR'] = {
			[select(2, GetSpecializationInfoByID(71))] = {	--무기
				['ClassColor'] = '|cff9a9a9a',
				['Rule'] = 'Melee',
			},
			[select(2, GetSpecializationInfoByID(72))] = {	--분노
				['ClassColor'] = '|cffb50000',
				['Rule'] = 'Melee',
			},
			[select(2, GetSpecializationInfoByID(73))] = {	--방어
				['ClassColor'] = '|cff088fdc',
				['Rule'] = 'Tank',
			},
		},
		['HUNTER'] = {
			[select(2, GetSpecializationInfoByID(253))] = {	--야수
				['ClassColor'] = '|cffffdb00',
				['Rule'] = 'Melee',
			},
			[select(2, GetSpecializationInfoByID(254))] = {	--사격
				['ClassColor'] = '|cffea5455',
				['Rule'] = 'Melee',
			},
			[select(2, GetSpecializationInfoByID(255))] = {	--생존
				['ClassColor'] = '|cffbaf71d',
				['Rule'] = 'Melee',
			},
		},
		['SHAMAN'] = {
			[select(2, GetSpecializationInfoByID(262))] = {	--정기
				['ClassColor'] = '|cff2be5fa',
				['Rule'] = 'Caster',
			},
			[select(2, GetSpecializationInfoByID(263))] = {	--고양
				['ClassColor'] = '|cffe60000',
				['Rule'] = 'Melee',
			},
			[select(2, GetSpecializationInfoByID(264))] = {	--복원
				['ClassColor'] = '|cff00ff0c',
				['Rule'] = 'Healer',
			},
		},
		['ROGUE'] = {
			[select(2, GetSpecializationInfoByID(259))] = {	--암살
				['ClassColor'] = '|cff129800',
				['Rule'] = 'Melee',
			},
			[select(2, GetSpecializationInfoByID(260))] = {	--전투
				['ClassColor'] = '|cffbc0001',
				['Rule'] = 'Melee',
			},
			[select(2, GetSpecializationInfoByID(261))] = {	--잠행
				['ClassColor'] = '|cfff48cba',
				['Rule'] = 'Melee',
			},
		},
		['MAGE'] = {
			[select(2, GetSpecializationInfoByID(62))] = {	--비전
				['ClassColor'] = '|cffdcb0fb',
				['Rule'] = 'Caster',
			},
			[select(2, GetSpecializationInfoByID(63))] = {	--화염
				['ClassColor'] = '|cffff3615',
				['Rule'] = 'Caster',
			},
			[select(2, GetSpecializationInfoByID(64))] = {	--냉기
				['ClassColor'] = '|cff1784d1',
				['Rule'] = 'Caster',
			},		
		},
		['DEATHKNIGHT'] = {
			[select(2, GetSpecializationInfoByID(250))] = {	--혈기
				['ClassColor'] = '|cffbc0001',
				['Rule'] = 'Tank',
			},
			[select(2, GetSpecializationInfoByID(251))] = {	--냉기
				['ClassColor'] = '|cff1784d1',
				['Rule'] = 'Melee',
			},
			[select(2, GetSpecializationInfoByID(252))] = {	--부정
				['ClassColor'] = '|cff00ff10',
				['Rule'] = 'Melee',
			},
		},
		['DRUID'] = {
			[select(2, GetSpecializationInfoByID(102))] = {	--조화
				['ClassColor'] = '|cffff7d0a',
				['Rule'] = 'Caster',
			},
			[select(2, GetSpecializationInfoByID(103))] = {	--야성
				['ClassColor'] = '|cffffdb00',
				['Rule'] = 'Melee',
			},
			[select(2, GetSpecializationInfoByID(104))] = {	--수호
				['ClassColor'] = '|cff088fdc',
				['Rule'] = 'Tank',
			},
			[select(2, GetSpecializationInfoByID(105))] = {	--회복
				['ClassColor'] = '|cff64df62',
				['Rule'] = 'Healer',
			},
		},
		['MONK'] = {
			[select(2, GetSpecializationInfoByID(268))] = {	--양조
				['ClassColor'] = '|cffbcae6d',
				['Rule'] = 'Tank',
			},
			[select(2, GetSpecializationInfoByID(269))] = {	--풍운
				['ClassColor'] = '|cffb2c6de',
				['Rule'] = 'Melee',
			},
			[select(2, GetSpecializationInfoByID(270))] = {	--운무
				['ClassColor'] = '|cffb6f1b7',
				['Rule'] = 'Healer',
			},	
		},
	}
	
	
	local function CheckRole()
		if InCombatLockdown() then return end
		
		KF.Role = nil
		
		local talentTree = GetSpecialization()
		
		if talentTree then
			talentTree = select(2, GetSpecializationInfo(talentTree))
			if talentTree then
				KF.Role = KF.Memory['Table']['ClassRole'][E.myclass][talentTree]['Rule']
			end
		end
		
		local Resilience = GetCombatRatingBonus(COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN)
		if Resilience > GetDodgeChance() and Resilence > GetParryChance() then
			Resilience = true
		else
			Resilience = nil
		end
		
		if KF.Role == 'Tank' and Resilience == true then KF.Role = 'Melee' end
		
		if KF.Role and KF.db.DatatextSetting.Enable ~= false and KF_TalentDatatext then
			KF_TalentDatatext.text:Point('CENTER', KF_TalentDatatext, -15, 0)
			KF_TalentDatatext.text:SetText(KF.Role == 'Tank' and '|TInterface\\AddOns\\ElvUI\\media\\textures\\tank.tga:14:14:0:1|t' or KF.Role == 'Healer' and '|TInterface\\AddOns\\ElvUI\\media\\textures\\healer.tga:14:14:0:0|t' or '|TInterface\\AddOns\\ElvUI\\media\\textures\\dps.tga:14:14:0:-1|t')
		elseif not KF.Role then
			local playerint = select(2, UnitStat('player', 4))
			local playeragi	= select(2, UnitStat('player', 2))
			local base, posBuff, negBuff = UnitAttackPower('player')
			
			if (base + posBuff + negBuff > playerint) or (playeragi > playerint) then
				KF.Role = 'Melee'
			else
				KF.Role = 'Caster'
			end
		end
		
		if KF.Role and KF.db.DatatextSetting.Enable ~= false then
			for i = 1, 3 do
				if _G['KF_Datatext'..i] then
					_G['KF_Datatext'..i].DataText:UnregisterAllEvents()
					_G['KF_Datatext'..i].DataText:SetScript('OnUpdate', nil)
					_G['KF_Datatext'..i].DataText:SetScript('OnEnter', nil)
					_G['KF_Datatext'..i].DataText:SetScript('OnLEave', nil)
					_G['KF_Datatext'..i].DataText:SetScript('OnClick', nil)
					E:GetModule('DataTexts'):AssignPanelToDataText(_G['KF_Datatext'..i].DataText, E:GetModule('DataTexts').RegisteredDataTexts[KF.db.DatatextSetting[KF.Role]['Datatext'..i]])
				end
			end
		end
	end
	KF:RegisterEventList('PLAYER_ENTERING_WORLD', CheckRole)
	KF:RegisterEventList('ACTIVE_TALENT_GROUP_CHANGED', CheckRole)
	KF:RegisterEventList('PLAYER_TALENT_UPDATE', CheckRole)
	KF:RegisterEventList('CHARACTER_POINTS_CHANGED', CheckRole)
	KF:RegisterEventList('UNIT_INVENTORY_CHANGED', CheckRole)


	-----------------------------------------------------------
	-- [ Knight : Check Current Group Mode					]--
	-----------------------------------------------------------
	local function CheckGroupMode()
		if not IsInGroup() and not IsInRaid() then
			KF.CurrentGroupMode = 'NoGroup'
			
			if KF.UpdateFrame.UpdateList.CheckArstraea then
				KF.UpdateFrame.UpdateList.CheckArstraea.Condition = false
				KF.ArstraeaFind = false
			end
		else
			if IsInRaid() then
				KF.CurrentGroupMode = 'raid'
			else
				KF.CurrentGroupMode = 'party'
			end
			
			if KF.UpdateFrame.UpdateList.CheckArstraea then
				KF.UpdateFrame.UpdateList.CheckArstraea.Condition = true
			end
		end
	end
	KF:RegisterEventList('GROUP_ROSTER_UPDATE', CheckGroupMode)
	
	
	-----------------------------------------------------------
	-- [ Knight : Check Combat End							]--
	-----------------------------------------------------------
	KF.BossBattleStart = CreateFrame('Frame', nil, E.UIParent)
	KF.BossBattleStart:Hide()
	
	local function CheckCombatEnd()
		local IsCombatEnd = true
		
		if KF.CurrentGroupMode == 'NoGroup' then
			if UnitAffectingCombat('player') then IsCombatEnd = false end
		else
			if not UnitIsDeadOrGhost('player') and not UnitAffectingCombat('player') then IsCombatEnd = true
			elseif UnitAffectingCombat('player') then IsCombatEnd = false
			else
				if KF.CurrentGroupMode == 'party' then
					for i = 1, 4 do
						if UnitAffectingCombat('party'..i) then IsCombatEnd = false break end
					end
				elseif KF.CurrentGroupMode == 'raid' then
					for i = 1, MAX_RAID_MEMBERS do
						if UnitExists('raid'..i) then
							if UnitAffectingCombat('raid'..i) then IsCombatEnd = false break end
						end
					end
				end
			end
		end
		return IsCombatEnd
	end
	
	local BossIsExists = false
	KF.UpdateFrame.UpdateList.CheckCombatEnd = {
		['Condition'] = true,
		['Delay'] = 0.5,
		['Action'] = function()
			if not KF.BossBattleStart:IsShown() then
				if UnitExists('boss1') or UnitExists('boss2') or UnitExists('boss3') or UnitExists('boss4') then
					for i = 1, 4 do
						if UnitExists('boss'..i) then
							BossIsExists = true
							KF.BossBattleStart:Show()
							break
						end
					end
				end
			else
				if BossIsExists == true and not (UnitExists('boss1') or UnitExists('boss2') or UnitExists('boss3') or UnitExists('boss4')) then
					BossIsExists = false
				elseif BossIsExists == false and (UnitExists('boss1') or UnitExists('boss2') or UnitExists('boss3') or UnitExists('boss4')) then
					BossIsExists = true
				end
			end
			
			if CheckCombatEnd() == true and BossIsExists == false then
				KF.UpdateFrame.UpdateList.CheckCombatEnd.Condition = false
				KF.BossBattleStart:Hide()
				return
			end
		end,
	}		
	KF:RegisterEventList('PLAYER_REGEN_DISABLED', function() KF.UpdateFrame.UpdateList.CheckCombatEnd.Condition = true end)
end