//=============================================================================
// WeaponLAW.
//=============================================================================
class WeaponLAW extends DeusExWeapon;

function Sound GetSelectSound()
{
    local DeusExGlobals gl;
    local sound sound;

    if (bPostTravel)
        return None;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetLAWSelect(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetLAWFire(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetLAWDown(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetDownSound();
    }
    else return Super.GetDownSound();
}

function DropUsedWeapon()
{
   local usedWeaponLAW used;
   local coords K;

   K = GetBoneCoords('90');
   used = Spawn(class'usedWeaponLAW',, '', K.Origin);
}


defaultproperties
{
     AttachmentClass=class'WeaponLAWAtt'
     PickupViewMesh=Mesh'DeusExItems.LAWPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.LAW'
     Mesh=Mesh'DeusExItems.LAWPickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconLAW'
     largeIconWidth=166
     largeIconHeight=47
     invSlotsX=4
     Description="The LAW provides cheap, dependable anti-armor capability in the form of an integrated one-shot rocket and delivery system, though at the expense of any laser guidance. Like other heavy weapons, the LAW can slow agents who have not trained with it extensively."
     beltDescription="LAW"
     LowAmmoWaterMark=0
     GoverningSkill=Class'DeusEx.SkillWeaponHeavy'
     NoiseLevel=2.000000
     EnviroEffective=ENVEFF_Air
     ShotTime=0.300000
     ReloadTime=0.000000
     HitDamage=100
     MaxRange=24000
     AccurateRange=14400
     BaseAccuracy=0.600000
     bHasMuzzleFlash=False
     recoilStrength=1.000000
     AmmoName=Class'DeusEx.AmmoNone'
     ReloadCount=0
     FireOffset=(X=28.000000,Y=12.000000,Z=4.000000)
     ProjectileClass=Class'DeusEx.RocketLAW'

     FireSound=Sound'DeusExSounds.Weapons.LAWFire'
     SelectSound=Sound'DeusExSounds.Weapons.LAWSelect'
     LandSound=Sound'DeusExSounds.Generic.DropLargeWeapon'

     InventoryGroup=16
     ItemName="Light Anti-Tank Weapon (LAW)"
     PlayerViewOffset=(X=12.000000,Y=15.000000,Z=-12.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconLAW'
     CollisionRadius=25.000000
     CollisionHeight=6.800000
     Mass=50.000000
}
