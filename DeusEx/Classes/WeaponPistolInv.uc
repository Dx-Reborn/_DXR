//=============================================================================
// WeaponPistol.
//=============================================================================
class WeaponPistolInv extends DeusExWeaponInv;

var() rotator smokeBoneRotator;
var EM_PistolSmoke extrapuff;
var int amountOfShots;

// Called from AnimNotify_script (bone 166)
// 163 STR_assualt_muzzleflash
function WeaponPistolSmoke()
{
  amountOfShots++;

  if (amountOfShots > 10)
  {
    extrapuff = Spawn(class'EM_PistolSmoke');
    extrapuff.Emitters[0].opacity = 0.1;
  }

  if (amountOfShots > 20)
  {
    extrapuff = Spawn(class'EM_PistolSmoke');
    extrapuff.Emitters[0].opacity = 0.3;
  }
}

function WeaponTick(float dt)
{
  super.WeaponTick(dt);
  if (extrapuff != none)
  {
    AttachToBone(extrapuff, '163'); // ближайшая косточка
  }
}


defaultproperties
{
     smokeBoneRotator=(Roll=15000,Pitch=0,Yaw=0)

		 PickupClass=class'WeaponPistol'
     PickupViewMesh=VertMesh'DXRPickups.GlockPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.Glock'
     Mesh=VertMesh'DXRPickups.GlockPickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconPistol'
     largeIconWidth=46
     largeIconHeight=28
     Description="A standard 10mm pistol."
     beltDescription="PISTOL"
     LowAmmoWaterMark=6
     GoverningSkill=Class'DeusEx.SkillWeaponPistol'
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_Visual
     ShotTime=0.600000
     ReloadTime=2.000000
     HitDamage=14
     MaxRange=4800
     AccurateRange=2400
     BaseAccuracy=0.700000
     bCanHaveScope=True
     ScopeFOV=25
     bCanHaveLaser=True
     recoilStrength=0.300000
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     AmmoName=Class'DeusEx.Ammo10mmInv'
     ReloadCount=6
     PickupAmmoCount=6
     bInstantHit=True
     FireOffset=(X=-22.000000,Y=10.000000,Z=14.000000)
     FireSound=Sound'DeusExSounds.Weapons.PistolFire'
     CockingSound=Sound'DeusExSounds.Weapons.PistolReload'
     SelectSound=Sound'DeusExSounds.Weapons.PistolSelect'
     InventoryGroup=2
     ItemName="Pistol"
     PlayerViewOffset=(X=22.000000,Y=19.000000,Z=-16.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconPistol'
     CollisionRadius=7.000000
     CollisionHeight=1.000000
}
