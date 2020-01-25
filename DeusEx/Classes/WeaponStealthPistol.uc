//=============================================================================
// WeaponStealthPistol.
//=============================================================================
class WeaponStealthPistol extends DeusExWeapon;

var EM_PistolSmoke extrapuff;
var int amountOfShots;

const SmokeThreshold = 10;

// Spawn an emitter!
function AddParticles()
{
    local coords K;

    K = GetBoneCoords('18');

    extrapuff = Spawn(class'EM_PistolSmoke',, '', K.Origin);
//    AttachToBone(extrapuff, '18');
}

// Called from mesh notify
function SPSmoke()
{
  amountOfShots++;

  if (amountOfShots >= SmokeThreshold)
  {
    AddParticles();
    extrapuff.Emitters[0].opacity = 0.1;
  }
}

// Works only while weapon is in hand.
/*function WeaponTick(float dt)
{
  if (extrapuff != none)
     AttachToBone(extrapuff, '18');

  Super.WeaponTick(dt);
}*/

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
    local ShellCasing10mm s;
    local coords K;

    K = GetBoneCoords('132');

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
        sound = class'DXRWeaponSoundManager'.static.GetStealthPistolSelect(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetStealthPistolFire(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetStealthPistolReloadBegin(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetReloadBeginSound();
    }
    else return Super.GetReloadBeginSound();
}

function Sound GetDownSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetStealthPistolDown(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetDownSound();
    }
    else return Super.GetDownSound();
}





defaultproperties
{
     AttachmentClass=class'WeaponStealthPistolAtt'
     PickupViewMesh=Mesh'DeusExItems.StealthPistolPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.StealthPistol'
     Mesh=Mesh'DeusExItems.StealthPistolPickup'

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
     AmmoName=Class'DeusEx.Ammo10mm'
     PickupAmmoCount=10
     ReloadCount=10
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
     CollisionHeight=1.800000
//     CollisionHeight=0.800000
}
