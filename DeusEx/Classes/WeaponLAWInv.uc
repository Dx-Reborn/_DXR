//=============================================================================
// WeaponLAW.
//=============================================================================
class WeaponLAWInv extends DeusExWeaponInv;



defaultproperties
{
     PickupClass=class'WeaponLAW'
     PickupViewMesh=VertMesh'DXRPickups.LAWPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.LAW'
     Mesh=VertMesh'DXRPickups.LAWPickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconLAW'
     largeIconWidth=166
     largeIconHeight=47
     invSlotsX=4
     Description="The LAW provides cheap, dependable anti-armor capability in the form of an integrated one-shot rocket and delivery system, though at the expense of any laser guidance. Like other heavy weapons, the LAW can slow agents who have not trained with it extensively."
     beltDescription="LAW"
     LowAmmoWaterMark=0
     GoverningSkill=Class'DeusEx.SkillWeaponHeavy'
     NoiseLevel=2.000000
     EnviroEffective=ENVEFF_Air
     ShotTime=0.300000
     ReloadTime=0.000000
     HitDamage=100
     MaxRange=24000
     AccurateRange=14400
     BaseAccuracy=0.600000
     bHasMuzzleFlash=False
     recoilStrength=1.000000
     AmmoName=Class'DeusEx.AmmoNoneInv'
     ReloadCount=0
     FireOffset=(X=28.000000,Y=12.000000,Z=4.000000)
     ProjectileClass=Class'DeusEx.RocketLAW'

     FireSound=Sound'DeusExSounds.Weapons.LAWFire'
     SelectSound=Sound'DeusExSounds.Weapons.LAWSelect'
     LandSound=Sound'DeusExSounds.Generic.DropLargeWeapon'

     InventoryGroup=16
     ItemName="Light Anti-Tank Weapon (LAW)"
     PlayerViewOffset=(X=12.000000,Y=15.000000,Z=-12.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconLAW'
     CollisionRadius=25.000000
     CollisionHeight=6.800000
     Mass=50.000000
}
