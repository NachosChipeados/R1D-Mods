
function main()
{
	if ( IsLobby() )
		return

	AddClientCommandCallback( "drawfirst", ClientCommand_DrawFirst )
	AddClientCommandCallback( "drawFirst", ClientCommand_DrawFirst )
}

function ClientCommand_DrawFirst( player, ... )
{
	if ( !IsValid( player ) || !IsAlive( player ) )
		return true

	local weapon = player.GetActiveWeapon()
	if ( !IsValid( weapon )  )
		return true

	local activity = "ACT_VM_DRAWFIRST"
	if ( !weapon.Anim_HasActivity( activity ) )
		return true

	if ( player.IsWallHanging() || player.IsZiplining() || player.GetTitanSoulBeingRodeoed() != null || ( ScriptExists( "autorun/sv_wallrun_onehanded" ) && player.IsWallRunning() ) )
	{
		if ( weapon.Anim_HasActivity( "ACT_VM_ONEHANDED_DRAWFIRST" ) )
			activity = "ACT_VM_ONEHANDED_DRAWFIRST"
	}

	player.Weapon_StartCustomActivity( activity, false )
	return true
}

main()