/*
  Base AI Controller for ScriptedPawn
*/

class DXRAiController extends AIController;

var name NextState;
var name NextLabel;

var float EnemyTimer, sleepTime;
var pawn OldEnemy;
var Pawn SeekPawn;

var name ConvOrders,ConvOrderTag;

var vector PrevLookVector;
var Actor PrevLookActor;

var bool bInterruptState, bConvEndState;

var Actor destPoint;

var actor LastMoveTarget;

/** Utilities ********************************************************************************************************************************************************************/

function LookAtVector(vector v)
{
   FocalPoint = v;		// location being looked at
}

function LookAtActor(Actor A)
{
   Focus = A;			// actor being looked at
}

// idk what there 0_^
function bool IsValidEnemy(Pawn TestEnemy, optional bool bCheckAlliance)
{
  local pawn pw;

  foreach DynamicActors(class'pawn', pw)
  {
    if (pw == Enemy)
    break;
    return true;
  }
  return false;
}

function bool SetEnemy(Pawn newEnemy, optional float newSeenTime, optional bool bForce)
{
	if (bForce || IsValidEnemy(newEnemy))
	{
		if (newEnemy != Enemy)
        EnemyTimer = 0;
		    Enemy = newEnemy;
		    LastSeenTime = newSeenTime;

		return True;
	}
	else
		return False;
}

function SetState(Name stateName, optional Name labelName)
{
	if (ScriptedPawn(pawn).bInterruptState)
		GotoState(stateName, labelName);
	else
		SetNextState(stateName, labelName);
}

function SetNextState(name newState, optional name newLabel)
{
	if (!ScriptedPawn(pawn).bInTransientState || !HasNextState())
	{
		if ((newState != 'Conversation') && (newState != 'FirstPersonConversation'))
		{
			NextState = newState;
			NextLabel = newLabel;
		}
	}
}

function ClearNextState()
{
	NextState = '';
	NextLabel = '';
}

function bool HasNextState()
{
	if ((NextState == '') || (NextState == GetStateName()))
		return false;
	else
		return true;
}

function GotoNextState()
{
	local name oldState, oldLabel;

	if (HasNextState())
	{
		oldState = NextState;
		oldLabel = NextLabel;
		if (oldLabel == '')
			oldLabel = 'Begin';

		ClearNextState();

		GotoState(oldState, oldLabel);
	}
	else
		ClearNextState();
}

function FollowOrders(optional bool bDefer)
{
	local bool bSetEnemy;
	local bool bUseOrderActor;

	if (ScriptedPawn(pawn).Orders != '')
	{
		if ((ScriptedPawn(pawn).Orders == 'Fleeing') || (ScriptedPawn(pawn).Orders == 'Attacking'))
		{
			bSetEnemy      = true;
			bUseOrderActor = true;
		}
		else if ((ScriptedPawn(pawn).Orders == 'WaitingFor') || (ScriptedPawn(pawn).Orders == 'GoingTo') ||
		         (ScriptedPawn(pawn).Orders == 'RunningTo') || (ScriptedPawn(pawn).Orders == 'Following') ||
		         (ScriptedPawn(pawn).Orders == 'Sitting') || (ScriptedPawn(pawn).Orders == 'Shadowing') ||
		         (ScriptedPawn(pawn).Orders == 'DebugFollowing') || (ScriptedPawn(pawn).Orders == 'DebugPathfinding'))
		{
			bSetEnemy      = false;
			bUseOrderActor = true;
		}
		else
		{
			bSetEnemy      = false;
			bUseOrderActor = false;
		}
		if (bUseOrderActor)
		{
			ScriptedPawn(pawn).FindOrderActor();
			if (bSetEnemy)
				SetEnemy(Pawn(ScriptedPawn(pawn).OrderActor), 0, true);
		}
		if (bDefer)  // hack
			SetState(ScriptedPawn(pawn).Orders);
		else
			GotoState(ScriptedPawn(pawn).Orders);
	}
	else
	{
		if (bDefer)
			SetState('Wandering');
		else
			GotoState('Wandering');
	}
}

function SetOrdersEx(Name orderName, optional Name newOrderTag, optional bool bImmediate)
{
	local bool bHostile;
	local DXRPawn orderEnemy;

	switch (orderName)
	{
		case 'Attacking':
		case 'Fleeing':
		case 'Alerting':
		case 'Seeking':
			bHostile = true;
			break;
		default:
			bHostile = false;
			break;
	}

	if (!bHostile)
	{
		ScriptedPawn(pawn).bSeatHackUsed = false;  // hack!
		ScriptedPawn(pawn).Orders = orderName;
		ScriptedPawn(pawn).OrderTag = newOrderTag;

		if (bImmediate)
			FollowOrders(true);
	}
	else
	{
		ScriptedPawn(pawn).ReactionLevel = 1.0;
		orderEnemy = DXRPawn(ScriptedPawn(pawn).FindTaggedActor(newOrderTag, false, Class'Pawn'));
		if (orderEnemy != None)
		{
			ScriptedPawn(pawn).ChangeAlly(orderEnemy.Alliance, -1, true);
			if (SetEnemy(orderEnemy))
				SetState(orderName);
		}
	}
}

function ResetConvOrders()
{
	ConvOrders   = '';
	ConvOrderTag = '';
}

function pawn GetPlayerPawn()
{
 local DeusExPlayer playerP;

 foreach AllActors(class'DeusExPlayer', playerP)
 break;

 if (PlayerP != none)
 return PlayerP;

 return level.GetLocalPlayerController().pawn;
}

function StopBlendAnims()
{
//	AIAddViewRotation = rot(0, 0, 0);
//	Super.StopBlendAnims();
  ScriptedPawn(pawn).StopAnimating(false);
	ScriptedPawn(pawn).PlayTurnHead(LOOK_Forward, 1.0, 1.0);
}

function SaveFocus(actor A, vector v)
{
   PrevLookActor = A;
   PrevLookVector = v;
}

function RestoreFocus()
{
   Focus = PrevLookActor;
   FocalPoint = PrevLookVector;
}

function Actor GetNextWaypoint(Actor destination)
{
	local Actor rMoveTarget;

	if (destination == None)
		rMoveTarget = None;
	else if (ActorReachable(destination))
		rMoveTarget = destination;
	else
		rMoveTarget = FindPathToward(destination);

	return rMoveTarget;
}

function bool IsOverlapping(Actor CheckActor)
{
  return class'ActorManager'.static.IsOverlapping(ScriptedPawn(pawn), CheckActor);
}

function bool IsPointInCylinder(Actor cylinder, Vector point, optional float extraRadius, optional float extraHeight)
{
	local bool  bPointInCylinder;
	local float tempX, tempY, tempRad;

	tempX    = cylinder.Location.X - point.X;
	tempX   *= tempX;
	tempY    = cylinder.Location.Y - point.Y;
	tempY   *= tempY;
	tempRad  = cylinder.CollisionRadius + extraRadius;
	tempRad *= tempRad;

	bPointInCylinder = false;
	if (tempX+tempY < tempRad)
		if (Abs(cylinder.Location.Z - point.Z) < (cylinder.CollisionHeight+extraHeight))
			bPointInCylinder = true;

	return (bPointInCylinder);
}


function StartFalling(Name resumeState, optional Name resumeLabel)
{
	SetNextState(resumeState, resumeLabel);
	GotoState('FallingState'); 
}


function bool TestDirection(vector dir, out vector pick, float MinDist, float MaxDist)
{	
	local vector HitLocation, HitNormal, dist;
	local actor HitActor;

	pick = dir * (MinDist + 2 * MinDist * FRand());

	// Я могу только предполагать, что там было...
	HitActor = Trace(HitLocation, HitNormal, Pawn.Location + pick + 1.5 * Pawn.CollisionRadius * dir , Pawn.Location, false);
	if (HitActor != None)
	{
		pick = HitLocation + (HitNormal - dir) * 2 * (Pawn.CollisionRadius + MaxDist); // Наверное так?
		if (!FastTrace(pick, Pawn.Location))
			return false;
	}
	else
		pick = Pawn.Location + pick;
	 
	dist = pick - Pawn.Location;
	if (Pawn.Physics == PHYS_Walking)
		dist.Z = 0;
	
	return (VSize(dist) > MinDist);
}

// Случайный выбор направления.
function PickDestination()
{
	local vector pick, pickdir;
	local bool success;

	if(pawn.Physics == PHYS_Flying || pawn.Physics == PHYS_Swimming)
		pickdir = VRand();

		else
		{
			pickdir.X = 2 * FRand() - 1;
			pickdir.Y = 2 * FRand() - 1;
			pickdir = Normal(pickdir);
		}
		
		success = TestDirection(pickdir, pick, pawn.CollisionRadius, pawn.CollisionRadius + 55 + rand(200));
		if (!success)
			success = TestDirection(-1 * pickdir, pick, pawn.CollisionRadius, pawn.CollisionRadius + 55 + rand(200));

		if (success)
			Destination = pick;
		else
      LookAtVector(pawn.Location + 20 * VRand());
}


function bool AIDirectionReachable(vector focus, int yaw, int pitch, float minDist, float maxDist, out vector bestDest)
{
  return TestDirection(focus, bestDest, minDist, maxDist);
}

function bool AIPickRandomDestination(float minDist, float maxDist,
                                      int centralYaw, float yawDistribution, int centralPitch, float pitchDistribution,int tries, float multiplier,out vector dest)
{
  local int i;
	local vector /*pick,*/ pickdir;
	local bool success;

  for (i=0; i<tries; i++)
  {
    if(pawn.Physics == PHYS_Flying || pawn.Physics == PHYS_Swimming)
		   pickdir = VRand();

     else
		 {
		    pickdir.X = 2 * FRand() - 1;
			  pickdir.Y = 2 * FRand() - 1;
			  pickdir = Normal(pickdir);
		 }
       success = TestDirection(pickdir, dest, minDist, maxDist);
		   if (!success)
		       success = TestDirection(-1 * pickdir, dest, minDist, maxDist);

		   if (success)
			     Destination = dest;
		   else
           LookAtVector(pawn.Location + 20 * VRand());
  }
  return true;//???
}

function EnableCheckDestLoc(bool bEnable)
{
  ScriptedPawn(Pawn).EnableCheckDestLoc(bEnable);
}

function SetupWeapon(bool bDrawWeapon, optional bool bForce)
{
   // Call pawn version of function
}


/** States ***********************************************************************************************************************************************************************/

auto state StartUp
{
  function BeginState()
  {
   if (scriptedPawn(pawn) != none)
   {
    scriptedPawn(pawn).bInterruptState = true;
    scriptedPawn(pawn).bCanConverse = false;

    scriptedPawn(pawn).SetMovementPhysics(); 
    if (pawn.Physics == PHYS_Walking)
      pawn.SetPhysics(PHYS_Falling);
      
    scriptedPawn(pawn).bStasis = false;
    ScriptedPawn(pawn).SetDistress(false);
    ScriptedPawn(pawn).BlockReactions();
    scriptedPawn(pawn).ResetDestLoc();
   }
  }

  function EndState()
  {
    scriptedPawn(pawn).bCanConverse = true;
    scriptedPawn(pawn).bStasis = True;
    ScriptedPawn(pawn).ResetReactions();
  }

  function Tick(float deltaSeconds)
  {
    if (scriptedPawn(pawn).LastRendered() <= 1.0)
    {
      //Global.Tick(deltaSeconds);
      pawn.PlayWaiting();
//      InitializePawn();
      FollowOrders();
    }
  }

Begin:
//  InitializePawn();

  Sleep(FRand()+0.2);
  WaitForLanding();

Start:
  FollowOrders();
}

state GoingTo
{
Begin:
    log(pawn @ self@"GoingTo");
}

state Attacking
{
Begin:
    log(pawn @ self@"Attacking");
}

state Fleeing
{
Begin:
    log(pawn @ self@"Fleeing");
}

// ----------------------------------------------------------------------
// Just like Patrolling, but make the pawn transient.
// ToDo: Pawn должен быть уничтожен когда игрок его не видит.
// ----------------------------------------------------------------------

State Leaving
{
	function BeginState()
	{
		ScriptedPawn(pawn).bTransient = true;  // this pawn will be destroyed when it gets out of range
		ScriptedPawn(pawn).bDisappear = true;
		GotoState('Patrolling');
	}

Begin:
	// shouldn't ever reach this point
}


// ----------------------------------------------------------------------
// state Patrolling
//
// Move from point to point in a predescribed pattern.
// ----------------------------------------------------------------------

State Patrolling
{
	function SetFall()
	{
		//StartFalling('Patrolling', 'ContinuePatrol');
	}

	//function HitWall(vector HitNormal, actor Wall)
	event bool NotifyHitWall(vector HitNormal, actor Wall)
	{
		if (pawn.Physics == PHYS_Falling)
			return false;
	}
	
	function AnimEnd(int Channel)
	{
//    if (pawn.Acceleration == vect(0, 0, 0))
		pawn.PlayWaiting();
	}

	function PatrolPoint PickStartPoint()
	{
		local NavigationPoint nav;
		local PatrolPoint     curNav;
		local float           curDist;
		local PatrolPoint     closestNav;
		local float           closestDist;

		nav = Level.NavigationPointList;
		while (nav != None)
		{
			nav.visitedWeight = 0;
			nav = nav.nextNavigationPoint;
		}

		closestNav  = None;
		closestDist = 100000;
		nav = Level.NavigationPointList;

		while (nav != None)
		{
			curNav = PatrolPoint(nav);
			if ((curNav != None) && (curNav.Tag == ScriptedPawn(pawn).OrderTag))
			{
				while (curNav != None)
				{
					if (curNav.visitedWeight != 0)  // been here before
						break;
					curDist = VSize(pawn.Location - curNav.Location);
					if ((closestNav == None) || (closestDist > curDist))
					{
						closestNav  = curNav;
						closestDist = curDist;
					}
					curNav.visitedWeight = 1;
					curNav = curNav.NextPatrolPoint;
				}
			}
			nav = nav.nextNavigationPoint;
		}
		return (closestNav);
	}

	function PickDestination()
	{
		if (PatrolPoint(destPoint) != None)
		{
			destPoint = PatrolPoint(destPoint).NextPatrolPoint;
//			log(pawn@self$" patrolPoint = "$destPoint);
		}
		else
		{
			destPoint = PickStartPoint();
		}
		if (destPoint == None)  // can't go anywhere...
		{
  		log(pawn@self$" No patrolPoint found, fallback to Standing, OrderTag ="@ScriptedPawn(pawn).OrderTag);
			GotoState('Standing');
		}
	}

	function BeginState()
	{
		ScriptedPawn(pawn).StandUp();
		SetEnemy(None, ScriptedPawn(pawn).EnemyLastSeen, true);
		Disable('AnimEnd');
//		ScriptedPawn(pawn).SetupWeapon(false);
		ScriptedPawn(pawn).SetDistress(false);
		ScriptedPawn(pawn).bStasis = false;
		SeekPawn = None;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		Enable('AnimEnd');
		ScriptedPawn(pawn).bStasis = true;
	}

Begin:
  WaitForLanding();
	destPoint = None;

Patrol:
	//Disable('Bump');
	PickDestination();

Moving:
	// Move from pathnode to pathnode until we get where we're going
	if (destPoint != None)
	{
		if (!IsPointInCylinder(self, destPoint.Location, 16-CollisionRadius))
		{
			scriptedPawn(pawn).EnableCheckDestLoc(true);
			MoveTarget = FindPathToward(destPoint, true);
			while (MoveTarget != None)
			{
				if (scriptedPawn(pawn).ShouldPlayWalk(MoveTarget.Location))
					scriptedPawn(pawn).PlayWalking();
//					scriptedPawn(pawn).MaxDesiredSpeed = scriptedPawn(pawn).WalkingSpeed;

				LookAtVector(destPoint.location);
				MoveToward(MoveTarget,,0,false, true);
				scriptedPawn(pawn).CheckDestLoc(MoveTarget.Location, true);
				if (MoveTarget == destPoint)
					break;
				MoveTarget = FindPathToward(destPoint, true);
			}
			scriptedPawn(pawn).EnableCheckDestLoc(false);
		}
	}
	else
		Goto('Patrol');

Pausing:
	if (!scriptedPawn(pawn).bAlwaysPatrol)
		scriptedPawn(pawn).bStasis = true;
	scriptedPawn(pawn).Acceleration = vect(0, 0, 0);


	// Turn in the direction dictated by the WanderPoint, or a random direction
	if (PatrolPoint(destPoint) != None)
	{
		if ((PatrolPoint(destPoint).pausetime > 0) || (PatrolPoint(destPoint).NextPatrolPoint == None))
		{
			if (scriptedPawn(pawn).ShouldPlayTurn(pawn.Location + PatrolPoint(destPoint).lookdir))
				scriptedPawn(pawn).PlayTurning();
			/*TurnTo*/ LookAtVector(pawn.Location + PatrolPoint(destPoint).location + PatrolPoint(destPoint).lookdir /*.lookdir*/);
			Enable('AnimEnd');
			scriptedPawn(pawn).TweenToWaiting(0.2);
			scriptedPawn(pawn).PlayScanningSound();
			//Enable('Bump');
			sleepTime = PatrolPoint(destPoint).pausetime * ((-0.9*scriptedPawn(pawn).restlessness) + 1);
			Sleep(sleepTime);
			Disable('AnimEnd');
			//Disable('Bump');
			scriptedPawn(pawn).FinishAnim();
		}
	}
	Goto('Patrol');

ContinuePatrol:
ContinueFromDoor:
	ScriptedPawn(pawn).FinishAnim();
	ScriptedPawn(pawn).PlayWalking();
	Goto('Moving');

}


// 0_o
state Sitting
{
/*	ignores EnemyNotVisible;

	function SetFall()
	{
		//StartFalling('Sitting', 'ContinueSit');
	}

	function pawn.AnimEnd()
	{
		pawn.PlayWaiting();
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (pawn.Physics == PHYS_Falling)
			return;

		if (!scriptedPawn(pawn).bAcceptBump)
			scriptedPawn(pawn).NextDirection = TURNING_None;
		Global.HitWall(HitNormal, Wall);
		CheckOpenDoor(HitNormal, Wall);
	}

	function bool HandleTurn(Actor Other)
	{
		if (Other == SeatActor)
			return true;
		else
			return Global.HandleTurn(Other);
	}

	function Bump(actor bumper)
	{
		// If we hit our chair, move to the right place
		if ((bumper == SeatActor) && bAcceptBump)
		{
			bAcceptBump = false;
			GotoState('Sitting', 'CircleToFront');
		}

		// Handle conversations, if need be
		else
			Global.Bump(bumper);
	}

	function Tick(float deltaSeconds)
	{
		local vector endPos;
		local vector newPos;
		local float  delta;

		Global.Tick(deltaSeconds);

		if (bSitInterpolation && (SeatActor != None))
		{
			endPos = SitPosition(SeatActor, SeatSlot);
			if ((deltaSeconds < remainingSitTime) && (remainingSitTime > 0))
			{
				delta = deltaSeconds/remainingSitTime;
				newPos = (endPos-Location)*delta + Location;
				remainingSitTime -= deltaSeconds;
			}
			else
			{
				remainingSitTime = 0;
				bSitInterpolation = false;
				newPos = endPos;
				Acceleration = vect(0,0,0);
				Velocity = vect(0,0,0);
				SetBase(SeatActor);
				bSitting = true;
			}
			SetLocation(newPos);
			DesiredRotation = SeatActor.Rotation+Rot(0, -16384, 0);
		}
	}

	function Vector SitPosition(Seat seatActor, int slot)
	{
		local float newAssHeight;

		newAssHeight = GetDefaultCollisionHeight() + BaseAssHeight;
		newAssHeight = -(CollisionHeight - newAssHeight);

		return ((seatActor.sitPoint[slot]>>seatActor.Rotation)+seatActor.Location+(vect(0,0,-1)*newAssHeight));
	}

	function vector GetDestinationPosition(Seat seatActor, optional float extraDist)
	{
		local Rotator seatRot;
		local Vector  destPos;

		if (seatActor == None)
			return (Location);

		seatRot = seatActor.Rotation + Rot(0, -16384, 0);
		seatRot.Pitch = 0;
		destPos = seatActor.Location;
		destPos += vect(0,0,1)*(CollisionHeight-seatActor.CollisionHeight);
		destPos += Vector(seatRot)*(seatActor.CollisionRadius+CollisionRadius+extraDist);

		return (destPos);
	}

	function bool IsIntersectingSeat()
	{
		local bool   bIntersect;
		local vector testVector;

		bIntersect = false;
		if (SeatActor != None)
			bIntersect = IsOverlapping(SeatActor);

		return (bIntersect);
	}

	function int FindBestSlot(Seat seatActor, out float slotDist)
	{
		local int   bestSlot;
		local float dist;
		local float bestDist;
		local int   i;

		bestSlot = -1;
		bestDist = 100;
		if (!seatActor.Region.Zone.bWaterZone)
		{
			for (i=0; i<seatActor.numSitPoints; i++)
			{
				if (seatActor.sittingActor[i] == None)
				{
					dist = VSize(SitPosition(seatActor, i) - Location);
					if ((bestSlot < 0) || (bestDist > dist))
					{
						bestDist = dist;
						bestSlot = i;
					}
				}
			}
		}

		slotDist = bestDist;

		return (bestSlot);
	}

	function FindBestSeat()
	{
		local Seat  curSeat;
		local Seat  bestSeat;
		local float curDist;
		local float bestDist;
		local int   curSlot;
		local int   bestSlot;
		local bool  bTry;

		if (bUseFirstSeatOnly && bSeatHackUsed)
		{
			bestSeat = SeatHack;  // use the seat hack
			bestSlot = -1;
			if (!IsSeatValid(bestSeat))
				bestSeat = None;
			else
			{
				if (GetNextWaypoint(bestSeat) == None)
					bestSeat = None;
				else
				{
					bestSlot = FindBestSlot(bestSeat, curDist);
					if (bestSlot < 0)
						bestSeat = None;
				}
			}
		}
		else
		{
			bestSeat = Seat(OrderActor);  // try the ordered seat first
			if (bestSeat != None)
			{
				if (!IsSeatValid(OrderActor))
					bestSeat = None;
				else
				{
					if (GetNextWaypoint(bestSeat) == None)
						bestSeat = None;
					else
					{
						bestSlot = FindBestSlot(bestSeat, curDist);
						if (bestSlot < 0)
							bestSeat = None;
					}
				}
			}
			if (bestSeat == None)
			{
				bestDist = 10001;
				bestSlot = -1;
				foreach RadiusActors(Class'Seat', curSeat, 10000)
				{
					if (IsSeatValid(curSeat))
					{
						curSlot = FindBestSlot(curSeat, curDist);
						if (curSlot >= 0)
						{
							if (bestDist > curDist)
							{
								if (GetNextWaypoint(curSeat) != None)
								{
									bestDist = curDist;
									bestSeat = curSeat;
									bestSlot = curSlot;
								}
							}
						}
					}
				}
			}
		}

		if (bestSeat != None)
		{
			bestSeat.sittingActor[bestSlot] = self;
			SeatLocation       = bestSeat.Location;
			bSeatLocationValid = true;
		}
		else
			bSeatLocationValid = false;

		if (bUseFirstSeatOnly && !bSeatHackUsed)
		{
			SeatHack      = bestSeat;
			bSeatHackUsed = true;
		}

		SeatActor = bestSeat;
		SeatSlot  = bestSlot;
	}

	function FollowSeatFallbackOrders()
	{
		FindBestSeat();
		if (IsSeatValid(SeatActor))
			GotoState('Sitting', 'Begin');
		else
			GotoState('Wandering');
	}

	function BeginState()
	{
		SetEnemy(None, EnemyLastSeen, true);
		Disable('AnimEnd');
		bCanJump = false;

		bAcceptBump = True;

		if (SeatActor == None)
			FindBestSeat();

		bSitInterpolation = false;

		bStasis = False;

		SetupWeapon(false);
		SetDistress(false);
		SeekPawn = None;
		EnableCheckDestLoc(true);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		if (!bSitting)
			StandUp();

		bAcceptBump = True;

		if (JumpZ > 0)
			bCanJump = true;

		bSitInterpolation = false;

		bStasis = True;
	}

Begin:
	WaitForLanding();
	if (!IsSeatValid(SeatActor))
		FollowSeatFallbackOrders();
	if (!bSitting)
		WaitForLanding();
	else
	{
		TurnTo(Vector(SeatActor.Rotation+Rot(0, -16384, 0))*100+Location);
		Goto('ContinueSitting');
	}

MoveToSeat:
	if (IsIntersectingSeat())
		Goto('MoveToPosition');
	bAcceptBump = true;
	while (true)
	{
		if (!IsSeatValid(SeatActor))
			FollowSeatFallbackOrders();
		destLoc = GetDestinationPosition(SeatActor);
		if (PointReachable(destLoc))
		{
			if (ShouldPlayWalk(destLoc))
				PlayWalking();
			MoveTo(destLoc, GetWalkingSpeed());
			CheckDestLoc(destLoc);

			if (IsPointInCylinder(self, GetDestinationPosition(SeatActor), 16, 16))
			{
				bAcceptBump = false;
				Goto('MoveToPosition');
				break;
			}
		}
		else
		{
			MoveTarget = GetNextWaypoint(SeatActor);
			if (MoveTarget != None)
			{
				if (ShouldPlayWalk(MoveTarget.Location))
					PlayWalking();
				MoveToward(MoveTarget, GetWalkingSpeed());
				CheckDestLoc(MoveTarget.Location, true);
			}
			else
				break;
		}
	}

CircleToFront:
	bAcceptBump = false;
	if (!IsSeatValid(SeatActor))
		FollowSeatFallbackOrders();
	if (ShouldPlayWalk(GetDestinationPosition(SeatActor, 16)))
		PlayWalking();
	MoveTo(GetDestinationPosition(SeatActor, 16), GetWalkingSpeed());

MoveToPosition:
	if (!IsSeatValid(SeatActor))
		FollowSeatFallbackOrders();
	bSitting = true;
	EnableCollision(false);
	Acceleration=vect(0,0,0);

Sit:
	Acceleration=vect(0,0,0);
	Velocity=vect(0,0,0);
	if (!IsSeatValid(SeatActor))
		FollowSeatFallbackOrders();
	remainingSitTime = 0.8;
	PlaySittingDown();
	SetBasedPawnSize(CollisionRadius, GetSitHeight());
	SetPhysics(PHYS_Flying);
	StopStanding();
	bSitInterpolation = true;
	while (bSitInterpolation)
		Sleep(0);
	FinishAnim();
	Goto('ContinueSitting');

ContinueFromDoor:
	Goto('MoveToSeat');

ContinueSitting:
	if (!IsSeatValid(SeatActor))
		FollowSeatFallbackOrders();
	SetBasedPawnSize(CollisionRadius, GetSitHeight());
	SetCollision(Default.bCollideActors, Default.bBlockActors, Default.bBlockPlayers);
	PlaySitting();
	bStasis  = True;*/
	// nil
}

/*
state FallingState 
{
	ignores NotifyBump, NotifyHitwall;//, WarnTarget, ReactToInjury;

	function PhysicsVolumeChange(PhysicsVolume newVolume)
	{
		Global.ZoneChange(newZone);
		if (newZone.bWaterZone)
			GotoState('FallingState', 'Splash');
	}

	//choose a jump velocity
	function AdjustJump()
	{
		local float velZ;
		local vector FullVel;

		velZ = pawn.Velocity.Z;
		FullVel = Normal(pawn.Velocity) * pawn.GroundSpeed;

		If (pawn.Location.Z > pawn.Destination.Z + pawn.CollisionHeight + 2 * MaxStepHeight)
		{
			pawn.Velocity = FullVel;
			pawn.Velocity.Z = velZ;
			pawn.Velocity = ScriptedPawn(pawn).EAdjustJump();
			pawn.Velocity.Z = 0;
			if (VSize(pawn.Velocity) < 0.9 * pawn.GroundSpeed)
			{
				pawn.Velocity.Z = velZ;
				return;
			}
		}

		pawn.Velocity = FullVel;
		pawn.Velocity.Z = JumpZ + velZ;
		pawn.Velocity = ScriptedPawn(pawn).EAdjustJump();
	}

	singular function BaseChange()
	{
		local float minJumpZ;

		Global.BaseChange();

		if (pawn.Physics == PHYS_Walking)
		{
			minJumpZ = FMax(pawn.JumpZ, 150.0);
			ScriptedPawn(pawn).bJustLanded = true;
			if (Health > 0)
			{
				if ((pawn.Velocity.Z < -0.8 * ScriptedPawn(pawn).minJumpZ) || pawn.bUpAndOut)
					GotoState('FallingState', 'Landed');
				else if (pawn.Velocity.Z < -0.8 * pawn.JumpZ)
					GotoState('FallingState', 'FastLanded');
				else
					GotoState('FallingState', 'Done');
			}
		}
	}

	function Landed(vector HitNormal)
	{
		local float landVol, minJumpZ;
		local vector legLocation;

		minJumpZ = FMax(pawn.JumpZ, 150.0);

		if ( (pawn.Velocity.Z < -0.8 * ScriptedPawn(pawn).minJumpZ) || pawn.bUpAndOut)
		{
			ScriptedPawn(pawn).PlayLanded(pawn.Velocity.Z);
			if (pawn.Velocity.Z < -700)
			{
				legLocation = pawn.Location + vect(-1,0,-1);			// damage left leg
				pawn.TakeDamage(-0.14 * (pawn.Velocity.Z + 700), pawn, legLocation, vect(0,0,0), class'fell');
				legLocation = pawn.Location + vect(1,0,-1);			// damage right leg
				pawn.TakeDamage(-0.14 * (pawn.Velocity.Z + 700), pawn, legLocation, vect(0,0,0), class'fell');
				legLocation = pawn.Location + vect(0,0,1);			// damage torso
				pawn.TakeDamage(-0.04 * (Velocity.Z + 700), pawn, legLocation, vect(0,0,0), class'fell');
			}
			landVol = pawn.Velocity.Z/pawn.JumpZ;
			landVol = 0.005 * Mass * FMin(5, landVol * landVol);
			if (!pawn.PhysicsVolume.bWaterVolume)
				pawn.PlaySound(ScriptedPawn(pawn).Land, SLOT_Interact, FMin(20, landVol));
		}
		else if ( pawn.Velocity.Z < -0.8 * pawn.JumpZ )
			ScriptedPawn(pawn).PlayLanded(Velocity.Z);
	}

	function SetFall()
	{
		if (!pawn.bUpAndOut)
			GotoState('FallingState');
	}

	function BeginState()
	{
		ScriptedPawn(pawn).StandUp();
		if (Enemy == None)
			Disable('EnemyNotVisible');
		else
		{
			Disable('HearNoise');
			Disable('SeePlayer');
		}
		bInterruptState = false;
		bCanConverse = False;
		bStasis = False;
		bInTransientState = true;
		EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		pawn.bUpAndOut = false;
		bInterruptState = true;
		ScriptedPawn(pawn).bCanConverse = True;
		ScriptedPawn(pawn).bStasis = True;
		bInTransientState = false;
	}

LongFall:
	if (ScriptedPawn(pawn).bCanFly)
	{
		pawn.SetPhysics(PHYS_Flying);
		Goto('Done');
	}
	Sleep(0.7);
	ScriptedPawn(pawn).PlayFalling();
	if (pawn.Velocity.Z > -150) //stuck
	{
		pawn.SetPhysics(PHYS_Falling);
		if (Enemy != None)
			pawn.Velocity = pawn.groundspeed * normal(Enemy.Location - pawn.Location);
		else
			pawn.Velocity = pawn.groundspeed * VRand();

		Velocity.Z = FMax(JumpZ, 250);
	}
	Goto('LongFall');

FastLanded:
	ScriptedPawn(pawn).FinishAnim();
	ScriptedPawn(pawn).TweenToWaiting(0.15);
	Goto('Done');

Landed:
	if (!bIsPlayer) //bots act like players
		pawn.Acceleration = vect(0,0,0);
	ScriptedPawn(pawn).FinishAnim();
	ScriptedPawn(pawn).TweenToWaiting(0.2);
	if (!bIsPlayer)
		Sleep(0.08);

Done:
	pawn.bUpAndOut = false;
	if (HasNextState())
		GotoNextState();
	else
		GotoState('Wandering');

Splash:
	pawn.bUpAndOut = false;
	ScriptedPawn(pawn).FinishAnim();
	if (HasNextState())
		GotoNextState();
	else
		GotoState('Wandering');

Begin:
	if (Enemy == None)
		Disable('EnemyNotVisible');
	else
	{
		Disable('HearNoise');
		Disable('SeePlayer');
	}
	if (pawn.bUpAndOut) //water jump
	{
		if (!bIsPlayer)
		{
			pawn.DesiredRotation = pawn.Rotation;
			pawn.DesiredRotation.Pitch = 0;
			pawn.Velocity.Z = 440; 
		}
	}
	else
	{	
		if (pawn.PhysicsVolume.bWaterVolume)
		{
			pawn.SetPhysics(PHYS_Swimming);
			GotoNextState();
		}	
		if (!bJumpOffPawn)
			ScriptedPawn(pawn).AdjustJump();
		else
			ScriptedPawn(pawn).bJumpOffPawn = false;

PlayFall:
		ScriptedPawn(pawn).PlayFalling();
		ScriptedPawn(pawn).FinishAnim();
	}
	
	if (pawn.Physics != PHYS_Falling)
		Goto('Done');
	Sleep(2.0);
	Goto('LongFall');

Ducking:
		
}*/


// Диалог от третьего лица.
state Conversation 
{
   function BeginState()
   {

   }

   function EndState()
   {

   }
Begin:
  log(pawn @ self@"Conversation");
	pawn.Acceleration = vect(0,0,0);

	pawn.DesiredRotation.Pitch = 0;
	if (!ScriptedPawn(pawn).bSitting && !ScriptedPawn(pawn).bDancing)
		pawn.PlayWaiting();
}

//--------------------------------------------//
// Диалог от первого лица (не интерактивный). //
//--------------------------------------------//
state FirstPersonConversation
{
   function Tick(float deltatime)
   {
    Global.Tick(deltaTime);
    ScriptedPawn(pawn).LipSynch(deltaTime);

		if (ScriptedPawn(pawn).ConversationActor != None)
		{
			if (ScriptedPawn(pawn).bSitting)
			{
				if (ScriptedPawn(pawn).SeatActor != None)
					LookAtActor(none);//ConversationActor, true, true, true, 0, 1.0, SeatActor.Rotation.Yaw+49152, 5461);
				else
					LookAtActor(ScriptedPawn(pawn).ConversationActor);
			}
			else
				LookAtActor(ScriptedPawn(pawn).ConversationActor);
		}
   }

   function SetOrdersEx(Name orderName, optional Name newOrderTag, optional bool bImmediate)
	 {
		 ConvOrders   = orderName;
	   ConvOrderTag = newOrderTag;
	 }

	 function FollowOrders(optional bool bDefer)
	 {
	   local name tempConvOrders, tempConvOrderTag;

		 // hack
		 tempConvOrders   = ConvOrders;
		 tempConvOrderTag = ConvOrderTag;
		 ResetConvOrders();  // must do this before calling SetOrders(), or recursion will result

		 if (tempConvOrders != '')
		  Global.SetOrdersEx(tempConvOrders, tempConvOrderTag, true);
		 else
			Global.FollowOrders(bDefer);
	 }

   function BeginState()
   {
    local DeusExPlayer dxPlayer;
		local bool         bBlock;

		ResetConvOrders();
		EnableCheckDestLoc(false);

		dxPlayer = DeusExPlayer(GetPlayerPawn());
		bBlock = false;

		bInterruptState = True;
		if (bBlock)
		{
			ScriptedPawn(pawn).bCanConverse = false;
			ScriptedPawn(pawn).MakePawnIgnored(true);
			ScriptedPawn(pawn).BlockReactions(true);
		}
		else
		{
			ScriptedPawn(pawn).bCanConverse = true;
			ScriptedPawn(pawn).MakePawnIgnored(false);
			if ((dxPlayer != None) && (dxPlayer.conPlay != None) &&
			    dxPlayer.conPlay.con.IsSpeakingActor(dxPlayer))

				ScriptedPawn(pawn).SetReactions(false, false, false, false, true, false, false, true, false, false, true, true);
			else
				ScriptedPawn(pawn).ResetReactions();
		}
		ScriptedPawn(pawn).bConversationEndedNormally = false;
		ScriptedPawn(pawn).bInConversation = true;
		ScriptedPawn(pawn).bStasis = false;
		ScriptedPawn(pawn).SetDistress(false);
		SeekPawn = None;

		if (ScriptedPawn(pawn).ConversationActor != none)
        SaveFocus(ScriptedPawn(pawn).ConversationActor, ScriptedPawn(pawn).ConversationActor.location);
   }

   function EndState()
   {
		local DeusExPlayer player;

		bConvEndState = true;
		if (ScriptedPawn(pawn).bConversationEndedNormally != true)
		{
			player = DeusExPlayer(GetPlayerPawn());
			player.AbortConversation();
		}
		bConvEndState = false;
		ScriptedPawn(pawn).ResetConvOrders();

		StopBlendAnims();
		bInterruptState = true;
		ScriptedPawn(pawn).bCanConverse    = true;
		ScriptedPawn(pawn).MakePawnIgnored(false);
		ScriptedPawn(pawn).ResetReactions();
		ScriptedPawn(pawn).bStasis = true;
		ScriptedPawn(pawn).ConversationActor = None;
		RestoreFocus();//
   }
Begin:
  log(pawn @ self@"FirstPersonConversation");
	pawn.Acceleration = vect(0,0,0);

	pawn.DesiredRotation.Pitch = 0;
	if (!ScriptedPawn(pawn).bSitting && !ScriptedPawn(pawn).bDancing)
		pawn.PlayWaiting();
}


state Idle
{
	ignores bump, frob;//, reacttoinjury;

	function BeginState()
	{
		ScriptedPawn(pawn).StandUp();
		ScriptedPawn(pawn).BlockReactions(true);
		ScriptedPawn(pawn).bCanConverse = False;
		SeekPawn = None;
		ScriptedPawn(pawn).EnableCheckDestLoc(false);
	}
	function EndState()
	{
		ScriptedPawn(pawn).ResetReactions();
		ScriptedPawn(pawn).bCanConverse = true;
	}

Begin:
  log(pawn @ self@"Idle");
	scriptedPawn(pawn).Acceleration = vect(0,0,0);
	scriptedPawn(pawn).DesiredRotation = scriptedPawn(pawn).Rotation;
	scriptedPawn(pawn).PlayAnimPivot('Still');

Idle:
}

//------------------------------------------//
state TakingHit
{
	ignores seeplayer, hearnoise, bump, hitwall;//, reacttoinjury;

/*	function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<damageType> damageType)
	{
		ScriptedPawn(pawn).TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, false);
	}*/

  event bool NotifyLanded(vector HitNormal)
	{
		if (pawn.Velocity.Z < -1.4 * pawn.JumpZ)
			pawn.MakeNoise(-0.5 * pawn.Velocity.Z/(FMax(pawn.JumpZ, 150.0)));
		pawn.bJustLanded = true;
		return false;
	}

	function BeginState()
	{
		ScriptedPawn(pawn).StandUp();
		ScriptedPawn(pawn).LastPainTime = Level.TimeSeconds;
		ScriptedPawn(pawn).LastPainAnim = pawn.GetAnimSequence();
		ScriptedPawn(pawn).bInterruptState = false;
		ScriptedPawn(pawn).BlockReactions();
		ScriptedPawn(pawn).bCanConverse = False;
		ScriptedPawn(pawn).bStasis = False;
		ScriptedPawn(pawn).SetDistress(true);
		ScriptedPawn(pawn).TakeHitTimer = 2.0;
		ScriptedPawn(pawn).EnemyReadiness = 1.0;
		ScriptedPawn(pawn).ReactionLevel  = 1.0;
		ScriptedPawn(pawn).bInTransientState = true;
		ScriptedPawn(pawn).EnableCheckDestLoc(false);
	}

	function EndState()
	{
		ScriptedPawn(pawn).EnableCheckDestLoc(false);
		ScriptedPawn(pawn).bInterruptState = true;
		ScriptedPawn(pawn).ResetReactions();
		ScriptedPawn(pawn).bCanConverse = true;
		ScriptedPawn(pawn).bStasis = true;
		ScriptedPawn(pawn).bInTransientState = false;
	}
		
Begin:
	ScriptedPawn(pawn).Acceleration = vect(0, 0, 0);
	ScriptedPawn(pawn).FinishAnim();
	if ((pawn.Physics == PHYS_Falling) && !pawn.PhysicsVolume.bWaterVolume)
	{
		pawn.Acceleration = vect(0,0,0);
		GotoState('FallingState', 'Ducking');
	}
	else if (HasNextState())
		GotoNextState();
	else
		GotoState('Wandering');
}

// ----------------------------------------------------------------------
// state Standing
//
// Just kinda stand there and do nothing.
// (similar to Wandering, except the pawn doesn't actually move)
// ----------------------------------------------------------------------
state Standing
{
	ignores EnemyNotVisible;

	function SetFall()
	{
		StartFalling('Standing', 'ContinueStand');
	}

	// Pawn ®Ї®ўҐй Ґв нв® бо¤ .
	function AnimEnd(int channel)
	{
		pawn.PlayWaiting();
	}

/*	function bool NotifyHitWall(vector HitNormal, actor Wall)
	{
		if (Physics == PHYS_Falling)
			return false;
		Global.HitWall(HitNormal, Wall);
		//CheckOpenDoor(HitNormal, Wall);
	}*/

	function Tick(float deltaSeconds)
	{
		ScriptedPawn(pawn).animTimer[1] += deltaSeconds;
		Global.Tick(deltaSeconds);
	}

	function BeginState()
	{
		scriptedPawn(pawn).StandUp();
		SetEnemy(None, scriptedPawn(pawn).EnemyLastSeen, true);
		Disable('AnimEnd');
		pawn.bCanJump = false;

		pawn.bStasis = false;

//		scriptedPawn(pawn).SetupWeapon(false);
		scriptedPawn(pawn).SetDistress(false);
		SeekPawn = None;
		scriptedPawn(pawn).EnableCheckDestLoc(false);
	}

	function EndState()
	{
		EnableCheckDestLoc(false);
		scriptedPawn(pawn).bAcceptBump = true;

		if (pawn.JumpZ > 0)
			pawn.bCanJump = true;
		pawn.bStasis = true;

//		scriptedPawn(pawn).StopBlendAnims();
	}

Begin:
	WaitForLanding();
	if (!scriptedPawn(pawn).bUseHome)
		Goto('StartStand');

MoveToBase:
	if (!IsPointInCylinder(pawn, scriptedPawn(pawn).HomeLoc, 16-pawn.CollisionRadius))
	{
		EnableCheckDestLoc(true);
		while (true)
		{
			if (PointReachable(scriptedPawn(pawn).HomeLoc))
			{
				if (scriptedPawn(pawn).ShouldPlayWalk(scriptedPawn(pawn).HomeLoc))
					scriptedPawn(pawn).PlayWalking();

				MoveTo(scriptedPawn(pawn).HomeLoc,,true);//GetWalkingSpeed());
				scriptedPawn(pawn).CheckDestLoc(scriptedPawn(pawn).HomeLoc);
				break;
			}
			else
			{
				MoveTarget = FindPathTo(scriptedPawn(pawn).HomeLoc);
				if (MoveTarget != None)
				{
					if (scriptedPawn(pawn).ShouldPlayWalk(MoveTarget.Location))
						ScriptedPawn(pawn).PlayWalking();
					MoveToward(MoveTarget,,0,false, true);// GetWalkingSpeed());
					ScriptedPawn(pawn).CheckDestLoc(MoveTarget.Location, true);
				}
				else
					break;
			}
		}
		EnableCheckDestLoc(false);
	}
	LookAtVector(ScriptedPawn(pawn).Location+ScriptedPawn(pawn).HomeRot);

StartStand:
	pawn.Acceleration = vect(0,0,0);
	Goto('Stand');

ContinueFromDoor:
	Goto('MoveToBase');

Stand:
ContinueStand:
	// nil
	scriptedPawn(pawn).bStasis = true;

	scriptedPawn(pawn).PlayWaiting();
	if (!scriptedPawn(pawn).bPlayIdle)
		Goto('DoNothing');
	Sleep(FRand()*14+8);

Fidget:
	if (FRand() < 0.5)
	{
		scriptedPawn(pawn).PlayIdle();
		scriptedPawn(pawn).FinishAnim();
	}
	else
	{
		if (FRand() > 0.5)
		{
			scriptedPawn(pawn).PlayTurnHead(LOOK_Up, 1.0, 1.0);
			Sleep(2.0);
			scriptedPawn(pawn).PlayTurnHead(LOOK_Forward, 1.0, 1.0);
			Sleep(0.5);
		}
		else if (FRand() > 0.5)
		{
			scriptedPawn(pawn).PlayTurnHead(LOOK_Left, 1.0, 1.0);
			Sleep(1.5);
			scriptedPawn(pawn).PlayTurnHead(LOOK_Forward, 1.0, 1.0);
			Sleep(0.9);
			scriptedPawn(pawn).PlayTurnHead(LOOK_Right, 1.0, 1.0);
			Sleep(1.2);
			scriptedPawn(pawn).PlayTurnHead(LOOK_Forward, 1.0, 1.0);
			Sleep(0.5);
		}
		else
		{
			scriptedPawn(pawn).PlayTurnHead(LOOK_Right, 1.0, 1.0);
			Sleep(1.5);
			scriptedPawn(pawn).PlayTurnHead(LOOK_Forward, 1.0, 1.0);
			Sleep(0.9);
			scriptedPawn(pawn).PlayTurnHead(LOOK_Left, 1.0, 1.0);
			Sleep(1.2);
			scriptedPawn(pawn).PlayTurnHead(LOOK_Forward, 1.0, 1.0);
			Sleep(0.5);
		}
	}
	if (FRand() < 0.3)
		scriptedPawn(pawn).PlayIdleSound();
	Goto('Stand');

DoNothing:
	// nil
}

state Wandering
{
	ignores EnemyNotVisible;

	function SetFall()
	{
		StartFalling('Wandering', 'ContinueWander');
	}

/*	function Bump(actor bumper)
	{
		if (ScriptedPawn(pawn).bAcceptBump)
		{
			// If we get bumped by another actor while we wait, start wandering again
			ScriptedPawn(pawn).bAcceptBump = False;
			Disable('AnimEnd');
			GotoState('Wandering', 'Wander');
		}

		// Handle conversations, if need be
		Global.Bump(bumper);
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (pawn.Physics == PHYS_Falling)
			return;
		Global.HitWall(HitNormal, Wall);
		//CheckOpenDoor(HitNormal, Wall);
	}*/

	function bool GoHome()
	{
		if (ScriptedPawn(pawn).bUseHome && !ScriptedPawn(pawn).IsNearHome(pawn.Location))
		{
			ScriptedPawn(pawn).destLoc = ScriptedPawn(pawn).HomeLoc;
			destPoint = None;
			if (PointReachable(ScriptedPawn(pawn).destLoc))
				return true;
			else
			{
				MoveTarget = FindPathTo(ScriptedPawn(pawn).destLoc);
				if (MoveTarget != None)
					return true;
				else
					return false;
			}
		}
		else
			return false;
	}

	function PickDestination()
	{
		local vector pick, pickdir;
		local bool success;
		local float XY;
		//Favor XY alignment
		XY = FRand();
		if (XY < 0.3)
		{
			pickdir.X = 1;
			pickdir.Y = 0;
		}
		else if (XY < 0.6)
		{
			pickdir.X = 0;
			pickdir.Y = 1;
		}
		else
		{
			pickdir.X = 2 * FRand() - 1;
			pickdir.Y = 2 * FRand() - 1;
		}
		if (pawn.Physics != PHYS_Walking)
		{
			pickdir.Z = 2 * FRand() - 1;
			pickdir = Normal(pickdir);
		}
		else
		{
			pickdir.Z = 0;
			if (XY >= 0.6)
				pickdir = Normal(pickdir);
		}	

		success = TestDirection(pickdir, pick, 100, 200);
		if (!success)
			success = TestDirection(-1 * pickdir, pick, 100, 200);
		
		if (success)
			Destination = pick;
		else
      LookAtVector(pawn.Location + 20 * VRand());
			//GotoState('Wandering', 'Turn');

/*		local WanderCandidates candidates[5];
		local int              candidateCount;
		local int              maxCandidates;
		local int              maxLastPoints;

		local WanderPoint curPoint;
		local Actor       wayPoint;
		local int         i;
		local int         openSlot;
		local float       maxDist;
		local float       dist;
		local float       angle;
		local float       magnitude;
		local int         iterations;
		local bool        bSuccess;
		local Rotator     rot;

		maxCandidates = 4;  // must be <= size of candidates[] array
		maxLastPoints = 2;  // must be <= size of lastPoints[] array

		for (i=0; i<maxCandidates; i++)
			candidates[i].dist = 100000;
		candidateCount = 0;

		// A certain percentage of the time, we want to angle off to a random direction...
		if ((RandomWandering < 1) && (FRand() > RandomWandering))
		{
			// Fill the candidate table
			foreach RadiusActors(Class'WanderPoint', curPoint, 3000*wanderlust+1000)  // 1000-4000
			{
				// Make sure we haven't been here recently
				for (i=0; i<maxLastPoints; i++)
				{
					if (lastPoints[i] == curPoint)
						break;
				}

				if (i >= maxLastPoints)
				{
					// Can we get there from here?
					wayPoint = GetNextWaypoint(curPoint);

					if ((wayPoint != None) && !IsNearHome(curPoint.Location))
						wayPoint = None;

					// Yep
					if (wayPoint != None)
					{
						// Find an empty slot for this candidate
						openSlot = -1;
						dist     = VSize(curPoint.location - location);
						maxDist  = dist;

						// This candidate will only replace more distant candidates...
						for (i=0; i<maxCandidates; i++)
						{
							if (maxDist < candidates[i].dist)
							{
								maxDist  = candidates[i].dist;
								openSlot = i;
							}
						}

						// Put the candidate in the (unsorted) list
						if (openSlot >= 0)
						{
							candidates[openSlot].point    = curPoint;
							candidates[openSlot].waypoint = wayPoint;
							candidates[openSlot].dist     = dist;
							if (candidateCount < maxCandidates)
								candidateCount++;
						}
					}
				}
			}
		}

		// Shift our list of recently visited points
		for (i=maxLastPoints-1; i>0; i--)
			lastPoints[i] = lastPoints[i-1];
		lastPoints[0] = None;

		// Do we have a list of candidates?
		if (candidateCount > 0)
		{
			// Pick a candidate at random
			i = Rand(candidateCount);
			curPoint = candidates[i].point;
			wayPoint = candidates[i].waypoint;
			lastPoints[0] = curPoint;
			MoveTarget    = wayPoint;
			destPoint     = curPoint;
		}

		// No candidates -- find a random place to go
		else
		{
			MoveTarget = None;
			destPoint  = None;
			iterations = 6;  // try up to 6 different directions
			while (iterations > 0)
			{
				// How far will we go?
				magnitude = (wanderlust*400+200) * (FRand()*0.2+0.9); // 200-600, +/-10%

				// Choose our destination, based on whether we have a home base
				if (!bUseHome)
					bSuccess = AIPickRandomDestination(100, magnitude, 0, 0, 0, 0, 1,
					                                   FRand()*0.4+0.35, destLoc);
				else
				{
					if (magnitude > HomeExtent)
						magnitude = HomeExtent*(FRand()*0.2+0.9);
					rot = Rotator(HomeLoc-Location);
					bSuccess = AIPickRandomDestination(50, magnitude, rot.Yaw, 0.25, rot.Pitch, 0.25, 1,
					                                   FRand()*0.4+0.35, destLoc);
				}

				// Success?  Break out of the iteration loop
				if (bSuccess)
					if (IsNearHome(destLoc))
						break;

				// We failed -- try again
				iterations--;
			}

			// If we got a destination, go there
			if (iterations <= 0)
				destLoc = Location;
		}*/
	}

	function AnimEnd(int channel)
	{
		pawn.PlayWaiting();
	}

	function BeginState()
	{
		ScriptedPawn(pawn).StandUp();
		SetEnemy(None, ScriptedPawn(pawn).EnemyLastSeen, true);
		Disable('AnimEnd');
		pawn.bCanJump = false;
		SetupWeapon(false);
		ScriptedPawn(pawn).SetDistress(false);
		SeekPawn = None;
		ScriptedPawn(pawn).EnableCheckDestLoc(false);
	}

	function EndState()
	{
		local int i;
		ScriptedPawn(pawn).bAcceptBump = true;

		ScriptedPawn(pawn).EnableCheckDestLoc(false);

		// Clear out our list of last visited points
		for (i=0; i<ArrayCount(ScriptedPawn(pawn).lastPoints); i++)
			ScriptedPawn(pawn).lastPoints[i] = None;

		if (pawn.JumpZ > 0)
			pawn.bCanJump = true;
	}

Begin:
	destPoint = None;

GoHome:
	ScriptedPawn(pawn).bAcceptBump = false;
	WaitForLanding();
	if (!GoHome())
		Goto('WanderInternal');

MoveHome:
	ScriptedPawn(pawn).EnableCheckDestLoc(true);
	while (true)
	{
		if (PointReachable(ScriptedPawn(pawn).destLoc))
		{
			if (ScriptedPawn(pawn).ShouldPlayWalk(ScriptedPawn(pawn).destLoc))
				  ScriptedPawn(pawn).PlayWalking();
			MoveTo(ScriptedPawn(pawn).destLoc,,true);//, GetWalkingSpeed());
			ScriptedPawn(pawn).CheckDestLoc(ScriptedPawn(pawn).destLoc);
			break;
		}
		else
		{
			MoveTarget = FindPathTo(ScriptedPawn(pawn).destLoc);
			if (MoveTarget != None)
			{
				if (ScriptedPawn(pawn).ShouldPlayWalk(MoveTarget.Location))
					ScriptedPawn(pawn).PlayWalking();
				MoveToward(MoveTarget,,0,false, true);//, GetWalkingSpeed());
				ScriptedPawn(pawn).CheckDestLoc(MoveTarget.Location, true);
			}
			else
				break;
		}
	}
	ScriptedPawn(pawn).EnableCheckDestLoc(false);
	Goto('Pausing');

Wander:
	WaitForLanding();
WanderInternal:
	PickDestination();

Moving:
	// Move from pathnode to pathnode until we get where we're going
	// (ooooold code -- no longer used)
/*if (destPoint != None)
	{
		if (ScriptedPawn(pawn).ShouldPlayWalk(MoveTarget.Location))
			  ScriptedPawn(pawn).PlayWalking();
		MoveToward(MoveTarget,,0,false, true);// GetWalkingSpeed());
		while ((MoveTarget != None) && (MoveTarget != ScriptedPawn(pawn).destPoint))
		{
			MoveTarget = FindPathToward(destPoint);
			if (MoveTarget != None)
			{
				if (ScriptedPawn(pawn).ShouldPlayWalk(MoveTarget.Location))
					ScriptedPawn(pawn).PlayWalking();
				MoveToward(MoveTarget,,0,false, true);//, GetWalkingSpeed());
			}
		}
	}
	else if (ScriptedPawn(pawn).destLoc != pawn.Location)
	{
		if (ScriptedPawn(pawn).ShouldPlayWalk(ScriptedPawn(pawn).destLoc))
			ScriptedPawn(pawn).PlayWalking();
		MoveTo(ScriptedPawn(pawn).destLoc,,true);// GetWalkingSpeed());
	}
	else
		Sleep(0.5);*/

Pausing:
	pawn.Acceleration = vect(0, 0, 0);

	// Turn in the direction dictated by the WanderPoint, if there is one
	sleepTime = 6.0;
	if (WanderPoint(destPoint) != None)
	{
		if (WanderPoint(destPoint).gazeItem != None)
		{
			LookAtActor(WanderPoint(destPoint).gazeItem);
			sleepTime = WanderPoint(destPoint).gazeDuration;
		}
		else if (WanderPoint(destPoint).gazeDirection != vect(0, 0, 0))
			LookAtVector(pawn.Location + WanderPoint(destPoint).gazeDirection);
	}
	Enable('AnimEnd');
	ScriptedPawn(pawn).TweenToWaiting(0.2);
	ScriptedPawn(pawn).bAcceptBump = True;
	ScriptedPawn(pawn).PlayScanningSound();
	sleepTime *= (-0.9*ScriptedPawn(pawn).restlessness) + 1;
	Sleep(sleepTime);
	Disable('AnimEnd');
	ScriptedPawn(pawn).bAcceptBump = False;
	ScriptedPawn(pawn).FinishAnim();
	Goto('Wander');

ContinueWander:
ContinueFromDoor:
	ScriptedPawn(pawn).FinishAnim();
	ScriptedPawn(pawn).PlayWalking();
	Goto('Wander');
}





defaultproperties
{
	bCanOpenDoors=true
	bCanDoSpecial=true
  bIsPlayer=false
  bStasis=false


   bAdvancedTactics=false
   RotationRate=(Pitch=4096,Yaw=50000,Roll=3072)
}

