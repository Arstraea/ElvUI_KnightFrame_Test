--local E, L, V, P, G, _  = unpack(ElvUI)
local E = select(1, unpack(ElvUI))
local KF = E:GetModule('KnightFrame')

if KF.UIParent and KF.db.Extra_Functions.ToggleAuraTimer ~= false then
	-----------------------------------------------------------
	-- [ Knight : Toggle Aura remain type					]--
	-----------------------------------------------------------
	E.TimeFormats = {
		[0] = { '%d일', '%dd' },
		[1] = { '%d시간', '%dh' },
		[2] = { '%d분', '%dm' },
		[3] = { '%d초', '%d' },
		[4] = { '%.1f', '%.1f' },
	}
end