--local E, L, V, P, G, _ = unpack(ElvUI)
local E, L, _, _, _, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')
	
if KF.UIParent and KF.db.Extra_Functions.Inspect.Enable ~= false then
	-----------------------------------------------------------
	-- [ Knight : Data										]--
	-----------------------------------------------------------
	local TT = E:GetModule('Tooltip')
	
	local CurrentInspectUnit
	local CurrentInspectUnitGUID
	local ReInspectCount
	
	local Check -- Check is using like temp value
	local Title, Name, Class, Realm, Level, Race, guildName, guildRankName
	local ItemCount, ItemTotal
	
	local GearData = {
		['HeadSlot'] = {},
		['NeckSlot'] = {},
		['ShoulderSlot'] = {},
		['BackSlot'] = {},
		['ChestSlot'] = {},
		['ShirtSlot'] = {},
		['TabardSlot'] = {},
		['WristSlot'] = {},
		['HandsSlot'] = {},
		['WaistSlot'] = {},
		['LegsSlot'] = {},
		['FeetSlot'] = {},
		['Finger0Slot'] = {},
		['Finger1Slot'] = {},
		['Trinket0Slot'] = {},
		['Trinket1Slot'] = {},
		['MainHandSlot'] = {},
		['SecondaryHandSlot'] = {},
	}
	local GearSetData = {}
	local SpecData = {}
	
	if not KF.Memory['Table']['ItemUpgrade'] then
		KF.Memory['Table']['ItemUpgrade'] = {
			['0'] = 0, ['1'] = 8, ['373'] = 4, ['374'] = 8, ['375'] = 4, ['376'] = 4,
			['377'] = 4, ['379'] = 4, ['380'] = 4, ['445'] = 0, ['446'] = 4, ['447'] = 8,
			['451'] = 0, ['452'] = 8, ['453'] = 0, ['454'] = 4, ['455'] = 8, ['456'] = 0,
			['457'] = 8, ['458'] = 0, ['459'] = 4, ['460'] = 8, ['461'] = 12, ['462'] = 16,
		}
	end
	
	
	-----------------------------------------------------------
	-- [ Knight : function about Setting					]--
	-----------------------------------------------------------
	local function SwitchDisplayFrame(FrameMod)
		FrameMod = FrameMod or 'Model'
		
		KnightInspectFrame.Model:Hide()
		KnightInspectFrame.Spec:Hide()
		KnightInspectFrame.PvPInfo:Hide()
		KnightInspectFrame.Button1.text:SetText((FrameMod == 'Model' and '|cffceff00' or '')..L['ShowModelFrame'])
		KnightInspectFrame.Button2.text:SetText((FrameMod == 'Spec' and '|cffceff00' or '')..L['ShowSpecializationFrame'])
		KnightInspectFrame.Button3.text:SetText((FrameMod == 'PvPInfo' and '|cffceff00' or '')..L['ShowPvPInfoFrame'])
		
		if FrameMod == 'Model' then
			for SlotName in pairs(GearData) do
				KnightInspectFrame[SlotName]['ilvl']:ClearAllPoints()
				KnightInspectFrame[SlotName]['ilvl']:SetText(GearData[SlotName]['ItemLevel'] and GearData[SlotName]['ItemLevel']..(GearData[SlotName]['IsUpgraded'] and (GearData[SlotName]['IsUpgraded'] >= 16 and '|n|cffff9614' or GearData[SlotName]['IsUpgraded'] >= 12 and '|n|cfff88ef4' or GearData[SlotName]['IsUpgraded'] >= 8 and '|n|cff2eb7e4' or GearData[SlotName]['IsUpgraded'] >= 4 and '|n|cffceff00' or '|n|cffaaaaaa')..'(+'..GearData[SlotName]['IsUpgraded']..')|r' or '') or '')
			end
			
			KnightInspectFrame['HeadSlot']['ilvl']:Point('LEFT', KnightInspectFrame['HeadSlot'], 'RIGHT', 4, 0)
			KnightInspectFrame['HeadSlot']['ilvl']:SetJustifyH('LEFT')
			KnightInspectFrame['NeckSlot']['ilvl']:Point('LEFT', KnightInspectFrame['NeckSlot'], 'RIGHT', 4, 0)
			KnightInspectFrame['NeckSlot']['ilvl']:SetJustifyH('LEFT')
			KnightInspectFrame['ShoulderSlot']['ilvl']:Point('LEFT', KnightInspectFrame['ShoulderSlot'], 'RIGHT', 4, 0)
			KnightInspectFrame['ShoulderSlot']['ilvl']:SetJustifyH('LEFT')
			KnightInspectFrame['BackSlot']['ilvl']:Point('LEFT', KnightInspectFrame['BackSlot'], 'RIGHT', 4, 0)
			KnightInspectFrame['BackSlot']['ilvl']:SetJustifyH('LEFT')
			KnightInspectFrame['ChestSlot']['ilvl']:Point('LEFT', KnightInspectFrame['ChestSlot'], 'RIGHT', 4, 0)
			KnightInspectFrame['ChestSlot']['ilvl']:SetJustifyH('LEFT')
			KnightInspectFrame['ShirtSlot']['ilvl']:Point('LEFT', KnightInspectFrame['ShirtSlot'], 'RIGHT', 4, 0)
			KnightInspectFrame['ShirtSlot']['ilvl']:SetJustifyH('LEFT')
			KnightInspectFrame['TabardSlot']['ilvl']:Point('LEFT', KnightInspectFrame['TabardSlot'], 'RIGHT', 4, 0)
			KnightInspectFrame['TabardSlot']['ilvl']:SetJustifyH('LEFT')
			KnightInspectFrame['WristSlot']['ilvl']:Point('LEFT', KnightInspectFrame['WristSlot'], 'RIGHT', 4, 0)
			KnightInspectFrame['WristSlot']['ilvl']:SetJustifyH('LEFT')
			KnightInspectFrame['HandsSlot']['ilvl']:Point('RIGHT', KnightInspectFrame['HandsSlot'], 'LEFT', -2, 0)
			KnightInspectFrame['HandsSlot']['ilvl']:SetJustifyH('RIGHT')
			KnightInspectFrame['WaistSlot']['ilvl']:Point('RIGHT', KnightInspectFrame['WaistSlot'], 'LEFT', -2, 0)
			KnightInspectFrame['WaistSlot']['ilvl']:SetJustifyH('RIGHT')
			KnightInspectFrame['LegsSlot']['ilvl']:Point('RIGHT', KnightInspectFrame['LegsSlot'], 'LEFT', -2, 0)
			KnightInspectFrame['LegsSlot']['ilvl']:SetJustifyH('RIGHT')
			KnightInspectFrame['FeetSlot']['ilvl']:Point('RIGHT', KnightInspectFrame['FeetSlot'], 'LEFT', -2, 0)
			KnightInspectFrame['FeetSlot']['ilvl']:SetJustifyH('RIGHT')
			KnightInspectFrame['Finger0Slot']['ilvl']:Point('RIGHT', KnightInspectFrame['Finger0Slot'], 'LEFT', -2, 0)
			KnightInspectFrame['Finger0Slot']['ilvl']:SetJustifyH('RIGHT')
			KnightInspectFrame['Finger1Slot']['ilvl']:Point('RIGHT', KnightInspectFrame['Finger1Slot'], 'LEFT', -2, 0)
			KnightInspectFrame['Finger1Slot']['ilvl']:SetJustifyH('RIGHT')
			KnightInspectFrame['Trinket0Slot']['ilvl']:Point('RIGHT', KnightInspectFrame['Trinket0Slot'], 'LEFT', -2, 0)
			KnightInspectFrame['Trinket0Slot']['ilvl']:SetJustifyH('RIGHT')
			KnightInspectFrame['Trinket1Slot']['ilvl']:Point('RIGHT', KnightInspectFrame['Trinket1Slot'], 'LEFT', -2, 0)
			KnightInspectFrame['Trinket1Slot']['ilvl']:SetJustifyH('RIGHT')
			KnightInspectFrame['MainHandSlot']['ilvl']:Point('BOTTOM', KnightInspectFrame['MainHandSlot'], 'TOP', 1, 3)
			KnightInspectFrame['SecondaryHandSlot']['ilvl']:Point('BOTTOM', KnightInspectFrame['SecondaryHandSlot'], 'TOP', 1, 3)
		else
			for SlotName in pairs(GearData) do
				KnightInspectFrame[SlotName]['ilvl']:ClearAllPoints()
				KnightInspectFrame[SlotName]['ilvl']:SetJustifyH('CENTER')
				KnightInspectFrame[SlotName]['ilvl']:Point('TOP', 0, -3)
				KnightInspectFrame[SlotName]['ilvl']:SetText(GearData[SlotName]['ItemLevel'] or '')
			end
		end
		
		KF.db.Extra_Functions.Inspect.DisplayPage = FrameMod
		KnightInspectFrame[FrameMod]:Show()
	end
	
	
	local function ClearCache()
		ClearInspectPlayer()
		
		Title = nil
		Name = nil
		Class = nil
		Realm = nil
		Level = nil
		Race = nil
		guildName = nil
		guildRankName = nil
		CurrentInspectUnit = nil
		CurrentInspectUnitGUID = nil
		
		for SlotName in pairs(GearData) do
			GearData[SlotName] = {}
		end
		GearSetData = {}
		SpecData = {}
		
		KF.UpdateFrame.UpdateList.NotifyInspect.Condition = false
		if KF.Memory['Event']['INSPECT_READY'] then
			KF.Memory['Event']['INSPECT_READY']['KnightInspect'] = nil
		end
	end
	
	
	-----------------------------------------------------------
	-- [ Knight : function about Inspect 					]--
	-----------------------------------------------------------
	KF.UpdateFrame.UpdateList.NotifyInspect = {
		['Condition'] = false,
		['Delay'] = 1,
		['Action'] = function()
			if UnitGUID(CurrentInspectUnit) ~= CurrentInspectUnitGUID then
				if CurrentInspectUnit == 'mouseover' then print(L['KF']..' : '..L['Mouseover Inspect is canceled because cursor left user to inspect.']) end
				
				ClearCache()
				return
			end
			NotifyInspect(CurrentInspectUnit)
		end,
	}
	
	KF:RegisterEventList('INSPECT_HONOR_UPDATE', function()
		local teamName, teamSize, teamRating, teamPlayed, teamWins, playerPlayed, playerRating, emblem
		local teamData = { [1] = {}, [2] = {}, [3] = {}, }
		local background = {}
		local borderColor = {}
		local emblemColor = {}
		
		playerRating, playerPlayed, teamWins = GetInspectRatedBGData()
		if playerPlayed then
			KnightInspectFrame.PvPInfo.RatedBG.Record:SetText(format(PVP_RECORD..' |cff93daff%s|cffff5675%s|r', teamWins and teamWins..'|r / ' or '|r', playerPlayed and playerPlayed - teamWins or ''))
			KnightInspectFrame.PvPInfo.RatedBG.Rating:SetText(format(RATING..' : |cffffe65a%d|r', playerRating))
		end
		
		if Realm ~= '' then
			-- 다른서버 사람은 투기장 읽기가 안됨!
		else
			for i = 1, MAX_ARENA_TEAMS do
				if UnitIsUnit(CurrentInspectUnit, 'player') then
					teamName, teamSize, teamRating, _, _, teamPlayed, teamWins, _, playerPlayed, teamRank, playerRating, background.r, background.g, background.b, emblem, emblemColor.r, emblemColor.g, emblemColor.b, _, borderColor.r, borderColor.g, borderColor.b = GetArenaTeam(i)
				else
					teamName, teamSize, teamRating, teamPlayed, teamWins, playerPlayed, playerRating, background.r, background.g, background.b, emblem, emblemColor.r, emblemColor.g, emblemColor.b, _, borderColor.r, borderColor.g, borderColor.b = GetInspectArenaTeamData(i)
				end
				
				if teamName then
					local frameNum
					if teamSize == 2 then
						frameNum = 1
					elseif teamSize == 3 then
						frameNum = 2
					elseif teamSize == 5 then
						frameNum = 3
					end
					
					teamData[frameNum]['teamName'] = teamName
					teamData[frameNum]['teamRating'] = teamRating
					teamData[frameNum]['teamPlayed'] = teamPlayed
					teamData[frameNum]['teamWins'] = teamWins
					teamData[frameNum]['teamLoss'] = teamPlayed - teamWins
					
					KnightInspectFrame.PvPInfo.Arena['Banner'..frameNum]:SetBackdropColor(0.21, 0.21, 0.21)
					KnightInspectFrame.PvPInfo.Arena['Banner'..frameNum].texture:SetVertexColor(background.r, background.g, background.b)
					KnightInspectFrame.PvPInfo.Arena['BannerBorder'..frameNum].texture:SetVertexColor(borderColor.r, borderColor.g, borderColor.b)
					KnightInspectFrame.PvPInfo.Arena['Emblem'..frameNum]:SetTexture('Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-'..emblem)
					KnightInspectFrame.PvPInfo.Arena['Emblem'..frameNum]:SetVertexColor(emblemColor.r, emblemColor.g, emblemColor.b)
					KnightInspectFrame.PvPInfo.Arena['Rating'..frameNum]:SetText('|cffffe65a'..playerRating)
				end
			end
		end
		
		for i = 1, MAX_ARENA_TEAMS do
			if not teamData[i]['teamName'] then
				KnightInspectFrame.PvPInfo.Arena['Banner'..i]:SetBackdropColor(0.12, 0.12, 0.12)
				KnightInspectFrame.PvPInfo.Arena['Banner'..i].texture:SetVertexColor(0.1, 0.1, 0.1)
				KnightInspectFrame.PvPInfo.Arena['BannerBorder'..i].texture:SetVertexColor(0.15, 0.15, 0.15)
				KnightInspectFrame.PvPInfo.Arena['Emblem'..i]:SetTexture(nil)
				KnightInspectFrame.PvPInfo.Arena['Emblem'..i]:SetVertexColor(0.1, 0.1, 0.1)
				KnightInspectFrame.PvPInfo.Arena['Rating'..i]:SetText(nil)
			end
		end
		
		KnightInspectFrame.PvPInfo.Arena['TeamName1']:SetText(teamData[1]['teamName'] and ' |cff93daff2vs2|r  '..teamData[1]['teamName'] or ' ')
		KnightInspectFrame.PvPInfo.Arena['TeamName2']:SetText(teamData[2]['teamName'] and ' |cff93daff3vs3|r  '..teamData[2]['teamName'] or ' ')
		KnightInspectFrame.PvPInfo.Arena['TeamName3']:SetText(teamData[3]['teamName'] and ' |cff93daff5vs5|r  '..teamData[3]['teamName'] or ' ')
		KnightInspectFrame.PvPInfo.Arena.TeamRating:SetText(format('|cffffe65a%s|n%s|n%s', teamData[1]['teamRating'] or '', teamData[2]['teamRating'] or '', teamData[3]['teamRating'] or ''))
		KnightInspectFrame.PvPInfo.Arena.TeamRecord:SetText(format('|cff93daff%s|cffff5675%s|r|n|cff93daff%s|cffff5675%s|r|n|cff93daff%s|cffff5675%s|r', teamData[1]['teamWins'] and teamData[1]['teamWins']..'|r / ' or '|r', teamData[1]['teamLoss'] or '', teamData[2]['teamWins'] and teamData[2]['teamWins']..'|r / ' or '|r', teamData[2]['teamLoss'] or '', teamData[3]['teamWins'] and teamData[3]['teamWins']..'|r / ' or '|r', teamData[3]['teamLoss'] or ''))
	end)
	
	local function INSPECT_READY(_, GUID)
		if CurrentInspectUnitGUID == GUID and UnitExists(CurrentInspectUnit) then
			do --<< Inspect Unit's Information Setting >>--
				_, _, Race, _, _, Name, Realm = GetPlayerInfoByGUID(GUID)				
				KnightInspectFrame.UnitTag:SetText((Realm ~= '' and Realm..L[" Server's "] or '')..'|cff93daff'..(string.gsub(Title, Name, '') or ''))
				KnightInspectFrame.UnitName:SetText(KF:ClassColor(Class, Name))
				KnightInspectFrame.LevelRace:SetText(format('|cff%02x%02x%02x%s|r '..LEVEL..'|n%s',
					(GetQuestDifficultyColor(Level).r) * 255,
					(GetQuestDifficultyColor(Level).g) * 255,
					(GetQuestDifficultyColor(Level).b) * 255, Level, Race))
				KnightInspectFrame.Guild:SetText(guildName and '<|cff2eb7e4'..guildName..'|r>  [|cff2eb7e4'..guildRankName..'|r]' or '')
			end
			
			do --<< Inspect Unit's Gear Data Setting >>--
				ItemCount, ItemTotal, GetTexture = 0, 0, false
				
				for SlotName in pairs(GearData) do
					local SlotNumber, EmptyTexture, _ = GetInventorySlotInfo(SlotName)
					local r, g, b = GetItemQualityColor(0)
					
					
					--Clean Itemlvl Cache
					GearData[SlotName]['ItemLevel'] = nil
					GearData[SlotName]['IsUpgraded'] = nil
					KnightInspectFrame[SlotName]['ilvl']:SetText('')
					
					if not GearData[SlotName]['Link'] then
						GearData[SlotName]['Link'] = GetInventoryItemLink(CurrentInspectUnit, SlotNumber) or false
					end
					
					Check = GetInventoryItemTexture(CurrentInspectUnit, SlotNumber) -- Item Texture
					KnightInspectFrame[SlotName]['Texture']:SetTexture(Check or EmptyTexture)
					
					if Check and Check..'.blp' ~= EmptyTexture then
						if GearData[SlotName]['Link'] == false then
							ItemCount = ItemCount - 50 -- means do Inspect again.
						else
							GetTexture = true
							
							--Calc Item Level
							_, _, Check, GearData[SlotName]['ItemLevel'], _, _, _, _, _, _, _ = GetItemInfo(GearData[SlotName]['Link'])
  
							if Check then -- Item Rarity
								r, g, b = GetItemQualityColor(Check)
							end
							
							Check = GearData[SlotName]['Link']:match(':(%d+)\124h%[') or nil -- Item Upgrade ID
							
							if GearData[SlotName]['ItemLevel'] then
								if not (SlotName == 'ShirtSlot' or SlotName == 'TabardSlot') then
									ItemCount = ItemCount + 1
									if tonumber(Check) > 0 then
										GearData[SlotName]['IsUpgraded'] = KF.Memory['Table']['ItemUpgrade'][Check]
										GearData[SlotName]['ItemLevel'] = GearData[SlotName]['ItemLevel'] + GearData[SlotName]['IsUpgraded']
									end
									
									ItemTotal = ItemTotal + GearData[SlotName]['ItemLevel']
								end
							end
							
							
							--Check Gear's Set Name and prepare data for colorizing tooltip because this addon can't preserve GameTooltip's SetInventoryItem() so tooltip can't display situation of set gear wearing.
							KnightInspectToolTip:ClearLines()
							KnightInspectToolTip:SetInventoryItem(CurrentInspectUnit, SlotNumber)
							
							local r, g, b, CheckGearSet, GearSetCount, GearSetMax
							for i = 1, KnightInspectToolTip:NumLines() do
								CheckGearSet, GearSetCount, GearSetMax = _G['KnightInspectToolTipTextLeft'..i]:GetText():match('^(.+) %((%d)/(%d)%)$') -- find string likes 'SetName (0/5)'
								
								if CheckGearSet then
									--print('세트이름 : '..CheckGearSet..'  ('..GearSetCount..'/'..GearSetMax..')')
									GearSetCount = tonumber(GearSetCount)
									GearSetMax = tonumber(GearSetMax)
									
									if not GearSetData[CheckGearSet] then
										GearSetData[CheckGearSet] = { ['SetBonus'] = {}, ['Num'] = { ['Count'] = 0, }, }
										ItemCount = ItemCount - 50 -- means do Inspect again.
									elseif GearSetMax == 0 or GearSetMax == 1 or GearSetMax < GearSetCount then
										ItemCount = ItemCount - 50 -- means do Inspect again.
									end
									
									GearSetData[CheckGearSet]['Num']['Text'] = GearSetCount
									if not GearSetData[CheckGearSet]['Num'][SlotName] then
										GearSetData[CheckGearSet]['Num'][SlotName] = true
										GearSetData[CheckGearSet]['Num']['Count'] = GearSetData[CheckGearSet]['Num']['Count'] + 1
									end
									
									local tempText, CheckSpace, SetBonusLine = nil, 2, 1
									for k = 1, KnightInspectToolTip:NumLines() do
										tempText = _G['KnightInspectToolTipTextLeft'..(i+k)]:GetText()
										
										if tempText == ' ' then
											CheckSpace = CheckSpace - 1
											if CheckSpace == 0 then break end
										elseif CheckSpace == 2 then
											r, g, b, _ = _G['KnightInspectToolTipTextLeft'..(i+k)]:GetTextColor()
											GearSetData[CheckGearSet][k] = format('|cff%02x%02x%02x%s', r * 255, g * 255, b * 255, tempText)
										elseif CheckSpace == 1 then
											r, g, b, _ = _G['KnightInspectToolTipTextLeft'..(i+k)]:GetTextColor()
											GearSetData[CheckGearSet]['SetBonus'][SetBonusLine] = format('|cff%02x%02x%02x%s', r * 255, g * 255, b * 255, tempText)
											SetBonusLine = SetBonusLine + 1
										end
									end
									break
								end
							end
						end
					end
					KnightInspectFrame[SlotName]:SetBackdropBorderColor(r, g, b)
				end
				for CheckGearSet in pairs(GearSetData) do
					if GearSetData[CheckGearSet]['Num']['Text'] ~= GearSetData[CheckGearSet]['Num']['Count'] then
						ItemCount = ItemCount - 50 -- means do Inspect again.
					end
				end
				
				
				-- ReInspect when there is no gear or crashed inspect data.
				if ItemCount <= 0 and ReInspectCount > 0 then
					if GetTexture == false then
						ReInspectCount = ReInspectCount - 1
					end
					print('Return ------------------------')
					return
				elseif ReInspectCount == 0 then
					KnightInspectFrame.Model.text:SetText(L['This is not a inspect bug.|nI think this user is not wearing any gears.'])
				else
					KnightInspectFrame.Model.text:SetText('')
				end
				KnightInspectFrame.BP.text:SetText(string.format('|cffceff00'..L['Average']..'|r : %.2f', (ItemCount > 0 and ItemTotal/ItemCount or 0)))
			end
			
			do --<< Inspect Unit's Specialization Setting >>--			
				Check = GetInspectSpecialization(CurrentInspectUnit)
				
				if Check ~= nil and Check > 0 then
					_, SpecData['CurrentSpec'], _, Check, _, _, _ = GetSpecializationInfoByID(Check)
					KnightInspectFrame.SpecIcon['Texture']:SetTexture(Check)
					
					if SpecData['CurrentSpec'] then
						Check = KF.Memory['Table']['ClassRole'][Class][SpecData['CurrentSpec']]['Rule']
						KnightInspectFrame.RoleTag:SetText((Check == 'Tank' and '|TInterface\\AddOns\\ElvUI\\media\\textures\\tank.tga:14:14:0:1|t' or Check == 'Healer' and '|TInterface\\AddOns\\ElvUI\\media\\textures\\healer.tga:14:14:0:0|t' or '|TInterface\\AddOns\\ElvUI\\media\\textures\\dps.tga:14:14:0:-1|t')..KF.Memory['Table']['ClassRole'][Class][SpecData['CurrentSpec']]['ClassColor']..SpecData['CurrentSpec'])
					end
				else
					KnightInspectFrame.SpecIcon['Texture']:SetTexture(nil)
					KnightInspectFrame.RoleTag:SetText('|cffff0000'..L['NoTalent'])
					KnightInspectFrame.Spec.text:SetText('|cffceff00■|r '..SPECIALIZATION..' : |cffff0000'..L['NoTalent'])
				end
				
				for i = 1, 18 do -- Talents COMPLETE
					local _, _, UnitClassID = UnitClass(CurrentInspectUnit)
					local CurrentLevelTab = ceil(i/3)
					
					if Level >= CurrentLevelTab * 15 then
						KnightInspectFrame.Spec['TalentGroup'..CurrentLevelTab]['Level'].text:SetText('|cffceff00'..(CurrentLevelTab * 15))
					else
						KnightInspectFrame.Spec['TalentGroup'..CurrentLevelTab]['Level'].text:SetText('|cffff0000'..(CurrentLevelTab * 15))
					end
					
					local talentName, talentTexture, _, _, isSelected, _ = GetTalentInfo(i, true, nil, CurrentInspectUnit, UnitClassID)
					SpecData['Talent'..i] = GetTalentLink(i, true, UnitClassID)
					
					KnightInspectFrame.Spec['Talent'..i].Icon['Texture']:SetTexture(talentTexture)
					
					if isSelected then
						KnightInspectFrame.Spec['Talent'..i].Icon['Texture']:SetAlpha(1)
						KnightInspectFrame.Spec['Talent'..i]:SetBackdropColor(0.8, 0.8, 0.8)
					else
						KnightInspectFrame.Spec['Talent'..i].Icon['Texture']:SetAlpha(0.2)
						if Level >= CurrentLevelTab * 15 then
							KnightInspectFrame.Spec['Talent'..i]:SetBackdropColor(0.2, 0.2, 0.2)
						else
							KnightInspectFrame.Spec['Talent'..i]:SetBackdropColor(0.3, 0, 0)
						end
					end
				end
				
				for i = 1, 6 do -- Glyphs COMPLETE
					local GlyphTexture
					local GlyphSocketLevel = ceil(i/2) * 25
					
					_, _, _, _, GlyphTexture, SpecData['Glyph'..i] = GetGlyphSocketInfo(i, nil, true, CurrentInspectUnit)
					
					KnightInspectFrame.Spec['Glyph'..i].Icon['Texture']:SetTexture(GlyphTexture)
					
					if SpecData['Glyph'..i] then
						SpecData['Glyph'..i] = GetGlyphLinkByID(SpecData['Glyph'..i])
						
						KnightInspectFrame.Spec['Glyph'..i]['Level'].text:SetText('|cffceff00'..GlyphSocketLevel..'|r')
						KnightInspectFrame.Spec['Glyph'..i]:SetBackdropColor(0.8, 0.8, 0.8)
					else
						if Level >= GlyphSocketLevel then
							KnightInspectFrame.Spec['Glyph'..i]['Level'].text:SetText('|cffceff00'..GlyphSocketLevel..'|r')
							KnightInspectFrame.Spec['Glyph'..i]:SetBackdropColor(0.8, 0.8, 0.8)
						else
							KnightInspectFrame.Spec['Glyph'..i]['Level'].text:SetText('|cffff0000'..GlyphSocketLevel..'|r')
							KnightInspectFrame.Spec['Glyph'..i]:SetBackdropColor(0.3, 0, 0)
						end
					end
				end
			end
			
			do --<< Inspect Unit's PvP Information Setting >>--
				RequestInspectHonorData()
			end
			
			PlaySound('igCharacterInfoOpen')
			KnightInspectFrame:Show()
			KnightInspectFrame.Model:SetUnit(CurrentInspectUnit)
			SwitchDisplayFrame(KF.db.Extra_Functions.Inspect.DisplayPage)
			
			local TimeWhenInspectOver = floor(GetTime())
			
			Check = nil
			for _, inspectCache in ipairs(TT.InspectCache) do
				if inspectCache.GUID == GUID then
					inspectCache.ItemLevel = ItemCount > 0 and ItemTotal/ItemCount or 0
					inspectCache.TalentSpec = SpecData['CurrentSpec']
					inspectCache.LastUpdate = TimeWhenInspectOver
					Check = true
					break
				end
			end

			if not Check then
				TT.InspectCache[#TT.InspectCache + 1] = {
					['GUID'] = GUID,
					['ItemLevel'] = ItemCount > 0 and ItemTotal/ItemCount or 0,
					['TalentSpec'] = SpecData['CurrentSpec'],
					['LastUpdate'] = TimeWhenInspectOver,
				}
			end
			
			if TargetAuraTracker and select(1, UnitName('target')) == Name then
				TopPanel.LocationY.text:SetText(floor(ItemCount > 0 and ItemTotal/ItemCount or 0))
				KF.Memory['Event']['INSPECT_READY']['TargetAuraTracker_ItemLevel'] = nil
			end
			
			KF.UpdateFrame.UpdateList.NotifyInspect.Condition = false
			KF.Memory['Event']['INSPECT_READY']['KnightInspect'] = nil
		end
	end
	
	
	function KF:Test()
		PrintTable(GearSetData)
	
	
	end
	
	
	
	-----------------------------------------------------------
	-- [ Knight : Redifine 									]--
	-----------------------------------------------------------
	InspectUnit = function(unit)
		if not UnitExists('mouseover') and UnitExists('target') then unit = 'target' end
		
		if not UnitIsPlayer(unit) or not CanInspect(unit) then return
		elseif UnitIsDeadOrGhost('player') then
			print(L['KF']..' : '..L["You can't inspect while dead."])
		else
			--Change UnitID
			if unit == 'mouseover' then
				if UnitIsUnit(unit, 'target') then
					unit = 'target'
				elseif UnitIsUnit(unit, 'focus') then
					unit = 'focus'
				else
					Check = GetMouseFocus()
					unit = Check and Check:GetAttribute('unit') or unit
				end
			end
			if IsInGroup() and (unit == 'mouseover' or unit == 'target' or unit == 'focus') then
				for i = 1, MAX_RAID_MEMBERS do
					Check = (IsInRaid() and 'raid' or 'party')..i
					if UnitExists(Check) and UnitIsUnit(unit, Check) then
						unit = Check
						break
					elseif not UnitExists(Check) then
						break
					end
				end
			end
			
			KnightInspectFrame:Hide()
			ClearCache()
			
			CurrentInspectUnit = unit
			CurrentInspectUnitGUID = UnitGUID(unit)
			ReInspectCount = 2
			
			Title = UnitPVPName(unit)
			Class = select(2, UnitClass(unit))
			Level = UnitLevel(unit)
			guildName, guildRankName, _ = GetGuildInfo(unit)
			
			if E.private['tooltip'].enable ~= false then
				TT.UpdateInspect:Hide()
				TT:RegisterEvent('INSPECT_READY')
			end
			
			--Do Inspect!!
			KF.UpdateFrame.UpdateList.NotifyInspect.Condition = true
			KF:RegisterEventList('INSPECT_READY', INSPECT_READY, 'KnightInspect')
			print(L['KF']..' : '..KF:ClassColor(Class, GetUnitName(unit))..L[" Inspect. Sometimes this work will take few second by waiting server's response."]..(unit == 'mouseover' and ' '..L['Mouseover Inspect needs to freeze mouse moving until inspect is over.'] or ''))
		end
	end
	
	function TT:Inspect_OnUpdate(elapsed)
		self.nextUpdate = (self.nextUpdate - elapsed);
		if (self.nextUpdate <= 0) then
			self:Hide();
			if UnitGUID('mouseover') == TT.currentGUID and not TT:IsInspectFrameOpen() and KF.UpdateFrame.UpdateList.NotifyInspect.Condition == false then
				TT.lastInspectRequest = GetTime();
				TT:RegisterEvent('INSPECT_READY');
				NotifyInspect(TT.currentUnit);
			end
		end
	end
	
	function TT:GetItemLvL(unit)
		local total, item = 0, 0

		for SlotName in pairs(GearData) do
			local slot = GetInventoryItemLink(unit, select(1, GetInventorySlotInfo(SlotName)))
			if (slot ~= nil) then
				local _, _, _, ilvl = GetItemInfo(slot)
				local IsUpgraded = slot:match(':(%d+)\124h%[') or nil
				
				if ilvl ~= nil and not (SlotName == 'ShirtSlot' or SlotName == 'TabardSlot') then
					item = item + 1
					
					if IsUpgraded then
						ilvl = ilvl + KF.Memory['Table']['ItemUpgrade'][IsUpgraded]
					end
					
					total = total + ilvl
				end
			end
		end
		if (total < 1 or item < 1) then
			return 0
		end
		
		return floor(total / item);
	end
	
	function TT:INSPECT_READY(event, GUID)
		local ilvl = TT:GetItemLvL('mouseover')
		local talentSpec = TT:GetTalentSpec('mouseover')
		local curTime = GetTime()
		local matchFound
		for index, inspectCache in ipairs(self.InspectCache) do
			if inspectCache.GUID == GUID then
				inspectCache.ItemLevel = ilvl
				inspectCache.TalentSpec = talentSpec
				inspectCache.LastUpdate = floor(curTime)
				matchFound = true
				break
			end
		end

		if not matchFound then
			local GUIDInfo = {
				['GUID'] = GUID,
				['ItemLevel'] = ilvl,
				['TalentSpec'] = talentSpec,
				['LastUpdate'] = floor(curTime)
			}	
			self.InspectCache[#self.InspectCache + 1] = GUIDInfo
		end
		
		if #self.InspectCache > 40 then
			table.remove(self.InspectCache, 1)
		end

		GameTooltip:SetUnit('mouseover')
		
		--delete ClearInspectPlayer() because KnightInspect is working for getting HonorData
		self:UnregisterEvent('INSPECT_READY')
	end

	-----------------------------------------------------------
	-- [ Knight : Initialize KnightInspectFrame				]--
	-----------------------------------------------------------
	local PANEL_HEIGHT = 22
	local SIDE_BUTTON_WIDTH = 16
	local SPACING = 3
	
	
	do	
		do --<< KnightInspectFrame >>--
			CreateFrame('Frame', 'KnightInspectFrame', E.UIParent)
			KnightInspectFrame:Size(350,450)
			KnightInspectFrame:CreateBackdrop('Transparent')
			KnightInspectFrame:SetFrameStrata('DIALOG')
			KnightInspectFrame:SetFrameLevel(10)
			KnightInspectFrame:SetMovable(true)
			KnightInspectFrame:Hide()
			KnightInspectFrame:SetScript('OnHide', function()
				PlaySound('igCharacterInfoClose')
				ClearCache()
			end)
			KF.Memory['InitializeFunction'][1]['KnightInspectFrame'] = KF.db.Extra_Functions['Inspect']['Location']
			KF.Memory['InitializeFunction'][2]['KnightInspectFrame'] = function() KnightInspectFrameMover:SetFrameLevel(15) end
			tinsert(UISpecialFrames, 'KnightInspectFrame')
			
			--<< KnightInspectFrame : Tab >>--
			KnightInspectFrame.Tab = CreateFrame('Frame', nil, KnightInspectFrame)
			KnightInspectFrame.Tab:Point('TOPLEFT', KnightInspectFrame, SPACING, -SPACING)
			KnightInspectFrame.Tab:Point('BOTTOMRIGHT', KnightInspectFrame, 'TOPRIGHT', -SPACING, -(SPACING + PANEL_HEIGHT))
			KnightInspectFrame.Tab:SetBackdrop({
				bgFile = E['media'].blankTex,
				edgeFile = E['media'].blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KnightInspectFrame.Tab:SetBackdropColor(0.2, 0.2, 0.2)
			KnightInspectFrame.Tab:SetBackdropBorderColor(unpack(E['media'].bordercolor))
			KF:TextSetting(KnightInspectFrame.Tab, '■ |cff2eb7e4Knight Inspect', 10, 'LEFT', 'LEFT', 6, 1)
			KnightInspectFrame.Tab:SetScript('OnMouseDown', function() if KnightInspectFrame:IsShown() then KnightInspectFrame:StartMoving() end end)
			KnightInspectFrame.Tab:SetScript('OnMouseUp', function()
				if KnightInspectFrame:IsShown() then
					KnightInspectFrame:StopMovingOrSizing()
					local point, _, secondaryPoint, x, y = KnightInspectFrame:GetPoint()
					KnightInspectFrameMover:ClearAllPoints()
					KnightInspectFrameMover:Point(point, E.UIParent, secondaryPoint, x, y)
					E:SaveMoverPosition('KnightInspectFrameMover')
					KnightInspectFrame:Point('TOPLEFT', KnightInspectFrameMover)
					KnightInspectFrame:Point('BOTTOMRIGHT', KnightInspectFrameMover)
				end
			end)
			KnightInspectFrame.Tab.Close = CreateFrame('Button', nil, KnightInspectFrame.Tab)
			KnightInspectFrame.Tab.Close:Size(PANEL_HEIGHT - 8)
			KnightInspectFrame.Tab.Close:SetTemplate('Default', true)
			KnightInspectFrame.Tab.Close:Point('RIGHT', -4, 0)
			KF:TextSetting(KnightInspectFrame.Tab.Close, 'X', 13, nil, 'CENTER', 1, 0)
			KnightInspectFrame.Tab.Close:SetScript('OnEnter', function(self) self:SetBackdropBorderColor(unpack(E['media'].rgbvaluecolor)) end)
			KnightInspectFrame.Tab.Close:SetScript('OnLeave', function(self) self:SetBackdropBorderColor(unpack(E['media'].bordercolor)) end)
			KnightInspectFrame.Tab.Close:SetScript('OnClick', function() KnightInspectFrame:Hide() end)
			
			--<< KnightInspectFrame : Bottom Panel >>--
			KnightInspectFrame.BP = CreateFrame('Frame', nil, KnightInspectFrame)
			KnightInspectFrame.BP:Point('TOPLEFT', KnightInspectFrame, 'BOTTOMLEFT', SPACING, SPACING + PANEL_HEIGHT)
			KnightInspectFrame.BP:Point('BOTTOMRIGHT', KnightInspectFrame, -SPACING, SPACING)
			KnightInspectFrame.BP:SetBackdrop({
				bgFile = E['media'].blankTex,
				edgeFile = E['media'].blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KnightInspectFrame.BP:SetBackdropColor(0.2, 0.2, 0.2)
			KnightInspectFrame.BP:SetBackdropBorderColor(unpack(E['media'].bordercolor))
			KnightInspectFrame.BP:SetFrameLevel(12)
			KF:TextSetting(KnightInspectFrame.BP, '', 10, 'LEFT', 'LEFT', 4, 1)
			
			--<< KnightInspectFrame : Specialization Icon >>--
			KnightInspectFrame.SpecIcon = CreateFrame('Frame', nil, KnightInspectFrame)
			KnightInspectFrame.SpecIcon:Size(44)
			KnightInspectFrame.SpecIcon:SetTemplate('Default', true)
			KnightInspectFrame.SpecIcon['Texture'] = KnightInspectFrame.SpecIcon:CreateTexture(nil, 'OVERLAY')
			KnightInspectFrame.SpecIcon['Texture']:SetTexCoord(unpack(E.TexCoords))
			KnightInspectFrame.SpecIcon['Texture']:SetInside()
			KnightInspectFrame.SpecIcon:Point('TOPRIGHT', KnightInspectFrame.Tab, 'BOTTOMRIGHT', -8, -13)
		end
		
		
		do --<< Information Text >>--
			KnightInspectFrame.UnitTag = KnightInspectFrame:CreateFontString(nil, 'OVERLAY')
			KnightInspectFrame.UnitTag:FontTemplate(nil, 9, 'OUTLINE')
			KnightInspectFrame.UnitTag:SetJustifyH('LEFT')
			KnightInspectFrame.UnitTag:Point('TOPLEFT', KnightInspectFrame.Tab, 'BOTTOMLEFT', 6, -9)
			
			KnightInspectFrame.UnitName = KnightInspectFrame:CreateFontString(nil, 'OVERLAY')
			KnightInspectFrame.UnitName:FontTemplate(nil, 22, 'OUTLINE')
			KnightInspectFrame.UnitName:SetJustifyH('LEFT')
			KnightInspectFrame.UnitName:Point('TOPLEFT', KnightInspectFrame.Tab, 'BOTTOMLEFT', 5, -22)
			
			KnightInspectFrame.LevelRace = KnightInspectFrame:CreateFontString(nil, 'OVERLAY')
			KnightInspectFrame.LevelRace:FontTemplate(nil, 10, nil)
			KnightInspectFrame.LevelRace:SetJustifyH('LEFT')
			KnightInspectFrame.LevelRace:Point('BOTTOMLEFT', KnightInspectFrame.UnitName, 'BOTTOMRIGHT', 5, 1)
			
			KnightInspectFrame.RoleTag = KnightInspectFrame:CreateFontString(nil, 'OVERLAY')
			KnightInspectFrame.RoleTag:FontTemplate(nil, 12, 'OUTLINE')
			KnightInspectFrame.RoleTag:SetJustifyH('CENTER')
			KnightInspectFrame.RoleTag:Point('TOP', KnightInspectFrame.SpecIcon, 'BOTTOM', 0, -1)
			
			KnightInspectFrame.Guild = KnightInspectFrame:CreateFontString(nil, 'OVERLAY')
			KnightInspectFrame.Guild:FontTemplate(nil, 10, nil)
			KnightInspectFrame.Guild:SetJustifyH('LEFT')
			KnightInspectFrame.Guild:Point('TOPLEFT', KnightInspectFrame.UnitName, 'BOTTOMLEFT', 2, -9)
			KnightInspectFrame.Guild:Point('BOTTOMRIGHT', KnightInspectFrame.RoleTag, 'BOTTOMLEFT', -3, 0)
		end
		
		
		do --<< Create Slot Frame >>--
			CreateFrame('GameTooltip', 'KnightInspectToolTip', nil, 'GameTooltipTemplate')
			KnightInspectToolTip:SetOwner(UIParent, 'ANCHOR_NONE')
		
			for SlotName in pairs(GearData) do
				KnightInspectFrame[SlotName] = CreateFrame('Button', nil, KnightInspectFrame)
				KnightInspectFrame[SlotName]:SetTemplate('Default', true)
				KnightInspectFrame[SlotName]:Size(37)
				KnightInspectFrame[SlotName]:SetFrameLevel(14)
				KnightInspectFrame[SlotName]['Texture'] = KnightInspectFrame[SlotName]:CreateTexture(nil, 'OVERLAY')
				KnightInspectFrame[SlotName]['Texture']:SetTexCoord(unpack(E.TexCoords))
				KnightInspectFrame[SlotName]['Texture']:SetInside()
				KnightInspectFrame[SlotName]['hover'] = KnightInspectFrame[SlotName]:CreateTexture('Frame', nil, self)
				KnightInspectFrame[SlotName]['hover']:SetInside()
				KnightInspectFrame[SlotName]['hover']:SetTexture(1, 1, 1, 0.3)
				KnightInspectFrame[SlotName]['ilvl'] = KnightInspectFrame[SlotName]:CreateFontString(nil, 'OVERLAY')
				KnightInspectFrame[SlotName]['ilvl']:FontTemplate(nil, 12, 'OUTLINE')
				KnightInspectFrame[SlotName]:SetHighlightTexture(KnightInspectFrame[SlotName]['hover'])
				
				KnightInspectFrame[SlotName]:SetScript('OnClick', function(self)
					HandleModifiedItemClick(GearData[SlotName]['Link'])
				end)
				KnightInspectFrame[SlotName]:SetScript('OnEnter', function(self)
					if GearData[SlotName]['Link'] ~= false then
						GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
						GameTooltip:SetHyperlink(GearData[SlotName]['Link'])
						
						local CurrentLineText, GearSetName
						for i = 1, GameTooltip:NumLines() do
							CurrentLineText = _G['GameTooltipTextLeft'..i]:GetText()
							GearSetName, _, _ = CurrentLineText:match('^(.+) %((%d)/(%d)%)$')
							
							if GearSetName then
								_G['GameTooltipTextLeft'..i]:SetText(string.gsub(CurrentLineText, '%(%d/', '%('..GearSetData[GearSetName]['Num']['Count']..'/', 1))
								
								local tempText, CheckEmptyLine
								for k = 1, KnightInspectToolTip:NumLines() do
									tempText = _G['GameTooltipTextLeft'..(i+k)]:GetText()
									
									if tempText == ' ' then
										CheckEmptyLine = true
									elseif CheckEmptyLine then
										for z = 1, #GearSetData[GearSetName]['SetBonus'] do
											_G['GameTooltipTextLeft'..(i + k + z - 1)]:SetText(GearSetData[GearSetName]['SetBonus'][z])
										end
										break
									else
										_G['GameTooltipTextLeft'..(i + k)]:SetText(GearSetData[GearSetName][k])
									end
								end
								break
							end
						end
						GameTooltip:Show()
					end
				end)
				KnightInspectFrame[SlotName]:SetScript('OnLeave', function() GameTooltip:Hide() end)
			end
			
			--<< Location >>--
			KnightInspectFrame['HeadSlot']:Point('BOTTOMLEFT', KnightInspectFrame['NeckSlot'], 'TOPLEFT', 0, SPACING)
			KnightInspectFrame['NeckSlot']:Point('BOTTOMLEFT', KnightInspectFrame['ShoulderSlot'], 'TOPLEFT', 0, SPACING)
			KnightInspectFrame['ShoulderSlot']:Point('BOTTOMLEFT', KnightInspectFrame['BackSlot'], 'TOPLEFT', 0, SPACING)
			KnightInspectFrame['BackSlot']:Point('BOTTOMLEFT', KnightInspectFrame['ChestSlot'], 'TOPLEFT', 0, SPACING)
			KnightInspectFrame['ChestSlot']:Point('BOTTOMLEFT', KnightInspectFrame['ShirtSlot'], 'TOPLEFT', 0, SPACING)
			KnightInspectFrame['ShirtSlot']:Point('BOTTOMLEFT', KnightInspectFrame['TabardSlot'], 'TOPLEFT', 0, SPACING)
			KnightInspectFrame['TabardSlot']:Point('BOTTOMLEFT', KnightInspectFrame['WristSlot'], 'TOPLEFT', 0, SPACING)
			KnightInspectFrame['WristSlot']:Point('BOTTOMLEFT', KnightInspectFrame.BP, 'TOPLEFT', 1, SPACING - 1)
			
			KnightInspectFrame['HandsSlot']:Point('BOTTOMRIGHT', KnightInspectFrame['WaistSlot'], 'TOPRIGHT', 0, SPACING)
			KnightInspectFrame['WaistSlot']:Point('BOTTOMRIGHT', KnightInspectFrame['LegsSlot'], 'TOPRIGHT', 0, SPACING)
			KnightInspectFrame['LegsSlot']:Point('BOTTOMRIGHT', KnightInspectFrame['FeetSlot'], 'TOPRIGHT', 0, SPACING)
			KnightInspectFrame['FeetSlot']:Point('BOTTOMRIGHT', KnightInspectFrame['Finger0Slot'], 'TOPRIGHT', 0, SPACING)
			KnightInspectFrame['Finger0Slot']:Point('BOTTOMRIGHT', KnightInspectFrame['Finger1Slot'], 'TOPRIGHT', 0, SPACING)
			KnightInspectFrame['Finger1Slot']:Point('BOTTOMRIGHT', KnightInspectFrame['Trinket0Slot'], 'TOPRIGHT', 0, SPACING)
			
			KnightInspectFrame['Trinket0Slot']:Point('BOTTOMRIGHT', KnightInspectFrame['Trinket1Slot'], 'TOPRIGHT', 0, SPACING)
			KnightInspectFrame['Trinket1Slot']:Point('BOTTOMRIGHT', KnightInspectFrame.BP, 'TOPRIGHT', -1, SPACING - 1)
			KnightInspectFrame['MainHandSlot']:Point('BOTTOMRIGHT', KnightInspectFrame.BP, 'BOTTOM', -2, E.PixelMode and SPACING + 1 or SPACING + 2)
			KnightInspectFrame['SecondaryHandSlot']:Point('BOTTOMLEFT', KnightInspectFrame.BP, 'BOTTOM', 2, E.PixelMode and SPACING + 1 or SPACING + 2)
		end

		
		do --<< ModelFrame >>--
			KnightInspectFrame.Model = CreateFrame('PlayerModel', nil, KnightInspectFrame)
			KnightInspectFrame.Model:EnableMouse(1)
			KnightInspectFrame.Model:EnableMouseWheel(1)
			KnightInspectFrame.Model:Point('TOPLEFT', KnightInspectFrame['HeadSlot'], 'TOPRIGHT', 3, 0)
			KnightInspectFrame.Model:Point('TOPRIGHT', KnightInspectFrame['HandsSlot'], 'TOPLEFT', -3, 0)
			KnightInspectFrame.Model:Point('BOTTOM', KnightInspectFrame['MainHandSlot'], 'TOP', 0, 3)
			KF:TextSetting(KnightInspectFrame.Model, '', nil, nil, 'BOTTOM', 0, 4)
			KnightInspectFrame.Model:SetScript('OnShow', function(self)
				self:SetPosition(-0.7, 0, -0.15)
				self:SetFacing(0.5)
			end)		
			KnightInspectFrame.Model:SetScript('OnMouseDown', function(self, button)
				local endx, endy
				self.startx, self.starty = GetCursorPosition()
				if (button == 'LeftButton') then
					KnightInspectFrame.Model:SetScript('OnUpdate', function(self)
						endx, endy = GetCursorPosition()
						
						self.rotation = (endx - self.startx) / 34 + self:GetFacing()
						
						self:SetFacing(self.rotation)
						self.startx, self.starty = GetCursorPosition()
					end)
				elseif (button == 'RightButton') then
					KnightInspectFrame.Model:SetScript('OnUpdate', function(self)
						local z, x, y = self:GetPosition(z, x, y)
						
						endx, endy = GetCursorPosition()
						
						x = (endx - self.startx) / 45 + x
						y = (endy - self.starty) / 45 + y
						
						self:SetPosition(z, x, y)
						self.startx, self.starty = GetCursorPosition()
					end)
				end
			end)
			KnightInspectFrame.Model:SetScript('OnMouseUp', function(self, button)
				KnightInspectFrame.Model:SetScript('OnUpdate', nil)
			end)
			KnightInspectFrame.Model:SetScript('OnMouseWheel', function(self, spining)
				local z, x, y = self:GetPosition()
				
				z = (spining > 0 and z + 0.7 or z - 0.7)
				
				self:SetPosition(z, x, y)
			end)
		end
		
		
		do --<< TalentFrame >>--
			KnightInspectFrame.Spec = CreateFrame('Frame', nil, KnightInspectFrame)
			KnightInspectFrame.Spec:Point('TOPLEFT', KnightInspectFrame['HeadSlot'], 'TOPRIGHT', 4, 0)
			KnightInspectFrame.Spec:Point('TOPRIGHT', KnightInspectFrame['HandsSlot'], 'TOPLEFT', -4, 0)
			KnightInspectFrame.Spec:Point('BOTTOM', KnightInspectFrame.BP, 'TOP', 0, 2)
			KnightInspectFrame.Spec:SetFrameLevel(11)
			
			for i = 1, 6 do
				KnightInspectFrame.Spec['TalentGroup'..i] = CreateFrame('Frame', nil, KnightInspectFrame.Spec)
				KnightInspectFrame.Spec['TalentGroup'..i]:SetBackdrop({
					bgFile = E['media'].blankTex,
					edgeFile = E['media'].blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				KnightInspectFrame.Spec['TalentGroup'..i]:SetBackdropColor(0.08, 0.08, 0.08)
				KnightInspectFrame.Spec['TalentGroup'..i]:SetBackdropBorderColor(unpack(E['media'].bordercolor))
				KnightInspectFrame.Spec['TalentGroup'..i]:SetFrameLevel(12)
				
				KnightInspectFrame.Spec['TalentGroup'..i]['Level'] = CreateFrame('Frame', nil, KnightInspectFrame.Spec['TalentGroup'..i])
				KnightInspectFrame.Spec['TalentGroup'..i]['Level']:SetBackdrop({
					bgFile = E['media'].blankTex,
					edgeFile = E['media'].blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				KnightInspectFrame.Spec['TalentGroup'..i]['Level']:SetBackdropColor(0.15, 0.15, 0.15)
				KnightInspectFrame.Spec['TalentGroup'..i]['Level']:SetBackdropBorderColor(unpack(E['media'].bordercolor))
				KnightInspectFrame.Spec['TalentGroup'..i]['Level']:SetFrameLevel(13)
				KnightInspectFrame.Spec['TalentGroup'..i]['Level']:Size(28,24)
				KnightInspectFrame.Spec['TalentGroup'..i]['Level']:Point('CENTER', KnightInspectFrame.Spec['TalentGroup'..i], 'LEFT', 0, 0)
				KF:TextSetting(KnightInspectFrame.Spec['TalentGroup'..i]['Level'], '', 10)
			end
			
			for i = 1, 18 do
				KnightInspectFrame.Spec['Talent'..i] = CreateFrame('Frame', nil, KnightInspectFrame.Spec['TalentGroup'..(ceil(i/3))])
				KnightInspectFrame.Spec['Talent'..i]:SetBackdrop({
					bgFile = E['media'].blankTex,
					edgeFile = E['media'].blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				KnightInspectFrame.Spec['Talent'..i]:SetFrameLevel(13)
				KnightInspectFrame.Spec['Talent'..i]:SetBackdropBorderColor(unpack(E['media'].bordercolor))
				KnightInspectFrame.Spec['Talent'..i]:Size(36)
				KnightInspectFrame.Spec['Talent'..i].Icon = CreateFrame('Frame', nil, KnightInspectFrame.Spec['Talent'..i])
				KnightInspectFrame.Spec['Talent'..i].Icon:Size(28)
				KnightInspectFrame.Spec['Talent'..i].Icon:SetBackdrop({
					bgFile = E['media'].blankTex,
					edgeFile = E['media'].blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				KnightInspectFrame.Spec['Talent'..i].Icon:SetBackdropColor(0.08, 0.08, 0.08)
				KnightInspectFrame.Spec['Talent'..i].Icon:SetBackdropBorderColor(unpack(E['media'].bordercolor))
				KnightInspectFrame.Spec['Talent'..i].Icon['Texture'] = KnightInspectFrame.Spec['Talent'..i].Icon:CreateTexture(nil, 'OVERLAY')
				KnightInspectFrame.Spec['Talent'..i].Icon['Texture']:SetTexCoord(unpack(E.TexCoords))
				KnightInspectFrame.Spec['Talent'..i].Icon['Texture']:SetInside()
				KnightInspectFrame.Spec['Talent'..i].Icon:Point('CENTER', KnightInspectFrame.Spec['Talent'..i])
				
				KnightInspectFrame.Spec['Talent'..i].tooltip = CreateFrame('Button', nil, KnightInspectFrame.Spec['Talent'..i])
				KnightInspectFrame.Spec['Talent'..i].tooltip:SetFrameLevel(14)
				KnightInspectFrame.Spec['Talent'..i].tooltip:SetInside()
				
				KnightInspectFrame.Spec['Talent'..i].tooltip:SetScript('OnClick', function(self)
					if IsShiftKeyDown() and SpecData['Talent'..i] then
						ChatEdit_InsertLink(SpecData['Talent'..i])
					end
				end)
				KnightInspectFrame.Spec['Talent'..i].tooltip:SetScript('OnEnter', function(self)
					if SpecData['Talent'..i] then
						GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
						GameTooltip:SetHyperlink(SpecData['Talent'..i])
						GameTooltip:Show()
					end
				end)
				KnightInspectFrame.Spec['Talent'..i].tooltip:SetScript('OnLeave', function() GameTooltip:Hide() end)
			end
			
			KnightInspectFrame.Spec['Talent1']:Point('RIGHT', KnightInspectFrame.Spec['Talent2'], 'LEFT', -3, 0)
			KnightInspectFrame.Spec['Talent2']:Point('TOP', KnightInspectFrame.Spec, -25, -25)
			KnightInspectFrame.Spec['Talent3']:Point('LEFT', KnightInspectFrame.Spec['Talent2'], 'RIGHT', 3, 0)
			KnightInspectFrame.Spec['Talent4']:Point('RIGHT', KnightInspectFrame.Spec['Talent5'], 'LEFT', -3, 0)
			KnightInspectFrame.Spec['Talent5']:Point('TOP', KnightInspectFrame.Spec['Talent2'], 'BOTTOM', 0, -9)
			KnightInspectFrame.Spec['Talent6']:Point('LEFT', KnightInspectFrame.Spec['Talent5'], 'RIGHT', 3, 0)
			KnightInspectFrame.Spec['Talent7']:Point('RIGHT', KnightInspectFrame.Spec['Talent8'], 'LEFT', -3, 0)
			KnightInspectFrame.Spec['Talent8']:Point('TOP', KnightInspectFrame.Spec['Talent5'], 'BOTTOM', 0, -9)
			KnightInspectFrame.Spec['Talent9']:Point('LEFT', KnightInspectFrame.Spec['Talent8'], 'RIGHT', 3, 0)
			KnightInspectFrame.Spec['Talent10']:Point('RIGHT', KnightInspectFrame.Spec['Talent11'], 'LEFT', -3, 0)
			KnightInspectFrame.Spec['Talent11']:Point('TOP', KnightInspectFrame.Spec['Talent8'], 'BOTTOM', 0, -9)
			KnightInspectFrame.Spec['Talent12']:Point('LEFT', KnightInspectFrame.Spec['Talent11'], 'RIGHT', 3, 0)
			KnightInspectFrame.Spec['Talent13']:Point('RIGHT', KnightInspectFrame.Spec['Talent14'], 'LEFT', -3, 0)
			KnightInspectFrame.Spec['Talent14']:Point('TOP', KnightInspectFrame.Spec['Talent11'], 'BOTTOM', 0, -9)
			KnightInspectFrame.Spec['Talent15']:Point('LEFT', KnightInspectFrame.Spec['Talent14'], 'RIGHT', 3, 0)
			KnightInspectFrame.Spec['Talent16']:Point('RIGHT', KnightInspectFrame.Spec['Talent17'], 'LEFT', -3, 0)
			KnightInspectFrame.Spec['Talent17']:Point('TOP', KnightInspectFrame.Spec['Talent14'], 'BOTTOM', 0, -9)
			KnightInspectFrame.Spec['Talent18']:Point('LEFT', KnightInspectFrame.Spec['Talent17'], 'RIGHT', 3, 0)
			
			
			for i = 1, 6 do
				KnightInspectFrame.Spec['TalentGroup'..i]:Point('TOPLEFT', KnightInspectFrame.Spec['Talent'..(1 + 3*(i-1))], -22, 3)
				KnightInspectFrame.Spec['TalentGroup'..i]:Point('BOTTOMRIGHT', KnightInspectFrame.Spec['Talent'..(3 + 3*(i-1))], 3, -3)
				
				
				KnightInspectFrame.Spec['Glyph'..i] = CreateFrame('Button', nil, KnightInspectFrame.Spec)
				KnightInspectFrame.Spec['Glyph'..i]:SetBackdrop({
					bgFile = E['media'].blankTex,
					edgeFile = E['media'].blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				KnightInspectFrame.Spec['Glyph'..i]:SetFrameLevel(13)
				KnightInspectFrame.Spec['Glyph'..i]:Size(34)
				KnightInspectFrame.Spec['Glyph'..i]:SetBackdropBorderColor(unpack(E['media'].bordercolor))
				KnightInspectFrame.Spec['Glyph'..i].Icon = CreateFrame('Frame', nil, KnightInspectFrame.Spec['Glyph'..i])
				KnightInspectFrame.Spec['Glyph'..i].Icon:Size(26)
				KnightInspectFrame.Spec['Glyph'..i].Icon:SetBackdrop({
					bgFile = E['media'].blankTex,
					edgeFile = E['media'].blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				KnightInspectFrame.Spec['Glyph'..i].Icon:SetBackdropColor(0.13, 0.13, 0.13)
				KnightInspectFrame.Spec['Glyph'..i].Icon:SetBackdropBorderColor(unpack(E['media'].bordercolor))
				KnightInspectFrame.Spec['Glyph'..i].Icon:Point('CENTER', KnightInspectFrame.Spec['Glyph'..i])
				KnightInspectFrame.Spec['Glyph'..i].Icon['Texture'] = KnightInspectFrame.Spec['Glyph'..i].Icon:CreateTexture(nil, 'OVERLAY')
				KnightInspectFrame.Spec['Glyph'..i].Icon['Texture']:SetTexCoord(unpack(E.TexCoords))
				KnightInspectFrame.Spec['Glyph'..i].Icon['Texture']:SetInside()
				
				KnightInspectFrame.Spec['Glyph'..i]['Level'] = CreateFrame('Frame', nil, KnightInspectFrame.Spec['Glyph'..i])
				KnightInspectFrame.Spec['Glyph'..i]['Level']:SetBackdrop({
					bgFile = E['media'].blankTex,
					edgeFile = E['media'].blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				KnightInspectFrame.Spec['Glyph'..i]['Level']:SetBackdropColor(0.15, 0.15, 0.15)
				KnightInspectFrame.Spec['Glyph'..i]['Level']:SetBackdropBorderColor(unpack(E['media'].bordercolor))
				KnightInspectFrame.Spec['Glyph'..i]['Level']:SetFrameLevel(13)
				KnightInspectFrame.Spec['Glyph'..i]['Level']:Size(24,20)
				KnightInspectFrame.Spec['Glyph'..i]['Level']:Point('CENTER', KnightInspectFrame.Spec['Glyph'..i], 'RIGHT', 19, 0)
				KF:TextSetting(KnightInspectFrame.Spec['Glyph'..i]['Level'], '', 10, nil, 'CENTER', 1, 0)
				
				KnightInspectFrame.Spec['Glyph'..i]:SetScript('OnClick', function(self)
					if IsShiftKeyDown() and SpecData['Glyph'..i] then
						ChatEdit_InsertLink(SpecData['Glyph'..i])
					end
				end)
				KnightInspectFrame.Spec['Glyph'..i]:SetScript('OnEnter', function(self)
					if SpecData['Glyph'..i] then
						GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
						GameTooltip:SetHyperlink(SpecData['Glyph'..i])
						GameTooltip:Show()
					end
				end)
				KnightInspectFrame.Spec['Glyph'..i]:SetScript('OnLeave', function() GameTooltip:Hide() end)
			end
			
			for i = 1, 2 do
				KnightInspectFrame.Spec['GlyphGroup'..i] = CreateFrame('Frame', nil, KnightInspectFrame.Spec)
				KnightInspectFrame.Spec['GlyphGroup'..i]:SetBackdrop({
					bgFile = E['media'].blankTex,
					edgeFile = E['media'].blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				KnightInspectFrame.Spec['GlyphGroup'..i]:SetBackdropColor(0.08, 0.08, 0.08)
				KnightInspectFrame.Spec['GlyphGroup'..i]:SetBackdropBorderColor(unpack(E['media'].bordercolor))
				KnightInspectFrame.Spec['GlyphGroup'..i]:SetFrameLevel(12)
				KnightInspectFrame.Spec['GlyphGroup'..i]:Size(57,114)
			end
			KnightInspectFrame.Spec['GlyphGroup1']:Point('RIGHT', KnightInspectFrame.Spec, -26, 0)
			KnightInspectFrame.Spec['GlyphGroup1']:Point('BOTTOM', KnightInspectFrame.Spec['TalentGroup3'], 0, 6)
			KnightInspectFrame.Spec['GlyphGroup2']:Point('RIGHT', KnightInspectFrame.Spec, -26, 0)
			KnightInspectFrame.Spec['GlyphGroup2']:Point('BOTTOM', KnightInspectFrame.Spec['TalentGroup6'], 0, 6)
			
			KnightInspectFrame.Spec['Glyph1']:Point('BOTTOM', KnightInspectFrame.Spec['Glyph3'], 'TOP', 0, 3)
			KnightInspectFrame.Spec['Glyph2']:Point('BOTTOM', KnightInspectFrame.Spec['Glyph4'], 'TOP', 0, 3)
			KnightInspectFrame.Spec['Glyph3']:Point('BOTTOM', KnightInspectFrame.Spec['Glyph5'], 'TOP', 0, 3)
			KnightInspectFrame.Spec['Glyph4']:Point('BOTTOM', KnightInspectFrame.Spec['Glyph6'], 'TOP', 0, 3)
			KnightInspectFrame.Spec['Glyph5']:Point('BOTTOMLEFT', KnightInspectFrame.Spec['GlyphGroup2'], 3, 3)
			KnightInspectFrame.Spec['Glyph6']:Point('BOTTOMLEFT', KnightInspectFrame.Spec['GlyphGroup1'], 3, 3)
			
			KF:TextSetting(KnightInspectFrame.Spec['GlyphGroup1'], '< |cffceff00'..MAJOR_GLYPH..'|r >', 8, nil, 'BOTTOMLEFT', KnightInspectFrame.Spec['GlyphGroup1'], 'TOPLEFT', 0, 4)
			KnightInspectFrame.Spec['GlyphGroup1'].text:Point('RIGHT', KnightInspectFrame.Spec['Glyph2']['Level'])
			KF:TextSetting(KnightInspectFrame.Spec['GlyphGroup2'], '< |cffceff00'..MINOR_GLYPH..'|r >', 8, nil, 'BOTTOMLEFT', KnightInspectFrame.Spec['GlyphGroup2'], 'TOPLEFT', 0, 4)
			KnightInspectFrame.Spec['GlyphGroup2'].text:Point('RIGHT', KnightInspectFrame.Spec['Glyph1']['Level'])
		end
		
		
		do --<< PvP Info Frame >>--
			KnightInspectFrame.PvPInfo = CreateFrame('Frame', nil, KnightInspectFrame)
			KnightInspectFrame.PvPInfo:Point('TOPLEFT', KnightInspectFrame['HeadSlot'], 'TOPRIGHT', 4, 0)
			KnightInspectFrame.PvPInfo:Point('TOPRIGHT', KnightInspectFrame['HandsSlot'], 'TOPLEFT', -4, 0)
			KnightInspectFrame.PvPInfo:Point('BOTTOM', KnightInspectFrame.BP, 'TOP', 0, 2)
			KnightInspectFrame.PvPInfo:SetFrameLevel(11)
			
			do --<< Rated BattleGrounds >>--
				KnightInspectFrame.PvPInfo.RatedBG = CreateFrame('Frame', nil, KnightInspectFrame.PvPInfo)
				KnightInspectFrame.PvPInfo.RatedBG:SetBackdrop({
					bgFile = E['media'].blankTex,
					edgeFile = E['media'].blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				KnightInspectFrame.PvPInfo.RatedBG:SetBackdropColor(0.08, 0.08, 0.08)
				KnightInspectFrame.PvPInfo.RatedBG:SetBackdropBorderColor(unpack(E['media'].bordercolor))
				KnightInspectFrame.PvPInfo.RatedBG:Point('BOTTOMLEFT', KnightInspectFrame.PvPInfo, 3, 13)
				KnightInspectFrame.PvPInfo.RatedBG:Point('BOTTOMRIGHT', KnightInspectFrame.PvPInfo, -3, 13)
				KnightInspectFrame.PvPInfo.RatedBG:Height(26)
				KnightInspectFrame.PvPInfo.RatedBG:SetFrameLevel(12)
				KF:TextSetting(KnightInspectFrame.PvPInfo.RatedBG, '|cffceff00■|r '..PVP_RATED_BATTLEGROUNDS, 12, 'LEFT', 'BOTTOMLEFT', KnightInspectFrame.PvPInfo.RatedBG, 'TOPLEFT', 3, 6)
				KF:TextSetting(KnightInspectFrame.PvPInfo.RatedBG, '', 10, 'LEFT', 'LEFT', KnightInspectFrame.PvPInfo.RatedBG, 6, 0)
				KnightInspectFrame.PvPInfo.RatedBG.Record = KnightInspectFrame.PvPInfo.RatedBG.text
				KF:TextSetting(KnightInspectFrame.PvPInfo.RatedBG, '', 10, 'RIGHT', 'RIGHT', KnightInspectFrame.PvPInfo.RatedBG, -6, 0)
				KnightInspectFrame.PvPInfo.RatedBG.Rating = KnightInspectFrame.PvPInfo.RatedBG.text
			end
			
			KnightInspectFrame.PvPInfo.Arena = {}
			do -- << Rating Information >>--
				KnightInspectFrame.PvPInfo.Arena.RatingGroup = CreateFrame('Frame', nil, KnightInspectFrame.PvPInfo)
				KnightInspectFrame.PvPInfo.Arena.RatingGroup:SetBackdrop({
					bgFile = E['media'].blankTex,
					edgeFile = E['media'].blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				KnightInspectFrame.PvPInfo.Arena.RatingGroup:SetBackdropColor(0.08, 0.08, 0.08)
				KnightInspectFrame.PvPInfo.Arena.RatingGroup:SetBackdropBorderColor(unpack(E['media'].bordercolor))
				KnightInspectFrame.PvPInfo.Arena.RatingGroup:SetFrameLevel(12)
				KnightInspectFrame.PvPInfo.Arena.RatingGroup:Point('TOPLEFT', KnightInspectFrame.PvPInfo, 3, -34)
				KnightInspectFrame.PvPInfo.Arena.RatingGroup:Point('TOPRIGHT', KnightInspectFrame.PvPInfo, -3, -34)
				KnightInspectFrame.PvPInfo.Arena.RatingGroup:Height(153)
				KF:TextSetting(KnightInspectFrame.PvPInfo, '|cffceff00■|r '..ARENA, 12, 'LEFT', 'TOPLEFT', 6, -16)
				
				for i = 1, 3 do
					KnightInspectFrame.PvPInfo.Arena['Banner'..i] = CreateFrame('Frame', nil, KnightInspectFrame.PvPInfo.Arena.RatingGroup)
					KnightInspectFrame.PvPInfo.Arena['Banner'..i]:SetBackdrop({
						bgFile = E['media'].blankTex,
						edgeFile = E['media'].blankTex,
						tile = false, tileSize = 0, edgeSize = E.mult,
						insets = { left = 0, right = 0, top = 0, bottom = 0}
					})
					KnightInspectFrame.PvPInfo.Arena['Banner'..i]:SetBackdropColor(0.15, 0.15, 0.15)
					KnightInspectFrame.PvPInfo.Arena['Banner'..i]:SetBackdropBorderColor(unpack(E['media'].bordercolor))
					KnightInspectFrame.PvPInfo.Arena['Banner'..i]:Size(80, 150)
					KnightInspectFrame.PvPInfo.Arena['Banner'..i]:SetFrameLevel(13)
					KnightInspectFrame.PvPInfo.Arena['Banner'..i].texture = KnightInspectFrame.PvPInfo.Arena['Banner'..i]:CreateTexture(nil, 'OVERLAY')
					KnightInspectFrame.PvPInfo.Arena['Banner'..i].texture:SetInside()
					KnightInspectFrame.PvPInfo.Arena['Banner'..i].texture:SetTexture('Interface\\AchievementFrame\\GuildTabard')
					KnightInspectFrame.PvPInfo.Arena['Banner'..i].texture:SetTexCoord(0.00781250, 0.57031250, 0.48437500, 0.98437500)
					
					
					KnightInspectFrame.PvPInfo.Arena['BannerBorder'..i] = CreateFrame('Frame', nil, KnightInspectFrame.PvPInfo.Arena['Banner'..i])
					KnightInspectFrame.PvPInfo.Arena['BannerBorder'..i]:Point('TOPLEFT', KnightInspectFrame.PvPInfo.Arena['Banner'..i])
					KnightInspectFrame.PvPInfo.Arena['BannerBorder'..i]:Point('BOTTOMRIGHT', KnightInspectFrame.PvPInfo.Arena['Banner'..i])
					KnightInspectFrame.PvPInfo.Arena['BannerBorder'..i]:SetFrameLevel(14)
					KnightInspectFrame.PvPInfo.Arena['BannerBorder'..i].texture = KnightInspectFrame.PvPInfo.Arena['BannerBorder'..i]:CreateTexture(nil, 'OVERLAY')
					KnightInspectFrame.PvPInfo.Arena['BannerBorder'..i].texture:Point('TOPLEFT', KnightInspectFrame.PvPInfo.Arena['BannerBorder'..i], 8, -1)
					KnightInspectFrame.PvPInfo.Arena['BannerBorder'..i].texture:Point('BOTTOMRIGHT', KnightInspectFrame.PvPInfo.Arena['BannerBorder'..i], -8, 6)
					KnightInspectFrame.PvPInfo.Arena['BannerBorder'..i].texture:SetTexture('Interface\\AchievementFrame\\GuildTabard')
					KnightInspectFrame.PvPInfo.Arena['BannerBorder'..i].texture:SetTexCoord(0.00781250, 0.44531250, 0.00390625, 0.47656250)
					
					KnightInspectFrame.PvPInfo.Arena['Emblem'..i] = KnightInspectFrame.PvPInfo.Arena['BannerBorder'..i]:CreateTexture(nil, 'OVERLAY')
					KnightInspectFrame.PvPInfo.Arena['Emblem'..i]:Point('CENTER', KnightInspectFrame.PvPInfo.Arena['BannerBorder'..i], 0, 4)
					KnightInspectFrame.PvPInfo.Arena['Emblem'..i]:Size(54)
					
					KnightInspectFrame.PvPInfo.Arena['Size'..i] = KnightInspectFrame.PvPInfo.Arena['BannerBorder'..i]:CreateFontString(nil, 'OVERLAY')
					KnightInspectFrame.PvPInfo.Arena['Size'..i]:FontTemplate(nil, 12, 'OUTLINE')
					KnightInspectFrame.PvPInfo.Arena['Size'..i]:SetJustifyH('CENTER')
					KnightInspectFrame.PvPInfo.Arena['Size'..i]:Point('TOP', 1, -8)
					
					KnightInspectFrame.PvPInfo.Arena['Rating'..i] = KnightInspectFrame.PvPInfo.Arena['BannerBorder'..i]:CreateFontString(nil, 'OVERLAY')
					KnightInspectFrame.PvPInfo.Arena['Rating'..i]:FontTemplate(nil, 22, 'OUTLINE')
					KnightInspectFrame.PvPInfo.Arena['Rating'..i]:SetJustifyH('CENTER')
					KnightInspectFrame.PvPInfo.Arena['Rating'..i]:Point('BOTTOM', 1, 8)
				end
				
				KnightInspectFrame.PvPInfo.Arena['Banner1']:Point('TOPRIGHT', KnightInspectFrame.PvPInfo.Arena['Banner2'], 'TOPLEFT', -3, 0)
				KnightInspectFrame.PvPInfo.Arena['Banner2']:Point('TOP', KnightInspectFrame.PvPInfo.Arena.RatingGroup)
				KnightInspectFrame.PvPInfo.Arena['Banner3']:Point('TOPLEFT', KnightInspectFrame.PvPInfo.Arena['Banner2'], 'TOPRIGHT', 3, 0)
				KnightInspectFrame.PvPInfo.Arena['Size1']:SetText('2vs2')
				KnightInspectFrame.PvPInfo.Arena['Size2']:SetText('3vs3')
				KnightInspectFrame.PvPInfo.Arena['Size3']:SetText('5vs5')
			end
			
			do -- << Team Information >>--
				KnightInspectFrame.PvPInfo.Arena.TeamGroup = CreateFrame('Frame', nil, KnightInspectFrame.PvPInfo)
				KnightInspectFrame.PvPInfo.Arena.TeamGroup:SetBackdrop({
					bgFile = E['media'].blankTex,
					edgeFile = E['media'].blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				KnightInspectFrame.PvPInfo.Arena.TeamGroup:SetBackdropColor(0.08, 0.08, 0.08)
				KnightInspectFrame.PvPInfo.Arena.TeamGroup:SetBackdropBorderColor(unpack(E['media'].bordercolor))
				KnightInspectFrame.PvPInfo.Arena.TeamGroup:Point('TOPLEFT', KnightInspectFrame.PvPInfo.Arena.RatingGroup, 'BOTTOMLEFT', 0, -3)
				KnightInspectFrame.PvPInfo.Arena.TeamGroup:Point('BOTTOMRIGHT', KnightInspectFrame.PvPInfo.RatedBG, 'TOPRIGHT', 0, 24)
				KnightInspectFrame.PvPInfo.Arena.TeamGroup:SetFrameLevel(12)
				
				
				KnightInspectFrame.PvPInfo.Arena.TeamTab = CreateFrame('Frame', nil, KnightInspectFrame.PvPInfo.Arena.TeamGroup)
				KnightInspectFrame.PvPInfo.Arena.TeamTab:SetBackdrop({
					bgFile = E['media'].blankTex,
					edgeFile = E['media'].blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				KnightInspectFrame.PvPInfo.Arena.TeamTab:SetBackdropColor(0.2, 0.2, 0.2)
				KnightInspectFrame.PvPInfo.Arena.TeamTab:SetBackdropBorderColor(unpack(E['media'].bordercolor))
				KnightInspectFrame.PvPInfo.Arena.TeamTab:Point('TOPLEFT', KnightInspectFrame.PvPInfo.Arena.TeamGroup, 3, -3)
				KnightInspectFrame.PvPInfo.Arena.TeamTab:Point('BOTTOMRIGHT', KnightInspectFrame.PvPInfo.Arena.TeamGroup, 'TOPRIGHT', -3, -19)
				KnightInspectFrame.PvPInfo.Arena.TeamTab:SetFrameLevel(13)
				KF:TextSetting(KnightInspectFrame.PvPInfo.Arena.TeamTab, '|cffffe65aTeam  Name', 8, 'LEFT', 'LEFT', 5, 0)
				KF:TextSetting(KnightInspectFrame.PvPInfo.Arena.TeamTab, '|cffffe65aTeam Rating', 8, nil, 'CENTER', 50, 0)
				KF:TextSetting(KnightInspectFrame.PvPInfo.Arena.TeamTab, '|cffffe65aRecord', 8, nil, 'CENTER', KnightInspectFrame.PvPInfo.Arena.TeamTab, 'RIGHT', -26, 0)
				
				KF:TextSetting(KnightInspectFrame.PvPInfo.Arena.TeamGroup, '', 9, nil, 'TOP', KnightInspectFrame.PvPInfo.Arena.TeamTab, 'BOTTOM', 50, -3)
				KnightInspectFrame.PvPInfo.Arena.TeamRating = KnightInspectFrame.PvPInfo.Arena.TeamGroup.text
				KnightInspectFrame.PvPInfo.Arena.TeamRating:SetSpacing(4)
				KnightInspectFrame.PvPInfo.Arena.TeamRating:SetWidth(40)
				
				KF:TextSetting(KnightInspectFrame.PvPInfo.Arena.TeamGroup, '', 9, 'LEFT', 'TOPLEFT', KnightInspectFrame.PvPInfo.Arena.TeamTab, 'BOTTOMLEFT', 2, -3)
				KnightInspectFrame.PvPInfo.Arena['TeamName1'] = KnightInspectFrame.PvPInfo.Arena.TeamGroup.text
				KnightInspectFrame.PvPInfo.Arena['TeamName1']:Point('RIGHT', KnightInspectFrame.PvPInfo.Arena.TeamRating, 'LEFT', -2, 0)
				KF:TextSetting(KnightInspectFrame.PvPInfo.Arena.TeamGroup, '', 9, 'LEFT', 'TOPLEFT', KnightInspectFrame.PvPInfo.Arena['TeamName1'], 'BOTTOMLEFT', 0, -4)
				KnightInspectFrame.PvPInfo.Arena['TeamName2'] = KnightInspectFrame.PvPInfo.Arena.TeamGroup.text
				KnightInspectFrame.PvPInfo.Arena['TeamName2']:Point('RIGHT', KnightInspectFrame.PvPInfo.Arena.TeamRating, 'LEFT', -2, 0)
				KF:TextSetting(KnightInspectFrame.PvPInfo.Arena.TeamGroup, '', 9, 'LEFT', 'TOPLEFT', KnightInspectFrame.PvPInfo.Arena['TeamName2'], 'BOTTOMLEFT', 0, -4)
				KnightInspectFrame.PvPInfo.Arena['TeamName3'] = KnightInspectFrame.PvPInfo.Arena.TeamGroup.text
				KnightInspectFrame.PvPInfo.Arena['TeamName3']:Point('RIGHT', KnightInspectFrame.PvPInfo.Arena.TeamRating, 'LEFT', -2, 0)
				
				KF:TextSetting(KnightInspectFrame.PvPInfo.Arena.TeamGroup, '', 9, nil, 'TOP', KnightInspectFrame.PvPInfo.Arena.TeamTab, 'BOTTOMRIGHT', -26, -3)
				KnightInspectFrame.PvPInfo.Arena.TeamRecord = KnightInspectFrame.PvPInfo.Arena.TeamGroup.text
				KnightInspectFrame.PvPInfo.Arena.TeamRecord:SetSpacing(4)
				KnightInspectFrame.PvPInfo.Arena.TeamRecord:SetWidth(100)
			end
		end
		
		
		do --<< Buttons >>-
			-- 1 : Model Frame / 2 : Specialization Frame / 3 : PvP Info Frame
			for i = 1, 3 do
				KnightInspectFrame['Button'..i] = CreateFrame('Button', nil, KnightInspectFrame)
				KnightInspectFrame['Button'..i]:SetBackdrop({
					bgFile = E['media'].blankTex,
					edgeFile = E['media'].blankTex,
					tile = false, tileSize = 0, edgeSize = E.mult,
					insets = { left = 0, right = 0, top = 0, bottom = 0}
				})
				KnightInspectFrame['Button'..i]:SetBackdropColor(0.2, 0.2, 0.2, 1)
				KnightInspectFrame['Button'..i]:SetBackdropBorderColor(unpack(E['media'].bordercolor))
				KnightInspectFrame['Button'..i]:Size(44,18)
				KnightInspectFrame['Button'..i]:SetFrameLevel(14)
				KF:TextSetting(KnightInspectFrame['Button'..i], '', 9)
			end
			KnightInspectFrame.Button1:Point('RIGHT', KnightInspectFrame.Button2, 'LEFT', -4, 0)
			KnightInspectFrame.Button1:SetScript('OnEnter', function(self) self.text:SetText('|cffceff00'..L['ShowModelFrame']) self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor)) end)
			KnightInspectFrame.Button1:SetScript('OnLeave', function(self) if KF.db.Extra_Functions.Inspect.DisplayPage ~= 'Model' then self.text:SetText(L['ShowModelFrame']) end self:SetBackdropBorderColor(unpack(E.media.bordercolor)) end)
			KnightInspectFrame.Button1:SetScript('OnClick', function() SwitchDisplayFrame('Model') end)
			
			KnightInspectFrame.Button2:Point('TOP', KnightInspectFrame.Tab, 'BOTTOM', 0, -74)
			KnightInspectFrame.Button2:SetScript('OnEnter', function(self) self.text:SetText('|cffceff00'..L['ShowSpecializationFrame']) self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor)) end)
			KnightInspectFrame.Button2:SetScript('OnLeave', function(self) if KF.db.Extra_Functions.Inspect.DisplayPage ~= 'Spec' then self.text:SetText(L['ShowSpecializationFrame']) end self:SetBackdropBorderColor(unpack(E.media.bordercolor)) end)
			KnightInspectFrame.Button2:SetScript('OnClick', function() SwitchDisplayFrame('Spec') end)
			
			KnightInspectFrame.Button3:Point('LEFT', KnightInspectFrame.Button2, 'RIGHT', 4, 0)
			KnightInspectFrame.Button3:SetScript('OnEnter', function(self) self.text:SetText('|cffceff00'..L['ShowPvPInfoFrame']) self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor)) end)
			KnightInspectFrame.Button3:SetScript('OnLeave', function(self) if KF.db.Extra_Functions.Inspect.DisplayPage ~= 'PvPInfo' then self.text:SetText(L['ShowPvPInfoFrame']) end self:SetBackdropBorderColor(unpack(E.media.bordercolor)) end)
			KnightInspectFrame.Button3:SetScript('OnClick', function() SwitchDisplayFrame('PvPInfo') end)
		end
	end
end