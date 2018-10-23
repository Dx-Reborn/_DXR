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

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class <damageType> damageType)
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
		GotoState('Flying');
		//PlayHit(actualDamage, hitLocation, damageType, momentum.z);
	}
	else
	{
		DXRAiController(controller).ClearNextState();
		//PlayDeathHit(actualDamage, hitLocation, damageType);
		Controller.Enemy = instigatedBy;
		Died(instigatedBy.controller, damageType, HitLocation);
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
	LoopAnim(WaitAnim);
}

function PlayFlying()
{
	LoopAnim('Fly', 1.0, 0.1);
	initialRate = GetAnimRate();
}

function MakeFrightened()
{
	fright = (cowardice*99)+1;
}

/*function FleeFromPawn(Pawn fleePawn)
{
	MakeFrightened();
	if (GetStateName() != 'Flying')
		GotoState('Flying');
}*/















// Kind of a hack, but...

defaultproperties
{
     WaitAnim=Idle1
     LikesFlying=0.250000
     bFleeBigPawns=True
     Restlessness=1.000000
     Wanderlust=0.050000
     Cowardice=0.200000
     bCanFly=True
     // MaxStepHeight=2.000000
}
