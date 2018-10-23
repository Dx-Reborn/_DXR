//=============================================================================
// WeaponPlasmaRifle.
//=============================================================================
class WeaponPlasmaRifleInv extends DeusExWeaponInv;

defaultproperties
{
		 PickupClass=class'WeaponPlasmaRifle'
     PickupViewMesh=VertMesh'DXRPickups.PlasmaRiflePickup'
     FirstPersonViewMesh=Mesh'DeusExItems.PlasmaRifle'
     Mesh=VertMesh'DXRPickups.PlasmaRiflePickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconPlasmaRifle'
     largeIconWidth=203
     largeIconHeight=66
     invSlotsX=4
     invSlotsY=2
     Description="An experimental weapon that is currently being produced as a series of one-off prototypes, the plasma gun superheats slugs of magnetically-doped plastic and accelerates the resulting gas-liquid mix using an array of linear magnets. The resulting plasma stream is deadly when used against slow-moving targets."
     beltDescription="PLASMA"
     LowAmmoWaterMark=12
     GoverningSkill=Class'DeusEx.SkillWeaponHeavy'
     EnviroEffective=ENVEFF_AirVacuum
     ReloadTime=2.000000
     HitDamage=35
     MaxRange=24000
     AccurateRange=14400
     BaseAccuracy=0.600000
     bCanHaveScope=True
     ScopeFOV=20
     bCanHaveLaser=True
     AreaOfEffect=AOE_Cone
     bPenetrating=False
     recoilStrength=0.300000
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     AmmoName=Class'DeusEx.AmmoPlasmaInv'
     ReloadCount=12
     PickupAmmoCount=12

     ProjectileClass=Class'DeusEx.PlasmaBolt'
     FireSound=Sound'DeusExSounds.Weapons.PlasmaRifleFire'
     ReloadEndSound=Sound'DeusExSounds.Weapons.PlasmaRifleReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.PlasmaRifleReload'
     SelectSound=Sound'DeusExSounds.Weapons.PlasmaRifleSelect'
     LandSound=Sound'DeusExSounds.Generic.DropLargeWeapon'

     InventoryGroup=8
     ItemName="Plasma Rifle"
     PlayerViewOffset=(X=17.000000,Y=12.000000,Z=-10.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconPlasmaRifle'
     CollisionRadius=15.600000
     CollisionHeight=5.200000
     Mass=50.000000
}
