//=============================================================================
// WeaponShuriken.
//=============================================================================
class WeaponShuriken extends DeusExWeapon;

function Sound GetSelectSound()
{
    local DeusExGlobals gl;
    local sound sound;

    if (bPostTravel)
        return None;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetShurikenSelect(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetShurikenFire(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetFireSound();
    }
    else return Super.GetFireSound();
}

function Sound GetDownSound()
{
    local DeusExGlobals gl;
    local sound sound;

    bPostTravel = false;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetShurikenDown(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetDownSound();
    }
    else return Super.GetDownSound();
}


defaultproperties
{
     AttachmentClass=class'WeaponShurikenAtt'
     PickupViewMesh=Mesh'DeusExItems.ShurikenPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.Shuriken'
     Mesh=Mesh'DeusExItems.ShurikenPickup'

//     FireSound=Sound'DeusExSounds.Weapons.CrowbarFire'

     largeIcon=Texture'DeusExUI.Icons.LargeIconShuriken'
     largeIconWidth=36
     largeIconHeight=45
     Description="A favorite weapon of assassins in the Far East for centuries, throwing knives can be deadly when wielded by a master but are more generally used when it becomes desirable to send a message. The message is usually 'Your death is coming on swift feet.'"
     beltDescription="THW KNIFE"
     LowAmmoWaterMark=5
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.050000
     EnemyEffective=ENMEFF_Organic
     EnviroEffective=ENVEFF_AirVacuum
     Concealability=CONC_Visual
     ShotTime=0.200000
     ReloadTime=0.200000
     HitDamage=15
     MaxRange=1280
     AccurateRange=640
     BaseAccuracy=0.900000
     bHasMuzzleFlash=False
     bHandToHand=True
     AmmoName=Class'DeusEx.AmmoShuriken'
     ReloadCount=1
     PickupAmmoCount=5
     ProjSpawnOffset=(X=-0.11,Y=0.16,Z=0.24)
 //    FireOffset=(X=-10.000000,Y=-21.000000,Z=38.000000)
     ProjectileClass=Class'DeusEx.Shuriken'
     InventoryGroup=12
     ItemName="Throwing Knives"
     PlayerViewOffset=(X=24.000000,Y=18.000000,Z=-21.000000)
//     PlayerViewOffset=(X=24.000000,Y=18.000000,Z=-30.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconShuriken'
     CollisionRadius=7.50
     CollisionHeight=3.00
//     CollisionHeight=0.300000
}
