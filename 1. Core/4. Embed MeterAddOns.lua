--local E, L, V, P, G, _ = unpack(ElvUI)
local E = select(1, unpack(ElvUI))
local KF = E:GetModule('KnightFrame')
	
if KF.UIParent and KF.db.Extra_Functions.EmbedMeter.Enable ~= false then
	-----------------------------------------------------------
	--[ Knight : Embed Meter 								]--
	-----------------------------------------------------------
	local RecommendMeterAddon = IsAddOnLoaded('Skada') and 'Skada' or (IsAddOnLoaded('Omen') and IsAddOnLoaded('Recount')) and 'Omen&Recount' or IsAddOnLoaded('Recount') and 'Recount' or IsAddOnLoaded('Omen') and 'Omen' or 'NONE'
	local RecommendEmbedingArea = KF:IfMod('ArstraeaMod', 'PanelSetting') and 'Meter' or KF:IfMod('KimsungjaeMod', 'PanelSetting') and 'Double' or 'Right'
	
		--<< Skada >>--
	if IsAddOnLoaded('Skada') and KF.db.Extra_Functions.EmbedMeter.SelectMeterAddon == 'Skada' or (KF.db.Extra_Functions.EmbedMeter.SelectMeterAddon == '0' and RecommendMeterAddon == 'Skada') then
		local widthOffset = 4
		local heightOffset = 60
		local barSpacing = E:Scale(1)
		local borderWidth = E:Scale(2)
		local panelwidth, panelheight, Windows, windowsnum, AreaToEmbeding
		
		local function EmbedWindow(window, parent, mwidth, mheight, point, relativeFrame, relativePoint, ofsx, ofsy)
			local barheight = 14
			window.db.barwidth = mwidth
			window.db.barheight = barheight
			if window.db.enabletitle then
				mheight = mheight - barheight
			end
			window.db.background.height = mheight
			window.db.spark = false
			window.db.barslocked = true

			window.bargroup:SetParent(parent)
			window.bargroup:ClearAllPoints()
			window.bargroup:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
			Skada.displays['bar'].ApplySettings(Skada.displays['bar'], window)
			window:UpdateDisplay()
		end
		
		local function EmbedSkada()
			if not MeterAddonToggleSwitch then
				CreateFrame('Button', 'MeterAddonToggleSwitch', KF.UIParent)
				MeterAddonToggleSwitch:Size(16,18)
				MeterAddonToggleSwitch.tex = MeterAddonToggleSwitch:CreateTexture(nil, 'OVERLAY')
				MeterAddonToggleSwitch.tex:SetTexture([[Interface\AddOns\ElvUI\media\textures\vehicleexit.tga]])
				MeterAddonToggleSwitch.tex:Size(16,18)
				MeterAddonToggleSwitch.tex:Point('CENTER', MeterAddonToggleSwitch)
				MeterAddonToggleSwitch:SetScript('OnMouseDown', function(self) self.tex:Point('CENTER', MeterAddonToggleSwitch, 0, -2) end)
				MeterAddonToggleSwitch:SetScript('OnMouseUp', function(self) self.tex:Point('CENTER', MeterAddonToggleSwitch) end)
				MeterAddonToggleSwitch:SetScript('OnClick', function() Skada:ToggleWindow() end)
			end
			
			windowsnum = Skada:GetWindows()
			Windows = {}
			for _, window in ipairs(Skada:GetWindows()) do
				tinsert(Windows, window)
				if window:IsShown() == nil then window:Show() end
			end
			
			AreaToEmbeding = KF.db.Extra_Functions.EmbedMeter.Location == '0' and RecommendEmbedingArea or KF.db.Extra_Functions.EmbedMeter.Location
			
			if AreaToEmbeding == 'Right' then
				panelwidth = E.db.chat.panelWidth
				panelheight = E.db.chat.panelHeight
				if #windowsnum == 1 then
					EmbedWindow(Windows[1], RightChatPanel, panelwidth - widthOffset - (E.PixelMode and 6 or 10), panelheight - heightOffset + (E.PixelMode and 1 or -1), 'TOPLEFT', RightChatTab, 'BOTTOMLEFT', 2, -(E.PixelMode and 19 or 18))
				elseif #windowsnum > 1 then
					EmbedWindow(Windows[1], RightChatPanel, ((panelwidth - widthOffset) * 2 / 3) - (borderWidth + E.mult + (E.PixelMode and 3 or 5)), panelheight - heightOffset + (E.PixelMode and 1 or -1), 'TOPRIGHT', RightChatTab, 'BOTTOMRIGHT', -2, -(E.PixelMode and 19 or 18))
					EmbedWindow(Windows[2], RightChatPanel, ((panelwidth - widthOffset) / 3) - (borderWidth + E.mult + (E.PixelMode and 3 or 4)), panelheight - heightOffset + (E.PixelMode and 1 or -1), 'TOPLEFT', RightChatTab, 'BOTTOMLEFT', 2, -(E.PixelMode and 19 or 18))
				end
				MeterAddonToggleSwitch:SetParent(RightChatTab)
				MeterAddonToggleSwitch:Point('RIGHT', RightChatTab, -8, 0)
			else
				if #windowsnum > 1 and AreaToEmbeding == 'Double' then
					panelwidth = KF.db.Panel_Options.MeterAddonPanel.Width
					panelheight = KF.db.Panel_Options.MeterAddonPanel.Height
					EmbedWindow(Windows[1], MeterAddonPanel, panelwidth - widthOffset - (E.PixelMode and 6 or 10), panelheight - heightOffset + (E.PixelMode and 1 or -1), 'TOPRIGHT', MeterAddonPanel.Tab, 'BOTTOMRIGHT', -2, -(E.PixelMode and 19 or 18))
					
					panelwidth = KF.db.Panel_Options.MiddleChatPanel.Width
					panelheight = KF.db.Panel_Options.MiddleChatPanel.Height
					EmbedWindow(Windows[2], MiddleChatPanel, panelwidth - widthOffset - (E.PixelMode and 6 or 10), panelheight - heightOffset + (E.PixelMode and 1 or -1), 'TOPLEFT', MiddleChatPanel.Tab, 'BOTTOMLEFT', 2, -(E.PixelMode and 19 or 18))
					
					MeterAddonToggleSwitch:SetParent(MeterAddonPanel.Tab)
					MeterAddonToggleSwitch:Point('LEFT', MeterAddonPanel.Tab, 2, 0)
				elseif AreaToEmbeding == 'Middle' then
					panelwidth = KF.db.Panel_Options.MiddleChatPanel.Width
					panelheight = KF.db.Panel_Options.MiddleChatPanel.Height
					if #windowsnum == 1 then
						EmbedWindow(Windows[1], MiddleChatPanel, panelwidth - widthOffset - (E.PixelMode and 6 or 10), panelheight - heightOffset + (E.PixelMode and 1 or -1), 'TOPLEFT', MiddleChatPanel.Tab, 'BOTTOMLEFT', 2, -(E.PixelMode and 19 or 18))
					elseif #windowsnum > 1 then
						EmbedWindow(Windows[1], MiddleChatPanel, ((panelwidth - widthOffset) * 2/3) - (borderWidth + E.mult + (E.PixelMode and 3 or 5)), panelheight - heightOffset + (E.PixelMode and 1 or -1), 'TOPRIGHT', MiddleChatPanel.Tab, 'BOTTOMRIGHT', -2, -(E.PixelMode and 19 or 18))
						EmbedWindow(Windows[2], MiddleChatPanel, ((panelwidth - widthOffset) / 3) - (borderWidth + E.mult + (E.PixelMode and 3 or 4)), panelheight - heightOffset + (E.PixelMode and 1 or -1), 'TOPLEFT', MiddleChatPanel.Tab, 'BOTTOMLEFT', 2, -(E.PixelMode and 19 or 18))
					end
					MeterAddonToggleSwitch:SetParent(MiddleChatPanel.Tab)
					MeterAddonToggleSwitch:Point('RIGHT', MiddleChatPanel.Tab, -8, 0)
				else
					panelwidth = KF.db.Panel_Options.MeterAddonPanel.Width
					panelheight = KF.db.Panel_Options.MeterAddonPanel.Height
					if #windowsnum == 1 then
						EmbedWindow(Windows[1], MeterAddonPanel, panelwidth - widthOffset - (E.PixelMode and 6 or 10), panelheight - heightOffset + (E.PixelMode and 1 or -1), 'TOPLEFT', MeterAddonPanel.Tab, 'BOTTOMLEFT', 2, -(E.PixelMode and 19 or 18))
					elseif #windowsnum > 1 then
						EmbedWindow(Windows[1], MeterAddonPanel, ((panelwidth - widthOffset) * 2/3) - (borderWidth + E.mult + (E.PixelMode and 3 or 5)), panelheight - heightOffset + (E.PixelMode and 1 or -1), 'TOPRIGHT', MeterAddonPanel.Tab, 'BOTTOMRIGHT', -2, -(E.PixelMode and 19 or 18))
						EmbedWindow(Windows[2], MeterAddonPanel, ((panelwidth - widthOffset) / 3) - (borderWidth + E.mult + (E.PixelMode and 3 or 4)), panelheight - heightOffset + (E.PixelMode and 1 or -1), 'TOPLEFT', MeterAddonPanel.Tab, 'BOTTOMLEFT', 2, -(E.PixelMode and 19 or 18))
					end
					MeterAddonToggleSwitch:SetParent(MeterAddonPanel.Tab)
					MeterAddonToggleSwitch:Point('LEFT', MeterAddonPanel.Tab, 2, 0)
				end
			end
		end
		
		KF.Memory['InitializeFunction'][2]['RunEmbedMeterAddon'] = function()
			EmbedSkada()
		end
		
		Skada.CreateWindow_ = Skada.CreateWindow
		function Skada:CreateWindow(name, db)
			Skada:CreateWindow_(name, db)
			if RightChatPanel then EmbedSkada() end
		end
		
		Skada.DeleteWindow_ = Skada.DeleteWindow
		function Skada:DeleteWindow(name)
			Skada:DeleteWindow_(name)
			if RightChatPanel then EmbedSkada() end
		end
		
		--<< Omen & Recount >>--
	elseif IsAddOnLoaded('Omen') and IsAddOnLoaded('Recount') and KF.db.Extra_Functions.EmbedMeter.SelectMeterAddon == 'Omen&Recount' or (KF.db.Extra_Functions.EmbedMeter.SelectMeterAddon == '0' and RecommendMeterAddon == 'Omen&Recount') then
		KF.Memory['InitializeFunction'][2]['RunEmbedMeterAddon'] = function()
			if not MeterAddonToggleSwitch then
				CreateFrame('Button', 'MeterAddonToggleSwitch', KF.UIParent)
				MeterAddonToggleSwitch:Size(16,18)
				MeterAddonToggleSwitch.tex = MeterAddonToggleSwitch:CreateTexture(nil, 'OVERLAY')
				MeterAddonToggleSwitch.tex:SetTexture([[Interface\AddOns\ElvUI\media\textures\vehicleexit.tga]])
				MeterAddonToggleSwitch.tex:Size(16,18)
				MeterAddonToggleSwitch.tex:Point('CENTER', MeterAddonToggleSwitch)
				MeterAddonToggleSwitch:SetScript('OnMouseDown', function(self) self.tex:Point('CENTER', MeterAddonToggleSwitch, 0, -2) end)
				MeterAddonToggleSwitch:SetScript('OnMouseUp', function(self) self.tex:Point('CENTER', MeterAddonToggleSwitch) end)
				MeterAddonToggleSwitch:SetScript('OnClick', function() if Recount.MainWindow:IsShown() then Recount.MainWindow:Hide() else Recount.MainWindow:Show();Recount:RefreshMainWindow() end Omen:Toggle() end)
			end
			if OmenAnchor:IsShown() == nil then OmenAnchor:Show() end
			if Omen.db.profile.ShowWith.UseShowWith ~= false then Omen.db.profile.ShowWith.UseShowWith = false end
			if Omen.db.profile.Locked ~= true then Omen.db.profile.Locked = true Omen:UpdateGrips() end
			if Recount_MainWindow and Recount_MainWindow:IsShown() == nil then Recount_MainWindow:Show() Recount:RefreshMainWindow() end
			Recount:LockWindows(true)
			
			local panelwidth, AreaToEmbeding = 0, KF.db.Extra_Functions.EmbedMeter.Location == '0' and RecommendEmbedingArea or KF.db.Extra_Functions.EmbedMeter.Location
			
			OmenAnchor:ClearAllPoints()
			Recount_MainWindow:ClearAllPoints()
			if AreaToEmbeding == 'Right' then
				panelwidth = E.db.chat.panelWidth
				OmenAnchor:SetPoint('BOTTOM', RightChatDataPanel, 'TOP', 0, 2)
				OmenAnchor:SetPoint('TOPLEFT', RightChatTab, 'BOTTOMLEFT', 0, -2)
				OmenAnchor:SetPoint('TOPRIGHT', RightChatTab, 'BOTTOMLEFT', panelwidth/3, -2)
				OmenAnchor:SetParent(RightChatPanel)
				
				Recount_MainWindow:SetPoint('BOTTOM', RightChatDataPanel, 'TOP', 0, 2)
				Recount_MainWindow:SetPoint('TOPLEFT', RightChatTab, 'BOTTOMRIGHT', -(panelwidth*2/3) + (E.PixelMode and 8 or 12), 7)
				Recount_MainWindow:SetPoint('TOPRIGHT', RightChatTab, 'BOTTOMRIGHT', 0, 7)
				Recount_MainWindow:SetParent(RightChatPanel)
				Recount:RefreshMainWindow()
				
				MeterAddonToggleSwitch:SetParent(RightChatTab)
				MeterAddonToggleSwitch:Point('RIGHT', RightChatTab, -8, 0)
			else
				if AreaToEmbeding == 'Double' then
					panelwidth = KF.db.Panel_Options.MiddleChatPanel.Width
					OmenAnchor:SetPoint('BOTTOM', MiddleChatPanel.DP, 'TOP', 0, 2)
					OmenAnchor:SetPoint('TOPLEFT', MiddleChatPanel.Tab, 'BOTTOMLEFT', 0, -2)
					OmenAnchor:SetPoint('TOPRIGHT', MiddleChatPanel.Tab, 'BOTTOMRIGHT', 0, -2)
					OmenAnchor:SetParent(MiddleChatPanel)
					
					panelwidth = KF.db.Panel_Options.MeterAddonPanel.Width
					Recount_MainWindow:SetPoint('BOTTOM', MeterAddonPanel.DP, 'TOP', 0, 2)
					Recount_MainWindow:SetPoint('TOPLEFT', MeterAddonPanel.Tab, 'BOTTOMLEFT', 0, 7)
					Recount_MainWindow:SetPoint('TOPRIGHT', MeterAddonPanel.Tab, 'BOTTOMRIGHT', 0, 7)
					Recount_MainWindow:SetParent(MeterAddonPanel)
					Recount_MainWindow:Width(panelwidth-6)
					Recount:RefreshMainWindow()
					
					MeterAddonToggleSwitch:SetParent(MeterAddonPanel.Tab)
					MeterAddonToggleSwitch:Point('LEFT', MeterAddonPanel.Tab, 2, 0)
				elseif AreaToEmbeding == 'Middle' then
					panelwidth = KF.db.Panel_Options.MiddleChatPanel.Width
					OmenAnchor:SetPoint('BOTTOM', MiddleChatPanel.DP, 'TOP', 0, 2)
					OmenAnchor:SetPoint('TOPLEFT', MiddleChatPanel.Tab, 'BOTTOMLEFT', 0, -2)
					OmenAnchor:SetPoint('TOPRIGHT', MiddleChatPanel.Tab, 'BOTTOMLEFT', panelwidth/3, -2)
					OmenAnchor:SetParent(MiddleChatPanel)
					Recount_MainWindow:SetPoint('BOTTOM', MiddleChatPanel.DP, 'TOP', 0, 2)
					Recount_MainWindow:SetPoint('TOPLEFT', MiddleChatPanel.Tab, 'BOTTOMRIGHT', -(panelwidth*2/3) + (E.PixelMode and 8 or 12), 7)
					Recount_MainWindow:SetPoint('TOPRIGHT', MiddleChatPanel.Tab, 'BOTTOMRIGHT', 0, 7)
					Recount_MainWindow:SetParent(MiddleChatPanel)
					Recount:RefreshMainWindow()
					
					MeterAddonToggleSwitch:SetParent(MiddleChatPanel.Tab)
					MeterAddonToggleSwitch:Point('RIGHT', MiddleChatPanel.Tab, -8, 0)
				else
					panelwidth = KF.db.Panel_Options.MeterAddonPanel.Width
					OmenAnchor:SetPoint('BOTTOM', MeterAddonPanel.DP, 'TOP', 0, 2)
					OmenAnchor:SetPoint('TOPLEFT', MeterAddonPanel.Tab, 'BOTTOMLEFT', 0, -2)
					OmenAnchor:SetPoint('TOPRIGHT', MeterAddonPanel.Tab, 'BOTTOMLEFT', panelwidth/3, -2)
					OmenAnchor:SetParent(MeterAddonPanel)
					Recount_MainWindow:SetPoint('BOTTOM', MeterAddonPanel.DP, 'TOP', 0, 2)
					Recount_MainWindow:SetPoint('TOPLEFT', MeterAddonPanel.Tab, 'BOTTOMRIGHT', -(panelwidth*2/3) + (E.PixelMode and 8 or 12), 7)
					Recount_MainWindow:SetPoint('TOPRIGHT', MeterAddonPanel.Tab, 'BOTTOMRIGHT', 0, 7)
					Recount_MainWindow:SetParent(MeterAddonPanel)
					Recount:RefreshMainWindow()
					
					MeterAddonToggleSwitch:SetParent(MeterAddonPanel.Tab)
					MeterAddonToggleSwitch:Point('LEFT', MeterAddonPanel.Tab, 2, 0)
				end
			end
			Recount:RefreshMainWindow()
		end
	
		--<< Omen Only >>--
	elseif IsAddOnLoaded('Omen') and KF.db.Extra_Functions.EmbedMeter.SelectMeterAddon == 'Omen' or (KF.db.Extra_Functions.EmbedMeter.SelectMeterAddon == '0' and RecommendMeterAddon == 'Omen') then
		KF.Memory['InitializeFunction'][2]['RunEmbedMeterAddon'] = function()
			if not MeterAddonToggleSwitch then
				CreateFrame('Button', 'MeterAddonToggleSwitch', KF.UIParent)
				MeterAddonToggleSwitch:Size(16,18)
				MeterAddonToggleSwitch.tex = MeterAddonToggleSwitch:CreateTexture(nil, 'OVERLAY')
				MeterAddonToggleSwitch.tex:SetTexture([[Interface\AddOns\ElvUI\media\textures\vehicleexit.tga]])
				MeterAddonToggleSwitch.tex:Size(16,18)
				MeterAddonToggleSwitch.tex:Point('CENTER', MeterAddonToggleSwitch)
				MeterAddonToggleSwitch:SetScript('OnMouseDown', function(self) self.tex:Point('CENTER', MeterAddonToggleSwitch, 0, -2) end)
				MeterAddonToggleSwitch:SetScript('OnMouseUp', function(self) self.tex:Point('CENTER', MeterAddonToggleSwitch) end)
				MeterAddonToggleSwitch:SetScript('OnClick', function() Omen:Toggle() end)
			end
			if OmenAnchor:IsShown() == nil then OmenAnchor:Show() end
			if Omen.db.profile.ShowWith.UseShowWith ~= false then Omen.db.profile.ShowWith.UseShowWith = false end
			if Omen.db.profile.Locked ~= true then Omen.db.profile.Locked = true Omen:UpdateGrips() end
		
			local AreaToEmbeding = KF.db.Extra_Functions.EmbedMeter.Location == '0' and RecommendEmbedingArea or KF.db.Extra_Functions.EmbedMeter.Location
			
			OmenAnchor:ClearAllPoints()
			if AreaToEmbeding == 'Right' then
				OmenAnchor:SetPoint('BOTTOM', RightChatDataPanel, 'TOP', 0, 2)
				OmenAnchor:SetPoint('TOPLEFT', RightChatTab, 'BOTTOMLEFT', 0, -2)
				OmenAnchor:SetPoint('TOPRIGHT', RightChatTab, 'BOTTOMRIGHT', 0, -2)
				OmenAnchor:SetParent(RightChatPanel)
				MeterAddonToggleSwitch:SetParent(RightChatTab)
				MeterAddonToggleSwitch:Point('RIGHT', RightChatTab, -8, 0)
			elseif AreaToEmbeding == 'Middle' then
				OmenAnchor:SetPoint('BOTTOM', MiddleChatPanel.DP, 'TOP', 0, 2)
				OmenAnchor:SetPoint('TOPLEFT', MiddleChatPanel.Tab, 'BOTTOMLEFT', 0, -2)
				OmenAnchor:SetPoint('TOPRIGHT', MiddleChatPanel.Tab, 'BOTTOMRIGHT', 0, -2)
				OmenAnchor:SetParent(MiddleChatPanel)
				MeterAddonToggleSwitch:SetParent(MiddleChatPanel.Tab)
				MeterAddonToggleSwitch:Point('RIGHT', MiddleChatPanel.Tab, -8, 0)
			else
				OmenAnchor:SetPoint('BOTTOM', MeterAddonPanel.DP, 'TOP', 0, 2)
				OmenAnchor:SetPoint('TOPLEFT', MeterAddonPanel.Tab, 'BOTTOMLEFT', 0, -2)
				OmenAnchor:SetPoint('TOPRIGHT', MeterAddonPanel.Tab, 'BOTTOMRIGHT', 0, -2)
				OmenAnchor:SetParent(MeterAddonPanel)
				MeterAddonToggleSwitch:SetParent(MeterAddonPanel.Tab)
				MeterAddonToggleSwitch:Point('LEFT', MeterAddonPanel.Tab, 2, 0)
			end
		end
		
		--<< Recount Only >>--
	elseif IsAddOnLoaded('Recount') and KF.db.Extra_Functions.EmbedMeter.SelectMeterAddon == 'Recount' or (KF.db.Extra_Functions.EmbedMeter.SelectMeterAddon == '0' and RecommendMeterAddon == 'Recount') then
		KF.Memory['InitializeFunction'][2]['RunEmbedMeterAddon'] = function()
			if not MeterAddonToggleSwitch then
				CreateFrame('Button', 'MeterAddonToggleSwitch', KF.UIParent)
				MeterAddonToggleSwitch:Size(16,18)
				MeterAddonToggleSwitch.tex = MeterAddonToggleSwitch:CreateTexture(nil, 'OVERLAY')
				MeterAddonToggleSwitch.tex:SetTexture([[Interface\AddOns\ElvUI\media\textures\vehicleexit.tga]])
				MeterAddonToggleSwitch.tex:Size(16,18)
				MeterAddonToggleSwitch.tex:Point('CENTER', MeterAddonToggleSwitch)
				MeterAddonToggleSwitch:SetScript('OnMouseDown', function(self) self.tex:Point('CENTER', MeterAddonToggleSwitch, 0, -2) end)
				MeterAddonToggleSwitch:SetScript('OnMouseUp', function(self) self.tex:Point('CENTER', MeterAddonToggleSwitch) end)
				MeterAddonToggleSwitch:SetScript('OnClick', function() if Recount.MainWindow:IsShown() then Recount.MainWindow:Hide() else Recount.MainWindow:Show(); Recount:RefreshMainWindow() end end)
			end
			if Recount_MainWindow and Recount_MainWindow:IsShown() == nil then Recount_MainWindow:Show() Recount:RefreshMainWindow() end
			Recount:LockWindows(true)
			
			local AreaToEmbeding = KF.db.Extra_Functions.EmbedMeter.Location == '0' and RecommendEmbedingArea or KF.db.Extra_Functions.EmbedMeter.Location
			
			Recount_MainWindow:ClearAllPoints()
			if AreaToEmbeding == 'Right' then
				Recount_MainWindow:SetPoint('BOTTOM', RightChatDataPanel, 'TOP', 0, 2)
				Recount_MainWindow:SetPoint('TOPLEFT', RightChatTab, 'BOTTOMLEFT', 0, 7)
				Recount_MainWindow:SetPoint('TOPRIGHT', RightChatTab, 'BOTTOMRIGHT', 0, 7)
				Recount_MainWindow:SetParent(RightChatPanel)
				Recount:RefreshMainWindow()
				MeterAddonToggleSwitch:SetParent(RightChatTab)
				MeterAddonToggleSwitch:Point('RIGHT', RightChatTab, -8, 0)
			elseif AreaToEmbeding == 'Middle' then
				Recount_MainWindow:SetPoint('BOTTOM', MiddleChatPanel.DP, 'TOP', 0, 2)
				Recount_MainWindow:SetPoint('TOPLEFT', MiddleChatPanel.Tab, 'BOTTOMLEFT', 0, 7)
				Recount_MainWindow:SetPoint('TOPRIGHT', MiddleChatPanel.Tab, 'BOTTOMRIGHT', 0, 7)
				Recount_MainWindow:SetParent(MiddleChatPanel)
				Recount:RefreshMainWindow()
				MeterAddonToggleSwitch:SetParent(MiddleChatPanel.Tab)
				MeterAddonToggleSwitch:Point('RIGHT', MiddleChatPanel.Tab, -8, 0)
			else
				Recount_MainWindow:SetPoint('BOTTOM', MeterAddonPanel.DP, 'TOP', 0, 2)
				Recount_MainWindow:SetPoint('TOPLEFT', MeterAddonPanel.Tab, 'BOTTOMLEFT', 0, 7)
				Recount_MainWindow:SetPoint('TOPRIGHT', MeterAddonPanel.Tab, 'BOTTOMRIGHT', 0, 7)
				Recount_MainWindow:SetParent(MeterAddonPanel)
				Recount:RefreshMainWindow()
				MeterAddonToggleSwitch:SetParent(MeterAddonPanel.Tab)
				MeterAddonToggleSwitch:Point('LEFT', MeterAddonPanel.Tab, 2, 0)		
			end
			Recount:RefreshMainWindow()
		end
	end
end