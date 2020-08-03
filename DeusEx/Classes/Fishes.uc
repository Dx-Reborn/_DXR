//=============================================================================
// Fishes.
//=============================================================================
class Fishes extends Animal
    abstract;

var   float leaderTimer;
var   float forwardTimer;
var   float bumpTimer;
var   float abortTimer;
var   float breatheTimer;
var() bool  bFlock;
var() bool  bStayHorizontal;

event PostBeginPlay()
{
    Super.PostBeginPlay();

    ResetLeaderTimer();
    forwardTimer = -1;
    bumpTimer    = 0;
    abortTimer   = -1;
    breatheTimer = 0;
}

function ResetLeaderTimer()
{
    leaderTimer = FRand()*10.0+5;
}

function ResetForwardTimer()
{
    forwardTimer = FRand()*10.0+2;
}

function bool IsNearHome(vector position)
{
    local bool          bNear;
    local PawnGenerator genOwner;

    bNear = true;
    if (bUseHome)
    {
        genOwner = PawnGenerator(Owner);
        if (genOwner == None)
        {
            if (VSize(HomeLoc-((position-Location)+genOwner.FlockCenter)) > HomeExtent)
                bNear = false;
        }
        else
        {
            if (VSize(HomeLoc-position) > HomeExtent)
                bNear = false;
        }
    }

    return bNear;
}

function PlayWalking()
{
    LoopAnimPivot('Swim');
}

function TweenToWalking(float tweentime)
{
    TweenAnimPivot('Swim', tweentime);
}


// Approximately five million stubbed out functions...
function ReactToInjury(Pawn instigatedBy, class<DamageType> damageType, EHitLocation hitPos);
function PlayRunningAndFiring();
function TweenToShoot(float tweentime);
function PlayShoot();
function TweenToAttack(float tweentime);
function PlayAttack();
function PlayPanicRunning();
function PlaySittingDown();
function PlaySitting();
function PlayStandingUp();
function PlayRubbingEyesStart();
function PlayRubbingEyes();
function PlayRubbingEyesEnd();
function PlayStunned();
function PlayFalling();
function PlayLanded(float impactVel);
function PlayDuck();
function PlayRising();
function PlayCrawling();
function PlayPushing();
function PlayFiring(float Rate, name FiringMode);
function PlayTakingHit(EHitLocation hitPos);

function PlayTurning();
function TweenToRunning(float tweentime);
function PlayRunning();
function TweenToWaiting(float tweentime);
function PlayWaiting();
function TweenToSwimming(float tweentime);
function PlaySwimming();


defaultproperties
{
     bFlock=True
     BindName="Fishes"
     WalkingSpeed=1.000000
     bHasShadow=False
     bHighlight=False
     bSpawnBubbles=False
     bCanWalk=False
     bCanSwim=True
     GroundSpeed=100.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     MaxiStepHeight=1.000000
     BaseEyeHeight=1.000000
     UnderWaterTime=99999.000000
     Physics=PHYS_Swimming
     Mesh=mesh'DeusExCharacters.Fish'
     CollisionRadius=7.760000
     CollisionHeight=3.890000
     bBlockActors=False
     bBlockPlayers=False
     bBounce=True
     Mass=1.000000
     Buoyancy=1.000000
     RotationRate=(Pitch=6000,Yaw=25000)
     ControllerClass=class'FishesController'
}
