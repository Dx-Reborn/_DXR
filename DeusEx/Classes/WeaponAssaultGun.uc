//=============================================================================
// WeaponAssaultGun.
// Какая же эта штука бестолковая!
//=============================================================================
class WeaponAssaultGun extends DeusExWeapon;

var EM_PistolSmoke extrapuff;
var int amountOfShots;
var Name ShootAnim;

var Sound FireSounds[5];

const FirstThreshold = 10;
const SecondThreshold = 20;
const Threshold3 = 40;
const Threshold4 = 60;


function PlayFiring()
{
    if (bAutomatic)
    {
        if (Owner.IsA('PlayerPawn'))
           LoopAnim(ShootAnim,5.0, 0.01);
        else
           LoopAnim(ShootAnim,1.0, 0.1);
    }
    else
    {
        PlayAnim(ShootAnim,,0.1);
    }

    if (bHasSilencer)
        Owner.PlaySound(GetSilencedSound(), SLOT_Misc,,, 2048);
    else
//        Owner.PlaySound(GetFireSound(), SLOT_None,,, 2048, 1.0,);
        Owner.PlaySound(GetFireSound(), SLOT_Misc,,, 2048, 1.0,);
}

event AnimEnd(int channel)
{
   Super.AnimEnd(channel);

   AssaultGunFireEnd();
}

// Spawn an emitter!
function AddParticles()
{
    local coords K;

    K = GetBoneCoords('211');
    extrapuff = Spawn(class'EM_PistolSmoke',, '', K.Origin);
}


function AssaultGunSmoke()
{
  amountOfShots++;

  if (amountOfShots > FirstThreshold)
  {
     AddParticles();
     extrapuff.Emitters[0].opacity = 0.05;
     extrapuff.Emitters[0].InitialParticlesPerSecond=50.00;
  }
  if (amountOfShots > SecondThreshold)
  {
     AddParticles();
     extrapuff.Emitters[0].opacity = 0.07;
     extrapuff.Emitters[0].LifetimeRange.Min = 2.000000;
     extrapuff.Emitters[0].LifetimeRange.Max = 2.500000;
  }
  if (amountOfShots > Threshold3)
  {
     AddParticles();
     extrapuff.Emitters[0].opacity = 0.08;
     extrapuff.Emitters[0].LifetimeRange.Min = 3.000000;
     extrapuff.Emitters[0].LifetimeRange.Max = 3.500000;
  }
  if (amountOfShots > Threshold4)
  {
     AddParticles();
     extrapuff.Emitters[0].opacity = 0.10;
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
    class'SoundManager'.static.StopSound(owner,GetFireSound());
}

event WeaponTick(float dt)
{
  if (GetAnimSequence() != 'Shoot')
  {
      class'SoundManager'.static.StopSound(owner,GetFireSound());
      AssaultGunFireEnd();
  }
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
         s.SetRotation(RotRand(false));
         s.SetDrawScale(ShellCasingDrawScale);
         s.Velocity = (FRand()*20+75) * Y + (10-FRand()*20) * X;
         s.Velocity.Z += 200;
     }
}


function Sound GetSelectSound()
{
    local DeusExGlobals gl;
    local sound sound;

    if (bPostTravel)
        return None;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetAssaultGunSelect(gl.WS_Preset);
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
        if (AmmoName != default.AmmoName)
        return Get20mmFireSound();
        else
        sound = class'DXRWeaponSoundManager'.static.GetAssaultGunFire(gl.WS_Preset);
        if (sound != None)
            return sound;
        else
            return FireSounds[Rand(4)]; //Super.GetFireSound();
    }
    if (AmmoName != default.AmmoName)
        return Get20mmFireSound();
    else 
        return FireSounds[Rand(4)];//Super.GetFireSound();
}


function PlayFireSound()
{
    if (bHasSilencer)
        Owner.PlaySound(GetSilencedSound(), SLOT_Misc,,, 2048);
    else
        Owner.PlaySound(GetFireSound(), SLOT_None,,false, 2048, 1.0, true);
}                                                //bNoOverride
// DXR: Я о5 всё забыла!
// function PlaySound(sound Sound,optional ESoundSlot Slot,optional float Volume,optional bool bNoOverride,optional float Radius,optional float Pitch,optional bool Attenuate);



function Sound GetReloadBeginSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetAssaultGunReloadBegin(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetAssaultGunReloadEnd(gl.WS_Preset);
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

    bPostTravel = false;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetAssaultGunDown(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetDownSound();
    }
    else return Super.GetDownSound();
}


defaultproperties
{
     FireSounds[0]=Sound'STALKER_Sounds.Weapons.AssaultGunFire1'
     FireSounds[1]=Sound'STALKER_Sounds.Weapons.AssaultGunFire2'
     FireSounds[2]=Sound'STALKER_Sounds.Weapons.AssaultGunFire3'
     FireSounds[3]=Sound'STALKER_Sounds.Weapons.AssaultGunFire4'
     FireSounds[4]=Sound'STALKER_Sounds.Weapons.AssaultGunFire5'

     ShellCasingDrawScale=0.8
     ShootAnim="Shoot"

     AttachmentClass=class'WeaponAssaultGunAtt'
     PickupViewMesh=Mesh'DeusExItems.AssaultGunPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.AssaultGun'
     Mesh=Mesh'DeusExItems.AssaultGunPickup'

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

     AmmoNames(0)=Class'DeusEx.Ammo762mm'
     AmmoNames(1)=Class'DeusEx.Ammo20mm'
     ProjectileNames(1)=Class'DeusEx.HECannister20mm'
     AmmoName=class'DeusEx.Ammo762mm'

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
     PlayerViewOffset=(X=19.000000,Y=9.000000,Z=-13.500000)
//     PlayerViewOffset=(X=8.00,Y=-5.00,Z=-11.50)

     Icon=Texture'DeusExUI.Icons.BeltIconAssaultGun'
     CollisionRadius=15.000000
     CollisionHeight=2.500000
//     CollisionHeight=1.100000
     Mass=30.000000
}
