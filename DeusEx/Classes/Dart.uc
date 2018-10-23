//=============================================================================
// Dart.
//=============================================================================
class Dart extends DeusExProjectile;

defaultproperties
{
     bBlood=True
     bStickToWall=True
     DamageType=class'DM_shot'
     spawnAmmoClass=Class'DeusEx.AmmoDartInv'
     bIgnoresNanoDefense=True
     ItemName="Dart"
     speed=2000.000000
     MaxSpeed=3000.000000
     Damage=15.000000
     MomentumTransfer=1000
     ImpactSound=Sound'DeusExSounds.Generic.BulletHitFlesh'
     Mesh=Mesh'DeusExItems.Dart'
     CollisionRadius=3.000000
     CollisionHeight=0.500000
}
