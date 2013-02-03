--local E, L, V, P, G, _  = unpack(ElvUI)
local E = select(1, unpack(ElvUI))
local KF = E:GetModule('KnightFrame')

if KF.UIParent and KF.db.Extra_Functions.ShowChatTab ~= false then
	-----------------------------------------------------------
	-- [ Knight : Redifine ElvUI's Script for Chat Tab		]--
	-----------------------------------------------------------
	local CH = E:GetModule('Chat')
	function CH:SetupChatTabs(frame, hook)
		--Clear
	end
end