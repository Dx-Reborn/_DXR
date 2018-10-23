//=============================================================================
// WeaponCombatKnife.
//=============================================================================
class WeaponCombatKnifeInv extends coldarmsInv;


defaultproperties
{
		 PickupClass=class'WeaponCombatKnife'
     AttachmentClass=class'WeaponCombatKnifeAtt'
     PickupViewMesh=VertMesh'DXRPickups.CombatKnifePickup'
     FirstPersonViewMesh=Mesh'DeusExItems.CombatKnife'
     Mesh=VertMesh'DXRPickups.CombatKnifePickup'

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
