local E, L, V, P, G, _  = unpack(ElvUI);
local KF = E:GetModule('KnightFrame')
local KFRC = E:GetModule('KF_RaidCooldown')

-----------------------------------------------------------
-- [ Knight : RaidCooldown								]--
-----------------------------------------------------------
if not (E.db.KnightFrame.Install_Complete == nil or E.db.KnightFrame.Install_Complete == 'NotInstalled') and E.db.KnightFrame.Enable ~= false and E.db.KnightFrame.RaidCooldown.Enable ~= false then
	local filter = COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE
	local TANKER_ICON = "|TInterface\\AddOns\\ElvUI\\media\\textures\\tank.tga:14:14:0:-1|t"
	local HEALER_ICON = "|TInterface\\AddOns\\ElvUI\\media\\textures\\healer.tga:14:14:0:-1|t"
	local DEALER_ICON = "|TInterface\\AddOns\\ElvUI\\media\\textures\\dps.tga:14:14:0:-1|t"
	local GroupNumber, MemberNumNow, ShowRaidIcon = 0, 0, false
	local CoolDownBarTable, RaidIconTable = {}, {}
	local InspectInfoTable = {
		[E.myname] = {
			['Class'] = E.myclass,
			['Glyph'] = {},
			['Talent'] = {},
			['Spell'] = {},
		},
	}
	
	--시간표시 포맷 지정 (완료)
	local TimeFormat = function(time)
		if time > 60 then
			return string.format("%d:%.2d", time/60, time%60)
		elseif time < 10 then
			return string.format("|cffb90624%.1f", time)
		else
			return string.format("%d", time)
		end
	end
	
	local function GetRuleIcon(userName)
		local RuleIcon = ""
		local userSpec, userClass
		if InspectInfoTable[userName] then
			if InspectInfoTable[userName]['Specialization'] then
				userSpec = InspectInfoTable[userName]['Specialization']
				userClass = InspectInfoTable[userName]['Class']
			end
		end
		if (not userSpec and not userClass) and CoolDownBarTable[userName] then
			if CoolDownBarTable[userName]['Specialization'] then
				userSpec = CoolDownBarTable[userName]['Specialization']
				userClass = CoolDownBarTable[userName]['Class']
			end
		end
		if userSpec and userClass then
			local rule = KF.TalentTable[userClass][userSpec]['R']
			if rule == L["Tanker"] then
				RuleIcon = TANKER_ICON
			elseif rule == L["Healer"] then
				RuleIcon = HEALER_ICON
			elseif rule == L["Caster"] or rule == L["Melee"] then
				RuleIcon = DEALER_ICON
			elseif rule == L["Caster"]..'or'..L["Tanker"] then
				RuleIcon = TANKER_ICON..DEALER_ICON
			end
		end
		return RuleIcon
	end
	
	local function CreateUserNameFrame(userName)
		local RCP = E.db.KnightFrame.RaidCooldown.Appearance
		local nameFrame = CoolDownBarTable[userName]['Name']

		if not nameFrame then
			nameFrame = CreateFrame('Frame', nil, KF.UIParent)
			nameFrame:SetFrameStrata('MEDIUM')
			nameFrame:SetFrameLevel(9)
			nameFrame:Size(RCP.AreaWidth, RCP.barHeight)
			
			nameFrame.f = CreateFrame('Frame', nil, nameFrame)
			nameFrame.f.text = nameFrame.f:CreateFontString(nil, 'OVERLAY')
			nameFrame.f.arrow = nameFrame.f:CreateFontString(nil, 'OVERLAY')
			
			nameFrame.f:SetFrameStrata('MEDIUM')
			nameFrame.f:SetFrameLevel(11)
			nameFrame.f.text:FontTemplate(nil, RCP.userNameFontsize, 'OUTLINE')
			nameFrame.f.arrow:FontTemplate(nil, RCP.userNameFontsize, 'OUTLINE')
			
			CoolDownBarTable[userName]['Name'] = nameFrame
			CoolDownBarTable[userName]['Name']['Text'] = nameFrame.f.text
			CoolDownBarTable[userName]['Name']['Arrow'] = nameFrame.f.arrow
		end		

		local RuleIcon = ""
		if CoolDownBarTable[userName] then
			if CoolDownBarTable[userName]['Specialization'] then
				RuleIcon = GetRuleIcon(userName)
			else
				nameFrame:SetScript('OnUpdate', function()
					if InspectInfoTable[userName] then
						if InspectInfoTable[userName]['Specialization'] then
							RuleIcon = GetRuleIcon(userName)
							nameFrame.f.text:SetText(KF:ClassColor(CoolDownBarTable[userName]['Class'], userName)..' '..RuleIcon)
							nameFrame:SetScript('OnUpdate', nil)
						end
					end
				end)
			end
		else
			nameFrame:SetScript('OnUpdate', function()
				if InspectInfoTable[userName] then
					if InspectInfoTable[userName]['Specialization'] then
						RuleIcon = GetRuleIcon(userName, true)
						nameFrame.f.text:SetText(KF:ClassColor(CoolDownBarTable[userName]['Class'], userName)..' '..RuleIcon)
						nameFrame:SetScript('OnUpdate', nil)
					end
				end
			end)
		end
		nameFrame.f.text:SetFont(select(1,nameFrame.Text:GetFont()), RCP.userNameFontsize, 'OUTLINE')
		nameFrame.f.text:Point('LEFT', nameFrame, RCP.userNameFontsize*2 + 4, 0)
		nameFrame.f.text:SetText(KF:ClassColor(CoolDownBarTable[userName]['Class'], userName)..' '..RuleIcon)
		
		nameFrame.f.arrow:SetFont(select(1,nameFrame.Text:GetFont()), RCP.userNameFontsize, 'OUTLINE')
		nameFrame.f.arrow:Point('LEFT', nameFrame, RCP.userNameFontsize, 0)
		nameFrame.f.arrow:SetText('|cffceff00▼|r')
		return CoolDownBarTable[userName]['Name']
	end
	
	--쿨다운 바 재정렬
	function KFRC:RearrangeBar()
		local RCP = E.db.KnightFrame.RaidCooldown.Appearance
		local SettingBar, barNum, BarExists, NameSetting = 0, 0, false, false
		local spacing = (RCP.barDirection == 1 and RCP.RaidIconDirection == 3 and ShowRaidIcon == true) and (RCP.RaidIconSize + 4) or (RCP.barDirection == 2 and RCP.RaidIconDirection == 4 and ShowRaidIcon == true) and (RCP.RaidIconSize + 3) or 0
		local barspace = E.PixelMode and 1 or 5
		local SumBarHeight = (RCP.barDirection == 2 and 1 or barspace) + spacing
		local areaHeight = RCP.AreaHeight
		local CurrentWheelLine = KFRC_Area.CurrentWheelLine
		KFRC_Area.RemainBar = 0
		KFRC_Area.BeforeRemain = 0
		KFRC_Area.AfterRemain = 0
		KFRC_Holder:Width(RCP.AreaWidth)
		KFRC_MainFrame.beforeArrow:Hide()
		KFRC_MainFrame.afterArrow:Hide()
		
		for user in pairs(CoolDownBarTable) do
			BarExists = false
			NameSetting = false
			if not CoolDownBarTable[user]['Class'] then CoolDownBarTable[user]['Class'] = select(2, UnitClass(user)) end
			
			local nameFrame = CreateUserNameFrame(user)
			nameFrame:ClearAllPoints()
			nameFrame:Hide()
			
			for spell in pairs(CoolDownBarTable[user]['List']) do
				if BarExists == false then BarExists = true end
				local bar = CoolDownBarTable[user]['List'][spell]
				bar:SetAlpha(0)
				bar.isDisplayed = nil
				if E.db.KnightFrame.RaidCooldown[CoolDownBarTable[user]['Class']][tostring(spell)] ~= false then
					if CurrentWheelLine > 0 then
						CurrentWheelLine = CurrentWheelLine - 1
						barNum = barNum + 1
						KFRC_Area.RemainBar = KFRC_Area.RemainBar + 1
						KFRC_Area.BeforeRemain = KFRC_Area.BeforeRemain + 1
					else
						if SumBarHeight + RCP.barHeight + barspace <= areaHeight then
							nameFrame:Show()
							if RCP.barDirection == 2 and NameSetting == false then
								nameFrame:Point('TOPLEFT', KFRC_MainFrame, 'BOTTOMLEFT', 0, -3 -((RCP.barHeight + barspace)*SettingBar + spacing))
								NameSetting = true
								barNum = barNum + 1
								SettingBar = SettingBar + 1
								SumBarHeight = SumBarHeight + RCP.barHeight + barspace
							end
							if RCP.barDirection == 1 then
								nameFrame:Point('BOTTOMLEFT', KFRC_MainFrame, 'TOPLEFT', 0, 6 + ((RCP.barHeight + barspace)*SettingBar + spacing))
								if NameSetting == false then
									NameSetting = true
									barNum = barNum + 1
									SumBarHeight = SumBarHeight + RCP.barHeight + barspace
								end 
							end
						else
							if NameSetting == false then
								NameSetting = true
								barNum = barNum + 1
								KFRC_Area.RemainBar = KFRC_Area.RemainBar + 1
								KFRC_Area.AfterRemain = KFRC_Area.AfterRemain + 1
							end
						end
						
						if SumBarHeight + RCP.barHeight + barspace <= areaHeight then
							BarExists = "Show"
							bar:SetAlpha(1)
							bar.isDisplayed = true
							bar:Size(RCP.AreaWidth - (RCP.barHeight + barspace + 3), RCP.barHeight)
							bar.spellIcon:Size(RCP.barHeight + (E.PixelMode and 2 or 4))
							bar.spellName:SetFont(select(1,bar.spellName:GetFont()), RCP.barHeight - 4, 'OUTLINE')
							bar.spellName:Size(RCP.AreaWidth - RCP.barHeight*4, RCP.barHeight - 4)
							bar.spellCooldown:SetFont(select(1,bar.spellCooldown:GetFont()), RCP.barHeight - 4, 'OUTLINE')
							bar:ClearAllPoints()
							if RCP.barDirection == 2 then
								bar:Point('TOPLEFT', KFRC_MainFrame, 'BOTTOMLEFT', RCP.barHeight + barspace + 2, -3 -((RCP.barHeight + barspace)*SettingBar + spacing))
							else
								bar:Point('BOTTOMLEFT', KFRC_MainFrame, 'TOPLEFT', RCP.barHeight + barspace + 2, 6 + ((RCP.barHeight + barspace)*SettingBar + spacing))
								nameFrame:Point('BOTTOMLEFT', KFRC_MainFrame, 'TOPLEFT', 0, 6 + ((RCP.barHeight + barspace)*(SettingBar+1) + spacing))
							end
							SettingBar = SettingBar + 1
							SumBarHeight = SumBarHeight + RCP.barHeight + barspace
						else
							if BarExists == true and RCP.barDirection == 1 then nameFrame.Arrow:SetText('|cffceff00▲|r') end
							KFRC_Area.RemainBar = KFRC_Area.RemainBar + 1
							KFRC_Area.AfterRemain = KFRC_Area.AfterRemain + 1
						end
						barNum = barNum + 1
					end
				end
			end
			if BarExists == "Show" and RCP.barDirection  == 1 then SettingBar = SettingBar + 1 end
			if BarExists == false then CoolDownBarTable[user] = nil	end
		end
		KFRC_Area.BarTotal = barNum
		if KFRC_Area.RemainBar == 0 then KFRC_Area.CurrentWheelLine = 0 end
		if SumBarHeight + (RCP.barHeight + barspace)*2 <= areaHeight and KFRC_Area.BeforeRemain > 0 then KFRC_Area.CurrentWheelLine = KFRC_Area.CurrentWheelLine - 1 KFRC:RearrangeBar() end
	end
	
	--쿨다운 종료시 알림 (완료)
	local function ReportCooldownEnd(userName, spellID)
		local ChatTable = {
			{ "SELF", "self"},
			{ "SAY", "present"},
			{ "PARTY", "present"},
			{ "RAID", "present"},								
			{ "GUILD", "present"},
			{ "OFFICER", "present"},
		}
		local List = {GetChannelList()}
		for i = 1, #List/2 do
			local a = {}
			a[1] = List[i*2-1]
			a[2] = "channel"
			table.insert(ChatTable, a)
		end
		local cm = E.db.KnightFrame.RaidCooldown.General.CooldownEndAnnounceChannel
		if ChatTable[cm][2] == "self" then
			print(L["KF"]..' : '..userName..L[" user's "]..GetSpellLink(spellID)..L[" enable to cast."])
		elseif ChatTable[cm][2] == "present" then
			local channel = ChatTable[cm][1]
			if KF.CurrentGroupMode == 'NoGroup' and (channel == "RAID" or channel == "PARTY") then
				channel = "SAY"
			elseif (KF.CurrentGroupMode == 'party' and channel == "RAID") or (channel == 'RAID' and not (KF:CheckFilterForName(E.myname) or UnitIsGroupLeader('player') or UnitIsGroupAssistant('player'))) then
				channel = "PARTY"				
			end
			SendChatMessage(userName..L[" user's "]..GetSpellLink(spellID)..L[" enable to cast."], channel)
		elseif ChatTable[cm][2] == "channel" then
			SendChatMessage(userName..L[" user's "]..GetSpellLink(spellID)..L[" enable to cast."], "CHANNEL", nil, ChatTable[cm][1])
		end
	end
	
	--쿨다운 바 시간 다 될시 Fade Out 처리
	local collectgarbage_throttle = GetTime()
	local function CooldownEnd(userName, spellID, report)
		local bar = CoolDownBarTable[userName]['List'][spellID]
		local class = CoolDownBarTable[userName]['Class']
		if KFRC_Area.CurrentWheelLine > 0 and KFRC_Area.RemainBar > 0 and KFRC_Area.AfterRemain == 0 then KFRC_Area.CurrentWheelLine = KFRC_Area.CurrentWheelLine - 1 end
		if E.db.KnightFrame.RaidCooldown[class][tostring(spellID)] ~= false then
			UIFrameFadeOut(bar, 0.4, bar:GetAlpha(), 0)
			bar.fadeInfo.finishedFunc = bar.fadeFunc
			if E.db.KnightFrame.RaidCooldown.General.CooldownEndAnnounceEnable ~= false and (UnitInParty(userName) or UnitInRaid(userName)) and report then ReportCooldownEnd(userName, spellID) end
		else
			bar:Kill()
			CoolDownBarTable[userName]['List'][spellID] = nil
			if RaidIconTable[spellID] then
				if RaidIconTable[spellID]['cooldownUser'][userName] then
					RaidIconTable[spellID]['cooldownUser'][userName] = nil
				end
			end
			KFRC:RearrangeBar()
			if collectgarbage_throttle + 5 < GetTime() then collectgarbage_throttle = GetTime() collectgarbage() end
		end
	end
	
	--스킬 쿨타임 계산
	local function CalcCooldown(event, cooldown, userName, userClass, spellID, destName)
		local userSpecial = InspectInfoTable[userName]['Specialization']
		CoolDownBarTable[userName]['Specialization'] = userSpecial
		if userClass == 'WARRIOR' and userSpecial == L['WProtection'] and spellID == 871 then
			cooldown = cooldown - 180 --전사 방특은 방벽쿨이 3분 줄어들음
		elseif userClass == 'HUNTER' and userSpecial == L['Survival'] and (spellID == 1499 or spellID == 13809 or spellID == 34600) then
			print(userSpecial)
			cooldown = cooldown - 6 --냥꾼 생존특성은 덫 쿨이 6초 줄어들음
		elseif userClass == 'DRUID' and userSpecial == L['DRestoration'] and spellID == 740 and UnitLevel(userName) >= 82 then
			cooldown = cooldown - 300 --드루 회드는 82렙 이상 시 평온쿨이 5분 줄어들음
		elseif userClass == 'ROGUE' and event == "SPELL_INTERRUPT" and spellID == 1766 and (InspectInfoTable[userName]['Glyph'][2] == 56805 or InspectInfoTable[userName]['Glyph'][4] == 56805 or InspectInfoTable[userName]['Glyph'][6] == 56805) then
			cooldown = cooldown - 6
		end
		if userClass == 'HUNTER' and destName and spellID == 131894 and UnitHealth(dsetName)/UnitHealthMax(destName) <= 0.2 then
			cooldown = cooldown - 60 --저승까마귀 생명력 20% 이하 대상에게 사용 시 60초감소
		end
		for glyphID in pairs(KFRC.ChangeCDByGlyph) do
			for i = 1, 6 do
				if InspectInfoTable[userName]['Glyph'][i] == glyphID and KFRC.ChangeCDByGlyph[glyphID][1] == spellID then cooldown = cooldown + KFRC.ChangeCDByGlyph[glyphID][2] end
			end
		end
		if KFRC.ChangeCDByTalent[userClass] then
			for i = 1, 38 do
				if i < 20 then
					if KFRC.ChangeCDByTalent[userClass][i] then
						if InspectInfoTable[userName]['Talent'][i] == true and KFRC.ChangeCDByTalent[userClass][i][1] == spellID then cooldown = cooldown + KFRC.ChangeCDByTalent[userClass][i][2] end
					end
				else
					if KFRC.ChangeCDByTalent[userClass][i] then
						if InspectInfoTable[userName]['Talent'][i-20] == true and KFRC.ChangeCDByTalent[userClass][i][1] == spellID then cooldown = cooldown + KFRC.ChangeCDByTalent[userClass][i][2] end
					end
				end
			end
		end
		return cooldown
	end
	
	local function CreateCooldownBar(event, userName, userClass, spellID, destName)
		if E.db.KnightFrame.RaidCooldown[userClass][tostring(spellID)] ~= false or RaidIconTable[spellID] then
			if not CoolDownBarTable[userName] then CoolDownBarTable[userName] = { ['Class'] = userClass, ['List'] = {}, } end
			local cooldown = KFRC.RaidSpell[userClass][spellID][1]
			local RecalcCooldown = false
			if InspectInfoTable[userName] then
				if InspectInfoTable[userName]['Specialization'] then
					cooldown = CalcCooldown(event, cooldown, userName, userClass, spellID, destName)
				else
					RecalcCooldown = true
				end
			else
				RecalcCooldown = true
			end
			if cooldown == 0 then return end
			
			local name, _, icon = GetSpellInfo(spellID)
		
			local bar = CoolDownBarTable[userName]['List'][spellID]
			if not bar then
				bar = CreateFrame('Statusbar', nil, KF.UIParent)
				bar:SetAlpha(0)
				bar:CreateBackdrop("Default")
				bar:SetFrameStrata('MEDIUM')
				bar:SetFrameLevel(10)
				bar:SetStatusBarTexture(E["media"].normTex)
				local color = RAID_CLASS_COLORS[userClass]
				if color then bar:SetStatusBarColor(color.r, color.g, color.b) end
				bar:SetMinMaxValues(0,100)
				bar.fadeFunc = function()
					bar:Kill()
					CoolDownBarTable[userName]['List'][spellID] = nil
					if RaidIconTable[spellID] then
						if RaidIconTable[spellID]['cooldownUser'][userName] then
							RaidIconTable[spellID]['cooldownUser'][userName] = nil
						end
					end
					KFRC:RearrangeBar()
					if collectgarbage_throttle + 5 < GetTime() then collectgarbage_throttle = GetTime() collectgarbage() end
				end
				bar.spellName = bar:CreateFontString(nil, 'OVERLAY')
				bar.spellName:FontTemplate(nil, 12, 'OUTLINE')
				bar.spellName:Point('LEFT', bar, 5, 0)
				bar.spellName:SetJustifyH('LEFT')
				
				bar.spellIcon = CreateFrame('Button', nil, bar)
				bar.spellIcon:SetTemplate()
				bar.spellIcon:Point('RIGHT', bar, 'LEFT', (E.PixelMode and -1 or -3), 0)
				bar.spellIcon:RegisterForClicks("AnyUp")
				bar.spellIcon:SetScript('OnClick', function(_, btn)
					if btn == "RightButton" then
						if IsShiftKeyDown() then
							E.db.KnightFrame.RaidCooldown[userClass][tostring(spellID)] = false
							KFRC:RearrangeBar()
						else
							CooldownEnd(userName, spellID)
							bar.spellIcon:SetScript('OnClick', nil)
						end
					end
				end)
				bar.spellIcon:SetScript('OnEnter', function()
					GameTooltip:SetOwner(bar.spellIcon, "ANCHOR_TOPLEFT")
					GameTooltip:SetHyperlink(GetSpellLink(spellID))
					GameTooltip:AddLine('|n'..L['KF']..' : ')
					GameTooltip:AddDoubleLine(L['Right Click'],L['Delete this spell cooltime bar.'])
					GameTooltip:AddDoubleLine(L['Right Click + Hold Shift'],L['Config to hide this spell all.'])
					GameTooltip:Show()
				end)
				bar.spellIcon:SetScript('OnLeave', function()
					GameTooltip:Hide()
				end)
				local is = E.PixelMode and 1 or 2
				bar.spellIcon.t = bar.spellIcon:CreateTexture(nil, 'OVERLAY')
				bar.spellIcon.t:SetTexCoord(unpack(E.TexCoords))
				bar.spellIcon.t:Point('TOPLEFT', bar.spellIcon, is, -is)
				bar.spellIcon.t:Point('BOTTOMRIGHT', bar.spellIcon, -is, is)
				bar.spellIcon.t:SetTexture(icon)

				bar.spellCooldown = bar:CreateFontString(nil, 'OVERLAY')
				bar.spellCooldown:FontTemplate(nil, 12, 'OUTLINE')
				bar.spellCooldown:Point('RIGHT', bar, -2, 0)
				UIFrameFadeIn(bar, 0.4, bar:GetAlpha(), 1)
			end
			if KFRC.RaidSpell[userClass][spellID][2] == true then
				local destColor
				if UnitIsPlayer(destName) then
					destColor = KF:ClassColor(select(2, UnitClass(destName)), "")
					if string.find(GetUnitName(destName, true), ' - ', 1) then destName = select(1, string.split(' ', GetUnitName(destName, true))) end
				else
					if UnitIsFriend('player', destName) then
						destColor = '|cff73e873'
					else
						destColor = '|cffff6a6a'
					end
				end
				bar.spellName:SetText(name..' ▶ '..destColor..destName)
			else
				bar.spellName:SetText(name)
			end
			bar.CheckCooldown = true
			bar.Cooldown = cooldown
			bar.ExecuteTime = GetTime()
			if RecalcCooldown == true then bar.RecalcCooldown = true end
			if not CoolDownBarTable[userName]['List'][spellID] then CoolDownBarTable[userName]['List'][spellID] = bar end
			if RaidIconTable[spellID] then
				RaidIconTable[spellID]['cooldownUser'][userName] = userName
			end
			bar:SetScript('OnUpdate', function(self, elapsed)
				local SkillCooldown = CoolDownBarTable[userName]['List'][spellID]['Cooldown']
				if bar.RecalcCooldown and InspectInfoTable[userName] then
					if InspectInfoTable[userName]['Specialization'] then
						SkillCooldown = CalcCooldown(event, cooldown, userName, userClass, spellID)
						bar.RecalcCooldown = nil
					end
				end
				if (GetTime() > bar.ExecuteTime + SkillCooldown - 0.5) and bar.CheckCooldown then
					bar.CheckCooldown = nil
					CooldownEnd(userName, spellID, true)
				end
				self:SetValue(100 - (GetTime() - bar.ExecuteTime)/SkillCooldown * 100)
				self.spellCooldown:SetText(TimeFormat(bar.ExecuteTime + SkillCooldown - GetTime()))
			end)
			KFRC:RearrangeBar()
		end
	end
	
	local function CooldownStart(event, userName, userClass, spellID, destName)
		CreateCooldownBar(event, userName, userClass, spellID, destName, ChangeSpellID)
		if CoolDownBarTable[userName] then
			if spellID == 11958 then --매서운 한파
				if CoolDownBarTable[userName]['List'][45438] then CooldownEnd(userName,45438) end --얼방 초기화
				if CoolDownBarTable[userName]['List'][45438] then CooldownEnd(userName,45438) end --얼회 초기화
				if CoolDownBarTable[userName]['List'][45438] then CooldownEnd(userName,45438) end --냉돌 초기화
			elseif spellID == 23989 then --만반의 준비
				if CoolDownBarTable[userName] then
					for spell in pairs(CoolDownBarTable[userName]['List']) do
						if CoolDownBarTable[userName]['List'][spell] and KFRC.RaidSpell[userClass][spell][1] < 300 then CooldownEnd(userName, spell) end
					end
				end
			elseif spellID == 14185 then --마음가짐
				if CoolDownBarTable[userName]['List'][31224] then CooldownEnd(userName,31224) end --그망 초기화
				if CoolDownBarTable[userName]['List'][2983] then CooldownEnd(userName,2983) end --전질 초기화
				if CoolDownBarTable[userName]['List'][1856] then CooldownEnd(userName,1856) end --소멸 초기화
				if CoolDownBarTable[userName]['List'][180] then CooldownEnd(userName,180) end --회피 초기화
				if CoolDownBarTable[userName]['List'][51722] then CooldownEnd(userName,51722) end --장분 초기화
			elseif spellID == 108285 then --원소의 부름
				if CoolDownBarTable[userName]['List'][8143] then CooldownEnd(userName,8143) end --진동의 토템 초기화
				if CoolDownBarTable[userName]['List'][51485] then CooldownEnd(userName,51485) end --구속의 토템 초기화
				if CoolDownBarTable[userName]['List'][108273] then CooldownEnd(userName,108273) end --바람걸음 토템 초기화
				if CoolDownBarTable[userName]['List'][2484] then CooldownEnd(userName,2484) end --속박의 토템 초기화
				if CoolDownBarTable[userName]['List'][108269] then CooldownEnd(userName,108269) end --축전 토템 초기화
				if CoolDownBarTable[userName]['List'][108279] then CooldownEnd(userName,108279) end --고요한 마음의 토템
				if CoolDownBarTable[userName]['List'][8177] then CooldownEnd(userName,8177) end --마법흡수 토템 초기화
				if CoolDownBarTable[userName]['List'][108270] then CooldownEnd(userName,108270) end --돌의 보루 토템 초기화
			end
		end
	end
		
	function KFRC:COMBAT_LOG_EVENT_UNFILTERED(...)
		local _, _, event, _, _, userName, userFlag, _, _, destName, _, _, spellID = ...
		if bit.band(userFlag, filter) == 0 or (event ~= "SPELL_RESURRECT" and event ~= "SPELL_AURA_APPLIED" and event ~= "SPELL_AURA_REFRESH" and event ~= "SPELL_CAST_SUCCESS" and event ~= "SPELL_INTERRUPT")then return end
		--[[
			print('Event : '..event)
			print('UserName : '..userName)
			print('SpellID : '..spellID)
			print('SKill Name : '..GetSpellInfo(spellID))
			print('DestUser : '..destName)
		]]
		local userClass
		if userName then
			if not UnitIsPlayer(userName) then --펫 주인 찾기
				if select(1, UnitName('pet')) == userName then
					userName = E.myname
				elseif KF.CurrentGroupMode ~= 'NoGroup' then
					if IsInRaid() and not UnitPlayerOrPetInRaid(userName) then return
					elseif IsInGroup() and not UnitPlayerOrPetInParty(userName) then return	end
					for i = 1, MAX_RAID_MEMBERS do
						if UnitExists(KF.CurrentGroupMode..i..'pet') then
							if UnitIsUnit(userName, KF.CurrentGroupMode..i..'pet') then
								userName = select(1, UnitName(KF.CurrentGroupMode..i))
							end
						end
					end
				end
			end
			if not UnitIsPlayer(userName) then return end
			userClass = select(2, UnitClass(userName))
		end
		--if event == 'SPELL_INTERRUPT' then SendChatMessage(userName..L[" user's "]..GetSpellLink(spellID).." 차단했음.", 'RAID') end
		if KFRC.RaidSpell[userClass] and userName then
			if spellID == 95750 and userClass == 'WARLOCK' then spellID = 20707 --영혼석
			elseif spellID == 60192 and userClass == 'HUNTER' then spellID = 1499 --빙결의 덫 투척
			elseif spellID == 82948 and userClass == 'HUNTER' then spellID = 34600 --뱀덫 투척
			elseif spellID == 82941 and userClass == 'HUNTER' then spellID = 13809 --냉덫 투척
			elseif (spellID == 77764 or spellID == 106898) and userClass == 'DRUID' then spellID = 77761 --쇄포
			elseif (spellID == 111859 or spellID == 111895 or spellID == 111896 or spellID == 111897 or spellID == 111898) and userClass == 'WARLOCK' then spellID = 108501 --흑마법서: 봉사
			elseif spellID == 86121 and userClass == 'WARLOCK' then return --영혼바꾸기에 체크하지 않음
			elseif spellID == 86213 and userClass == 'WARLOCK' then spellID = 86121 --영혼바꾸기: 내보내기 를 영혼바꾸기로 체크
			end
			if KFRC.RaidSpell[userClass][spellID] then
				--다른서버 사람일 때 이름에서 서버명 없애기
				if string.find(GetUnitName(userName, true), ' - ', 1) then userName = select(1, string.split(' ', GetUnitName(userName, true))) end
				CooldownStart(event, userName, userClass, spellID, destName)
			end
		end
	end
	
	local Inspecting = GetTime()
	--파티원 체크 지시
	local function CheckGroupMembersTalent(force)
		if (E.db.KnightFrame.RaidCooldown.General.AutoInspect ~= false or force) and Inspecting < GetTime() then
			for i = 1, MAX_RAID_MEMBERS do
				local userName = select(1, GetRaidRosterInfo(i))
				if userName and userName ~= E.myname then
					if string.find(userName, '-', 1) then userName = select(1, string.split('-', userName)) end
					if not InspectInfoTable[userName] then InspectInfoTable[userName] = { ['CheckedTime'] = GetTime(), ['Glyph'] = {}, ['Talent'] = {}, } end

					if (not force and InspectInfoTable[userName]['CheckedTime'] < GetTime()) or (force and not InspectInfoTable[userName]['StopInspect']) and Inspecting < GetTime() and CanInspect(userName) and UnitIsConnected(userName) then
						Inspecting = GetTime() + 1
						NotifyInspect(userName)
					end
				end
			end
		end
	end
	
	--테이블 청소 (완료)
	local function ClearInspectTable()
		if not IsInGroup() then GroupNumber = 0 end
		MemberNumNow = GetNumGroupMembers()
		if MemberNumNow > GroupNumber then
			GroupNumber = MemberNumNow
			if E.db.KnightFrame.RaidCooldown.General.AutoInspectByMembersChange ~= false then KFRC:ForceCheck() end
		elseif MemberNumNow < GroupNumber then
			GroupNumber = MemberNumNow
			for userName in pairs(InspectInfoTable) do
				if userName ~= E.myname then
					if not UnitInParty(userName) then
						InspectInfoTable[userName] = nil
						for spellID in pairs(RaidIconTable) do
							if RaidIconTable[spellID]['cooldownUser'][userName] then RaidIconTable[spellID]['cooldownUser'][userName] = nil end
						end
					end
				end
			end
		end
		KFRC:SetupRaidIcon()
	end

	--플레이어 특성문양체크 (완료)
	local function CheckPlayerTalent()
		local spec = GetSpecialization()
		if (spec ~= nil and spec > 0) then
			local _, specialization = GetSpecializationInfo(spec)
			if specialization ~= nil then InspectInfoTable[E.myname]['Specialization'] = specialization end
		end
		for i = 1, 6 do
			InspectInfoTable[E.myname]['Glyph'][i] = select(4, GetGlyphSocketInfo(i))
		end
		for i = 1, 18 do
			InspectInfoTable[E.myname]['Talent'][i] = select(5, GetTalentInfo(i))
		end
		KFRC:SetupRaidIcon()
	end
	
	local NumToInspect, InspectOrder = 0, false
	function KFRC:ForceCheck()
		if GetNumGroupMembers() > 1 then
			NumToInspect = GetNumGroupMembers() - 1
			InspectOrder = true
			for userName in pairs(InspectInfoTable) do
				if InspectInfoTable[userName]['StopInspect'] then InspectInfoTable[userName]['StopInspect'] = nil end
			end
			KFRC_CheckButton.num:SetText(NumToInspect)
			print(L["KF"]..' : |cffceff00'..NumToInspect..'|r 명에 대하여 체크 시작')
			KFRC_Holder:SetScript('OnUpdate', function(self, elapsed)
				CheckGroupMembersTalent(true)
			end)
		end
	end

	function KFRC:INSPECT_READY(_, GUID)
		local _, class, _, _, _, userName = GetPlayerInfoByGUID(GUID)
		if not UnitInParty(userName) or not InspectInfoTable[userName] then return end
		InspectInfoTable[userName]['CheckedTime'] = GetTime() + E.db.KnightFrame.RaidCooldown.General.Throttle
		InspectInfoTable[userName]['Specialization'] = select(2,GetSpecializationInfoByID(GetInspectSpecialization(userName)))
		InspectInfoTable[userName]['Class'] = class
		for i = 1, 6 do
			InspectInfoTable[userName]['Glyph'][i] = select(4, GetGlyphSocketInfo(i, nil, true, userName))
		end
		class = select(3, UnitClass(userName))
		for i = 1, 18 do
			InspectInfoTable[userName]['Talent'][i] = select(5, GetTalentInfo(i, true, nil, userName, class))
		end
		KFRC:SetupRaidIcon()
		if UnitGUID('player') ~= GUID and InspectOrder == true then
			if NumToInspect > 0 and not InspectInfoTable[userName]['StopInspect'] then
				NumToInspect = NumToInspect - 1
				KFRC_CheckButton.num:SetText(NumToInspect)
				InspectInfoTable[userName]['StopInspect'] = true
				Inspecting = GetTime()
			end
			if NumToInspect == 0 then
				KFRC_CheckButton.time = GetTime() + 5
				KFRC_Holder:SetScript('OnUpdate', function() CheckGroupMembersTalent() end)
				KFRC_CheckButton.num:SetText("")
				print(L["KF"]..' : |cffceff00자동체크|r 해제. 모든 파티원의 전문화, 특성, 문양 정보가 업데이트 되었습니다. 이 기록으로 쿨타임을 계산합니다.|r')
				InspectOrder = false
			end
		end
	end
	
	--레이드 아이콘 정렬
	function KFRC:RearrangeIcon()
		local num = 0
		local RCP = E.db.KnightFrame.RaidCooldown.Appearance
		for spellID in pairs(RaidIconTable) do
			local button = RaidIconTable[spellID]
			if button:IsShown() then
				button:ClearAllPoints()
				button:Size(RCP.RaidIconSize)
				if RCP.RaidIconDirection == 1 then
					button:Point(RCP.RaidIconLocation == 1 and 'BOTTOMRIGHT' or 'BOTTOMLEFT', KFRC_MainFrame, RCP.RaidIconLocation == 1 and 'TOPLEFT' or 'TOPRIGHT', RCP.RaidIconLocation == 1 and -4 or 4, 4 +(RCP.RaidIconSize + RCP.RaidIconSpacing)*num)
				elseif RCP.RaidIconDirection == 2 then
					button:Point(RCP.RaidIconLocation == 1 and 'TOPRIGHT' or 'TOPLEFT', KFRC_MainFrame, RCP.RaidIconLocation == 1 and 'BOTTOMLEFT' or 'BOTTOMRIGHT', RCP.RaidIconLocation == 1 and -4 or 4, -4 -(RCP.RaidIconSize + RCP.RaidIconSpacing)*num)
				elseif RCP.RaidIconDirection == 3 then
					button:Point(RCP.RaidIconLocation == 1 and 'BOTTOMLEFT' or 'BOTTOMRIGHT', KFRC_MainFrame, RCP.RaidIconLocation == 1 and 'TOPLEFT' or 'TOPRIGHT', (RCP.RaidIconLocation == 1 and 1 or -1)*(RCP.RaidIconSize + RCP.RaidIconSpacing)*num, 4)
				else
					button:Point(RCP.RaidIconLocation == 1 and 'TOPLEFT' or 'TOPRIGHT', KFRC_MainFrame, RCP.RaidIconLocation == 1 and 'BOTTOMLEFT' or 'BOTTOMRIGHT', (RCP.RaidIconLocation == 1 and 1 or -1)*(RCP.RaidIconSize + RCP.RaidIconSpacing)*num, -4)
				end
				num = num + 1
			end
		end
	end
	
	--레이드 아이콘 생성
	local function CreateRaidIcon(spellID)
		local maxbutton, cooldowncount
		local button = CreateFrame('Frame', nil, KFRC_Holder)
		button:SetTemplate('Default', true)
		button.User = {}
		button.cooldownUser = {}
		
		button.t = button:CreateTexture(nil, 'OVERLAY')
		button.t:SetTexCoord(unpack(E.TexCoords))
		button.t:Point('TOPLEFT', button, 2, -2)
		button.t:Point('BOTTOMRIGHT', button, -2, 2)
		button.t:SetTexture(select(3, GetSpellInfo(spellID)))
		
		local buttontooltip = CreateFrame('Frame', nil, button)
		button:SetScript('OnEnter', function(self)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
			button:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
			buttontooltip:SetScript('OnUpdate', function()
				GameTooltip:ClearLines()
				GameTooltip:SetHyperlink(GetSpellLink(spellID))
				GameTooltip:AddLine('|n'..L['Castable User'])
				for _, userName in pairs(button.User) do
					local IsCooltime =  true or false
					GameTooltip:AddDoubleLine(' '..GetRuleIcon(userName, true)..' '..KF:ClassColor(InspectInfoTable[userName]['Class'], userName)..(UnitIsDeadOrGhost(userName) and ' |cffb90624('..DEAD..')' or ''), button.cooldownUser[userName] == userName and '|cffb90624'..CoolDownBarTable[userName]['List'][spellID].spellCooldown:GetText() or L['Enable To Cast'])
				end
				GameTooltip:Show()
			end)
		end)
		button:SetScript('OnLeave', function()
			button:SetBackdropBorderColor(unpack(E.media.bordercolor))
			buttontooltip:SetScript('OnUpdate', nil)
			GameTooltip:Hide()
		end)		
		
		button.num = button:CreateFontString(nil, 'OVERLAY')
		button.num:FontTemplate(nil, E.db.KnightFrame.RaidCooldown.Appearance.RaidIconFontsize, 'OUTLINE')
		button.num:SetJustifyH('CENTER')
		button.num:Point('BOTTOMRIGHT', button, -1, 4)
		button.num:SetText(button.remain)
		button:SetScript('OnUpdate', function()
			maxcount = 0
			cooldowncount = 0
			for i in pairs(button['User']) do
				maxcount = maxcount + 1
			end
			if maxcount == 0 then button:Hide() KFRC:RearrangeIcon() return end
			for i in pairs(button['cooldownUser']) do
				cooldowncount = cooldowncount + 1
			end
			button.num:SetFont(select(1,button.num:GetFont()), E.db.KnightFrame.RaidCooldown.Appearance.RaidIconFontsize, 'OUTLINE')
			if maxcount-cooldowncount <= 0 then
				if E.db.KnightFrame.RaidCooldown.Appearance.ShowMax ~= false then
					button.num:SetText('|cffb906240/'..maxcount)
				else
					button.num:SetText('|cffb906240')
				end
				button.t:SetAlpha(0.2)
			else
				if E.db.KnightFrame.RaidCooldown.Appearance.ShowMax ~= false then
					button.num:SetText((maxcount-cooldowncount)..'/'..maxcount)
				else
					button.num:SetText((maxcount-cooldowncount))
				end
				button.t:SetAlpha(1)
			end
		end)
		button:Hide()
		RaidIconTable[spellID] = button
	end
	
	--아이콘 보이기 (완료)
	local function RaidIcon_Show(userName, spellID)
		RaidIconTable[spellID]['User'][userName] = userName
		RaidIconTable[spellID]:Show()
		ShowRaidIcon = true
	end

	--아이콘 활성화 유무 체크 (완료)
	function KFRC:SetupRaidIcon()
		for _, spellID in pairs(KFRC.RaidIconDefault) do
			RaidIconTable[spellID].User = {}
			RaidIconTable[spellID]:Hide()
		end
		KFRC_CheckButton:Hide()
		ShowRaidIcon = false
		if MemberNumNow > 1 then
			for userName in pairs(InspectInfoTable) do
				local userClass = InspectInfoTable[userName]['Class']
				local userSpec = InspectInfoTable[userName]['Specialization']
				local userLevel = UnitLevel(userName)
				if userClass == 'WARRIOR' and userLevel >= 83 then
					RaidIcon_Show(userName, 97462)
				end
				if userClass == 'SHAMAN' and userLevel >= 70 and userSpec == L['SRestoration'] then
					RaidIcon_Show(userName, 98008)
				end
				if userClass == 'SHAMAN' and InspectInfoTable[userName]['Talent'][13] == true then
					RaidIcon_Show(userName, 108280)
				end
				if userClass == 'PALADIN' and userLevel >= 60 then
					RaidIcon_Show(userName, 31821)
				end
				if userClass == 'ROGUE' and userLevel >= 85 then
					RaidIcon_Show(userName, 76577)
				end
				if userClass == 'DEATHKNIGHT' and InspectInfoTable[userName]['Talent'][5] == true then
					RaidIcon_Show(userName, 51052)
				end
				if userClass == 'DRUID' and userLevel >= 74 then
					RaidIcon_Show(userName, 740)
				end
				if userClass == 'PRIEST' and userLevel >= 78 and userSpec == L['Holy'] then
					RaidIcon_Show(userName, 64843)
				end
				if userClass == 'PRIEST' and userLevel >= 70 and userSpec == L['Discipline'] then
					RaidIcon_Show(userName, 62618)
				end
				if userClass == 'MONK' and userLevel >= 78 and userSpec == L['Mistweaver'] then
					RaidIcon_Show(userName, 115310)
				end
			end
			KFRC_CheckButton:Show()
		end
		KFRC:RearrangeIcon()
		KFRC:RearrangeBar()
	end
	
	function KFRC:ChangeArea()
		local area = KFRC_Area
		local MainFrame = KFRC_MainFrame
		area:ClearAllPoints()
		area.resizegrip:ClearAllPoints()
		if E.db.KnightFrame.RaidCooldown.Appearance.barDirection == 1 then
			area:Point('BOTTOMLEFT', KFRC_MainFrame, 'TOPLEFT')
			area.resizegrip:Point('TOPRIGHT', area)
			area.resizegrip.t:SetTexture([[Interface\AddOns\ElvUI_KnightFrame\Media\ResizeGripRightTop.tga]])
			
			MainFrame.beforeArrow:SetText('▼')
			MainFrame.afterArrow:SetText('▲')
			
			area.resizegrip:SetScript('OnMouseDown', function()
				if area:GetAlpha() > 0 then
					area:SetResizable(true)
					area:StartSizing('TOPRIGHT')
				end
			end)	
		else
			area:Point('TOPLEFT', KFRC_MainFrame, 'BOTTOMLEFT')
			area.resizegrip:Point('BOTTOMRIGHT', area)
			area.resizegrip.t:SetTexture([[Interface\AddOns\ElvUI_KnightFrame\Media\ResizeGripRight.tga]])
			
			MainFrame.beforeArrow:SetText('▲')
			MainFrame.afterArrow:SetText('▼')
			
			area.resizegrip:SetScript('OnMouseDown', function()
				if area:GetAlpha() > 0 then
					area:SetResizable(true)
					area:StartSizing('BOTTOMRIGHT')
				end
			end)
		end
	end

	--보스전 종료 시 5분쿨 이상 스킬 초기화 관련
	--GetInstanceInfo() 에서 가장 마지막에 나오는 값이 ID
	local ResetCooldownMapID = {
		1009, --공포의 심장
		1008, --모구샨 궁전
		996, --영원한 봄의 정원
	}
	local BattleAreaCheck, BattleStart, AreaWhenBattleStart, GroupWhenBattleStart, BossFrameCheck, HideTime = false, false, 0, 'NoGroup', false , 0
	local ResetCooldownFrame = CreateFrame('Frame')
	function KFRC:ZONE_CHANGED_NEW_AREA()
		BattleAreaCheck = false
		local InInstance, InstanceType = IsInInstance()
		if not InInstance and BattleStart == true and select(8, GetInstanceInfo()) ~= AreaWhenBattleStart and KF.CurrentGroupMode ~= GroupWhenBattleStart then
			ResetCooldownFrame:Hide()
			BattleStart = false
			AreaWhenBattleStart = nil
			GroupWhenBattleStart = nil
			BossFrameCheck = false
			HideTime = 0
		elseif InstanceType == 'arena' then
			for userName in pairs(CoolDownBarTable) do
				for spellID in pairs(CoolDownBarTable[userName]['List']) do
					CooldownEnd(userName, spellID)
				end
			end
		end
	end
	
	local function CheckBattleEnd()
		local checking = true
		if KF.CurrentGroupMode == 'NoGroup' then
			if UnitAffectingCombat('player') then checking = false end
		else
			if not UnitIsDeadOrGhost('player') and not UnitAffectingCombat('player') then checking = true
			elseif UnitAffectingCombat('player') then checking = false
			else
				if KF.CurrentGroupMode == 'party' then
					for i = 1, 4 do
						if UnitAffectingCombat('party'..i) then checking = false break end
					end
				elseif KF.CurrentGroupMode == 'raid' then
					for i = 1, MAX_RAID_MEMBERS do
						if UnitExists('raid'..i) then
							if UnitAffectingCombat('raid'..i) then checking = false break end
						end
					end
				end
			end
		end
		return checking
	end
	
	ResetCooldownFrame:Hide()
	ResetCooldownFrame.elapsedTime = GetTime()
	ResetCooldownFrame:SetScript('OnUpdate', function()
		if BattleAreaCheck == false then
			local CurrentMapID = select(8, GetInstanceInfo())
			for _, TableMapID in pairs(ResetCooldownMapID) do
				if CurrentMapID == TableMapID then BattleAreaCheck = true break end
			end
		end
		if BattleAreaCheck == false then ResetCooldownFrame:Hide() return end
		
		if BattleStart == true then
			if BossFrameCheck == false and not (UnitExists('boss1') or UnitExists('boss2') or UnitExists('boss3') or UnitExists('boss4')) then
				BossFrameCheck = true
				HideTime = GetTime()
			elseif BossFrameCheck == true and (UnitExists('boss1') or UnitExists('boss2') or UnitExists('boss3') or UnitExists('boss4')) then
				BossFrameCheck = false
				HideTime = 0
			end
		end
		
		if CheckBattleEnd() == true and BossFrameCheck == true then
			if BattleStart == true and (not (UnitExists('boss1') or UnitExists('boss2') or UnitExists('boss3') or UnitExists('boss4')) or (select(8, GetInstanceInfo()) ~= AreaWhenBattleStart and KF.CurrentGroupMode == GroupWhenBattleStart))then
				print(L['KF']..' : '..L['Reset skills that have a cool time more than 5 minutes'])
				for userName in pairs(CoolDownBarTable) do
					for spellID in pairs(CoolDownBarTable[userName]['List']) do
						for class in pairs(KFRC.RaidSpell) do
							if KFRC.RaidSpell[class][spellID] then
								if KFRC.RaidSpell[class][spellID][1] >= 300 and CoolDownBarTable[userName]['List'][spellID]['ExecuteTime'] < HideTime then CooldownEnd(userName, spellID) end
							end
						end
					end
				end
			end
			ResetCooldownFrame:Hide()
			AreaWhenBattleStart = nil
			GroupWhenBattleStart = nil
			BossFrameCheck = false
			HideTime = 0
			BattleStart = false
			return
		end
		if BattleStart == false then
			if not (UnitExists('boss1') or UnitExists('boss2') or UnitExists('boss3') or UnitExists('boss4')) then
				return
			else
				for i = 1, 4 do
					if UnitExists('boss'..i) then
						if (UnitLevel('boss'..i) == -1 or UnitClassification('boss'..i) == 'worldboss') and UnitCanAttack('player', 'boss'..i) then
							BossFrameCheck = false
							HideTime = 0
							AreaWhenBattleStart = select(8, GetInstanceInfo())
							GroupWhenBattleStart = KF.CurrentGroupMode
							BattleStart = true
						end
					end
				end
			end
		end
	end)
	
	function KFRC:PLAYER_REGEN_DISABLED()
		ResetCooldownFrame:Show()
	end

	function KFRC:Initialize()
		local Holder = CreateFrame('Frame', 'KFRC_Holder', KF.UIParent)
		local point, anchor, secondaryPoint, x, y = string.split('\031', E.db['KnightFrame']['RaidCooldown']['Default Location'])
		Holder:Size(E.db.KnightFrame.RaidCooldown.Appearance.AreaWidth, 18)
		Holder:SetPoint(point, anchor, secondaryPoint, x, y)
		E:CreateMover(KFRC_Holder, 'KF_RaidCooldownMover', L['RaidCooldown'], nil, nil)
		if E:HasMoverBeenMoved('KF_RaidCooldownMover') then
			local Mover = KF_RaidCooldownMover
			point, anchor, secondaryPoint, x, y = string.split('\031', E.db['movers']['KF_RaidCooldownMover'])
			Mover:ClearAllPoints()
			Mover:SetPoint(point, anchor, secondaryPoint, x, y)
		end
		
		local MainFrame = CreateFrame('Frame', 'KFRC_MainFrame', KF.UIParent)
		MainFrame:SetTemplate('Default', true)
		MainFrame:SetFrameStrata('MEDIUM')
		MainFrame:SetFrameLevel(2)
		MainFrame:SetMovable(true)
		MainFrame:Point('TOPLEFT', Holder)
		MainFrame:Point('BOTTOMRIGHT', Holder)
		MainFrame.name = MainFrame:CreateFontString(nil, 'OVERLAY')
		MainFrame.name:FontTemplate(nil, 10, 'OUTLINE')
		MainFrame.name:Point('LEFT', MainFrame, 4, 1)
		MainFrame.name:SetJustifyH('LEFT')
		MainFrame.name:SetText('■ |cff2eb7e4Raid Cooldown')
		MainFrame:SetScript('OnMouseDown', function()
			if KFRC_Area:GetAlpha() > 0 then MainFrame:StartMoving() end
		end)
		MainFrame:SetScript('OnMouseUp', function()
			if KFRC_Area:GetAlpha() > 0 then
				MainFrame:StopMovingOrSizing()
				local point, anchor, secondaryPoint, x, y = MainFrame:GetPoint()
				KF_RaidCooldownMover:ClearAllPoints()
				KF_RaidCooldownMover:SetPoint(point, anchor, secondaryPoint, x, y)
				E:SaveMoverPosition('KF_RaidCooldownMover')
				MainFrame:Point('TOPLEFT', Holder)
				MainFrame:Point('BOTTOMRIGHT', Holder)
			end
		end)
		MainFrame.beforeArrow = MainFrame:CreateFontString(nil, 'OVERLAY')
		MainFrame.beforeArrow:FontTemplate()
		MainFrame.beforeArrow:Hide()
		MainFrame.afterArrow = MainFrame:CreateFontString(nil, 'OVERLAY')
		MainFrame.afterArrow:FontTemplate()
		MainFrame.afterArrow:Hide()
		
		local area = CreateFrame('Frame', 'KFRC_Area', MainFrame)
		area:Size(E.db.KnightFrame.RaidCooldown.Appearance.AreaWidth, E.db.KnightFrame.RaidCooldown.Appearance.AreaHeight)
		area:SetMinResize(200,100)
		area:SetMaxResize(600,600)
		area:SetTemplate()
		area:SetFrameLevel(1)
		area:SetBackdropColor(0.1, 0.1, 0.1, 0.1)
		area:SetBackdropBorderColor(1,1,1,1)
		area.backdropTexture:SetAlpha(0.1)
		area:EnableMouseWheel()
		area.CurrentWheelLine = 0
		area.BarTotal = 0
		area.DisplayBar = 0
		area.RemainBar = 0

		area:SetScript('OnMouseWheel', function(_, spining)
			--마우스 휠을 위로 올리면 spining 에 1값 리턴, 아래로 내리면 spining 에 -1 값 리턴
			if E.db.KnightFrame.RaidCooldown.Appearance.barDirection == 2 then
				if spining == -1 then
					if KFRC_Area.CurrentWheelLine + KFRC_Area.DisplayBar < KFRC_Area.BarTotal then KFRC_Area.CurrentWheelLine = KFRC_Area.CurrentWheelLine + 1 end
				elseif spining == 1 then
					if KFRC_Area.CurrentWheelLine > 0 then KFRC_Area.CurrentWheelLine = KFRC_Area.CurrentWheelLine - 1 end
				end
			else
				if spining == 1 then
					if KFRC_Area.CurrentWheelLine + KFRC_Area.DisplayBar < KFRC_Area.BarTotal then KFRC_Area.CurrentWheelLine = KFRC_Area.CurrentWheelLine + 1 end
				elseif spining == -1 then
					if KFRC_Area.CurrentWheelLine > 0 then KFRC_Area.CurrentWheelLine = KFRC_Area.CurrentWheelLine - 1 end
				end
			end
			KFRC:RearrangeBar()
		end)
		
		area:SetScript('OnSizeChanged', function()
			E.db.KnightFrame.RaidCooldown.Appearance.AreaWidth = area:GetWidth()
			E.db.KnightFrame.RaidCooldown.Appearance.AreaHeight = area:GetHeight()
			area.DisplayBar = floor((E.db.KnightFrame.RaidCooldown.Appearance.AreaHeight - 1)/(E.db.KnightFrame.RaidCooldown.Appearance.barHeight+5))
			KFRC:RearrangeBar()
		end)
		if E.db.KnightFrame.RaidCooldown.Appearance.AreaView == false then area:SetAlpha(0) end
		
		local resizegrip = CreateFrame('Frame', nil, area)
		resizegrip:Size(16)
		resizegrip:SetFrameStrata('TOOLTIP')
		resizegrip.t = resizegrip:CreateTexture('KFRC_AreaGrip', 'OVERLAY')
		resizegrip.t:Size(16)
		resizegrip.t:Point('CENTER', resizegrip)
		resizegrip:SetScript('OnMouseUp', function()
			if area:GetAlpha() > 0 then
				area:StopMovingOrSizing()
				area:SetResizable(false)
				resizegrip:SetScript('OnUpdate', nil)
				KFRC:ChangeArea()
			end
		end)
		area.resizegrip = resizegrip
		
		local ResizeButton = CreateFrame('Button', nil, MainFrame)
		ResizeButton:Size(16)
		ResizeButton:Point('RIGHT', MainFrame, -2, 0)
		ResizeButton.t = ResizeButton:CreateTexture(nil, 'OVERLAY')
		ResizeButton.t:SetTexCoord(unpack(E.TexCoords))
		ResizeButton.t:Point('TOPLEFT', ResizeButton, 2, -2)
		ResizeButton.t:Point('BOTTOMRIGHT', ResizeButton, -2, 2)
		ResizeButton.t:SetTexture(select(3, GetSpellInfo(35715)))
		ResizeButton:SetScript('OnClick', function()
			GameTooltip:Hide()
			if area:GetAlpha() > 0 then
				area:SetAlpha(0)
				E.db.KnightFrame.RaidCooldown.Appearance.AreaView = false
				print(L['KF']..' : '..L['Lock Display Window'])
			else
				area:SetAlpha(1)
				E.db.KnightFrame.RaidCooldown.Appearance.AreaView = true
				print(L['KF']..' : '..L['Unlock Display Window'])
			end
		end)
		ResizeButton:SetScript('OnEnter', function()
			if not InCombatLockdown() then
				GameTooltip:SetOwner(ResizeButton, "ANCHOR_NONE")
				GameTooltip:SetPoint('LEFT', ResizeButton, 'RIGHT', 4, 0)
				GameTooltip:AddLine('|cffceff00◀|cffffffffToggle Lock')
				GameTooltip:Show()
			end
		end)
		ResizeButton:SetScript('OnLeave', function() GameTooltip:Hide() end)
		
		local CheckButton = CreateFrame('Button', 'KFRC_CheckButton', MainFrame)
		CheckButton:Size(16)
		CheckButton:Point('RIGHT', ResizeButton, 'LEFT', -2, 0)
		CheckButton.t = CheckButton:CreateTexture(nil, 'OVERLAY')
		CheckButton.t:SetTexCoord(unpack(E.TexCoords))
		CheckButton.t:Point('TOPLEFT', CheckButton, 2, -2)
		CheckButton.t:Point('BOTTOMRIGHT', CheckButton, -2, 2)
		CheckButton.t:SetTexture(select(3, GetSpellInfo(3562)))
		CheckButton.num = CheckButton:CreateFontString(nil, 'OVERLAY')
		CheckButton.num:FontTemplate(nil, 15, 'OUTLINE')
		CheckButton.num:Point('CENTER', CheckButton)
		CheckButton:SetScript('OnClick', function()
			GameTooltip:Hide()
			KFRC:ForceCheck()
		end)
		CheckButton:SetScript('OnEnter', function()
			if not InCombatLockdown() then
				GameTooltip:SetOwner(CheckButton, "ANCHOR_NONE")
				GameTooltip:SetPoint('LEFT', CheckButton, 'RIGHT', 4, 0)
				GameTooltip:AddLine('|cffceff00◀|cffffffffCheck Group Members')
				GameTooltip:Show()
			end
		end)
		CheckButton:SetScript('OnLeave', function() GameTooltip:Hide() end)
		CheckButton:Hide()
		KFRC:ChangeArea()
	
		for _, spellID in pairs(KFRC.RaidIconDefault) do
			CreateRaidIcon(spellID)
		end

		if E.db.KnightFrame.RaidCooldown.General.AutoInspectByReadyCheck ~= false then
			self:RegisterEvent('READY_CHECK', 'ForceCheck');
		end
		self:RegisterEvent('PLAYER_REGEN_DISABLED')
		self:RegisterEvent('INSPECT_READY')
		self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		self:RegisterEvent('GROUP_ROSTER_UPDATE', ClearInspectTable)
		CheckPlayerTalent()
		self:RegisterEvent('ZONE_CHANGED_NEW_AREA')
		self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED', CheckPlayerTalent)
		self:RegisterEvent('PLAYER_TALENT_UPDATE', CheckPlayerTalent)
		self:RegisterEvent('CHARACTER_POINTS_CHANGED', CheckPlayerTalent)
		self:RegisterEvent('UPDATE_BONUS_ACTIONBAR', CheckPlayerTalent)
	end
end