//=============================================================================
// WeaponSawedOffShotgun.
// Косточка для выброса - 164
//=============================================================================
class WeaponSawedOffShotgunInv extends DeusExWeaponInv;

var EM_PistolSmoke extrapuff;
var int amountOfShots;

const FirstThreshold = 4;
const SecondThreshold = 8;
const Threshold3 = 16;
const Threshold4 = 32;


// Spawn an emitter!
function AddParticles()
{
    extrapuff = Spawn(class'EM_PistolSmoke');
    AttachToBone(extrapuff, '155');
}

function SpawnSmoke()
{
  amountOfShots++;

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


simulated function SawedOffCockSound()
{
    EjectShell();

    if ((AmmoType.AmmoAmount > 0) && (Self != None))
        PlaySound(SelectSound, SLOT_None,,, 1024);
}

function SawedOffFireStart()
{
    if (FRand() > 0.5)
      Skins[2] = Shader'FlatFXTex31_SH';
    else
      Skins[2] = Shader'FlatFXTex34_SH';
}

function SawedOffFireEnd()
{
     Skins[2] = texture'PinkMaskTex';
     SpawnSmoke();
}

function EjectShell()
{
    local vector X, Y, Z;
    local ShellCasing_a s;
    local coords K;

    if (!bool(Owner))
        return;

    GetAxes(Pawn(Owner).GetViewRotation(), X, Y, Z);

    K = GetBoneCoords('166');

     s = Spawn(class'ShellCasing_a',, '', K.Origin);
     if (S != None)
     {
         s.Velocity = (FRand()*20+75) * Y + (10-FRand()*20) * X;
         s.Velocity.Z += 200;
     }
}

//155

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

     FirstPersonViewSkins[0]=Texture'DeusExItems.Skins.WeaponHandsTex'
     FirstPersonViewSkins[1]=Texture'DeusExItems.Skins.ShotgunTex1'
     FirstPersonViewSkins[2]=Texture'DeusExItems.Skins.BlackMaskTex'
     FirstPersonViewSkins[3]=Texture'DeusExItems.Skins.WeaponHandsTex'

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

     TransientSoundVolume=0.8
}
