--local E, L, V, P, G, _ = unpack(ElvUI)
local E = select(1, unpack(ElvUI))
local KF = E:GetModule('KnightFrame')

if KF.UIParent and KF.db.Extra_Functions.RealValue ~= false then
	-----------------------------------------------------------
	-- [ Knight : RealValue									]--
	-----------------------------------------------------------
	--<< Tooltip HP >>--
	local TT = E:GetModule('Tooltip')
	function TT:GameTooltipStatusBar_OnValueChanged(tt, value)
		if not value then return end
		local min, max = tt:GetMinMaxValues()

		if (value < min) or (value > max) then
			return
		end
		local _, unit = GameTooltip:GetUnit()
	
		if (not unit) then
			local GMF = GetMouseFocus()
			unit = GMF and GMF:GetAttribute('unit')
		end

		if tt.text then
			if unit then
				min, max = UnitHealth(unit), UnitHealthMax(unit)
				tt.text:Show()
				local hp = (min)..' / '..(max)
				if UnitIsDeadOrGhost(unit) then
					tt.text:SetText(DEAD)
				else
					tt.text:SetText(hp)
				end
			else
				tt.text:Hide()
			end
		end
	end
	
	
	--<< UnitFrame HP >>--
	local KFstyles = {
		['CURRENT'] = '%s',
		['CURRENT_MAX'] = '%s - %s',
		['CURRENT_PERCENT'] =  '%s%%|n%s',
		['CURRENT_MAX_PERCENT'] = '%s%%|n%s - %s',
		['PERCENT'] = '%s%%',
		['DEFICIT'] = '-%s'
	}
	
	function E:GetFormattedText(style, min, max) --ElvUI\Core\math.lua
		assert(KFstyles[style], 'Invalid format style: '..style)
		assert(min, 'You need to provide a current value. Usage: E:GetFormattedText(style, min, max)')
		assert(max, 'You need to provide a maximum value. Usage: E:GetFormattedText(style, min, max)')
	
		if max == 0 then max = 1 end
	
		local useStyle = KFstyles[style]
		
		if style == 'DEFICIT' then
			local deficit = max - min
			if deficit <= 0 then
				return ''
			else
				return string.format(useStyle, deficit)
			end
		elseif style == 'PERCENT' then
			if max - min <= 0 then
				return ''
			else
				return string.format(useStyle, format("%.1f", min / max * 100))
			end
		elseif style == 'CURRENT' or ((style == 'CURRENT_MAX' or style == 'CURRENT_MAX_PERCENT' or style == 'CURRENT_PERCENT') and min == max) then
			return string.format(KFstyles['CURRENT'], min)
		elseif style == 'CURRENT_MAX' then
			return string.format(useStyle, min, max)
		elseif style == 'CURRENT_PERCENT' then
			return string.format(useStyle, format("%.1f", min / max * 100), min)
		elseif style == 'CURRENT_MAX_PERCENT' then
			return string.format(useStyle, format("%.1f", min / max * 100), min, max)
		end
	end
end