//=============================================================================
// WeaponGasGrenade.
//=============================================================================
class WeaponGasGrenadeInv extends GrenadeWeaponInv;

function Fire(float Value)
{
	// if facing a wall, affix the GasGrenade to the wall
	if (Pawn(Owner) != None)
	{
		if (bNearWall)
		{
			AmmoType.UseAmmo(1);
			bReadyToFire = False;
			GotoState('NormalFire');
			bPointing = True;
			PlayAnim('Place',, 0.1);
			return;
		}
	}

	// otherwise, throw as usual
	Super.Fire(Value);
}

defaultproperties
{
		 PickupClass=class'WeaponGasGrenade'
     PickupViewMesh=VertMesh'DXRPickups.GasGrenadePickup'
     FirstPersonViewMesh=Mesh'DeusExItems.GasGrenade'
     Mesh=VertMesh'DXRPickups.GasGrenadePickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconGasGrenade'
     largeIconWidth=23
     largeIconHeight=46
     Description="Upon detonation, the gas grenade releases a large amount of CS (a military-grade 'tear gas' agent) over its area of effect. CS will cause irritation to all exposed mucous membranes leading to temporary blindness and uncontrolled coughing. Like a LAM, gas grenades can be attached to any surface."
     beltDescription="GAS GREN"
     LowAmmoWaterMark=2
     GoverningSkill=Class'DeusEx.SkillDemolition'
     EnemyEffective=ENMEFF_Organic
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_All
     ShotTime=0.300000
     ReloadTime=0.100000
     HitDamage=0
     MaxRange=4800
     AccurateRange=2400
     BaseAccuracy=1.000000
     bPenetrating=False
     StunDuration=60.000000
     bHasMuzzleFlash=False
     bHandToHand=True
     bUseAsDrawnWeapon=False
     AITimeLimit=4.000000
     AIFireDelay=20.000000
     AmmoName=Class'DeusEx.AmmoGasGrenadeInv'
     ReloadCount=1
     PickupAmmoCount=1
     FireOffset=(Y=10.000000,Z=20.000000)
     ProjectileClass=Class'DeusEx.GasGrenade'
     SelectSound=Sound'DeusExSounds.Weapons.GasGrenadeSelect'
     InventoryGroup=21
     ItemName="Gas Grenade"
     PlayerViewOffset=(X=30.000000,Y=19.000000,Z=-23.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconGasGrenade'
     CollisionRadius=2.300000
     CollisionHeight=3.300000
     Mass=5.000000
     Buoyancy=2.000000
}
