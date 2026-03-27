
function main()
{
	if ( IsLobby() )
		return

	AddCreateCallback( "npc_grenade_frag", MineCreated )
}

function MineCreated( mine, isRecreate )
{
	if ( mine.IsClientCreated() )
		return

	local className = mine.GetWeaponClassName()
	if ( className == "mp_weapon_proximity_mine" || className == "mp_weapon_laser_mine" )
		thread EnableTrapWarningSound_Client( mine, PROXIMITY_MINE_ARMING_DELAY, "Weapon_ProximityMine_ArmedBeep" )
	else if ( className == "mp_weapon_satchel" )
		thread EnableTrapWarningSound_Client( mine, 0, "Weapon_ProximityMine_ArmedBeep" ) // "Weapon_R1_Satchel.ArmedBeep_Fixed" change after the update is out
}

// Client version of EnableTrapWarningSound
function EnableTrapWarningSound_Client( mine, delay = 0, warningSound = DEFAULT_WARNING_SFX )
{
	mine.EndSignal( "OnDestroy" )
	//mine.EndSignal( "DisableTrapWarningSound" )

	if ( delay > 0 )
		wait delay

	while ( IsValid( mine ) )
	{
		local player = GetLocalViewPlayer()
		if ( player && player.GetTeam() == mine.GetTeam() )
			EmitSoundOnEntity( mine, warningSound )

		wait 1.0
	}
}

main()