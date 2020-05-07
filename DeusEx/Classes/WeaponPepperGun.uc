//=============================================================================
// WeaponPepperGun.
//=============================================================================
class WeaponPepperGun extends DeusExWeapon;

function Sound GetSelectSound()
{
    local DeusExGlobals gl;
    local sound sound;

    if (bPostTravel)
        return None;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetPepperGunSelect(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetPepperGunFire(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetPepperGunReloadBegin(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetPepperGunReloadEnd(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetPepperGunDown(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetDownSound();
    }
    else return Super.GetDownSound();
}


defaultproperties
{
     AttachmentClass=class'WeaponPepperGunAtt'
     PickupViewMesh=Mesh'DeusExItems.PepperGunPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.PepperGun'
     Mesh=Mesh'DeusExItems.PepperGunPickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconPepperSpray'
     largeIconWidth=46
     largeIconHeight=40
     Description="The pepper gun will accept a number of commercially available riot control agents in cartridge form and disperse them as a fine aerosol mist that can cause blindness or blistering at short-range."
     beltDescription="PEPPER"
     LowAmmoWaterMark=50
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.200000
     EnemyEffective=ENMEFF_Organic
     EnviroEffective=ENVEFF_AirVacuum
     Concealability=CONC_Visual
     bAutomatic=True
     ShotTime=0.075000
     ReloadTime=4.000000
     HitDamage=0
     MaxRange=100
     AccurateRange=100
     BaseAccuracy=0.700000
     AreaOfEffect=AOE_Sphere
     bPenetrating=False
     StunDuration=15.000000
     bHasMuzzleFlash=False
     AmmoName=Class'DeusEx.AmmoPepper'
     ReloadCount=100
     PickupAmmoCount=100
     ProjSpawnOffset=(X=8.000000,Y=4.000000,Z=0.000000)
//     FireOffset=(X=8.000000,Y=4.000000,Z=14.000000)
     ProjectileClass=Class'DeusEx.TearGas'
     FireSound=Sound'DeusExSounds.Weapons.PepperGunFire'
     ReloadEndSound=Sound'DeusExSounds.Weapons.PepperGunReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.PepperGunReload'
     SelectSound=Sound'DeusExSounds.Weapons.PepperGunSelect'
     InventoryGroup=18
     ItemName="Pepper Gun"
     PlayerViewOffset=(X=22.000000,Y=19.000000,Z=-16.000000)


     Icon=Texture'DeusExUI.Icons.BeltIconPepperSpray'

     CollisionRadius=7.000000
     CollisionHeight=1.500000
     Mass=7.000000
     Buoyancy=2.000000
}
