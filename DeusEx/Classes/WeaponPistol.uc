//=============================================================================
// WeaponPistol.
//=============================================================================
class WeaponPistol extends DeusExWeapon;

var EM_PistolSmoke extrapuff;
var int amountOfShots;

const SmokeThreshold = 10;

// Spawn an emitter!
function AddParticles()
{
    local coords K;

    K = GetBoneCoords('163');
    extrapuff = Spawn(class'EM_PistolSmoke',, '', K.Origin);
//    AttachToBone(extrapuff, '163');
}

function WeaponPistolSmoke()
{
  amountOfShots++;

  if (amountOfShots > SmokeThreshold)
  {
    AddParticles();
    extrapuff.Emitters[0].opacity = 0.1;
  }
  BoneRefresh();
}

// Called from mesh notify (shooting animation)
function PistolFireStart()
{
  if (FRand() > 0.5)
      Skins[2] = Shader'FlatFXTex31_SH';
    else
      Skins[2] = Shader'FlatFXTex34_SH';
}

function PistolFireEnd()
{
    Skins[2] = texture'PinkMaskTex'; //class'ObjectManager'.static.GetActorMeshTexture(self, 2);
}

/*function WeaponTick(float dt)
{
  if (extrapuff != none)
     AttachToBone(extrapuff, '163'); // ближайшая косточка

  Super.WeaponTick(dt);
}*/

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
    local ShellCasing10mm s;
    local coords K;

    K = GetBoneCoords('177');

     Super.ProcessTraceHit(Other, HitLocation, HitNormal, X, Y, Z);

     s = Spawn(class'ShellCasing10mm',, '', K.Origin);
     if (S != None)
     {
         s.SetDrawScale(0.1);
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
        sound = class'DXRWeaponSoundManager'.static.GetPistolSelect(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetPistolFire(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetPistolReloadBegin(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetReloadBeginSound();
    }
    else return Super.GetReloadBeginSound();
}

function Sound GetDownSound()
{
   return default.DownSound;
}



defaultproperties
{
     AttachmentClass=class'WeaponPistolAtt'
     PickupViewMesh=Mesh'DeusExItems.GlockPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.Glock'
     Mesh=Mesh'DeusExItems.GlockPickup'

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
     AmmoName=Class'DeusEx.Ammo10mm'
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

     IconCoords=(X1=-1)
}
