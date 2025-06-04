
const RAVEN_MDL = "models/fortnite/raven_team_leader.mdl"

function main()
{
	PrecacheModel( RAVEN_MDL )

	if ( IsTrainingLevel() )
	{
		local raven = CreatePropDynamic( RAVEN_MDL, Vector( -13568, -6571, 45 ), Vector( 0, -210, 0 ), 0, 500 )
		raven.SetName( "Raven_Team_Leader" )
	}
}

main()