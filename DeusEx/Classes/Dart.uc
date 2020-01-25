//=============================================================================
// Dart.
//=============================================================================
class Dart extends DeusExProjectile;

var EM_ThinTrail_A trail;

event BeginPlay()
{
   Super.BeginPlay();
   AddTrail();
}

function AddTrail()
{
   if (trail == None)
       trail = Spawn(class'EM_ThinTrail_A',self,,Location,);
       trail.SetBase(self);
}

event Destroyed()
{
   Super.Destroyed();

   if (Trail != None)
       trail.Kill();
}

auto state Flying
{
    function ProcessTouch(Actor Other, vector HitLocation)
    {
        Super.ProcessTouch(Other, HitLocation);
        if (Trail != None)
            trail.Kill();
    }

    event HitWall(vector HitNormal, actor Wall)
    {
        Super.HitWall(HitNormal, Wall);
        if (Trail != None)
            trail.Kill();
    }
}



defaultproperties
{
     bBlood=True
     bStickToWall=True
     DamageType=class'DM_shot'
     spawnAmmoClass=Class'DeusEx.AmmoDart'
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
