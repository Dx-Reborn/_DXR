//=============================================================================
// Fly.
//=============================================================================
class Fly extends Animal;

function bool IsNearHome(vector position)
{
    local bool bNear;

    bNear = true;
    if (bUseHome)
        if (VSize(HomeLoc-position) > HomeExtent)
            bNear = false;

    return bNear;
}


function ReactToInjury(Pawn instigatedBy, class<damageType> damageType, EHitLocation hitPos);

function PlayWalking()
{
    LoopAnimPivot('Still');
}
function TweenToWalking(float tweentime)
{
    TweenAnimPivot('Still', tweentime);
}



// Approximately five million stubbed out functions...
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
function PlayFiring(optional float Rate, optional name FiringMode);
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
     bAmbientCreature=true
     bTransient=true
     BindName="Fly"
     FamiliarName="Fly"
     UnfamiliarName="Fly"
     WalkingSpeed=1.000000
     bHasShadow=False
     bHighlight=False
     bSpawnBubbles=False
     bCanFly=True
     GroundSpeed=100.000000
     WaterSpeed=100.000000
     AirSpeed=100.000000
     AccelRate=500.000000
     JumpZ=0.000000
     MaxiStepHeight=1.000000
     //  MinHitWall=0.000000
     BaseEyeHeight=1.000000
     Health=1
     UnderWaterTime=20.000000
     Physics=PHYS_Flying
     AmbientSound=Sound'DeusExSounds.Animal.FlyBuzz'
//     Mesh=Mesh'DeusExCharacters.Fly'
     DrawType=DT_Sprite
     DrawScale=1.400000
     SoundRadius=6
     SoundVolume=128
     CollisionRadius=2.000000
     CollisionHeight=1.000000
     bBlockActors=False
     bBlockPlayers=False
     bBounce=True
     Mass=0.100000
     Buoyancy=0.100000
     RotationRate=(Pitch=16384,Yaw=100000)
     ControllerClass=class'FlyController'
}
