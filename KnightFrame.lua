--local E, L, V, P, G, _  = unpack(ElvUI)
local E, L, _, _, _, _  = unpack(ElvUI)
local KF = E:NewModule('KnightFrame', 'AceEvent-3.0', 'AceConsole-3.0')

	-----------------------------------------------------------
	-- [ Knight : Toolkit									]--
	-----------------------------------------------------------
	function KF:Color(InputText)
		local r, g, b = unpack(E['media'].rgbvaluecolor)
		
		return format('|cff%02x%02x%02x%s', r * 255, g * 255, b * 255, InputText and InputText..'|r' or '')
	end
	
	function KF:ClassColor(Class, Name)
		local color = RAID_CLASS_COLORS[Class]
		
		return format('|cff%02x%02x%02x%s', color.r * 255, color.g * 255, color.b * 255, Name and Name..'|r' or '')
	end

	function KF:TextSetting(self, SText, FontSize, directionH, ...)
		self.text = self:CreateFontString(nil, 'OVERLAY')
		self.text:FontTemplate(nil, FontSize or 12, nil)
		self.text:SetJustifyH(directionH or 'CENTER')
		self.text:SetText(SText)
		if ... then
			self.text:Point(...)
		else
			self.text:SetPoint('CENTER')
		end
	end
	
	function KF:IfMod(SelectUI, option)
		local CurrentOption = KF.db.UICustomize[option]
		
		return ((CurrentOption == '0' and E.db.KnightFrame.Installed_UI_Layout == SelectUI) or CurrentOption == SelectUI) and true or false
	end
	
	function KF:RegisterEventList(EventTag, InputFunction, RegistTag)
		if not KF.Memory['Event'][EventTag] then
			KF.Memory['Event'][EventTag] = {}
			KF:RegisterEvent(EventTag, function(...)
				for _, SavedFunction in pairs(KF.Memory['Event'][EventTag]) do
					SavedFunction(...)
				end
			end)
		end
		RegistTag = RegistTag or (#KF.Memory['Event'][EventTag] + 1)
		KF.Memory['Event'][EventTag][RegistTag] = InputFunction
	end
	
	
	if E.db.KnightFrame and E.db.KnightFrame.Enable ~= false and not (E.db.KnightFrame.Install_Complete == nil or E.db.KnightFrame.Install_Complete == 'NotInstalled') then
		-----------------------------------------------------------
		-- [ Knight : Start Up Setting							]--
		-----------------------------------------------------------
		KF.AddOnName = 'KnightFrame'
		KF.CurrentGroupMode = 'NoGroup'
		KF.Memory = {
			['Event'] = {},
			['Table'] = {},
			['InitializeFunction'] = {
				[1] = {},
				[2] = {},
			},
		}
		
		--KF.UIParent
		KF.UIParent = CreateFrame('Frame', 'KnightFrameUIParent', E.UIParent)
		KF.UIParent:SetPoint('TOPLEFT', E.UIParent)
		KF.UIParent:SetPoint('BOTTOMRIGHT', E.UIParent)
		
		local function ToggleKFDuringWowkemon()
			if C_PetBattles.IsInBattle() then
				KnightFrameUIParent:Hide()
			else
				KnightFrameUIParent:Show()
			end
		end
		KF:RegisterEventList('PET_BATTLE_CLOSE', ToggleKFDuringWowkemon)
		KF:RegisterEventList('PET_BATTLE_OPENING_START', ToggleKFDuringWowkemon)
		
		--KF.UpdateFrame
		KF.UpdateFrame = CreateFrame('Frame', 'KF_UpdateFrame', UIParent)
		KF.UpdateFrame.UpdateList = {
			['CollectGarbage'] = {
				['Condition'] = true,
				['Action'] = function() collectgarbage('collect') end,
			},
		}
		KF.UpdateFrame:SetScript('OnUpdate', function(self)
			local TimeNow = GetTime()
			
			for _, Contents in pairs(self.UpdateList) do
				if not Contents.LastUpdate then Contents.LastUpdate = 0 end
				if (Contents.Condition and ((type(Contents.Condition) == 'function' and Contents.Condition() == true) or (type(Contents.Condition) ~= 'function' and Contents.Condition == true))) and Contents.LastUpdate + (Contents.Delay or 5) < TimeNow then
					Contents.LastUpdate = TimeNow
					Contents.Action()
				end
			end
		end)
		
		
		-----------------------------------------------------------
		-- [ Knight : Checking AddOn Creater in group			]--
		-----------------------------------------------------------
		local Arstraea = {
			'Arstraea',
			'Arstreas',
			'Arstrita',
			'Arstrint',
			'Arstraia',
			'Arstripor',
			'Arstriv',
			'Arstrant',
			'Arstriz',
			'Arstratun',
			'Arstraea-라그나로스',
			'Arstreas-라그나로스',
			'Arstrita-라그나로스',
			'Arstrint-라그나로스',
			'Arstraia-라그나로스',
			'Arstripor-라그나로스',
			'Arstriv-라그나로스',
			'Arstrant-라그나로스',
			'Arstriz-라그나로스',
			'Arstratun-라그나로스',
		}

		local function CheckFilterForName(CheckingName)
			for _, ArstraeaID in pairs(Arstraea) do
				if ArstraeaID == CheckingName then
					return true, ArstraeaID
				end
			end
			return nil
		end

		if not select(1, CheckFilterForName(E.myname)) then
			KF.ArstraeaFind = false
			KF.UpdateFrame.UpdateList.CheckArstraea = {
				['Condition'] = false,
				['Action'] = function()
					if KF.CurrentGroupMode ~= 'NoGroup' then
						local CheckUser, CheckArst, ArstID
						
						for i = 1, MAX_RAID_MEMBERS do
							CheckUser = select(1, GetRaidRosterInfo(i))
							if CheckUser then
								CheckArst, ArstID = CheckFilterForName(CheckUser)
								if CheckArst then
									if KF.ArstraeaFind == false then
										KF.ArstraeaFind = true
										
										SendAddonMessage('KnightFrame', KF.AddOnName, 'WHISPER', ArstID)
										print(L['KF']..' : 본 애드온 제작자인 제가 |cff2eb7e4'..ArstID..'|r 아이디로 |cffceff00'..L[KF.CurrentGroupMode]..'|r 안에 있습니다! 귓속말로 '..L['KF']..' 에 대하여 의견을 이야기해주세요.')
									end
									KF.UpdateFrame.UpdateList.CheckArstraea.Condition = false
									break
								end
							else
								break
							end
						end
						if not CheckArst and KF.ArstraeaFind == true then KF.ArstraeaFind = false end
					end
				end,
			}
		else
			RegisterAddonMessagePrefix('ElvUIKFCheck')
			RegisterAddonMessagePrefix('KnightFrame')
			local function RecieveAddonMessage(event, prefix, message, distributionType, sender)
				if prefix == 'ElvUIKFCheck' or prefix == 'KnightFrame' then
					print(event..' / '..prefix..' / '..message..' / '..sender)
					if message:find(' ') then
						print(L['KF']..' : |cff2eb7e4'..sender..'|r '..message)
						if message:find('RaidCooldown') then message = 'ElvUI_KF_RaidCooldown' else message = 'KnightFrame' end
					else
						print(format(L['KF']..' : |cff2eb7e4%s|r 님은 '..KF:Color(message)..' 사용자 입니다.', sender))
					end
					
					local CheckingName
					
					if GetNumFriends() > 0 then ShowFriends() end
					for friendIndex = 1, GetNumFriends() do
						CheckingName = select(1, GetFriendInfo(friendIndex))
						if sender:find(CheckingName) ~= nil then return end
					end
					
					if IsInGuild() then GuildRoster() end
					for guildIndex = 1, GetNumGuildMembers(true) do
						CheckingName = select(1, GetGuildRosterInfo(guildIndex))
						if sender:find(CheckingName) ~= nil then return end
					end
					
					for bnIndex = 1, BNGetNumFriends() do
						CheckingName = select(5, BNGetFriendInfo(bnIndex))
						if CheckingName and sender:find(CheckingName) then return end
					end
					
					for i = 1, MAX_RAID_MEMBERS do
						CheckingName = select(1, GetRaidRosterInfo(i))
						if CheckingName and CheckingName == sender then
							if string.find(CheckingName, '-', 1) then
								CheckingName = select(1, string.split('-', CheckingName))
							end
							SendChatMessage('안녕하세요, '..CheckingName..' 님. '..message..' 제작자인 '..E.myname..' 입니다. (__) 사용해 주셔서 감사합니다~!', 'WHISPER', nil, sender)
						end
					end
				end
			end
			KF:RegisterEventList('CHAT_MSG_ADDON', RecieveAddonMessage)
		end
	elseif not E.db.KnightFrame then
		E.db.KnightFrame = {}
	end
	E:RegisterModule(KF:GetName())