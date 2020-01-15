//=============================================================================
// WeaponBaton.
//=============================================================================
class WeaponBatonInv extends coldarmsInv;

function class<DamageType> WeaponDamageType()
{
   return class'DM_KnockedOut';
}

function Sound GetSelectSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetBatonSelect(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetBatonFire(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetBatonHitFlesh(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetFleshHitSound();
    }
    else return Super.GetFleshHitSound();
}


defaultproperties
{
     PickupClass=class'WeaponBaton'
     AttachmentClass=class'WeaponBatonAtt'
     PickupViewMesh=VertMesh'DXRPickups.BatonPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.Baton'
     Mesh=VertMesh'DXRPickups.BatonPickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconBaton'
     largeIconWidth=46
     largeIconHeight=47
     Description="A hefty looking baton, typically used by riot police and national security forces to discourage civilian resistance."
     beltDescription="BATON"
     LowAmmoWaterMark=0
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.050000
     ReloadTime=0.000000
     HitDamage=7
     MaxRange=80
     AccurateRange=80
     BaseAccuracy=1.000000
     bPenetrating=False
     bHasMuzzleFlash=False
     bHandToHand=True
     bFallbackWeapon=True
     bEmitWeaponDrawn=False
     AmmoName=Class'DeusEx.AmmoNoneInv'
     ReloadCount=0
     bInstantHit=True
     FireOffset=(X=-24.000000,Y=14.000000,Z=17.000000)
     // shakemag=20.000000
     FireSound=Sound'DeusExSounds.Weapons.BatonFire'
     SelectSound=Sound'DeusExSounds.Weapons.BatonSelect'
     Misc1Sound=Sound'DeusExSounds.Weapons.BatonHitFlesh'
     Misc2Sound=Sound'DeusExSounds.Weapons.BatonHitHard'
     Misc3Sound=Sound'DeusExSounds.Weapons.BatonHitSoft'
     InventoryGroup=24
     ItemName="Baton"
     PlayerViewPivot=(Pitch=0,Roll=0,Yaw=-32768) // Развернуть модель
     PlayerViewOffset=(X=24.000000,Y=14.000000,Z=-17.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconBaton'
     CollisionRadius=14.000000
     CollisionHeight=1.000000
     Mass=20.000000
}
