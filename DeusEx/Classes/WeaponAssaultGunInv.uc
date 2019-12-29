//=============================================================================
// WeaponAssaultGun.
// Какая же эта штука бестолковая!
//=============================================================================
class WeaponAssaultGunInv extends DeusExWeaponInv;

var EM_PistolSmoke extrapuff;
var int amountOfShots;

const FirstThreshold = 10;
const SecondThreshold = 20;
const Threshold3 = 40;
const Threshold4 = 60;

event AnimEnd(int channel)
{
   Super.AnimEnd(channel);

   AssaultGunFireEnd();
}

// Spawn an emitter!
function AddParticles()
{
    extrapuff = Spawn(class'EM_PistolSmoke');
    AttachToBone(extrapuff, '211');
}


function AssaultGunSmoke()
{
//  amountOfShots++;
  amountOfShots += 5;

  if (amountOfShots > FirstThreshold)
  {
    AddParticles();
    extrapuff.Emitters[0].opacity = 0.1;
  }
  if (amountOfShots > SecondThreshold)
  {
    AddParticles();
    extrapuff.Emitters[0].opacity = 0.3;
    extrapuff.Emitters[0].LifetimeRange.Min = 2.000000;
    extrapuff.Emitters[0].LifetimeRange.Max = 2.500000;
  }
  if (amountOfShots > Threshold3)
  {
    AddParticles();
    extrapuff.Emitters[0].opacity = 0.5;
    extrapuff.Emitters[0].LifetimeRange.Min = 3.000000;
    extrapuff.Emitters[0].LifetimeRange.Max = 3.500000;
  }
  if (amountOfShots > Threshold4)
  {
    AddParticles();
    extrapuff.Emitters[0].opacity = 1.0;
    extrapuff.Emitters[0].LifetimeRange.Min = 3.500000;
    extrapuff.Emitters[0].LifetimeRange.Max = 4.000000;
  }

  BoneRefresh();
}

// 182 93 187
// Called from mesh notify (shooting animation)
function AssaultGunFireStart()
{
  if (FRand() > 0.5)
      Skins[2] = Shader'FlatFXTex31_SH';
    else
      Skins[2] = Shader'FlatFXTex34_SH';
}

function AssaultGunFireEnd()
{
    Skins[2] = texture'PinkMaskTex';
}

function WeaponTick(float dt)
{
  if (extrapuff != none)
     AttachToBone(extrapuff, '211');

  Super.WeaponTick(dt);
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
    local ShellCasing s;
    local coords K;

    K = GetBoneCoords('193');

     Super.ProcessTraceHit(Other, HitLocation, HitNormal, X, Y, Z);

     s = Spawn(class'ShellCasing',, '', K.Origin);
     if (S != None)
     {
         s.SetDrawScale(0.1);
         s.Velocity = (FRand()*20+75) * Y + (10-FRand()*20) * X;
         s.Velocity.Z += 200;
     }
}        


defaultproperties
{
     PickupClass=class'WeaponAssaultGun'
     AttachmentClass=class'WeaponAssaultGunAtt'
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
     AmmoName=class'DeusEx.Ammo762mmInv'

     FirstPersonViewSkins[0]=Texture'DeusExItems.Skins.WeaponHandsTex'
     FirstPersonViewSkins[1]=Texture'DeusExItems.Skins.AssaultGunTex1'
     FirstPersonViewSkins[2]=Texture'DeusExItems.Skins.BlackMaskTex'
     FirstPersonViewSkins[3]=Texture'DeusExItems.Skins.WeaponHandsTex'

     recoilStrength=0.500000
     MinWeaponAcc=0.200000
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
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
