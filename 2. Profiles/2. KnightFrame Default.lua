--local E, L, V, P, G, _ = unpack(ElvUI)
local E, L, _, P, _, _ = unpack(ElvUI)
local KF = E:GetModule('KnightFrame')

if KF.UIParent then
	-----------------------------------------------------------
	--[ Knight : KnightFrame Default Structure				]--
	-----------------------------------------------------------
	KF.db = {
		['Enable'] = true,
		
		
		['Panel_Options'] = {
			['MiddleChatPanel'] = {
				['Enable'] = true,
				['Width'] = 442,
				['Height'] = 180,
				['Location'] = 'BOTTOMLEFTLeftChatPanelBOTTOMRIGHT50',
			},
			['MeterAddonPanel'] = {
				['Enable'] = true,
				['Width'] = 442,
				['Height'] = 180,
				['Location'] = 'BOTTOMRIGHTRightChatPanelBOTTOMLEFT-50',
			},			
			['ActionBarPanel'] = {
				['Enable'] = true,
				['Width'] = 574,
				['Height'] = 180,
				['ActionBarBackground_Width'] = 374,
				['Location'] = 'BOTTOMElvUIParentBOTTOM04'
			},
			
			['CenterMinimap'] = true,
			['TopPanel'] = true,
			
			['ExpRep'] = true,
			['ExpRepLock'] = false,
		},
		
		
		['DatatextSetting'] = {
			['Enable'] = true,
			['TalentDatatext'] = {
				['ChangeSet'] = false,
				['PrimarySet'] = 'NONE',
				['SecondarySet'] = 'NONE',
			},
			['Tank'] = {
				['Datatext1'] = 'Avoidance',
				['Datatext2'] = 'Expertise',
				['Datatext3'] = 'Hit Rating',
			},
			['Melee'] = {
				['Datatext1'] = 'Attack Power',
				['Datatext2'] = 'Crit Chance',
				['Datatext3'] = 'Hit Rating',
			},
			['Caster'] = {
				['Datatext1'] = 'Spell/Heal Power',
				['Datatext2'] = 'Crit Chance',
				['Datatext3'] = 'Hit Rating',
			},
			['Healer'] = {
				['Datatext1'] = 'Spell/Heal Power',
				['Datatext2'] = 'Mastery',
				['Datatext3'] = 'Mana Regen',
			},
		},
		
		
		['UICustomize'] = {	-- 0 means option will follow Installed_UI_Layout profile
			['Map'] = '0',
			['PanelSetting'] = '0',
			['Unitframe'] = '0',
		},
		
		
		['Skins'] = {
			['ACP'] = true,
			['DBM'] = true,
			['Omen'] = true,
			['Recount'] = true,
			['Skada'] = true,
		},
		
		
		['Extra_Functions'] = {
			['EmbedMeter'] = {
				['Enable'] = true,
				['HideWhenBattleEnd'] = false,
				['SelectMeterAddon'] = '0',	-- 0 means recommended addon by KF
				['Location'] = '0',	-- 0 means recommended area by KF
			},
			['Inspect'] = {
				['Enable'] = true,
				['ShowMessage'] = true,
				['DisplayPage'] = 'Model',
				['Location'] = 'BOTTOMLEFTElvUIParentLEFT40-40',
			},
			
			['ItemLevel'] = true,
			['ShowChatTab'] = true,
			['RealValue'] = true,
			['TooltipTalent'] = true,
			['ToggleAuraTimer'] = true,
			['ToggleWatchFrame'] = true,
			
			['BuffTracker'] = true,
			['TargetAuraTracker'] = true,
			['SpellAlert'] = {
				['Enable'] = true,
				[87024] = { -- 소작
					['Type'] = 'HARMFUL',
					['Message'] = '소작!!! 두번죽이지 말아줘요 ;ㅁ;',
				},
				[41425] = { -- 저체온증
					['Type'] = 'HARMFUL',
					['Message'] = '얼방 사용했슴!! 살려주세요.. ㅠㅁㅠ',
				},
				[94794] = { -- 니트로 부작용
					['Type'] = 'HARMFUL',
					['Message'] = '니트로 삑사리났음!! 힐힐힐!! ㅠㅠ 아이고, 나죽네!!',
				},
				[19263] = { -- 공저
					['Message'] = '공격저지 켰어요~',
				},
				[1022] = { --보축
					['Message'] = '보축',
				},
			},
		},
	}
end