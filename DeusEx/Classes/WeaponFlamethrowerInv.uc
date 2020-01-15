//=============================================================================
// WeaponFlamethrower.
// 
//=============================================================================
class WeaponFlamethrowerInv extends DeusExWeaponInv;

var() int BurnTime, BurnDamage;
var EM_FlameThrower flame; // Частицы 
var bool bFlameExists;



function SetFlame()
{
  local rotator r;

  if (flame != None)
  {
    r.Yaw = 32768;
    AttachToBone(flame, '114'); // ближайшая косточка
    SetBoneRotation('114', r, 0, 1.f); // Повернуть косточку
    return;
  }

  if (IsInState('reload'))
  return;

//  log(self@"setting up flame...");

  if (flame == none) 
  {
    flame = spawn(class'EM_FlameThrower');
    bFlameExists = true;
    flame.Emitters[0].SecondsBeforeInactive = 0.1;
  }
}

event WeaponTick(float dt)
{
  super.WeaponTick(dt);

  if (GetAnimSequence() == 'Shoot')
      SetFlame();
  else if (flame != none)
  {
     flame.kill();
     bFlameExists = false;
  }
}

function Sound GetSelectSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetFlamethrowerSelect(gl.WS_Preset);
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
        sound = class'DXRWeaponSoundManager'.static.GetFlamethrowerFire(gl.WS_Preset);

        if (sound != None)
        return sound;
        else
        return Super.GetFireSound();
    }
    else return Super.GetFireSound();
}


defaultproperties
{
     AttachmentClass=class'WeaponFlamethrowerAtt'
     PickupClass=class'WeaponFlamethrower'
     PickupViewMesh=VertMesh'DXRPickups.FlamethrowerPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.Flamethrower'
     Mesh=VertMesh'DXRPickups.FlamethrowerPickup'

     BurnTime=30
     BurnDamage=5
     largeIcon=Texture'DeusExUI.Icons.LargeIconFlamethrower'
     largeIconWidth=203
     largeIconHeight=69
     invSlotsX=4
     invSlotsY=2
     Description="A portable flamethrower that discards the old and highly dangerous backpack fuel delivery system in favor of pressurized canisters of napalm. Inexperienced agents will find that a flamethrower can be difficult to maneuver, however."
     beltDescription="FLAMETH"
     LowAmmoWaterMark=50
     GoverningSkill=Class'DeusEx.SkillWeaponHeavy'
     EnviroEffective=ENVEFF_Air
     bAutomatic=True
     ShotTime=0.100000
     ReloadTime=5.500000
     HitDamage=2
     MaxRange=320
     AccurateRange=320
     BaseAccuracy=0.900000
     bHasMuzzleFlash=False
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     AmmoName=Class'DeusEx.AmmoNapalmInv'
     ReloadCount=100
     PickupAmmoCount=100
     FireOffset=(Y=10.000000,Z=10.000000)
     ProjectileClass=Class'DeusEx.InvisibleFireball'

     FireSound=Sound'DeusExSounds.Weapons.FlamethrowerFire'
     ReloadEndSound=Sound'DeusExSounds.Weapons.FlamethrowerReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.FlamethrowerReload'
     SelectSound=Sound'DeusExSounds.Weapons.FlamethrowerSelect'
     LandSound=Sound'DeusExSounds.Generic.DropLargeWeapon'

     InventoryGroup=15
     ItemName="Flamethrower"
     PlayerViewOffset=(X=20.000000,Y=22.000000,Z=-16.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconFlamethrower'
     CollisionRadius=20.500000
     CollisionHeight=4.400000
     Mass=40.000000
     bFullVolume=false
}
