local E, L, V, P, G, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')
local KFRC = E:GetModule('KF_RaidCooldown')

if not (E.db.KnightFrame.Install_Complete == nil or E.db.KnightFrame.Install_Complete == 'NotInstalled') then
	--Raid Cooldown
	L["RaidCooldown"] = "레이드 쿨다운"
	L["Show group member's spell cooldown that is affect to raid."] = "공략에 있어 영향을 주는 파티원들 주요 주문들의 쿨다운을 표시합니다."

	L["KFRC_Inspect_Desc"] = "|cffceff00살펴보기 설정|r : 정확한 쿨타임 계산을 위해 이 애드온은 내부적으로|n                      파티원의 전문화와 특성, 문양을 체크합니다."
		L["AutoInspect"] = "반복 살펴보기"
			L["When you checked this option, RaidCooldown will inspect each group members continuously at an interval of throttle option's time."] = "이 옵션을 체크하면, 마지막으로 체크한 시간에서 스로틀에서 설정한 시간이 흐르면 자동으로 멤버들을 살펴보기 합니다."
		L["Throttle"] = "스로틀"
			L["This option will affect checking members's interval. |cffceff00(second)"] = "자동 반복체크 기능의 시간 간격을 정합니다. |cffceff00(단위: 초)"
		L["AutoInspect By Member's Change"] = "멤버 변경시 실행"
			L["When you checked this option, RaidCooldown will inspect each group members when group member is changed."] = "이 옵션을 체크하면, 파티원이나 레이드원이 추가될 때마다 살펴보기를 실행합니다."
		L["AutoInspect By Commander's Ready Check."] = "전투 준비시 실행"
			L["When you checked this option, RaidCooldown will inspect each group members when Ready check activate."] = "이 옵션을 체크하면, 전투 준비를 할 때마다 살펴보기를 실행합니다."
			
	L["KFRC_Announce_Desc"] = "|cffceff00알림 설정|r : 여러가지 종류의 알림 기능을 설정할 수 있습니다."
		L["Cooldown End Announce"] = "쿨다운 종료 알림"
			L["When cooldown is end, Add-On will announce that skill is able to cast."] = "표시된 쿨다운 바가 종료되면 자동으로 설정된 채널로 알려줍니다."
		L["Send Channel"] = "출력 채널"
			L["Announce will send this option's selected channel."] = "이 옵션에서 선택한 채널로 알림이 출력됩니다."
			L["Self"] = "자신만 보기"
			L["Say"] = "일반"
			L["Party"] = "파티말"
			L["Raid"] = "레이드"
			L["Guild"] = "길드"
			L["Officer"] = "길드관리자"
			L[" user's "] = " 님의 "
			L[" enable to cast."] = " 재사용 가능!"
		L["Intterupt Announce"] = "차단 알림"
			L["When group member interrupt enemy, Add-On will announce."] = "파티원이나 레이드멤버가 차단하면 알립니다."

	L['Right Click'] = " |cff2eb7e4우클릭"
	L['Delete this spell cooltime bar.'] = "|cffffffff해당 쿨타임 바 강제종료"
	L['Right Click + Hold Shift'] = " |cff2eb7e4Shift|cffffffff + |cff2eb7e4우클릭"
	L['Config to hide this spell all.'] = "|cffffffff주문표시 옵션 체크해제"
	L['Reset skills that have a cool time more than 5 minutes'] = "5분 이상 쿨타임을 가진 스킬들 리셋"
	
	L['Castable User'] = "|cff1784d1<<|r|cffffffff 시전 가능한 유저 |cff1784d1>>"
	L['Enable To Cast'] = "|cff2eb7e4시전 가능"
	L['Lock Display Window'] = "표시 창 |cffceff00고정"
	L['Unlock Display Window'] = "표시 창 |cffff5353고정 해제"
		
	L["Appearance Setting"] = "외형 설정"
		L["KFRC_Appearance_Bar_Desc"] = '|cffceff00쿨타임 바 설정|r : 쿨타임 바의 전반적인 외형 설정을 다룹니다.'
			L["Bar Direction"] = "바 정렬방향"
			L["Direction of cooltime bar arranging."] = "쿨타임 바가 어느 방향을 향하여 나열할지 결정합니다."
			L["Bar Height"] = "바 높이"
			L["Bar Spacing"] = "바 사이간 간격"
			L["Spacing Slider between each user's cooldown bar."] = "유저간 쿨타임 바의 간격을 조절합니다."
			L["UserName Fontsize"] = "유저이름 폰트사이즈"
		L["KFRC_Appearance_RaidIcon_Desc"] = '|cffceff00레이드 아이콘 설정|r : 주요 공대 생존기 표시 아이콘의 외형 설정을 다룹니다.'
			L["Raid Icon Size"] = "아이콘 사이즈"
			L["Raid Icon Spacing"] = "아이콘 사이 간격"
			L["Raid Icon Location"] = "아이콘 위치"
				L["choose location of raid icon."] = "메인프레임을 기준으로 레이드아이콘을 어느 방향에 위치할 건지 설정합니다."
				L['LEFTSIDE of MainFrame'] = "프레임 좌측"
				L['RIGHTSIDE of MainFrame'] = "프레임 우측"
			L["Raid Icon Direction"] = "아이콘 정렬방향"
				L["Direction of raid icon arranging."] = "아이콘이 어느 방향을 향하여 나열할지 결정합니다."
				L['UP'] = '위로 나열'
				L['DOWN'] = '아래로 나열'
				L['UPPER'] = '메인프레임 위에 나열'
				L['BELOW'] = '메인프레임 아래에 나열'
			L["Raid Icon Font Size"] = "표시 폰트 사이즈"
			L["Show Max"] = "스킬 보유수 표시"
				L["Show max number of each skills in your group in icon."] = "각 아이콘에 현재 파티가 사용할 수 있는 최대량을 표시합니다."
	
	L["Skill Setting"] = "|cffceff00스킬 설정|r |cffffffff:|r "
		L["When you checked "] = "체크된 "
		L["spell below, only checked spell will display the cooltime bar."] = "|r 주문들만 쿨타임 바로 표시합니다."
		L["Survival"] = "|cff1784d1<<|r 생존기 |cff1784d1>>"
		L["Interrupt"] = "|cff1784d1<<|r 차단기 |cff1784d1>>"
		L["Utility"] = "|cff1784d1<<|r 유틸리티 |cff1784d1>>"
		
	if not E.db.KnightFrame.RaidCooldown then E.db.KnightFrame.RaidCooldown = {} end
	
	if E.db.KnightFrame.RaidCooldown.Enable == false then
		E.Options.args.KnightFrame.args.RaidCooldown = {
			name = " - |cffceff00"..L["RaidCooldown"],
			type = "group",
			order = 11,
			disabled = function() return E.db.KnightFrame.Enable == false end,
			args = {
				Enable = {
					name = " |cffceff00"..L["RaidCooldown"].."|cffffffff "..L['Enable'],
					type = 'toggle',
					order = 1,
					get = function(info)
						return E.db.KnightFrame.RaidCooldown.Enable
					end,
					set = function(info, value)
						E.db.KnightFrame.RaidCooldown.Enable = value
						StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		}
	else
		E.Options.args.KnightFrame.args.RaidCooldown = {
			name = " - |cffceff00"..L["RaidCooldown"],
			type = "group",
			order = 11,
			disabled = function() return E.db.KnightFrame.Enable == false end,
			args = {
				Enable = {
					name = " |cffceff00"..L["RaidCooldown"].."|cffffffff "..L['Enable'],
					type = 'toggle',
					order = 1,
					get = function(info)
						return E.db.KnightFrame.RaidCooldown.Enable
					end,
					set = function(info, value)
						E.db.KnightFrame.RaidCooldown.Enable = value
						StaticPopup_Show("CONFIG_RL")
					end,
				},
				General= {
					name = "|cffffffff"..L["General"],
					type = "group",
					order = 2,
					disabled = function() return E.db.KnightFrame.Enable == false end,
					args = {
						Desc = {
							order = 1,
							type = "description",
							name = L["KFRC_Inspect_Desc"],
						},
						AutoInspect = {
							name = " |cff2eb7e4"..L["AutoInspect"],
							desc = L["When you checked this option, RaidCooldown will inspect each group members continuously at an interval of throttle option's time."],
							type = 'toggle',
							order = 2,
							get = function(info) return E.db.KnightFrame.RaidCooldown.General.AutoInspect end,
							set = function(info, value) E.db.KnightFrame.RaidCooldown.General.AutoInspect = value end,
							disabled = function() return E.db.KnightFrame.RaidCooldown.Enable == false end,
						},
						Throttle = {
							order = 3,
							type = 'range',
							name = " |cff2eb7e4"..L["Throttle"],
							desc = L["This option will affect checking members's interval. |cffceff00(second)"],
							get = function(info) return E.db.KnightFrame.RaidCooldown.General.Throttle end,
							set = function(info, value) E.db.KnightFrame.RaidCooldown.General.Throttle = value end,
							disabled = function() return E.db.KnightFrame.RaidCooldown.General.AutoInspect == false end,
							min = 10, max = 300, step = 1,
							disabled = function() return E.db.KnightFrame.RaidCooldown.Enable == false end,
						},
						AutoInspectByMembersChange = {
							name = " |cff2eb7e4"..L["AutoInspect By Member's Change"],
							desc = L["When you checked this option, RaidCooldown will inspect each group members when group member is changed."],
							type = 'toggle',
							order = 4,
							get = function(info) return E.db.KnightFrame.RaidCooldown.General.AutoInspectByMembersChange end,
							set = function(info, value) E.db.KnightFrame.RaidCooldown.General.AutoInspectByMembersChange = value end,
							disabled = function() return E.db.KnightFrame.RaidCooldown.Enable == false end,
						},
						AutoInspectByReadyCheck = {
							name = " |cff2eb7e4"..L["AutoInspect By Commander's Ready Check."],
							desc = L["When you checked this option, RaidCooldown will inspect each group members when Ready check activate."],
							type = 'toggle',
							order = 5,
							get = function(info) return E.db.KnightFrame.RaidCooldown.General.AutoInspectByReadyCheck end,
							set = function(info, value)
								E.db.KnightFrame.RaidCooldown.General.AutoInspectByReadyCheck = value
								if value == false then
									KFRC:UnregisterEvent('READY_CHECK')
								else
									KFRC:RegisterEvent('READY_CHECK', 'ForceCheck')
								end
							end,
							disabled = function() return E.db.KnightFrame.RaidCooldown.Enable == false end,
						},
						Header2 = {
							order = 50,
							type = "header",
							name = "",
						},
						Desc2 = {
							order = 51,
							type = "description",
							name = L["KFRC_Announce_Desc"],
						},
						CooldownEndAnnounceEnable = {
							name = " |cff2eb7e4"..L["Cooldown End Announce"]..' '..L["Enable"],
							desc = L["When cooldown is end, Add-On will announce that skill is able to cast."],
							type = 'toggle',
							order = 52,
							get = function(info) return E.db.KnightFrame.RaidCooldown.General.CooldownEndAnnounceEnable end,
							set = function(info, value) E.db.KnightFrame.RaidCooldown.General.CooldownEndAnnounceEnable = value end,
							disabled = function() return E.db.KnightFrame.RaidCooldown.Enable == false end,
						},
						CooldownEndAnnounceChannel = {
							name = " |cff2eb7e4"..L["Cooldown End Announce"]..' '..L["Send Channel"],
							desc = L["Announce will send this option's selected channel."],
							type = "select",
							order = 53,
							get = function(info) return E.db.KnightFrame.RaidCooldown.General.CooldownEndAnnounceChannel end,
							set = function(info, value) E.db.KnightFrame.RaidCooldown.General.CooldownEndAnnounceChannel = value end,
							values = function()
								local ChatTable = {
									L["Self"],
									L["Say"],
									L["Party"],
									L["Raid"],
									L["Guild"],
									L["Officer"],
								}
								local List = {GetChannelList()}
								for i = 1, #List/2 do
									ChatTable[i+6] = List[i*2-1]..'. '..List[i*2]
								end
								return ChatTable
							end,
							disabled = function() return E.db.KnightFrame.RaidCooldown.Enable == false or E.db.KnightFrame.RaidCooldown.General.CooldownEndAnnounceEnable == false end,
						},
						IntteruptAnnounceEnable = {
							name = " |cff2eb7e4"..L["Intterupt Announce"]..' '..L["Enable"],
							desc = L["When group member interrupt enemy, Add-On will announce."],
							type = 'toggle',
							order = 54,
							get = function(info) return E.db.KnightFrame.RaidCooldown.General.IntteruptAnnounceEnable end,
							set = function(info, value) E.db.KnightFrame.RaidCooldown.General.IntteruptAnnounceEnable = value end,
							disabled = function() return E.db.KnightFrame.RaidCooldown.Enable == false end,
						},
						IntteruptAnnounceChannel = {
							name = " |cff2eb7e4"..L["Intterupt Announce"]..' '..L["Send Channel"],
							desc = L["Announce will send this option's selected channel."],
							type = "select",
							order = 55,
							get = function(info) return E.db.KnightFrame.RaidCooldown.General.IntteruptAnnounceChannel end,
							set = function(info, value) E.db.KnightFrame.RaidCooldown.General.IntteruptAnnounceChannel = value end,
							values = function()
								local ChatTable = {
									L["Self"],
									L["Say"],
									L["Party"],
									L["Raid"],
									L["Guild"],
									L["Officer"],
								}
								local List = {GetChannelList()}
								for i = 1, #List/2 do
									ChatTable[i+6] = List[i*2-1]..'. '..List[i*2]
								end
								return ChatTable
							end,
							disabled = function() return E.db.KnightFrame.RaidCooldown.Enable == false or E.db.KnightFrame.RaidCooldown.General.IntteruptAnnounceEnable == false end,
						},
					},
				},
				Appearance = {
					name = "|cffffffff"..L["Appearance Setting"],
					type = "group",
					order = 3,
					disabled = function() return E.db.KnightFrame.RaidCooldown.Enable == false end,
					get = function(info) return E.db.KnightFrame.RaidCooldown.Appearance[ info[#info] ] end,
					set = function(info, value) E.db.KnightFrame.RaidCooldown.Appearance[ info[#info] ] = value end,
					args = {
						Desc = {
							order = 1,
							type = "description",
							name = L["KFRC_Appearance_Bar_Desc"],
						},
						barDirection = {
							order = 2,
							type = 'select',
							name = " |cff2eb7e4"..L["Bar Direction"],
							desc = L["Direction of cooltime bar arranging."],
							set = function(info, value)	E.db.KnightFrame.RaidCooldown.Appearance.barDirection = value KFRC:ChangeArea() KFRC:RearrangeBar() end,
							values = {
								L['UP'],
								L['DOWN'],
							},
						},
						barHeight = {
							order = 3,
							type = 'range',
							name = " |cff2eb7e4"..L["Bar Height"],
							set = function(info, value) E.db.KnightFrame.RaidCooldown.Appearance.barHeight = value KFRC:RearrangeBar() end,
							min = 10, max = 30, step = 1,
						},
						userNameFontsize = {
							order = 4,
							type = 'range',
							name = " |cff2eb7e4"..L["UserName Fontsize"],
							set = function(info, value) E.db.KnightFrame.RaidCooldown.Appearance.userNameFontsize = value KFRC:RearrangeBar() end,
							min = 10, max = 30, step = 1,
						},
						Header = {
							order = 5,
							type = "header",
							name = "",
						},
						Desc2 = {
							order = 6,
							type = "description",
							name = L["KFRC_Appearance_RaidIcon_Desc"],
						},
						RaidIconSize = {
							order = 7,
							type = 'range',
							name = " |cff2eb7e4"..L["Raid Icon Size"],
							--get = function(info) return E.db.KnightFrame.RaidCooldown.Appearance.RaidIconSize end,
							set = function(info, value) E.db.KnightFrame.RaidCooldown.Appearance.RaidIconSize = value KFRC:RearrangeIcon() KFRC:RearrangeBar() end,
							min = 20, max = 60, step = 1,
						},
						RaidIconSpacing = {
							order = 8,
							type = 'range',
							name = " |cff2eb7e4"..L["Raid Icon Spacing"],
							--get = function(info) return E.db.KnightFrame.RaidCooldown.Appearance.RaidIconSpacing end,
							set = function(info, value) E.db.KnightFrame.RaidCooldown.Appearance.RaidIconSpacing = value KFRC:RearrangeIcon() end,
							min = 1, max = 30, step = 1,
						},
						RaidIconLocation = {
							name = " |cff2eb7e4"..L["Raid Icon Location"],
							desc = L["choose location of raid icon."],
							type = "select",
							order = 9,
							values = {
								L['LEFTSIDE of MainFrame'],
								L['RIGHTSIDE of MainFrame'],
							},
							set = function(info, value) E.db.KnightFrame.RaidCooldown.Appearance.RaidIconLocation = value KFRC:ChangeArea() KFRC:RearrangeIcon() end,
						},
						RaidIconDirection = {
							name = " |cff2eb7e4"..L["Raid Icon Direction"],
							desc = L["Direction of raid icon arranging."],
							type = "select",
							order = 10,
							values = {
								L['UP'],
								L['DOWN'],
								L['UPPER'],
								L['BELOW'],
							},
							set = function(info, value) E.db.KnightFrame.RaidCooldown.Appearance.RaidIconDirection = value KFRC:RearrangeIcon() KFRC:RearrangeBar() end,
						},
						RaidIconFontsize = {
							order = 11,
							type = 'range',
							name = " |cff2eb7e4"..L["Raid Icon Font Size"],
							min = 10, max = 30, step = 1,
						},
						ShowMax = {
							name = " |cff2eb7e4"..L["Show Max"],
							desc = L["Show max number of each skills in your group in icon."],
							type = 'toggle',
							order = 12,
						},
					},
				},
			},
		}

		local classTable, spellIDTable, ChangeLocal = {}, {}, {}
		FillLocalizedClassList(ChangeLocal)
		for classTemp in pairs(KFRC.RaidSpell) do
			classTable[#classTable + 1] = classTemp
		end
		for i, className in pairs(classTable) do
			wipe(spellIDTable)
			for ID in pairs(KFRC.RaidSpell[className]) do
				spellIDTable[#spellIDTable + 1] = ID
			end
			local class = {
				name = L["Skill Setting"]..KF:ClassColor(className, ChangeLocal[className]),
				type = "group",
				order = 3 + i,
				disabled = function() return E.db.KnightFrame.RaidCooldown.Enable == false end,
				get = nil,
				set = nil,
				args = {
					DESC = {
						order = 1,
						type = "description",
						name = L["Skill Setting"]..L["When you checked "]..KF:ClassColor(className, ChangeLocal[className])..L["spell below, only checked spell will display the cooltime bar."],
					},
					Header = {
						order = 2,
						type = "header",
						name = L["Survival"],
					},
					Blank = {
						order = 399,
						type = "description",
						name = "|n",
					},
					Header2 = {
						order = 400,
						type = "header",
						name = L["Interrupt"],
					},
					Blank2 = {
						order = 699,
						type = "description",
						name = "|n",
					},
					Header3 = {
						order = 700,
						type = "header",
						name = L["Utility"],
					},
				},
			}
			P["KnightFrame"]["RaidCooldown"][className] = {}
			for i, spellID in pairs(spellIDTable) do
				local temp = {}
				local IsInDefaultTable = false
				local spell = {
					name = "|T"..GetSpellTexture(spellID)..":20:20:2:0|t |cff2eb7e4"..select(1, GetSpellInfo(spellID)),
					desc = function(value, event)
						KFRC:HookScript(GameTooltip, 'OnShow', function(self, ...)
							GameTooltip:SetHyperlink(GetSpellLink(spellID))
							GameTooltip:Show()
							KFRC:Unhook(GameTooltip, 'OnShow')
						end)
					end,
					type = 'toggle',
					order = (KFRC.RaidSpell[className][spellID][3] == 1 and 2 or KFRC.RaidSpell[className][spellID][3] == 2 and 400 or 700) + i,
				}
				class.args[tostring(spellID)] = spell
				for _, spell in pairs(KFRC.DefaultTrueSpell[className]) do
					if spell == spellID then
						IsInDefaultTable = true
						break
					end
				end
				if IsInDefaultTable == true then
					P["KnightFrame"]["RaidCooldown"][className][tostring(spellID)] = true
				else
					P["KnightFrame"]["RaidCooldown"][className][tostring(spellID)] = false
				end
			end
			E.Options.args.KnightFrame.args.RaidCooldown.args[className] = class
			E.Options.args.KnightFrame.args.RaidCooldown.args[className].get = function(info) return E.db.KnightFrame.RaidCooldown[className][ info[#info] ] end
			E.Options.args.KnightFrame.args.RaidCooldown.args[className].set = function(info, value) E.db.KnightFrame.RaidCooldown[className][ info[#info] ] = value KFRC:RearrangeBar() end
		end
		KFRC.DefaultTrueSpell = nil
	end
end