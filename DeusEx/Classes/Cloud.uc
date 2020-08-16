/*
   Cloud

   ToDo: подключить к этим projectiles генераторы частиц.
*/

class Cloud extends DeusExProjectile;

var bool bFloating;
var float cloudRadius;
var float damageInterval;
var class <DeusExEmitter> CloudEffectClass;
var DeusExEmitter CloudEffect; // Pointer to particle generator

function SpawnCloudEmitter()
{
    if (CloudEffectClass == None) // DXR: ≈сли класс не указан, то и делать нечего )
        return;

    if (CloudEffect == None)
    {
        CloudEffect = Spawn(CloudEffectClass, self, '', Location, Rotation);
        CloudEffect.SetPhysics(PHYS_Trailer); // DXR: attach emitter to this cloud
    }
}

event Destroyed()
{
    Super.Destroyed();

    if (CloudEffect != None)
        CloudEffect.Kill();
}

auto state Flying
{
    function HitWall(vector HitNormal, actor Wall)
    {
        // do nothing
        Velocity = vect(0,0,0);
    }

    function ProcessTouch(Actor Other, Vector HitLocation)
    {
        // do nothing
    }
}

event PhysicsVolumeChange(PhysicsVolume NewVolume)
{
    Super.PhysicsVolumeChange(NewVolume);

    // clouds can't live underwater, so kill us quickly if we enter the water
    if ((NewVolume.bWaterVolume) && (LifeSpan > 2.0))
        LifeSpan = 2.0;
}

event Timer()
{
    local Actor A;
    local Vector offset;

    // check to see if anything has entered our effect radius
    // don't damage our owner
    foreach VisibleActors(class'Actor', A, cloudRadius)
    if (A != Owner)
    {
        // be sure to damage the torso
        offset = A.Location;
        A.TakeDamage(Damage, Instigator, offset, vect(0,0,0), damageType);
    }
}

event Tick(float deltaTime)
{
    local float value;
    local float sizeMult;

    // don't Super.Tick() becuase we don't want gravity to affect the stream
    time += deltaTime;

    value = 1.0+time;
    if (MinDrawScale > 0)
        sizeMult = MaxDrawScale/MinDrawScale;
    else
        sizeMult = 1;

    SetDrawScale(MinDrawScale*(drawScale-sizeMult/(value*value) + (sizeMult+1)));
    ScaleGlow = FClamp(LifeSpan*0.5, 0.0, 1.0);

    // make it swim around a bit at random
    if (bFloating)
    {
        Acceleration = VRand() * 15;
        Acceleration.Z = 0;
    }
}

event BeginPlay()
{
    Super.BeginPlay();

    // set the cloud damage timer
    SetTimer(damageInterval, True);
    // DXR: Spawn particle generator
    SpawnCloudEmitter();

    // DXR: If there is an emitter, hide the sprite of this cloud.
    if (CloudEffect != None)
        SetDrawType(DT_None);
}

defaultproperties
{
     cloudRadius=128.000000
     damageInterval=1.000000
     blastRadius=1.000000
     DamageType=class'DM_PoisonGas'
     AccurateRange=100
     MaxRange=100
     maxDrawScale=5.000000
     bIgnoresNanoDefense=True
     ItemName="Gas Cloud"
     speed=300.000000
     MaxSpeed=300.000000
     Damage=1.000000
     MomentumTransfer=100
     LifeSpan=1.000000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=None
     DrawScale=0.010000
     bUnlit=True
     CollisionRadius=16.000000
     CollisionHeight=16.000000
}
