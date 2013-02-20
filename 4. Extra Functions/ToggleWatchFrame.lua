--local E, L, V, P, G, _  = unpack(ElvUI)
local E, L, _, _, _, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

-----------------------------------------------------------
-- [ Knight : Toggle Quest Watchframe					]--
-----------------------------------------------------------
if KF.UIParent and KF.db.Extra_Functions.ToggleWatchFrame ~= false then
	local Toggled = false
	local Exception_Boss = {
		--['bossGUID'] = true <- when you write like this, this function will not active.
	}
	
	KF.BossBattleStart:HookScript('OnShow', function()
		local bossName, bossLevel, playerLevel
		for i = 1, 4 do
			bossName, _ = UnitName('boss'..i)
			if bossName then
				if Exception_Boss[UnitGUID('boss'..i)] then return end
				
				bossLevel = UnitLevel('boss'..i)
				playerLevel = UnitLevel('player')
				if not (bossLevel == -1 or UnitClassification('boss'..i) == 'worldboss') and (bossLevel > playerLevel + 6 or bossLevel < playerLevel - 6) then return end
			end
		end
		
		if WatchFrameLines:IsVisible() and WatchFrameCollapseExpandButton:IsShown() and Toggled == false then
			Toggled = true
			WatchFrameCollapseExpandButton:Click()
			print(L['KF']..' : '..L['Hide Watchframe because of entering boss battle.'])
		end
	end)
	
	KF.BossBattleStart:HookScript('OnHide', function()
		if not WatchFrameLines:IsVisible() and WatchFrameCollapseExpandButton:IsShown() and Toggled == true then
			WatchFrameCollapseExpandButton:Click()
			Toggled = false
		end
	end)
end