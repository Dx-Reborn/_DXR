//=============================================================================
// PlasmaBolt.
//=============================================================================
class PlasmaBolt extends DeusExProjectile;

var ParticleGenerator pGen1;
var ParticleGenerator pGen2;

var float mpDamage;
var float mpBlastRadius;

#exec OBJ LOAD FILE=Effects





// DEUS_EX AMSD Should not be called as server propagating to clients.

defaultproperties
{
     mpDamage=8.000000
     mpBlastRadius=300.000000
     bExplodes=True
     blastRadius=128.000000
     DamageType=class'DM_Burned'
     AccurateRange=14400
     MaxRange=24000
     bIgnoresNanoDefense=True
     ItemName="Plasma Bolt"
     //  ItemArticle="a"
     speed=1500.000000
     MaxSpeed=1500.000000
     Damage=40.000000
     MomentumTransfer=5000
     ImpactSound=Sound'DeusExSounds.Weapons.PlasmaRifleHit'
     ExplosionDecal=Class'DeusEx.ScorchMark'
     Mesh=Mesh'DeusExItems.PlasmaBolt'
     DrawScale=3.000000
     bUnlit=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=200
     LightHue=80
     LightSaturation=128
     LightRadius=3
     bFixedRotationDir=True
}
