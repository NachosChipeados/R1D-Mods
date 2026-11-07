
Resource/UI/custom_hud_16.res
{
	idLogoShadow
	{
		image				HUD/ability_wallrun
	}

	OutOfBoundsWarning_Message
	{
		//xpos					-50
		//ypos					50
		xpos					100
		ypos					35
		labelText				""
	}

	AnnouncementAnchor
	{
		ypos			c-140
	}

	IngameTextChat [$WINDOWS]
	{
		//messageModeAlwaysOn		0
		//Chat.NeutralFontColor
		//Chat.EnemyFontColor
		//Chat.FriendlyFontColor
		//ChatInputLine
		//ChatFont
	}

/////////////////////////////////////////////////////////////////////////////////////////////////////

	NC_WeaponPickupPrompt
	{
		"ControlName"			"Label"
		//"xpos"            		"c-200"
		"ypos"            		"100" //330
		"zpos"					"150"
		"wide"            		"400"
		"tall"            		"100"
		"font"					"HudFontLarge"
		"visible"				"0"
		labelText				""

		textAlignment				center
		auto_wide_tocontents		1
		fgcolor_override 			"235 225 200 255" //220 215 210 255

		pin_to_sibling				Screen
		pin_corner_to_sibling		8
		pin_to_sibling_corner		8
	}
	NC_WeaponPickupPromptMods
	{
		"ControlName"			"Label"
		"ypos"            		"20"
		"wide"            		"400"
		"tall"            		"100"
		"font"					"HudFontLarge"
		"visible"				"0"
		labelText				""

		textAlignment				center
		auto_wide_tocontents		1
		fgcolor_override 			"235 225 200 255" //220 215 210 255

		pin_to_sibling				NC_WeaponPickupPrompt
		pin_corner_to_sibling		8
		pin_to_sibling_corner		8
	}
}