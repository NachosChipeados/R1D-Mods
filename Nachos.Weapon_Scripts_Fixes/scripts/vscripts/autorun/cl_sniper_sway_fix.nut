
function main()
{
	if ( IsLobby() )
		return

	thread AdsSway()
}

function AdsSway()
{
	local player
	local weapon

	while( true )
	{
		WaitFrame()

		player = GetLocalViewPlayer()
		if ( !player )
		{
			SetCvarIfNotBool( player, "delta_enable_ads_sway", 1 )
			continue
		}

		weapon = player.GetActiveWeapon()
		if ( !weapon )
		{
			SetCvarIfNotBool( player, "delta_enable_ads_sway", 1 )
			continue
		}

		local className = weapon.GetClassname()
		if ( className != "mp_weapon_dmr" && className != "mp_weapon_sniper" && className != "mp_weapon_mega1" )
		{
			SetCvarIfNotBool( player, "delta_enable_ads_sway", 1 )
			continue
		}

		if ( WeaponHasMod( weapon, "aog" ) || WeaponHasMod( weapon, "iron_sights" ) )
			SetCvarIfNotBool( player, "delta_enable_ads_sway", 1 )
		else
			SetCvarIfNotBool( player, "delta_enable_ads_sway", 0 )
	}
}

function WeaponHasMod( weapon, mod )
{
	return weapon.HasModDefined( mod ) && weapon.HasMod( mod )
}

function SetCvarIfNotBool( player, command, state )
{
	if ( GetConVarInt( command ) != state )
		player.ClientCommand( command + " " + state )
}

main()