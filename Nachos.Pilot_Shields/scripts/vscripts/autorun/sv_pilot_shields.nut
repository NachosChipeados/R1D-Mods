
function main()
{
	AddCallback_OnPlayerRespawned( PlayerShield_OnPlayerRespawned )
	AddCallback_OnPilotBecomesTitan( PlayerShield_OnPilotBecomesTitan )
	AddCallback_OnTitanBecomesPilot( PlayerShield_OnTitanBecomesPilot )

	AddDamageCallback( "player", PlayerShield_TookDamage )
}

function PlayerShield_OnPlayerRespawned( player )
{
	if ( !( "pilotShieldSoul" in player.s ) )
		player.s.pilotShieldSoul <- null

	if ( !player.IsTitan() )
	{
		PlayerShield_CreateShieldSoul( player )
	}
}

function PlayerShield_OnPilotBecomesTitan( player, titan )
{
	if ( ( "pilotShieldSoul" in player.s ) && player.s.pilotShieldSoul )
	player.s.pilotShieldSoul.Kill()
}

function PlayerShield_OnTitanBecomesPilot( player, titan )
{
	PlayerShield_CreateShieldSoul( player )
}

function PlayerShield_CreateShieldSoul( player )
{
	local shieldSoul = CreateEntity( "titan_soul" )
	DispatchSpawn( shieldSoul )
	player.SetTitanSoul( shieldSoul )
	shieldSoul.SetTitan( player )
	shieldSoul.SetShieldHealthMax( 100 )
	shieldSoul.SetShieldHealth( 100 )
	shieldSoul.s.nextRegenTime <- 0
	thread PlayerTitanShieldRegenThink( shieldSoul, player )

	player.s.pilotShieldSoul = shieldSoul
}

function PlayerShield_TookDamage( player, damageInfo )
{
	if ( !IsAlive( player ) )
		return

	if ( player.IsTitan() )
		return

	local soul = player.s.pilotShieldSoul
	if ( !soul )
		return

	local damage = damageInfo.GetDamage()
	local damageType = damageInfo.GetCustomDamageType()

	if ( damageInfo.GetForceKill() || damageType & DF_MELEE )
	{
		soul.SetShieldHealth( 0 )
		return
	}

	soul.s.nextRegenTime = Time() + EVAC_SHIP_SHIELD_REGEN_DELAY

	ShieldModifyDamage( player, damageInfo )
}

function PlayerTitanShieldRegenThink( soul, player )
{
	soul.EndSignal( "OnDestroy" )

	local lastShieldHealth = soul.GetShieldHealth()
	local shieldHealthSound = false
	local maxShield = soul.GetShieldHealthMax()
	local lastTime = Time()
	local shieldRegenRate = maxShield / ( EVAC_SHIP_SHIELD_REGEN_TIME / SHIELD_REGEN_TICK_TIME )

	while ( true )
	{
		if ( player.IsTitan() )
			break

		local shieldHealth = soul.GetShieldHealth()

		if ( lastShieldHealth <= 0 && shieldHealth && player.IsPlayer() )
		{
		 	EmitSoundOnEntityOnlyToPlayer( player, player, "titan_energyshield_up" )
		 	shieldHealthSound = true
		}
		else if ( shieldHealthSound && shieldHealth == soul.GetShieldHealthMax() )
		{
			shieldHealthSound = false
		}
		else if ( lastShieldHealth > shieldHealth && shieldHealthSound )
		{
		 	StopSoundOnEntity( player, "titan_energyshield_up" )
		 	shieldHealthSound = false
		}

		if ( Time() >= soul.s.nextRegenTime )
		{
			local shieldHealth = soul.GetShieldHealth()
			local frameTime = max( 0.0, Time() - lastTime )
			local adjustedShieldRegenRate = shieldRegenRate * frameTime / SHIELD_REGEN_TICK_TIME

			soul.SetShieldHealth( min( soul.GetShieldHealthMax(), shieldHealth + adjustedShieldRegenRate ) )
		}

		lastShieldHealth = shieldHealth
		lastTime = Time()
		wait 0
	}
}

main()