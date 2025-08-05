
function main()
{
	AddCallback_OnClientScriptInit( ClientInit_IngameServerBrowser )
}

function ClientInit_IngameServerBrowser( player )
{
	player.ClientCommand( "script_ui AddEventHandlerToButtonClass( GetMenu( \"InGameMenu\" ), \"ServerBrowserButtonClass\", UIE_CLICK, AdvanceMenuEventHandler( GetMenu( \"ServerBrowserMenu\" ) ) )" )
}

main()
