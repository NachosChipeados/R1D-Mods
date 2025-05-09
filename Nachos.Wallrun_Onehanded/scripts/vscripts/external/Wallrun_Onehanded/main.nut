function main()
{
	AddCallback_OnPlayerRespawned( Wallrun_Onehanded )

}

function Wallrun_Onehanded( player )
{
	thread Wallrun_Onehanded_Think( player )
}

function Wallrun_Onehanded_Think( player )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "Disconnected" )

	while ( true )
	{
		if ( player.IsWallRunning() )
		{
			player.SetOneHandedWeaponUsageOn()
		}
		else
		{
			// GetTitanSoulBeingRodeoed() means "is this player rodeoing someone?"
			while ( player.IsWallHanging() || player.IsZiplining() || player.GetTitanSoulBeingRodeoed() != null )
			{
				wait 0
			}

			player.SetOneHandedWeaponUsageOff()
		}

		wait 0
	}
}

main()