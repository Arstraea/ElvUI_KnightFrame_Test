--local E, L, V, P, G, _  = unpack(ElvUI)
local E, L, _, _, _, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

if KF.UIParent and KF.db.Extra_Functions.BuffTracker.Enable ~= false then
	-----------------------------------------------------------
	-- [ Knight : BuffTracker								]--
	-----------------------------------------------------------
	local function CheckFilterForActiveBuff(filter)
		local spellName, texture, class
		for spellID, EnableClass in pairs(filter) do
			spellName, _, texture = GetSpellInfo(spellID)
			if UnitAura('player', spellName) then
				return true, texture, spellName, EnableClass
			end
		end
		return false, texture, nil, nil
	end
	
	local limiter = 0
	local hasBuff, texture
	local spellName = { [1] = nil, [2] = nil, [3] = nil, [4] = nil, [5] = nil, [6] = nil, [7] = nil, [8] = nil, [9] = nil, }
	local userClass = { [1] = nil, [2] = nil, [3] = nil, [4] = nil, [5] = nil, [6] = nil, [7] = nil, [8] = nil, [9] = nil, }
	
	local function BuffTracker_UpdateReminder(event, unit)
		if (event == 'UNIT_AURA' and unit ~= 'player') and (limiter >= GetTime()) then return end
		limiter = GetTime() + 0.3
		
		for i = 1, 9 do
			hasBuff, texture, spellName[i], userClass[i] = CheckFilterForActiveBuff(KF.Memory['Table']['SysnergyBuffs'][i])
			BuffTracker['Spell'..i].t:SetTexture(texture)
			if hasBuff then
				BuffTracker['Spell'..i].t:SetAlpha(1)
				BuffTracker['Spell'..i]:SetBackdropBorderColor(1, 0.86, 0.24)
			else
				BuffTracker['Spell'..i].t:SetAlpha(0.2)
				BuffTracker['Spell'..i]:SetBackdropBorderColor(unpack(E.media.bordercolor))
			end
		end
	end
	
	CreateFrame('Frame', 'BuffTracker', KF.UIParent)
	BuffTracker:Size((KF.db.Extra_Functions.BuffTracker.ButtonSize * 9) + 70, KF.db.Extra_Functions.BuffTracker.ButtonSize)
	KF.Memory['InitializeFunction'][1]['BuffTracker'] = function()
		local point, anchor, secondaryPoint, x, y = string.split('\031', KF.db.Extra_Functions['BuffTracker']['Location'])
		BuffTracker:SetPoint(point, anchor, secondaryPoint, x, y)
		E:CreateMover(BuffTracker, 'BuffTrackerMover', L['FrameTag']..L['BuffTracker'])
	end
	
	for i = 1, 9 do
		BuffTracker['Spell'..i] = CreateFrame('Frame', nil, BuffTracker)
		BuffTracker['Spell'..i]:SetTemplate('Default')
		BuffTracker['Spell'..i]:Size(KF.db.Extra_Functions.BuffTracker.ButtonSize)
		BuffTracker['Spell'..i]:SetFrameLevel(8)
		BuffTracker['Spell'..i].t = BuffTracker['Spell'..i]:CreateTexture(nil, 'OVERLAY')
		BuffTracker['Spell'..i].t:SetTexCoord(unpack(E.TexCoords))
		BuffTracker['Spell'..i].t:SetInside()
		BuffTracker['Spell'..i]:SetScript('OnLeave', function() GameTooltip:Hide() end)
		BuffTracker['Spell'..i]:SetScript('OnEnter', function(self)
			GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT', KF.db.Extra_Functions.BuffTracker.ButtonSize, -4)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(KF:Color('Synergy')..' : |cffffdc3c'..BuffTracker['Spell'..i].Tag..'|r', 1, 1, 1)
			if spellName[i] then
				GameTooltip:AddLine('|n '..KF:Color('-*')..' |cff6dd66d'..L['Applied']..'|r : ', 1, 1, 1)
				GameTooltip:AddDoubleLine(userClass[i], spellName[i], 1, 1, 1, 1, 1, 1)
			else
				GameTooltip:AddLine('|n '..KF:Color('-*')..' |cffb9062f'..L['Non-applied']..'|r|n|n <|cffceff00'..L['EnableClass']..'|r >', 1, 1, 1)
				for ID, EnableClass in pairs(KF.Memory['Table']['SysnergyBuffs'][i]) do
					GameTooltip:AddDoubleLine(EnableClass, select(1, GetSpellInfo(ID)), 1, 1, 1, 1, 1, 1)
				end
			end
			GameTooltip:Show()
		end)
	end

	anchor = KF.db.Extra_Functions.BuffTracker.BackgroundDirection

	BuffTracker['Spell1']:Point('TOPRIGHT', BuffTracker['Spell2'], 'TOPLEFT', -4, 0)
	BuffTracker['Spell1'].Tag = L['AP']
	BuffTracker['Spell2']:Point('TOPRIGHT', BuffTracker['Spell3'], 'TOPLEFT', -4, 0)
	BuffTracker['Spell2'].Tag = STAT_HASTE
	BuffTracker['Spell3']:Point('TOPRIGHT', BuffTracker['Spell4'], 'TOPLEFT', -4, 0)
	BuffTracker['Spell3'].Tag = L['SP']
	BuffTracker['Spell4']:Point('TOPRIGHT', BuffTracker['Spell5'], 'TOPLEFT', -19, 0)
	BuffTracker['Spell4'].Tag = L['SpellHaste']

	BuffTracker['Spell5']:Point((anchor == 'UP' and 'TOP' or 'BOTTOM'), BuffTracker, (anchor == 'UP' and 'BOTTOM' or 'TOP'), 0, (anchor == 'UP' and 1 or -1) * (KF.db.Extra_Functions.BuffTracker.ButtonSize - 4))
	BuffTracker['Spell5'].Tag = select(1, GetSpellInfo(53563))

	BuffTracker['Spell6']:Point('TOPLEFT', BuffTracker['Spell5'], 'TOPRIGHT', 19, 0)
	BuffTracker['Spell6'].Tag = CRIT_ABBR
	BuffTracker['Spell7']:Point('TOPLEFT', BuffTracker['Spell6'], 'TOPRIGHT', 4, 0)
	BuffTracker['Spell7'].Tag = L['Stats']
	BuffTracker['Spell8']:Point('TOPLEFT', BuffTracker['Spell7'], 'TOPRIGHT', 4, 0)
	BuffTracker['Spell8'].Tag = STAT_MASTERY
	BuffTracker['Spell9']:Point('TOPLEFT', BuffTracker['Spell8'], 'TOPRIGHT', 4, 0)
	BuffTracker['Spell9'].Tag = L['Health']

	anchor = KF.db.Extra_Functions.BuffTracker.BackgroundDirection == 'UP' and 1 or -1
	x = CreateFrame('Frame', nil, BuffTracker)
	x:Point('TOPLEFT', BuffTracker['Spell1'], 'TOPLEFT', -4, anchor * 4)
	x:Point('BOTTOMRIGHT', BuffTracker['Spell4'], 'BOTTOMRIGHT', 4, anchor * 4)
	x:SetFrameLevel(7)
	x:SetTemplate('Default', true)

	x = CreateFrame('Frame', nil, BuffTracker)
	x:Point('TOPLEFT', BuffTracker['Spell5'], 'TOPLEFT', -4, anchor * 4)
	x:Point('BOTTOMRIGHT', BuffTracker['Spell5'], 'BOTTOMRIGHT', 4, anchor * 4)
	x:SetFrameLevel(7)
	x:SetTemplate('Default', true)

	x = CreateFrame('Frame', nil, BuffTracker)
	x:Point('TOPLEFT', BuffTracker['Spell6'], 'TOPLEFT', -4, anchor * 4)
	x:Point('BOTTOMRIGHT', BuffTracker['Spell9'], 'BOTTOMRIGHT', 4, anchor * 4)
	x:SetFrameLevel(7)
	x:SetTemplate('Default', true)

	KF:RegisterEventList('ACTIVE_TALENT_GROUP_CHANGED', BuffTracker_UpdateReminder)
	KF:RegisterEventList('CHARACTER_POINTS_CHANGED', BuffTracker_UpdateReminder)
	KF:RegisterEventList('PLAYER_ENTERING_WORLD', BuffTracker_UpdateReminder)
	KF:RegisterEventList('UNIT_AURA', BuffTracker_UpdateReminder)
end