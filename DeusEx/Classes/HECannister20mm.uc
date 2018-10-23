//=============================================================================
// HECannister20mm.
//=============================================================================
class HECannister20mm extends DeusExProjectile;

var ParticleGenerator smokeGen;

defaultproperties
{
     bExplodes=True
     bBlood=True
     bDebris=True
     blastRadius=512.000000
     DamageType=class'DM_exploded'
     AccurateRange=400
     MaxRange=800
     ItemName="HE 20mm Shell"
     //  ItemArticle="a"
     speed=1000.000000
     MaxSpeed=1000.000000
     Damage=150.000000
     MomentumTransfer=40000
     SpawnSound=Sound'DeusExSounds.Weapons.GEPGunFire'
     ImpactSound=Sound'DeusExSounds.Generic.MediumExplosion2'
     ExplosionDecal=Class'DeusEx.ScorchMark'
     Mesh=Mesh'DeusExItems.HECannister20mm'
}
