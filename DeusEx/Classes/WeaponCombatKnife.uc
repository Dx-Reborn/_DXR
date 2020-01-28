//=============================================================================
// WeaponCombatKnife.
//=============================================================================
class WeaponCombatKnife extends H2H_Weapon;

function Sound GetFireSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetCombatKnifeFire(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetCombatKnifeHitFlesh(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetCombatKnifeHitHard(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetHardHitSound();
    }
    else return Super.GetHardHitSound();
}

function Sound GetDownSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetCombatKnifeDown(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetDownSound();
    }
    else return Super.GetDownSound();
}


defaultproperties
{
     AttachmentClass=class'WeaponCombatKnifeAtt'
     PickupViewMesh=Mesh'DeusExItems.CombatKnifePickup'
     FirstPersonViewMesh=Mesh'DeusExItems.CombatKnife'
     Mesh=Mesh'DeusExItems.CombatKnifePickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconCombatKnife'
     largeIconWidth=49
     largeIconHeight=45
     Description="An ultra-high carbon stainless steel knife."
     beltDescription="KNIFE"
     LowAmmoWaterMark=0
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.050000
     EnemyEffective=ENMEFF_Organic
     Concealability=CONC_Visual
     ReloadTime=0.000000
     HitDamage=5
     MaxRange=80
     AccurateRange=80
     BaseAccuracy=1.000000
     bHasMuzzleFlash=False
     bHandToHand=True
     bFallbackWeapon=True
     AmmoName=Class'DeusEx.AmmoNone'
     ReloadCount=0
     PickupAmmoCount=0
     bInstantHit=True
     FireOffset=(X=-5.000000,Y=8.000000,Z=14.000000)
     FireSound=Sound'DeusExSounds.Weapons.CombatKnifeFire'
     SelectSound=Sound'DeusExSounds.Weapons.CombatKnifeSelect'
     Misc1Sound=Sound'DeusExSounds.Weapons.CombatKnifeHitFlesh'
     Misc2Sound=Sound'DeusExSounds.Weapons.CombatKnifeHitHard'
     Misc3Sound=Sound'DeusExSounds.Weapons.CombatKnifeHitSoft'
     InventoryGroup=11
     ItemName="Combat Knife"
     PlayerViewOffset=(X=10.000000,Y=16.000000,Z=-13.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconCombatKnife'
     CollisionRadius=12.650000
     CollisionHeight=0.800000
}
