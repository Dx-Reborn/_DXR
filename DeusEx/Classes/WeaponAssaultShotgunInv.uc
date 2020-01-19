//=============================================================================
// WeaponAssaultShotgun.
//=============================================================================
class WeaponAssaultShotgunInv extends DeusExWeaponInv;

var EM_PistolSmoke extrapuff;
var int amountOfShots;
var int pLifeRand;

const FirstThreshold = 10;
const SecondThreshold = 20;
const Threshold3 = 40;
const Threshold4 = 60;

// Spawn an emitter!
function AddParticles()
{
    local coords K;

//    extrapuff = Spawn(class'EM_PistolSmoke');
    K = GetBoneCoords('177');
    extrapuff = Spawn(class'EM_PistolSmoke',, '', K.Origin);
//    AttachToBone(extrapuff, '177');
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
    extrapuff.Emitters[0].LifetimeRange.Max = 2.500000 + FRand();
  }
  if (amountOfShots > Threshold3)
  {
    AddParticles();
    extrapuff.Emitters[0].opacity = 0.5;
    extrapuff.Emitters[0].LifetimeRange.Min = 3.000000;
    extrapuff.Emitters[0].LifetimeRange.Max = 3.500000 + FRand();
  }
  if (amountOfShots > Threshold4)
  {
    AddParticles();
    extrapuff.Emitters[0].opacity = 1.0;
    extrapuff.Emitters[0].LifetimeRange.Min = 3.500000;
    extrapuff.Emitters[0].LifetimeRange.Max = 4.000000 + FRand();
  }

  BoneRefresh();
}

function AssaultShotGunFireStart()
{
  if (FRand() > 0.5)
      Skins[2] = Shader'FlatFXTex31_SH';
    else
      Skins[2] = Shader'FlatFXTex34_SH';
}

function AssaultShotGunFireEnd()
{
      Skins[2] = texture'PinkMaskTex';
      EjectShell();
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

    K = GetBoneCoords('135');

     s = Spawn(class'ShellCasing_a',, '', K.Origin);
     if (S != None)
     {
         s.Velocity = (FRand()*20+75) * Y + (10-FRand()*20) * X;
         s.Velocity.Z += 200;
     }
}

function Sound GetSelectSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetAssaultShotgunSelect(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetSelectSound();
    }
    else return Super.GetSelectSound();
}

function Sound GetFireSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetAssaultShotgunFire(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetFireSound();
    }
    else return Super.GetFireSound();
}

function Sound GetReloadBeginSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetAssaultShotgunReloadBegin(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetReloadBeginSound();
    }
    else return Super.GetReloadBeginSound();
}

function Sound GetReloadEndSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetAssaultShotgunReloadEnd(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetReloadEndSound();
    }
    else return Super.GetReloadEndSound();
}

function Sound GetDownSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetAssaultShotGunDown(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetDownSound();
    }
    else return Super.GetDownSound();
}


defaultproperties
{
     PickupClass=class'WeaponAssaultShotgun'
     AttachmentClass=class'WeaponAssaultShotgunAtt'
     PickupViewMesh=VertMesh'DXRPickups.AssaultShotgunPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.AssaultShotgun'
     Mesh=VertMesh'DXRPickups.AssaultShotgunPickup'

     FirstPersonViewSkins[0]=Texture'DeusExItems.Skins.AssaultShotgunTex1'
     FirstPersonViewSkins[1]=Texture'DeusExItems.Skins.WeaponHandsTex'
     FirstPersonViewSkins[2]=Texture'DeusExItems.Skins.BlackMaskTex'
     FirstPersonViewSkins[3]=Texture'DeusExItems.Skins.WeaponHandsTex'

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