//=============================================================================
// WeaponNanoSword.
//=============================================================================
class WeaponNanoSwordInv extends coldarmsInv;

#exec OBJ LOAD FILE=DeusExItemsEx.utx

state DownWeapon
{
    function BeginState()
    {
        Super.BeginState();
        LightType = LT_None;
    }
}

state Idle
{
    function BeginState()
    {
        Super.BeginState();
        LightType = LT_Steady;
    }
}

auto state Pickup
{
    function EndState()
    {
        Super.EndState();
        LightType = LT_None;
    }
}

function Sound GetSelectSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetNanoSwordSelect(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetNanoSwordFire(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetNanoSwordHitFlesh(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetFireSound();
    }
    else return Super.GetFireSound();
}

function Sound GetHardHitSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetNanoSwordHitHard(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetFireSound();
    }
    else return Super.GetFireSound();
}

function Sound GetSoftHitSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetNanoSwordHitSoft(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetFireSound();
    }
    else return Super.GetFireSound();
}




defaultproperties
{
     PickupClass=class'WeaponNanoSword'
     AttachmentClass=class'WeaponNanoSwordAtt'
     PickupViewMesh=VertMesh'DXRPickups.NanoSwordPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.NanoSword'
     Mesh=VertMesh'DXRPickups.NanoSwordPickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconDragonTooth'
     largeIconWidth=205
     largeIconHeight=46
     invSlotsX=4
     Description="The true weapon of a modern warrior, the Dragon's Tooth is not a sword in the traditional sense, but a nanotechnologically constructed blade that is dynamically 'forged' on command into a non-eutactic solid. Nanoscale whetting devices insure that the blade is both unbreakable and lethally sharp."
     beltDescription="DRAGON"
     LowAmmoWaterMark=0
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.050000
     ReloadTime=0.000000
     HitDamage=20
     MaxRange=96
     AccurateRange=96
     BaseAccuracy=1.000000
     AreaOfEffect=AOE_Cone
     bHasMuzzleFlash=False
     bHandToHand=True
     FirstPersonViewSkins(0)=Texture'DeusExItems.Skins.WeaponHandsTex'
     FirstPersonViewSkins(1)=Shader'DeusExItemsEX.ExSkins.NanoSwordEx1'
     FirstPersonViewSkins(2)=Shader'DeusExItemsEX.ExSkins.NanoSwordEx1'
     FirstPersonViewSkins(3)=Texture'DeusExItems.Skins.NanoSwordTex1'
     FirstPersonViewSkins(4)=Shader'DeusExItemsEX.ExSkins.NanoSwordEx4'
     FirstPersonViewSkins(5)=Shader'DeusExItemsEX.ExSkins.NanoSwordEx3'
     FirstPersonViewSkins(6)=Shader'DeusExItemsEX.ExSkins.NanoSwordEx2'

     PickupViewSkins(0)=Texture'DeusExItems.Skins.NanoSword3rdTex1'
     PickupViewSkins(1)=Texture'DeusExItems.Skins.NanoSword3rdTex1'
     PickupViewSkins(2)=Texture'DeusExItems.Skins.PinkMaskTex'
     PickupViewSkins(3)=Texture'DeusExItems.Skins.PinkMaskTex'
     PickupViewSkins(4)=Shader'DeusExItemsEX.ExSkins.NanoSwordEx4'
     PickupViewSkins(5)=Shader'DeusExItemsEX.ExSkins.NanoSwordEx3'

     SwingOffset=(X=24.000000,Z=2.000000)
     AmmoName=Class'DeusEx.AmmoNoneInv'
     ReloadCount=0
     PickupAmmoCount=0
     bInstantHit=True
     FireOffset=(X=-21.000000,Y=16.000000,Z=27.000000)

     FireSound=Sound'DeusExSounds.Weapons.NanoSwordFire'
     SelectSound=Sound'DeusExSounds.Weapons.NanoSwordSelect'
     Misc1Sound=Sound'DeusExSounds.Weapons.NanoSwordHitFlesh'
     Misc2Sound=Sound'DeusExSounds.Weapons.NanoSwordHitHard'
     Misc3Sound=Sound'DeusExSounds.Weapons.NanoSwordHitSoft'
     LandSound=Sound'DeusExSounds.Generic.DropLargeWeapon'

     InventoryGroup=14
     ItemName="Dragon's Tooth Sword"

     PlayerViewPivot=(Pitch=0,Roll=0,Yaw=-32768) // Развернуть модель
     PlayerViewOffset=(X=21.000000,Y=19.000000,Z=-27.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconDragonTooth'
     CollisionRadius=32.000000
     CollisionHeight=2.400000
     LightEffect=LE_None
     LightType=LT_SubtlePulse
     LightBrightness=224
     LightHue=160
     LightSaturation=64
     LightRadius=4
     bDynamicLight=true
     Mass=20.000000
}
