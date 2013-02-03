--local E, L, V, P, G, _ = unpack(ElvUI)
local E, L, _, _, _, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')
	
if KF.UIParent and KF.db.Extra_Functions.Inspect.Enable ~= false then
	-----------------------------------------------------------
	-- [ Knight : Inspect Data								]--
	-----------------------------------------------------------
	local TT = E:GetModule('Tooltip')
	
	local CurrentInspectUnit
	local CurrentInspectUnitGUID
	local ReInspectCount
	local TimeWhenInspectOver
	
	local Check -- Check is using like temp value
	local Title, Name, Class, Realm, Level, Race, guildName, guildRankName
	local ItemCount, ItemTotal, ItemLevel
	
	local GearData = { -- SlotName = value to set text's justifyH and tooltip's owner direction. this value will erase until inspect.
		['HeadSlot'] = 'LEFT',
		['NeckSlot'] = 'LEFT',
		['ShoulderSlot'] = 'LEFT',
		['BackSlot'] = 'LEFT',
		['ChestSlot'] = 'LEFT',
		['ShirtSlot'] = 'LEFT',
		['TabardSlot'] = 'LEFT',
		['WristSlot'] = 'LEFT',
		['HandsSlot'] = 'RIGHT',
		['WaistSlot'] = 'RIGHT',
		['LegsSlot'] = 'RIGHT',
		['FeetSlot'] = 'RIGHT',
		['Finger0Slot'] = 'RIGHT',
		['Finger1Slot'] = 'RIGHT',
		['Trinket0Slot'] = 'RIGHT',
		['Trinket1Slot'] = 'RIGHT',
		['MainHandSlot'] = 'CENTER',
		['SecondaryHandSlot'] = 'CENTER',
	}
	
	local SpecData = {
		['CurrentSpec'] = nil,
		['Talent1'] = { ['Name'] = nil, ['Texture'] = nil, ['Selected'] = false, ['Link'] = nil, },
		['Talent2'] = { ['Name'] = nil, ['Texture'] = nil, ['Selected'] = false, ['Link'] = nil, },
		['Talent3'] = { ['Name'] = nil, ['Texture'] = nil, ['Selected'] = false, ['Link'] = nil, },
		['Talent4'] = { ['Name'] = nil, ['Texture'] = nil, ['Selected'] = false, ['Link'] = nil, },
		['Talent5'] = { ['Name'] = nil, ['Texture'] = nil, ['Selected'] = false, ['Link'] = nil, },
		['Talent6'] = { ['Name'] = nil, ['Texture'] = nil, ['Selected'] = false, ['Link'] = nil, },
		['Talent7'] = { ['Name'] = nil, ['Texture'] = nil, ['Selected'] = false, ['Link'] = nil, },
		['Talent8'] = { ['Name'] = nil, ['Texture'] = nil, ['Selected'] = false, ['Link'] = nil, },
		['Talent9'] = { ['Name'] = nil, ['Texture'] = nil, ['Selected'] = false, ['Link'] = nil, },
		['Talent10'] = { ['Name'] = nil, ['Texture'] = nil, ['Selected'] = false, ['Link'] = nil, },
		['Talent11'] = { ['Name'] = nil, ['Texture'] = nil, ['Selected'] = false, ['Link'] = nil, },
		['Talent12'] = { ['Name'] = nil, ['Texture'] = nil, ['Selected'] = false, ['Link'] = nil, },
		['Talent13'] = { ['Name'] = nil, ['Texture'] = nil, ['Selected'] = false, ['Link'] = nil, },
		['Talent14'] = { ['Name'] = nil, ['Texture'] = nil, ['Selected'] = false, ['Link'] = nil, },
		['Talent15'] = { ['Name'] = nil, ['Texture'] = nil, ['Selected'] = false, ['Link'] = nil, },
		['Talent16'] = { ['Name'] = nil, ['Texture'] = nil, ['Selected'] = false, ['Link'] = nil, },
		['Talent17'] = { ['Name'] = nil, ['Texture'] = nil, ['Selected'] = false, ['Link'] = nil, },
		['Talent18'] = { ['Name'] = nil, ['Texture'] = nil, ['Selected'] = false, ['Link'] = nil, },
		['Glyph1'] = nil,
		['Glyph2'] = nil,
		['Glyph3'] = nil,
		['Glyph4'] = nil,
		['Glyph5'] = nil,
		['Glyph6'] = nil,
	}
	
	if not KF.Memory['Table']['ItemUpgrade'] then
		KF.Memory['Table']['ItemUpgrade'] = {
			['0'] = 0, ['1'] = 8, ['373'] = 4, ['374'] = 8, ['375'] = 4, ['376'] = 4,
			['377'] = 4, ['379'] = 4, ['380'] = 4, ['445'] = 0, ['446'] = 4, ['447'] = 8,
			['451'] = 0, ['452'] = 8, ['453'] = 0, ['454'] = 4, ['455'] = 8, ['456'] = 0,
			['457'] = 8, ['458'] = 0, ['459'] = 4, ['460'] = 8, ['461'] = 12, ['462'] = 16,
		}
	end
	
	
	-----------------------------------------------------------
	-- [ Knight : INSPECT function							]--
	-----------------------------------------------------------
	KF.UpdateFrame.UpdateList.NotifyInspect = {
		['Condition'] = false,
		['Delay'] = 0.5,
		['Action'] = function()
			if UnitGUID(CurrentInspectUnit) ~= CurrentInspectUnitGUID then
				KF.UpdateFrame.UpdateList.NotifyInspect.Condition = false
				KF.Memory['Event']['INSPECT_READY']['KnightInspect'] = nil
				if CurrentInspectUnit == 'mouseover' then print(L['KF']..' : '..L['Mouseover Inspect is canceled because cursor left user to inspect.']) end
				return
			end
			NotifyInspect(CurrentInspectUnit)
		end,
	}
	
	
	local function SwitchDisplayFrame(FrameMod)
		if not FrameMod then return end
		
		KnightInspectFrame.Model:Hide()
		KnightInspectFrame.Spec:Hide()
		KnightInspectFrame.PvPInfo:Hide()
		KnightInspectFrame.Button1.text:SetText((FrameMod == 'Model' and '|cffceff00' or '')..L['ShowModelFrame'])
		KnightInspectFrame.Button2.text:SetText((FrameMod == 'Spec' and '|cffceff00' or '')..L['ShowSpecializationFrame'])
		KnightInspectFrame.Button3.text:SetText((FrameMod == 'PvPInfo' and '|cffceff00' or '')..L['ShowPvPInfoFrame'])
		
		KF.db.Extra_Functions.Inspect.DisplayPage = FrameMod
		KnightInspectFrame[FrameMod]:Show()
	end
	
	
	local function INSPECT_READY(_, GUID)
		if CurrentInspectUnitGUID == GUID then
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
				ItemCount, ItemTotal = 0, 0
				for SlotName in pairs(GearData) do
					local SlotNumber, EmptyTexture, _ = GetInventorySlotInfo(SlotName)
					local r, g, b = GetItemQualityColor(0)
					
					KnightInspectFrame[SlotName]['ilvl']:SetText('')
					
					GearData[SlotName] = GetInventoryItemLink(CurrentInspectUnit, SlotNumber) or false
					
					Check = GetInventoryItemTexture(CurrentInspectUnit, SlotNumber)
					KnightInspectFrame[SlotName]['Texture']:SetTexture(Check or EmptyTexture)
					
					if Check and Check..'.blp' ~= EmptyTexture then
						if GearData[SlotName] == false then
							ItemCount = ItemCount - 50 -- means ReInspect
							break
						else
							_, _, Check, ItemLevel, _, _, _, _, _, _, _ = GetItemInfo(GearData[SlotName])
							r, g, b = GetItemQualityColor(Check)
							Check = GearData[SlotName]:match(':(%d+)\124h%[') or nil
							
							if ItemLevel then
								if not (SlotName == 'ShirtSlot' or SlotName == 'TabardSlot') then
									ItemCount = ItemCount + 1
									if Check then
										ItemLevel = ItemLevel + KF.Memory['Table']['ItemUpgrade'][Check]
									end
									
									ItemTotal = ItemTotal + ItemLevel
								end
								KnightInspectFrame[SlotName]['ilvl']:SetText(ItemLevel..(tonumber(Check) > 0 and '|n'..(KF.Memory['Table']['ItemUpgrade'][Check] >= 16 and '|cffff9614' or KF.Memory['Table']['ItemUpgrade'][Check] >= 12 and '|cfff88ef4' or KF.Memory['Table']['ItemUpgrade'][Check] >= 8 and '|cff2eb7e4' or KF.Memory['Table']['ItemUpgrade'][Check] >= 4 and '|cffceff00' or '|cffaaaaaa')..'(+'..KF.Memory['Table']['ItemUpgrade'][Check]..')|r' or ''))
							end
						end
					end
					KnightInspectFrame[SlotName]:SetBackdropBorderColor(r, g, b)
				end
				KnightInspectFrame.BP.text:SetText(string.format('|cffceff00'..L['Average']..'|r : %.2f', (ItemCount > 0 and ItemTotal/ItemCount or 0)))
				
				-- ReInspect when there is no gear or gear texture.
				if ItemCount <= 0 and ReInspectCount > 0 then
					ReInspectCount = ReInspectCount - 1
					KF.UpdateFrame.UpdateList.NotifyInspect.Condition = true
					return
				end
				
				if ReInspectCount == 0 then
					KnightInspectFrame.Model.text:SetText(L['This is not a inspect bug.|nI think this user is not wearing any gears.'])
				else
					KnightInspectFrame.Model.text:SetText('')
				end
			end
			
			do --<< Inspect Unit's Specialization Setting >>--			
				Check = GetInspectSpecialization(CurrentInspectUnit)
				
				if Check ~= nil and Check > 0 then
					_, SpecData['CurrentSpec'], _, Check, _, _, _ = GetSpecializationInfoByID(GetInspectSpecialization(CurrentInspectUnit))
					KnightInspectFrame.SpecIcon['Texture']:SetTexture(Check)
					
					Check = KF.Memory['Table']['ClassRole'][Class][SpecData['CurrentSpec']]['Rule']
					KnightInspectFrame.RoleTag:SetText((Check == 'Tank' and '|TInterface\\AddOns\\ElvUI\\media\\textures\\tank.tga:14:14:0:1|t' or Check == 'Healer' and '|TInterface\\AddOns\\ElvUI\\media\\textures\\healer.tga:14:14:0:0|t' or '|TInterface\\AddOns\\ElvUI\\media\\textures\\dps.tga:14:14:0:-1|t')..KF.Memory['Table']['ClassRole'][Class][SpecData['CurrentSpec']]['ClassColor']..SpecData['CurrentSpec'])
					KnightInspectFrame.Spec.text:SetText('|cffceff00■|r '..SPECIALIZATION..' : '..(Check == 'Tank' and '|TInterface\\AddOns\\ElvUI\\media\\textures\\tank.tga:14:14:0:-1|t' or Check == 'Healer' and '|TInterface\\AddOns\\ElvUI\\media\\textures\\healer.tga:14:14:0:0|t' or '|TInterface\\AddOns\\ElvUI\\media\\textures\\dps.tga:14:14:0:-1|t')..KF.Memory['Table']['ClassRole'][Class][SpecData['CurrentSpec']]['ClassColor']..SpecData['CurrentSpec'])
				else
					KnightInspectFrame.SpecIcon['Texture']:SetTexture(nil)
					KnightInspectFrame.RoleTag:SetText('|cffff0000'..L['NoTalent'])
					KnightInspectFrame.Spec.text:SetText('|cffceff00■|r '..SPECIALIZATION..' : |cffff0000'..L['NoTalent'])
				end
				
				for i = 1, 18 do -- Talents COMPLETE
					local _, _, UnitClassID = UnitClass(CurrentInspectUnit)
					local CurrentLevelTab = ceil(i/3)
					
					if Level >= CurrentLevelTab * 15 then
						KnightInspectFrame.Spec['TalentGroup'..CurrentLevelTab].text:SetText('|cffceff00'..(CurrentLevelTab * 15))
					else
						KnightInspectFrame.Spec['TalentGroup'..CurrentLevelTab].text:SetText('|cffff0000'..(CurrentLevelTab * 15))
					end
					
					SpecData['Talent'..i]['Name'], SpecData['Talent'..i]['Texture'], _, _, SpecData['Talent'..i]['Selected'], _ = GetTalentInfo(i, true, nil, CurrentInspectUnit, UnitClassID)
					SpecData['Talent'..i]['Link'] = GetTalentLink(i, true, UnitClassID)
					
					KnightInspectFrame.Spec['Talent'..i].Icon['Texture']:SetTexture(SpecData['Talent'..i]['Texture'])
					KnightInspectFrame.Spec['Talent'..i].text:SetText(SpecData['Talent'..i]['Name'])
					
					if SpecData['Talent'..i]['Selected'] then
						KnightInspectFrame.Spec['Talent'..i].Icon['Texture']:SetAlpha(1)
						KnightInspectFrame.Spec['Talent'..i]:SetBackdropColor(0.3, 0.3, 0.3)
						KnightInspectFrame.Spec['Talent'..i]:SetBackdropBorderColor(0.18, 0.72, 0.9)
						KnightInspectFrame.Spec['Talent'..i].Icon:SetBackdropBorderColor(0.18, 0.72, 0.9)
					else
						KnightInspectFrame.Spec['Talent'..i].Icon['Texture']:SetAlpha(0.2)
						if Level >= CurrentLevelTab * 15 then
							KnightInspectFrame.Spec['Talent'..i]:SetBackdropColor(0.19, 0.19, 0.19)
							KnightInspectFrame.Spec['Talent'..i]:SetBackdropBorderColor(unpack(E['media'].bordercolor))
							KnightInspectFrame.Spec['Talent'..i].Icon:SetBackdropBorderColor(unpack(E['media'].bordercolor))
						else
							KnightInspectFrame.Spec['Talent'..i]:SetBackdropColor(0.08, 0.08, 0.08)
							KnightInspectFrame.Spec['Talent'..i]:SetBackdropBorderColor(0.4, 0, 0, 1)
							KnightInspectFrame.Spec['Talent'..i].Icon:SetBackdropBorderColor(0.4, 0, 0, 1)
						end
					end
				end
				
				for i = 1, 6 do -- Glyphs COMPLETE
					local SpellID, GlyphTexture
					
					_, _, _, SpellID, GlyphTexture, SpecData['Glyph'..i] = GetGlyphSocketInfo(i, nil, true, CurrentInspectUnit)
					
					KnightInspectFrame.Spec['Glyph'..i].Icon['Texture']:SetTexture(GlyphTexture)
					
					if SpecData['Glyph'..i] then
						SpecData['Glyph'..i] = GetGlyphLinkByID(SpecData['Glyph'..i])
					
						--fuck getting glyphs name
						local GlyphName
						_, GlyphName = string.split(':', select(1, GetSpellInfo(SpellID)), 2)
						GlyphName = string.gsub(GlyphName, ' ', '', 1)
					
						KnightInspectFrame.Spec['Glyph'..i].text:SetText('|cff93daff'..GlyphName)
						KnightInspectFrame.Spec['Glyph'..i]:SetBackdropColor(0.3, 0.3, 0.3)
						KnightInspectFrame.Spec['Glyph'..i]:SetBackdropBorderColor(unpack(E['media'].bordercolor))
						KnightInspectFrame.Spec['Glyph'..i].Icon:SetBackdropBorderColor(unpack(E['media'].bordercolor))
					else
						local destLevel = ceil(i/2) * 25
						if Level >= destLevel then
							KnightInspectFrame.Spec['Glyph'..i].text:SetText('|cffff0000'..L['Empty'])
							KnightInspectFrame.Spec['Glyph'..i]:SetBackdropColor(0.19, 0.19, 0.19)
							KnightInspectFrame.Spec['Glyph'..i]:SetBackdropBorderColor(unpack(E['media'].bordercolor))
							KnightInspectFrame.Spec['Glyph'..i].Icon:SetBackdropBorderColor(unpack(E['media'].bordercolor))
						else
							KnightInspectFrame.Spec['Glyph'..i].text:SetText('|cffceff00'..destLevel..L['NeedLevel'])
							KnightInspectFrame.Spec['Glyph'..i]:SetBackdropColor(0.08, 0.08, 0.08)
							KnightInspectFrame.Spec['Glyph'..i]:SetBackdropBorderColor(0.4, 0, 0)
							KnightInspectFrame.Spec['Glyph'..i].Icon:SetBackdropBorderColor(0.4, 0, 0)
						end
					end
				end
			end
			
			PlaySound('igCharacterInfoOpen')
			KnightInspectFrame:Show()
			KnightInspectFrame.Model:SetUnit(CurrentInspectUnit)
			TimeWhenInspectOver = floor(GetTime())
			
			SwitchDisplayFrame(KF.db.Extra_Functions.Inspect.DisplayPage)
			
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
			
			ClearInspectPlayer()
			KF.UpdateFrame.UpdateList.NotifyInspect.Condition = false
			KF.Memory['Event']['INSPECT_READY']['KnightInspect'] = nil
		end
	end
	
	
	-----------------------------------------------------------
	-- [ Knight : Redifine 									]--
	-----------------------------------------------------------	
	InspectUnit = function(unit)
		if not UnitExists(unit) then return
		elseif not UnitIsVisible(unit) then
			print(L['KF']..' : '..L['Cannot Inspect because target unit is out of range to inspect.'])
			return
		elseif not UnitIsPlayer(unit) then
			return
		else
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
		
			CurrentInspectUnit = unit
			CurrentInspectUnitGUID = UnitGUID(unit)
			ReInspectCount = 3
			
			Title = UnitPVPName(unit)
			Class = select(2, UnitClass(unit))
			Level = UnitLevel(unit)
			guildName, guildRankName, _ = GetGuildInfo(unit)
			
			KF:RegisterEventList('INSPECT_READY', INSPECT_READY, 'KnightInspect')
			if E.private['tooltip'].enable ~= false then
				TT.UpdateInspect:Hide()
				TT:RegisterEvent('INSPECT_READY')
			end
			
			KF.UpdateFrame.UpdateList.NotifyInspect.Condition = true
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
	
	
	-----------------------------------------------------------
	-- [ Knight : Initialize KnightInspectFrame				]--
	-----------------------------------------------------------
	local PANEL_HEIGHT = 22
	local SIDE_BUTTON_WIDTH = 16
	local SPACING = 3
	
	
	do --<< KnightInspectFrame >>--
		CreateFrame('Frame', 'KnightInspectFrame', E.UIParent)
		KnightInspectFrame:Size(350,450)
		if KF.db.Extra_Functions.Inspect.TransparentBackground == true then
			KnightInspectFrame:CreateBackdrop('Transparent')
		else
			KnightInspectFrame:SetTemplate('Default', true)
		end
		KnightInspectFrame:SetFrameStrata('DIALOG')
		KnightInspectFrame:SetFrameLevel(10)
		KnightInspectFrame:EnableMouse(1)
		KnightInspectFrame:SetMovable(true)
		KnightInspectFrame:Hide()
		KnightInspectFrame:SetScript('OnHide', function()
			PlaySound('igCharacterInfoClose')
			KF.UpdateFrame.UpdateList.NotifyInspect.Condition = false
			KF.Memory['Event']['INSPECT_READY']['KnightInspect'] = nil
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
		
		KF:TextSetting(KnightInspectFrame.Tab, '■ |cff2eb7e4Knight Inspect', 10, 'LEFT', 'LEFT', 3, 1)
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
		KF:TextSetting(KnightInspectFrame.BP, 'Elapsed : |cff2eb7e430', 10, 'RIGHT', 'RIGHT', -3, 1)
		KnightInspectFrame.BP.TimeText = KnightInspectFrame.BP.text
		KF:TextSetting(KnightInspectFrame.BP, '', 10, 'LEFT', 'LEFT', 4, 1)
		
		--<< KnightInspectFrame : Specialization Icon >>--
		KnightInspectFrame.SpecIcon = CreateFrame('Frame', nil, KnightInspectFrame)
		KnightInspectFrame.SpecIcon:Size(44)
		KnightInspectFrame.SpecIcon:SetTemplate('Default', true)
		KnightInspectFrame.SpecIcon['Texture'] = KnightInspectFrame.SpecIcon:CreateTexture(nil, 'OVERLAY')
		KnightInspectFrame.SpecIcon['Texture']:SetTexCoord(unpack(E.TexCoords))
		KnightInspectFrame.SpecIcon['Texture']:SetInside()
		KnightInspectFrame.SpecIcon:Point('TOPRIGHT', KnightInspectFrame.Tab, 'BOTTOMRIGHT', -6, -8)
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
			KnightInspectFrame[SlotName]['ilvl'] = KnightInspectFrame:CreateFontString(nil, 'OVERLAY')
			KnightInspectFrame[SlotName]['ilvl']:FontTemplate(nil, nil, 'OUTLINE')
			KnightInspectFrame[SlotName]['ilvl']:SetJustifyH(GearData[SlotName])
			KnightInspectFrame[SlotName]['hover']:SetTexture(1, 1, 1, 0.3)
			KnightInspectFrame[SlotName]:SetHighlightTexture(KnightInspectFrame[SlotName]['hover'])
			
			KnightInspectFrame[SlotName]:SetScript('OnClick', function(self)
				if IsShiftKeyDown() and GearData[SlotName] ~= false then
					ChatEdit_InsertLink(select(2, GetItemInfo(GearData[SlotName])))
				end
			end)
			KnightInspectFrame[SlotName]:SetScript('OnEnter', function(self)
				if GearData[SlotName] ~= false then
					GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
					GameTooltip:SetHyperlink(GearData[SlotName])
					GameTooltip:Show()
				end
			end)
			KnightInspectFrame[SlotName]:SetScript('OnLeave', function() GameTooltip:Hide() end)
		end
		
		--<< Location >>--
		KnightInspectFrame['HeadSlot']:Point('BOTTOMLEFT', KnightInspectFrame['NeckSlot'], 'TOPLEFT', 0, SPACING)
		KnightInspectFrame['HeadSlot']['ilvl']:Point('LEFT', KnightInspectFrame['HeadSlot'], 'RIGHT', 4, 0)
		KnightInspectFrame['NeckSlot']:Point('BOTTOMLEFT', KnightInspectFrame['ShoulderSlot'], 'TOPLEFT', 0, SPACING)
		KnightInspectFrame['NeckSlot']['ilvl']:Point('LEFT', KnightInspectFrame['NeckSlot'], 'RIGHT', 4, 0)
		KnightInspectFrame['ShoulderSlot']:Point('BOTTOMLEFT', KnightInspectFrame['BackSlot'], 'TOPLEFT', 0, SPACING)
		KnightInspectFrame['ShoulderSlot']['ilvl']:Point('LEFT', KnightInspectFrame['ShoulderSlot'], 'RIGHT', 4, 0)
		KnightInspectFrame['BackSlot']:Point('BOTTOMLEFT', KnightInspectFrame['ChestSlot'], 'TOPLEFT', 0, SPACING)
		KnightInspectFrame['BackSlot']['ilvl']:Point('LEFT', KnightInspectFrame['BackSlot'], 'RIGHT', 4, 0)
		KnightInspectFrame['ChestSlot']:Point('BOTTOMLEFT', KnightInspectFrame['ShirtSlot'], 'TOPLEFT', 0, SPACING)
		KnightInspectFrame['ChestSlot']['ilvl']:Point('LEFT', KnightInspectFrame['ChestSlot'], 'RIGHT', 4, 0)
		KnightInspectFrame['ShirtSlot']:Point('BOTTOMLEFT', KnightInspectFrame['TabardSlot'], 'TOPLEFT', 0, SPACING)
		KnightInspectFrame['ShirtSlot']['ilvl']:Point('LEFT', KnightInspectFrame['ShirtSlot'], 'RIGHT', 4, 0)
		KnightInspectFrame['TabardSlot']:Point('BOTTOMLEFT', KnightInspectFrame['WristSlot'], 'TOPLEFT', 0, SPACING)
		KnightInspectFrame['TabardSlot']['ilvl']:Point('LEFT', KnightInspectFrame['TabardSlot'], 'RIGHT', 4, 0)
		KnightInspectFrame['WristSlot']:Point('BOTTOMLEFT', KnightInspectFrame.BP, 'TOPLEFT', 1, SPACING - 1)
		KnightInspectFrame['WristSlot']['ilvl']:Point('LEFT', KnightInspectFrame['WristSlot'], 'RIGHT', 4, 0)
		
		KnightInspectFrame['HandsSlot']:Point('BOTTOMRIGHT', KnightInspectFrame['WaistSlot'], 'TOPRIGHT', 0, SPACING)
		KnightInspectFrame['HandsSlot']['ilvl']:Point('RIGHT', KnightInspectFrame['HandsSlot'], 'LEFT', -2, 0)
		KnightInspectFrame['WaistSlot']:Point('BOTTOMRIGHT', KnightInspectFrame['LegsSlot'], 'TOPRIGHT', 0, SPACING)
		KnightInspectFrame['WaistSlot']['ilvl']:Point('RIGHT', KnightInspectFrame['WaistSlot'], 'LEFT', -2, 0)
		KnightInspectFrame['LegsSlot']:Point('BOTTOMRIGHT', KnightInspectFrame['FeetSlot'], 'TOPRIGHT', 0, SPACING)
		KnightInspectFrame['LegsSlot']['ilvl']:Point('RIGHT', KnightInspectFrame['LegsSlot'], 'LEFT', -2, 0)
		KnightInspectFrame['FeetSlot']:Point('BOTTOMRIGHT', KnightInspectFrame['Finger0Slot'], 'TOPRIGHT', 0, SPACING)
		KnightInspectFrame['FeetSlot']['ilvl']:Point('RIGHT', KnightInspectFrame['FeetSlot'], 'LEFT', -2, 0)
		KnightInspectFrame['Finger0Slot']:Point('BOTTOMRIGHT', KnightInspectFrame['Finger1Slot'], 'TOPRIGHT', 0, SPACING)
		KnightInspectFrame['Finger0Slot']['ilvl']:Point('RIGHT', KnightInspectFrame['Finger0Slot'], 'LEFT', -2, 0)
		KnightInspectFrame['Finger1Slot']:Point('BOTTOMRIGHT', KnightInspectFrame['Trinket0Slot'], 'TOPRIGHT', 0, SPACING)
		KnightInspectFrame['Finger1Slot']['ilvl']:Point('RIGHT', KnightInspectFrame['Finger1Slot'], 'LEFT', -2, 0)
		KnightInspectFrame['Trinket0Slot']:Point('BOTTOMRIGHT', KnightInspectFrame['Trinket1Slot'], 'TOPRIGHT', 0, SPACING)
		KnightInspectFrame['Trinket0Slot']['ilvl']:Point('RIGHT', KnightInspectFrame['Trinket0Slot'], 'LEFT', -2, 0)
		KnightInspectFrame['Trinket1Slot']:Point('BOTTOMRIGHT', KnightInspectFrame.BP, 'TOPRIGHT', -1, SPACING - 1)
		KnightInspectFrame['Trinket1Slot']['ilvl']:Point('RIGHT', KnightInspectFrame['Trinket1Slot'], 'LEFT', -2, 0)
		
		KnightInspectFrame['MainHandSlot']:Point('BOTTOMRIGHT', KnightInspectFrame.BP, 'BOTTOM', -2, E.PixelMode and SPACING + 1 or SPACING + 2)
		KnightInspectFrame['MainHandSlot']['ilvl']:Point('BOTTOM', KnightInspectFrame['MainHandSlot'], 'TOP', 1, 3)
		KnightInspectFrame['SecondaryHandSlot']:Point('BOTTOMLEFT', KnightInspectFrame.BP, 'BOTTOM', 2, E.PixelMode and SPACING + 1 or SPACING + 2)
		KnightInspectFrame['SecondaryHandSlot']['ilvl']:Point('BOTTOM', KnightInspectFrame['SecondaryHandSlot'], 'TOP', 1, 3)
	end

	
	do --<< ModelFrame >>-- COMPLETE
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
		KnightInspectFrame.Spec:SetBackdrop({
			bgFile = E['media'].blankTex,
			edgeFile = false,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		KnightInspectFrame.Spec:SetBackdropColor(0.3, 0.3, 0.3)
		KnightInspectFrame.Spec:Point('TOPLEFT', KnightInspectFrame['HeadSlot'], 'TOPRIGHT', 4, 0)
		KnightInspectFrame.Spec:Point('TOPRIGHT', KnightInspectFrame['HandsSlot'], 'TOPLEFT', -4, 0)
		KnightInspectFrame.Spec:Point('BOTTOM', KnightInspectFrame.BP, 'TOP', 0, 2)
		KnightInspectFrame.Spec:SetFrameLevel(11)
		KF:TextSetting(KnightInspectFrame.Spec, '', 12, 'LEFT', 'TOPLEFT', 6, -18)
		
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
			KnightInspectFrame.Spec['Talent'..i]:Size(74,22)
			KnightInspectFrame.Spec['Talent'..i].Icon = CreateFrame('Frame', nil, KnightInspectFrame.Spec['Talent'..i])
			KnightInspectFrame.Spec['Talent'..i].Icon:Size(18)
			KnightInspectFrame.Spec['Talent'..i].Icon:SetTemplate('Default', true)
			KnightInspectFrame.Spec['Talent'..i].Icon['Texture'] = KnightInspectFrame.Spec['Talent'..i].Icon:CreateTexture(nil, 'OVERLAY')
			KnightInspectFrame.Spec['Talent'..i].Icon['Texture']:SetTexCoord(unpack(E.TexCoords))
			KnightInspectFrame.Spec['Talent'..i].Icon['Texture']:SetInside()
			KnightInspectFrame.Spec['Talent'..i].Icon:Point('LEFT', KnightInspectFrame.Spec['Talent'..i], 2, 0)
			KF:TextSetting(KnightInspectFrame.Spec['Talent'..i], '', 7, 'LEFT', 'LEFT', KnightInspectFrame.Spec['Talent'..i].Icon, 'RIGHT', 4, 0)
			KnightInspectFrame.Spec['Talent'..i].text:Point('RIGHT', KnightInspectFrame.Spec['Talent'..i], -2, 0)
			
			KnightInspectFrame.Spec['Talent'..i].tooltip = CreateFrame('Button', nil, KnightInspectFrame.Spec['Talent'..i])
			KnightInspectFrame.Spec['Talent'..i].tooltip:SetFrameLevel(14)
			KnightInspectFrame.Spec['Talent'..i].tooltip:SetInside()
			
			KnightInspectFrame.Spec['Talent'..i].tooltip:SetScript('OnClick', function(self)
				if IsShiftKeyDown() and SpecData['Talent'..i]['Link'] then
					ChatEdit_InsertLink(SpecData['Talent'..i]['Link'])
				end
			end)
			KnightInspectFrame.Spec['Talent'..i].tooltip:SetScript('OnEnter', function(self)
				if SpecData['Talent'..i]['Link'] then
					GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
					GameTooltip:SetHyperlink(SpecData['Talent'..i]['Link'])
					GameTooltip:Show()
				end
			end)
			KnightInspectFrame.Spec['Talent'..i].tooltip:SetScript('OnLeave', function() GameTooltip:Hide() end)
		end
		
		KnightInspectFrame.Spec['Talent1']:Point('RIGHT', KnightInspectFrame.Spec['Talent2'], 'LEFT', -2, 0)
		KnightInspectFrame.Spec['Talent2']:Point('TOP', KnightInspectFrame.Spec, 11, -42)
		KnightInspectFrame.Spec['Talent3']:Point('LEFT', KnightInspectFrame.Spec['Talent2'], 'RIGHT', 2, 0)
		KnightInspectFrame.Spec['Talent4']:Point('RIGHT', KnightInspectFrame.Spec['Talent5'], 'LEFT', -2, 0)
		KnightInspectFrame.Spec['Talent5']:Point('TOP', KnightInspectFrame.Spec['Talent2'], 'BOTTOM', 0, -9)
		KnightInspectFrame.Spec['Talent6']:Point('LEFT', KnightInspectFrame.Spec['Talent5'], 'RIGHT', 2, 0)
		KnightInspectFrame.Spec['Talent7']:Point('RIGHT', KnightInspectFrame.Spec['Talent8'], 'LEFT', -2, 0)
		KnightInspectFrame.Spec['Talent8']:Point('TOP', KnightInspectFrame.Spec['Talent5'], 'BOTTOM', 0, -9)
		KnightInspectFrame.Spec['Talent9']:Point('LEFT', KnightInspectFrame.Spec['Talent8'], 'RIGHT', 2, 0)
		KnightInspectFrame.Spec['Talent10']:Point('RIGHT', KnightInspectFrame.Spec['Talent11'], 'LEFT', -2, 0)
		KnightInspectFrame.Spec['Talent11']:Point('TOP', KnightInspectFrame.Spec['Talent8'], 'BOTTOM', 0, -9)
		KnightInspectFrame.Spec['Talent12']:Point('LEFT', KnightInspectFrame.Spec['Talent11'], 'RIGHT', 2, 0)
		KnightInspectFrame.Spec['Talent13']:Point('RIGHT', KnightInspectFrame.Spec['Talent14'], 'LEFT', -2, 0)
		KnightInspectFrame.Spec['Talent14']:Point('TOP', KnightInspectFrame.Spec['Talent11'], 'BOTTOM', 0, -9)
		KnightInspectFrame.Spec['Talent15']:Point('LEFT', KnightInspectFrame.Spec['Talent14'], 'RIGHT', 2, 0)
		KnightInspectFrame.Spec['Talent16']:Point('RIGHT', KnightInspectFrame.Spec['Talent17'], 'LEFT', -2, 0)
		KnightInspectFrame.Spec['Talent17']:Point('TOP', KnightInspectFrame.Spec['Talent14'], 'BOTTOM', 0, -9)
		KnightInspectFrame.Spec['Talent18']:Point('LEFT', KnightInspectFrame.Spec['Talent17'], 'RIGHT', 2, 0)
		
		for i = 1, 6 do
			KnightInspectFrame.Spec['TalentGroup'..i]:Point('TOPLEFT', KnightInspectFrame.Spec['Talent'..(1 + 3*(i-1))], -25, 3)
			KnightInspectFrame.Spec['TalentGroup'..i]:Point('BOTTOMRIGHT', KnightInspectFrame.Spec['Talent'..(3 + 3*(i-1))], 3, -3)
			KF:TextSetting(KnightInspectFrame.Spec['TalentGroup'..i], '', 9, nil, 'LEFT', 4, 0)
			KnightInspectFrame.Spec['TalentGroup'..i].text:Point('RIGHT', KnightInspectFrame.Spec['Talent'..(1 + 3*(i-1))], 'LEFT', -3, 0)
		end
		
		
		for i = 1, 6 do
			KnightInspectFrame.Spec['Glyph'..i] = CreateFrame('Button', nil, KnightInspectFrame.Spec)
			KnightInspectFrame.Spec['Glyph'..i]:SetBackdrop({
				bgFile = E['media'].blankTex,
				edgeFile = E['media'].blankTex,
				tile = false, tileSize = 0, edgeSize = E.mult,
				insets = { left = 0, right = 0, top = 0, bottom = 0}
			})
			KnightInspectFrame.Spec['Glyph'..i]:SetFrameLevel(13)
			KnightInspectFrame.Spec['Glyph'..i]:Size(114,22)
			KnightInspectFrame.Spec['Glyph'..i].Icon = CreateFrame('Frame', nil, KnightInspectFrame.Spec['Glyph'..i])
			KnightInspectFrame.Spec['Glyph'..i].Icon:Size(18)
			KnightInspectFrame.Spec['Glyph'..i].Icon:SetTemplate('Default', true)
			KnightInspectFrame.Spec['Glyph'..i].Icon['Texture'] = KnightInspectFrame.Spec['Glyph'..i].Icon:CreateTexture(nil, 'OVERLAY')
			KnightInspectFrame.Spec['Glyph'..i].Icon['Texture']:SetTexCoord(unpack(E.TexCoords))
			KnightInspectFrame.Spec['Glyph'..i].Icon['Texture']:SetInside()
			KF:TextSetting(KnightInspectFrame.Spec['Glyph'..i], '', 7, 'CENTER', 'LEFT', 2, 0)
			KnightInspectFrame.Spec['Glyph'..i].text:Point('RIGHT', -2, 0)
			
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
		
		KnightInspectFrame.Spec['Glyph1']:Point('BOTTOMLEFT', KnightInspectFrame.Spec['Glyph3'], 'TOPLEFT', 0, 2)
		KnightInspectFrame.Spec['Glyph1'].Icon:Point('LEFT', -8, 0)
		KnightInspectFrame.Spec['Glyph2']:Point('BOTTOMRIGHT', KnightInspectFrame.Spec['Glyph4'], 'TOPRIGHT', 0, 2)
		KnightInspectFrame.Spec['Glyph2'].Icon:Point('RIGHT', 8, 0)
		KnightInspectFrame.Spec['Glyph3']:Point('BOTTOMLEFT', KnightInspectFrame.Spec['Glyph5'], 'TOPLEFT', 0, 2)
		KnightInspectFrame.Spec['Glyph3'].Icon:Point('LEFT', -8, 0)
		KnightInspectFrame.Spec['Glyph4']:Point('BOTTOMRIGHT', KnightInspectFrame.Spec['Glyph6'], 'TOPRIGHT', 0, 2)
		KnightInspectFrame.Spec['Glyph4'].Icon:Point('RIGHT', 8, 0)
		KnightInspectFrame.Spec['Glyph5']:Point('BOTTOMLEFT', KnightInspectFrame.Spec, 'BOTTOM', 10, 19)
		KnightInspectFrame.Spec['Glyph5'].Icon:Point('LEFT', -8, 0)
		KnightInspectFrame.Spec['Glyph6']:Point('BOTTOMRIGHT', KnightInspectFrame.Spec, 'BOTTOM', -10, 19)
		KnightInspectFrame.Spec['Glyph6'].Icon:Point('RIGHT', 8, 0)
		
		
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
		end
		KnightInspectFrame.Spec['GlyphGroup1']:Point('TOPLEFT', KnightInspectFrame.Spec['Glyph2'], -3, 3)
		KnightInspectFrame.Spec['GlyphGroup1']:Point('BOTTOMRIGHT', KnightInspectFrame.Spec, 'BOTTOM', -7, 3)
		KnightInspectFrame.Spec['GlyphGroup2']:Point('TOPRIGHT', KnightInspectFrame.Spec['Glyph1'], 3, 3)
		KnightInspectFrame.Spec['GlyphGroup2']:Point('BOTTOMLEFT', KnightInspectFrame.Spec, 'BOTTOM', 7, 3)
		
		KF:TextSetting(KnightInspectFrame.Spec['GlyphGroup1'], '< |cff93daff주문양|r >', 8, nil, 'BOTTOMLEFT', 5, 4)
		KnightInspectFrame.Spec['GlyphGroup1'].text:Point('RIGHT', KnightInspectFrame['MainHandSlot'], 'LEFT', -2, 0)
		KF:TextSetting(KnightInspectFrame.Spec['GlyphGroup2'], '< |cff93daff보조문양|r >', 8, nil, 'BOTTOMRIGHT', -2, 4)
		KnightInspectFrame.Spec['GlyphGroup2'].text:Point('LEFT', KnightInspectFrame['SecondaryHandSlot'], 'RIGHT', 2, 0)
	end
	
	
	do --<< PvP Info Frame >>--
		KnightInspectFrame.PvPInfo = CreateFrame('Frame', nil, KnightInspectFrame)
	end
	
	
	do --<< Buttons >>-
		-- 1. ModelFrame
		KnightInspectFrame.Button1 = CreateFrame('Button', nil, KnightInspectFrame)
		KnightInspectFrame.Button1:SetBackdrop({
			bgFile = E['media'].blankTex,
			edgeFile = E['media'].blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		KnightInspectFrame.Button1:SetBackdropColor(0.2, 0.2, 0.2, 1)
		KnightInspectFrame.Button1:SetBackdropBorderColor(unpack(E['media'].bordercolor))
		KnightInspectFrame.Button1:Size(44,18)
		KnightInspectFrame.Button1:SetFrameLevel(14)
		KF:TextSetting(KnightInspectFrame.Button1, L['ShowModelFrame'], 9)
		KnightInspectFrame.Button1:SetScript('OnEnter', function(self) self.text:SetText('|cffceff00'..L['ShowModelFrame']) self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor)) end)
		KnightInspectFrame.Button1:SetScript('OnLeave', function(self) if KF.db.Extra_Functions.Inspect.DisplayPage ~= 'Model' then self.text:SetText(L['ShowModelFrame']) end self:SetBackdropBorderColor(unpack(E.media.bordercolor)) end)
		KnightInspectFrame.Button1:SetScript('OnClick', function() SwitchDisplayFrame('Model') end)
		
		-- 2. Specialization Frame
		KnightInspectFrame.Button2 = CreateFrame('Button', nil, KnightInspectFrame)
		KnightInspectFrame.Button2:SetBackdrop({
			bgFile = E['media'].blankTex,
			edgeFile = E['media'].blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		KnightInspectFrame.Button2:SetBackdropColor(0.2, 0.2, 0.2, 1)
		KnightInspectFrame.Button2:SetBackdropBorderColor(unpack(E['media'].bordercolor))
		KnightInspectFrame.Button2:Size(44,18)
		KnightInspectFrame.Button2:SetFrameLevel(14)
		KF:TextSetting(KnightInspectFrame.Button2, L['ShowSpecializationFrame'], 9)
		KnightInspectFrame.Button2:SetScript('OnEnter', function(self) self.text:SetText('|cffceff00'..L['ShowSpecializationFrame']) self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor)) end)
		KnightInspectFrame.Button2:SetScript('OnLeave', function(self) if KF.db.Extra_Functions.Inspect.DisplayPage ~= 'Spec' then self.text:SetText(L['ShowSpecializationFrame']) end self:SetBackdropBorderColor(unpack(E.media.bordercolor)) end)
		KnightInspectFrame.Button2:SetScript('OnClick', function() SwitchDisplayFrame('Spec') end)
		
		-- 3. PvP Info Frame
		KnightInspectFrame.Button3 = CreateFrame('Button', nil, KnightInspectFrame)
		KnightInspectFrame.Button3:SetBackdrop({
			bgFile = E['media'].blankTex,
			edgeFile = E['media'].blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		KnightInspectFrame.Button3:SetBackdropColor(0.2, 0.2, 0.2, 1)
		KnightInspectFrame.Button3:SetBackdropBorderColor(unpack(E['media'].bordercolor))
		KnightInspectFrame.Button3:Size(44,18)
		KnightInspectFrame.Button3:SetFrameLevel(14)
		KF:TextSetting(KnightInspectFrame.Button3, L['ShowPvPInfoFrame'], 9)
		KnightInspectFrame.Button3:SetScript('OnEnter', function(self) self.text:SetText('|cffceff00'..L['ShowPvPInfoFrame']) self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor)) end)
		KnightInspectFrame.Button3:SetScript('OnLeave', function(self) if KF.db.Extra_Functions.Inspect.DisplayPage ~= 'PvPInfo' then self.text:SetText(L['ShowPvPInfoFrame']) end self:SetBackdropBorderColor(unpack(E.media.bordercolor)) end)
		KnightInspectFrame.Button3:SetScript('OnClick', function() SwitchDisplayFrame('PvPInfo') end)
		
		KnightInspectFrame.Button1:Point('RIGHT', KnightInspectFrame.Button2, 'LEFT', -4, 0)
		KnightInspectFrame.Button2:Point('TOP', KnightInspectFrame.Tab, 'BOTTOM', 0, -74)
		KnightInspectFrame.Button3:Point('LEFT', KnightInspectFrame.Button2, 'RIGHT', 4, 0)
	end
end