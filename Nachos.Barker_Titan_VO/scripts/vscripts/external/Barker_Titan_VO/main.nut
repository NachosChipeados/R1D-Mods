function main()
{
	// Disable this if you want them to play on all maps
//	if ( GetMapName() != "mp_airbase" )
//		return

	local convRef

	if ( !GetCinematicMode() && GAMETYPE != COOPERATIVE )
	{
		convRef = ReplaceConversation( "FirstTitanETA120s", TEAM_MILITIA )
		AddVDURadio( convRef, "barker", "diag_replacement_eta_AB125_01_01_mcor_barker" )

		convRef = ReplaceConversation( "FirstTitanETA60s", TEAM_MILITIA )
		AddVDURadio( convRef, "barker", "diag_replacement_eta_AB126_01_01_mcor_barker" )

		convRef = ReplaceConversation( "FirstTitanETA30s", TEAM_MILITIA )
		AddVDURadio( convRef, "barker", "diag_replacement_eta_AB127_01_01_mcor_barker" )

		convRef = ReplaceConversation( "FirstTitanETA15s", TEAM_MILITIA )
		AddVDURadio( convRef, "barker", "diag_replacement_eta_AB128_01_01_mcor_barker" )

		convRef = ReplaceConversation( "FirstTitanReady", TEAM_MILITIA )
		AddVDURadio( convRef, "barker", "diag_titanReady_AB129_01_01_mcor_barker" )

		convRef = AddConversation( "FirstTitanReady", TEAM_MILITIA )
		AddVDURadio( convRef, "barker", "diag_titanReady_AB130_01_01_mcor_barker" )

		convRef = ReplaceConversation( "FirstTitanInbound", TEAM_MILITIA )
		AddVDURadio( convRef, "barker", "diag_titanFall_AB131_01_01_mcor_barker" )

		convRef = AddConversation( "FirstTitanInbound", TEAM_MILITIA )
		AddVDURadio( convRef, "barker", "diag_titanFall_AB132_01_01_mcor_barker" )

		convRef = ReplaceConversation( "TitanReplacementReady", TEAM_MILITIA )
		AddVDURadio( convRef, "barker", "diag_titanReady_AB133_01_01_mcor_barker" )

		convRef = AddConversation( "TitanReplacementReady", TEAM_MILITIA )
		AddVDURadio( convRef, "barker", "diag_titanReady_AB134_01_01_mcor_barker" )

		convRef = ReplaceConversation( "TitanReplacementETA120s", TEAM_MILITIA )
		AddVDURadio( convRef, "barker", "diag_replacement_eta_AB125_01_01_mcor_barker" )

		convRef = ReplaceConversation( "TitanReplacementETA60s", TEAM_MILITIA )
		AddVDURadio( convRef, "barker", "diag_replacement_eta_AB126_01_01_mcor_barker" )

		convRef = ReplaceConversation( "TitanReplacementETA30s", TEAM_MILITIA )
		AddVDURadio( convRef, "barker", "diag_replacement_eta_AB127_01_01_mcor_barker" )

		convRef = ReplaceConversation( "TitanReplacementETA15s", TEAM_MILITIA )
		AddVDURadio( convRef, "barker", "diag_replacement_eta_AB128_01_01_mcor_barker" )

		convRef = ReplaceConversation( "TitanReplacement", TEAM_MILITIA )
		AddVDURadio( convRef, "barker", "diag_titanFall_AB131_01_01_mcor_barker" )

		convRef = AddConversation( "TitanReplacement", TEAM_MILITIA )
		AddVDURadio( convRef, "barker", "diag_titanFall_AB132_01_01_mcor_barker" )

		convRef = ReplaceConversation( "AutoTitanDestroyed", TEAM_MILITIA )
		AddVDURadio( convRef, "barker", "diag_titanDestro_AB135_01_01_mcor_barker" )

		convRef = AddConversation( "AutoTitanDestroyed", TEAM_MILITIA )
		AddVDURadio( convRef, "barker", "diag_titanDestro_AB136_01_01_mcor_barker" )

		convRef = AddConversation( "AutoTitanDestroyed", TEAM_MILITIA )
		AddVDURadio( convRef, "barker", "diag_titanDestro_AB137_01_01_mcor_barker" )
	}
}

main()