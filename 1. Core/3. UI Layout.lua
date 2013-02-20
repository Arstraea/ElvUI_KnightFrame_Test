local E, L, V, P, G, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

if KF.UIParent then
	-----------------------------------------------------------
	--[ Knight : KnightFrame UI Layout						]--
	-----------------------------------------------------------
	local PANEL_HEIGHT = 22
	local SIDE_BUTTON_WIDTH = 16
	local SPACING = E.PixelMode and 3 or 5
	
	
	--<< MiddleChatPanel >>--
	if KF.db.Panel_Options.MiddleChatPanel.Enable ~= false then
		CreateFrame('Frame', 'MiddleChatPanel', KF.UIParent)
		MiddleChatPanel:SetFrameStrata('BACKGROUND')
		MiddleChatPanel:Size(KF.db.Panel_Options.MiddleChatPanel.Width, KF.db.Panel_Options.MiddleChatPanel.Height)
		MiddleChatPanel:CreateBackdrop('Transparent')
		MiddleChatPanel.backdrop:SetAllPoints()
		KF.Memory['InitializeFunction'][1]['MiddleChatPanel'] = KF.db.Panel_Options['MiddleChatPanel']['Location']
		
		--<< MiddleChatPanel : Tab >>--
		MiddleChatPanel.Tab = CreateFrame('Frame', nil, MiddleChatPanel)
		MiddleChatPanel.Tab:Point('TOPLEFT', MiddleChatPanel, SPACING, -SPACING)
		MiddleChatPanel.Tab:Point('BOTTOMRIGHT', MiddleChatPanel, 'TOPRIGHT', -SPACING, -(SPACING + PANEL_HEIGHT))
		MiddleChatPanel.Tab:SetTemplate('Default', true)
		
		--<< MiddleChatPanel : Data Panel >>--
		MiddleChatPanel.DP = CreateFrame('Frame', nil, MiddleChatPanel)
		MiddleChatPanel.DP:Point('TOPLEFT', MiddleChatPanel, 'BOTTOMLEFT', SPACING, SPACING + PANEL_HEIGHT)
		MiddleChatPanel.DP:Point('BOTTOMRIGHT', MiddleChatPanel, -SPACING, SPACING)
		MiddleChatPanel.DP:SetTemplate('Default', true)
	end
	
	
	--<< MeterAddonPanel >>--
	if KF.db.Panel_Options.MeterAddonPanel.Enable ~= false then
		CreateFrame('Frame', 'MeterAddonPanel', KF.UIParent)
		MeterAddonPanel:SetFrameStrata('BACKGROUND')
		MeterAddonPanel:Size(KF.db.Panel_Options.MeterAddonPanel.Width, KF.db.Panel_Options.MeterAddonPanel.Height)
		MeterAddonPanel:CreateBackdrop('Transparent')
		MeterAddonPanel.backdrop:SetAllPoints()
		KF.Memory['InitializeFunction'][1]['MeterAddonPanel'] = KF.db.Panel_Options['MeterAddonPanel']['Location']
		
		--<< MeterAddonPanel : Tab >>--
		MeterAddonPanel.Tab = CreateFrame('Frame', nil, MeterAddonPanel)
		MeterAddonPanel.Tab:Point('TOPLEFT', MeterAddonPanel, SPACING, -SPACING)
		MeterAddonPanel.Tab:Point('BOTTOMRIGHT', MeterAddonPanel, 'TOPRIGHT', -SPACING, -(SPACING + PANEL_HEIGHT))
		MeterAddonPanel.Tab:SetTemplate('Default', true)
		
		--<< MeterAddonPanel : Data Panel >>--
		MeterAddonPanel.DP = CreateFrame('Frame', nil, MeterAddonPanel)
		MeterAddonPanel.DP:Point('TOPLEFT', MeterAddonPanel, 'BOTTOMLEFT', SPACING, SPACING + PANEL_HEIGHT)
		MeterAddonPanel.DP:Point('BOTTOMRIGHT', MeterAddonPanel, -SPACING, SPACING)
		MeterAddonPanel.DP:SetTemplate('Default', true)
		
		--<< MeterAddonPanel : Talent Panel >>--
		MeterAddonPanel.TP = CreateFrame('Frame', nil, MeterAddonPanel)
		MeterAddonPanel.TP:Point('BOTTOMLEFT', MeterAddonPanel, SPACING, SPACING)
		MeterAddonPanel.TP:Point('TOPRIGHT', MeterAddonPanel.DP, 'TOPLEFT', -(E.PixelMode and 2 or 1), 0)
		MeterAddonPanel.TP:SetTemplate()
		MeterAddonPanel.TP.backdropTexture:SetVertexColor(0.2, 0.2, 0.2)
	end	
	
	
	--<< ActionBarPanel >>--
	if KF.db.Panel_Options.ActionBarPanel.Enable ~= false then
		CreateFrame('Frame', 'ActionBarPanel', KF.UIParent)
		ActionBarPanel:SetFrameStrata('BACKGROUND')
		ActionBarPanel:Size(KF.db.Panel_Options.ActionBarPanel.Width, KF.db.Panel_Options.ActionBarPanel.Height)
		ActionBarPanel:CreateBackdrop('Transparent')
		ActionBarPanel.backdrop:SetAllPoints()
		KF.Memory['InitializeFunction'][1]['ActionBarPanel'] = KF.db.Panel_Options['ActionBarPanel']['Location']
		
		--<< ActionBarPanel : Tab >>--
		ActionBarPanel.Tab = CreateFrame('Frame', nil, ActionBarPanel)
		ActionBarPanel.Tab:Point('TOPLEFT', ActionBarPanel, SPACING, -SPACING)
		ActionBarPanel.Tab:Point('BOTTOMRIGHT', ActionBarPanel, 'TOPRIGHT', -SPACING, -(SPACING + PANEL_HEIGHT))
		ActionBarPanel.Tab:SetTemplate('Default', true)
		
		--<< ActionBarPanel : Data Panel >>--
		ActionBarPanel.DP = CreateFrame('Frame', nil, ActionBarPanel)
		ActionBarPanel.DP:Point('TOPLEFT', ActionBarPanel, 'BOTTOMLEFT', SPACING, SPACING + PANEL_HEIGHT)
		ActionBarPanel.DP:Point('BOTTOMRIGHT', ActionBarPanel, -SPACING, SPACING)
		ActionBarPanel.DP:SetTemplate('Default', true)
		
		--<< ActionBarPanel : ActionBar Background >>--
		ActionBarPanel.ABBG = CreateFrame('Frame', nil, ActionBarPanel)
		ActionBarPanel.ABBG:CreateBackdrop('Default')
		ActionBarPanel.ABBG:Point('TOP', ActionBarPanel.Tab, 'BOTTOM', 0, -(E.PixelMode and 2 or 3))
		ActionBarPanel.ABBG:Point('BOTTOM', ActionBarPanel.DP, 'TOP', 0, (E.PixelMode and 2 or 3))
		ActionBarPanel.ABBG:Width(KF.db.Panel_Options.ActionBarPanel.ActionBarBackground_Width)
	end
	
	
	--<< Panel : Config Button and ExpRep System >>--
	if KF.db.Panel_Options.MiddleChatPanel.Enable ~= false or KF.db.Panel_Options.ActionBarPanel.Enable ~= false then
		--<< Config Button >>--
		CreateFrame('Button', 'Button_CONFIG', KF.UIParent)
		Button_CONFIG:Size(SIDE_BUTTON_WIDTH, PANEL_HEIGHT)
		Button_CONFIG:SetTemplate('Default', true)
		KF:TextSetting(Button_CONFIG, 'C')
		Button_CONFIG:SetScript('OnEnter', function(self) 
			OptionPanelHolder.text:SetText('< '..KF:Color('Elv Options')..' >')
			OptionPanelHolder:Show()
			self.text:SetText(KF:Color('C'))
		end)
		Button_CONFIG:SetScript('OnClick', function() OptionPanelHolder:Hide() E:ToggleConfigMode() Button_CONFIG.text:SetText('C') end)
		
		--<< Create Option Panel >>--
		CreateFrame('Frame', 'OptionPanelHolder', Button_CONFIG)
		OptionPanelHolder:SetFrameStrata('TOOLTIP')
		OptionPanelHolder:SetFrameLevel(7)
		OptionPanelHolder:Size(116,85)
		OptionPanelHolder:Point('BOTTOMRIGHT', Button_CONFIG, 'TOPRIGHT', 0, 2)
		OptionPanelHolder:SetTemplate('Default', true)
		KF:TextSetting(OptionPanelHolder, '', nil, nil, 'TOP', 0, -5)
		OptionPanelHolder:Hide()
		
		--<< Area to hide option panel >>--
		Button_CONFIG.HA_Top = CreateFrame('Frame', nil, OptionPanelHolder)
		Button_CONFIG.HA_Top:SetFrameStrata('TOOLTIP')
		Button_CONFIG.HA_Top:Point('TOPLEFT', KF.UIParent)
		Button_CONFIG.HA_Top:Point('TOPRIGHT', KF.UIParent)
		Button_CONFIG.HA_Top:Point('BOTTOM', OptionPanelHolder, 'TOP', 0,2)
		Button_CONFIG.HA_Top:SetScript('OnEnter', function() OptionPanelHolder:Hide() Button_CONFIG.text:SetText('C') end)
		
		Button_CONFIG.HA_Left = CreateFrame('Frame', nil, OptionPanelHolder)
		Button_CONFIG.HA_Left:SetFrameStrata('TOOLTIP')
		Button_CONFIG.HA_Left:Point('BOTTOMLEFT', KF.UIParent)
		Button_CONFIG.HA_Left:Point('TOPRIGHT', OptionPanelHolder, 'TOPLEFT', -2 ,0)
		Button_CONFIG.HA_Left:SetScript('OnEnter', function() OptionPanelHolder:Hide() Button_CONFIG.text:SetText('C') end)
		
		Button_CONFIG.HA_Right = CreateFrame('Frame', nil, OptionPanelHolder)
		Button_CONFIG.HA_Right:SetFrameStrata('TOOLTIP')
		Button_CONFIG.HA_Right:Point('TOPLEFT', OptionPanelHolder, 'TOPRIGHT', 2, 0)
		Button_CONFIG.HA_Right:Point('BOTTOMRIGHT', KF.UIParent)
		Button_CONFIG.HA_Right:SetScript('OnEnter',function() OptionPanelHolder:Hide() Button_CONFIG.text:SetText('C') end)
		
		--<< Button : Toggle Anchor Mode, Toggle ElvUI Config, Toggle ACP >>--
		Button_CONFIG.Button1 = CreateFrame('Button', nil, OptionPanelHolder)
		Button_CONFIG.Button1:Size(108,18)
		Button_CONFIG.Button1:SetBackdrop({
			bgFile = E['media'].blankTex,
			edgeFile = E['media'].blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		Button_CONFIG.Button1:SetBackdropColor(0.2, 0.2, 0.2, 1)
		Button_CONFIG.Button1:SetBackdropBorderColor(unpack(E['media'].bordercolor))
		Button_CONFIG.Button1:Point('BOTTOM', OptionPanelHolder, 0, 4)
		KF:TextSetting(Button_CONFIG.Button1, 'Anchor Toggle')
		Button_CONFIG.Button1:SetScript('OnEnter', function(self) self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor)) self.text:SetText('|cffceff00Anchor Toggle') end)
		Button_CONFIG.Button1:SetScript('OnLeave',function(self) self:SetBackdropBorderColor(unpack(E.media.bordercolor)) self.text:SetText('Anchor Toggle') self.text:SetPoint('CENTER') end)
		Button_CONFIG.Button1:SetScript('OnMouseDown', function(self) self.text:SetPoint('CENTER', 0, -2) end)
		Button_CONFIG.Button1:SetScript('OnMouseUp', function(self) self.text:SetPoint('CENTER') end)
		Button_CONFIG.Button1:SetScript('OnClick', function() OptionPanelHolder:Hide() E:ToggleConfigMode() Button_CONFIG.text:SetText('C') end)
		
		Button_CONFIG.Button2 = CreateFrame('Button', nil, OptionPanelHolder)
		Button_CONFIG.Button2:Size(108,18)
		Button_CONFIG.Button2:SetBackdrop({
			bgFile = E['media'].blankTex,
			edgeFile = E['media'].blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		Button_CONFIG.Button2:SetBackdropColor(0.2, 0.2, 0.2, 1)
		Button_CONFIG.Button2:SetBackdropBorderColor(unpack(E['media'].bordercolor))
		Button_CONFIG.Button2:Point('BOTTOM', OptionPanelHolder, 0, 25)
		KF:TextSetting(Button_CONFIG.Button2, 'Elv UI Config')
		Button_CONFIG.Button2:SetScript('OnEnter', function(self) self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor)) self.text:SetText('|cffceff00Elv UI Config') end)
		Button_CONFIG.Button2:SetScript('OnLeave',function(self) self:SetBackdropBorderColor(unpack(E.media.bordercolor)) self.text:SetText('Elv UI Config') self.text:SetPoint('CENTER') end)
		Button_CONFIG.Button2:SetScript('OnMouseDown', function(self) self.text:SetPoint('CENTER', 0, -2) end)
		Button_CONFIG.Button2:SetScript('OnMouseUp', function(self) self.text:SetPoint('CENTER') end)
		Button_CONFIG.Button2:SetScript('OnClick', function() OptionPanelHolder:Hide() E:ToggleConfig() Button_CONFIG.text:SetText('C') end)
		
		Button_CONFIG.Button3 = CreateFrame('Button', nil, OptionPanelHolder)
		Button_CONFIG.Button3:Size(108,18)
		Button_CONFIG.Button3:SetBackdrop({
			bgFile = E['media'].blankTex,
			edgeFile = E['media'].blankTex,
			tile = false, tileSize = 0, edgeSize = E.mult,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})
		Button_CONFIG.Button3:SetBackdropColor(0.2, 0.2, 0.2, 1)
		Button_CONFIG.Button3:SetBackdropBorderColor(unpack(E['media'].bordercolor))
		Button_CONFIG.Button3:Point('BOTTOM', OptionPanelHolder, 0, 46)
		KF:TextSetting(Button_CONFIG.Button3, 'ACP')	
		if not IsAddOnLoaded('ACP') then
			Button_CONFIG.Button3.text:SetText('|cff828282ACP')
			Button_CONFIG.Button3:SetScript('OnLeave', function(self) self:SetBackdropBorderColor(unpack(E.media.bordercolor)) GameTooltip:Hide() self.text:SetPoint('CENTER') end)
			
			local TextMessage = KF:Color('ACP')..' is |cffb9062fnot loaded|r.|n'..KF:Color('-*')..' |cff6dd66dCLICK|r : Load Addon.'
			if select(6, GetAddOnInfo('ACP')) ~= "MISSING" then
				Button_CONFIG.Button3:SetScript('OnClick', function() GameTooltip:Hide() EnableAddOn('ACP') if InCombatLockdown() then StaticPopup_Show('CONFIG_RL') else ReloadUI() end end)
			else
				TextMessage = KF:Color('ACP')..' is |cffb9062fnot installed!!!|r :('
			end
			
			Button_CONFIG.Button3:SetScript('OnEnter',function(self)
				self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
				GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 2)
				GameTooltip:SetFrameLevel(8)
				GameTooltip:ClearLines()
				GameTooltip:AddLine(TextMessage, 1, 1, 1)
				GameTooltip:Show()
			end)
		else
			Button_CONFIG.Button3:SetScript('OnEnter', function(self) self:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor)) self.text:SetText('|cffceff00ACP') end)
			Button_CONFIG.Button3:SetScript('OnLeave',function(self) self:SetBackdropBorderColor(unpack(E.media.bordercolor)) self.text:SetText('ACP') self.text:SetPoint('CENTER') end)
			Button_CONFIG.Button3:SetScript('OnMouseDown', function(self) self.text:SetPoint('CENTER', 0, -2) end)
			Button_CONFIG.Button3:SetScript('OnMouseUp', function(self) self.text:SetPoint('CENTER') end)
			Button_CONFIG.Button3:SetScript('OnClick', function() OptionPanelHolder:Hide() if not ACP_AddonList:IsShown() then ACP_AddonList:Show() elseif ACP_AddonList:IsShown() then ACP_AddonList:Hide() end Button_CONFIG.text:SetText('C') end)
		end
	
		--<< Location >>--
		if KF.db.Panel_Options.ActionBarPanel.Enable ~= false then
			Button_CONFIG:Point('BOTTOMLEFT', ActionBarPanel, SPACING, SPACING)
			ActionBarPanel.DP:Point('TOPLEFT', ActionBarPanel, 'BOTTOMLEFT', SIDE_BUTTON_WIDTH + SPACING + (E.PixelMode and 2 or 1), SPACING + PANEL_HEIGHT)
		else
			Button_CONFIG:Point('BOTTOMLEFT', MiddleChatPanel, SPACING, SPACING)
			MiddleChatPanel.DP:Point('TOPLEFT', MiddleChatPanel, 'BOTTOMLEFT', SIDE_BUTTON_WIDTH + SPACING + (E.PixelMode and 2 or 1), SPACING + PANEL_HEIGHT)
		end
		
		
		--<< ExpRep System >>
		if KF.db.Panel_Options.ExpRep ~= false then
			local M = E:GetModule('Misc')
			
			local function ToggleExpRepTooltip(ToggleType)
				if ToggleType == 'SHOW' and ElvUI_ReputationBar:IsShown() then
					RepTooltip:Show()
					ReputationBarMover:ClearAllPoints()
					ReputationBarMover:Point('TOPLEFT', RepTooltip, 'BOTTOMLEFT', 2, PANEL_HEIGHT - 2)
					ReputationBarMover:Point('BOTTOMRIGHT', RepTooltip, -2, 2)
					ElvUI_ReputationBar:SetFrameStrata('HIGH')
					ElvUI_ReputationBar:SetFrameLevel(4)
					ElvUI_ReputationBar:Size(ReputationBarMover:GetWidth(), ReputationBarMover:GetHeight())
				elseif ToggleType == 'HIDE' or not ElvUI_ReputationBar:IsShown() then
					RepTooltip:Hide()
					M:UpdateReputation()
					M:UpdateExpRepAnchors()
				end
				
				if ExpTooltip then
					if ToggleType == 'SHOW' and ElvUI_ExperienceBar:IsShown() then
						ExpTooltip:Show()
						if ElvUI_ReputationBar:IsShown() then
							ExpTooltip:Point('BOTTOM', RepTooltip, 'TOP', 0, -1)
						else
							ExpTooltip:Point('BOTTOM', ExpRepSensor)
						end
						ExperienceBarMover:ClearAllPoints()
						ExperienceBarMover:Point('TOPLEFT', ExpTooltip, 'BOTTOMLEFT', 2, PANEL_HEIGHT - 2)
						ExperienceBarMover:Point('BOTTOMRIGHT', ExpTooltip, -2, 2)
						ElvUI_ExperienceBar:SetFrameStrata('HIGH')
						ElvUI_ExperienceBar:SetFrameLevel(4)
						ElvUI_ExperienceBar:Size(ExperienceBarMover:GetWidth(), ExperienceBarMover:GetHeight())					
					elseif ToggleType == 'HIDE' or not ElvUI_ExprerienceBar:IsShown() then
						ExpTooltip:Hide()
						M:UpdateExperience()
						M:UpdateExpRepAnchors()
					end
				end
			end
			
			local function ExpRepTooltipLock(ToggleType)
				if ToggleType == 'Lock' and RepTooltip:IsShown() then
					RepTooltip:SetBackdropBorderColor(0.1, 0.36, 0.75)
					RepTooltip.Title:SetText('< '..KF:Color('Reputation')..' > |cffceff00LOCKED!!|r')
				elseif ToggleType == 'Unlock' or not ElvUI_ReputationBar:IsShown() then
					RepTooltip:SetBackdropBorderColor(unpack(E.media.bordercolor))
					RepTooltip.Title:SetText('< '..KF:Color('Reputation')..' >')
				end
				
				if ExpTooltip then
					if ToggleType == 'Lock' and ExpTooltip:IsShown() then
						ExpTooltip:SetBackdropBorderColor(0.1, 0.36, 0.75)
						ExpTooltip.Title:SetText('< '..KF:Color('Experience')..' > |cffceff00LOCKED!!|r')
					elseif ToggleType == 'Unlock' or not ElvUI_ExperienceBar:IsShown() then
						ExpTooltip:SetBackdropBorderColor(unpack(E.media.bordercolor))
						ExpTooltip.Title:SetText('< '..KF:Color('Experience')..' >')
					end
				end
			end
			
			--<< Redefine ElvUI's script for Tooltip system >>--
			function M:UpdateExperience(event)
				local bar = self.expBar

				if(UnitLevel('player') == MAX_PLAYER_LEVEL) or IsXPUserDisabled() then
					bar:Hide()
				else
					bar:Show()
				
					local cur, max = self:GetXP('player')
					bar.statusBar:SetMinMaxValues(0, max)
					bar.statusBar:SetValue(cur - 1 >= 0 and cur - 1 or 0)
					bar.statusBar:SetValue(cur)
				
					local rested = GetXPExhaustion()
				
					if rested and rested > 0 then
						bar.rested:SetMinMaxValues(0, max)
						bar.rested:SetValue(math.min(cur + rested, max))
					else
						bar.rested:SetMinMaxValues(0, 1)
						bar.rested:SetValue(0)		
					end
					if not ExpTooltip then self:UpdateExpRepAnchors() return end
					ExpTooltip.text:SetText(KF:Color('-* ').. string.format('%d / %d (%d%%)', cur, max, cur/max * 100))
					ExpTooltip.text2:SetText(string.format('|cffFF8200Needs|r : %d%% '..KF:Color('%d Block'), (max - cur) / max * 100, 20 * (max - cur) / max))
					if rested then ExpTooltip.text3:SetText(string.format('|cff228b22%d%% |r Rest', rested / max * 100)) end
					bar.text:SetText('')
				end
				self:UpdateExpRepAnchors()
			end
			function M:UpdateReputation(event)
				local bar = self.repBar

				local ID = 100
				local name, reaction, min, max, value = GetWatchedFactionInfo()
				local numFactions = GetNumFactions();
				if not name then
					bar:Hide()
					if KF.db.Panel_Options.ExpRepLock == true and RepTooltip:IsShown() then
						ToggleExpRepTooltip('SHOW')
						ExpRepTooltipLock('Lock')
					end
				else
					bar:Show()
					local color = FACTION_BAR_COLORS[reaction]
					bar.statusBar:SetStatusBarColor(color.r, color.g, color.b)	
					bar.statusBar:SetMinMaxValues(min, max)
					bar.statusBar:SetValue(value)
					
					if KF.db.Panel_Options.ExpRepLock == true and not RepTooltip:IsShown() then
						ToggleExpRepTooltip('SHOW')
						ExpRepTooltipLock('Lock')
					end
				end
				if not RepTooltip then self:UpdateExpRepAnchors() return end
				bar.text:SetText('')
				if name then
					RepTooltip.text:SetText(KF:Color('-* ')..name)
					RepTooltip.text2:SetText(KF:Color(' ('..format('%d / %d - %d%%', value - min, max - min, (value - min) / (max - min) * 100)..' )'))
					RepTooltip.text3:SetText(_G['FACTION_STANDING_LABEL'..reaction])
				end
				self:UpdateExpRepAnchors()
			end
			function M:UpdateExpRepDimensions()
				--Clear
			end
			function M:UpdateExpRepAnchors()
				if not ReputationBarMover or not ExperienceBarMover or not ExpRepSensor or (ExpTooltip and ExpTooltip:IsShown()) or (RepTooltip and RepTooltip:IsShown()) then return end
				ElvUI_ExperienceBar:Disable()
				ExperienceBarMover:Disable()
				ExperienceBarMover:ClearAllPoints()
				
				ElvUI_ReputationBar:Disable()
				ReputationBarMover:Disable()
				ReputationBarMover:ClearAllPoints()
				
				ExperienceBarMover.text:SetText("|cff838383Experience Bar|r (|r|cffb9062fLock!!|r)")
				ReputationBarMover.text:SetText("|cff838383Reputation Bar|r (|r|cffb9062fLock!!|r)")
				
				if ElvUI_ExperienceBar:IsShown() and ElvUI_ReputationBar:IsShown() then
					ExperienceBarMover:Point('TOPLEFT', ExpRepSensor, 'BOTTOMLEFT', 2, PANEL_HEIGHT - 2)
					ExperienceBarMover:Point('BOTTOMRIGHT', ExpRepSensor, -2, PANEL_HEIGHT/2 + 0.5)
					ElvUI_ExperienceBar:SetAllPoints(ExperienceBarMover)
					ReputationBarMover:Point('TOPLEFT', ExpRepSensor, 'BOTTOMLEFT', 2, PANEL_HEIGHT/2 - 0.5)
					ReputationBarMover:Point('BOTTOMRIGHT', ExpRepSensor, -2, 2)
					ElvUI_ReputationBar:SetAllPoints(ReputationBarMover)
				elseif ElvUI_ExperienceBar:IsShown() then
					ExperienceBarMover:Point('TOPLEFT', ExpRepSensor, 'BOTTOMLEFT', 2, PANEL_HEIGHT - 2)
					ExperienceBarMover:Point('BOTTOMRIGHT', ExpRepSensor, -2, 2)
					ElvUI_ExperienceBar:SetAllPoints(ExperienceBarMover)
				elseif ElvUI_ReputationBar:IsShown() then
					ReputationBarMover:Point('TOPLEFT', ExpRepSensor, 'BOTTOMLEFT', 2, PANEL_HEIGHT - 2)
					ReputationBarMover:Point('BOTTOMRIGHT', ExpRepSensor, -2, 2)
					ElvUI_ReputationBar:SetAllPoints(ReputationBarMover)
				end
			end
			
			--<< Create sensor frame to display ExpRep Tooltip >>--
			CreateFrame('Button', 'ExpRepSensor', KF.UIParent)
			ExpRepSensor:RegisterForClicks('AnyUp')			
			ExpRepSensor:SetScript('OnEnter', function() ToggleExpRepTooltip('SHOW') end)
			ExpRepSensor:SetScript('OnLeave', function()
				if KF.db.Panel_Options.ExpRepLock == false then
					ToggleExpRepTooltip('HIDE')
				end
			end)
			ExpRepSensor:SetScript('OnClick', function(_, button)
				if button == 'RightButton' then
					if KF.db.Panel_Options.ExpRepLock == true then
						ExpRepTooltipLock('Unlock')
						KF.db.Panel_Options.ExpRepLock = false
						print(L['KF']..' : '..L['Unlock ExpRep Tooltip.'])
					elseif RepTooltip:IsShown() or (ExpTooltip and ExpTooltip:IsShown()) then
						ExpRepTooltipLock('Lock')
						KF.db.Panel_Options.ExpRepLock = true
						print(L['KF']..' : '..L['Lock ExpRep Tooltip.'])
					end
				else
					ToggleCharacter('ReputationFrame')
				end
			end)
			
			--<< Create Reputation Tooltip >>--
			CreateFrame('Frame', 'RepTooltip', KF.UIParent)
			RepTooltip:SetFrameStrata('HIGH')
			RepTooltip:SetFrameLevel(2)
			RepTooltip:Height(60)
			RepTooltip:Point('BOTTOM', ExpRepSensor)
			RepTooltip:Point('LEFT', ExpRepSensor)
			RepTooltip:Point('RIGHT', ExpRepSensor)
			RepTooltip:SetTemplate()
			KF:TextSetting(RepTooltip, '< '..KF:Color('Reputation')..' >', nil, 'LEFT', 'TOPLEFT', RepTooltip, 4, -7)
			RepTooltip.Title = RepTooltip.text
			KF:TextSetting(RepTooltip, '', nil, 'RIGHT', 'TOPRIGHT', RepTooltip, -8, -7)
			RepTooltip.text3 = RepTooltip.text
			KF:TextSetting(RepTooltip, '', nil, 'RIGHT', 'RIGHT', RepTooltip, -8, 0)
			RepTooltip.text2 = RepTooltip.text
			KF:TextSetting(RepTooltip, '', nil, 'LEFT', 'LEFT', RepTooltip, 8, 0)
			RepTooltip:Hide()
			
			--<< Create Experience Tooltip >>--
			if not ((UnitLevel('player') == MAX_PLAYER_LEVEL) or IsXPUserDisabled()) then
				CreateFrame('Frame', 'ExpTooltip', KF.UIParent)
				ExpTooltip:SetFrameStrata('HIGH')
				ExpTooltip:SetFrameLevel(2)
				ExpTooltip:Height(60)
				ExpTooltip:Point('BOTTOM', ExpRepSensor)
				ExpTooltip:Point('LEFT', ExpRepSensor)
				ExpTooltip:Point('RIGHT', ExpRepSensor)
				ExpTooltip:SetTemplate()
				KF:TextSetting(ExpTooltip, '< '..KF:Color('Experience')..' >', nil, 'LEFT', 'TOPLEFT', ExpTooltip, 4, -7)
				ExpTooltip.Title = ExpTooltip.text
				KF:TextSetting(ExpTooltip, '', nil, 'RIGHT', 'TOPRIGHT', ExpTooltip, -8, -7)
				ExpTooltip.text3 = ExpTooltip.text
				KF:TextSetting(ExpTooltip, '', nil, 'RIGHT', 'RIGHT', ExpTooltip, -8, 0)
				ExpTooltip.text2 = ExpTooltip.text
				KF:TextSetting(ExpTooltip, '', nil, 'LEFT', 'LEFT', ExpTooltip, 8, 0)
				ExpTooltip:Hide()
			end
			
			KF.Memory['InitializeFunction'][2]['ExpRepSetting'] = function()
				--<< Location >>--
				if KF.db.Panel_Options.ActionBarPanel.Enable ~= false then
					ExpRepSensor:SetParent(ActionBarPanel.DP)
				else
					ExpRepSensor:SetParent(MiddleChatPanel.DP)
				end
				ExpRepSensor:SetFrameStrata('TOOLTIP')
				ExpRepSensor:SetFrameLevel(7)
				ExpRepSensor:SetAllPoints()
				
				if ExpTooltip then
					M:RegisterEvent('PLAYER_XP_UPDATE', 'UpdateExperience')
					M:RegisterEvent('PLAYER_LEVEL_UP', 'UpdateExperience')
					M:RegisterEvent("DISABLE_XP_GAIN", 'UpdateExperience')
					M:RegisterEvent("ENABLE_XP_GAIN", 'UpdateExperience')
					M:RegisterEvent('UPDATE_EXHAUSTION', 'UpdateExperience')
					M:UpdateExperience()
				end
				M:RegisterEvent('UPDATE_FACTION', 'UpdateReputation')
				M:UpdateReputation()
				M:UpdateExpRepAnchors()
				
				if KF.db.Panel_Options.ExpRepLock ~= false then
					ToggleExpRepTooltip('SHOW')
					ExpRepTooltipLock('Lock')
				end
			end
		end
	end
	
	
	--<< Panel : Micro Menu Button >>--
	if KF.db.Panel_Options.MeterAddonPanel.Enable ~= false or KF.db.Panel_Options.ActionBarPanel.Enable ~= false then
		CreateFrame('Button', 'Button_MICROMENU', KF.UIParent)
		Button_MICROMENU:Size(SIDE_BUTTON_WIDTH, PANEL_HEIGHT)
		Button_MICROMENU:SetTemplate('Default', true)
		KF:TextSetting(Button_MICROMENU, 'M')
		Button_MICROMENU:SetScript('OnEnter', function(self)
			MicroMenuHolder.tag:SetText('< '..KF:Color('Micro Menu')..' >')
			
			GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 2)
			GameTooltip:ClearLines()
			GameTooltip:AddLine('Open '..KF:Color('Micro Menu'), 1, 1, 1)
			GameTooltip:Show()
			
			self.text:SetText(KF:Color('M'))
		end)
		Button_MICROMENU:SetScript('OnLeave', function(self) GameTooltip:Hide() if not MicroMenuHolder:IsShown() then self.text:SetText('M') self.text:SetPoint('CENTER') end end)
		Button_MICROMENU:SetScript('OnMouseDown', function(self) self.text:SetPoint('CENTER', 0, -2) end)
		Button_MICROMENU:SetScript('OnMouseUp', function(self) self.text:SetPoint('CENTER') end)
		Button_MICROMENU:SetScript('OnClick', function() ToggleFrame(MicroMenuHolder) MicroMenuHolder.text:SetText('v |cff6dd66dSelect Menu|r v') if MicroMenuHolder:IsShown() then Button_MICROMENU.text:SetText(KF:Color('M')) else Button_MICROMENU.text:SetText('M') end GameTooltip:Hide() end)
	
		--<< Create MicroMenu Panel >>--
		MicroMenuHolder = CreateFrame('Frame', 'MicroMenuHolder', Button_MICROMENU)
		MicroMenuHolder:SetFrameStrata('TOOLTIP')
		MicroMenuHolder:SetFrameLevel(7)
		MicroMenuHolder:Size(224,72)
		MicroMenuHolder:Point('BOTTOM', Button_MICROMENU, 'TOP', 0, 2)
		MicroMenuHolder:SetTemplate('Default', true)
		KF:TextSetting(MicroMenuHolder, '< '..KF:Color('Micro Menu')..' >', nil, nil, 'TOP', 0, -3)
		MicroMenuHolder.tag = MicroMenuHolder.text
		KF:TextSetting(MicroMenuHolder, 'v |cff6dd66dSelect Menu|r v', nil, nil, 'CENTER', 0, 11)
		MicroMenuHolder:Hide()

		--<< Area to hide micromenu panel >>--
		Button_MICROMENU.HA_Top = CreateFrame('Frame', nil, MicroMenuHolder)
		Button_MICROMENU.HA_Top:SetFrameStrata('TOOLTIP')
		Button_MICROMENU.HA_Top:Point('TOPLEFT', KF.UIParent)
		Button_MICROMENU.HA_Top:Point('TOPRIGHT', KF.UIParent)
		Button_MICROMENU.HA_Top:Point('BOTTOM', MicroMenuHolder, 'TOP', 0, 100)
		Button_MICROMENU.HA_Top:SetScript('OnEnter', function() MicroMenuHolder:Hide() Button_MICROMENU.text:SetText('M') end)
		
		Button_MICROMENU.HA_Left = CreateFrame('Frame', nil, MicroMenuHolder)
		Button_MICROMENU.HA_Left:SetFrameStrata('TOOLTIP')
		Button_MICROMENU.HA_Left:Point('BOTTOMLEFT', KF.UIParent)
		Button_MICROMENU.HA_Left:Point('TOPRIGHT', MicroMenuHolder, 'TOPLEFT', -100, 100)
		Button_MICROMENU.HA_Left:SetScript('OnEnter', function() MicroMenuHolder:Hide() Button_MICROMENU.text:SetText('M') end)
		
		Button_MICROMENU.HA_Right = CreateFrame('Frame', nil, MicroMenuHolder)
		Button_MICROMENU.HA_Right:SetFrameStrata('TOOLTIP')
		Button_MICROMENU.HA_Right:Point('BOTTOMRIGHT', KF.UIParent)
		Button_MICROMENU.HA_Right:Point('TOPLEFT', MicroMenuHolder, 'TOPRIGHT', 100, 100)
		Button_MICROMENU.HA_Right:SetScript('OnEnter', function() MicroMenuHolder:Hide() Button_MICROMENU.text:SetText('M') end)

		--<< Create micromenu button >>--
		local function CreateButton(self, xOffset, yOffset, sText, sScript)
			self = CreateFrame('Button', nil, MicroMenuHolder)
			self:Size(28,14)
			self:SetTemplate()
			self:SetScript('OnShow', function() self.backdropTexture:SetVertexColor(0.21,0.21,0.21) self:SetBackdropBorderColor(unpack(E.media.bordercolor)) end)
			self:Point('CENTER', MicroMenuHolder, xOffset, yOffset)
			self:SetScript('OnEnter', function() MicroMenuHolder.text:SetText(sText) c1,c2,c3 = unpack(E.media.rgbvaluecolor) self.backdropTexture:SetVertexColor(c1,c2,c3) self:SetBackdropBorderColor(c1,c2,c3) end)
			self:SetScript('OnLeave', function() MicroMenuHolder.text:SetText('') self.backdropTexture:SetVertexColor(0.21,0.21,0.21) self:SetBackdropBorderColor(unpack(E.media.bordercolor)) self:SetPoint('CENTER', xOffset, yOffset) end)
			self:SetScript('OnMouseDown', function() self:SetPoint('CENTER', xOffset, yOffset - 2) end)
			self:SetScript('OnMouseUp', function() self:SetPoint('CENTER', xOffset, yOffset) end)
			self:SetScript('OnClick', sScript)
		end

		CreateButton(Button1, -93, -6, '|cff1784d1'..CHARACTER_BUTTON, function() ToggleFrame(MicroMenuHolder) ToggleCharacter('PaperDollFrame') Button_MICROMENU.text:SetText('M') end)
		CreateButton(Button2, -62, -6, '|cff228b22'..SPELLBOOK_ABILITIES_BUTTON, function() ToggleFrame(MicroMenuHolder) if not SpellBookFrame:IsShown() then ShowUIPanel(SpellBookFrame) else HideUIPanel(SpellBookFrame) end Button_MICROMENU.text:SetText('M') end)
		CreateButton(Button3, -31, -6, '|cff1784d1'..TALENTS_BUTTON, function() ToggleFrame(MicroMenuHolder) if not PlayerTalentFrame then LoadAddOn('Blizzard_TalentUI') end if not GlyphFrame then LoadAddOn('Blizzard_GlyphUI') end PlayerTalentFrame_Toggle() Button_MICROMENU.text:SetText('M') end)
		CreateButton(Button4, 0, -6, '|cff228b22'..QUESTLOG_BUTTON, function() ToggleFrame(MicroMenuHolder) ToggleFrame(QuestLogFrame) Button_MICROMENU.text:SetText('M') end)
		CreateButton(Button5, 31, -6, '|cff228b22'..MOUNTS_AND_PETS, function() ToggleFrame(MicroMenuHolder) TogglePetJournal() Button_MICROMENU.text:SetText('M') end)
		CreateButton(Button6, 62, -6, '|cff1784d1'..ACHIEVEMENT_BUTTON, function() ToggleFrame(MicroMenuHolder) ToggleAchievementFrame() Button_MICROMENU.text:SetText('M') end)
		CreateButton(Button7, 93, -6, '|cff228b22'..SOCIAL_BUTTON, function() ToggleFrame(MicroMenuHolder) ToggleFriendsFrame(1) Button_MICROMENU.text:SetText('M') end)
		CreateButton(Button8, -93, -24, '|cff1784d1'..ACHIEVEMENTS_GUILD_TAB, function() ToggleFrame(MicroMenuHolder) if IsInGuild() then if not GuildFrame then LoadAddOn('Blizzard_GuildUI') end GuildFrame_Toggle() else if not LookingForGuildFrame then LoadAddOn('Blizzard_LookingForGuildUI') end if not LookingForGuildFrame then return end LookingForGuildFrame_Toggle() end Button_MICROMENU.text:SetText('M') end)
		CreateButton(Button9, -62, -24, '|cff228b22'..string.gsub(string.gsub(SLASH_CALENDAR1, '/', ''), '^%l', string.upper), function() ToggleFrame(MicroMenuHolder) if(not CalendarFrame) then LoadAddOn('Blizzard_Calendar') end Calendar_Toggle() Button_MICROMENU.text:SetText('M') end)
		CreateButton(Button10, -31, -24, '|cff1784d1'..LFG_TITLE, function() ToggleFrame(MicroMenuHolder) PVEFrame_ToggleFrame() Button_MICROMENU.text:SetText('M') end)
		CreateButton(Button11, 0, -24, '|cff1784d1'..ENCOUNTER_JOURNAL, function() ToggleFrame(MicroMenuHolder) if not IsAddOnLoaded('Blizzard_EncounterJournal') then LoadAddOn('Blizzard_EncounterJournal') end ToggleFrame(EncounterJournal) Button_MICROMENU.text:SetText('M') end)
		CreateButton(Button12, 31, -24, '|cff228b22'..PLAYER_V_PLAYER, function() ToggleFrame(MicroMenuHolder) ToggleFrame(PVPFrame) Button_MICROMENU.text:SetText('M') end)
		CreateButton(Button13, 62, -24, '|cff1784d1'..L['GAME MENU'], function() ToggleFrame(MicroMenuHolder) ToggleFrame(GameMenuFrame) Button_MICROMENU.text:SetText('M') end)
		CreateButton(Button14, 93, -24, '|cff228b22'..HELP_BUTTON, function() ToggleFrame(MicroMenuHolder) ToggleHelpFrame() Button_MICROMENU.text:SetText('M') end)
		
		--<< Location >>--
		if KF.db.Panel_Options.ActionBarPanel.Enable ~= false then
			Button_MICROMENU:Point('BOTTOMRIGHT', ActionBarPanel, -SPACING, SPACING)
			ActionBarPanel.DP:Point('BOTTOMRIGHT', ActionBarPanel, -(SIDE_BUTTON_WIDTH + SPACING + (E.PixelMode and 2 or 1)), SPACING)
		else
			Button_MICROMENU:Point('BOTTOMRIGHT', MeterAddonPanel, -SPACING, SPACING)
			MeterAddonPanel.DP:Point('BOTTOMRIGHT', MeterAddonPanel, -(SIDE_BUTTON_WIDTH + SPACING + (E.PixelMode and 2 or 1)), SPACING)
		end
	end
	
	
	--<< TopPanel >>--
	if KF.db.Panel_Options.TopPanel ~= false then
		CreateFrame('Frame', 'TopPanel', KF.UIParent)
		TopPanel:Point('TOPLEFT', KF.UIParent, 6, 2)
		TopPanel:Point('BOTTOMRIGHT', KF.UIParent, 'TOPRIGHT', -6, -14)
		TopPanel:SetFrameStrata('BACKGROUND')
		TopPanel:CreateBackdrop('Transparent')
		
		TopPanel.CenterHolder = CreateFrame('Frame', nil, TopPanel)
		TopPanel.CenterHolder:SetTemplate('Default', true)
		TopPanel.CenterHolder:Size(308, 20)
		TopPanel.CenterHolder:Point('CENTER', TopPanel, 0, -10)
		
		TopPanel.LocationName = CreateFrame('Frame', nil, TopPanel.CenterHolder)
		TopPanel.LocationName:SetTemplate('Default', true)
		TopPanel.LocationName:Size(200, 20)
		TopPanel.LocationName:Point('BOTTOM', TopPanel.CenterHolder, 0, -4)
		TopPanel.LocationName:SetFrameLevel(9)
		KF:TextSetting(TopPanel.LocationName)
		
		TopPanel.LocationX = CreateFrame('Frame', nil, TopPanel.CenterHolder)
		TopPanel.LocationX:SetTemplate('Default', true)
		TopPanel.LocationX:Size(46, 20)
		TopPanel.LocationX:Point('RIGHT', TopPanel.LocationName, 'LEFT', -4, 0)
		TopPanel.LocationX:SetFrameLevel(9)
		KF:TextSetting(TopPanel.LocationX)
		
		TopPanel.LocationY = CreateFrame('Frame', nil, TopPanel.CenterHolder)
		TopPanel.LocationY:SetTemplate('Default', true)
		TopPanel.LocationY:Size(46, 20)
		TopPanel.LocationY:Point('LEFT', TopPanel.LocationName, 'RIGHT', 4, 0)
		TopPanel.LocationY:SetFrameLevel(9)
		KF:TextSetting(TopPanel.LocationY)
		
		local x, y
		KF.UpdateFrame.UpdateList.UpdateLocation = {
			['Condition'] = function() return (TopPanel.LocationName.text:GetText() == nil or select(1, GetUnitSpeed('player')) > 0) and true or false end,
			['Delay'] = 0.5,
			['Action'] = function()
				x, y = GetPlayerMapPosition('player')
				x = math.floor(100 * x)
				y = math.floor(100 * y)
				TopPanel.LocationName.text:SetText(strsub(GetMinimapZoneText(), 1))
				TopPanel.LocationName.text:SetTextColor(E:GetModule('Minimap'):GetLocTextColor())
				
				TopPanel.LocationX.text:SetText(x == 0 and '...' or KF:Color(x))
				TopPanel.LocationY.text:SetText(y == 0 and '...' or KF:Color(y))
			end,
		}
		KF:RegisterEventList('PLAYER_ENTERING_WORLD', function()
			if not (KF.db.Extra_Functions.TargetAuraTracker ~= false and UnitExists('target'))then
				KF.UpdateFrame.UpdateList.UpdateLocation.Action()
			end
		end)
		
		KF:RegisterEventList('WORLD_MAP_UPDATE', function()
			if not (KF.db.Extra_Functions.TargetAuraTracker ~= false and UnitExists('target'))then
				KF.UpdateFrame.UpdateList.UpdateLocation.Action()
			end
		end)
		
		--	TP.LeftHolder = CreateFrame('Frame', nil, TP)
		--	TP.LeftHolder:SetTemplate('Default', true)
		--	TP.LeftHolder:Size(357, 20)
		--	TP.LeftHolder:Point('LEFT', TP, 4, -10)
	end
	
	
	--<< DataText Setting >>--
	if KF.db.DatatextSetting.Enable ~= false then
		if KF.db.Panel_Options.MiddleChatPanel.Enable ~= false or KF.db.Panel_Options.MeterAddonPanel.Enable ~= false then
			CreateFrame('Frame', 'KF_TalentDatatext', KF.UIParent)
			KF:TextSetting(KF_TalentDatatext, '...')
			KF_TalentDatatext.xOff = 0
			KF_TalentDatatext.yOff = 2
			KF_TalentDatatext.anchor = 'ANCHOR_TOP'
			KF_TalentDatatext:SetFrameStrata('BACKGROUND')
			KF_TalentDatatext:Size(50, 20)
			KF_TalentDatatext:SetFrameLevel(11)
			KF_TalentDatatext.DataText = CreateFrame('Button', nil, KF_TalentDatatext)
			KF:TextSetting(KF_TalentDatatext.DataText)
			KF_TalentDatatext.DataText:Size(50, 20)
			KF_TalentDatatext.DataText:Point('CENTER', KF_TalentDatatext, 5, 1)
			E:GetModule('DataTexts'):AssignPanelToDataText(KF_TalentDatatext.DataText, E:GetModule('DataTexts').RegisteredDataTexts['Spec Switch'])
			
			CreateFrame('Frame', 'KF_Datatext1', KF.UIParent)
			KF_Datatext1.xOff = 0
			KF_Datatext1.yOff = 2
			KF_Datatext1.anchor = 'ANCHOR_TOP'
			KF_Datatext1:SetFrameStrata('BACKGROUND')
			KF_Datatext1:Size(110, 20)
			KF_Datatext1:SetFrameLevel(10)		
			KF_Datatext1.DataText = CreateFrame('Button', nil, KF_Datatext1)
			KF:TextSetting(KF_Datatext1.DataText)
			KF_Datatext1.DataText:Size(50, 20)
			KF_Datatext1.DataText:Point('CENTER', KF_Datatext1)
		end
		
		if KF.db.Panel_Options.MeterAddonPanel.Enable ~= false then
			CreateFrame('Frame', 'KF_Datatext2', KF.UIParent)
			KF_Datatext2.xOff = 0
			KF_Datatext2.yOff = 2
			KF_Datatext2.anchor = 'ANCHOR_TOP'
			KF_Datatext2:SetFrameStrata('BACKGROUND')
			KF_Datatext2:Size(110, 20)
			KF_Datatext2:SetFrameLevel(10)
			KF_Datatext2.DataText = CreateFrame('Button', nil, KF_Datatext2)
			KF:TextSetting(KF_Datatext2.DataText)
			KF_Datatext2.DataText:Size(50, 20)
			KF_Datatext2.DataText:Point('CENTER', KF_Datatext2)
			
			CreateFrame('Frame', 'KF_Datatext3', KF.UIParent)
			KF_Datatext3.xOff = 0
			KF_Datatext3.yOff = 2
			KF_Datatext3.anchor = 'ANCHOR_TOP'
			KF_Datatext3:SetFrameStrata('BACKGROUND')
			KF_Datatext3:Size(110, 20)
			KF_Datatext3:SetFrameLevel(10)
			KF_Datatext3.DataText = CreateFrame('Button', nil, KF_Datatext3)
			KF:TextSetting(KF_Datatext3.DataText)
			KF_Datatext3.DataText:Size(50, 20)
			KF_Datatext3.DataText:Point('CENTER', KF_Datatext3)
		end
		
		if KF:IfMod('ArstraeaMod', 'PanelSetting') then
			if KF.db.Panel_Options.MeterAddonPanel.Enable ~= false then
				MeterAddonPanel.DP:Point('TOPLEFT', MeterAddonPanel, 'BOTTOMLEFT', SPACING + 70, SPACING + PANEL_HEIGHT)
				KF_TalentDatatext:Point('CENTER', MeterAddonPanel.TP)
				KF_Datatext1:Point('LEFT', MeterAddonPanel.DP, 13, 0)
				KF_Datatext2:Point('CENTER', MeterAddonPanel.DP, 3, 0)
				KF_Datatext3:Point('RIGHT', MeterAddonPanel.DP, -10, 0)
			end
		elseif KF:IfMod('KimsungjaeMod', 'PanelSetting') then
			if KF.db.Panel_Options.MiddleChatPanel.Enable ~= false then
				KF_TalentDatatext:Point('LEFT', MiddleChatPanel.DP, 22, 0)
				KF_Datatext1:Point('RIGHT', MiddleChatPanel.DP, -7, 0)
			end
			if KF.db.Panel_Options.MeterAddonPanel.Enable ~= false then
				MeterAddonPanel.TP:Hide()
				KF_Datatext2:Point('LEFT', MeterAddonPanel.DP)
				KF_Datatext3:Point('RIGHT', MeterAddonPanel.DP, 5, 0)
			end		
		end
	end
	
	
	--<< Center Minimap Option >>--
	if E.private.general.minimap.enable ~= false then
		-- Create Farm-Mode icon to minimap
		KF.Memory['InitializeFunction'][1]['CreateMinimapFarmmodeButton'] = function()
			LeftMiniPanel:Point('BOTTOMRIGHT', Minimap, 'BOTTOM', -E.Spacing * 2 - 10, -((E.PixelMode and 0 or 3) + PANEL_HEIGHT))
			RightMiniPanel:Point('BOTTOMLEFT', Minimap, 'BOTTOM', E.Spacing * 2 + 10, -((E.PixelMode and 0 or 3) + PANEL_HEIGHT))
			
			CreateFrame('Frame', 'MiddleMiniPanel', Minimap)
			MiddleMiniPanel:Point('TOPLEFT', LeftMiniPanel, 'TOPRIGHT')
			MiddleMiniPanel:Point('BOTTOMRIGHT', RightMiniPanel, 'BOTTOMLEFT')
			MiddleMiniPanel:SetTemplate('Default', true)
			MiddleMiniPanel.tex = MiddleMiniPanel:CreateTexture(nil, 'OVERLAY')
			MiddleMiniPanel.tex:SetTexture([[INTERFACE\ICONS\inv_misc_shovel_01]])
			MiddleMiniPanel.tex:Point('CENTER', MiddleMiniPanel)
			MiddleMiniPanel.tex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			MiddleMiniPanel.tex:Size(16)
			MiddleMiniPanel:SetScript('OnEnter', function(self)
				GameTooltip:SetOwner(self,'ANCHOR_TOP', 0, 2)
				GameTooltip:ClearLines()
				GameTooltip:AddLine('Run ElvUI '..KF:Color('Farmmode')..'.' , 1, 1, 1)
				GameTooltip:Show()
			end)
			MiddleMiniPanel:SetScript('OnLeave', function() GameTooltip:Hide() end)
			MiddleMiniPanel:SetScript('OnMouseDown', function() E:FarmMode() end)
			
			if KF.db.Panel_Options.CenterMinimap ~= false then
				CreateFrame('Button', 'MinimapBG', KF.UIParent)
				MinimapBG:CreateBackdrop('Transparent')
				MinimapBG:Point('TOPLEFT', Minimap)
				MinimapBG:Point('BOTTOMRIGHT', Minimap)
				MinimapBG:SetFrameStrata('BACKGROUND')
				MinimapBG:SetScript('OnClick', function() E:FarmMode() end)
				KF:TextSetting(MinimapBG, KF:Color('Farm Mode'), 20, nil, 'CENTER', 0, 10)
				KF:TextSetting(MinimapBG, 'Activated', 20, nil, 'CENTER', 0, -10)
				
				LeftMiniPanel:SetParent(MinimapBG)
				RightMiniPanel:SetParent(MinimapBG)
				MiddleMiniPanel:SetParent(MinimapBG)
			end
		end
		if KF.db.Panel_Options.CenterMinimap ~= false then
			FarmModeMap:SetScript('OnShow', function()
				if KF.db.Panel_Options.CenterMinimap == false and not E:HasMoverBeenMoved('AurasMover') then
					AurasMover:ClearAllPoints()
					AurasMover:Point("TOPRIGHT", E.UIParent, -3, -34)
				end
				MinimapCluster:ClearAllPoints()
				MinimapCluster:SetAllPoints(FarmModeMap)
				if IsAddOnLoaded('Routes') then
					LibStub("AceAddon-3.0"):GetAddon('Routes'):ReparentMinimap(FarmModeMap)
				end

				if IsAddOnLoaded('GatherMate2') then
					LibStub('AceAddon-3.0'):GetAddon('GatherMate2'):GetModule('Display'):ReparentMinimapPins(FarmModeMap)
				end		
			end)
			
			FarmModeMap:SetScript('OnHide', function() 
				if KF.db.Panel_Options.CenterMinimap == false and not E:HasMoverBeenMoved('AurasMover') then E:ResetMovers('Auras Frame') end		
				MinimapCluster:ClearAllPoints()
				MinimapCluster:SetAllPoints(Minimap)	
				if IsAddOnLoaded('Routes') then
					LibStub("AceAddon-3.0"):GetAddon('Routes'):ReparentMinimap(Minimap)
				end

				if IsAddOnLoaded('GatherMate2') then
					LibStub('AceAddon-3.0'):GetAddon('GatherMate2'):GetModule('Display'):ReparentMinimapPins(Minimap)
				end	
			end)
		end
	end
end