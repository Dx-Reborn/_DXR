//=============================================================================
// WeaponAssaultShotgun.
//=============================================================================
class WeaponAssaultShotgunInv extends DeusExWeaponInv;

defaultproperties
{
		 PickupClass=class'WeaponAssaultShotgun'
     PickupViewMesh=VertMesh'DXRPickups.AssaultShotgunPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.AssaultShotgun'
     Mesh=VertMesh'DXRPickups.AssaultShotgunPickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconAssaultShotgun'
     largeIconWidth=99
     largeIconHeight=55
     invSlotsX=2
     invSlotsY=2
     Description="The assault shotgun (sometimes referred to as a 'street sweeper') combines the best traits of a normal shotgun with a fully automatic feed that can clear an area of hostiles in a matter of seconds. Particularly effective in urban combat, the assault shotgun accepts either buckshot or sabot shells."
     beltDescription="SHOTGUN"
     LowAmmoWaterMark=12
     GoverningSkill=Class'DeusEx.SkillWeaponRifle'
     EnviroEffective=ENVEFF_Air
     bAutomatic=True
     ShotTime=0.700000
     ReloadTime=4.500000
     HitDamage=4
     MaxRange=2400
     AccurateRange=1200
     BaseAccuracy=0.800000
     AmmoNames(0)=Class'DeusEx.AmmoShellInv'
     AmmoNames(1)=Class'DeusEx.AmmoSabotInv'
     AreaOfEffect=AOE_Cone
     recoilStrength=0.700000
     bCanHaveModReloadCount=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     AmmoName=Class'DeusEx.AmmoShellInv'
     ReloadCount=12
     PickupAmmoCount=12
     bInstantHit=True
     FireOffset=(X=-30.000000,Y=10.000000,Z=12.000000)

     FireSound=Sound'DeusExSounds.Weapons.AssaultShotgunFire'
     ReloadEndSound=Sound'DeusExSounds.Weapons.AssaultShotgunReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.AssaultShotgunReload'
     SelectSound=Sound'DeusExSounds.Weapons.AssaultShotgunSelect'
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'

     InventoryGroup=7
     ItemName="Assault Shotgun"
     PlayerViewOffset=(X=23,Y=9.000000,Z=-12.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconAssaultShotgun'
     CollisionRadius=15.000000
     CollisionHeight=8.000000
     Mass=30.000000
}