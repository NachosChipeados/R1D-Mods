
#base "hud_indicators_thing.res"
//#base "hudflyouts.res"

custom_hud_16.res
{
	GameModeLabel
	{
		auto_wide_tocontents	1
	}

	ScorePopupLabel
	{
		xpos				80 //-24
		ypos				-200 //0
		tall				24 //12
		textAlignment		center //west

		//pin_to_sibling				ScoresFriendly
		//pin_corner_to_sibling		2
		//pin_to_sibling_corner		1

		pin_to_sibling				SafeAreaCenter
		pin_corner_to_sibling		6
		pin_to_sibling_corner		6
	}

	MinimapBG
	{
		tall				172 //166
	}

	TargetHealthBarSmall
	{
		ypos				-96
	}

	TargetHealthBarBurnCardIndicator
	{
		ypos				-106
	}
	TargetHealthBarSubClass
	{
		ypos				-92
	}

	TargetShieldBarSmall
	{
		ypos				-96
	}

	TargetDoomedHealthBarSmall
	{
		ypos				-96
	}

	ObjectiveAnchor
	{
		ypos			-40 //-20
	}

	MinimapSatelliteLabel
	{
		visible				1

		zpos				10

		pin_to_sibling				MinimapCompass
		pin_corner_to_sibling		6
		pin_to_sibling_corner		4
	}

	killStreak_background
	{
		ypos				4
		visible				0
		drawColor			"255 255 255 255"
	}

	killStreak_label
	{
		textAlignment		center
		visible				0
		fgcolor_override	"255 255 255 255"
	}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	MinimapSatelliteLabelCoop
	{
		ControlName			Label
		xpos				0
		ypos				2
		wide				120
		tall				8
		visible				0
		font				HudFontSmall
		labelText			"#COOP_MINIMAP_SATELLITE_VIEW"
		allCaps				1
		textAlignment		center
		fgcolor_override 	"200 230 255 255"

		zpos				10

		pin_to_sibling				MinimapCompassCoop
		pin_corner_to_sibling		6
		pin_to_sibling_corner		4
	}

	Low_Ammo_Status
	{
		ControlName			Label
		xpos				0
		ypos				-135
		wide				100
		tall				20
		visible				0
		font				HudFontSmall
		labelText			""
		textAlignment		center

		zpos				200

		pin_to_sibling				SafeAreaCenter
		pin_corner_to_sibling		6
		pin_to_sibling_corner		6
	}

	RealTimeLabel
	{
		ControlName			Label
		xpos				16
		ypos				38 //24 //44
		wide				110
		tall				12
		visible				0
		font				HudFontMedSmall
		labelText			""
		allcaps				1
		textAlignment		center
		fgcolor_override 	"255 255 255 255"
		//bgcolor_override 	"255 255 255 255"

		zpos				150

		pin_to_sibling				GameInfoBG
		pin_corner_to_sibling		2
		pin_to_sibling_corner		0
	}

	Speedometer_Label
	{
		ControlName			Label
		xpos				80
		ypos				-300 //135
		wide				100
		tall				30
		visible				0
		font				HudFontSmall
		labelText			""
		allcaps				1
		textAlignment		center
		fgcolor_override 	"255 255 255 220"

		zpos				200

		pin_to_sibling				SafeAreaCenter
		pin_corner_to_sibling		6
		pin_to_sibling_corner		6
	}

	GameModeLabel_SwitchSides
	{
		ControlName			Label
		xpos				2
		ypos				0
		wide				200
		tall				12
		visible				1
		font				HudFontSmall
		labelText			""
		textAlignment		west
		textinsetx			0
		allcaps				1
		fgcolor_override 	"255 255 255 180"

		//zpos				150

		pin_to_sibling				GameModeLabel
		pin_corner_to_sibling		7
		pin_to_sibling_corner		5


// enum PinCorner_e 
// {
// 	PIN_TOPLEFT = 0,
// 	PIN_TOPRIGHT, // 1
// 	PIN_BOTTOMLEFT, // 2
// 	PIN_BOTTOMRIGHT, // 3

// 	// For sibling pinning
// 	PIN_CENTER_TOP, // 4
// 	PIN_CENTER_RIGHT, // 5
// 	PIN_CENTER_BOTTOM, // 6
// 	PIN_CENTER_LEFT, // 7
// };

//		up
//		pin_corner_to_sibling		2
//		pin_to_sibling_corner		0

//		left
//		pin_corner_to_sibling		8
//		pin_to_sibling_corner		8
//		pin_corner_to_sibling		6
//		pin_to_sibling_corner		6
//		pin_corner_to_sibling		5
//		pin_to_sibling_corner		7

//		right
//		pin_corner_to_sibling		7
//		pin_to_sibling_corner		5

	}

	"DuckingIcon"
	{
		"ControlName"	"ImagePanel"
		"xpos"			"0" //119
		"ypos"			"5" //29
		"wide"			"25"
		"tall"			"25"
		"zpos"			"102"
		"visible"		"1"
		"enabled"		"1"
		"scaleImage"	"1"
		"image"			"hud/crouch_survivor"
		drawColor			"255 255 255 255"

		pin_to_sibling				dpadSideBG
		pin_corner_to_sibling		3
		pin_to_sibling_corner		1
	}

	Weather_Label
	{
		ControlName			Label
//		xpos				80
//		ypos				-300 //135

		xpos				0
		ypos				20 //135
//		wide				100
		auto_wide_tocontents	1
		tall				30
		visible				1
		font				HudFontSmall
		labelText			"" //zip 30114
		allcaps				0
		textAlignment		center
		fgcolor_override 	"255 255 255 220"

		zpos				200

		pin_to_sibling				VDU_CockpitScreen
		pin_corner_to_sibling		6
		pin_to_sibling_corner		6
	}

	"perkImage0"
	{
		"ControlName"	"ImagePanel"
		"xpos"			"20"
		"ypos"			"100"
		"wide"			"25"
		"tall"			"25"
		"zpos"			"102"
		"visible"		"1"
		"enabled"		"1"
		"scaleImage"	"1"
		"image"			""
		drawColor			"255 255 255 255"

		pin_to_sibling				dpadSideBG
		pin_corner_to_sibling		3
		pin_to_sibling_corner		1
	}

	perkName0
	{
		ControlName			Label
		xpos				5
		ypos				0
		auto_wide_tocontents	1
		//wide				200
		tall				12
		visible				1
		font				HudFontSmall
		labelText			""
		textAlignment		west
		textinsetx			0
		allcaps				1
		fgcolor_override 	"255 255 255 255"

		//zpos				150

		pin_to_sibling				perkImage0
		pin_corner_to_sibling		5
		pin_to_sibling_corner		7
	}

	"perkImage1"
	{
		"ControlName"	"ImagePanel"
		"xpos"			"0" //119
		"ypos"			"30" //29
		"wide"			"25"
		"tall"			"25"
		"zpos"			"102"
		"visible"		"1"
		"enabled"		"1"
		"scaleImage"	"1"
		"image"			""
		drawColor			"255 255 255 255"

		pin_to_sibling				perkImage0
		pin_corner_to_sibling		6
		pin_to_sibling_corner		6
	}

	perkName1
	{
		ControlName			Label
		xpos				5
		ypos				0
		auto_wide_tocontents	1
		//wide				200
		tall				12
		visible				1
		font				HudFontSmall
		labelText			""
		textAlignment		west
		textinsetx			0
		allcaps				1
		fgcolor_override 	"255 255 255 255"

		//zpos				150

		pin_to_sibling				perkImage1
		pin_corner_to_sibling		5
		pin_to_sibling_corner		7
	}

	"perkImage2"
	{
		"ControlName"	"ImagePanel"
		"xpos"			"0" //119
		"ypos"			"30" //29
		"wide"			"25"
		"tall"			"25"
		"zpos"			"102"
		"visible"		"1"
		"enabled"		"1"
		"scaleImage"	"1"
		"image"			""
		drawColor			"255 255 255 255"

		pin_to_sibling				perkImage1
		pin_corner_to_sibling		6
		pin_to_sibling_corner		6
	}

	perkName2
	{
		ControlName			Label
		xpos				5
		ypos				0
		auto_wide_tocontents	1
		//wide				200
		tall				12
		visible				1
		font				HudFontSmall
		labelText			""
		textAlignment		west
		textinsetx			0
		allcaps				1
		fgcolor_override 	"255 255 255 255"

		//zpos				150

		pin_to_sibling				perkImage2
		pin_corner_to_sibling		5
		pin_to_sibling_corner		7
	}

	HealthAmmount
	{
		ControlName			Label
		xpos				0
		ypos				25 //135
		auto_wide_tocontents	1
		tall				30
		visible				0
		font				HudFontSmall
		labelText			""
		allcaps				0
		textAlignment		center
		fgcolor_override 	"255 255 255 220"

		zpos				200

		pin_to_sibling				HealthBar
		pin_corner_to_sibling		6
		pin_to_sibling_corner		6
	}

	ShieldAmmount
	{
		ControlName			Label
		xpos				0
		ypos				25 //135
		auto_wide_tocontents	1
		tall				30
		visible				0
		font				HudFontSmall
		labelText			""
		allcaps				0
		textAlignment		center
		fgcolor_override 	"255 255 255 220"

		zpos				200

		pin_to_sibling				HealthBar
		pin_corner_to_sibling		4
		pin_to_sibling_corner		4
	}

	MinimapDpadIcon
	{
		ControlName			Label
		xpos				55
		ypos				30
		auto_wide_tocontents	1
		tall				30
		visible				1
		font				HudFontMed
		labelText			"%+toggleFullscreenMap%"
		allcaps				0
		textAlignment		center
		fgcolor_override 	"255 255 255 220"

		zpos				200

		pin_to_sibling				Minimap
		pin_corner_to_sibling		8
		pin_to_sibling_corner		8
	}

	PDTHAssaultIcon
	{
		ControlName			ImagePanel
		xpos				0
		ypos				-8
		wide				64
		tall				64
		visible				0
		image				HUD/coop/pdth_assault_icon
		scaleImage			1
		drawColor			"255 255 255 255"

		pin_to_sibling				SafeAreaCenter
		pin_corner_to_sibling		6
		pin_to_sibling_corner		6
	}

	PDTHAssaultLabel
	{
		ControlName			Label
		xpos				0
		ypos				-16
		auto_wide_tocontents	1
		tall				30
		visible				0
		font				HudFontMed
		labelText			"ASSAULT"
		allcaps				1
		textAlignment		center
		fgcolor_override 	"255 0 0 220"

		zpos				200

		pin_to_sibling				SafeAreaCenter
		pin_corner_to_sibling		6
		pin_to_sibling_corner		6
	}

	PairingLabel
	{
		ControlName			Label
		xpos				0
		ypos				35 //135
		auto_wide_tocontents	1
		tall				30
		visible				0
		font				HudFontMed
		labelText			""
		allcaps				0
		textAlignment		center
		fgcolor_override 	"255 255 255 220"

		zpos				200

		pin_to_sibling				HealthBar
		pin_corner_to_sibling		4
		pin_to_sibling_corner		4
	}

//	damageOverlay_1
//	{
//		ControlName			ImagePanel
//		xpos				-200
//		ypos				-100
//		wide				%150
//		tall				%150
//		visible				1
//		image				../effects/health_overlay_1
//		scaleImage			1
//		fillColor			"255 255 0 0"
//	}

//	damageOverlay_2
//	{
//		ControlName			ImagePanel
//		xpos				-200
//		ypos				-100
//		wide				%145
//		tall				%145
//		visible				1
//		image				../effects/health_overlay_1
//		scaleImage			1
//		fillColor			"255 0 0 0"
//	}

//	damageOverlay_3
//	{
//		ControlName			ImagePanel
//		xpos				-200
//		ypos				-100
//		wide				%140
//		tall				%140
//		visible				1
//		image				../effects/health_overlay_1
//		scaleImage			1
//		fillColor			"255 0 0 0"
//	}

/////////////////////////////////////////////////////////////////////////////

//	EnemyName
//	{
//		ControlName			Label
//		xpos				0
//		ypos				-13
//		wide				140
//		tall				50
//		visible				1
//		//autoresize			3
//		font				HudNumbersSmall
//		labelText			"Names Blah"
//		textAlignment		center
//		drawColor			"255 255 255 255"
//
//		zpos				10
//
//		pin_to_sibling				EnemyIcon
//		pin_corner_to_sibling		4
//		pin_to_sibling_corner		6
//	}

	TargetHealthBarName
	{
		ControlName			Label
		xpos				90
		ypos				-102
		wide				140
		tall				25
		visible				1
		//autoresize			3
		font				HudFontSmall
		labelText			"Names Blah"
		textAlignment		center
		drawColor			"255 255 255 255"
		fgcolor_override 	"255 255 255 225"

		zpos				10

		pin_to_sibling				SafeAreaCenter
		pin_corner_to_sibling		4
		pin_to_sibling_corner		4
	}

	TargetHealthBarSmallFriendly
	{
		ControlName			CHudProgressBar
		xpos				-88
		ypos				-96
		wide				94
		tall				12
		visible				0
		bg_image			HUD/shieldbar_bg
		fg_image			HUD/shieldbar_health
		change_image		HUD/shieldbar_health_change
		fgcolor_override	"255 255 255 255"
		bgcolor_override	"255 255 255 255"
		SegmentSize			94
		SegmentGap			0
		Inset				0
		Margin				0
		ProgressDirection	0
		SegmentFill			2
		ChangeStyle			1
		ChangeTime			0.25
		ChangeDir			0
		//ChangeColor			"255 128 64 255"

		zpos 200

		pin_to_sibling				SafeAreaCenter
		pin_corner_to_sibling		4
		pin_to_sibling_corner		4
	}

	TargetHealthBarBurnCardIndicatorFriendly
	{
		ControlName			ImagePanel
		xpos				-120
		ypos				-106
		wide				20
		tall				20
		visible				0
		image				HUD/overhead_shieldbar_burn_card_indicator
		scaleImage			1.0

		zpos 199

		pin_to_sibling				SafeAreaCenter
		pin_corner_to_sibling		4
		pin_to_sibling_corner		4
	}
	TargetHealthBarSubClassFriendly
	{
		ControlName			ImagePanel
		xpos				-145
		ypos				-92
		wide				20
		tall				20
		visible				0
		image				HUD/overhead_shieldbar_burn_card_indicator
		scaleImage			1.0

		zpos 199

		pin_to_sibling				SafeAreaCenter
		pin_corner_to_sibling		4
		pin_to_sibling_corner		4
	}

	TargetShieldBarSmallFriendly
	{
		ControlName			CHudProgressBar
		xpos				-88
		ypos				-96
		wide				94
		tall				12
		visible				0
		fg_image			HUD/target_shieldbar_shield
		change_image		HUD/target_shieldbar_shield_change
		fgcolor_override	"255 255 255 255"
		bgcolor_override	"255 255 255 0"
		SegmentSize			94
		SegmentGap			0
		Inset				0
		Margin				0
		ProgressDirection	0
		SegmentFill			2
		ChangeStyle			1
		ChangeTime			0.25
		ChangeDir			0
		//ChangeColor			"255 128 64 255"

		zpos 201

		pin_to_sibling				SafeAreaCenter
		pin_corner_to_sibling		4
		pin_to_sibling_corner		4
	}

	TargetDoomedHealthBarSmallFriendly
	{
		ControlName			CHudProgressBar
		xpos				-88
		ypos				-96
		wide				94
		tall				10
		visible				0
		bg_image			HUD/titan_doomedbar_bg
		fg_image			HUD/titan_doomedbar_fill
		fgcolor_override	"255 255 255 255"
		bgcolor_override	"255 255 255 160"
		SegmentSize			284
		SegmentGap			0
		Inset				0
		Margin				0
		ProgressDirection	0
		SegmentFill			1

		pin_to_sibling				SafeAreaCenter
		pin_corner_to_sibling		4
		pin_to_sibling_corner		4
	}

	TargetSmall_ConnectingLineFriendly
	{
		ControlName			ImagePanel
		xpos				c
		ypos				c
		wide				16
		tall				16
		visible				0
		image				HUD/flyout_line_fade
		scaleImage			1

		zpos				200
	}
}