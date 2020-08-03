//=============================================================================
// SpyDrone.
//=============================================================================
class SpyDrone extends ThrownProjectile;

auto state Flying
{
    function ProcessTouch (Actor Other, Vector HitLocation)
    {
        // do nothing
    }
    function HitWall (vector HitNormal, actor HitWall)
    {
        // do nothing
    }
}

event Tick(float deltaTime)
{
    // do nothing
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, class<damageType> damageType)
{
    // fall to the ground if EMP'ed
    if ((DamageType == class'DM_EMP') && !bDisabled)
    {
        SetPhysics(PHYS_Falling);
        bBounce = True;
        LifeSpan = 10.0;
    }
    Super.TakeDamage(Damage, instigatedBy, HitLocation, Momentum, damageType);
}

event BeginPlay()
{
    // do nothing
}

event Destroyed()
{
    if (DeusExPlayer(Owner) != None)
        DeusExPlayer(Owner).aDrone = None;

    Super.Destroyed();
}


function bool SpecialCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation, bool bBehindView)
{
    local vector HitNormal, HitLocation;

    log(self@"SpecialCalcView");
    viewactor = self;

    if (!bBehindView)
        CameraLocation = Location + (vect(-800,0,300) >> Rotation);
//        CameraLocation = Location + (MortarCameraOffset >> Rotation);
    else
        CameraLocation = Location + (vect(-800,0,300) >> CameraRotation);

    if( Trace( HitLocation, HitNormal, CameraLocation, Location,false,vect(10,10,10) ) != None )
        CameraLocation = HitLocation;

    return True;
}


defaultproperties
{
     elasticity=0.200000
     fuseLength=0.000000
     proxRadius=128.000000
     bHighlight=False
     bBlood=False
     bDebris=False
     blastRadius=128.000000
     DamageType=class'DM_EMP'
     bEmitDanger=False
     ItemName="Remote Spy Drone"
     MaxSpeed=0.000000
     Damage=20.000000
     ImpactSound=Sound'DeusExSounds.Generic.SmallExplosion2'
     Physics=PHYS_Projectile
     RemoteRole=ROLE_DumbProxy
     LifeSpan=0.000000
     AmbientSound=Sound'DeusExSounds.Augmentation.AugDroneLoop'
     Mesh=mesh'DeusExCharacters.SpyDrone'
     SoundRadius=24
     SoundVolume=192
     CollisionRadius=13.000000
     CollisionHeight=2.760000
     Mass=10.000000
     Buoyancy=2.000000

     bSpecialCalcView=true
}
