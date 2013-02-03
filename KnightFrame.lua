﻿--local E, L, V, P, G, _  = unpack(ElvUI)
local E, L, _, _, _, _  = unpack(ElvUI)
local KF = E:NewModule('KnightFrame', 'AceEvent-3.0', 'AceConsole-3.0')

	-----------------------------------------------------------
	-- [ Knight : Toolkit									]--
	-----------------------------------------------------------
	function KF:Color(InputText)
		return format('|cff%02x%02x%02x%s', E.media.rgbvaluecolor[1]*255, E.media.rgbvaluecolor[2]*255, E.media.rgbvaluecolor[3]*255, InputText and InputText..'|r' or '')
	end
	
	function KF:ClassColor(Class, Name)
		return format("|cff%02x%02x%02x%s", RAID_CLASS_COLORS[Class].r*255, RAID_CLASS_COLORS[Class].g*255, RAID_CLASS_COLORS[Class].b*255, Name and Name..'|r' or '')
	end

	function KF:TextSetting(self, SText, FontSize, directionH, ...)
		self.text = self:CreateFontString(nil, 'OVERLAY')
		self.text:FontTemplate(nil, FontSize, nil)
		self.text:SetJustifyH(directionH or 'CENTER')
		self.text:SetText(SText or '')
		if ... then
			self.text:Point(...)
		else
			self.text:SetPoint('CENTER')
		end
	end
	
	function KF:IfMod(SelectUI, option)
		return ((KF.db.UICustomize[option] == '0' and E.db.KnightFrame.Installed_UI_Layout == SelectUI) or KF.db.UICustomize[option] == SelectUI) and true or false
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
		KF.BossBattleStart = false
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
			for _, Contents in pairs(self.UpdateList) do
				if not Contents.LastUpdate then Contents.LastUpdate = 0 end
				if (Contents.Condition and ((type(Contents.Condition) == 'function' and Contents.Condition() == true) or (type(Contents.Condition) ~= 'function' and Contents.Condition == true))) and Contents.LastUpdate + (Contents.Delay or 5) < GetTime() then
					Contents.LastUpdate = GetTime()
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
			local CheckArst, ArstID
			KF.UpdateFrame.UpdateList.CheckArstraea = {
				['Condition'] = false,
				['Action'] = function()
					if KF.CurrentGroupMode ~= 'NoGroup' then
						for i = 1, MAX_RAID_MEMBERS do
							CheckArst, ArstID = CheckFilterForName(select(1, GetRaidRosterInfo(i)))
							if CheckArst then
								if KF.ArstraeaFind == false then
									KF.ArstraeaFind = true
									local SendChannel = KF.CurrentGroupMode
									local inInstance, instanceType = IsInInstance()
									if inInstance then
										if instanceType == 'pvp' or instanceType == 'arena' then
											SendChannel = 'battleground'
										else
											SendChannel = 'INSTANCE_CHAT'
										end
									end
									SendAddonMessage('KnightFrame', KF.AddOnName, string.upper(SendChannel))
									print(L['KF']..' : 본 애드온 제작자인 제가 |cff2eb7e4'..ArstID..'|r 아이디로 |cffceff00'..L[(SendChannel == 'INSTANCE_CHAT' and KF.CurrentGroupMode or SendChannel)]..'|r 안에 있습니다! 귓속말로 '..L['KF']..' 에 대하여 의견을 이야기해주세요.')
								end
								KF.UpdateFrame.UpdateList.CheckArstraea.Condition = false
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
						
						if sender:find(CheckingName) ~= nil then print('내친구이여서 대답안함') return end
					end
					
					if IsInGuild() then GuildRoster() end
					for guildIndex = 1, GetNumGuildMembers(true) do
						CheckingName = select(1, GetGuildRosterInfo(guildIndex))
						
						if sender:find(CheckingName) ~= nil then print('내 길드원이여서 대답안함') return end
					end
					
					for bnIndex = 1, BNGetNumFriends() do
						CheckingName = select(5, BNGetFriendInfo(bnIndex))
						CheckingName = CheckingName:match('(.+)%-.+') or CheckingName
						
						if sender:find(CheckingName) ~= nil then print('내 배넷친구여서 대답안함') return end
					end
					
					for i = 1, MAX_RAID_MEMBERS do
						CheckingName = select(1, GetRaidRosterInfo(i))
						
						if CheckingName then
							print('Sender : '..sender)
							print('CheckingName : '..CheckingName)
							print(sender == CheckingName)
							if string.find(CheckingName, '-', 1) then
								CheckingName = select(1, string.split('-', CheckingName))
							end
							
							if sender:find(CheckingName) then
								SendChatMessage('안녕하세요, '..CheckingName..' 님. '..message..' 제작자인 '..E.myname..' 입니다. (__) 사용해 주셔서 감사합니다~!', 'WHISPER', nil, sender)
							end
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