function main()
{
    AddCallback_OnClientScriptInit( VMTeaks_ClientScriptInit )
    AddCallback_OnWeaponClientEvent( VMTeaks_ClientEvent )
}

function VMTeaks_ClientScriptInit( player )
{
    PrecacheParticleSystem( "weapon_muzzle_smoke" )

	foreach( className in VMTeaks_GetAllWeaponClassnames( false ) )
	{
		// Remove mp_weapon_ from the classname
		local weaponName = VMTeaks_GetWeaponName( className )

		PrecacheParticleSystem( "wpn_mageject_" + weaponName )
		PrecacheParticleSystem( "wpn_mageject_" + weaponName + "_FP" )
		PrecacheParticleSystem( "wpn_mageject_" + weaponName + "_fallback" )
		PrecacheParticleSystem( "wpn_mageject_" + weaponName + "_resting" )

		PrecacheParticleSystem( "wpn_mageject_" + weaponName + "_02" )
		PrecacheParticleSystem( "wpn_mageject_" + weaponName + "_02_FP" )
		PrecacheParticleSystem( "wpn_mageject_" + weaponName + "_02_fallback" )
		PrecacheParticleSystem( "wpn_mageject_" + weaponName + "_02_resting" )
	}
}

function VMTeaks_GetAllWeaponClassnames( grenades )
{
	local weapons = []
	local numWeapons = PersistenceGetEnumCount( "loadoutItems" )

	local className
	for ( local i = 0 ; i < numWeapons ; i++ )
	{
		className = PersistenceGetEnumItemNameForIndex( "loadoutItems", i )
		if ( className == "NULL" )
			continue 

		if ( GetWeaponInfoFileKeyField_Global( className, "anim_prefix" ) == "Grenade" && !grenades )
			continue

		if ( StringContains( className, "ability" ) )
			continue

		className = RemapWeaponClassname( className )

		weapons.append( className )
	}

	return weapons
}

function RemapWeaponClassname( className )
{
	// Frontier overhaul and frontier defense 2 use different names for them
	switch( className )
	{
		case "mp_weapon_alternator_smg":
			className = "mp_weapon_alternator"
			break

		case "mp_weapon_energy_ar":
			className = "mp_weapon_havoc"
			break

		case "mp_weapon_esaw":
			className = "mp_weapon_devotion"
			break

		case "mp_weapon_dragon_lmg":
			className = "mp_weapon_rampage"
			break

		case "mp_weapon_hemlok_smg":
			className = "mp_weapon_volt"
			break

		case "mp_weapon_meteor":
			className = "mp_weapon_thermite_launcher"
			break

		case "mp_weapon_pdw":
			className = "mp_weapon_prowler"
			break

		case "mp_weapon_pulse_lmg":
		case "mp_weapon_coldwar":
			className = "mp_weapon_cold_war"
			break

		case "mp_weapon_shotgun_pistol":
			className = "mp_weapon_mozambique"
			break

		case "mp_weapon_vinson":
			className = "mp_weapon_flatline"
			break

		case "mp_weapon_wingman_n":
			className = "mp_weapon_wingman_elite"
			break
	}

	return className
}

function VMTeaks_GetWeaponName( className )
{
	local titanWeapon = StringContains( className, "mp_titan" )

	local startIndex = titanWeapon ? 15 : 10
	local weaponName = className.slice( startIndex, className.len() )

	if ( titanWeapon )
	{
		// Hack
		if ( weaponName == "sniper" || weaponName == "shotgun" || weaponName == "rocket_launcher" )
			weaponName = "titan_" + weaponName
	}

	return weaponName
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

function VMTeaks_ClientEvent( weapon, eventName )
{
	if ( eventName == "ammo_update_reload" )
		UpdateViewmodelAmmoForReload( weapon )

	if ( eventName == "mag_eject" && GetConVarBool( "autocvar_vmteaks_drop_magazine" ) )
		thread PlayMagazineEject( weapon, false )

	if ( eventName == "mag_eject2" && GetConVarBool( "autocvar_vmteaks_drop_magazine" ) )
		thread PlayMagazineEject( weapon, true )

	if ( eventName = "muzzle_flash" && GetConVarBool( "autocvar_vmteaks_smoketrail" ) )
		PlayMuzzleSmoke( weapon )
}

function UpdateViewmodelAmmoForReload( weapon )
{
	if ( !IsValid( weapon ) )
		return

	local owner = weapon.GetWeaponOwner()
	if ( !IsLocalViewPlayer( owner ) )
		return

	local rounds = weapon.GetWeaponPrimaryClipCount()
	local maxAmmo = owner.GetWeaponAmmoMaxLoaded( weapon )
	local ammoStockpile = owner.GetWeaponAmmoStockpile( weapon )

	local scope = weapon.GetScriptScope()

	if ( ammoStockpile > scope.AMMO_BODYGROUP_COUNT )
		ammoStockpile = scope.AMMO_BODYGROUP_COUNT

	if ( ammoStockpile < rounds )
		ammoStockpile = rounds

	//printt( "Updating for rounds: " + ammoStockpile );
	weapon.SetViewmodelAmmoModelIndex( ammoStockpile )
}

if ( !( "IsBodyGroupSet" in getroottable() ) )
{
	function IsBodyGroupSet( ent, bodygroup )
	{
		local index = ent.FindBodyGroup( bodygroup )
		if ( index == -1 )
			return false

		return ent.GetBodyGroupState( index ) == 1
	}
}

function PlayMuzzleSmoke( weapon )
{
	local owner = weapon.GetWeaponOwner()
	if ( !IsValid( owner ) || owner != GetLocalViewPlayer() )
		return

	local viewmodel = owner.GetViewModelEntity()
	if ( !IsValid( viewmodel ) )
		return

	local effectIndex = GetParticleSystemIndex( "weapon_muzzle_smoke" )
	if ( effectIndex == -1 )
		return

	local attachment = "muzzle_flash"
	if ( IsBodyGroupSet( weapon, "suppressor_cyl_sm" ) || IsBodyGroupSet( weapon, "suppressor_cyl_med" ) || IsBodyGroupSet( weapon, "suppressor_cyl_lg" ) )
		attachment = "suppressor_cyl"
	else if ( IsBodyGroupSet( weapon, "suppressor_sq_sm" ) || IsBodyGroupSet( weapon, "suppressor_sq_med" ) || IsBodyGroupSet( weapon, "suppressor_sq_lg" ) )
		attachment = "suppressor_sq"

	local attachmentIndex = viewmodel.LookupAttachment( attachment )
	if ( attachmentIndex <= 0 )
		return

	if ( !( "gunHeat" in weapon.s ) )
	{
		weapon.s.gunHeat <- 0
		weapon.s.lastSmokeTime <- 0
		weapon.s.pendingSmokes <- 0
	}

	local cooldownTime = 2.0
	local minTimeBetweenSmokes = 4.0

	local currentShotTime = Time()
	local timeSinceLastShot = currentShotTime - weapon.GetPreviousAttackTime()

	// Drain off any heat from prior shots
	weapon.s.gunHeat -= timeSinceLastShot * ( 1.0 / cooldownTime )
	if ( weapon.s.gunHeat <= 0.0 )
	{
		weapon.s.gunHeat = 0.0;
	}

	local addHeat = 0.3

	// Add the new heat to the gun
	weapon.s.gunHeat += addHeat;
	if ( weapon.s.gunHeat > 1.0 )
	{
		// Reset the heat so we have to build up to it again
		weapon.s.gunHeat = 0.0;
		//m_smokeAttachments |= ( 0x1 << iAttachmentIndex );
		weapon.s.pendingSmokes++
	}

	// We don't want to hammer the smoke effect too much, so prevent smoke from spawning too soon after the last smoke
	if ( weapon.s.pendingSmokes > 0 && currentShotTime - weapon.s.lastSmokeTime > minTimeBetweenSmokes )
	{
		for ( local i = 0; i < 16 && weapon.s.pendingSmokes > 0; i++ )
		{
			StartParticleEffectOnEntity( viewmodel, effectIndex, FX_PATTACH_POINT_FOLLOW, attachmentIndex )
			weapon.s.lastSmokeTime = currentShotTime
			weapon.s.pendingSmokes--
		}

		weapon.s.pendingSmokes = 0
	}
}

function PlayMagazineEject( weapon, secondMag )
{
	local owner = weapon.GetWeaponOwner()
	if ( !IsValid( owner ) || owner != GetLocalViewPlayer() )
		return

	local viewmodel = owner.GetViewModelEntity()
	if ( !IsValid( viewmodel ) )
		return

	local className = RemapWeaponClassname( weapon.GetClassname() )

	local test = false
	if ( test )
	{
		local allClassnames = VMTeaks_GetAllWeaponClassnames( false )
		className = allClassnames[RandomInt( 0, allClassnames.len() ) ]
	}

	local weaponName = VMTeaks_GetWeaponName( className )
	//printt( "className", className )

	local effectIndex
	if ( secondMag )
		effectIndex = GetParticleSystemIndex( "wpn_mageject_" + weaponName + "_02_FP" )
	else
		effectIndex = GetParticleSystemIndex( "wpn_mageject_" + weaponName + "_FP" )

	if ( effectIndex == -1 )
		return

	local attachmentIndex = secondMag ? viewmodel.LookupAttachment( "mag_eject02" ) : viewmodel.LookupAttachment( "mag_eject" )
	if ( attachmentIndex <= 0 )
		attachmentIndex = viewmodel.LookupAttachment( "L_HAND" )
	if ( attachmentIndex <= 0 )
		attachmentIndex = viewmodel.LookupAttachment( "muzzle_flash" )

	if ( attachmentIndex <= 0 )
		return

	StartParticleEffectOnEntity( viewmodel, effectIndex, FX_PATTACH_POINT_FOLLOW, attachmentIndex )
	local soundOrigin = owner.GetOrigin()

	wait 0.25
	EmitSoundAtPosition( soundOrigin, "weapon.impacthard" )
}

main()
