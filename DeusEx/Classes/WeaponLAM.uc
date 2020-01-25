//=============================================================================
// WeaponLAM.
//=============================================================================
class WeaponLAM extends WeaponGrenade;

var localized String shortName;

function Fire(float Value)
{
    // if facing a wall, affix the LAM to the wall
    if (Pawn(Owner) != None)
    {
        if (bNearWall)
        {
            AmmoType.UseAmmo(1);
            bReadyToFire = False;
            GotoState('NormalFire');
            bPointing = True;
            PlayAnim('Place',, 0.1);
            return;
        }
    }
    // otherwise, throw as usual
    Super.Fire(Value);
}

function Sound GetSelectSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetLAMSelect(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetLAMFire(gl.WS_Preset);
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

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetLAMDown(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetDownSound();
    }
    else return Super.GetDownSound();
}



defaultproperties
{
     AttachmentClass=class'WeaponLAMAtt'
     PickupViewMesh=Mesh'DeusExItems.LAMPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.LAM'
     Mesh=Mesh'DeusExItems.LAMPickup'

     ShortName="LAM"
     largeIcon=Texture'DeusExUI.Icons.LargeIconLAM'
     largeIconWidth=35
     largeIconHeight=45
     Description="A multi-functional explosive with electronic priming system that can either be thrown or attached to any surface with its polyhesive backing and used as a proximity mine.|n|n<UNATCO OPS FILE NOTE SC093-BLUE> Disarming a proximity device should only be attempted with the proper demolitions training. Trust me on this. -- Sam Carter <END NOTE>"
     beltDescription="LAM"
     LowAmmoWaterMark=2
     GoverningSkill=Class'DeusEx.SkillDemolition'
     EnviroEffective=ENVEFF_AirWater
     Concealability=CONC_All
     ShotTime=0.300000
     ReloadTime=0.100000
     HitDamage=50
     MaxRange=4800
     AccurateRange=2400
     BaseAccuracy=1.000000
     bHasMuzzleFlash=False
     bHandToHand=True
     bUseAsDrawnWeapon=False
     AITimeLimit=3.500000
     AIFireDelay=5.000000
     AmmoName=Class'DeusEx.AmmoLAM'
     ReloadCount=1
     PickupAmmoCount=1
     FireOffset=(Y=10.000000,Z=20.000000)
     ProjectileClass=Class'DeusEx.LAM'

     SelectSound=Sound'DeusExSounds.Weapons.LAMSelect'
     LandSound=Sound'DeusExSounds.Generic.DropLargeWeapon'

     InventoryGroup=20
     ItemName="Lightweight Attack Munitions (LAM)"
     PlayerViewOffset=(X=24.000000,Y=21.000000,Z=-20.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconLAM'
     CollisionRadius=3.800000
     CollisionHeight=3.500000
     Mass=5.000000
     Buoyancy=2.000000
}
