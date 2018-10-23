//=============================================================================
// WeaponGEPGun.
//=============================================================================
class WeaponGEPGunInv extends DeusExWeaponInv;

var localized String shortName;

defaultproperties
{
		 PickupClass=class'WeaponGEPGun'
		 AttachmentClass=class'WeaponGEPGunAtt'

     PickupViewMesh=VertMesh'DXRPickups.GEPGunPickup'
		 FirstPersonViewMesh=Mesh'DeusExItems.GEPGun'
     Mesh=VertMesh'DXRPickups.GEPGunPickup'

     ShortName="GEP Gun"
     largeIcon=Texture'DeusExUI.Icons.LargeIconGEPGun'
     largeIconWidth=203
     largeIconHeight=77
     invSlotsX=4
     invSlotsY=2
     Description="The GEP gun is a relatively recent invention in the field of armaments: a portable, shoulder-mounted launcher that can fire rockets and laser guide them to their target with pinpoint accuracy. While suitable for high-threat combat situations, it can be bulky for those agents who have not grown familiar with it."
     beltDescription="GEP GUN"
     LowAmmoWaterMark=4
     GoverningSkill=Class'DeusEx.SkillWeaponHeavy'
     NoiseLevel=2.000000
     EnviroEffective=ENVEFF_Air
     ShotTime=2.000000
     ReloadTime=2.000000
     HitDamage=300
     MaxRange=24000
     AccurateRange=14400
     bCanHaveScope=True
     bCanTrack=True
     LockTime=2.000000

     LockedSound=Sound'DeusExSounds.Weapons.GEPGunLock'
     TrackingSound=Sound'DeusExSounds.Weapons.GEPGunTrack'
     LandSound=Sound'DeusExSounds.Generic.DropLargeWeapon'
     FireSound=Sound'DeusExSounds.Weapons.GEPGunFire'
     CockingSound=Sound'DeusExSounds.Weapons.GEPGunReload'
     SelectSound=Sound'DeusExSounds.Weapons.GEPGunSelect'

     AmmoNames(0)=Class'DeusEx.AmmoRocketInv'
     AmmoNames(1)=Class'DeusEx.AmmoRocketWPInv'
     ProjectileNames(0)=Class'DeusEx.Rocket'
     ProjectileNames(1)=Class'DeusEx.RocketWP'
     bHasMuzzleFlash=False
     recoilStrength=1.000000
     bUseWhileCrouched=False
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     AmmoName=Class'DeusEx.AmmoRocketInv'
     ReloadCount=1
     PickupAmmoCount=4
     projSpawnOffset=(X=-46.000000,Y=22.000000,Z=-10.000000)
     ProjectileClass=Class'DeusEx.Rocket'

     InventoryGroup=17
     ItemName="Guided Explosive Projectile (GEP) Gun"
     PlayerViewOffset=(X=35.000000,Y=17.000000,Z=-12.000000)
     CenteredOffsetY=0

     Icon=Texture'DeusExUI.Icons.BeltIconGEPGun'
     CollisionRadius=27.000000
     CollisionHeight=6.600000
     Mass=50.000000
}
