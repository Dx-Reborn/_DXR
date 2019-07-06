//=============================================================================
// WeaponSword.
//=============================================================================
class WeaponSwordInv extends coldarmsInv;

defaultproperties
{
     PickupClass=class'WeaponSword'
     AttachmentClass=class'WeaponSwordAtt'
     PickupViewMesh=VertMesh'DXRPickups.SwordPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.Sword'
     Mesh=VertMesh'DXRPickups.SwordPickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconSword'
     largeIconWidth=130
     largeIconHeight=40
     invSlotsX=3
     Description="A rather nasty-looking sword."
     beltDescription="SWORD"
     LowAmmoWaterMark=0
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.050000
     EnemyEffective=ENMEFF_Organic
     ReloadTime=0.000000
     MaxRange=64
     AccurateRange=64
     BaseAccuracy=1.000000
     bHasMuzzleFlash=False
     bHandToHand=True
     bFallbackWeapon=True
     AmmoName=Class'DeusEx.AmmoNoneInv'
     ReloadCount=0
     PickupAmmoCount=0
     bInstantHit=True
     FireOffset=(X=-25.000000,Y=10.000000,Z=24.000000)

     FireSound=Sound'DeusExSounds.Weapons.SwordFire'
     SelectSound=Sound'DeusExSounds.Weapons.SwordSelect'
     Misc1Sound=Sound'DeusExSounds.Weapons.SwordHitFlesh'
     Misc2Sound=Sound'DeusExSounds.Weapons.SwordHitHard'
     Misc3Sound=Sound'DeusExSounds.Weapons.SwordHitSoft'
     LandSound=Sound'DeusExSounds.Generic.DropLargeWeapon'
     InventoryGroup=13
     ItemName="Sword"
     PlayerViewOffset=(X=25.000000,Y=21.000000,Z=-26.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconSword'
     CollisionRadius=26.000000
     CollisionHeight=0.500000
     Mass=20.000000
}
