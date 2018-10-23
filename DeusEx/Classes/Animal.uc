//=============================================================================
// Animal.
//=============================================================================
class Animal extends ScriptedPawn
	abstract;

var bool          bPlayDying;

var float         FoodTimer;
var int           FoodIndex;
var Actor         Food;
var Class<Actor>  FoodClass;
var int           FoodDamage;
var int           FoodHealth;
var bool          bBefriendFoodGiver;
var bool          bPauseWhenEating;
var bool          bMessyEater;
var bool          bFleeBigPawns;
var Actor         BestFood;
var float         BestDist;

var float         fleePawnTimer;
var float         aggressiveTimer;
var float         checkAggTimer;
var bool          bFoodOverridesAttack;



























// Approximately over9000 stubbed out functions... :)
function PlayRunningAndFiring() {}
function TweenToShoot(float tweentime) {}
function PlayShoot() {}
function TweenToAttack(float tweentime) {}
function PlayAttack() {}
function PlaySittingDown() {}
function PlaySitting() {}
function PlayStandingUp() {}
function PlayRubbingEyesStart() {}
function PlayRubbingEyes() {}
function PlayRubbingEyesEnd() {}
function PlayStunned() {}
function PlayFalling() {}
function PlayLanded(float impactVel) {}
function PlayDuck() {}
function PlayRising() {}
function PlayCrawling() {}
function PlayPushing() {}
function PlayFiring(float Rate, name FiringMode) {}
function PlayTakingHit(EHitLocation hitPos) {}
function PlayCowerBegin() {}
function PlayCowering() {}
function PlayCowerEnd() {}

function PlayPanicRunning()
{
	PlayRunning();
}
function PlayTurning()
{
	LoopAnimPivot('Walk', 0.1);
}
function TweenToWalking(float tweentime)
{
	TweenAnimPivot('Walk', tweentime);
}
function PlayWalking()
{
	LoopAnimPivot('Walk', , 0.15);
}
function TweenToRunning(float tweentime)
{
	LoopAnimPivot('Run',, tweentime);
}
function PlayRunning()
{
	LoopAnimPivot('Run');
}
function TweenToWaiting(float tweentime)
{
	TweenAnimPivot('BreatheLight', tweentime);
}
function PlayWaiting()
{
	LoopAnimPivot('BreatheLight', , 0.3);
}
function TweenToSwimming(float tweentime)
{
	TweenAnimPivot('Swim', tweentime, GetSwimPivot());
}
function PlaySwimming()
{
	LoopAnimPivot('Swim', , , , GetSwimPivot());
}


function PlayDying(class <damageType> damageType, vector hitLoc)
{
	local Vector X, Y, Z;
	local float dotp;

	if (bPlayDying)
	{
	    if ((damageType == class'DM_Stunned') || (damageType == class'DM_KnockedOut') ||
	    (damageType == class'DM_Poison') || (damageType == class'DM_PoisonEffect'))
		    bStunned = True;

		GetAxes(Rotation, X, Y, Z);
		dotp = (Location - HitLoc) dot X;

		// die from the correct side
		if (dotp < 0.0)		// shot from the front, fall back
			PlayAnimPivot('DeathBack',, 0.1);
		else				// shot from the back, fall front
			PlayAnimPivot('DeathFront',, 0.1);
	}
	PlayDyingSound();
	GoToState('Dying');
}



function PlayPauseWhenEating()
{
}

function PlayStartEating()
{
	PlayAnimPivot('EatBegin');
}

function PlayEating()
{
	PlayAnimPivot('Eat', 1.3, 0.2);
}

function PlayStopEating()
{
	PlayAnimPivot('EatEnd');
}

function PlayEatingSound()
{
}


function float GetMaxDistance(Actor foodActor)
{
	return (foodActor.CollisionRadius+CollisionRadius);
}


function bool IsInRange(Actor foodActor)
{
	return (VSize(foodActor.Location-Location) <= GetMaxDistance(foodActor)+20);
}




defaultproperties
{
     FoodDamage=10
     FoodHealth=3
     bCanGlide=True
     VisibilityThreshold=0.006000
     BindName="Animal"
     MaxRange=512.000000
     MinHealth=5.000000
     bCanBleed=False
     bCanSit=False
     bAvoidAim=False
     bAvoidHarm=False
     bHateShot=False
     bReactProjectiles=False
     bFearIndirectInjury=True
     bEmitDistress=False
     RaiseAlarm=RAISEALARM_Never
     MaxProvocations=0
     SurprisePeriod=0.000000
     ShadowScale=0.500000
     walkAnimMult=1.000000
     bCanStrafe=False
     bCanSwim=False
     //  bCanOpenDoors=False
     //  bIsHuman=False
     Health=10
     Texture=Texture'Engine.S_Pawn'
}
