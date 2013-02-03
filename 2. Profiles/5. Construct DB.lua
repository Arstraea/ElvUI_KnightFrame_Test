--local E, L, V, P, G, _ = unpack(ElvUI)
local E, L, _, P, _, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

if KF.UIParent then
	-----------------------------------------------------------
	--[ Knight : Change default table by layout setting		]--
	-----------------------------------------------------------
	E:CopyTable(KF.db, KF.LayoutDB)
	KF.LayoutDB = nil
	
	
	-----------------------------------------------------------
	--[ Knight : Copy KnightFrame default table to P table	]--
	-----------------------------------------------------------
	P['KnightFrame'] = {}
	E:CopyTable(P['KnightFrame'], KF.db)
	
	
	-----------------------------------------------------------
	--[ Knight : Load profile value to KF.db				]--
	-----------------------------------------------------------
	E:CopyTable(KF.db, E.db.KnightFrame)
	
	
	-----------------------------------------------------------
	--[ Knight : Save profile FUCK!!!!!!!!!!!!!!!!!!!		]--
	-----------------------------------------------------------
	local function CompareTable(MainTable, TableToCompare)
		local RemainValueTable = {}
		local RemainValue
		for option, value in pairs(MainTable) do
			RemainValue = nil
			if type(value) == 'table' and TableToCompare[option] ~= nil then
				RemainValue = CompareTable(MainTable[option], TableToCompare[option])
			elseif value ~= TableToCompare[option] or TableToCompare[option] == nil then
				RemainValue = value
			end
			if RemainValue ~= nil then
				RemainValueTable[option] = RemainValue
			end
		end
		for k in pairs(RemainValueTable) do
			return RemainValueTable
		end
	end
	KF:RegisterEvent('PLAYER_LOGOUT', function()
		E.db.KnightFrame = CompareTable(KF.db, P['KnightFrame'])
	end)
end