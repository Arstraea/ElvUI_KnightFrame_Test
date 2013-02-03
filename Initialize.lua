--local E, L, V, P, G, _  = unpack(ElvUI)
local E, L, _, _, _, _  = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

	-----------------------------------------------------------
	-- [ Knight : Load Install								]--
	-----------------------------------------------------------
	local function CheckOptionPack()
		local InstallAddonLoaded, Reason = LoadAddOn("ElvUI_KnightFrame_Option")

		if not InstallAddonLoaded then
			if Reason == "DISABLED" then
				EnableAddOn("ElvUI_KnightFrame_Option")
				LoadAddOn("ElvUI_KnightFrame_Option")
				KF:InstallPage()
			elseif Reason == "MISSING" then
				print(L['KnightFrame Option Pack is not exist.'])
				return
			end
		end
	end
	
	
	-----------------------------------------------------------
	-- [ Knight : Run KF Install instead of ElvUI Install	]--
	-----------------------------------------------------------
	if not E.private.install_complete or (E.private.install_complete and type(E.private.install_complete) == 'boolean') or (E.private.install_complete and type(tonumber(E.private.install_complete)) == 'number' and tonumber(E.private.install_complete) <= 4.22) or (E.db.KnightFrame.Install_Complete == nil or E.db.KnightFrame.Install_Complete == 'NotInstalled') then
		E.Install_ = E.Install
		function E:Install()
			CheckOptionPack()
		end
	end
	
	
	-----------------------------------------------------------
	-- [ Knight : Initialize KnightFrame					]--
	-----------------------------------------------------------
	function KF:Initialize()
		if not E.db.KnightFrame then E.db.KnightFrame = {} end
		if E.db.KnightFrame.Install_Complete == 'NotInstalled' then
			--메시지
		elseif E.db.KnightFrame.Install_Complete == nil or E.db.KnightFrame.Install_Complete ~= KF.Version then
			E.db.KnightFrame.PatchCheck = true
			CheckOptionPack()
		end
		
		if KF.Memory['InitializeFunction'] then
			local point, anchor, secondaryPoint, x, y
			for Sequence, SavedFunctionTable in pairs(KF.Memory['InitializeFunction']) do
				for Target, SavedData in pairs(SavedFunctionTable) do
					if type(SavedData) == 'string' and _G[Target] then	--To Locate Frame by split locate string
						point, anchor, secondaryPoint, x, y = string.split('\031', SavedData)
						_G[Target]:SetPoint(point, anchor, secondaryPoint, x, y)
						E:CreateMover(_G[Target], Target..'Mover', L['FrameTag']..L[Target])
					elseif type(SavedData) == 'function' then
						SavedData()
					end
				end
			end
			KF.Memory['InitializeFunction'] = nil
		end
		
		KF.Initialize = nil
	end