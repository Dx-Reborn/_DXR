//=============================================================================
// WeaponSword.
//=============================================================================
class WeaponSword extends H2H_Weapon;

function Sound GetSelectSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetSwordSelect(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetSwordFire(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetSwordHitFlesh(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetSwordHitHard(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetSwordHitSoft(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetSwordDown(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetSwordLanded(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetLandedSound();
    }
    else return Super.GetLandedSound();
}




defaultproperties
{
     AttachmentClass=class'WeaponSwordAtt'
     PickupViewMesh=Mesh'DeusExItems.SwordPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.Sword'
     Mesh=Mesh'DeusExItems.SwordPickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconSword'
     largeIconWidth=130
     largeIconHeight=40
     invSlotsX=3
     Description="A rather nasty-looking sword."
     beltDescription="SWORD"
     LowAmmoWaterMark=0
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.050000
     EnemyEffective=ENMEFF_Organic
     ReloadTime=0.000000
     MaxRange=64
     AccurateRange=64
     BaseAccuracy=1.000000
     bHasMuzzleFlash=False
     bHandToHand=True
     bFallbackWeapon=True

     AmmoName=Class'DeusEx.AmmoNone'

     ReloadCount=0
     bInstantHit=True
     FireOffset=(X=-25.000000,Y=10.000000,Z=24.000000)

     FireSound=Sound'DeusExSounds.Weapons.SwordFire'
     SelectSound=Sound'DeusExSounds.Weapons.SwordSelect'
     Misc1Sound=Sound'DeusExSounds.Weapons.SwordHitFlesh'
     Misc2Sound=Sound'DeusExSounds.Weapons.SwordHitHard'
     Misc3Sound=Sound'DeusExSounds.Weapons.SwordHitSoft'
     LandSound=Sound'DeusExSounds.Generic.DropLargeWeapon'
     InventoryGroup=13
     ItemName="Sword"
     PlayerViewOffset=(X=25.000000,Y=21.000000,Z=-26.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconSword'
     CollisionRadius=26.000000
     CollisionHeight=0.500000
     Mass=20.000000
}
