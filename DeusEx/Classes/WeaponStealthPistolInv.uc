//=============================================================================
// WeaponStealthPistol.
//=============================================================================
class WeaponStealthPistolInv extends DeusExWeaponInv;

defaultproperties
{
		 PickupClass=class'WeaponStealthPistol'
     PickupViewMesh=VertMesh'DXRPickups.StealthPistolPickup'
		 FirstPersonViewMesh=Mesh'DeusExItems.StealthPistol' 
     Mesh=VertMesh'DXRPickups.StealthPistolPickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconStealthPistol'
     largeIconWidth=47
     largeIconHeight=37
     Description="The stealth pistol is a variant of the standard 10mm pistol with a larger clip and integrated silencer designed for wet work at very close ranges."
     beltDescription="STEALTH"
     GoverningSkill=Class'DeusEx.SkillWeaponPistol'
     NoiseLevel=0.010000
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_All
     ShotTime=0.150000
     ReloadTime=1.500000
     HitDamage=8
     MaxRange=4800
     AccurateRange=2400
     BaseAccuracy=0.800000
     bCanHaveScope=True
     ScopeFOV=25
     bCanHaveLaser=True
     recoilStrength=0.100000
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     AmmoName=Class'DeusEx.Ammo10mmInv'
     PickupAmmoCount=10
     bInstantHit=True
     FireOffset=(X=-24.000000,Y=10.000000,Z=14.000000)
     FireSound=Sound'DeusExSounds.Weapons.StealthPistolFire'
     ReloadEndSound=Sound'DeusExSounds.Weapons.StealthPistolReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.StealthPistolReload'
     SelectSound=Sound'DeusExSounds.Weapons.StealthPistolSelect'
     InventoryGroup=3
     ItemName="Stealth Pistol"
     PlayerViewOffset=(X=16.000000,Y=14.000000,Z=-14.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconStealthPistol'
     CollisionRadius=8.000000
     CollisionHeight=0.800000
}
