function OnWeaponPrimaryAttack( attackParams )
{
	self.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	self.FireWeaponBullet( attackParams.pos, attackParams.dir, 1, damageTypes.Bullet )
}

function OnWeaponNpcPrimaryAttack( attackParams )
{
	self.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	self.FireWeaponBullet( attackParams.pos, attackParams.dir, 1, damageTypes.SmallArms )
}

function OnWeaponStartZoomIn()
{
	HandleWeaponSoundZoomIn( self, "Weapon.r1SMG.ADS" )
}


function OnWeaponStartZoomOut()
{
	HandleWeaponSoundZoomOut( self, "Weapon.r1SMG.ADS" )
}

function OnWeaponActivate( activateParams )
{
	if ( !( "zoomTimeIn" in self.s ) )
		self.s.zoomTimeIn <- self.GetWeaponModSetting( "zoom_time_in" )

	if ( !IsClient() )
		return

	if ( self.GetWeaponOwner() != GetLocalViewPlayer() )
		return

	//if ( self.HasMod( "sniper_assist" ) )
	if ( self.HasModDefined( "aog" ) && self.HasMod( "aog" ) )
		CreateSniperVGUI( GetLocalViewPlayer(), self )
}

function OnWeaponOwnerChanged( changeParams )
{
	if ( !IsClient() )
		return

	if ( changeParams.oldOwner == GetLocalViewPlayer() && changeParams.newOwner != GetLocalViewPlayer() && ( self.HasModDefined( "aog" ) && self.HasMod( "aog" ) ) )
		DestroySniperVGUI( self )
}

function OnWeaponDeactivate( deactivateParams )
{
	if ( !IsClient() )
		return

	if ( self.HasModDefined( "aog" ) && self.HasMod( "aog" ) )
		DestroySniperVGUI( self )
}
