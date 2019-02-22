/*

*/
class AnimalController extends DXRAiController;


function GotoDisabledState(class<DamageType> damageType, ScriptedPawn.EHitLocation hitPos)
{
	if (!pawn.bCollideActors && !pawn.bBlockActors && !pawn.bBlockPlayers)
		return;
	else if ((damageType == class'DM_TearGas') || (damageType == class'DM_HalonGas'))
		GotoState('Fleeing');
	else if (damageType == class'DM_Stunned')
		GotoState('Fleeing');
	else if (Animal(pawn).CanShowPain())
		Animal(pawn).TakeHit(hitPos);
	else
		GotoNextState();
}

state Eating
{
	function SetFall()
	{
		StartFalling('Eating', 'ContinueEat');
	}

	event bool NotifyHitWall(vector HitNormal, actor Wall)
	{
		if (pawn.Physics == PHYS_Falling)
			return true;
		//CheckOpenDoor(HitNormal, Wall);
	}

	function AnimEnd(int channel)
	{
		pawn.PlayWaiting();
	}

	function Tick(float deltaSeconds)
	{
		Super.Tick(deltaSeconds);

		if (Animal(pawn).bFoodOverridesAttack && (Animal(pawn).checkAggTimer <= 0))
		{
			Animal(pawn).checkAggTimer = 0.3;
			if (Animal(pawn).aggressiveTimer > 0)
				Animal(pawn).ResetReactions();
			else
				Animal(pawn).BlockReactions();
		}
	}

	function BeginState()
	{
		Animal(pawn).StandUp();
		SetEnemy(None, Animal(pawn).EnemyLastSeen, true);
		Disable('AnimEnd');
		Animal(pawn).SetDistress(false);
		if (!Animal(pawn).bFoodOverridesAttack)
			Animal(pawn).ResetReactions();
		else if (Animal(pawn).aggressiveTimer > 0)
			Animal(pawn).ResetReactions();
		else
			Animal(pawn).BlockReactions();
	}

	function EndState()
	{
		Animal(pawn).ResetReactions();
		Animal(pawn).Food     = None;
		Animal(pawn).BestFood = None;
	}

Begin:
	Animal(pawn).destPoint = None;
	Animal(pawn).Acceleration = vect(0,0,0);

GoToFood:
	WaitForLanding();
	if (!Animal(pawn).IsValidFood(Animal(pawn).Food))
		Animal(pawn).FollowOrders();
	if (!Animal(pawn).GetFeedSpot(Animal(pawn).Food, Animal(pawn).destLoc))
		FollowOrders();
	Animal(pawn).PlayRunning();
	MoveTo(Animal(pawn).destLoc,,false);// MaxDesiredSpeed);
	if (!Animal(pawn).IsInRange(Animal(pawn).Food))
		Goto('GoToFood');

TurnToFood:
	Animal(pawn).Acceleration = vect(0,0,0);
	Animal(pawn).PlayTurning();
	/*TurnTo*/LookAtActor(Animal(pawn).Food);
	if (!Animal(pawn).bPauseWhenEating || (FRand() >= 0.4))
		Goto('StartEating');

PauseEating:
	Animal(pawn).PlayPauseWhenEating();
	FinishAnim();

StartEating:
	if (!Animal(pawn).IsValidFood(Animal(pawn).Food))
		Animal(pawn).FollowOrders();
	if (!Animal(pawn).IsInRange(Animal(pawn).Food))
		Goto('GoToFood');
	Animal(pawn).PlayStartEating();
	FinishAnim();

Eat:
	if (!Animal(pawn).IsValidFood(Animal(pawn).Food))
		Goto('StopEating');
	if (!Animal(pawn).IsInRange(Animal(pawn).Food))
		Goto('StopEating');
	Animal(pawn).PlayEatingSound();
	Animal(pawn).PlayEating();
//	if (Animal(pawn).bAnimNotify)
   if (bControlAnimations) //?
		FinishAnim();
	else
	{
		FinishAnim();
		Animal(pawn).Munch(Animal(pawn).Food);
	}
	if (!Animal(pawn).bPauseWhenEating || (FRand() > 0.1))
		Goto('Eat');

StopEating:
	Animal(pawn).PlayStopEating();
	FinishAnim();
	if (Animal(pawn).IsValidFood(Animal(pawn).Food))
	{
		if (!Animal(pawn).IsInRange(Animal(pawn).Food))
			Goto('GoToFood');
		else
			Goto('PauseEating');
	}

ContinueEat:
ContinueFromDoor:
	FollowOrders();
}

state Fleeing
{
	function PickDestination()
	{
		local int     iterations;
		local float   magnitude;
		local rotator rot1;

		iterations = 4;
		magnitude  = 400*(FRand()*0.4+0.8);  // 400, +/-20%
		rot1       = Rotator(pawn.Location-Enemy.Location);
		if (!AIPickRandomDestination(100, magnitude, rot1.Yaw, 0.6, rot1.Pitch, 0.6, iterations,FRand()*0.4+0.35, Animal(pawn).destLoc))
			Animal(pawn).destLoc = pawn.Location;  // we give up
	}
}

state Wandering
{
/*	function PickDestination()
	{
		local int   iterations;
		local float magnitude;

		magnitude  = (Animal(pawn).wanderlust*300+100) * (FRand()*0.2+0.9); // 100-400, +/-10%
		iterations = 5;  // try up to 5 different directions

		if (!AIPickRandomDestination(30, magnitude, 0, 0, 0, 0, iterations, FRand()*0.4+0.35, Animal(pawn).destLoc))
			Animal(pawn).destLoc = Animal(pawn).Location;
	}*/

	function Tick(float deltaSeconds)
	{
		local pawn fearPawn;

		Global.Tick(deltaSeconds);

		Animal(pawn).fleePawnTimer += deltaSeconds;
		if (Animal(pawn).fleePawnTimer > 0.5)
		{
			Animal(pawn).fleePawnTimer = 0;
			fearPawn = Animal(pawn).FrightenedByPawn();
			if (fearPawn != None)
				Animal(pawn).FleeFromPawn(fearPawn);
		}
	}
}


state RubbingEyes
{
Begin:
	GotoState('Fleeing');
}
