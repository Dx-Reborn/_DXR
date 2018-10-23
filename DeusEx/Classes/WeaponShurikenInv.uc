//=============================================================================
// WeaponShuriken.
//=============================================================================
class WeaponShurikenInv extends DeusExWeaponInv;

defaultproperties
{
		 PickupClass=class'WeaponShuriken'
     PickupViewMesh=VertMesh'DXRPickups.ShurikenPickup'
     FirstPersonViewMesh=Mesh'DeusExItems.Shuriken'
     Mesh=VertMesh'DXRPickups.ShurikenPickup'

     largeIcon=Texture'DeusExUI.Icons.LargeIconShuriken'
     largeIconWidth=36
     largeIconHeight=45
     Description="A favorite weapon of assassins in the Far East for centuries, throwing knives can be deadly when wielded by a master but are more generally used when it becomes desirable to send a message. The message is usually 'Your death is coming on swift feet.'"
     beltDescription="THW KNIFE"
     LowAmmoWaterMark=5
     GoverningSkill=Class'DeusEx.SkillWeaponLowTech'
     NoiseLevel=0.050000
     EnemyEffective=ENMEFF_Organic
     EnviroEffective=ENVEFF_AirVacuum
     Concealability=CONC_Visual
     ShotTime=0.200000
     ReloadTime=0.200000
     HitDamage=15
     MaxRange=1280
     AccurateRange=640
     BaseAccuracy=0.900000
     bHasMuzzleFlash=False
     bHandToHand=True
     AmmoName=Class'DeusEx.AmmoShurikenInv'
     ReloadCount=1
     PickupAmmoCount=5
     FireOffset=(X=-10.00,Y=14.00,Z=22.00),
 //    FireOffset=(X=-10.000000,Y=-21.000000,Z=38.000000)
     ProjectileClass=Class'DeusEx.Shuriken'
     InventoryGroup=12
     ItemName="Throwing Knives"
     PlayerViewOffset=(X=24.000000,Y=18.000000,Z=-30.000000)

     Icon=Texture'DeusExUI.Icons.BeltIconShuriken'
     CollisionRadius=7.500000
     CollisionHeight=0.300000
}
