//=============================================================================
// Bird.
//=============================================================================
class Bird extends Animal
	abstract;

var     name         WaitAnim;
var(AI) float        LikesFlying;
var     float        lastCheck;
var     float        stuck;
var     float        hitTimer;
var     float        fright;
var     float        initialRate;

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	if ((DamageType == class'DM_EMP') || (DamageType == class'DM_NanoVirus'))
		return;

	if (!bInvincible)
		Health -= Damage;

	HealthHead     = Health;
	HealthTorso    = Health;
	HealthArmLeft  = Health;
	HealthArmRight = Health;
	HealthLegLeft  = Health;
	HealthLegRight = Health;

	if (Health > 0)
	{
		MakeFrightened();
		Controller.GotoState('Flying');
		//PlayHit(actualDamage, hitLocation, damageType, momentum.z);
	}
	else
	{
		Controller.ClearNextState();
		//PlayDeathHit(actualDamage, hitLocation, damageType);
		Controller.Enemy = instigatedBy;
		Died(instigatedBy.Controller, damageType, HitLocation);
	}
}


function TweenToWaiting(float tweentime)
{
	if (FRand() >= 0.5)
		WaitAnim = 'Idle1';
	else
		WaitAnim = 'Idle2';
	TweenAnim(WaitAnim, tweentime);
}

function PlayWaiting()
{
 if (Vsize(Acceleration) < 0.1)
	LoopAnim(WaitAnim);
}

function PlayFlying()
{
	LoopAnim('Fly', 1.0, 0.1);
	initialRate = GetAnimRate();
}

function BeginPlay()
{
	Super.BeginPlay();
//	AIClearEventCallback('WeaponFire');
}

function MakeFrightened()
{
	fright = (cowardice*99)+1;
}

function FleeFromPawn(Pawn fleePawn)
{
	MakeFrightened();
	if (Controller.GetStateName() != 'Flying')
		Controller.GotoState('Flying');
}

function Tick(float deltaSeconds)
{
	Super.Tick(deltaSeconds);

	if (fright > 0)
	{
		fright -= deltaSeconds;
		if (fright < 0)
			fright = 0;
	}
}


defaultproperties
{
     WaitAnim=Idle1
     LikesFlying=0.250000
     bFleeBigPawns=True
     Restlessness=1.000000
     Wanderlust=0.050000
     Cowardice=0.200000
     bCanFly=True
     MaxiStepHeight=2.000000
     controllerClass=class'BirdController'

     orders=Flying
}
