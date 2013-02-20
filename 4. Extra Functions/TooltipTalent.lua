--local E, L, V, P, G, _  = unpack(ElvUI)
local E, L, _, _, _, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

if KF.UIParent and KF.db.Extra_Functions.TooltipTalent ~= false then
	-----------------------------------------------------------
	-- [ Knight : Tooltip Talent							]--
	-----------------------------------------------------------
	GameTooltip:HookScript('OnTooltipSetUnit', function(self, ...)
		local _, unit = self:GetUnit()
		if (not unit) then
			local mFocus = GetMouseFocus()
			if (mFocus) and (mFocus.unit) then
				unit = mFocus.unit;
			end
		end
		if (not unit) or (not UnitIsPlayer(unit)) then
			return;
		end
		
		local userClass, talentSpec, talentRule
		if UnitIsUnit(unit, 'player') then
			talentSpec = GetSpecialization()
			if talentSpec then
				talentSpec = select(2, GetSpecializationInfo(talentSpec))
			else
				talentSpec = nil
			end
			userClass = E.myclass
		else
			userClass = select(2, UnitClass(unit))
			unit = UnitGUID(unit)
			for index in pairs(E:GetModule('Tooltip').InspectCache) do
				local inspectCache = E:GetModule('Tooltip').InspectCache[index]
				if inspectCache.GUID == unit then
					talentSpec = inspectCache.TalentSpec or nil
				end
			end
		end
		if talentSpec then
			talentRule = KF.Memory['Table']['ClassRole'][userClass][talentSpec]['Rule']
			GameTooltip:AddDoubleLine(TALENTS..' : ', KF.Memory['Table']['ClassRole'][userClass][talentSpec]['ClassColor']..talentSpec..'|r|cffffffff ('..(talentRule == 'Tank' and '|TInterface\\AddOns\\ElvUI\\media\\textures\\tank.tga:14:14:0:1|t' or talentRule == 'Healer' and '|TInterface\\AddOns\\ElvUI\\media\\textures\\healer.tga:14:14:0:0|t' or '|TInterface\\AddOns\\ElvUI\\media\\textures\\dps.tga:14:14:0:-1|t')..L[talentRule]..')')
		end
	end)
end