//=============================================================================
// WeaponSpiderBot.
//=============================================================================
class WeaponSpiderBot extends WeaponNPCRanged;

var Electricityemitter EE_emitter;
var float zapTimer;
var vector lastHitLocation;
var int shockDamage;

// force EMP damage
function class<DamageType> WeaponDamageType()
{
    return class'DM_EMP';
}

// intercept the hit and turn on the EE_emitter
function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
    Super.ProcessTraceHit(Other, HitLocation, HitNormal, X, Y, Z);

    zapTimer = 0.5;
    if (EE_emitter != None)
    {
        EE_emitter.SetLocation(Owner.Location);
        EE_emitter.SetRotation(Rotator(HitLocation - EE_emitter.Location));
        EE_emitter.TurnOn();
        EE_emitter.SetBase(Owner);
        lastHitLocation = HitLocation;
    }
}

event Tick(float deltaTime)
{
    Super.Tick(deltaTime);

    if (zapTimer > 0)
    {
        zapTimer -= deltaTime;

        // update the rotation of the EE_emitter
        EE_emitter.SetRotation(Rotator(lastHitLocation - EE_emitter.Location));

        // turn off the electricity after the timer has expired
        if (zapTimer < 0)
        {
            zapTimer = 0;
            EE_emitter.TurnOff();
        }
    }
}

event Destroyed()
{
    if (EE_emitter != None)
    {
        EE_emitter.Destroy();
        EE_emitter = None;
    }

    Super.Destroyed();
}

event PostBeginPlay()
{
    Super.PostBeginPlay();

    zapTimer = 0;
    EE_emitter = Spawn(class'Electricityemitter', Self);
    if (EE_emitter != None)
    {
        EE_emitter.bFlicker = False;
        EE_emitter.randomAngle = 1024;
        EE_emitter.damageAmount = shockDamage;
        EE_emitter.TurnOff();
        EE_emitter.Instigator = Pawn(Owner);
    }
}

defaultproperties
{
    shockDamage=15
    ShotTime=1.50
    HitDamage=25
    maxRange=1280
    AccurateRange=640
    BaseAccuracy=0.00
    AmmoName=Class'AmmoBattery'
    PickupAmmoCount=20
    bInstantHit=True
    FireSound=Sound'DeusExSounds.Weapons.ProdFire'
}
