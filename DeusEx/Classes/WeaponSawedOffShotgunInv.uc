//=============================================================================
// WeaponSawedOffShotgun.
// Косточка для выброса - 164
//=============================================================================
class WeaponSawedOffShotgunInv extends DeusExWeaponInv;

var xEmitter SmokeEmitter;

simulated function SawedOffCockSound()
{
	if ((AmmoType.AmmoAmount > 0) && (Self != None))
		PlaySound(SelectSound, SLOT_None,,, 1024);
}

defaultproperties
{
     PickupClass=class'WeaponSawedOffShotgun'
     AttachmentClass=class'WeaponSawedOffShotgunAtt'
     PickupViewMesh=VertMesh'DXRPickups.ShotgunPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.Shotgun'
     Mesh=VertMesh'DXRPickups.ShotgunPickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconShotgun'
     largeIconWidth=131
     largeIconHeight=45
     invSlotsX=3
     Description="The sawed-off, pump-action shotgun features a truncated barrel resulting in a wide spread at close range and will accept either buckshot or sabot shells."
     beltDescription="SAWED-OFF"
     LowAmmoWaterMark=4
     GoverningSkill=Class'DeusEx.SkillWeaponRifle'
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_Visual
     ShotTime=0.300000
     ReloadTime=3.000000
     HitDamage=5
     MaxRange=2400
     AccurateRange=1200
     BaseAccuracy=0.600000
     AmmoName=Class'DeusEx.AmmoShellInv'

     AmmoNames(0)=Class'DeusEx.AmmoShellInv'
     AmmoNames(1)=Class'DeusEx.AmmoSabotInv'
     AreaOfEffect=AOE_Cone
     recoilStrength=0.500000
     bCanHaveModReloadCount=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     ReloadCount=4
     PickupAmmoCount=4
     bInstantHit=True
     FireOffset=(X=-11.000000,Y=4.000000,Z=13.000000)

     FireSound=Sound'DeusExSounds.Weapons.SawedOffShotgunFire'
     ReloadEndSound=Sound'DeusExSounds.Weapons.SawedOffShotgunReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.SawedOffShotgunReload'
     SelectSound=Sound'DeusExSounds.Weapons.SawedOffShotgunSelect'
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'

     InventoryGroup=6
     ItemName="Sawed-off Shotgun"
     PlayerViewOffset=(X=5.500000,Y=4.000000,Z=-13.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconShotgun'
     CollisionRadius=12.000000
     CollisionHeight=0.900000
     Mass=15.000000
}
