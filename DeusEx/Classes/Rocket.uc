//=============================================================================
// Rocket.
//=============================================================================
class Rocket extends DeusExProjectile;

var EM_ThinTrail fsGen;

function PostBeginPlay()
{
    Super.PostBeginPlay();
    SpawnRocketEffects();
}

function SpawnRocketEffects()
{
  fsGen = Spawn(class'EM_ThinTrail', Self);
    if (fsGen != None)
        fsGen.SetBase(Self);
}

event Destroyed()
{
  if (fsGen != None)
        fsGen.Kill();

    Super.Destroyed();
}

defaultproperties
{
     bExplodes=True
     bBlood=True
     bDebris=True
     blastRadius=192.000000
     DamageType=class'DM_exploded'
     AccurateRange=14400
     MaxRange=24000
     bTracking=True
     ItemName="GEP Rocket"
     speed=1000.000000
     MaxSpeed=1500.000000
     Damage=300.000000
     MomentumTransfer=10000
     SpawnSound=Sound'DeusExSounds.Weapons.GEPGunFire'
     ImpactSound=Sound'DeusExSounds.Generic.SmallExplosion1'
     ExplosionDecal=Class'DeusEx.ScorchMark'
     AmbientSound=Sound'DeusExSounds.Special.RocketLoop'
     Mesh=Mesh'DeusExItems.Rocket'
     DrawScale=0.250000
     SoundRadius=16
//     SoundVolume=224
     RotationRate=(Pitch=32768,Yaw=32768)
}
