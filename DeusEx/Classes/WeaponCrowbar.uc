//=============================================================================
// WeaponCrowbar.
//=============================================================================
class WeaponCrowbar extends H2H_Weapon;

function Sound GetSelectSound()
{
    local DeusExGlobals gl;
    local sound sound;

    if (bPostTravel)
        return None;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetCrowBarSelect(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetCrowBarFire(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetFireSound();
    }
    else return Super.GetFireSound();
}

function Sound GetFleshHitSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetCrowBarHitFlesh(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetFleshHitSound();
    }
    else return Super.GetFleshHitSound();
}

function Sound GetHardHitSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetCrowBarHitHard(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetHardHitSound();
    }
    else return Super.GetHardHitSound();
}

function Sound GetSoftHitSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetCrowBarHitSoft(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetSoftHitSound();
    }
    else return Super.GetSoftHitSound();
}

function Sound GetDownSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetCrowBarDown(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetDownSound();
    }
    else return Super.GetDownSound();
}

function Sound GetLandedSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetCrowbarLanded(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetLandedSound();
    }
    else return Super.GetLandedSound();
}



defaultproperties
{
     DrawScale=1.0
     AttachmentClass=class'WeaponCrowbarAtt'
     PickupViewMesh=Mesh'DeusExItems.CrowbarPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.Crowbar'
     Mesh=Mesh'DeusExItems.CrowbarPickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconCrowbar'
     largeIconWidth=101
     largeIconHeight=43
     invSlotsX=2
     Description="A crowbar. Hit someone or something with it. Repeat.|n|n<UNATCO OPS FILE NOTE GH010-BLUE> Many crowbars we call 'murder of crowbars.'  Always have one for kombat. Ha. -- Gunther Hermann <END NOTE>"
     beltDescription="CROWBAR"
     LowAmmoWaterMark=0
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.050000
     ReloadTime=0.000000
     HitDamage=6
     MaxRange=80
     AccurateRange=80
     BaseAccuracy=1.000000
     bPenetrating=False
     bHasMuzzleFlash=False
     bHandToHand=True
     bFallbackWeapon=True
     bEmitWeaponDrawn=False
     AmmoName=Class'DeusEx.AmmoNone'

     ReloadCount=0
     PickupAmmoCount=0
     bInstantHit=True
     FireOffset=(X=-40.000000,Y=15.000000,Z=8.000000)

     FireSound=Sound'DeusExSounds.Weapons.CrowbarFire'
     SelectSound=Sound'DeusExSounds.Weapons.CrowbarSelect'
     Misc1Sound=Sound'DeusExSounds.Weapons.CrowbarHitFlesh'
     Misc2Sound=Sound'DeusExSounds.Weapons.CrowbarHitHard'
     Misc3Sound=Sound'DeusExSounds.Weapons.CrowbarHitSoft'
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'

     InventoryGroup=10
     ItemName="Crowbar"

     PlayerViewPivot=(Pitch=0,Roll=0,Yaw=-32768) // Развернуть модель
     PlayerViewOffset=(X=40.000000,Y=15.000000,Z=-8.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconCrowbar'
     CollisionRadius=19.000000
     CollisionHeight=1.050000
     Mass=15.000000
}
