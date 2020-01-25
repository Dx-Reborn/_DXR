//=============================================================================
// WeaponProd.
//=============================================================================
class WeaponProd extends DeusExWeapon;


function Sound GetSelectSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetProdSelect(gl.WS_Preset);
        if (sound != None)
           return sound;
           else
        return Super.GetSelectSound();
    }
    return Super.GetSelectSound();
}

function Sound GetFireSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetProdFire(gl.WS_Preset);
        if (sound != None)
           return sound;
           else
        return Super.GetFireSound();
    }
    return Super.GetFireSound();    
}

function Sound GetReloadBeginSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetProdReloadBegin(gl.WS_Preset);
        if (sound != None)
           return sound;
           else
        return Super.GetReloadBeginSound();
    }
    return Super.GetReloadBeginSound();
}

function Sound GetReloadEndSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetProdReloadEnd(gl.WS_Preset);
        if (sound != None)
           return sound;
           else
        return Super.GetReloadEndSound();
    }
    return Super.GetReloadEndSound();
}

function Sound GetDownSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetProdDown(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetDownSound();
    }
    else return Super.GetDownSound();
}


defaultproperties
{
     AttachmentClass=class'WeaponProdAtt'
     PickupViewMesh=Mesh'DeusExItems.ProdPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.Prod'
     Mesh=Mesh'DeusExItems.ProdPickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconProd'
     largeIconWidth=49
     largeIconHeight=48
     Description="The riot prod has been extensively used by security forces who wish to keep what remains of the crumbling peace and have found the prod to be an valuable tool. Its short range tetanizing effect is most effective when applied to the torso or when the subject is taken by surprise."
     beltDescription="PROD"
     LowAmmoWaterMark=4
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.050000
     EnemyEffective=ENMEFF_Organic
     EnviroEffective=ENVEFF_Air
     Concealability=CONC_Visual
     ShotTime=1.000000
     ReloadTime=3.000000
     HitDamage=15
     MaxRange=80
     AccurateRange=80
     bPenetrating=False
     StunDuration=10.000000
     bHasMuzzleFlash=False
     AmmoName=Class'DeusEx.AmmoBattery'
     ReloadCount=4
     PickupAmmoCount=4
     bInstantHit=True
     FireOffset=(X=-21.000000,Y=12.000000,Z=19.000000)
     FireSound=Sound'DeusExSounds.Weapons.ProdFire'
     ReloadEndSound=Sound'DeusExSounds.Weapons.ProdReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.ProdReload'
     SelectSound=Sound'DeusExSounds.Weapons.ProdSelect'
     InventoryGroup=19
     ItemName="Riot Prod"
     PlayerViewOffset=(X=21.000000,Y=12.000000,Z=-19.000000)
//     PlayerViewOffset=(X=21.000000,Y=-12.000000,Z=-19.000000)
     Icon=Texture'DeusExUI.Icons.BeltIconProd'
     CollisionRadius=8.750000
     CollisionHeight=1.350000
}
