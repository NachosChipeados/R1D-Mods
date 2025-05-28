
// https://github.com/R2Northstar/NorthstarMods/blob/main/Northstar.Custom/mod/scripts/vscripts/sh_custom_pilot_collision.gnut

function main()
{
	AddCallback_OnPlayerRespawned( SetPilotCollisionFlagsForRespawn )
	AddCallback_OnPilotBecomesTitan( PilotCollisionOnPilotBecomesTitan )
	AddCallback_OnTitanBecomesPilot( PilotCollisionOnTitanBecomesPilot )
}

function SetPilotCollisionFlagsForRespawn( player )
{
	player.kv.CollisionGroup = TRACE_COLLISION_GROUP_BLOCK_WEAPONS
}

function PilotCollisionOnPilotBecomesTitan( player, titan )
{
	player.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
}

function PilotCollisionOnTitanBecomesPilot( player, titan )
{
	player.kv.CollisionGroup = TRACE_COLLISION_GROUP_BLOCK_WEAPONS
}

main()