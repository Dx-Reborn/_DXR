//=============================================================================
// WeaponRifle.
//=============================================================================
class WeaponRifleInv extends DeusExWeaponInv;

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
    local ShellCasing s;
    local coords K;

    K = GetBoneCoords('127');

     Super.ProcessTraceHit(Other, HitLocation, HitNormal, X, Y, Z);

     s = Spawn(class'ShellCasing',, '', K.Origin);
     if (S != None)
     {
         s.SetRotation(rot(0,0,32768));
         s.SetDrawScale3D(vect(1, 2, 1));
         s.Velocity = (FRand()*20+75) * Y + (10-FRand()*20) * X;
         s.Velocity.Z += 200;
     }
}        

defaultproperties
{
     AttachmentClass=class'WeaponRifleAtt'
     PickupClass=class'WeaponRifle'
     PickupViewMesh=VertMesh'DXRPickups.SniperRiflePickup'
     FirstPersonViewMesh=Mesh'DeusExItems.SniperRifle'
     Mesh=VertMesh'DXRPickups.SniperRiflePickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconRifle'
     largeIconWidth=159
     largeIconHeight=47
     invSlotsX=4
     Description="The military sniper rifle is the superior tool for the interdiction of long-range targets. When coupled with the proven 30.06 round, a marksman can achieve tight groupings at better than 1 MOA (minute of angle) depending on environmental conditions."
     beltDescription="SNIPER"
     LowAmmoWaterMark=6
     GoverningSkill=Class'DeusEx.SkillWeaponRifle'
     NoiseLevel=2.000000
     EnviroEffective=ENVEFF_Air
     ShotTime=1.500000
     ReloadTime=2.000000
     HitDamage=25
     MaxRange=48000
     AccurateRange=28800
     bCanHaveScope=True
     bHasScope=True
     bCanHaveLaser=True
     bCanHaveSilencer=True
     bHasMuzzleFlash=False
     recoilStrength=0.400000
     bUseWhileCrouched=False
     bCanHaveModBaseAccuracy=True
     bCanHaveModReloadCount=True
     bCanHaveModAccurateRange=True
     bCanHaveModReloadTime=True
     bCanHaveModRecoilStrength=True
     AmmoName=Class'DeusEx.Ammo3006inv'
     ReloadCount=6
     PickupAmmoCount=6
     bInstantHit=True
     FireOffset=(X=-20.000000,Y=2.000000,Z=30.000000)

     FireSound=Sound'DeusExSounds.Weapons.RifleFire'
     ReloadEndSound=Sound'DeusExSounds.Weapons.RifleReloadEnd'
     CockingSound=Sound'DeusExSounds.Weapons.RifleReload'
     SelectSound=Sound'DeusExSounds.Weapons.RifleSelect'
     LandSound=Sound'DeusExSounds.Generic.DropMediumWeapon'

     InventoryGroup=5
     ItemName="Sniper Rifle"
     PlayerViewOffset=(X=20.000000,Y=10.000000,Z=-35.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconRifle'
     CollisionRadius=26.000000
     CollisionHeight=2.000000
     Mass=30.000000
}
