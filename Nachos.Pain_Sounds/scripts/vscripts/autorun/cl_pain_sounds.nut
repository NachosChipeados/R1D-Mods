
function main()
{
	if ( IsLobby() )
		return

	thread PlayerPainSoundThread()
}

const HEALTH_PERCENT_LAYER1 = 0.85
const HEALTH_PERCENT_LAYER1_END = 0.85
const HEALTH_PERCENT_LAYER2 = 0.55
const HEALTH_PERCENT_LAYER2_END = 0.55
const HEALTH_PERCENT_LAYER3 = 0.55
const HEALTH_PERCENT_LAYER3_END = 0.59

function PlayerPainSoundThread()
{
	// Each layer has:
	//: begin threshold (health falls below XX)
	//: end threshold (health has risen back up above YY)
	//: looping sound
	//: endcap sound

	local ourPlayer = null
	local arePlayingLayer1 = false
	local arePlayingLayer2 = false
	local arePlayingLayer3 = false

	local soundLayer1Loop = ""
	local soundLayer1End = ""
	local soundLayer2Start = ""
	local soundLayer2Loop = ""
	local soundLayer3Loop = ""
	local soundLayer3End = ""

	while ( true )
	{
		local shouldPlayLayer1 = false
		local shouldPlayLayer2 = false
		local shouldPlayLayer3 = false
		local endcapsAllowed = false
		local localViewPlayer = GetLocalViewPlayer()

		if ( !IsValid( localViewPlayer ) )
		{
		}
		else if ( !IsAlive( localViewPlayer ) )
		{
		}
		else if ( (ourPlayer != null) && (ourPlayer != localViewPlayer) )
		{
		}
		else if ( localViewPlayer.IsTitan() )
		{
			endcapsAllowed = true
		}
		else
		{
			soundLayer1Loop = ""
			soundLayer1End = ""
			soundLayer2Start = ""
			soundLayer2Loop = "player_heartbeat_loop"
			soundLayer3Loop = ""
			soundLayer3End = "player_exhale"

			endcapsAllowed = true

			local health = localViewPlayer.GetHealth()
			local maxHealth = localViewPlayer.GetMaxHealth()
			local healthPercent = ((maxHealth > 0) ? (health.tofloat() / maxHealth.tofloat()) : 1.0)

			if ( !arePlayingLayer1 && (healthPercent <= HEALTH_PERCENT_LAYER1) )
				shouldPlayLayer1 = true
			else if ( arePlayingLayer1 && (healthPercent <= HEALTH_PERCENT_LAYER1_END) )
				shouldPlayLayer1 = true

			if ( !arePlayingLayer2 && (healthPercent <= HEALTH_PERCENT_LAYER2) )
				shouldPlayLayer2 = true
			else if ( arePlayingLayer2 && (healthPercent <= HEALTH_PERCENT_LAYER2_END) )
				shouldPlayLayer2 = true

			if ( !arePlayingLayer3 && (healthPercent <= HEALTH_PERCENT_LAYER3) )
				shouldPlayLayer3 = true
			else if ( arePlayingLayer3 && (healthPercent <= HEALTH_PERCENT_LAYER3_END) )
				shouldPlayLayer3 = true
		}

		if ( shouldPlayLayer1 != arePlayingLayer1 )
		{
			if ( shouldPlayLayer1 )
			{
				printt( "LAYER 1 STARTS" )
				arePlayingLayer1 = true
				Assert( (ourPlayer == null) || (ourPlayer == localViewPlayer) )
				ourPlayer = localViewPlayer

				if ( soundLayer1Loop != "" )
					EmitSoundOnEntity( ourPlayer, soundLayer1Loop )
			}
			else
			{
				printt( "LAYER 1 _stop_" )
				if ( IsValid( ourPlayer ) )
				{
					if ( soundLayer1Loop != "" )
						StopSoundOnEntity( ourPlayer, soundLayer1Loop )
					if ( endcapsAllowed && (soundLayer1End != "") )
						EmitSoundOnEntity( ourPlayer, soundLayer1End )
				}
				arePlayingLayer1 = false;
			}
		}

		if ( shouldPlayLayer2 != arePlayingLayer2 )
		{
			if ( shouldPlayLayer2 )
			{
				printt( "LAYER 2 STARTS" );
				arePlayingLayer2 = true;
				Assert( (ourPlayer == null) || (ourPlayer == localViewPlayer) )
				ourPlayer = localViewPlayer;

				if ( soundLayer2Start != "" )
					EmitSoundOnEntity( ourPlayer, soundLayer2Start )
				if ( soundLayer2Loop != "" )
					EmitSoundOnEntity( ourPlayer, soundLayer2Loop )
			}
			else
			{
				printt( "LAYER 2 _stop_" );
				if ( IsValid( ourPlayer ) )
				{
					if ( soundLayer2Start != "" )
						StopSoundOnEntity( ourPlayer, soundLayer2Start )
					if ( soundLayer2Loop != "" )
						StopSoundOnEntity( ourPlayer, soundLayer2Loop )
				}
				arePlayingLayer2 = false;
			}
		}

		if ( shouldPlayLayer3 != arePlayingLayer3 )
		{
			if ( shouldPlayLayer3 )
			{
				printt( "LAYER 3 STARTS" )
				arePlayingLayer3 = true
				Assert( (ourPlayer == null) || (ourPlayer == localViewPlayer) )
				ourPlayer = localViewPlayer

				if ( soundLayer3Loop != "" )
					EmitSoundOnEntity( ourPlayer, soundLayer3Loop )
			}
			else
			{
				printt( "LAYER 3 _stop_" )
				if ( IsValid( ourPlayer ) )
				{
					if ( soundLayer3Loop != "" )
						StopSoundOnEntity( ourPlayer, soundLayer3Loop )
					if ( endcapsAllowed && (soundLayer3End != "") )
						EmitSoundOnEntity( ourPlayer, soundLayer3End )
				}
				arePlayingLayer3 = false;
			}
		}

		if ( !arePlayingLayer1 && !arePlayingLayer2 && !arePlayingLayer3 )
			ourPlayer = null

		WaitFrame()
	}
}

main()
