local E, L, V, P, G, _  = unpack(ElvUI);
local KF = E:GetModule('KnightFrame');
local KFTQ = E:NewModule('KF_ToggleQuest', 'AceEvent-3.0', 'AceHook-3.0');

if not (E.db.KnightFrame.Install_Complete == nil or E.db.KnightFrame.Install_Complete == 'NotInstalled') then
	--Toggle Quest
	L["ToggleQuest"] = "보스전 추적 숨기기"
	L["Hide quest watchframe during boss battle."] = "보스와의 전투 시 퀘스트 추적 프레임을 자동으로 숨겨줍니다."
	L['Hide Watchframe because of entering battle of boss.'] = '주요 보스와의 전투를 감지하여 퀘스트프레임을 숨깁니다.'
	
	E.Options.args.KnightFrame.args.Extra_Function.args.ToggleQuest = {
		name = " |cff2eb7e4"..L["ToggleQuest"],
		desc = L["Hide quest watchframe during boss battle."],
		type = "toggle",
		order = 17,
		get = function(info)
			return E.db.KnightFrame.Extra_Function.ToggleQuest
		end,
		set = function(info, value)
			E.db.KnightFrame.Extra_Function.ToggleQuest = value
			KFTQ:Initialize()
		end,
	}
	P["KnightFrame"]["Extra_Function"]["ToggleQuest"] = true
	E:RegisterModule(KFTQ:GetName())
end

-----------------------------------------------------------
-- [ Knight : Toggle Quest Watchframe					]--
-----------------------------------------------------------
if E.db.KnightFrame.Enable ~= false then
	local Except_Boss = {
		--'보스이름', 이런 식으로 적으면 해당 보스가 있는 전투 시 퀘스트프레임이 숨겨지지 않음
	}

	local Toggled = false
	local BattleStart = false
	local function CheckBoss()
		for i = 1, 4 do
			local bossname, _ = UnitName('boss'..i)
			if bossname then
				local bosslevel = UnitLevel('boss'..i)
				local playerlevel = UnitLevel('player')
				for _, checkbossname in pairs(Except_Boss) do
					if bossname == checkbossname then return false end
				end
				if UnitCanAttack('player', 'boss'..i) and ((bosslevel > playerlevel - 4 and bosslevel < playerlevel + 6) or bosslevel == -1 or UnitClassification('boss'..i) == 'worldboss') then return true end
			end
		end
	end
	
	local ShowBackWatchFrame = CreateFrame('Frame')
		ShowBackWatchFrame:Hide()
		ShowBackWatchFrame:SetScript('OnUpdate', function()
			if not WatchFrameLines:IsVisible() and WatchFrameCollapseExpandButton:IsShown() and not InCombatLockdown() and Toggled == true and BattleStart == true then
				WatchFrameCollapseExpandButton:Click()
				ShowBackWatchFrame:Hide()
				Toggled = false
				BattleStart = false
			end
		end)
	
	local function SwitchWatchFrame()
		if CheckBoss() == true and WatchFrameLines:IsVisible() == 1 and WatchFrameCollapseExpandButton:IsShown() and Toggled == false then
			Toggled = true
			WatchFrameCollapseExpandButton:Click()
			ShowBackWatchFrame:Show()
			print(L['KF']..' : '..L['Hide Watchframe because of entering battle of boss.'])
		end
	end
	
	function KFTQ:PLAYER_REGEN_DISABLED()
		if Toggled == true then BattleStart = true end
	end
	
	function KFTQ:Initialize()
		if E.db.KnightFrame.Extra_Function.ToggleQuest ~= false then
			ElvUF_Boss1:HookScript('OnShow', SwitchWatchFrame)
			ElvUF_Boss2:HookScript('OnShow', SwitchWatchFrame)
			ElvUF_Boss3:HookScript('OnShow', SwitchWatchFrame)
			ElvUF_Boss4:HookScript('OnShow', SwitchWatchFrame)
			self:RegisterEvent('PLAYER_REGEN_DISABLED')
		else
			self:Unhook(ElvUF_Boss1'OnShow')
			self:Unhook(ElvUF_Boss2'OnShow')
			self:Unhook(ElvUF_Boss3'OnShow')
			self:Unhook(ElvUF_Boss4'OnShow')
			self:UnregisterEvent('PLAYER_REGEN_DISABLED')
		end
	end
end