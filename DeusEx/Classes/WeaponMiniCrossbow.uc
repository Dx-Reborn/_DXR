//=============================================================================
// WeaponMiniCrossbow.
//=============================================================================
class WeaponMiniCrossbow extends DeusExWeapon;

// pinkmask out the arrow when we're out of ammo or the clip is empty
state NormalFire
{
    function BeginState()
    {
        if (ClipCount >= ReloadCount)
            Skins[3] = Texture'PinkMaskTex';

        if ((AmmoType != None) && (AmmoType.AmmoAmount <= 0))
            Skins[3] = Texture'PinkMaskTex';
    
        Super.BeginState();
    }
}

// unpinkmask the arrow when we reload
function WeaponTick(float deltaTime)
{
    if (Skins[3] != None)
        if ((AmmoType != None) && (AmmoType.AmmoAmount > 0) && (ClipCount < ReloadCount))
            Skins[3] = default.skins[3];

    Super.WeaponTick(deltaTime);
}

function Sound GetSelectSound()
{
    local DeusExGlobals gl;
    local sound sound;

    if (bPostTravel)
        return None;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetMiniCrossbowSelect(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetSelectSound();
    }
    else return Super.GetSelectSound();
}

function Sound GetSilencedSound()//GetFireSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetMiniCrossbowFire(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Sound'MiniCrossbowFire';
    }
    else return Sound'MiniCrossbowFire';//Super.GetSilencedSound();
}

function Sound GetReloadBeginSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetMiniCrossbowReloadBegin(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetMiniCrossbowReloadEnd(gl.WS_Preset);
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

    bPostTravel = false;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetMiniCrossbowDown(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetDownSound();
    }
    else return Super.GetDownSound();
}



defaultproperties
{
     AttachmentClass=class'WeaponMiniCrossbowAtt'
     PickupViewMesh=Mesh'DeusExItems.MiniCrossbowPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.MiniCrossbow'
     Mesh=Mesh'DeusExItems.MiniCrossbowPickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconCrossbow'
     largeIconWidth=47
     largeIconHeight=46
     Description="The mini-crossbow was specifically developed for espionage work, and accepts a range of dart types (normal, tranquilizer, or flare) that can be changed depending upon the mission requirements."
     beltDescription="X-BOW"
     LowAmmoWaterMark=4
     GoverningSkill=Class'DeusEx.SkillWeaponPistol'
     NoiseLevel=0.050000
     EnemyEffective=ENMEFF_Organic
     Concealability=CONC_All
     ShotTime=0.800000
     ReloadTime=2.000000
     HitDamage=25
     MaxRange=1600
     AccurateRange=800
     BaseAccuracy=0.800000
     bCanHaveScope=True
     ScopeFOV=15
     bCanHaveLaser=True
     bHasSilencer=True
     AmmoNames(0)=Class'DeusEx.AmmoDartPoison'
     AmmoNames(1)=Class'DeusEx.AmmoDart'
     AmmoNames(2)=Class'DeusEx.AmmoDartFlare'
     ProjectileNames(0)=Class'DeusEx.DartPoison'
     ProjectileNames(1)=Class'DeusEx.Dart'
     ProjectileNames(2)=Class'DeusEx.DartFlare'
     StunDuration=10.000000
     bHasMuzzleFlash=False
     bCanHaveModBaseAccuracy=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     AmmoName=Class'DeusEx.AmmoDartPoison'
     ReloadCount=4
     PickupAmmoCount=4
     //FireOffset=(X=-25.000000,Y=8.000000,Z=14.000000)

     ProjSpawnOffset=(X=25.000000,Y=8.000000,Z=-14.000000) //(X=-15.00,Y=8.00,Z=-5.00) // (X=-25.000000,Y=8.000000,Z=16.000000)
     ProjectileClass=Class'DeusEx.DartPoison'
     FireSound=Sound'DeusExSounds.Weapons.MiniCrossbowFire'
     ReloadEndSound=Sound'DeusExSounds.Weapons.MiniCrossbowReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.MiniCrossbowReload'
     SelectSound=Sound'DeusExSounds.Weapons.MiniCrossbowSelect'
     InventoryGroup=9
     ItemName="Mini-Crossbow"
     PlayerViewOffset=(X=25.00,Y=8.00,Z=-14.00)  //(X=25.000000,Y=13.000000,Z=-14.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconCrossbow'
     CollisionRadius=8.00
     CollisionHeight=3.00
//     CollisionHeight=1.000000
     Mass=15.000000

     FirstPersonViewSkins(0)=Texture'DeusExItems.Skins.MiniCrossbowTex1'
     FirstPersonViewSkins(1)=Texture'DeusExItems.Skins.MiniCrossbowTex2'
     FirstPersonViewSkins(2)=Texture'DeusExItems.Skins.MiniCrossbowTex2'
     FirstPersonViewSkins(3)=Texture'DeusExItems.Skins.MiniCrossbowTex2'
}
