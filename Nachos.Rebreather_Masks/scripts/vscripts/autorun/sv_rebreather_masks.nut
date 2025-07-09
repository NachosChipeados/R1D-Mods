function main()
{
	if ( IsLobby() )
		return

	AddSpawnCallback( "npc_soldier", EnableRebreatherMasks )
	AddCallback_OnPlayerRespawned( EnableRebreatherMasks )
}

function EnableRebreatherMasks( entity )
{
	// Masks are already forced on in outpost
	if ( GetMapName() == "mp_outpost_207" )
		return

	// Runoff is pretty obvious
	// Sandtrap seemingly takes place in the same moon as Outpost 207
	if ( GetMapName() == "mp_runoff" || GetMapName() == "mp_sandtrap" )
	{
		SetRebreatherMaskVisible( entity, true )
		return
	}

	local maskIndex = entity.FindBodyGroup( "mask" )
	if ( maskIndex == -1 )
	{
		//printt( "maskIndex == -1, returning" )
		return
	}

	local numOfMasks = entity.GetBodyGroupModelCount( maskIndex )
	//printt( "Num of Masks: " + numOfMasks )

	local randomMaskIndex = RandomInt( 0, numOfMasks )
	//printt( "Set mask to: : " + randomMaskIndex )
	entity.SetBodygroup( maskIndex, randomMaskIndex )
}

main()