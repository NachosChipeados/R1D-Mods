
function main()
{
	if ( IsLobby() )
		return

	//AddClientCommandCallback( "+reload", VP_PlayReloadVO )
	//AddClientCommandCallback( "+useAndReload", VP_PlayReloadVO )

	AddCallback_OnClientConnected( VP_PlayerConnected )
	AddCallback_OnPlayerRespawned( VP_Respawned )
	AddCallback_PlayerOrNPCKilled( VP_PlayerOrNPCKilled )
	AddCallback_OnClientChatMsg( VP_ChatMsg )
	AddDamageCallback( "player", VP_PlayerDamaged )
	TEMPAddCallback_OnWeaponAttack( VP_OnWeaponAttack )

	::voicelines <- {}
	voicelines.RELOAD <- { prefix = "diag_%s_grunt%i_gs_magswitchcall_0%s", maxLines = 3 }
	voicelines.RELOAD_EMPTY <- { prefix = "diag_%s_grunt%i_gs_reloadcall_0%s", maxLines = 8 }
	voicelines.THANKS <- { prefix = "diag_%s_grunt%i_gs_skitthanks_01_%s", maxLines = 6 }
	voicelines.KILL_GRUNT <- { prefix = "diag_%s_grunt%i_gs_killenemygrunt_0%s_1", maxLines = 8, chanceToPlay = 30 }
	voicelines.KILL_PILOT <- { prefix = "diag_%s_grunt%i_gs_killenemypilot_%s_1", maxLines = 11 }
	voicelines.KILL_SPECTRE <- { prefix = "diag_%s_grunt%i_gs_killenemyspectre_0%s_1", maxLines = 6, chanceToPlay = 30 }
	voicelines.KILL_TITAN <- { prefix = "diag_%s_grunt%i_gs_gruntkillstitan_0%s_1", maxLines = 5 }
	voicelines.FAN_OUT <- { prefix = "diag_%s_grunt%i_fanoutcall_0%s", maxLines = 6 }
	voicelines.MOVE_OUT <- { prefix = "diag_%s_grunt%i_gs_movefrontline_0%s_1", maxLines = 8 }
	voicelines.GRENADE_OUT <- { prefix = "diag_%s_grunt%i_gs_grenadecall_0%s", maxLines = 5 }
	voicelines.ENGAGE_PILOT <- { prefix = "diag_%s_grunt%i_gs_engagepilotenemy_%s_1", maxLines = 11 }
	voicelines.SQUAD_DEPLETE <- { prefix = "diag_%s_grunt%i_gs_squaddeplete_0%s_1", maxLines = 3 }
	voicelines.ALLY_PILOT_DOWN <- { prefix = "diag_%s_grunt%i_gs_allypilotdown_0%s_1", maxLines = 5 }
	voicelines.ALLY_TITAN_DOWN <- { prefix = "diag_%s_grunt%i_gs_allytitandown_0%s_1", maxLines = 5 }
	voicelines.ALLY_EJECT_FAIL <- { prefix = "diag_%s_grunt%i_gs_allyejectfail_0%s_1", maxLines = 5 }


	::events <- {}
	events[ "reload" ] <- { voiceline = voicelines.RELOAD, priority = 2.0, debounce = 2.0 }
	events[ "reload_empty" ] <- { voiceline = voicelines.RELOAD_EMPTY, priority = 2.0, debounce = 2.0 }
	events[ "thanks" ] <- { voiceline = voicelines.THANKS, priority = 0.5, debounce = 2.0, teamOnly = true }
	events[ "kill_grunt" ] <- { voiceline = voicelines.KILL_GRUNT, priority = 0.5, debounce = 2.0 }
	events[ "kill_pilot" ] <- { voiceline = voicelines.KILL_PILOT, priority = 2.0, debounce = 2.0 }
	events[ "kill_spectre" ] <- { voiceline = voicelines.KILL_SPECTRE, priority = 0.5, debounce = 2.0 }
	events[ "kill_titan" ] <- { voiceline = voicelines.KILL_TITAN, priority = 3.0, debounce = 2.0 }
	events[ "fan_out" ] <- { voiceline = voicelines.FAN_OUT, priority = 0.5, debounce = 2.0, teamOnly = true }
	events[ "move_out" ] <- { voiceline = voicelines.MOVE_OUT, priority = 0.5, debounce = 2.0, teamOnly = true }
	events[ "grenade_out" ] <- { voiceline = voicelines.GRENADE_OUT, priority = 1.0, debounce = 2.0 }
	events[ "engage_pilot" ] <- { voiceline = voicelines.ENGAGE_PILOT, priority = 1.5, debounce = 6.0 }
	events[ "squad_deplete" ] <- { voiceline = voicelines.SQUAD_DEPLETE, priority = 4.0, debounce = 5.0 }
	events[ "ally_pilot_down" ] <- { voiceline = voicelines.ALLY_PILOT_DOWN, priority = 3.0, debounce = 5.0 }
	events[ "ally_titan_down" ] <- { voiceline = voicelines.ALLY_TITAN_DOWN, priority = 3.0, debounce = 5.0 }
	events[ "ally_eject_fail" ] <- { voiceline = voicelines.ALLY_EJECT_FAIL, priority = 3.0, debounce = 5.0 }

	if ( GAMETYPE == COOPERATIVE )
		events[ "kill_titan" ].debounce = 4.0

	//Add defaults for chanceToPlay
	foreach( event in ::events )
	{
		if ( !( "teamOnly" in event ) )
			event.teamOnly <- false

		if ( !( "alwaysAnnounce" in event ) )
			event.alwaysAnnounce <- false

		if ( !( "chanceToPlay" in event ) )
			event.chanceToPlay <- 100

		if ( !( "noVoiceIndex" in event ) )
			event.noVoiceIndex <- false

		if ( !( "noTeamCheck" in event ) )
			event.noTeamCheck <- false

		if ( !( "noRandomLines" in event ) )
			event.noRandomLines <- false

		if ( !( "skipVoiceIndexes" in event ) )
			event.skipVoiceIndexes <- []
	}

	Globalize( VP_PlayBattleChatterLine )
}

function EntitiesDidLoad()
{
	foreach( i, hardpoint in level.hardpoints )
	{
		//hardpoint.s.trigger.ConnectOutput( "OnStartTouch", VP_HardpointOnStartTouch )
		//hardpoint.s.trigger.ConnectOutput( "OnEndTouch", VP_HardpointOnEndTouch )
	}
}

function VP_PlayerConnected( player )
{
	player.s.VP_GruntVoiceIndex <- 0
	player.s.VP_LastBattleChatterTime <- 0
	player.s.VP_BattleChatterLineActive <- false
	player.s.VP_BattleChatterLineAliasList <- []
}

function VP_Respawned( player )
{
	player.s.VP_GruntVoiceIndex = RandomInt( 1, 5 )

	thread VP_PlayIntroDialogue( player )
	thread VP_PlayReloadVO_Think( player )
}

function VP_PlayIntroDialogue( player )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "Disconnected" )

	if ( IsTrainingLevel() )
		return

	if ( Flag( "CinematicIntro" ) )
		FlagWait( "IntroDone" )

	while ( HasCinematicFlag( player, CE_FLAG_INTRO ) )
		player.WaitSignal( "CE_FLAGS_CHANGED" )

	if ( GetClassicMPMode() )
	{
		while ( HasCinematicFlag( player, CE_FLAG_CLASSIC_MP_SPAWNING ) )
			player.WaitSignal( "CE_FLAGS_CHANGED" )
	}

	if ( GetGameState() <= eGameState.Playing )
	{
		wait 3

		if ( !VP_CanPlayBattleChatter( player, false ) )
			return

		VP_PlayBattleChatterLine( player, "move_out", true ) // fan_out
	}
}

function VP_PlayReloadVO( player )
{
	if ( !VP_CanPlayBattleChatter( player ) )
		return

	local weapon = player.GetActiveWeapon()

	if ( !weapon )
		return

	local playerInfo = VP_GetPlayerInfo( player )
	local reloadSound

	if ( player.GetWeaponAmmoLoaded( weapon ) == 0 )
		reloadSound = "reload_empty"
	else
		reloadSound = "reload"

	VP_PlayBattleChatterLine( player, reloadSound, true )
}
Globalize( VP_PlayReloadVO )

function VP_PlayReloadVO_Think( player )
{
	return

	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "Disconnected" )

	while ( true )
	{
		local weapon = player.GetActiveWeapon()
	
		if ( !weapon )
			wait 0

		while ( weapon.IsReloading() )
		{
			if ( player.GetTeam() == TEAM_IMC )
				EmitSoundOnEntity( player, "diag_imc_grunt1_gs_reloadcall_01" )
			else if ( player.GetTeam() == TEAM_MILITIA )
				EmitSoundOnEntity( player, "diag_mcor_grunt1_gs_reloadcall_01" )

			break
		}

		wait 0
	}

//	if ( player.GetTeam() == TEAM_IMC )
//		EmitSoundOnEntity( player, "diag_imc_grunt1_gs_reloadcall_01" )
//	else if ( player.GetTeam() == TEAM_MILITIA )
//		EmitSoundOnEntity( player, "diag_mcor_grunt1_gs_reloadcall_01" )

	//PlaySquadConversationToAll( "aichat_reload", player, true )
}

function VP_PlayerOrNPCKilled( victim, attacker, damageInfo )
{
	if ( victim.IsPlayer() )
	{
		VP_PlayDeathSound( victim, damageInfo )
		VP_PlayAllyDownSound( victim, attacker, damageInfo )
	}

	if ( attacker.IsPlayer() )
		VP_PlayKillSound( victim, attacker, damageInfo )
}

function VP_PlayDeathSound( victim, damageInfo )
{
	if ( !VP_CanPlayBattleChatter( victim, false, false, false ) )
		return

	local attackInfo = VP_GetAttackInfo( damageInfo )

	if ( attackInfo.scriptType & DF_TITAN_STEP )
		return

	local playerInfo = VP_GetPlayerInfo( victim )
	local deathSound

	if ( playerInfo.footstepType == "robot" )
	{
		deathSound = "diag_imc_spectre_gs_spectreDeath_01_1"
	}
	else
	{
		if ( IsFemalePilotModel( victim ) )
		{
			deathSound = "diag_female_titansquish"
		}
		else
		{
			if ( CoinFlip() )
				deathSound = "diag_" + playerInfo.teamString + "_titansquish_01"
			else
				deathSound = "diag_" + playerInfo.teamString + "_grunt" + playerInfo.voiceIndex + "_gs_death_01"
		}
	}

	VP_PlayBattleChatterLine( victim, deathSound )
}

function VP_PlayAllyDownSound( victim, attacker, damageInfo )
{
	if ( victim == attacker || victim == attacker.GetPetTitan() )
		return

	local deathSound
	foreach( player in GetPlayerArrayOfTeam( victim.GetTeam() ) )
	{
		if ( !IsAlive( player ) )
			continue

		if ( !VP_CanPlayBattleChatter( player, false ) )
			continue

		if ( GetLivingPlayers( victim.GetTeam() ).len() == 1 && ( GAMETYPE == COOPERATIVE || IsEliminationBased() ) )
		{
			deathSound = "squad_deplete"
		}
		else
		{
			if ( IsPilot( victim ) )
				deathSound = "ally_pilot_down"
			else if ( victim.IsTitan() )
				deathSound = CoinFlip() ? "ally_titan_down" : "ally_eject_fail"
		}

		VP_PlayBattleChatterLine( player, deathSound, true )
		break
	}
}

function VP_PlayKillSound( victim, attacker, damageInfo )
{
	if ( victim == attacker || victim == attacker.GetPetTitan() )
		return

	if ( !VP_CanPlayBattleChatter( attacker, false ) )
		return

	local playerInfo = VP_GetPlayerInfo( attacker )
	local killSound = "kill_grunt"
	local useNewSystem = true
	local delay = 0.3

	if ( playerInfo.footstepType == "robot" )
	{
		//if ( victim.IsPlayer() )
		//{
			killSound = "diag_imc_spectre_gs_killenemypilot_01_1"
			useNewSystem = false
		//}
	}
	else
	{
		// TODO: + "_2" is for responses
		// diag_imc_grunt1_gs_killenemygrunt_01_1 That's one dead outlaw!
		// diag_imc_grunt1_gs_killenemygrunt_01_2 Copy that!

		if ( IsPilot( victim ) )
		{
			delay = 0.8
			killSound = "kill_pilot"
		}
		else if ( victim.IsSpectre() || victim.IsMarvin() )
		{
			killSound = "kill_spectre"
		}
		else if ( victim.IsTitan() )
		{
			delay = 1.3 // A bit more delay for a titan explosion to clear
			killSound = "kill_titan"
		}
	}

	printt( killSound )
	thread VP_PlayBattleChatterLine_Delayed( attacker, killSound, delay, useNewSystem )
}

function VP_ChatMsg( playerIndex, msg, isTeamChat )
{
//	printt( "AAAAAAAAAA: " + msg )

    local player = GetEntByIndex( playerIndex )
	if ( !VP_CanPlayBattleChatter( player ) )
		return msg

	local playerInfo = VP_GetPlayerInfo( player )
	local voiceline = ""

	local thankStrings = [ "thanks", "thank you", "thx", "ty", "gracias", "graxias", "grax" ]
	foreach ( string in thankStrings )
	{
		if ( StringContains( msg, string ) )
		{
			voiceline = "thanks"
			break
		}
	}

	if ( voiceline != "" )
		VP_PlayBattleChatterLine( player, voiceline, true )

	return msg
}

function VP_PlayerDamaged( player, damageInfo )
{
	VP_PlayPainSounds( player, damageInfo )
	VP_PlayEnemyEngagedVoicelines( player, damageInfo )
}

function VP_PlayPainSounds( player, damageInfo )
{
	if ( !VP_CanPlayBattleChatter( player ) )
		return

	if ( player.GetHealth() <= damageInfo.GetDamage() )
		return

	EmitSoundOnEntity( player, SOLDIER_SOUND_PAIN )
}

function VP_PlayEnemyEngagedVoicelines( player, damageInfo )
{
	local attackInfo = VP_GetAttackInfo( damageInfo )
	local attacker = attackInfo.attacker
	if ( !attacker )
		return

	if ( !attacker.IsPlayer() || attacker.IsTitan() )
		return

	if ( player.GetHealth() <= damageInfo.GetDamage() )
		return

	if ( !VP_CanPlayBattleChatter( attacker ) )
		return

	VP_PlayBattleChatterLine( attacker, "engage_pilot", true )
}

function VP_OnWeaponAttack( player, weapon, weaponName, shotsFired )
{
	if ( !player )
		return

	if ( !IsAlive( player ) || player.IsTitan() )
		return

	if ( !VP_CanPlayBattleChatter( player ) )
		return

	if ( weaponName != "mp_weapon_frag_grenade" && weaponName != "mp_weapon_grenade_emp" )
		return

	VP_PlayBattleChatterLine( player, "grenade_out", true )
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function VP_PlayBattleChatterLine_Delayed( player, sound, delay = 0, useNewSystem = false )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "Disconnected" )

	wait delay

	VP_PlayBattleChatterLine( player, sound, useNewSystem )
}

const VP_PRINT = 1
function VP_PlayBattleChatterLine( player, eventType, useNewSystem = false )
{
	if ( useNewSystem )
	{
		if ( events[eventType].alwaysAnnounce == false && !GamePlayingOrSuddenDeath() ) //events marked as alwaysAnnounce == true skip these checks.
			return
	}

	thread VP_PlayBattleChatterLine_Internal( player, eventType, useNewSystem )
}

function VP_PlayBattleChatterLine_Internal( player, eventType, useNewSystem )
{
	if ( useNewSystem )
	{
		if ( player.s.VP_BattleChatterLineActive && events[eventType].priority <= events[player.s.VP_BattleChatterLineActive].priority )
		{
			//printt( "Returning from VP_PlayBattleChatterLine_Internal because another higher priority dialog is taking place" )
			return
		}

		if ( Time() - player.s.VP_LastBattleChatterTime <= events[eventType].debounce )
		{
			/*local timeSince = Time() - player.s.VP_LastBattleChatterTime
			printt( "Returning from VP_PlayBattleChatterLine_Internal because debounce time for event" + eventType + " has not reached yet" )
			printt( "Debounce: " + events[eventType].debounce + ", Time since last dialogue: " + timeSince )*/
			return
		}

		//player.Signal( "TitanCockpit_PlayDialogInternal" )
		//player.EndSignal( "TitanCockpit_PlayDialogInternal" )
		player.EndSignal( "OnDestroy" )
		player.EndSignal( "OnDeath" )

		player.s.VP_BattleChatterLineAliasList.append( events[eventType].voiceline )

		player.s.VP_LastBattleChatterTime = Time()
		player.s.VP_BattleChatterLineActive = eventType

		OnThreadEnd(
			function() : ( player )
			{
				//if ( !IsConnected() ) //Temp fix for SRE on disconnecting, real fix is to get a code variable instead of using persistent variable
				//	return

				//foreach ( dialogType, dialogInfo in player.s.VP_BattleChatterLineAliasList )
				//{
				//	local soundAlias = GenerateBattleChatterAlias( player, dialogInfo )
				//	StopSoundOnEntity( player, soundAlias )
				//}

				player.s.VP_BattleChatterLineAliasList = []
				player.s.VP_BattleChatterLineActive = null
			}
		)

		foreach ( dialogType, dialogInfo in player.s.VP_BattleChatterLineAliasList )
		{
			//printt( "dialogType: " + dialogType + ", dialogInfo: ",  PrintTable( dialogInfo ) )

			local soundAlias = GenerateBattleChatterAlias( player, eventType, dialogInfo )

			//wait EmitSoundOnEntity( player, soundAlias )
			if ( events[eventType].teamOnly )
				EmitSoundOnEntityToTeam( player, soundAlias, player.GetTeam() )
			else
				EmitSoundOnEntity( player, soundAlias )

			if ( VP_PRINT )
			{
				printt( "-------------------------------------------------" )
				printt( "VOCAL PILOTS: Playing voiceline [" + soundAlias + "] for player [" + player.GetPlayerName() + "]" )
				printt( "-------------------------------------------------" )
			}
		}
	}
	else
	{
		EmitSoundOnEntity( player, eventType )
		if ( VP_PRINT )
		{
			printt( "-------------------------------------------------" )
			printt( "VOCAL PILOTS: Playing voiceline [" + eventType + "] for player [" + player.GetPlayerName() + "]" )
			printt( "-------------------------------------------------" )
		}
	}

	//PlaySquadConversationToAll( "aichat_reload", player, true )
}

function VP_GetAttackInfo( damageInfo )
{
	local attacker = damageInfo.GetAttacker()
	local inflictor = damageInfo.GetInflictor()

	local time = Time()

	local weapon = _GetWeaponNameFromDamageInfo( damageInfo )
	local damageSourceId = damageInfo.GetDamageSourceIdentifier()
	local scriptType = damageInfo.GetCustomDamageType()

	return { attacker = attacker, inflictor = inflictor, time = time, weapon = weapon, damageSourceId = damageSourceId, scriptType = scriptType }
}

function VP_GetPlayerInfo( player )
{
	local team = player.GetTeam()
	local teamString

	if ( team == TEAM_MILITIA )
		teamString = "mcor"
	else
		teamString = "imc"

	local footstepType = player.GetPlayerSettingsField( "footstep_type" )
	local voiceIndex = player.s.VP_GruntVoiceIndex

	return { team = team, teamString = teamString, footstepType = footstepType, voiceIndex = voiceIndex }
}

function GenerateBattleChatterAlias( player, eventType, dialogInfo )
{
	local playerInfo = VP_GetPlayerInfo( player )

	local lineNumber = RandomInt( 1, dialogInfo.maxLines )

	if ( events[eventType].noVoiceIndex == true )
		playerInfo.voiceIndex = ""

	if ( events[eventType].noTeamCheck == true )
		playerInfo.teamString = ""

	if ( events[eventType].noRandomLines == true )
		lineNumber = ""

	local modifiedAlias
	if ( eventType == "kill_pilot" || eventType == "engage_pilot" )
		modifiedAlias = ( format( dialogInfo.prefix, playerInfo.teamString, playerInfo.voiceIndex, ( lineNumber >= 10 ? "" : "0" ) + lineNumber.tostring() ) )
	else
		modifiedAlias = ( format( dialogInfo.prefix, playerInfo.teamString, playerInfo.voiceIndex, lineNumber.tostring() ) )

	return modifiedAlias
}

function VP_CanPlayBattleChatter( entity, spectreCheck = true, femaleCheck = true, cloakCheck = true )
{
	if ( IsTrainingLevel() )
		return false

	if ( entity.IsTitan() )
		return false

	if ( spectreCheck )
	{
		if ( entity.IsSpectre() )
			return false

		if ( entity.IsPlayer() && entity.GetPlayerSettingsField( "footstep_type" ) == "robot" )
			return false
	}

	// No female grunts = no voicelines to use... sad
	if ( femaleCheck && entity.IsPlayer() && IsFemalePilotModel( entity ) )
		return false

	if ( cloakCheck && IsCloaked( entity ) )
		return false

	return true
}

function IsFemalePilotModel( player )
{
	local femaleModels = [ MILITIA_FEMALE_BR, MILITIA_FEMALE_CQ, MILITIA_FEMALE_DM, SARAH_MODEL ]
	if ( player.GetModelName() in femaleModels )
		return true

	return false
}

function TEMPAddCallback_OnWeaponAttack( callbackFunc )
{
    Assert( "onWeaponAttackCallbacks" in level )
	Assert( type( this ) == "table", "AddCallback_OnWeaponAttack can only be added on a table. " + type( this ) )

	local name = FunctionToString( callbackFunc )
    Assert( !( name in level.onWeaponAttackCallbacks ), "Already added " + name + " with AddCallback_OnPlayerRespawned" )

	local callbackInfo = {}
	callbackInfo.name <- name
	callbackInfo.func <- callbackFunc
	callbackInfo.scope <- this

	level.onWeaponAttackCallbacks[name] <- callbackInfo
}

main()