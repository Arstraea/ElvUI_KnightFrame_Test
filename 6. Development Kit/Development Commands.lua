--local E, L, V, P, G, _  = unpack(ElvUI);

local E, L, _, P, _, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

	--[[
	KnightInspectFrame.SpecIcon['RoleIcon'] = CreateFrame('Frame', nil, KnightInspectFrame.SpecIcon)
	KnightInspectFrame.SpecIcon['RoleIcon']:Size(20)
	KnightInspectFrame.SpecIcon['RoleIcon'].t = KnightInspectFrame.SpecIcon['RoleIcon']:CreateTexture(nil, 'OVERLAY')
	KnightInspectFrame.SpecIcon['RoleIcon'].t:SetTexture('Interface\\LFGFRAME\\UI-LFG-ICON-ROLES.BLP')
	KnightInspectFrame.SpecIcon['RoleIcon'].t:SetTexCoord(GetTexCoordsForRole("DAMAGER"))
	KnightInspectFrame.SpecIcon['RoleIcon'].t:SetInside()
	KnightInspectFrame.SpecIcon['RoleIcon']:Point('TOPRIGHT', KnightInspectFrame.SpecIcon, 10, 10)
	]]
	
	CreateFrame('GameTooltip', 'TestTooltip', nil, 'GameTooltipTemplate')
	TestTooltip:SetOwner(UIParent, 'ANCHOR_NONE')
	
	local CurrentItemID = 1
	local Gap = 9
	
	function KF:asdf(msg)
		if KF.UpdateFrame.UpdateList.CheckAllItemsSetName.Condition == false then
			if msg ~= '' then
				CurrentItemID = tonumber(msg)
			end
			print('Item ID : |cff2eb7e4'..(CurrentItemID)..'|r 부터 확인시작')
			KF.UpdateFrame.UpdateList.CheckAllItemsSetName.Condition = true
		else
			print('-------- |cffff0000계산멈춤|r --------')
			KF.UpdateFrame.UpdateList.CheckAllItemsSetName.Condition = false
		end
	end
	
	KF.UpdateFrame.UpdateList.CheckAllItemsSetName = {
		['Condition'] = false,
		['Delay'] = 0.5,
		['Action'] = function()
			local ItemName, ItemLink, ItemRarity, ItemType, ItemLocation, ItemID
			local CheckGearSet, SetMax
			
			for i = CurrentItemID, (CurrentItemID + Gap) do
				ItemName, ItemLink, ItemRarity, _, _, ItemType, _, _, ItemLocation, _, _ = GetItemInfo(i)
				
				if ItemName then
					TestTooltip:ClearLines()
					TestTooltip:SetHyperlink(ItemLink)
					local r, g, b = GetItemQualityColor(ItemRarity)
					ItemID = select(2, strsplit(':', string.match(ItemLink, 'item[%-?%d:]+')))
					ItemID = tonumber(ItemID)
					
					for k = 1, TestTooltip:NumLines() do
						CheckGearSet, _, SetMax = _G['TestTooltipTextLeft'..k]:GetText():match('^(.+) %((%d)/(%d)%)$') -- find string likes 'SetName (0/5)'
						
						if CheckGearSet then
							if not KnightFrameDB then
								KnightFrameDB = {}
							end
							if SetMax then
								SetMax = tonumber(SetMax)
							end
							if not KnightFrameDB[CheckGearSet] then
								KnightFrameDB[CheckGearSet] = { ['MaxCount'] = 0, ['Piece'] = {}, }
								print('|cff1784d1--------------------------|r')
								print('|cffff5675세트발견!!|r -> |cffff9614'..CheckGearSet..' 세트|r : '..SetMax..'  '..ItemLink)
								print('|cff1784d1--------------------------|r')
							end
							if SetMax > KnightFrameDB[CheckGearSet]['MaxCount'] then
								KnightFrameDB[CheckGearSet]['MaxCount'] = SetMax
							end
							if ItemLocation and _G[ItemLocation] and ItemType ~= '제조법' then
								KnightFrameDB[CheckGearSet]['Piece'][ItemID] = (_G['TestTooltipTextLeft1']:GetText())..' ('..(_G[ItemLocation])..')'
							end
							break
						end
					end
					
					print('  '..i..' : '..ItemLink..(CheckGearSet and ItemType ~= '제조법' and ' -> |cffff9614'..CheckGearSet..'|r 세트에 추가' or ''))
				end
			end
			CurrentItemID = CurrentItemID + Gap + 1
			print('Item ID : |cffceff00'..(CurrentItemID - 1)..'|r 까지 확인함')
			if CurrentItemID > 120000 then KF.UpdateFrame.UpdateList.CheckAllItemsSetName.Condition = false end
		end,
	}
	
	KF:RegisterChatCommand('asdf', 'asdf')