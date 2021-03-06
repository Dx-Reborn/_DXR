//=============================================================================
// Trash.
//=============================================================================
class Trash extends DeusExDecoration
    abstract;

var Vector dir;
var Rotator rot;
var float time;
var float rnd;
var bool bStopped;
var Vector lastLoc;

event Tick(float deltaTime)
{
    Super.Tick(deltaTime);

    if (!bFloating && !bStopped)
    {
        Velocity = dir * rnd;

        if (time >= 1.0)
        {
            rnd = FRand() * 0.2 + 0.8;
            RotationRate = rot * rnd;
            time = 0;
        }
        time += deltaTime;

        // if we haven't moved much since the last frame, stop moving
        if (VSize(Location - lastLoc) < 0.1)
            StopMoving();

        lastLoc = Location;
    }
}

event Timer()
{
    Destroy();
}

singular function RotateTrash()
{
    dir = vect(0,0,0);
    Velocity = dir;
    RotationRate = rot(0,0,0);
    rot = rot(0,0,0);
    rot.Yaw = FRand() * 65535;
    SetRotation(rot);
}


function StopMoving()
{
    RotateTrash();

    bFixedRotationDir = False;
    SetCollisionSize(default.CollisionRadius, 0.1);
    SetPhysics(PHYS_Falling);
    PlayAnim('Still');
    bStopped = True;

    // die after some random time
    SetTimer(10*FRand()+20, False);
}

event PhysicsVolumeChange(PhysicsVolume Volume)
{
    if (Volume.bWaterVolume)
        StopMoving();

    Super.PhysicsVolumeChange(Volume);
} 

event HitWall(vector HitNormal, actor Wall)
{
    Velocity = (Velocity dot HitNormal) * HitNormal * (-2.0) + Velocity;
}

event BeginPlay()
{
    Super.BeginPlay();

    lastLoc = Location + vect(100,0,0);
    if (IsA('TrashPaper'))
        LoopAnim('Blowing');
}



defaultproperties
{
     Time=1.000000
     rnd=1.000000
     bHighlight=False
     bPushable=False
     LifeSpan=30.000000
     Mesh=None
     bBlockActors=False
     bBlockPlayers=False
     bFixedRotationDir=True
     Mass=2.000000
     Buoyancy=3.000000
}
