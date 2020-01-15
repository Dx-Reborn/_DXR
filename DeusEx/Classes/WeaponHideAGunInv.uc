//=============================================================================
// WeaponHideAGun.
//=============================================================================
class WeaponHideAGunInv extends DeusExWeaponInv;

function Sound GetSelectSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetHideAGunSelect(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetHideAGunFire(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetFireSound();
    }
    else return Super.GetFireSound();
}

defaultproperties
{
     PickupClass=class'WeaponHideAGun'
     PickupViewMesh=VertMesh'DXRPickups.HideAGunPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.HideAGun'
     Mesh=VertMesh'DXRPickups.HideAGunPickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconHideAGun'
     largeIconWidth=29
     largeIconHeight=47
     Description="The PS20 is a disposable, plasma-based weapon developed by an unknown security organization as a next generation stealth pistol.  Unfortunately, the necessity of maintaining a small physical profile restricts the weapon to a single shot.  Despite its limited functionality, the PS20 can be lethal at close range."
     beltDescription="PS20"
     LowAmmoWaterMark=0
     GoverningSkill=Class'DeusEx.SkillWeaponPistol'
     NoiseLevel=0.010000
     Concealability=CONC_All
     ShotTime=0.300000
     ReloadTime=0.000000
     HitDamage=25
     MaxRange=24000
     AccurateRange=14400
     BaseAccuracy=0.000000
     bHasMuzzleFlash=False
     bEmitWeaponDrawn=False
     bUseAsDrawnWeapon=False
     AmmoName=Class'DeusEx.AmmoNoneInv'
     ReloadCount=0
     FireOffset=(X=-20.000000,Y=10.000000,Z=16.000000)
     ProjectileClass=Class'DeusEx.PlasmaBolt'
     FireSound=Sound'DeusExSounds.Weapons.PlasmaRifleFire'
     SelectSound=Sound'DeusExSounds.Weapons.HideAGunSelect'
     ItemName="PS20"
     PlayerViewOffset=(X=20.000000,Y=19.000000,Z=-18.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconHideAGun'
     CollisionRadius=3.300000
     CollisionHeight=0.600000
     Mass=5.000000
     Buoyancy=2.000000
}
