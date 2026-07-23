function main()
{
	AddCallback_GameStateEnter( eGameState.Playing, WallrunOnehanded_Playing )
}

function WallrunOnehanded_Playing()
{
	thread WallrunOnehanded_Think()
}

function WallrunOnehanded_Think()
{
	for( ;; )
	{
		foreach( player in GetLivingPlayers() )
		{
			if ( player.IsBot() )
				continue

			if ( player.IsWallRunning() ) //|| ( player.IsOnGround() && player.IsCrouched() && player.GetVelocity().Length() >= 300 ) )
			{
				player.SetOneHandedWeaponUsageOn()
			}
			else
			{
				// GetTitanSoulBeingRodeoed() means "is this player rodeoing someone?"
				if ( !player.IsWallHanging() && !player.IsZiplining() && player.GetTitanSoulBeingRodeoed() == null )
				{
					player.SetOneHandedWeaponUsageOff()
				}
			}
		}

		wait 0
	}
}

main()