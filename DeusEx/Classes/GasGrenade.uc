//=============================================================================
// GasGrenade.
//=============================================================================
class GasGrenade extends ThrownProjectile;

defaultproperties
{
     fuseLength=3.000000
     proxRadius=128.000000
     AISoundLevel=0.000000
     bBlood=False
     bDebris=False
     DamageType=class'DM_TearGas'
     spawnWeaponClass=Class'DeusEx.WeaponGasGrenadeInv'
     ItemName="Gas Grenade"
     speed=1000.000000
     MaxSpeed=1000.000000
     Damage=10.000000
     MomentumTransfer=50000
     ImpactSound=Sound'DeusExSounds.Weapons.GasGrenadeExplode'
     LifeSpan=0.000000
     Mesh=Mesh'DeusExItems.GasGrenadePickup'
     CollisionRadius=4.300000
     CollisionHeight=1.400000
     Mass=5.000000
     Buoyancy=2.000000
}
