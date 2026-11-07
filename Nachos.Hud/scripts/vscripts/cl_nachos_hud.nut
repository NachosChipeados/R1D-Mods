
const FRAC_STATE_NORMAL = 0
const FRAC_STATE_MID = 1
const FRAC_STATE_LOW = 2

SHIELD_BOOST_HUD_COLOR <- [ SHIELD_BOOST_R, SHIELD_BOOST_G, SHIELD_BOOST_B, 255 ]

function main()
{
	AddCallback_OnClientScriptInit( NachosHud_ScriptInit )
	AddCallback_LocalViewPlayerSpawned( NachosHud_PlayerSpawned )
	AddCreatePilotCockpitCallback( NachosHud_CreateCockpit )
	AddCreateTitanCockpitCallback( NachosHud_CreateCockpit )

	RegisterServerVarChangeCallback( "gameState", NachosHud_GameStateChanged )
	AddLocalPlayerDidDamageCallback( NachosHud_PlayerDidDamage )
	AddOnDeathCallback( "player", NachosHud_PlayerDied )

	RegisterSignal( "ShowPerkHud" )
	RegisterSignal( "AlphaOverTime" )
}

function NachosHud_ScriptInit( player )
{
	file.bumpscosity <- RandomInt( 0, 1001 )
	if ( file.bumpscosity.tostring().find( "88" ) )
		file.bumpscosity--

	file.showingEnemyIcon <- false
	file.nextDoubleAgentUpdate <- 0
	file.lastPlayerClass <- ""

	file.pilotID <- 0
	file.killstreak <- 0

	NachosHud_Test_InitUnusedHudElems( player )
}

function NachosHud_PlayerSpawned( player )
{
	file.pilotID = format( "%i%i%i%i%i-%i%i%i%i", r(), r(), r(), r(), r(), r(), r(), r(), r() )
	file.killstreak = 0

	if ( player == GetLocalClientPlayer() && !IsWatchingKillReplay() )
		StopPlayerDeathSound( player )
}

function NachosHud_CreateCockpit( cockpit, player )
{
	local vgui = cockpit.s.mainVGUI
	local panel = vgui.s.panel

	local _vguiElem

	cockpit.s.Low_Ammo_Status 		<- HudElement( "Low_Ammo_Status", panel )
	cockpit.s.Low_Ammo_Status.EnableKeyBindingIcons()
	cockpit.s.weaponsGroup.AddElement( cockpit.s.Low_Ammo_Status )

	cockpit.s.Real_Time_Label 		<- HudElement( "RealTimeLabel", panel )
	cockpit.s.Real_Time_Label.Show()
	cockpit.s.weaponsGroup.AddElement( cockpit.s.Real_Time_Label )

	cockpit.s.killstreakBG <- HudElement( "killStreak_background", panel )
	cockpit.s.killstreakLabel <- HudElement( "killStreak_label", panel )
	cockpit.s.weaponsGroup.AddElement( cockpit.s.killstreakBG )
	cockpit.s.weaponsGroup.AddElement( cockpit.s.killstreakLabel )

	cockpit.s.Speedometer_Label 		<- HudElement( "Speedometer_Label", panel )
	cockpit.s.Speedometer_Label.Show()
	cockpit.s.weaponsGroup.AddElement( cockpit.s.Speedometer_Label )

	cockpit.s.DuckingIcon 		<- HudElement( "DuckingIcon", panel )
	cockpit.s.DuckingIcon.Show()
	cockpit.s.weaponsGroup.AddElement( cockpit.s.DuckingIcon )

	cockpit.s.Weather_Label 		<- HudElement( "Weather_Label", panel )
	cockpit.s.Weather_Label.Show()
	cockpit.s.weaponsGroup.AddElement( cockpit.s.Weather_Label )

	cockpit.s.flashingOffhand <- {}
	cockpit.s.flashingOffhand[0] <- false
	cockpit.s.flashingOffhand[1] <- false
	cockpit.s.flashingOffhand[2] <- false

	if ( IsSwitchSidesBased() /*&& !IsRoundBased()*/ )
	{
		local scoreGroup = HudElementGroup( "scoreboardProgress" )
	
		vgui.s.scoreboardProgressBars.GameModeLabel_SwitchSides	<- scoreGroup.CreateElement( "GameModeLabel_SwitchSides", panel )
		vgui.s.scoreboardProgressBars.GameModeLabel_SwitchSides.Show()
		vgui.s.scoreboardProgressBars.GameModeLabel_SwitchSides.SetText( "( " + ( HasSwitchedSides() ? "2" : "1" ) + "/2 )" )
	
		//gametypeText = TranslateTokenToUTF8( gametypeText ) + " (" + ( HasSwitchedSides() ? "2" : "1" ) + "/2 )"
	}

	vgui.s.minimapGroup.CreateElement( "MinimapSatelliteLabel", panel )
	vgui.s.minimapGroup.CreateElement( "MinimapDpadIcon", panel )
	vgui.s.minimapGroup.GetElement( "MinimapDpadIcon" ).EnableKeyBindingIcons()

	if ( IsWatchingKillReplay() || level.showingFullscreenMap )
		vgui.s.minimapGroup.Hide()

	if ( Riff_MinimapState() == eMinimapState.Hidden )
		vgui.s.minimapGroup.Hide()

	cockpit.s.perksGroup		<- HudElementGroup( "perks" )

	cockpit.s.perkImages		<- {}
	cockpit.s.perkImages[0]		<- HudElement( "perkImage0", panel )
	cockpit.s.perkImages[1]		<- HudElement( "perkImage1", panel )
	cockpit.s.perkImages[2]		<- HudElement( "perkImage2", panel )

	cockpit.s.perkNames			<- {}
	cockpit.s.perkNames[0]		<- HudElement( "perkName0", panel )
	cockpit.s.perkNames[1]		<- HudElement( "perkName1", panel )
	cockpit.s.perkNames[2]		<- HudElement( "perkName2", panel )

	foreach ( perk in cockpit.s.perkImages )
	{
		//perk.Hide()
		//perk.SetAlpha( 0 )
		cockpit.s.perksGroup.AddElement( perk )
	}

	foreach ( perk in cockpit.s.perkNames )
	{
		//perk.Hide()
		//perk.SetAlpha( 0 )
		cockpit.s.perksGroup.AddElement( perk )
	}

	_vguiElem = panel.HudElement( "HealthAmmount" )
	vgui.s.healthAmmountLabel <- _vguiElem

	_vguiElem = panel.HudElement( "ShieldAmmount" )
	vgui.s.shieldAmmountLabel <- _vguiElem

	switch( GameRules.GetGameMode() )
	{
		case COOPERATIVE:
			vgui.s.coopMinimapGroup.hide.append( vgui.s.minimapGroup.GetElement( "MinimapSatelliteLabel" ) )
			vgui.s.coopMinimapGroup.hide.append( vgui.s.minimapGroup.GetElement( "MinimapDpadIcon" ) )
			foreach ( elem in vgui.s.coopMinimapGroup.hide )
				elem.Hide()

			vgui.s.assaultIndicatorGroup <- HudElementGroup( "assaultIndicatorGroup" )
			vgui.s.assaultIndicator <- {}
			vgui.s.assaultIndicator.icon <- vgui.s.assaultIndicatorGroup.CreateElement( "PDTHAssaultIcon", panel )
			vgui.s.assaultIndicator.label <- vgui.s.assaultIndicatorGroup.CreateElement( "PDTHAssaultLabel", panel )
			thread NachosToggleAssaultIndicator( cockpit, vgui, player )

			player.Signal( "UpdatingWaveInfo" )
			break
		
		default:
			break
	}

	switch( GetGameState() )
	{
		case eGameState.Epilogue:
			vgui.s.epilogue.Show()
			break
	}

	if ( player.IsTitan() )
		thread NachosHud_CreateTitanCockpitElems( cockpit, vgui, player )
	else
		thread NachosHud_CreatePilotCockpitElems( cockpit, vgui, player )

	thread NachosHudThink( cockpit, vgui, player )
	thread NachosWeaponThink( cockpit, player )
}

function NachosHud_CreateTitanCockpitElems( cockpit, vgui, player )
{
	local panel = vgui.s.panel
	local _vguiElem

	_vguiElem = panel.HudElement( "PairingLabel" )
	vgui.s.pairingLabel <- _vguiElem
	vgui.s.pairingLabel.Show()

	local text = "PAIRING P-" + file.pilotID
	vgui.s.pairingLabel.SetText( text )

	wait 1.5

	if ( vgui && vgui.s.pairingLabel )
	{
		vgui.s.pairingLabel.SetText( "SYSTEMS READY" )
		vgui.s.pairingLabel.FadeOverTimeDelayed( 0, 0.5, 1.5 )
	}
}

function NachosHud_CreatePilotCockpitElems( cockpit, vgui, player )
{
	local panel = vgui.s.panel
	local _vguiElem

	/*
	_vguiElem = panel.HudElement( "HealthBar" )
	_vguiElem.SetBarProgressSourceEntity( player )
	_vguiElem.SetBarProgressSource( ProgressSource.PROGRESS_SOURCE_ENTITY_HEALTH )
	_vguiElem.SetBarProgressRemap( 0.0, 1.0, 0.05625, 1.0 )
	vgui.s.healthBar <- _vguiElem

	_vguiElem = panel.HudElement( "ShieldBar" )
	vgui.s.shieldBar <- _vguiElem
	_vguiElem.SetColor( SHIELD_R, SHIELD_G, SHIELD_B, 255 )
	vgui.s.shieldBar.SetBarProgress( 1.0 )

	thread HealthBarsThink( cockpit, player )
	thread TitanShieldBarThink( cockpit, player )
	*/
}

function NachosHud_GameStateChanged()
{
	local player = GetLocalClientPlayer()
	local cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	local vgui = cockpit.GetMainVGUI()
	if ( !vgui )
		return

	switch ( GetGameState() )
	{
		case eGameState.Epilogue:
			vgui.s.epilogue.SetAlpha( 0 )
			vgui.s.epilogue.Show()
			vgui.s.epilogue.FadeOverTime( 255, 1.5 )
			break
		
		case eGameState.Postmatch:
			vgui.s.epilogue.FadeOverTime( 0, 1.5 )
			break
	}
}

function NachosHud_PlayerDidDamage( attacker, params )
{
	if ( IsWatchingKillReplay() )
		return

	local victim = params.victim
	if ( !victim )
		return

	if ( !victim.IsPlayer() )
		return

	if ( !( params.damageType & DF_KILLSHOT ) )
		return

	local player = GetLocalViewPlayer()
	if ( !player || !IsAlive( player ) )
		return

	local cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	file.killstreak++

	if ( !cockpit.s.killstreakBG.IsVisible() )
	{
		cockpit.s.killstreakBG.SetAlpha( 0 )
		cockpit.s.killstreakLabel.SetAlpha( 0 )

		cockpit.s.killstreakBG.Show()
		cockpit.s.killstreakLabel.Show()

		cockpit.s.killstreakBG.FadeOverTime( 255, 0.1, INTERPOLATOR_ACCEL )
		cockpit.s.killstreakLabel.FadeOverTime( 255, 0.1, INTERPOLATOR_ACCEL )
	}

	cockpit.s.killstreakLabel.SetText( "#SENTRY_TURRET_KILLCOUNT", "x" + file.killstreak.tostring() )
}

function NachosHud_PlayerDied( player )
{
	if ( IsWatchingKillReplay() )
		return

	if ( player == GetLocalClientPlayer() )
	{
		PlayPlayerDeathSound( player )
		return
	}

	if ( !ShouldUsePlayerStatusCount() && !IsSuddenDeathGameMode() )
		return

	// TODO mw19 snd player 1 vs x
}

function NachosHud_Test_InitUnusedHudElems( player )
{
	//player.InitHudElem( "sniperCamRingAnchor" )
	player.InitHudElem( "sniperCamRingIcon" )
	player.InitHudElem( "sniperCamRingIconZoom" )

	//player.InitHudElem( "" )
	//player.InitHudElem( "idAnchor" )
	player.InitHudElem( "idFrame" )
	player.InitHudElem( "idBackground" )
	player.InitHudElem( "idLogo" )
	player.InitHudElem( "idLogoShadow" )
	player.InitHudElem( "idName" )
	player.InitHudElem( "idNameShadow" )
}

function nachos_test_showid()
{
	local player = GetLocalClientPlayer()

	player.hudElems.idFrame.Show()
	player.hudElems.idBackground.Show()
	player.hudElems.idLogo.Show()
	player.hudElems.idLogoShadow.Show()
	player.hudElems.idName.Show()
	player.hudElems.idNameShadow.Show()
}

///////////////////////////////////////////////////////////////////////////////////////////////////

function NachosHudThink( cockpit, vgui, player )
{
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	local time
	local weapon
	local passives = 0
	local oldPassives = 0
	local soul

	local nextTimeUpdate = 0
	local nextWeatherUpdate = 0
	local nextDoubleAgentUpdate = 0
	local nextWinStateUpdate = 0

	local showingGamemodeName = true
	local showingEnemyIcon = false

	while( true )
	{
		WaitFrame()
		time = Time()

		if ( time > nextTimeUpdate )
		{
			NachosTimeLabel( cockpit, player, cockpit.s.Real_Time_Label )
			nextTimeUpdate = time + 1.0
		}

		NachosSpeedometer( cockpit, player, cockpit.s.Speedometer_Label )
		NachosDuckingIcon( cockpit, player, cockpit.s.DuckingIcon )
		NachosAdsSway( player )

		if ( time > nextWeatherUpdate )
		{
			NachosWeatherLabel( cockpit, player, cockpit.s.Weather_Label )
			nextWeatherUpdate = time + RandomFloat( 3.0, 9.0 )
		}

		local weapon = player.GetSelectedWeapon()
		if ( !weapon )
			weapon = player.GetActiveWeapon()

		if ( IsValid( weapon ) )
		{
			NachosReloadLabel( cockpit, player, weapon )
			//NachosAmmoLabel( cockpit, vgui, player, weapon )
		}

		//local class = player.GetPlayerClass()
		//if ( !IsWatchingKillReplay() && player.classChanged )
		//	NachosHud_PlayerClassChanged( player, class )
		//file.lastPlayerClass = class


		passives = player.GetPassives()
		if ( PassiveStatusChanged( passives, oldPassives, PAS_FUSION_CORE ) )
		{
			UpdateAmmoBarColor( cockpit, player, weapon )
		}
		oldPassives = passives

		local winStateResults = NachosWinState( vgui, player, showingGamemodeName, nextWinStateUpdate )
		//NachosWinState( vgui, player, showingGamemodeName, nextWinStateUpdate )

		showingGamemodeName = winStateResults.showingGamemodeName
		nextWinStateUpdate = winStateResults.nextWinStateUpdate

		/*
		if ( GetPlayerActiveBurnCard( player ) == "bc_double_agent" && time > nextDoubleAgentUpdate )
		{
			showingEnemyIcon = NachosDoubleAgentHUD( cockpit, vgui, player, showingEnemyIcon )

			nextDoubleAgentUpdate = time
			nextDoubleAgentUpdate += showingEnemyIcon ? RandomFloat( 1.0, 1.5 ) : RandomFloat( 4.0, 6.0 )
		}
		*/

		//NachosDoubleAgentHUD( cockpit, vgui, player )

		soul = player.GetTitanSoul()
		if ( GetConVarBool( "autocvar_nachos_healthbar_labels" ) )
		{
			vgui.s.healthAmmountLabel.Show()
			vgui.s.healthAmmountLabel.SetText( player.GetHealth().tostring() )

			if ( soul )
			{
				vgui.s.shieldAmmountLabel.Show()
				vgui.s.shieldAmmountLabel.SetText( soul.GetShieldHealth().tostring() )
			}
		}
		else
		{
			vgui.s.healthAmmountLabel.Hide()

			if ( soul )
				vgui.s.shieldAmmountLabel.Hide()
		}


		switch( GameRules.GetGameMode() )
		{
			case COOPERATIVE:
				local assaultAlpha = Sine( 0.5, 0.4, 1.0, 0 )
				assaultAlpha *= 255

				vgui.s.assaultIndicator.icon.SetAlpha( assaultAlpha )
				vgui.s.assaultIndicator.label.SetAlpha( assaultAlpha )
				break
		}
	}
}

function NachosHud_PlayerClassChanged( player, newClass )
{
	printt( "fjoiwrgjvioewrg" )

	switch( newClass )
	{
		case level.pilotClass:
			if ( file.lastPlayerClass == "titan" )
				ClientScreenFadeFromBlack( 1.5, 0 )
			break
	}
}

const fguieghuie = 0
function NachosTimeLabel( cockpit, player, label )
{
	local time = GetTimeForLabel()
	local OffsetMinutes = time.minutes
	local OffsetHours = time.hours

	local OffsetHoursString = OffsetHours.tostring()
	local OffsetMinutesString = OffsetMinutes.tostring()
	local CurrentHalfofDay

	local finalTime

	if ( fguieghuie )
	{
		if ( OffsetMinutes < 10 )
			label.SetText( "#HUD_ARCHER_TARGET", OffsetHoursString, "0" + OffsetMinutesString )
		else
			label.SetText( "#HUD_ARCHER_TARGET", OffsetHoursString, OffsetMinutesString )
	}
	else
	{
		if ( OffsetHours > 11 )
		{
			CurrentHalfofDay = " PM"
			OffsetHours -= 12 //( OffsetHours - 12 )
			OffsetHoursString = OffsetHours.tostring() // eh
		}
		else 
		{
			CurrentHalfofDay = " AM"
		}

		if ( OffsetMinutes < 10 )
			label.SetText( "#HUD_ARCHER_TARGET", OffsetHoursString, "0" + OffsetMinutesString + CurrentHalfofDay )
		else
			label.SetText( "#HUD_ARCHER_TARGET", OffsetHoursString, OffsetMinutesString + CurrentHalfofDay )
	}

	//printt( "OffsetMinutesString " + OffsetMinutesString )
	//printt( "OffsetHoursString " + OffsetHoursString )

	//label.SetText( finalTime )
	//label.SetText( "#HUD_ARCHER_TARGET", OffsetHoursString, OffsetMinutesString )

}

function GetTimeForLabel()
{
	local currentTime = Daily_GetCurrentTime()
	local timePartsNow = GetUnixTimeParts( currentTime )

	local hour = timePartsNow["hour"]
	local minute = timePartsNow["minute"]

	local OffsetHours = hour + 6
	local OffsetMinutes = minute + 0

	if ( OffsetMinutes >= 60 )
	{
		OffsetHours++
		OffsetMinutes -= 60
	}

	if ( OffsetMinutes < 0 )
	{
		OffsetHours--
		OffsetMinutes += 60
	}

	if ( OffsetHours < 0 )
	{
		OffsetHours += 24
	}
	if ( OffsetHours >= 24 )
	{
		OffsetHours -= 24
	}

	return { minutes = OffsetMinutes, hours = OffsetHours }
}

function NachosSpeedometer( cockpit, player, label )
{
	local includeVertical = false //(GetConVarInt("s2_speedometer_vertical") == 1)
	local usesMetric = true //(GetConVarInt("s2_speedometer_metric") == 1)
	local addHammer = true //(GetConVarInt("s2_speedometer_hammer") == 1)
	local speedFade = true //(GetConVarInt("s2_speedometer_fade") == 1)
	local alpha = 1.0 //GetConVarFloat("s2_speedometer_alpha")

	local playerVelV = player.GetVelocity()
	local playerVel

	if ( includeVertical )
		playerVel = sqrt( playerVelV.x * playerVelV.x + playerVelV.y * playerVelV.y + playerVelV.z * playerVelV.z )
	else
		playerVel = sqrt( playerVelV.x * playerVelV.x + playerVelV.y * playerVelV.y )

	local playerVelNormal = playerVel * ( 0.091392 )
	if ( !usesMetric )
		playerVelNormal *= ( 0.621371 )

	local playerVelStr = format( "%3i", playerVelNormal )
	if ( usesMetric )
		playerVelStr += " KPH"
	else
		playerVelStr += " MPH"

	if ( addHammer )
		playerVelStr += ("\n" + format("%3i", playerVel) + " HPS")

	if ( playerVel / 300 < alpha && speedFade )
		label.SetAlpha( ( playerVel / 300 ) * 255 )
	else
		label.SetAlpha( alpha * 255 )

	label.SetText( playerVelStr )
}

function NachosDuckingIcon( cockpit, player, label )
{
	if ( player.IsCrouched() )
		label.Show()
	else
		label.Hide()
}

function NachosWeatherLabel( cockpit, player, label )
{
	local useCelsius = true

	local weather = RandomInt( 70, 100 )

	if ( weather == 88 )
		weather--

	if ( useCelsius )
		weather = ( weather - 32 ) * 5/9

	local weatherString = format( "%3i", weather ) + "º"
	if ( RandomInt( 1, 1000 ) == 1 )
		weatherString = "zip 30114"

	label.SetText( "Weather: %s1\nBumpscosity: %s2", weatherString, file.bumpscosity )

}

function NachosAdsSway( player )
{
	local weapon = player.GetActiveWeapon()
	if ( !weapon )
	{
		SetCvarIfNotBool( player, "delta_enable_ads_sway", 1 )
		return
	}

	local className = weapon.GetClassname()
	if ( className != "mp_weapon_dmr" && className != "mp_weapon_sniper" && className != WEAPON_VALKYRIE_NAME )
	{
		SetCvarIfNotBool( player, "delta_enable_ads_sway", 1 )
		return
	}

	if ( WeaponHasMod( weapon, "aog" ) || WeaponHasMod( weapon, "iron_sights" ) )
		SetCvarIfNotBool( player, "delta_enable_ads_sway", 1 )
	else
		SetCvarIfNotBool( player, "delta_enable_ads_sway", 0 )
}

function NachosWeaponThink( cockpit, player )
{
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )
	cockpit.EndSignal( "OnDestroy" )

	local weapon
	local lastWeapon

	while( true )
	{
		WaitSignal( player, "UpdateWeapons", "ResetWeapons" )

		if ( IsWatchingKillReplay() )
			continue

		weapon = player.GetSelectedWeapon()
		if ( !weapon )
			weapon = player.GetActiveWeapon()

		if ( !( "weapon" in player.s.weaponUpdateData ) )
		{
			if ( !weapon )
			{
				cockpit.s.weaponMags[0].Hide()
				cockpit.s.weaponMagsLabel.Hide()

				cockpit.s.weaponMags[0].SetImage( "HUD/weaponinfo_clip" )
			}
			else if ( weapon.IsWeaponOffhand() )
			{
				//if ( !WeaponCancelsCloak( weapon ) )
				//{
				//	cockpit.s.weaponMags[0].Show()
				//	cockpit.s.weaponMagsLabel.Show()

				//	cockpit.s.weaponMags[0].SetImage( "HUD/dpad_grenade_icon" )
				//}
				//else
				{
					cockpit.s.weaponMags[0].Hide()
					cockpit.s.weaponMagsLabel.Hide()

					cockpit.s.weaponMags[0].SetImage( "HUD/weaponinfo_clip" )
				}
			}
			else
			{
				cockpit.s.weaponMags[0].Show()
				cockpit.s.weaponMagsLabel.Show()

				cockpit.s.weaponMags[0].SetImage( "HUD/weaponinfo_clip" )
			}
		}

		if ( IsValid( weapon ) && weapon != lastWeapon )
		{
			local weaponMods = weapon.GetMods()
			local burnModText = null
			foreach ( mod in weaponMods )
			{
				if ( mod in level.burnCardWeaponModList )
				{
					burnModText = level.burnCardWeaponModList[ mod ]
					break
				}
			}

			local soul = player.GetTitanSoul()
			if ( IsValid( soul ) && PlayerHasDamageCore() )
			{
				cockpit.s.weaponName.SetColor( SHIELD_BOOST_HUD_COLOR )
				cockpit.s.weaponAmmoCount.SetColor( SHIELD_BOOST_HUD_COLOR )
				cockpit.s.weaponAmmoBar.SetColor( SHIELD_BOOST_HUD_COLOR )
				cockpit.s.weaponMagsLabel.SetColor( SHIELD_BOOST_HUD_COLOR )
				cockpit.s.chargeAmmoBar.SetColor( SHIELD_BOOST_HUD_COLOR )
			}
			else if ( burnModText )
			{
				cockpit.s.weaponName.SetColor( BURN_CARD_WEAPON_HUD_COLOR )
				cockpit.s.weaponAmmoCount.SetColor( BURN_CARD_WEAPON_HUD_COLOR )
				cockpit.s.weaponAmmoBar.SetColor( BURN_CARD_WEAPON_HUD_COLOR )
				cockpit.s.weaponMagsLabel.SetColor( BURN_CARD_WEAPON_HUD_COLOR )
				cockpit.s.chargeAmmoBar.SetColor( BURN_CARD_WEAPON_HUD_COLOR )
			}
			else
			{
				//local ammoFracInfo = GetCurrentAmmoFrac( player, weapon )

				cockpit.s.weaponName.ReturnToBaseColor()
				cockpit.s.weaponAmmoCount.ReturnToBaseColor()
				cockpit.s.weaponAmmoBar.ReturnToBaseColor()
				cockpit.s.weaponMagsLabel.ReturnToBaseColor()
				cockpit.s.chargeAmmoBar.ReturnToBaseColor()
			}
		}

		lastWeapon = weapon
	}
}

function NachosReloadLabel( cockpit, player, weapon )
{
	if ( IsWatchingKillReplay() )
		return

	local className = weapon.GetWeaponClassName()

	//if ( GetWeaponInfoFileKeyField_Global( className, "ammo_clip_size" ) < 1 || GetWeaponInfoFileKeyField_Global( className, "ammo_clip_size" ) > 999 )
	//{
	//	WaitFrame()
	//	cockpit.s.Low_Ammo_Status.Hide()
	//	continue
	//}

	local text = "%+reload% " + ( Localize( "#VALVE_HINT_RELOAD" ) )
	local col = ColorStringToArray( GetConVarString( "usePromptTextColor" ) )
	local ammoFracInfo = GetCurrentAmmoFrac( player, weapon )

	if ( weapon.IsReloading() )
	{
		cockpit.s.Low_Ammo_Status.Hide()

		if ( ammoFracInfo.fracState == FRAC_STATE_LOW )
		{
			cockpit.s.weaponAmmoCount.SetColor( [ 255, 0, 0, 255 ] )
			cockpit.s.weaponAmmoBar.SetColor( [ 255, 0, 0, 255 ] )
		}
		else
		{
			ReturnElemToBaseOrBurnColor( cockpit.s.weaponAmmoCount, false, weapon )
			ReturnElemToBaseOrBurnColor( cockpit.s.weaponAmmoBar, false, weapon )
			//cockpit.s.weaponMagsLabel.ReturnToBaseColor()
		}
	}
	else
	{
		if ( ammoFracInfo.fracState == FRAC_STATE_LOW )
		{
			cockpit.s.Low_Ammo_Status.Show()

			if ( ammoFracInfo.clipState == FRAC_STATE_LOW )
			{
				text = "#HUD_NO_AMMO"
				//cockpit.s.weaponMagsLabel.SetColor( [ 255, 0, 0, 255 ] )
			}
			else if ( ammoFracInfo.clipState == FRAC_STATE_MID )
			{
				text = "#HUD_LOW_AMMO"
				//cockpit.s.weaponMagsLabel.SetColor( [ 255, 0, 0, 255 ] )
			}
			else
			{
				//cockpit.s.weaponMagsLabel.ReturnToBaseColor()
			}

			col = [ 252, 116, 98, 255 ]
			cockpit.s.weaponAmmoCount.SetColor( [ 255, 0, 0, 255 ] )
			cockpit.s.weaponAmmoBar.SetColor( [ 255, 0, 0, 255 ] )
		}
		else if ( ammoFracInfo.fracState == FRAC_STATE_MID )
		{
			cockpit.s.Low_Ammo_Status.Show()

			if ( ammoFracInfo.clipState == FRAC_STATE_MID )
				text = "#HUD_LOW_AMMO"

			ReturnElemToBaseOrBurnColor( cockpit.s.weaponAmmoCount, false, weapon )
			ReturnElemToBaseOrBurnColor( cockpit.s.weaponAmmoBar, false, weapon )
			//cockpit.s.weaponMagsLabel.ReturnToBaseColor()
		}
		else
		{
			cockpit.s.Low_Ammo_Status.Hide()

			ReturnElemToBaseOrBurnColor( cockpit.s.weaponAmmoCount, false, weapon )
			ReturnElemToBaseOrBurnColor( cockpit.s.weaponAmmoBar, false, weapon )
			//cockpit.s.weaponMagsLabel.ReturnToBaseColor()
		}

		/*
		if ( currentAmmo <= maxAmmo * fracLow )
		{
			cockpit.s.Low_Ammo_Status.Show()

			if ( clipAmount == 0 && currentAmmo == 0 )
				text = "#HUD_NO_AMMO"
			else if ( clipAmount <= 2 && currentAmmo >= 0 )
				text = "#HUD_LOW_AMMO"

			//if ( clipAmount <= 1 && currentAmmo >= 0 )
			//	text = "#HUD_LOW_AMMO"
			//else if ( clipAmount == 0 && currentAmmo == 0 )
			//	text = "#HUD_NO_AMMO"

			col = [ 252, 116, 98, 255 ]
		}
		else if ( currentAmmo < maxAmmo * fracMid )
		{
			cockpit.s.Low_Ammo_Status.Show()

			if ( clipAmount <= 2 )
				text = "#HUD_LOW_AMMO"
		}
		else
		{
			cockpit.s.Low_Ammo_Status.Hide()
		}
		*/
	}

	if ( ammoFracInfo.clipState == FRAC_STATE_LOW || ammoFracInfo.clipState == FRAC_STATE_MID )
		cockpit.s.weaponMagsLabel.SetColor( [ 255, 0, 0, 255 ] )
	else
		ReturnElemToBaseOrBurnColor( cockpit.s.weaponMagsLabel, false, weapon )


	cockpit.s.Low_Ammo_Status.SetText( text )
	cockpit.s.Low_Ammo_Status.SetColor( col )
}

function NachosAmmoLabel( cockpit, vgui, player, weapon )
{
	if ( IsWatchingKillReplay() )
		return

	//local ammoMax = weapon.GetWeaponInfoFileKeyField( "ammo_clip_size" )
	//local currentAmmo = weapon.GetWeaponPrimaryClipCount()
	local AmmoStockpile = player.GetWeaponAmmoStockpile( weapon )

	//local loadedAmmo = player.GetWeaponAmmoLoaded( activeWeapon )
	//local loadedAmmoMax = player.GetWeaponAmmoMaxLoaded( activeWeapon )

	cockpit.s.weaponMagsLabel.SetText( "#HUDAUTOTEXT_ACTIVEWEAPONMAGAZINECOUNT", AmmoStockpile.tostring() )
}

function UpdateAmmoBarColor( cockpit, player, weapon )
{
	if ( !IsValid( player ) )
		return

	if ( !IsAlive( player ) )
		return

	local soul = player.GetTitanSoul()
	if ( IsValid( soul ) && GetSoulTitanType( soul ) == "stryder" )
		return

	// its a titan only passive. Pilot doesn't even have dash bar anyway.
	if ( !player.IsTitan() )
		return

	local col
	local alpha

	local elems = [ null, cockpit.s.weaponName, cockpit.s.weaponAmmoCount, cockpit.s.weaponAmmoBar, cockpit.s.weaponMagsLabel, cockpit.s.chargeAmmoBar ]
	foreach ( elem in elems )
	{
		if ( elem )
		{
			col = elem.GetBaseColor()
			alpha = elem.GetBaseAlpha()

			if ( PlayerHasDamageCore() && GetConVarBool( "delta_hud_misc_changes" ) )
				col = [ SHIELD_BOOST_R, SHIELD_BOOST_G, SHIELD_BOOST_B ]
			else if ( weapon && weapon.GetWeaponModSetting( "is_burn_mod" ) && GetConVarBool( "delta_hud_misc_changes" ) )
				col = [ BURN_CARD_WEAPON_HUD_COLOR[0], BURN_CARD_WEAPON_HUD_COLOR[1], BURN_CARD_WEAPON_HUD_COLOR[2], BURN_CARD_WEAPON_HUD_COLOR[3] ]
		
			elem.ColorOverTime( col[0], col[1], col[2], alpha, 0.5, INTERPOLATOR_DEACCEL )
		}
	}
}

function NachosDoubleAgentHUD( cockpit, vgui, player, showingEnemyIcon = false )
{
	local friendlyTeam = player.GetTeam()
	local flickerElem = vgui.s.scoreboardProgressBars.GameInfo_Icon
	local flickerElemBaseAlpha = flickerElem.GetBaseAlpha()

	local showingEnemyIcon = file.showingEnemyIcon
	local nextDoubleAgentUpdate = file.nextDoubleAgentUpdate

	local state 					= false
	local flickerCountToSwitchIcon 	= 10
	local flickers 					= 25 // always an odd number

	for ( local i = 0; i < flickers; i++ )
	{
		if ( !state )
		{
			if ( i == flickerCountToSwitchIcon )
			{
				if ( flickerElem )
					flickerElem.Hide()

				flickerElem = elemGroup.RankedLogo
				flickerElem.SetImage( friendlyTeam == TEAM_MILITIA ? TEAM_ICON_IMC : TEAM_ICON_MILITIA )
			}

			if ( flickerElem )
				flickerElem.Show()

			state = true
		}
		else
		{
			if ( flickerElem )
				flickerElem.Hide()
			state = false
		}

		local flickerWait = RandomFloat( 0, 0.15 )

		if ( flickerElem )
			flickerElem.FadeOverTime( 0, flickerWait )

		wait flickerWait

		if ( flickerElem )
			flickerElem.SetAlpha( flickerElemBaseAlpha )
	}

	flickerElem.SetAlpha( flickerElemBaseAlpha )

/*
	flickerElem.SetAlpha( 0 )

	if ( showingEnemyIcon )
	{
		flickerElem.SetImage( friendlyTeam == TEAM_MILITIA ? TEAM_ICON_MILITIA : TEAM_ICON_IMC )
		showingEnemyIcon = false
	}
	else
	{
		flickerElem.SetImage( friendlyTeam == TEAM_MILITIA ? TEAM_ICON_IMC : TEAM_ICON_MILITIA )
		showingEnemyIcon = true
	}

	//thread SetAlphaOverTime( flickerElem, flickerElemBaseAlpha, 0.5 )
	flickerElem.FadeOverTime( scoreElemsBaseAlpha, 0.5, INTERPOLATOR_ACCEL )
*/

	return showingEnemyIcon
}

function NachosToggleAssaultIndicator( cockpit, vgui, player )
{
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	while( true )
	{
		player.WaitSignal( "UpdatingWaveInfo" )

		local waveTimer 		= level.nv.TDWaveTimer
		local elapsedTime 		= Time() - level.nv.TDWaveStartTime
		local timeRemaining 	= waveTimer - elapsedTime
		local waveTimeRatio 	= timeRemaining / waveTimer
		local totalEnemyNum 	= GetTotalEnemyNum()

		if ( level.nv.TDCurrWave != null && GetGameState() == eGameState.Playing )
		{
			vgui.s.assaultIndicatorGroup.Hide()

			if ( level.nv.TDGeneratorHealth > 0 && waveTimeRatio < 0 && totalEnemyNum )
			{
				vgui.s.assaultIndicatorGroup.Show()
			}
		}
	}
}

// Holy FUCK this one was annoying to make
// You have no idea
function NachosWinState( vgui, player, showingGamemodeName, nextWinStateUpdate )
{
	local friendlyScore = 0
	local enemyScore = 0

	local scoreElems = vgui.s.scoreboardProgressBars
	local gameModeLabelText
	local gameModeLabelColor

	if ( !IsFFABased() )
	{
		local friendlyTeam = player.GetTeam()
		local enemyTeam = friendlyTeam == TEAM_IMC ? TEAM_MILITIA : TEAM_IMC

		friendlyScore = GameRules.GetTeamScore( friendlyTeam )
		enemyScore = GameRules.GetTeamScore( enemyTeam )
	}
	else
	{
		friendlyScore = player.GetAssaultScore()

		local opponent = GetLeadingOpponent( player )
		if ( opponent )
			enemyScore = opponent.GetAssaultScore()
	}

	if ( Time() > nextWinStateUpdate )
	{
		showingGamemodeName = !showingGamemodeName

		nextWinStateUpdate = Time()
		nextWinStateUpdate += showingGamemodeName ? 5.0 : 15.0
		
		//printt( "====================" )
		//printt( "showingGamemodeName " + showingGamemodeName )
		//printt( "time " + Time() )
		//printt( "nextWinStateUpdate " + nextWinStateUpdate )
	}
	
	if ( GetGameState() == eGameState.SuddenDeath )
	{
		gameModeLabelText = GAMETYPE_TEXT[ GameRules.GetGameMode() ] + "_SUDDEN_DEATH"
		gameModeLabelColor = [255, 100, 0, 255]
	}
	else
	{
		if ( showingGamemodeName )
		{
			gameModeLabelText = GAMETYPE_TEXT[ GameRules.GetGameMode() ]
			gameModeLabelColor = scoreElems.GameModeLabel.GetBaseColor()
		}
		else
		{
			if ( friendlyScore == enemyScore )
			{
				gameModeLabelText = "Tied"
				gameModeLabelColor = [255, 255, 100, 255]
			}
			else if ( friendlyScore > enemyScore )
			{
				gameModeLabelText = "Winning"
				gameModeLabelColor = [100, 255, 100, 255]
			}
			else
			{
				gameModeLabelText = "Losing"
				gameModeLabelColor = [255, 100, 100, 255]
			}
		}
	}

	scoreElems.GameModeLabel.SetText( gameModeLabelText )
	scoreElems.GameModeLabel.SetColor( gameModeLabelColor )

	if ( IsSwitchSidesBased() /*&& !IsRoundBased()*/ )
	{
		scoreElems.GameModeLabel_SwitchSides.SetColor( gameModeLabelColor )
	}

	return { showingGamemodeName = showingGamemodeName, nextWinStateUpdate = nextWinStateUpdate }
}

//function WinStateHUDThink( vgui, player )
//{
//	vgui.EndSignal( "OnDestroy" )
//
//	local friendlyScore = 0
//	local enemyScore = 0
//
//	local scoreElems = vgui.s.scoreboardProgressBars
//	local gameModeLabelText
//	local gameModeLabelColor
//
//	local showingGamemodeName = true
//
//	local nextWinStateUpdate = 0
//
//	while( true )
//	{
//		player = GetLocalViewPlayer()
//		while ( !player )
//		{
//			continue
//		}
//
//		while ( GetGameState() < eGameState.Playing )
//			wait 0
//
//		if ( !IsFFABased() )
//		{
//			local friendlyTeam = player.GetTeam()
//			local enemyTeam = friendlyTeam == TEAM_IMC ? TEAM_MILITIA : TEAM_IMC
//
//			friendlyScore = GameRules.GetTeamScore( friendlyTeam )
//			enemyScore = GameRules.GetTeamScore( enemyTeam )
//		}
//		else
//		{
//			friendlyScore = player.GetAssaultScore()
//
//			local opponent = GetLeadingOpponent( player )
//			if ( opponent )
//				enemyScore = opponent.GetAssaultScore()
//		}
//
//		if ( Time() > nextWinStateUpdate )
//		{
//			showingGamemodeName = !showingGamemodeName
//
//			nextWinStateUpdate = Time()
//			nextWinStateUpdate += showingGamemodeName ? 5.0 : 15.0
//		
//			printt( "====================" )
//			printt( "showingGamemodeName " + showingGamemodeName )
//			printt( "time " + Time() )
//			printt( "nextWinStateUpdate " + nextWinStateUpdate )
//		}
//
//		if ( showingGamemodeName )
//		{
//			gameModeLabelText = GAMETYPE_TEXT[ GameRules.GetGameMode() ]
//			gameModeLabelColor = scoreElems.GameModeLabel.GetBaseColor()
//		}
//		else
//		{
//			if ( friendlyScore == enemyScore )
//			{
//				gameModeLabelText = "Tied"
//				gameModeLabelColor = [255, 255, 100, 255]
//			}
//			else if ( friendlyScore > enemyScore )
//			{
//				gameModeLabelText = "Winning"
//				gameModeLabelColor = [100, 255, 100, 255]
//			}
//			else
//			{
//				gameModeLabelText = "Losing"
//				gameModeLabelColor = [255, 100, 100, 255]
//			}
//		}
//
//		scoreElems.GameModeLabel.SetText( gameModeLabelText )
//		scoreElems.GameModeLabel.SetColor( gameModeLabelColor )
//
//		if ( IsSwitchSidesBased() /*&& !IsRoundBased()*/ )
//		{
//			scoreElems.GameModeLabel_SwitchSides.SetColor( gameModeLabelColor )
//		}
//
//		wait 1.0
//	}
//}

function PlayPlayerDeathSound( player )
{
	if ( IsPlayerEliminated( player ) )
		EmitSoundOnEntity( player, "Player_Death_Begin_Eliminated" )
	else
		EmitSoundOnEntity( player, "Player_Death_Begin" )
}

function StopPlayerDeathSound( player )
{
	FadeOutSoundOnEntity( player, "Player_Death_Begin", 0.5 )
	FadeOutSoundOnEntity( player, "Player_Death_Begin_Eliminated", 0.5 )
	EmitSoundOnEntity( player, "Player_Death_PrespawnTransition" )
}

function GetCurrentAmmoFrac( player, weapon )
{
	local currentAmmo
	local maxAmmo
	local clipAmount

//	local usesStockpileAmmo = ( weapon.GetWeaponInfoFileKeyField( "ammo_stockpile_max" ) > 0 )
	local stockpileAmmo = player.GetWeaponAmmoStockpile( weapon )
//	local maxReserveClip = ( weapon.GetWeaponInfoFileKeyField( "ammo_stockpile_max" ) / player.GetWeaponAmmoMaxLoaded( weapon ) )

// script_client printt( ( GetLocalViewPlayer().GetWeaponAmmoStockpile( GetLocalViewPlayer().GetActiveWeapon() ) ) / ( GetLocalViewPlayer().GetWeaponAmmoMaxLoaded( GetLocalViewPlayer().GetActiveWeapon() ) ) )

	if ( player.GetWeaponAmmoMaxLoaded( weapon ) > 0 ) //weapon.GetWeaponInfoFileKeyField( "ammo_clip_size" )
	{
		currentAmmo = weapon.GetWeaponPrimaryClipCount()
		maxAmmo = player.GetWeaponAmmoMaxLoaded( weapon )
		clipAmount = ( stockpileAmmo ) / ( maxAmmo )
	}
	else
	{
		currentAmmo = weapon.GetWeaponChargeFraction()
		maxAmmo = weapon.GetWeaponModSetting( "charge_time" )
		clipAmount = ( stockpileAmmo ) / ( maxAmmo )
	}
//	else
//	{
//		currentAmmo = stockpileAmmo
//		maxAmmo = weapon.GetWeaponInfoFileKeyField( "ammo_stockpile_max" )
//	}

	local fracLow = 0.2 //0.1
	local fracMid = 0.6 //0.4

	local fracState
	local clipState

	if ( currentAmmo <= maxAmmo * fracLow )
	{
		fracState = FRAC_STATE_LOW

		if ( clipAmount == 0 && currentAmmo == 0 )
			clipState = FRAC_STATE_LOW
		else if ( clipAmount <= 2 && currentAmmo >= 0 )
			clipState = FRAC_STATE_MID
	}
	else if ( currentAmmo < maxAmmo * fracMid )
	{
		fracState = FRAC_STATE_MID

		if ( clipAmount <= 2 )
			clipState = FRAC_STATE_MID
		else
			clipState = FRAC_STATE_NORMAL
	}
	else
	{
		fracState = FRAC_STATE_NORMAL

		if ( clipAmount <= 2 )
			clipState = FRAC_STATE_MID
		else
			clipState = FRAC_STATE_NORMAL
	}

	return { fracState = fracState, clipState = clipState }
}

function ReturnElemToBaseOrBurnColor( elem, force, weapon = null )
{
	local burn = false

	if ( force )
	{
		elem.SetColor( BURN_CARD_WEAPON_HUD_COLOR )
		burn = true
	}
	else if ( weapon )
	{
		foreach ( mod in weapon.GetMods() )
		{
			if ( mod in level.burnCardWeaponModList )
			{
				elem.SetColor( BURN_CARD_WEAPON_HUD_COLOR )
				burn = true
			}
		}
	}

	if ( PlayerHasDamageCore() && !force )
		elem.SetColor( SHIELD_BOOST_HUD_COLOR )
	else if ( burn )
		elem.SetColor( BURN_CARD_WEAPON_HUD_COLOR )
	else
		elem.ReturnToBaseColor()
}
Globalize( ReturnElemToBaseOrBurnColor )

function WeaponHasMod( weapon, mod )
{
	return weapon.HasModDefined( mod ) && weapon.HasMod( mod )
}

function SetCvarIfNotBool( player, command, state )
{
	if ( GetConVarInt( command ) != state )
		player.ClientCommand( command + " " + state )
}

function PlayerHasDamageCore()
{
	local player = GetLocalViewPlayer()
	if ( !player )
		return

	local soul = player.GetTitanSoul()

	return ( IsValid( soul ) && GetSoulTitanType( soul ) != "stryder" && PlayerHasPassive( player, PAS_FUSION_CORE ) )
}

function PlayerHasDashCore()
{
	local player = GetLocalViewPlayer()
	if ( !player )
		return

	local soul = player.GetTitanSoul()

	return ( IsValid( soul ) && GetSoulTitanType( soul ) == "stryder" && PlayerHasPassive( player, PAS_FUSION_CORE ) )
}

function PlayerHasShieldCore()
{
	local player = GetLocalViewPlayer()
	if ( !player )
		return

	local soul = player.GetTitanSoul()

	return ( IsValid( soul ) && PlayerHasPassive( player, PAS_SHIELD_BOOST ) )
}

function SetAlphaOverTime( panel, alpha, duration )
{
	Signal( panel, "AlphaOverTime" )
	EndSignal( panel, "AlphaOverTime" )
	EndSignal( panel, "OnDestroy" )

	local startTime = Time()
	local endTime = startTime + duration
	local startAlpha = panel.GetAlpha()

	while( Time() <= endTime )
	{
		local a = GraphCapped( Time(), startTime, endTime, startAlpha, alpha )

		if ( panel )
			panel.SetAlpha( a )
		wait 0
	}

	if ( panel )
		panel.SetAlpha( alpha )
}

// Recreation of the Sine VMT proxy
function Sine( sinePeriod, sineMin, sineMax, timeOffset )
{
	return sineMin + ( sineMax - sineMin ) / 2 * ( 1 + sin( 2 * PI / sinePeriod * ( Time() + timeOffset ) ) )
}

function PassiveStatusChanged( passives, oldValue, passive )
{
	if ( oldValue & passive )
	{
		return !( passives & passive )
	}
	else
	{
		return ( passives & passive )
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

function r()
{
	return RandomInt( 0, 10 )
}

function testetty1y33131()
{
	local player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return

	local viewmodel = player.GetViewModelEntity()
	if ( !IsValid( viewmodel ) )
		return

local arrow = CreateClientSidePropDynamic( Vector( 0, 0, 0 ), Vector( 0, 0, 0 ), SARAH_MODEL )

			arrow.DisableRenderWithCockpit()
			arrow.EnableRenderWithViewModelsNoZoom()

			arrow.SetParent( viewmodel )
			//arrow.SetAttachOffsetOrigin( Vector( 25.0, 0.0, -2.0 ) )

}

main()