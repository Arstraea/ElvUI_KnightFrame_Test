--local E, L, V, P, G, _  = unpack(ElvUI)
local E, L, _, P, _, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

if KF.UIParent and KF.db.Extra_Functions.ItemLevel ~= false then
	-----------------------------------------------------------
	-- [ Knight : Item Level								]--
	-----------------------------------------------------------
	local Slots = {	--SlotName = Direction to show ItemLevel
		['Head'] = 'RIGHT',
		['Neck'] = 'RIGHT',
		['Shoulder'] = 'RIGHT',
		['Back'] = 'RIGHT',
		['Chest'] = 'RIGHT',
		['Wrist'] = 'RIGHT',
		['Hands'] = 'LEFT',
		['Waist'] = 'LEFT',
		['Legs'] = 'LEFT',
		['Feet'] = 'LEFT',
		['Finger0'] = 'LEFT',
		['Finger1'] = 'LEFT',
		['Trinket0'] = 'LEFT',
		['Trinket1'] = 'LEFT',
		['MainHand'] = 'UP',
		['SecondaryHand'] = 'UP',
	}
	
	if not KF.Memory['Table']['ItemUpgrade'] then
		KF.Memory['Table']['ItemUpgrade'] = {
			['0'] = 0,
			['1'] = 8,
			['373'] = 4,
			['374'] = 8,
			['375'] = 4,
			['376'] = 4,
			['377'] = 4,
			['379'] = 4,
			['380'] = 4,
			['445'] = 0,
			['446'] = 4,
			['447'] = 8,
			['451'] = 0,
			['452'] = 8,
			['453'] = 0,
			['454'] = 4,
			['455'] = 8,
			['456'] = 0,
			['457'] = 8,
			['458'] = 0,
			['459'] = 4,
			['460'] = 8,
			['461'] = 12,
			['462'] = 16,
		}
	end
	
	local ItemCount, Total, TargetFrame, CheckingItem, ItemLevel, IsUpgraded
	local function ItemLevelCalc(TargetPlayer)
		ItemCount, Total, TargetFrame = 0, 0, (TargetPlayer ~= 'Player' and 'Inspect' or 'Character')
		if _G['KF_ItemLevel_'..TargetFrame] then
			for ItemBlock in pairs(Slots) do
				_G[TargetFrame..ItemBlock..'Slot'].text:SetText('')
				CheckingItem = GetInventoryItemLink(TargetPlayer, GetInventorySlotInfo(ItemBlock..'Slot')) or nil
				
				if CheckingItem ~= nil then
					ItemCount = ItemCount + 1
					
					ItemLevel = select(4, GetItemInfo(CheckingItem)) or nil
					IsUpgraded = CheckingItem:match(':(%d+)\124h%[') or nil
					
					if ItemLevel then
						if IsUpgraded then
							ItemLevel = ItemLevel + KF.Memory['Table']['ItemUpgrade'][IsUpgraded]
						end
						
						Total = Total + ItemLevel
						_G[TargetFrame..ItemBlock..'Slot'].text:SetText(ItemLevel..(tonumber(IsUpgraded) > 0 and '|n'..(KF.Memory['Table']['ItemUpgrade'][IsUpgraded] >= 16 and '|cffff9614' or KF.Memory['Table']['ItemUpgrade'][IsUpgraded] >= 12 and '|cfff88ef4' or KF.Memory['Table']['ItemUpgrade'][IsUpgraded] >= 8 and '|cff2eb7e4' or KF.Memory['Table']['ItemUpgrade'][IsUpgraded] >= 4 and '|cffceff00' or '|cffaaaaaa')..'(+'..KF.Memory['Table']['ItemUpgrade'][IsUpgraded]..')|r' or ''))
					end
				end
			end
			_G['KF_ItemLevel_'..TargetFrame].text:SetText(string.format('|cffceff00'..L['Average']..'|r : %.2f', (ItemCount > 0 and Total/ItemCount or 0)))
		end
	end
	KF:RegisterEventList('UNIT_INVENTORY_CHANGED', function() ItemLevelCalc('Player') end)
	KF:RegisterEventList('UPDATE_INVENTORY_DURABILITY', function() ItemLevelCalc('Player') end)
	
	
	KF.Memory['InitializeFunction'][1]['ItemLevel'] = function()
		CreateFrame('Frame', 'KF_ItemLevel_Character', PaperDollFrame)
		KF_ItemLevel_Character:SetFrameStrata('MEDIUM')
		KF_ItemLevel_Character:SetFrameLevel(PaperDollFrame:GetFrameLevel() + 5)
		
		KF_ItemLevel_Character:SetScript('OnShow', function() ItemLevelCalc('Player') end)
		KF:TextSetting(KF_ItemLevel_Character, '', 12, nil, 'BOTTOMLEFT', PaperDollFrame, 8, 14)
		for ItemBlock, TextDirection in pairs(Slots) do
			_G['Character'..ItemBlock..'Slot'].text = _G['Character'..ItemBlock..'Slot']:CreateFontString(nil, 'OVERLAY')
			_G['Character'..ItemBlock..'Slot'].text:FontTemplate(nil, nil, 'OUTLINE')
			if TextDirection == 'RIGHT' then
				_G['Character'..ItemBlock..'Slot'].text:SetJustifyH('LEFT')
				_G['Character'..ItemBlock..'Slot'].text:Point('LEFT', _G['Character'..ItemBlock..'Slot'], 'RIGHT', 3, 0)
			elseif TextDirection == 'LEFT' then
				_G['Character'..ItemBlock..'Slot'].text:SetJustifyH('RIGHT')
				_G['Character'..ItemBlock..'Slot'].text:Point('RIGHT', _G['Character'..ItemBlock..'Slot'], 'LEFT', -3, 0)
			else
				_G['Character'..ItemBlock..'Slot'].text:SetJustifyH('CENTER')
				_G['Character'..ItemBlock..'Slot'].text:Point('BOTTOM', _G['Character'..ItemBlock..'Slot'], 'TOP', 1, 3)
			end
		end
		
		KF:RegisterEventList('ADDON_LOADED', function(_, LoadedAddOn)
			if LoadedAddOn == 'Blizzard_InspectUI' then
				CreateFrame('Frame', 'KF_ItemLevel_Inspect', InspectPaperDollFrame)
				KF_ItemLevel_Inspect:SetFrameStrata('MEDIUM')
				KF_ItemLevel_Inspect:SetFrameLevel(InspectPaperDollFrame:GetFrameLevel() + 5)
				KF:TextSetting(KF_ItemLevel_Inspect, '', 12, nil, 'BOTTOMLEFT', InspectPaperDollFrame, 8, 14)
				
				for ItemBlock, TextDirection in pairs(Slots) do
					_G['Inspect'..ItemBlock..'Slot'].text = _G['Inspect'..ItemBlock..'Slot']:CreateFontString(nil, 'OVERLAY')
					_G['Inspect'..ItemBlock..'Slot'].text:FontTemplate(nil, nil, 'OUTLINE')
					if TextDirection == 'RIGHT' then
						_G['Inspect'..ItemBlock..'Slot'].text:SetJustifyH('LEFT')
						_G['Inspect'..ItemBlock..'Slot'].text:Point('LEFT', _G['Inspect'..ItemBlock..'Slot'], 'RIGHT', 3, 0)
					elseif TextDirection == 'LEFT' then
						_G['Inspect'..ItemBlock..'Slot'].text:SetJustifyH('RIGHT')
						_G['Inspect'..ItemBlock..'Slot'].text:Point('RIGHT', _G['Inspect'..ItemBlock..'Slot'], 'LEFT', -3, 0)
					else
						_G['Inspect'..ItemBlock..'Slot'].text:SetJustifyH('CENTER')
						_G['Inspect'..ItemBlock..'Slot'].text:Point('BOTTOM', _G['Inspect'..ItemBlock..'Slot'], 'TOP', 1, 3)
					end
				end
				
				KF:RegisterEventList('UNIT_INVENTORY_CHANGED', function(unit) if InspectFrame.unit == unit then ItemLevelCalc(InspectFrame.unit) end end)
				KF:RegisterEventList('INSPECT_READY', function() if InspectFrame.unit then ItemLevelCalc(InspectFrame.unit) end end)
				KF.Memory['Event']['ADDON_LOADED']['ItemLevel_InspectInitialize'] = nil
			end
		end, 'ItemLevel_InspectInitialize')
	end
end