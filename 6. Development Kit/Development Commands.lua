--local E, L, V, P, G, _  = unpack(ElvUI);

local E, L, _, P, _, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

function PrintTable(TableToCheck, row, InputTableName)
	row = row or 0
	if InputTableName then
		print(((' '):rep(row*2))..'|cff2eb7e4 [ Table|r : '..InputTableName..'|cff2eb7e4 ]')
		InputTableName = InputTableName..'-'
	else
		InputTableName = ''
	end
	for k, v in pairs(TableToCheck) do
		if type(v) == 'table' then
			PrintTable(v, row + 1, InputTableName..k)
		elseif type(v) == 'function' then
			print(((' '):rep(row*2))..' |cff828282'..(row == 0 and '■' or ' - ')..'|r|cffceff00'..k..'|r : FUNCTION')
		elseif type(v) == 'userdata' then
			print(((' '):rep(row*2))..' |cff828282'..(row == 0 and '■' or ' - ')..'|r|cffceff00'..k..'|r : UserData')
		else
			print(((' '):rep(row*2))..' |cff828282'..(row == 0 and '■' or ' - ')..'|r|cffceff00'..k..'|r : '..(type(v) == 'boolean' and (v==true and '|cff1784d1TRUE|r' or '|cffff0000FALSE|r') or v))
		end
	end
end

--[[
	KnightInspectFrame.SpecIcon['RoleIcon'] = CreateFrame('Frame', nil, KnightInspectFrame.SpecIcon)
	KnightInspectFrame.SpecIcon['RoleIcon']:Size(20)
	KnightInspectFrame.SpecIcon['RoleIcon'].t = KnightInspectFrame.SpecIcon['RoleIcon']:CreateTexture(nil, 'OVERLAY')
	KnightInspectFrame.SpecIcon['RoleIcon'].t:SetTexture('Interface\\LFGFRAME\\UI-LFG-ICON-ROLES.BLP')
	KnightInspectFrame.SpecIcon['RoleIcon'].t:SetTexCoord(GetTexCoordsForRole("DAMAGER"))
	KnightInspectFrame.SpecIcon['RoleIcon'].t:SetInside()
	KnightInspectFrame.SpecIcon['RoleIcon']:Point('TOPRIGHT', KnightInspectFrame.SpecIcon, 10, 10)
	]]