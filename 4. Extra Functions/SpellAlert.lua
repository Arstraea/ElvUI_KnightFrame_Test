--local E, L, V, P, G, _  = unpack(ElvUI)
local E, L, _, _, _, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

if KF.UIParent and KF.db.Extra_Functions.SpellAlert.Enable ~= false then
	-----------------------------------------------------------
	-- [ Knight : 디버프 알리미								]--
	-----------------------------------------------------------
	local AlertList = {}
	
	local function SpellAlert(_, unit)
		if unit ~= 'player' then return end
		
		for SpellID in pairs(KF.db.Extra_Functions.SpellAlert) do
			if type(SpellID) == 'number' then
				if UnitAura('player', GetSpellInfo(SpellID), nil, KF.db.Extra_Functions.SpellAlert[SpellID]['Type']) then
					if not AlertList[SpellID] then
						AlertList[SpellID] = true
						
						--[[
						local inInstance, instanceType = IsInInstance()
						if inInstance and instanceType == 'pvp' or instanceType == 'arena' then 
							SendChatMessage(KFSA.SpellAlert[tag]["message"], "BATTLEGROUND")
							print(L["KF"]..' : '..KFSA.SpellAlert[tag]["message"])
						elseif UnitInRaid('player') then 
							SendChatMessage(KFSA.SpellAlert[tag]["message"], "RAID")
							SendChatMessage(KFSA.SpellAlert[tag]["message"], "YELL")
						elseif UnitInParty('player') then 
							SendChatMessage(KFSA.SpellAlert[tag]["message"], "PARTY")
							SendChatMessage(KFSA.SpellAlert[tag]["message"], "SAY")
						else
							print(L["KF"]..' : '..KFSA.SpellAlert[tag]["message"])
						end
						]]
						
						local inInstance, instanceType = IsInInstance()
						if inInstance and (instanceType == 'pvp' or instanceType == 'arena') then
							--전장, 투기장
						elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and inInstance then
							--무작위 던전 & 무작위레이드
						elseif KF.CurrentGroupMode == 'raid' then
							--걍레이드
						elseif KF.CurrentGroupMode == 'party' then
							--걍파티
						else
							--솔로잉
						end
						
						PlaySoundFile([[Interface\AddOns\ElvUI_KnightFrame_Test\5. Media & Skin\SoundEffects\warning.ogg]])
					end
				elseif AlertList[SpellID] then
					AlertList[SpellID] = nil
				end
			end
		end
	end
	KF:RegisterEventList('UNIT_AURA', SpellAlert, 'SpellAlert')
end