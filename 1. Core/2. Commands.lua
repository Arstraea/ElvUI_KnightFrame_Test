--local E, L, V, P, G, _  = unpack(ElvUI);
local E = select(1, unpack(ElvUI))
local KF = E:GetModule('KnightFrame')

-----------------------------------------------------------
-- [ Knight : add /command								]--
-----------------------------------------------------------
local function Calculater(msg)
	local origHandler = geterrorhandler()
	seterrorhandler(function (msg)
		print('식이 잘못되었습니다.')
	end)
	msg = 'local answer='..msg..';if answer then SendChatMessage(\'식: '..msg..'\',\'SAY\');SendChatMessage(\'답: \'..answer,\'SAY\') end'
	RunScript(msg)
	seterrorhandler(origHandler)
end


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
		elseif v == nil then
			print(((' '):rep(row*2))..' |cff828282'..(row == 0 and '■' or ' - ')..'|r|cffceff00'..k..'|r : nil value')
		else
			print(((' '):rep(row*2))..' |cff828282'..(row == 0 and '■' or ' - ')..'|r|cffceff00'..k..'|r : '..(type(v) == 'boolean' and (v==true and '|cff1784d1TRUE|r' or '|cffff0000FALSE|r') or v))
		end
	end
end


KF:RegisterChatCommand('test', 'Test')
KF:RegisterChatCommand('ㅅㄷㄴㅅ', 'Test')

E:RegisterChatCommand('ㄷㅊ', 'ToggleConfig')
KF:RegisterChatCommand('기', ReloadUI)
KF:RegisterChatCommand('키', E.ActionBars.ActivateBindMode)
KF:RegisterChatCommand('vkxkf', LeaveParty)
KF:RegisterChatCommand('파탈', LeaveParty)
KF:RegisterChatCommand('rPtks', Calculater)
KF:RegisterChatCommand('계산', Calculater)
KF:RegisterChatCommand('kf_install', 'CheckInstallAddon')
KF:RegisterChatCommand('ㅏㄹ_ㅑㅜㄴㅅ미ㅣ', 'CheckInstallAddon')
KF:RegisterChatCommand('나이트프레임설치', 'CheckInstallAddon')