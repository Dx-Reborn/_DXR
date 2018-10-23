//=============================================================================
// WeaponNPCMelee.
//=============================================================================
class WeaponNPCMelee extends DeusExWeaponInv
	abstract;

defaultproperties
{
    LowAmmoWaterMark=0
    NoiseLevel=0.10
    EnemyEffective=1
    ShotTime=0.30
    reloadTime=0.00
    BaseAccuracy=1.00
    bHasMuzzleFlash=False
    bHandToHand=True
    bOwnerWillNotify=True
    bNativeAttack=True
    AmmoName=class'AmmoNoneInv'
    ReloadCount=0
    bInstantHit=True
    Misc1Sound=Sound'DeusExSounds.Weapons.CombatKnifeHitFlesh'
    Misc2Sound=Sound'DeusExSounds.Weapons.CombatKnifeHitHard'
    Misc3Sound=Sound'DeusExSounds.Weapons.CombatKnifeHitSoft'
    InventoryGroup=99
    PlayerViewOffset=(X=0.00,Y=0.00,Z=0.00)

    PickupViewMesh=VertMesh'DXRPickups.GEPGunPickup'
    FirstPersonViewMesh=Mesh'DeusExItems.InvisibleWeapon'
    Mesh=Mesh'DeusExItems.InvisibleWeapon'

    Icon=None
    largeIconWidth=1
    largeIconHeight=1
    CollisionRadius=1.00
    CollisionHeight=1.00
}
