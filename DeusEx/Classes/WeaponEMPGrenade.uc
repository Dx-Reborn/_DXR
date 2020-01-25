//=============================================================================
// WeaponEMPGrenade.
//=============================================================================
class WeaponEMPGrenade extends WeaponGrenade;

function Fire(float Value)
{
    // if facing a wall, affix the EMPGrenade to the wall
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

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
    local Projectile proj;

    proj = Super.ProjectileFire(ProjClass, ProjSpeed, bWarn);

    if (proj != None)
        proj.PlayAnim('Open');

    return proj;
}


function Sound GetSelectSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetEMPGrenadeSelect(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetEMPGrenadeFire(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetEMPGrenadeDown(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetDownSound();
    }
    else return Super.GetDownSound();
}



defaultproperties
{
     AttachmentClass=class'WeaponEMPGrenadeAtt'
     PickupViewMesh=Mesh'DeusExItems.EMPGrenadePickup'
     FirstPersonViewMesh=Mesh'DeusExItems.EMPGrenade'
     Mesh=Mesh'DeusExItems.EMPGrenadePickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconEMPGrenade'
     largeIconWidth=31
     largeIconHeight=49
     Description="The EMP grenade creates a localized pulse that will temporarily disable all electronics within its area of effect, including cameras and security grids.|n|n<UNATCO OPS FILE NOTE JR134-VIOLET> While nanotech augmentations are largely unaffected by EMP, experiments have shown that it WILL cause the spontaneous dissipation of stored bioelectric energy. -- Jaime Reyes <END NOTE>"
     beltDescription="EMP GREN"
     LowAmmoWaterMark=2
     GoverningSkill=Class'DeusEx.SkillDemolition'
     EnemyEffective=ENMEFF_Robot
     Concealability=CONC_Visual
     ShotTime=0.300000
     ReloadTime=0.100000
     HitDamage=0
     MaxRange=4800
     AccurateRange=2400
     BaseAccuracy=1.000000
     bPenetrating=False
     StunDuration=60.000000
     bHasMuzzleFlash=False
     bHandToHand=True
     bUseAsDrawnWeapon=False
     AITimeLimit=3.500000
     AIFireDelay=5.000000
     AmmoName=Class'DeusEx.AmmoEMPGrenade'
     ReloadCount=1
     PickupAmmoCount=1
     FireOffset=(Y=10.000000,Z=20.000000)
     ProjectileClass=Class'DeusEx.EMPGrenade'
     SelectSound=Sound'DeusExSounds.Weapons.EMPGrenadeSelect'
     InventoryGroup=22
     ItemName="Electromagnetic Pulse (EMP) Grenade"
     PlayerViewOffset=(X=24.000000,Y=24.000000,Z=-19.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconEMPGrenade'
     CollisionRadius=3.000000
     CollisionHeight=2.430000
     Mass=5.000000
     Buoyancy=2.000000
}
