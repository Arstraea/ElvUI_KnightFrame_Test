local E, L, V, P, G, _  = unpack(ElvUI);
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:GetLocale("ElvUI", "koKR")
local KF = E:GetModule('KnightFrame');
local c1,c2,c3 = unpack(E.media.rgbvaluecolor)
local b1,b2,b3 = unpack(E.media.bordercolor)
local KFSA = E:NewModule('KFSpellAlert', 'AceEvent-3.0')

if not (E.db.KnightFrame.Install_Complete == nil or E.db.KnightFrame.Install_Complete == 'NotInstalled') then
	--Spell Alert
	L["Spell Alert"] = "주문 알리미"
	L["Use |cff1874d1KnightFrame|r's custom Debuff Alert system."] = "특정 주문을 획득했을 때 채팅으로 알려주는 옵션을 활성화합니다.|n|n |cffceff00ex)|r |cffff5353소작, 니트로 부작용"
	L["KFSpellAlertEnable"] = "|cff2eb7e4주문 알리미|r 를 |cffceff00사용|r 합니다."
	L["KFSpellAlertDisable"] = "|cff2eb7e4주문 알리미|r 를 |cffff5353사용 해제|r 합니다."
	
	E.Options.args.KnightFrame.args.Extra_Function.args.SpellAlert = {
		name = " |cff2eb7e4"..L["Spell Alert"],
		desc = L["Use |cff1874d1KnightFrame|r's custom Debuff Alert system."],
		type = "toggle",
		order = 13,
		get = function(info)
			return E.db.KnightFrame.Extra_Function.SpellAlert
		end,
		set = function(info, value)
			E.db.KnightFrame.Extra_Function.SpellAlert = value
			KFSA:ToggleSpellAlert()
			if E.db.KnightFrame.Extra_Function.SpellAlert == nil or E.db.KnightFrame.Extra_Function.SpellAlert == true then
				print(L["KF"]..' : '..L["KFSpellAlertEnable"])
			else
				print(L["KF"]..' : '..L["KFSpellAlertDisable"])
			end
		end,
	}
	P["KnightFrame"]["Extra_Function"]["SpellAlert"] = true
	E:RegisterModule(KFSA:GetName())
end

-----------------------------------------------------------
-- [ Knight : 디버프 알리미								]--
-----------------------------------------------------------
KFSA.SpellAlert = {		--경고
	[1] = {
		["ID"] = 87024, -- 소작
		["Type"] = "HARMFUL",
		["check"] = false,
		["message"] = "소작!!! 두번죽이지 말아줘요 ;ㅁ;",
	},
	[2] = {
		["ID"] = 41425, -- 저체온증
		["Type"] = "HARMFUL",
		["check"] = false,
		["message"] = "얼방 사용했슴!! 살려주세요.. ㅠㅁㅠ",
	},
	[3] = {
		["ID"] = 94794, -- 니트로 부작용
		["Type"] = "HARMFUL",
		["check"] = false,
		["message"] = "니트로 삑사리났음!! 힐힐힐!! ㅠㅠ 아이고, 나죽네!!",
	},
	[4] = {
		["ID"] = 19263, -- 공저
		["Type"] = "",
		["check"] = false,
		["message"] = "공격저지 켰어요~",
	},
}

local function CheckFilterForActiveBuff(spell)
	local spellName, texture
	spellName, _, texture = GetSpellInfo(spell["ID"])
	if UnitAura("player", spellName, nil, spell["Type"]) then
		return true, texture, spellName
	end
	return false
end

function KFSA:SpellAlert_Main()
	if (event == "UNIT_AURA" and unit ~= "player") then return end
	
	for tag in pairs(KFSA.SpellAlert) do
		local hasBuff, texture, spellname = CheckFilterForActiveBuff(KFSA.SpellAlert[tag])
		if hasBuff then
			if KFSA.SpellAlert[tag]["check"] == false then
				KFSA.SpellAlert[tag]["check"] = true
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
				PlaySoundFile([[Interface\AddOns\ElvUI_KnightFrame\Media\warning.ogg]])
			end
		end
		if hasBuff == false and KFSA.SpellAlert[tag]["check"] == true then
			KFSA.SpellAlert[tag]["check"] = false
		end
	end
end

function KFSA:ToggleSpellAlert()
	if E.db.KnightFrame.Extra_Function.SpellAlert == nil or E.db.KnightFrame.Extra_Function.SpellAlert == true then
		self:RegisterEvent("UNIT_AURA", 'SpellAlert_Main')
	else
		self:UnregisterAllEvents()
	end
end
KFSA:ToggleSpellAlert()