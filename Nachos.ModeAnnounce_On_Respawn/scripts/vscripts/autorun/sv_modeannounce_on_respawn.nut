function main()
{
	if ( IsLobby() )
		return

	AddCallback_OnPlayerRespawned( PlayerRespawned )
}

function PlayerRespawned( player )
{
	thread TryGameModeAnnouncement( player )
}

main()