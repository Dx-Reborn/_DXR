//=============================================================================
// WeaponAssaultGun.
//=============================================================================
class WeaponAssaultGunInv extends DeusExWeaponInv;

defaultproperties
{
		 PickupClass=class'WeaponAssaultGun'
     PickupViewMesh=VertMesh'DXRPickups.AssaultGunPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.AssaultGun'
     Mesh=VertMesh'DXRPickups.AssaultGunPickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconAssaultGun'
     largeIconWidth=94
     largeIconHeight=65
     invSlotsX=2
     invSlotsY=2
     Description="The 7.62x51mm assault rifle is designed for close-quarters combat, utilizing a shortened barrel and 'bullpup' design for increased maneuverability. An additional underhand 20mm HE launcher increases the rifle's effectiveness against a variety of targets."
     beltDescription="ASSAULT"
     LowAmmoWaterMark=30
     GoverningSkill=Class'DeusEx.SkillWeaponRifle'
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_Visual
     bAutomatic=True
     ShotTime=0.100000
     ReloadTime=3.000000
     HitDamage=3
     BaseAccuracy=0.700000
     bCanHaveLaser=True
     bCanHaveSilencer=True
     AmmoNames(0)=Class'DeusEx.Ammo762mmInv'
     AmmoNames(1)=Class'DeusEx.Ammo20mmInv'
     ProjectileNames(1)=Class'DeusEx.HECannister20mm'
     recoilStrength=0.500000
     MinWeaponAcc=0.200000
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     AmmoName=Class'DeusEx.Ammo762mmInv'
     ReloadCount=30
     PickupAmmoCount=30
     bInstantHit=True
     FireOffset=(X=-16.000000,Y=5.000000,Z=11.500000)

     FireSound=Sound'DeusExSounds.Weapons.AssaultGunFire'
     ReloadEndSound=Sound'DeusExSounds.Weapons.AssaultGunReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.AssaultGunReload'
     SelectSound=Sound'DeusExSounds.Weapons.AssaultGunSelect'
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'

     InventoryGroup=4
     ItemName="Assault Rifle"
//     PlayerViewOffset=(X=16.000000,Y=-5.000000,Z=-11.500000)
     PlayerViewOffset=(X=9.000000,Y=9.000000,Z=-11.500000)

     Icon=Texture'DeusExUI.Icons.BeltIconAssaultGun'
     CollisionRadius=15.000000
     CollisionHeight=1.100000
     Mass=30.000000
}
