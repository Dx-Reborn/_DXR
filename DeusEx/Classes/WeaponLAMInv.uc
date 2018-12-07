//=============================================================================
// WeaponLAM.
//=============================================================================
class WeaponLAMInv extends GrenadeWeaponInv;

var localized String shortName;

function Fire(float Value)
{
	// if facing a wall, affix the LAM to the wall
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
		 PickupClass=class'WeaponLAM'
     PickupViewMesh=VertMesh'DXRPickups.LAMPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.LAM'
     Mesh=VertMesh'DXRPickups.LAMPickup'

     ShortName="LAM"
     largeIcon=Texture'DeusExUI.Icons.LargeIconLAM'
     largeIconWidth=35
     largeIconHeight=45
     Description="A multi-functional explosive with electronic priming system that can either be thrown or attached to any surface with its polyhesive backing and used as a proximity mine.|n|n<UNATCO OPS FILE NOTE SC093-BLUE> Disarming a proximity device should only be attempted with the proper demolitions training. Trust me on this. -- Sam Carter <END NOTE>"
     beltDescription="LAM"
     LowAmmoWaterMark=2
     GoverningSkill=Class'DeusEx.SkillDemolition'
     EnviroEffective=ENVEFF_AirWater
     Concealability=CONC_All
     ShotTime=0.300000
     ReloadTime=0.100000
     HitDamage=50
     MaxRange=4800
     AccurateRange=2400
     BaseAccuracy=1.000000
     bHasMuzzleFlash=False
     bHandToHand=True
     bUseAsDrawnWeapon=False
     AITimeLimit=3.500000
     AIFireDelay=5.000000
     AmmoName=Class'DeusEx.AmmoLAMInv'
     ReloadCount=1
     PickupAmmoCount=1
     FireOffset=(Y=10.000000,Z=20.000000)
     ProjectileClass=Class'DeusEx.LAM'

     SelectSound=Sound'DeusExSounds.Weapons.LAMSelect'
     LandSound=Sound'DeusExSounds.Generic.DropLargeWeapon'

     InventoryGroup=20
     ItemName="Lightweight Attack Munitions (LAM)"
     PlayerViewOffset=(X=24.000000,Y=21.000000,Z=-20.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconLAM'
     CollisionRadius=3.800000
     CollisionHeight=3.500000
     Mass=5.000000
     Buoyancy=2.000000
}
