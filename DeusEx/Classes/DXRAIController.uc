/*
  Базовый контроллер ИИ для класса ScriptedPawn.
  Дочерние классы соответветственно для подклассов, при условии что есть различия в состояниях.
  Контроллер ссылается на ScriptedPawn, которым он управляет.

  Основной принцип такой: все стейты и все что с ними связано, помещается в контроллер.
  Все остальное в Pawn.

  Важно: нельзя вызывать latent функции Pawn! Это может привести (и приведет) к бесконечной рекурсии.
  Если нужно выполнить FinishAnim(), то нужно вызывать её напрямую, контроллер при этом сделает то что нужно для Pawn.
*/

class DXRAiController extends DeusExAiController;

const Stunned_Delay = 15;
const RubbingEyes_Delay = 15;
const OpeningDoorSleepTime = 5.0;

const DAMAGE_DOOR_BY_NPC_VALUE = 200;
const ALARM_UNIT_FIND_RADIUS = 2400;
const STATE_SHADOWING_DIST = 900;

const HIDEPOINT_CHECK_RADIUS = 10000;

const FALLBACK_IF_STUCK_VALUE = -10.00;
const CHAIR_IS_CLOSE_DIST = 100; // 70

// Из Unreal, для постановки состояния в очередь.
var name NextState;
var name NextLabel;

var float sleepTime;

var Actor ChairActor;
var vector ChairLoc;
var bool bChairFirstHit;

var vector PrevLookVector;
var bool bSeatIsPointInCylinder;

var Actor PrevLookActor;
var DestLocMarker mark;

/** Utilities ********************************************************************************************************************************************************************/

function WaitForMover(Mover M);
function NotifyTouch(actor toucher);
function SwitchToBestWeapon();

event Destroyed()
{
    Super.Destroyed();

    // Уничтожить маркер для отладки ИИ, поскольку Pawn уже не существует.
    if (mark != None)
        mark.destroy();
}

function float LoudNoiseScore(actor receiver, actor sender, float score)
{
    if (ScriptedPawn(pawn) != None)
        return ScriptedPawn(pawn).LoudNoiseScore(receiver, sender, score);
}

// Приходит из ScriptedPawn, передаем в другую функцию. Нужно для переопределения в состояниях. 
// Global(NotifyTakeDamage(...)) вызовет именно этот вариант.
function NotifyTakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class <damageType> damageType)
{
    ScriptedPawn(Pawn).TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, true);
}

// Застрял(а)? Иди хоть куда-нибудь!
function FallBackIfStuck()
{
   if ((pawn != None) && (pawn.ReachedDestination(MoveTarget) == false))
      ScriptedPawn(Pawn).BackOff();
}

// Срабатывает когда NPC стоит на краю и может упасть.
event MayFall()
{
//   log(pawn@" May Fall ?");
//   Pawn.bCanJump = true;
//   Pawn.Velocity = EAdjustJump(0,Pawn.GroundSpeed);
} 

event NotifyMissedJump()
{
   log(pawn@" MissedJump ?");
}

//
// LookAtActor - DEUS_EX STM
//

function LookAtActor(Actor targ, bool bRotate,
                     bool bLookHorizontal, bool bLookVertical,
                     optional float DelayTime, optional float rate,
                     optional float LockAngle, optional float AngleOffset)
{
    local vector lookTo;

    // If we're looking at a pawn, look at the head;
    // otherwise, look at the center point

    lookTo = targ.Location;
    if (Pawn(targ) != None)
        lookTo += (vect(0,0,1)*Pawn(targ).BaseEyeHeight);
    else if (DeusExDecoration(targ) != None)
        lookTo += (vect(0,0,1)*DeusExDecoration(targ).BaseEyeHeight);
    else
        lookTo += (vect(0,0,1)*targ.CollisionHeight*0.75);

    LookAtVector(lookTo, bRotate, bLookHorizontal, bLookVertical,
                 DelayTime, rate, LockAngle, AngleOffset);
}

//
// LookAtVector - DEUS_EX STM
//

function LookAtVector(vector lookTo, bool bRotate,
                      bool bLookHorizontal, bool bLookVertical,
                      optional float DelayTime, optional float rate,
                      optional float LockAngle, optional float AngleOffset)
{
    local vector         lookFrom;
    local rotator        lookAngle;
    local int            hPos, vPos;
    local int            hAngle, vAngle;
    local int            hAbs, vAbs;
    local int            hRot;
    local ScriptedPawn.ELookDirection lookDir;

    if (rate <= 0)
        rate = 1.0;

    // Head movement angles
    hAngle = 54; //5461;  // 30 degrees horizontally // ToDo: модель с капризами стоит +- 500$
    vAngle = 27; //2731;  // 15 degrees vertically // В оригинале на остаток NPC доворачивал голову в нужном направлении.

    // Determine our angle to the target
    lookFrom  = pawn.Location + (vect(0,0,1)*pawn.CollisionHeight*0.9);
    lookAngle = Rotator(lookTo - lookFrom);
    lookAngle.Yaw = (lookAngle.Yaw - pawn.Rotation.Yaw) & 65535;
    if (lookAngle.Yaw > 32767)
        lookAngle.Yaw -= 65536;
    if (lookAngle.Pitch > 32767)
        lookAngle.Pitch -= 65536;

    // hPos and vPos determine which way the pawn needs to look
    // horizontally and vertically

    hPos = 0;
    vPos = 0;

    // Do we need to look up or down?
    if (bLookVertical)
    {
        if (lookAngle.Pitch > vAngle * 0.9)
            vPos = 1;
        else if (lookAngle.Pitch < -vAngle * 0.75)
            vPos = -1;
    }

    // Do we need to look left or right?
    if (bLookHorizontal)
    {
        if (lookAngle.Yaw > hAngle * 0.5)
            hPos = 1;
        else if (lookAngle.Yaw < -hAngle * 0.5)
            hPos = -1;
    }

    hAbs = Abs(lookAngle.Yaw);
    vAbs = Abs(lookAngle.Pitch);

    if (bRotate)
    {
        hRot = lookAngle.Yaw;

        // Hack -- NPCs that look horizontally or vertically, AND rotate, will use inexact rotations
        if (bLookHorizontal && (vPos == 0))
        {
            if (hRot > hAngle * 1.2)
                hRot -= hAngle * 1.2;
            else if (hRot < -hAngle * 1.2)
                hRot += hAngle * 1.2;
            else
                hRot = 0;
        }
        else if (bLookVertical && (hPos == 0))
        {
            if (hRot > hAngle * 0.35)
                hRot -= hAngle * 0.35;
            else if (hRot < -hAngle * 0.35)
                hRot += hAngle * 0.35;
            else
                hRot = 0;
        }

        // Clamp the rotation angle, based on the angles passed in
        if (AngleOffset > 0)
        {
            hRot = (hRot + (pawn.Rotation.Yaw - LockAngle) + 65536 * 4) & 65535;
            if (hRot > 32767)
                hRot -= 65536;
            if      (hRot < -AngleOffset)
                hRot = -AngleOffset;
            else if (hRot > AngleOffset)
                hRot = AngleOffset;
            hRot = (hRot + (LockAngle - pawn.Rotation.Yaw) + 65536 * 4) & 65535;
            if (hRot > 32767)
                hRot -= 65536;
        }

        // Compute actual rotation, based on new angle
        hAbs = (65536 + lookAngle.Yaw - hRot) & 65535;
        if (hAbs > 32767)
            hAbs = 65536-hAbs;
    }

    // No rotation
    else
        hRot = 0;

    // We can't look vertically AND horizontally at the same time
    // (we need a skeletal animation system!!!)

    if ((hPos != 0) && (vPos != 0))
    {
        if (hAbs > vAbs)
            vPos = 0;
        else
            hPos = 0;
    }

    // Play head turning animation
    if (hPos > 0)
        lookDir = LOOK_Right;
    else if (hPos < 0)
        lookDir = LOOK_Left;
    else if (vPos > 0)
        lookDir = LOOK_Up;
    else if (vPos < 0)
        lookDir = LOOK_Down;
    else
        lookDir = LOOK_Forward;
    if ((bLookHorizontal || bLookVertical) && (ScriptedPawn(pawn).animTimer[1] >= DelayTime)) 
        ScriptedPawn(pawn).PlayTurnHead(lookDir, 1.0, rate);

    // Turn as necessary
    if (bRotate)
        TurnTo(vector(pawn.Rotation + rot(0,1,0) * hRot));
}

function HandleSighting(DeusExPawn pawnSighted)
{
    SetSeekLocation(pawnSighted, pawnSighted.Location, SEEKTYPE_Sight);
    GotoState('Seeking');
}

function ReactToInjury(Pawn instigatedBy, class<DamageType> damageType, ScriptedPawn.EHitLocation hitPos)
{
    local Name currentState;
    local bool bHateThisInjury;
    local bool bFearThisInjury;

    if ((pawn.health > 0) && (instigatedBy != None) && (ScriptedPawn(pawn).bLookingForInjury || ScriptedPawn(pawn).bLookingForIndirectInjury))
    {
        currentState = GetStateName();

        bHateThisInjury = ShouldReactToInjuryType(damageType, ScriptedPawn(pawn).bHateInjury, ScriptedPawn(pawn).bHateIndirectInjury);
        bFearThisInjury = ShouldReactToInjuryType(damageType, ScriptedPawn(pawn).bFearInjury, ScriptedPawn(pawn).bFearIndirectInjury);

        if (bHateThisInjury)
            ScriptedPawn(pawn).IncreaseAgitation(instigatedBy);
        if (bFearThisInjury)
            ScriptedPawn(pawn).IncreaseFear(instigatedBy, 2.0);

        if (SetEnemy(instigatedBy))
        {
            ScriptedPawn(pawn).SetDistressTimer();
            SetNextState('HandlingEnemy');
        }
        else if (bFearThisInjury && ScriptedPawn(pawn).IsFearful())
        {
            ScriptedPawn(pawn).SetDistressTimer();
            SetEnemy(instigatedBy, , true);
            SetNextState('Fleeing');
        }
        else
        {
            SetNextState(currentState);
        }
        GotoDisabledState(damageType, hitPos);
    }
}

function SetSeekLocation(DeusExPawn seekCandidate, vector newLocation, ScriptedPawn.ESeekType newSeekType, optional bool bNewPostCombat)
{
    SetEnemy(None, 0, true);
    ScriptedPawn(pawn).SeekPawn      = seekCandidate;
    LastSeenPos                      = newLocation;
    ScriptedPawn(pawn).bSeekLocation = True;
    ScriptedPawn(pawn).SeekType      = newSeekType;

    if (newSeekType == SEEKTYPE_Carcass)
        ScriptedPawn(pawn).CarcassTimer = 120.0;

    if (newSeekType == SEEKTYPE_Sight)
        ScriptedPawn(pawn).SeekLevel = Max(ScriptedPawn(pawn).SeekLevel, 1);
    else
        ScriptedPawn(pawn).SeekLevel = Max(ScriptedPawn(pawn).SeekLevel, 3);

    if (bNewPostCombat)
        ScriptedPawn(pawn).bSeekPostCombat = true;
}

function bool IsLocationDangerous(ScriptedPawn.NearbyProjectileList projList,vector aLocation)
{
    return ScriptedPawn(Pawn).IsLocationDangerous(projList,aLocation);
}
//----------------------------------------------------------------------
function bool ShouldFlee()
{
    return ScriptedPawn(pawn).ShouldFlee();
}

function bool HasEnemyTimedOut()
{
    return ScriptedPawn(pawn).HasEnemyTimedOut();
}
//----------------------------------------------------------------------
function bool ShouldReactToInjuryType(class <damageType> DamageType,bool bHatePrimary, bool bHateSecondary)
{
   return ScriptedPawn(Pawn).ShouldReactToInjuryType(DamageType,bHatePrimary, bHateSecondary);
}
//----------------------------------------------------------------------
function bool ShouldStrafe()
{
    // This may be overridden from subclasses
    return (ScriptedPawn(pawn).AICanShoot(DeusExPawn(enemy), false, false, 0.025, true));
}
//----------------------------------------------------------------------
function Reloading(DeusExWeapon reloadWeapon, float reloadTime)
{
    if (reloadWeapon == pawn.Weapon)
        ScriptedPawn(Pawn).ReloadTimer = reloadTime;
}

function DoneReloading(DeusExWeapon reloadWeapon)
{
    if (reloadWeapon == pawn.Weapon)
        ScriptedPawn(Pawn).ReloadTimer = 0;
}

function bool IsWeaponReloading()
{
    return ScriptedPawn(pawn).IsWeaponReloading();
}

function bool IsNearHome(vector position)
{
    return ScriptedPawn(pawn).IsNearHome(position);
}

function int GetProjectileList(out ScriptedPawn.NearbyProjectileList projList, vector aLocation)
{
    return ScriptedPawn(Pawn).GetProjectileList(projList,  aLocation);
}


event PostSetInitialState()
{
    if (mark == None)
        mark = Spawn(class'DestLocMarker');
}

event LongFall() // called when latent function WaitForLanding() doesn't return after 4 seconds
{
    SetFall();
    GotoState('FallingState', 'LongFall');
}

function GotoDisabledState(class<DamageType> damageType, ScriptedPawn.EHitLocation hitPos)
{
    if (!ScriptedPawn(pawn).bCollideActors && !ScriptedPawn(pawn).bBlockActors && !ScriptedPawn(pawn).bBlockPlayers)
        return;
    else if ((damageType == class'DM_TearGas') || (damageType == class'DM_HalonGas'))
        GotoState('RubbingEyes');
    else if (damageType == class'DM_Stunned')
        GotoState('Stunned');
    else if (ScriptedPawn(pawn).CanShowPain())
        ScriptedPawn(pawn).TakeHit(hitPos);
    else
        GotoNextState();
}

function SetFall()
{
    GotoState('FallingState');
}

function TurnTo(vector NewFocus)
{
   Focus = None;
   FocalPoint = pawn.location + NewFocus;
}

function TurnToward(Actor A)
{
   //Focus = A;           // actor being looked at
   Focus = None;
   FocalPoint = A.Location;
}

function bool IsSeatValid(Actor checkActor)
{
   return ScriptedPawn(pawn).IsSeatValid(checkActor);
}

function bool SetEnemy(Pawn newEnemy, optional float newSeenTime, optional bool bForce)
{
  if (ScriptedPawn(pawn) != None)
   return ScriptedPawn(pawn).SetEnemy(newEnemy, newSeenTime, bForce);
  else
   return false;
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


function bool GetNextVector(Actor destination, out vector outVect)
{
    local bool    bValid;
    local rotator rot;
    local float   dist;
    local float   maxDist;

    bValid = true;
    if (destination != None)
    {
        maxDist = 64;
        rot     = Rotator(destination.Location - pawn.Location);
        dist    = VSize(destination.Location - pawn.Location);
        if (dist < maxDist)
            outVect = destination.Location;
        else if (!AIDirectionReachable(pawn.Location, rot.Yaw, rot.Pitch,0, maxDist, outVect))
            bValid = false;
    }
    else
        bValid = false;

    return (bValid);
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

function SetOrders(Name orderName, optional Name newOrderTag, optional bool bImmediate)
{
    local bool bHostile;
    local DeusExPawn orderEnemy;

//    log(pawn@"SetOrders: Name="$orderName$" OrderTag="$newOrderTag$" bImmediate? ="$bImmediate);

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
        orderEnemy = DeusExPawn(ScriptedPawn(pawn).FindTaggedActor(newOrderTag, false, class'Pawn'));
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
    ScriptedPawn(pawn).ConvOrders   = '';
    ScriptedPawn(pawn).ConvOrderTag = '';
}

function pawn GetPlayerPawn()
{
 return level.GetLocalPlayerController().pawn;
}

function StopBlendAnims()
{
    ScriptedPawn(pawn).AIAddViewRotation = rot(0, 0, 0);
//  Super.StopBlendAnims();
    ScriptedPawn(pawn).StopAnimating(false);
    ScriptedPawn(pawn).PlayTurnHead(LOOK_Forward, 1.0, 1.0);
}

function StopAcc()
{
    if(pawn.Physics == PHYS_WALKING)
    {
        // Don't set Z values
        pawn.Acceleration = vect(0,0,0);
        pawn.Velocity = vect(0, 0, 0);
    }
}

function Actor GetNextWaypoint(Actor MyDestination)
{
    local Actor aMoveTarget;

    if (MyDestination == None)
        aMoveTarget = None;
    else if (ActorReachable(MyDestination))
        aMoveTarget = MyDestination;
    else
        aMoveTarget = FindPathToward(MyDestination, true); // false

    return aMoveTarget;
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

function EnableCheckDestLoc(bool bEnable)
{
  ScriptedPawn(Pawn).EnableCheckDestLoc(bEnable);
}

/*-------------------------------------------------------------------*/
function bool FrobDoor(actor Target)
{
    local DeusExMover      dxMover;
    local DeusExMover      triggerMover;
    local DeusExDecoration trigger;
    local float            dist;
    local DeusExDecoration bestTrigger;
    local float            bestDist;
    local bool             bDone;

    bDone = false;

    dxMover = DeusExMover(Target);
    if (dxMover != None)
    {
        bestTrigger = None;
        bestDist    = 10000;
        foreach pawn.AllActors(Class'DeusExDecoration', trigger)
        {
            if (dxMover.Tag == trigger.Event)
            {
                dist = VSize(pawn.Location - trigger.Location);
                if ((bestTrigger == None) || (bestDist > dist))
                {
                    bestTrigger = trigger;
                    bestDist    = dist;
                }
            }
        }
        if (bestTrigger != None)
        {
            foreach pawn.AllActors(Class'DeusExMover', triggerMover, dxMover.Tag)
                triggerMover.Trigger(bestTrigger, pawn);
            bDone = true;
        }
        else if (dxMover.bFrobbable)
        {
            if ((dxMover.WaitingPawn == None) || (dxMover.WaitingPawn == pawn))
            {
                dxMover.Frob(pawn, None);
                bDone = true;
            }
        }

        if (bDone)
            dxMover.WaitingPawn = pawn;
    }
    return bDone;
}

/*-------------------------------------------------------------------*/
function bool IsDoor(Actor door, optional bool bWarn)
{
    local bool        bIsDoor;
    local DeusExMover dxMover;

    bIsDoor = false;

    dxMover = DeusExMover(door);
    if (dxMover != None)
    {
        if (dxMover.NumKeys > 1)
        {
            if (dxMover.bIsDoor)
                bIsDoor = true;

            else if (bWarn && bCanOpenDoors)  // hack for now // DXR: only spamLog if can open doors
                log("WARNING: NPC "$pawn$" trying to use door "$dxMover$", but bIsDoor flag is False");

        }
    }
    return bIsDoor;
}

/*-------------------------------------------------------------------*/
function CheckOpenDoor(vector HitNormal, actor Door, optional name Label)
{
    local DeusExMover dxMover;

    dxMover = DeusExMover(Door);
    if (dxMover != None)
    {
        //== Y|y: Only allow this for NPCs who are carrying a weapon
        if (bCanOpenDoors && !IsDoor(dxMover) && dxMover.bBreakable && pawn.Weapon != None)  // break glass we walk into
        {
            dxMover.TakeDamage(DAMAGE_DOOR_BY_NPC_VALUE, pawn, dxMover.Location, pawn.Velocity, class'DM_Shot');
            return;
        }

        if (dxMover.bInterpolating && (dxMover.MoverEncroachType == ME_IgnoreWhenEncroach))
            return;

        if (bCanOpenDoors && ScriptedPawn(Pawn).bInterruptState && !ScriptedPawn(Pawn).bInTransientState && IsDoor(dxMover, true))
        {
            if (Label == '')
                Label = 'Begin';

            if (GetStateName() != 'OpeningDoor')
                SetNextState(GetStateName(), 'ContinueFromDoor');

            Target = Door;
            ScriptedPawn(Pawn).destLoc = HitNormal;
            GotoState('OpeningDoor', 'BeginHitNormal');
        }
        else if ((pawn.Acceleration != vect(0,0,0)) && (pawn.Physics == PHYS_Walking) && (ScriptedPawn(Pawn).TurnDirection == TURNING_None))
            Destination = pawn.Location;
    }
}

function AlterDest()
{
    local Rotator  dir;
    local int      avoidYaw;
    local int      destYaw;
    local int      moveYaw;
    local int      angle;
    local bool     bPointInCylinder;
    local float    dist1, dist2;
    local bool     bAround;
    local vector   tempVect;
    local ScriptedPawn myPawn;
    local ScriptedPawn.ETurning oldTurnDir;

//    FocalPoint = pawn.Location;
//    Pawn.Acceleration = vect(0,0,0);
    Focus = None; //

    myPawn = ScriptedPawn(pawn);

    oldTurnDir = myPawn.TurnDirection;

    // Sanity check -- are we done walking around the actor?
    if (myPawn.TurnDirection != TURNING_None)
    {
        if (!myPawn.bWalkAround)
        {
            myPawn.TurnDirection = TURNING_None;
            FocalPoint = destination;
        }
        else if (myPawn.bClearedObstacle)
        {
            myPawn.TurnDirection = TURNING_None;
            FocalPoint = destination;
        }
        else if (myPawn.ActorAvoiding == None)
        {
            myPawn.TurnDirection = TURNING_None;
            FocalPoint = destination;
        }
        else if (myPawn.ActorAvoiding.bDeleteMe)
        {
            myPawn.TurnDirection = TURNING_None;
            FocalPoint = destination;
        }
        else if (!IsPointInCylinder(myPawn.ActorAvoiding, myPawn.Location,myPawn.CollisionRadius*2, myPawn.CollisionHeight*2))
        {
            myPawn.TurnDirection = TURNING_None;
            FocalPoint = destination;
        }
    }

    // Are we still turning?
    if (myPawn.TurnDirection != TURNING_None)
    {
        bAround = false;

        // Is our destination point inside the actor we're walking around?
        bPointInCylinder = IsPointInCylinder(myPawn.ActorAvoiding, destination, myPawn.CollisionRadius-8, myPawn.CollisionHeight-8);
        if (bPointInCylinder)
        {
            dist1 = VSize((myPawn.Location - myPawn.ActorAvoiding.Location)*vect(1,1,0));
            dist2 = VSize((myPawn.Location - destination)*vect(1,1,0));

            // Are we on the right side of the actor?
            if (dist1 > dist2)
            {
                // Just make a beeline, if possible
                tempVect = destination - myPawn.ActorAvoiding.Location;
                tempVect.Z = 0;
                tempVect = Normal(tempVect) * (myPawn.ActorAvoiding.CollisionRadius + myPawn.CollisionRadius);

                if (tempVect == vect(0,0,0))
                {
                    destination = myPawn.Location;
                    FocalPoint = destination;
                }
                else
                {
                    tempVect += myPawn.ActorAvoiding.Location;
                    tempVect.Z = destination.Z;
                    destination = tempVect;
                    FocalPoint = Destination;
                }
            }
            else
                bAround = true;
        }
        else
            bAround = true;

        // We have a valid destination -- continue to walk around
        if (bAround)
        {
            // Determine the destination-self-obstacle angle
            dir      = Rotator(myPawn.ActorAvoiding.Location - myPawn.Location);
            avoidYaw = dir.Yaw;
            dir      = Rotator(destination - myPawn.Location);
            destYaw  = dir.Yaw;

            if (myPawn.TurnDirection == TURNING_Left)
                angle = (avoidYaw - destYaw) & 65535;
            else
                angle = (destYaw - avoidYaw) & 65535;
            if (angle < 0)
                angle += 65536;

            // If the angle is between 90 and 180 degrees, we've cleared the obstacle
            if (bPointInCylinder || (angle < 16384) || (angle > 32768))  // haven't cleared the actor yet
            {
                if (myPawn.TurnDirection == TURNING_Left)
                    moveYaw = avoidYaw - 16384;
                else
                    moveYaw = avoidYaw + 16384;
                    destination = myPawn.Location + vector(rot(0,1,0)*moveYaw)*400;
                    FocalPoint = Destination;
            }
            else  // cleared the actor -- move on
            {
                myPawn.TurnDirection = TURNING_None;
                FocalPoint = Destination;
            }
        }
    }

    if (myPawn.TurnDirection == TURNING_None)
    {
        if (myPawn.ObstacleTimer > 0)
        {
            myPawn.TurnDirection = oldTurnDir;
            myPawn.bClearedObstacle = true;
            FocalPoint = Destination;
        }
    }
    else
        myPawn.ObstacleTimer = 1.5;

    // Reset if done turning
    if (myPawn.TurnDirection == TURNING_None)
    {
        myPawn.NextDirection    = TURNING_None;
        myPawn.ActorAvoiding    = None;
        //myPawn.bAdvancedTactics = false;
        bUseAlterDest = false;
        myPawn.ObstacleTimer    = 0;
        myPawn.bClearedObstacle = true;

        if (oldTurnDir != TURNING_None)
            MoveTimer -= 4.0;
    }
}


/*-------------------------------------------------------------------*/
event bool NotifyBump(Actor Other)
{
    local Rotator      rot1, rot2;
    local int          yaw;
    local ScriptedPawn avoidPawn;
    local DeusExPlayer dxPlayer;
    local bool         bTurn;

//    log(pawn@"__ NotifyBump with Actor"@Other);

    // Handle futzing and projectiles
    if (Other.Physics == PHYS_Falling)
    {
        if (DeusExProjectile(Other) != None)
            ScriptedPawn(pawn).ReactToProjectiles(Other);
        else
        {
            dxPlayer = DeusExPlayer(Other.Instigator);
            if ((Other != dxPlayer) && (dxPlayer != None))
                ScriptedPawn(pawn).ReactToFutz();
        }
    }
    
    // Have we walked into another (non-level) actor?
    bTurn = false;
    if ((pawn.Physics == PHYS_Walking) && (pawn.Acceleration != vect(0,0,0)) && ScriptedPawn(pawn).bWalkAround && (Other != Level) && !Other.IsA('Mover'))
        if ((ScriptedPawn(pawn).TurnDirection == TURNING_None) || (ScriptedPawn(pawn).AvoidBumpTimer <= 0))
            if (HandleTurn(Other))
                bTurn = true;

    // Turn away from the actor
    if (bTurn)
    {
        // If we're not already turning, start
        if (ScriptedPawn(pawn).TurnDirection == TURNING_None)
        {
            // Give ourselves a little extra time
            MoveTimer += 4.0;

            rot1 = Rotator(Other.Location-pawn.Location);  // direction of object being bumped
            rot2 = Rotator(pawn.Acceleration);  // direction we wish to go
            yaw  = (rot2.Yaw - rot1.Yaw) & 65535;
            if (yaw > 32767)
                yaw -= 65536;

            // Depending on the angle we bump the actor, turn left or right
            if (yaw < 0)
            {
                ScriptedPawn(pawn).TurnDirection = TURNING_Left;
                ScriptedPawn(pawn).NextDirection = TURNING_Right;
            }
            else
            {
                ScriptedPawn(pawn).TurnDirection = TURNING_Right;
                ScriptedPawn(pawn).NextDirection = TURNING_Left;
            }
            ScriptedPawn(pawn).bClearedObstacle = false;

            // Enable AlterDestination()
            bUseAlterDest = true;
//            Focus = None;
            //ScriptedPawn(pawn).bAdvancedTactics = true;
    }

        // Ignore multiple bumps in a row
        // BOOGER! Ignore same bump actor?
        if (ScriptedPawn(pawn).AvoidBumpTimer <= 0)
        {
            ScriptedPawn(pawn).AvoidBumpTimer   = 0.2;
            ScriptedPawn(pawn).ActorAvoiding    = Other;
            ScriptedPawn(pawn).bClearedObstacle = false;

            avoidPawn = ScriptedPawn(ScriptedPawn(pawn).ActorAvoiding);

            // Avoid pairing off
            if (avoidPawn != None)
            {
                if ((avoidPawn.Acceleration != vect(0,0,0)) && (avoidPawn.Physics == PHYS_Walking) && (avoidPawn.TurnDirection != TURNING_None) && (avoidPawn.ActorAvoiding == pawn))
                {
                    if ((avoidPawn.TurnDirection == TURNING_Left) && (ScriptedPawn(pawn).TurnDirection == TURNING_Right))
                    {
                        ScriptedPawn(pawn).TurnDirection = TURNING_Left;
                        if (ScriptedPawn(pawn).NextDirection != TURNING_None)
                            ScriptedPawn(pawn).NextDirection = TURNING_Right;
                    }
                    else if ((avoidPawn.TurnDirection == TURNING_Right) && (ScriptedPawn(pawn).TurnDirection == TURNING_Left))
                    {
                        ScriptedPawn(pawn).TurnDirection = TURNING_Right;
                        if (ScriptedPawn(pawn).NextDirection != TURNING_None)
                            ScriptedPawn(pawn).NextDirection = TURNING_Left;
                    }
                }
            }
        }
    }
  return false; // true -- pawn don't receive Bump() event.
}

event bool NotifyHitWall(vector HitLocation, Actor hitActor)
{
    local ScriptedPawn avoidPawn;
    local ScriptedPawn myPawn;

    // We only care about HitWall as it pertains to level geometry
    // DXR: Похоже здесь это условие не требуется...
//    if ((hitActor != Level) || (hitActor.bWorldGeometry == false))
//    {
//        return true;
//    }
        myPawn = ScriptedPawn(pawn);

        // DXR: Я должна это сбросить, иначе Pawn будет нервно дергаться :D
        focus = None;
        //focalPoint = myPawn.destLoc;
        Destination = focalPoint;

    // Are we walking?
    if ((myPawn.Physics == PHYS_Walking) && (myPawn.Acceleration != vect(0,0,0)) && myPawn.bWalkAround && (myPawn.AvoidWallTimer <= 0))
    {
        // Are we turning?
        if (myPawn.TurnDirection != TURNING_None)
        {
            myPawn.AvoidWallTimer = 1.0;

            // About face
            myPawn.TurnDirection    = myPawn.NextDirection;
            myPawn.NextDirection    = TURNING_None;
            myPawn.bClearedObstacle = false;

            // Avoid pairing off
            avoidPawn = ScriptedPawn(myPawn.ActorAvoiding);
            if (avoidPawn != None)
            {
                if ((avoidPawn.Acceleration != vect(0,0,0)) && (avoidPawn.Physics == PHYS_Walking) &&
                    (avoidPawn.TurnDirection != TURNING_None) && (avoidPawn.ActorAvoiding == myPawn))
                {
                    if ((avoidPawn.TurnDirection == TURNING_Left) && (myPawn.TurnDirection == TURNING_Right))
                        myPawn.TurnDirection = TURNING_None;
                    else if ((avoidPawn.TurnDirection == TURNING_Right) && (myPawn.TurnDirection == TURNING_Left))
                        myPawn.TurnDirection = TURNING_None;
                }
            }

            // Stopped turning?  Shut down
            if (myPawn.TurnDirection == TURNING_None)
            {
                myPawn.ActorAvoiding = None;
                //bAdvancedTactics = false;
                bUseAlterDest = false;
                MoveTimer -= 4.0;
                myPawn.ObstacleTimer = 0;
            }
        }
    }
    return !ScriptedPawn(Pawn).bCrouchToPassObstacles; //true; // true -- pawn don't receive HitWall() event.
}

function bool HandleTurn(actor Other)
{
    local bool             bHandle;
    local bool             bHackState;
    local DeusExDecoration dxDecoration;
    local ScriptedPawn     scrPawn;

    // THIS ENTIRE SECTION IS A MASSIVE HACK TO GET AROUND PATHFINDING PROBLEMS
    // WHEN AN OBSTACLE COMPLETELY BLOCKS AN NPC'S PATH...

    bHandle    = true;
    bHackState = false;
    if (ScriptedPawn(pawn).bEnableCheckDest)
    {
        if (ScriptedPawn(pawn).DestAttempts >= 2)
        {
            dxDecoration = DeusExDecoration(Other);
            scrPawn      = ScriptedPawn(Other);
            if (dxDecoration != None)
            {
                if (!dxDecoration.bInvincible && !dxDecoration.bExplosive)
                {
                    dxDecoration.HitPoints = 0;
                    dxDecoration.TakeDamage(1, pawn, dxDecoration.Location, vect(0,0,0), class'DM_Shot'); // Kick
                    bHandle = false;
                }
                else if (ScriptedPawn(pawn).DestAttempts >= 3)
                {
                    bHackState = true;
                    bHandle    = false;
                }
            }
            else if (scrPawn != None)
            {
                if (ScriptedPawn(pawn).DestAttempts >= 3)
                {
                    if (GetStateName() != 'BackingOff')
                    {
                        bHackState = true;
                        bHandle    = false;
                    }
                }
            }
        }

        if (bHackState)
            ScriptedPawn(pawn).BackOff();
    }
    return (bHandle);
}


/** States ***********************************************************************************************************************************************************************/

auto state StartUp
{
  event BeginState()
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

  event EndState()
  {
     if (scriptedPawn(pawn) != None)
     {
        scriptedPawn(pawn).bCanConverse = true;
        scriptedPawn(pawn).bStasis = true;
        ScriptedPawn(pawn).ResetReactions();
     }
  }

  event Tick(float deltaSeconds)
  {
     Global.Tick(deltaSeconds);
//     SetFall();//
     if (Level.TimeSeconds - pawn.LastRenderTime <= 1.0)
     {
        pawn.PlayWaiting();
        scriptedPawn(pawn).InitializePawn();

//        if (scriptedPawn(pawn).bInWorld) // Fixed crash on 03_NYC_Airfield, when pawn tried to patrol outside of world 0_o
        SetFall();//
        FollowOrders();
     }
  }

Begin:
  scriptedPawn(pawn).InitializePawn();
  Sleep(FRand()+0.2);
  WaitForLanding();

Start:
//   if (scriptedPawn(pawn).bInWorld) // Fixed crash on 03_NYC_Airfield, when pawn tried to patrol outside of world 0_o
     SetFall();
     FollowOrders();
}

// ----------------------------------------------------------------------
// state Seeking
//
// Look for enemies in the area
// ----------------------------------------------------------------------
State Seeking
{
    function SetFall()
    {
        StartFalling('Seeking', 'ContinueSeek');
    }

    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (pawn.Physics == PHYS_Falling)
            return false;

        Global.HitWall(HitNormal, Wall);
        CheckOpenDoor(HitNormal, Wall);
        return false;  //!ScriptedPawn(pawn).bCrouchToPassObstacles;
    }

    function bool GetNextLocation(out vector nextLoc)
    {
        local float   dist;
        local rotator aRotation;
        local bool    bDone;
        local float   seekDistance;
        local Actor   hitActor;
        local vector  HitLocation, HitNormal;
        local vector  diffVect;
        local bool    bLOS;

        if (ScriptedPawn(pawn).bSeekLocation)
        {
            if (ScriptedPawn(pawn).SeekType == SEEKTYPE_Guess)
                seekDistance = (200 + FClamp(pawn.GroundSpeed * ScriptedPawn(pawn).EnemyLastSeen * 0.5, 0, 1000));
            else
                seekDistance = 300;
        }
        else
            seekDistance = 60;

        dist  = VSize(pawn.Location - ScriptedPawn(pawn).destLoc);
        bDone = false;
        bLOS  = false;

        if (dist < seekDistance)
        {
            bLOS = true;
            foreach ScriptedPawn(pawn).TraceActorsExt(class'Actor', hitActor, hitLocation, hitNormal, ScriptedPawn(pawn).destLoc, pawn.Location+vect(0,0,1)*pawn.BaseEyeHeight,,0x04)
            {
                if (hitActor != pawn)
                {
                    if (hitActor == Level)
                        bLOS = false;
                    else if (IsPointInCylinder(hitActor, ScriptedPawn(pawn).destLoc, 16, 16))
                        break;
                    else if (hitActor.bBlockSight && !hitActor.bHidden)
                        bLOS = false;
                }
                if (!bLOS)
                    break;
            }
        }

        if (!bLOS)
        {
            if (PointReachable(ScriptedPawn(pawn).destLoc))
            {
                aRotation = Rotator(ScriptedPawn(pawn).destLoc - pawn.Location);
                if (seekDistance == 0)
                    nextLoc = ScriptedPawn(pawn).destLoc;
                else if (!AIDirectionReachable(ScriptedPawn(pawn).destLoc, aRotation.Yaw, aRotation.Pitch, 0, seekDistance, nextLoc))
                    bDone = true;
                if (!bDone && ScriptedPawn(pawn).bDefendHome && !IsNearHome(nextLoc))
                    bDone = true;
                if (!bDone)  // hack, because Unreal's movement code SUCKS
                {
                    diffVect = nextLoc - pawn.Location;
                    if (pawn.Physics == PHYS_Walking)
                        diffVect *= vect(1,1,0);
                    if (VSize(diffVect) < 20)
                        bDone = true;
                    else if (IsPointInCylinder(pawn, nextLoc, 10, 10))
                        bDone = true;
                }
            }
            else
            {
                MoveTarget = FindPathTo(ScriptedPawn(pawn).destLoc);
                if (MoveTarget == None)
                    bDone = true;
                else if (ScriptedPawn(pawn).bDefendHome && !IsNearHome(MoveTarget.Location))
                    bDone = true;
                else
                    nextLoc = MoveTarget.Location;
            }
        }
        else
            bDone = true;

        return (!bDone);
    }

    function bool PickDestination()
    {
        local bool bValid;

        bValid = false;
        if (/*(EnemyLastSeen <= 25.0) &&*/ (ScriptedPawn(pawn).SeekLevel > 0))
        {
            if (ScriptedPawn(pawn).bSeekLocation)
            {
                bValid  = true;
                ScriptedPawn(pawn).destLoc = LastSeenPos;
            }
            else
            {
                bValid = AIPickRandomDestination(130, 250, 0, 0, 0, 0, 2, 1.0, ScriptedPawn(pawn).destLoc);
                if (!bValid)
                {
                    bValid  = true;
                    ScriptedPawn(pawn).destLoc = pawn.Location + VRand()*50;
                }
                else
                    ScriptedPawn(pawn).destLoc += vect(0,0,1) * pawn.BaseEyeHeight;
            }
        }
        log(pawn@"State Seeking PickDestination() returns "@bValid);

        return (bValid);
    }

    function NavigationPoint GetOvershootDestination(float randomness, optional float focus)
    {
        local NavigationPoint navPoint; //, bestPoint;
        /*local float           distance;
        local float           score, bestScore;
        local int             yaw;
        local rotator         rot;
        local float           yawCutoff;

        if (focus <= 0)
            focus = 0.6;

        yawCutoff = int(32768*focus);
        bestPoint = None;
        bestScore = 0;

        foreach ReachablePathnodes(Class'NavigationPoint', navPoint, None, distance)
        {
            if (distance < 1)
                distance = 1;
            rot = Rotator(navPoint.Location-Location);
            yaw = rot.Yaw + (16384*randomness);
            yaw = (yaw-Rotation.Yaw) & 0xFFFF;
            if (yaw > 32767)
                yaw  -= 65536;
            yaw = abs(yaw);
            if (yaw <= yawCutoff)
            {
                score = yaw/distance;
                if ((bestPoint == None) || (score < bestScore))
                {
                    bestPoint = navPoint;
                    bestScore = score;
                }
            }
        }*/

        /*navPoint = FindRandomDest();
        if (navPoint != None)
        {
             log(pawn@"State Seeking() picked "$navPoint);
             return NavigationPoint(FindPathToward(navPoint,true));// bestPoint; Пока заглушка
        }
        else*/ navPoint = NavigationPoint(RouteCache[rand(16)]);
               log(pawn@"State Seeking() picked "$navPoint);
               return navPoint;
    }

    event Tick(float deltaSeconds)
    {
        ScriptedPawn(pawn).animTimer[1] += deltaSeconds;
        Global.Tick(deltaSeconds);
        ScriptedPawn(pawn).UpdateActorVisibility(Enemy, deltaSeconds, 1.0, true);
    }

    function HandleLoudNoise(Name event, EAIEventState state, XAIParams params)
    {
        local Actor bestActor;
        local Pawn  instigatorP;

        if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
        {
            bestActor = params.bestActor;
            if ((bestActor != None) && (ScriptedPawn(Pawn).EnemyLastSeen > 2.0))
            {
                instigatorP = Pawn(bestActor);
                if (instigatorP == None)
                    instigatorP = bestActor.Instigator;
                if (instigatorP != None)
                {
                    if (ScriptedPawn(pawn).IsValidEnemy(DeusExPawn(instigatorP)))
                    {
                        SetSeekLocation(DeusExPawn(instigator), bestActor.Location, SEEKTYPE_Sound);
                        ScriptedPawn(Pawn).destLoc = LastSeenPos;
                        if (ScriptedPawn(Pawn).bInterruptSeek)
                            GotoState('Seeking', 'GoToLocation');
                    }
                }
            }
        }
    }

    function HandleSighting(DeusExPawn pawnSighted)
    {
        if ((ScriptedPawn(pawn).EnemyLastSeen > 2.0) && ScriptedPawn(pawn).IsValidEnemy(pawnSighted))
        {
            SetSeekLocation(pawnSighted, pawnSighted.Location, SEEKTYPE_Sight);
            ScriptedPawn(pawn).destLoc = LastSeenPos;
            if (ScriptedPawn(pawn).bInterruptSeek)
                GotoState('Seeking', 'GoToLocation');
        }
    }

    function BeginState()
    {
        ScriptedPawn(pawn).StandUp();
        ScriptedPawn(pawn).Disable('AnimEnd');
        ScriptedPawn(pawn).destLoc = LastSeenPos;
        ScriptedPawn(pawn).SetReactions(true, true, false, true, true, true, true, true, true, false, true, true);
        ScriptedPawn(pawn).bCanConverse = False;
        ScriptedPawn(pawn).bStasis = false;
        ScriptedPawn(pawn).SetupWeapon(true);
        ScriptedPawn(pawn).SetDistress(false);
        ScriptedPawn(pawn).bInterruptSeek = false;
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
    }

    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
        ScriptedPawn(pawn).Enable('AnimEnd');
        ScriptedPawn(pawn).ResetReactions();
        ScriptedPawn(pawn).bCanConverse = true;
        ScriptedPawn(pawn).bStasis = true;
        StopBlendAnims();
        ScriptedPawn(pawn).SeekLevel = 0;
      }
    }

Begin:
    WaitForLanding();
    pawn.PlayWaiting();
    if ((pawn.Weapon != None) && ScriptedPawn(pawn).bKeepWeaponDrawn && (DeusExWeapon(pawn.Weapon).CockingSound != None) && !ScriptedPawn(pawn).bSeekPostCombat)
        pawn.PlaySound(DeusExWeapon(pawn.Weapon).CockingSound, SLOT_None,,, 1024);
    pawn.Acceleration = vect(0,0,0);
    if (!PickDestination())
        Goto('DoneSeek');

GoToLocation:
    ScriptedPawn(pawn).bInterruptSeek = true;
    pawn.Acceleration = vect(0,0,0);

    if ((DeusExWeapon(pawn.Weapon) != None) && DeusExWeapon(pawn.Weapon).CanReload() && !pawn.Weapon.IsInState('Reload'))
        DeusExWeapon(pawn.Weapon).ReloadAmmo();

    if (ScriptedPawn(pawn).bSeekPostCombat)
        ScriptedPawn(pawn).PlayPostAttackSearchingSound();
    else if (ScriptedPawn(pawn).SeekType == SEEKTYPE_Sound)
        ScriptedPawn(pawn).PlayPreAttackSearchingSound();
    else if (ScriptedPawn(pawn).SeekType == SEEKTYPE_Sight)
    {
        if (ScriptedPawn(pawn).ReactionLevel > 0.5)
            ScriptedPawn(pawn).PlayPreAttackSightingSound();
    }
    else if ((ScriptedPawn(pawn).SeekType == SEEKTYPE_Carcass) && ScriptedPawn(pawn).bSeekLocation)
        ScriptedPawn(pawn).PlayCarcassSound();

    StopBlendAnims();

    if ((ScriptedPawn(pawn).SeekType == SEEKTYPE_Sight) && ScriptedPawn(pawn).bSeekLocation)
        Goto('TurnToLocation');

    ScriptedPawn(pawn).EnableCheckDestLoc(true);
    while (GetNextLocation(ScriptedPawn(pawn).useLoc))
    {
        if (ScriptedPawn(pawn).ShouldPlayWalk(ScriptedPawn(pawn).useLoc))
            ScriptedPawn(pawn).PlayRunning();
        MoveTo(ScriptedPawn(pawn).useLoc,,false);
        ScriptedPawn(pawn).CheckDestLoc(ScriptedPawn(pawn).useLoc);
    }
    ScriptedPawn(pawn).EnableCheckDestLoc(false);

    if ((ScriptedPawn(pawn).SeekType == SEEKTYPE_Guess) && ScriptedPawn(pawn).bSeekLocation)
    {
        MoveTarget = GetOvershootDestination(0.5);
        if (MoveTarget != None)
        {
            if (ScriptedPawn(pawn).ShouldPlayWalk(MoveTarget.Location))
                ScriptedPawn(pawn).PlayRunning();
            MoveToward(MoveTarget, ,,true,false);
        }

        if (AIPickRandomDestination(pawn.CollisionRadius*2, 200+FRand()*200, pawn.Rotation.Yaw, 0.75, pawn.Rotation.Pitch, 0.75, 2, 0.4, ScriptedPawn(pawn).useLoc))
        {
            if (ScriptedPawn(pawn).ShouldPlayWalk(ScriptedPawn(pawn).useLoc))
                ScriptedPawn(pawn).PlayRunning();
            MoveTo(ScriptedPawn(pawn).useLoc,,false);
        }
    }

TurnToLocation:
    log(pawn@"State Seeking TurnToLocation:");
    pawn.Acceleration = vect(0,0,0);
    ScriptedPawn(pawn).PlayTurning();
    FinishRotation();//
    if ((ScriptedPawn(pawn).SeekType == SEEKTYPE_Guess) && ScriptedPawn(pawn).bSeekLocation)
        ScriptedPawn(pawn).destLoc = pawn.Location + vector(pawn.Rotation+(rot(0,1,0)*(Rand(16384)-8192)))*1000;

    if (ScriptedPawn(pawn).bCanTurnHead)
    {
        Sleep(0);  // needed to turn head
        LookAtVector(ScriptedPawn(pawn).destLoc, true, false, true);
//        TurnTo(vector(pawn.DesiredRotation)*1000);//+Location);
//        FinishRotation(); //
    }
    else
    {
//        Focus = None;
        TurnTo(ScriptedPawn(pawn).destLoc - pawn.Location);
//        FinishRotation(); //
    }
    ScriptedPawn(pawn).bSeekLocation = false;
    ScriptedPawn(pawn).bInterruptSeek = false;

    pawn.PlayWaiting();
    Sleep(FRand()*1.5+3.0);

LookAround:
    if (ScriptedPawn(pawn).bCanTurnHead)
    {
        if (FRand() < 0.5)
        {
            if (!ScriptedPawn(pawn).bSeekLocation)
            {
                ScriptedPawn(pawn).PlayTurnHead(LOOK_Left, 1.0, 1.0);
                Sleep(1.0);
            }
            if (!ScriptedPawn(pawn).bSeekLocation)
            {
                ScriptedPawn(pawn).PlayTurnHead(LOOK_Forward, 1.0, 1.0);
                Sleep(0.5);
            }
            if (!ScriptedPawn(pawn).bSeekLocation)
            {
                ScriptedPawn(pawn).PlayTurnHead(LOOK_Right, 1.0, 1.0);
                Sleep(1.0);
            }
        }
        else
        {
            if (!ScriptedPawn(pawn).bSeekLocation)
            {
                ScriptedPawn(pawn).PlayTurnHead(LOOK_Right, 1.0, 1.0);
                Sleep(1.0);
            }
            if (!ScriptedPawn(pawn).bSeekLocation)
            {
                ScriptedPawn(pawn).PlayTurnHead(LOOK_Forward, 1.0, 1.0);
                Sleep(0.5);
            }
            if (!ScriptedPawn(pawn).bSeekLocation)
            {
                ScriptedPawn(pawn).PlayTurnHead(LOOK_Left, 1.0, 1.0);
                Sleep(1.0);
            }
        }
        ScriptedPawn(pawn).PlayTurnHead(LOOK_Forward, 1.0, 1.0);
        Sleep(0.5);
        StopBlendAnims();
    }
    else
    {
        if (!ScriptedPawn(pawn).bSeekLocation)
            Sleep(1.0);
    }

FindAnotherPlace:
    ScriptedPawn(pawn).SeekLevel--;
    if (PickDestination())
        Goto('GoToLocation');

DoneSeek:
    if (ScriptedPawn(pawn).bSeekPostCombat)
        ScriptedPawn(pawn).PlayTargetLostSound();
    else
        ScriptedPawn(pawn).PlaySearchGiveUpSound();
    ScriptedPawn(pawn).bSeekPostCombat = false;
    ScriptedPawn(pawn).SeekPawn = None;
    if (ScriptedPawn(pawn).Orders != 'Seeking')
        FollowOrders();
    else
        GotoState('Wandering');

ContinueSeek:
ContinueFromDoor:
    FinishAnim();
    Goto('FindAnotherPlace');

}


// ----------------------------------------------------------------------
// state AvoidingProjectiles
//
// Run away from a projectile.
// ----------------------------------------------------------------------
state AvoidingProjectiles
{
    ignores EnemyNotVisible;

    function SetFall()
    {
        StartFalling('RunningTo', 'ContinueRun');
    }

    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (pawn.Physics == PHYS_Falling)
            return true;
        Global.HitWall(HitNormal, Wall);
        CheckOpenDoor(HitNormal, Wall);
        return !ScriptedPawn(pawn).bCrouchToPassObstacles;
    }

    function AnimEnd(int channel)
    {
        pawn.PlayWaiting();
    }

    function PickDestination(bool bGotoWatch)
    {
        local ScriptedPawn.NearbyProjectileList projList;
        local bool                 bMove;
        local vector               projVector;
        local rotator              projRot;

        ScriptedPawn(pawn).destLoc   = vect(0,0,0);
        ScriptedPawn(pawn).destPoint = None;
        bMove = false;

        if (ScriptedPawn(pawn).GetProjectileList(projList, pawn.Location) > 0)
        {
            if (ScriptedPawn(pawn).IsLocationDangerous(projList, Location))
            {
                projVector = ScriptedPawn(pawn).ComputeAwayVector(projList);
                projRot    = Rotator(projVector);
                if (AIDirectionReachable(pawn.Location, projRot.Yaw, projRot.Pitch, pawn.CollisionRadius+24, VSize(projVector), ScriptedPawn(pawn).destLoc))
                {
                    ScriptedPawn(pawn).useLoc = pawn.Location + vect(0,0,1) * pawn.BaseEyeHeight;  // hack
                    bMove = true;
                }
            }
        }

        if (bMove)
            GotoState('AvoidingProjectiles', 'RunAway');
        else if (bGotoWatch)
            GotoState('AvoidingProjectiles', 'Watch');
    }

    function BeginState()
    {
        ScriptedPawn(pawn).StandUp();
        Disable('AnimEnd');
        pawn.bCanJump = false;
        ScriptedPawn(pawn).SetReactions(true, true, true, true, false, true, true, true, true, true, true, true);
        ScriptedPawn(pawn).bStasis = false;
        ScriptedPawn(pawn).useLoc = pawn.Location + vect(0,0,1) * pawn.BaseEyeHeight + Vector(pawn.Rotation);
        ScriptedPawn(pawn).bCanConverse = False;
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
    }

    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {

        ScriptedPawn(pawn).EnableCheckDestLoc(false);
        if (pawn.JumpZ > 0)
            pawn.bCanJump = true;
        ScriptedPawn(pawn).ResetReactions();
        ScriptedPawn(pawn).bStasis = true;
        ScriptedPawn(pawn).bCanConverse = True;
      }
    }

Begin:
    pawn.Acceleration = vect(0,0,0);
    PickDestination(true);

RunAway:
//  ScriptedPawn(pawn).PlayTurnHead(LOOK_Forward, 1.0, 0.0001);
    if (ScriptedPawn(pawn).ShouldPlayWalk(ScriptedPawn(pawn).destLoc))
        ScriptedPawn(pawn).PlayRunning();
    MoveTo(ScriptedPawn(pawn).destLoc, ,false);
    PickDestination(true);

Watch:
    pawn.Acceleration = vect(0,0,0);
    pawn.PlayWaiting();
//  LookAtVector(useLoc, true, false, true);
    TurnTo(Vector(pawn.DesiredRotation)*1000+pawn.Location);
    FinishRotation();
    ScriptedPawn(pawn).sleepTime = 3.0;
    while (ScriptedPawn(pawn).sleepTime > 0)
    {
        ScriptedPawn(pawn).sleepTime -= 0.5;
        Sleep(0.5);
        PickDestination(false);
    }

Done:
    if (ScriptedPawn(pawn).Orders != 'AvoidingProjectiles')
        FollowOrders();
    else
        GotoState('Wandering');

ContinueRun:
ContinueFromDoor:
    PickDestination(false);
    Goto('Done');

}


// ----------------------------------------------------------------------
// state Attacking
//
// Kill!  Kill!  Kill!  Kill!
// ----------------------------------------------------------------------
State Attacking
{
    function ReactToInjury(Pawn instigatedBy, class<damageType> damageType, ScriptedPawn.EHitLocation hitPos)
    {
        local Pawn oldEnemy;
        local bool bHateThisInjury;
        local bool bFearThisInjury;

        if ((pawn.health > 0) && (scriptedPawn(pawn).bLookingForInjury || scriptedPawn(pawn).bLookingForIndirectInjury))
        {
            oldEnemy = Enemy;

            bHateThisInjury = ShouldReactToInjuryType(damageType, scriptedPawn(pawn).bHateInjury, scriptedPawn(pawn).bHateIndirectInjury);
            bFearThisInjury = ShouldReactToInjuryType(damageType, scriptedPawn(pawn).bFearInjury, scriptedPawn(pawn).bFearIndirectInjury);

            if (bHateThisInjury)
                scriptedPawn(pawn).IncreaseAgitation(instigatedBy, 1.0);
            if (bFearThisInjury)
                scriptedPawn(pawn).IncreaseFear(instigatedBy, 2.0);

            if (scriptedPawn(pawn).ReadyForNewEnemy())
                SetEnemy(instigatedBy);

            if (ShouldFlee())
            {
                scriptedPawn(pawn).SetDistressTimer();
                scriptedPawn(pawn).PlayCriticalDamageSound();
                if (scriptedPawn(pawn).RaiseAlarm == RAISEALARM_BeforeFleeing)
                    SetNextState('Alerting');
                else
                    SetNextState('Fleeing');
            }
            else
            {
                scriptedPawn(pawn).SetDistressTimer();
                if (oldEnemy != Enemy)
                    scriptedPawn(pawn).PlayNewTargetSound();
                SetNextState('Attacking', 'ContinueAttack');
            }
            GotoDisabledState(damageType, hitPos);
        }
    }

    function SetFall()
    {
        StartFalling('Attacking', 'ContinueAttack');
    }

    event bool NotifyBump(actor bumper)
    {
       //CyberP: (otherwise known as |Totalitarian|) stop attempting to move to location if bump enemy
       if (Enemy != None && bumper == Enemy && Pawn.Weapon != None)
       {
          if (Pawn.GetAnimSequence() != 'Strafe2H' && Pawn.GetAnimSequence() != 'Strafe' && Pawn.GetAnimSequence() != 'Attack')
              if (VSize(pawn.Velocity) > 0)
              {
                   GoToState('Attacking','Fire');
              }
       }
      Global.Bump(bumper);
      return !ScriptedPawn(pawn).bCrouchToPassObstacles;
    }


    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (pawn.Physics == PHYS_Falling)
            return true;

        Global.NotifyHitWall(HitNormal, Wall);
        CheckOpenDoor(HitNormal, Wall);
        return !ScriptedPawn(pawn).bCrouchToPassObstacles;
    }

    function Reloading(DeusExWeapon reloadWeapon, float reloadTime)
    {
        Global.Reloading(reloadWeapon, reloadTime);
        if (scriptedPawn(pawn).bReadyToReload)
            if (IsWeaponReloading())
                if (!IsHandToHand())
                    scriptedPawn(pawn).TweenToShoot(0);
    }

    function ScriptedPawn.EDestinationType PickDestination()
    {
        local vector               tempVect;
        local rotator              enemyDir;
        local ScriptedPawn.EDestinationType     destType;
        local ScriptedPawn.NearbyProjectileList projList;

        scriptedPawn(pawn).destPoint = None;
        scriptedPawn(pawn).destLoc   = vect(0, 0, 0);
        destType  = DEST_Failure;

        if (enemy == None)
            return (destType);

        if (scriptedPawn(pawn).bCrouching && (scriptedPawn(pawn).CrouchTimer > 0))
            destType = DEST_SameLocation;

        if (destType == DEST_Failure)
        {
            if (ScriptedPawn(pawn).AICanShoot(DeusExPawn(enemy), true, false, 0.025) || ActorReachable(enemy))
            {
                destType = ScriptedPawn(pawn).ComputeBestFiringPosition(tempVect);
                if (destType == DEST_NewLocation)
                    scriptedPawn(pawn).destLoc = tempVect;
            }
        }

        if (destType == DEST_Failure)
        {
            MoveTarget = FindPathToward(enemy, false);
            if (MoveTarget != None)
            {
                if (!scriptedPawn(pawn).bDefendHome || IsNearHome(MoveTarget.Location))
                {
                    if (scriptedPawn(pawn).bAvoidHarm)
                        GetProjectileList(projList, MoveTarget.Location);
                    if (!scriptedPawn(pawn).bAvoidHarm || 
                        !IsLocationDangerous(projList, MoveTarget.Location))
                    {
                        scriptedPawn(pawn).destPoint = MoveTarget;
                        destType  = DEST_NewLocation;
                    }
                }
            }
        }

        // Default behavior, so they don't just stand there...
        if (destType == DEST_Failure)
        {
            enemyDir = Rotator(Enemy.Location - pawn.Location);
            if (AIPickRandomDestination(60, 150,
                                        enemyDir.Yaw, 0.5, enemyDir.Pitch, 0.5, 
                                        2, FRand()*0.4+0.35, tempVect))
            {
                if (!scriptedPawn(pawn).bDefendHome || IsNearHome(tempVect))
                {
                    destType = DEST_NewLocation;
                    scriptedPawn(pawn).destLoc  = tempVect;
                }
            }
        }

        return (destType);
    }

    function bool FireIfClearShot()
    {
        local DeusExWeapon dxWeapon;

        dxWeapon = DeusExWeapon(pawn.Weapon);
        if (dxWeapon != None)
        {
            if ((dxWeapon.AIFireDelay > 0) && (scriptedPawn(pawn).FireTimer > 0))
                return false;
            else if (ScriptedPawn(pawn).AICanShoot(DeusExPawn(enemy), true, true, 0.025))
            {
                pawn.Weapon.Fire(0);
                scriptedPawn(pawn).FireTimer = dxWeapon.AIFireDelay;
                return true;
            }
            else
                return false;
        }
        else
            return false;
    }

    function CheckAttack(bool bPlaySound)
    {
        local bool bCriticalDamage;
        local bool bOutOfAmmo;
        local Pawn oldEnemy;
        local bool bAllianceSwitch;

        oldEnemy = enemy;

        bAllianceSwitch = false;
        if (!ScriptedPawn(pawn).IsValidEnemy(DeusExPawn(enemy)))
        {
            if (ScriptedPawn(pawn).IsValidEnemy(DeusExPawn(enemy), false))
                bAllianceSwitch = true;
            SetEnemy(None, 0, true);
        }

        if (enemy == None)
        {
            if (scriptedPawn(pawn).Orders == 'Attacking')
            {
                scriptedPawn(pawn).FindOrderActor();
                SetEnemy(Pawn(scriptedPawn(pawn).OrderActor), 0, true);
            }
        }
        if (scriptedPawn(pawn).ReadyForNewEnemy())
            scriptedPawn(pawn).FindBestEnemy(false);
        if (enemy == None)
        {
            Enemy = oldEnemy;  // hack
            if (bPlaySound)
            {
                if (bAllianceSwitch)
                    scriptedPawn(pawn).PlayAllianceFriendlySound();
                else
                    scriptedPawn(pawn).PlayAreaSecureSound();
            }
            Enemy = None;
            if (scriptedPawn(pawn).Orders != 'Attacking')
                FollowOrders();
            else
                GotoState('Wandering');
            return;
        }

        if (scriptedPawn(pawn).bCrouching && (scriptedPawn(pawn).CrouchTimer <= 0) && !ShouldCrouch())
        {
            EndCrouch();
            scriptedPawn(pawn).TweenToShoot(0.15);
        }
        bCriticalDamage = false;
        bOutOfAmmo      = false;
        if (ShouldFlee())
            bCriticalDamage = True;
        else if (pawn.Weapon == None)
            bOutOfAmmo = True;
        else if (DeusExWeapon(pawn.Weapon).ReloadCount > 0)
        {
            if (DeusExWeapon(pawn.Weapon).AmmoType == None)
                bOutOfAmmo = True;
            else if (DeusExWeapon(pawn.Weapon).AmmoType.AmmoAmount < 1)
                bOutOfAmmo = True;
        }
        if (bCriticalDamage || bOutOfAmmo)
        {
            if (bPlaySound)
            {
                if (bCriticalDamage)
                    scriptedPawn(pawn).PlayCriticalDamageSound();
                else if (bOutOfAmmo)
                    scriptedPawn(pawn).PlayOutOfAmmoSound();
            }
            if (scriptedPawn(pawn).RaiseAlarm == RAISEALARM_BeforeFleeing)
                GotoState('Alerting');
            else
                GotoState('Fleeing');
        }
        else if (bPlaySound && (oldEnemy != Enemy))
            scriptedPawn(pawn).PlayNewTargetSound();
    }

    event Tick(float deltaSeconds)
    {
        local float  yaw;
        local vector lastLocation;
        local Pawn   lastEnemy;

        Global.Tick(deltaSeconds);

        if (scriptedPawn(pawn).CrouchTimer > 0)
        {
            scriptedPawn(pawn).CrouchTimer -= deltaSeconds;
            if (scriptedPawn(pawn).CrouchTimer < 0)
                scriptedPawn(pawn).CrouchTimer = 0;
        }
        scriptedPawn(pawn).EnemyTimer += deltaSeconds;
        scriptedPawn(pawn).UpdateActorVisibility(Enemy, deltaSeconds, 1.0, false);
        if ((Enemy != None) && HasEnemyTimedOut())
        {
            lastLocation = Enemy.Location;
            lastEnemy    = Enemy;
            scriptedPawn(pawn).FindBestEnemy(true);
            if (Enemy == None)
            {
                SetSeekLocation(DeusExPawn(lastEnemy), lastLocation, SEEKTYPE_Guess, true);
                GotoState('Seeking');
            }
        }
        else if (scriptedPawn(pawn).bCanFire && (Enemy != None))
        {
            pawn.SetViewRotation(Rotator(Enemy.Location - pawn.Location));
            if (scriptedPawn(pawn).bFacingTarget)
                FireIfClearShot();
            else if (!scriptedPawn(pawn).bMustFaceTarget)
            {
                yaw = (GetViewRotation().Yaw - pawn.Rotation.Yaw) & 0xFFFF;
                if (yaw >= 32768)
                    yaw -= 65536;
                yaw = Abs(yaw)*360/32768;  // 0-180 x 2
                if (yaw <= scriptedPawn(pawn).FireAngle)
                    FireIfClearShot();
            }
        }
        //UpdateReactionLevel(true, deltaSeconds);
    }

    function bool IsHandToHand()
    {
        if (pawn.Weapon != None)
        {
            if (DeusExWeapon(pawn.Weapon) != None)
            {
                if (DeusExWeapon(pawn.Weapon).bHandToHand)
                    return true;
                else
                    return false;
            }
            else
                return false;
        }
        else
            return false;
    }

    function bool ReadyForWeapon()
    {
        local bool bReady;

        bReady = false;
        if (DeusExWeapon(pawn.weapon) != None)
        {
            if (DeusExWeapon(pawn.weapon).bReadyToFire)
                if (!IsWeaponReloading())
                    bReady = true;
        }
        if (!bReady)
            if (enemy == None)
                bReady = true;
        if (!bReady)
            if (!ScriptedPawn(pawn).AICanShoot(DeusExPawn(enemy), true, false, 0.025))
                bReady = true;

        return (bReady);
    }

    function bool ShouldCrouch()
    {
        if (scriptedPawn(pawn).bCanCrouch && !pawn.PhysicsVolume.bWaterVolume && !IsHandToHand() &&
            ((enemy != None) && (VSize(enemy.Location - pawn.Location) > 300)) &&
            ((DeusExWeapon(pawn.Weapon) == None) || DeusExWeapon(pawn.Weapon).bUseWhileCrouched))
            return true;
        else
            return false;
    }

    function StartCrouch()
    {
        if (!scriptedPawn(pawn).bCrouching)
        {
            scriptedPawn(pawn).bCrouching = true;
            scriptedPawn(pawn).SetBasedPawnSize(pawn.CollisionRadius, scriptedPawn(pawn).GetCrouchHeight());
            scriptedPawn(pawn).CrouchTimer = 1.0+FRand()*0.5;
        }
    }

    function EndCrouch()
    {
        if (scriptedPawn(pawn).bCrouching)
        {
            scriptedPawn(pawn).bCrouching = false;
            scriptedPawn(pawn).ResetBasedPawnSize();
        }
    }

    function BeginState()
    {
        scriptedPawn(pawn).StandUp();

        // hack
        if (scriptedPawn(pawn).MaxRange < scriptedPawn(pawn).MinRange+10)
            scriptedPawn(pawn).MaxRange = scriptedPawn(pawn).MinRange+10;
        scriptedPawn(pawn).bCanFire      = false;
        scriptedPawn(pawn).bFacingTarget = false;

        scriptedPawn(pawn).SwitchToBestWeapon();

        //EnemyLastSeen = 0;
        scriptedPawn(pawn).BlockReactions();
        scriptedPawn(pawn).bCanConverse = False;
        scriptedPawn(pawn).bAttacking = True;
        scriptedPawn(pawn).bStasis = false;
        scriptedPawn(pawn).SetDistress(true);

        scriptedPawn(pawn).CrouchTimer = 0;
        scriptedPawn(pawn).EnableCheckDestLoc(false);
    }

    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        scriptedPawn(pawn).EnableCheckDestLoc(false);
        scriptedPawn(pawn).bCanFire      = false;
        scriptedPawn(pawn).bFacingTarget = false;

        scriptedPawn(pawn).ResetReactions();
        scriptedPawn(pawn).bCanConverse = True;
        scriptedPawn(pawn).bAttacking = False;
        scriptedPawn(pawn).bStasis = True;
        scriptedPawn(pawn).bReadyToReload = false;

        EndCrouch();
      }
    }

    // DXR: Застряла(а)? Тогда перезапустить состояние с другой позиции. Сейчас уже должно быть исправлено (теоретически).
    event RecoverFromBadStateCode()                                                                         
    {
        log(self$"."$pawn$" State Attacking: something gone WRONG, fallback to Surprise:",'DXRAIController');
        bBadStateCode = false;
        GotoState('Attacking', 'Surprise');
    }


Begin:
    if (Enemy == None)
        GotoState('Seeking');
    //EnemyLastSeen = 0;
    CheckAttack(false);

Surprise:
    if ((1.0-scriptedPawn(pawn).ReactionLevel) * scriptedPawn(pawn).SurprisePeriod < 0.25)
        Goto('BeginAttack');
    scriptedPawn(pawn).Acceleration = vect(0,0,0);
    scriptedPawn(pawn).PlaySurpriseSound();
    pawn.PlayWaiting();
    while (scriptedPawn(pawn).ReactionLevel < 1.0)
    {
        TurnToward(Enemy);
        if (scriptedPawn(pawn).bFastTurnWhenAttacking)
            Sleep(0);
        else
            FinishRotation();

    }

BeginAttack:
    scriptedPawn(pawn).EnemyReadiness = 1.0;
    scriptedPawn(pawn).ReactionLevel  = 1.0;
    if (scriptedPawn(pawn).PlayerAgitationTimer > 0)
        scriptedPawn(pawn).PlayAllianceHostileSound();
    else
        scriptedPawn(pawn).PlayTargetAcquiredSound();
    if (scriptedPawn(pawn).PlayBeginAttack())
    {
        pawn.Acceleration = vect(0,0,0);
        TurnToward(enemy);
        if (scriptedPawn(pawn).bFastTurnWhenAttacking)
            Sleep(0);
        else
            FinishRotation();

        FinishAnim();
    }

RunToRange:
    scriptedPawn(pawn).bCanFire       = false;
    scriptedPawn(pawn).bFacingTarget  = false;
    scriptedPawn(pawn).bReadyToReload = false;
    EndCrouch();
    if (pawn.Physics == PHYS_Falling)
        scriptedPawn(pawn).TweenToRunning(0.05);
    WaitForLanding();
    if (!IsWeaponReloading() || scriptedPawn(pawn).bCrouching)
    {
        if (scriptedPawn(pawn).ShouldPlayTurn(Enemy.Location))
            scriptedPawn(pawn).PlayTurning();

        TurnToward(enemy);
        if (scriptedPawn(pawn).bFastTurnWhenAttacking)
            Sleep(0);
        else
            FinishRotation();
    }
    else
        Sleep(0);
    scriptedPawn(pawn).bCanFire = true;
    while (PickDestination() == DEST_NewLocation)
    {
        if (scriptedPawn(pawn).bCanStrafe && ShouldStrafe())
        {
            scriptedPawn(pawn).PlayRunningAndFiring();
            if (scriptedPawn(pawn).destPoint != None)
                MoveTo(scriptedPawn(pawn).destPoint.Location, Enemy, false); // StrafeFacing(destPoint.Location, enemy);
            else
                MoveTo(scriptedPawn(pawn).destLoc, Enemy, false); //StrafeFacing(scriptedPawn(pawn).destLoc, enemy); 
            scriptedPawn(pawn).bFacingTarget = true;
        }
        else
        {
            scriptedPawn(pawn).bFacingTarget = false;
            scriptedPawn(pawn).PlayRunning();
            if (scriptedPawn(pawn).destPoint != None)
                MoveToward(scriptedPawn(pawn).destPoint,,0,true,false);  //MoveToward(scriptedPawn(pawn).destPoint, MaxDesiredSpeed);
            else
                MoveTo(scriptedPawn(pawn).destLoc,,false);  //MoveTo(scriptedPawn(pawn).destLoc, MaxDesiredSpeed);
        }
        CheckAttack(true);
    }

Fire:
    scriptedPawn(pawn).bCanFire      = false;
    scriptedPawn(pawn).bFacingTarget = false;
    pawn.Acceleration = vect(0, 0, 0);

    scriptedPawn(pawn).SwitchToBestWeapon();
    if (FRand() > 0.5)
        scriptedPawn(pawn).bUseSecondaryAttack = true;
    else
        scriptedPawn(pawn).bUseSecondaryAttack = false;
    if (IsHandToHand())
        scriptedPawn(pawn).TweenToAttack(0.15);
    else if (ShouldCrouch() && (FRand() < scriptedPawn(pawn).CrouchRate))
    {
        scriptedPawn(pawn).TweenToCrouchShoot(0.15);
        FinishAnim();
        StartCrouch();
    }
    else
        scriptedPawn(pawn).TweenToShoot(0.15);
    if (!IsWeaponReloading() || scriptedPawn(pawn).bCrouching)
    {
        TurnToward(enemy);
        if (scriptedPawn(pawn).bFastTurnWhenAttacking)
            Sleep(0);
        else
            FinishRotation();
    }
    FinishAnim();
    scriptedPawn(pawn).bReadyToReload = true;

ContinueFire:
    while (!ReadyForWeapon())
    {
        if (PickDestination() != DEST_SameLocation)
            Goto('RunToRange');
        CheckAttack(true);
        if (!IsWeaponReloading() || scriptedPawn(pawn).bCrouching)
        {
            TurnToward(enemy);
            if (scriptedPawn(pawn).bFastTurnWhenAttacking)
                Sleep(0);
            else
                FinishRotation();
        }
        else
            Sleep(0);
    }
    CheckAttack(true);
    if (!FireIfClearShot())
        Goto('ContinueAttack');
    scriptedPawn(pawn).bReadyToReload = false;
    if (scriptedPawn(pawn).bCrouching)
        scriptedPawn(pawn).PlayCrouchShoot();
    else if (IsHandToHand())
        scriptedPawn(pawn).PlayAttack();
    else
        scriptedPawn(pawn).PlayShoot();
    FinishAnim();
    if (FRand() > 0.5)
        scriptedPawn(pawn).bUseSecondaryAttack = true;
    else
        scriptedPawn(pawn).bUseSecondaryAttack = false;
        scriptedPawn(pawn).bReadyToReload = true;
    if (!IsHandToHand())
    {
        if (scriptedPawn(pawn).bCrouching)
            scriptedPawn(pawn).TweenToCrouchShoot(0);
        else
            scriptedPawn(pawn).TweenToShoot(0);
    }
    CheckAttack(true);
    if (PickDestination() != DEST_NewLocation)
    {
        if (!IsWeaponReloading() || scriptedPawn(pawn).bCrouching)
        {
            TurnToward(enemy);
            if (scriptedPawn(pawn).bFastTurnWhenAttacking)
                Sleep(0);
            else
                FinishRotation();
        }
        else
            Sleep(0);
        Goto('ContinueFire');
    }
    Goto('RunToRange');

ContinueAttack:
ContinueFromDoor:
    CheckAttack(true);
    if (PickDestination() != DEST_NewLocation)
        Goto('Fire');
    else
        Goto('RunToRange');
}


// ----------------------------------------------------------------------
// state Fleeing
//
// Run like a bat outta hell away from an actor.
// ----------------------------------------------------------------------
State Fleeing
{
    function ReactToInjury(Pawn instigatedBy, class<DamageType> damageType, ScriptedPawn.EHitLocation hitPos)
    {
        local Name currentState;
        local Pawn oldEnemy;
        local name newLabel;
        local bool bHateThisInjury;
        local bool bFearThisInjury;
        local bool bAttack;

        if ((pawn.health > 0) && (ScriptedPawn(pawn).bLookingForInjury || ScriptedPawn(pawn).bLookingForIndirectInjury))
        {
            currentState = GetStateName();

            bHateThisInjury = ShouldReactToInjuryType(damageType, ScriptedPawn(pawn).bHateInjury, ScriptedPawn(pawn).bHateIndirectInjury);
            bFearThisInjury = ShouldReactToInjuryType(damageType, ScriptedPawn(pawn).bFearInjury, ScriptedPawn(pawn).bFearIndirectInjury);

            if (bHateThisInjury)
                ScriptedPawn(pawn).IncreaseAgitation(instigatedBy);
            if (bFearThisInjury)
                ScriptedPawn(pawn).IncreaseFear(instigatedBy, 2.0);

            oldEnemy = Enemy;

            bAttack = false;
            if (SetEnemy(instigatedBy))
            {
                if (!ShouldFlee())
                {
                    ScriptedPawn(pawn).SwitchToBestWeapon();
                    if (pawn.Weapon != None)
                        bAttack = true;
                }
            }
            else
                SetEnemy(instigatedBy, , true);

            if (bAttack)
            {
                ScriptedPawn(pawn).SetDistressTimer();
                SetNextState('HandlingEnemy');
            }
            else
            {
                ScriptedPawn(pawn).SetDistressTimer();
                if (oldEnemy != Enemy)
                    newLabel = 'Begin';
                else
                    newLabel = 'ContinueFlee';
                SetNextState('Fleeing', newLabel);
            }
            GotoDisabledState(damageType, hitPos);
        }
    }

    function SetFall()
    {
        StartFalling('Fleeing', 'ContinueFlee');
    }

    function FinishFleeing()
    {
        if (ScriptedPawn(pawn).bLeaveAfterFleeing)
            GotoState('Wandering');
        else
            FollowOrders();
    }

    function bool InSeat(out vector newLoc)  // hack
    {
        local Seat curSeat;
        local bool bSeat;

        bSeat = false;
        foreach RadiusActors(Class'Seat', curSeat, 200)
        {
            if (IsOverlapping(curSeat))
            {
                bSeat = true;
                newLoc = curSeat.Location + vector(curSeat.Rotation+Rot(0, -16384, 0)) * (pawn.CollisionRadius + curSeat.CollisionRadius+20);
                break;
            }
        }

        return (bSeat);
    }

    event Tick(float deltaSeconds)
    {
        ScriptedPawn(pawn).UpdateActorVisibility(Enemy, deltaSeconds, 1.0, false);
        if (ScriptedPawn(pawn).IsValidEnemy(DeusExPawn(Enemy)))
        {
            if (ScriptedPawn(pawn).EnemyLastSeen > ScriptedPawn(pawn).FearSustainTime)
                FinishFleeing();
        }
        else if (!ScriptedPawn(pawn).IsValidEnemy(DeusExPawn(Enemy), false))
            FinishFleeing();
        else if (!ScriptedPawn(pawn).IsFearful())
            FinishFleeing();
        Global.Tick(deltaSeconds);
    }

    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (pawn.Physics == PHYS_Falling)
            return true;
        Global.HitWall(HitNormal, Wall);
        CheckOpenDoor(HitNormal, Wall);
        return !ScriptedPawn(pawn).bCrouchToPassObstacles;
    }
    
    function AnimEnd(int channel)
    {
        pawn.PlayWaiting();
    }

    function PickDestination()
    {
        local HidePoint      hidePoint;
        local Actor          waypoint;
        local float          dist;
        local float          score;
        local Vector         vector1, vector2;
        local Rotator        rotator1;
        local float          tmpDist;

        local float          bestDist;
        local float          bestScore;

        local ScriptedPawn.FleeCandidates candidates[5];
        local int            candidateCount;
        local int            maxCandidates;
        local float          maxDist;
        local int            openSlot;
        local float          maxScore;
        local int            i;
        local bool           bReplace;

        local float          magnitude;
        local int            iterations;

        local ScriptedPawn.NearbyProjectileList projList;


        maxCandidates  = 3;  // must be <= size of candidates[] arrays
        maxDist        = HIDEPOINT_CHECK_RADIUS;

        // Initialize the list of candidates
        for (i=0; i<maxCandidates; i++)
        {
            candidates[i].score = -1;
            candidates[i].dist  = maxDist+1;
        }
        candidateCount = 0;

        MoveTarget = None;
        ScriptedPawn(pawn).destPoint  = None;

        if (ScriptedPawn(pawn).bAvoidHarm)
        {
            GetProjectileList(projList, pawn.Location);
            if (IsLocationDangerous(projList, pawn.Location))
            {
                vector1 = ScriptedPawn(pawn).ComputeAwayVector(projList);
                rotator1 = Rotator(vector1);
                if (AIDirectionReachable(pawn.Location, rotator1.Yaw, rotator1.Pitch, pawn.CollisionRadius+24, VSize(vector1), ScriptedPawn(pawn).destLoc))
                    return;   // eck -- hack!!!
            }
        }

        if (Enemy != None)
        {
            foreach pawn.RadiusActors(Class'HidePoint', hidePoint, maxDist)
            {
                // Can the boogeyman see our hiding spot?
                if (!enemy.LineOfSightTo(hidePoint))
                {
                    // More importantly, can we REACH our hiding spot?
                    waypoint = GetNextWaypoint(hidePoint);
                    if (waypoint != None)
                    {
                        // How far is it to the hiding place?
                        dist = VSize(hidePoint.Location - Location);

                        // Determine vectors to the waypoint and our enemy
                        vector1 = enemy.Location - pawn.Location;
                        vector2 = waypoint.Location - pawn.Location;

                        // Strip out magnitudes from the vectors
                        tmpDist = VSize(vector1);
                        if (tmpDist > 0)
                            vector1 /= tmpDist;
                        tmpDist = VSize(vector2);
                        if (tmpDist > 0)
                            vector2 /= tmpDist;

                        // Add them
                        vector1 += vector2;

                        // Compute a score (a function of angle)
                        score = VSize(vector1);
                        score = 4-(score * score);

                        // Find an empty slot for this candidate
                        openSlot  = -1;
                        bestScore = score;
                        bestDist  = dist;

                        for (i=0; i<maxCandidates; i++)
                        {
                            // Can we replace the candidate in this slot?
                            if (bestScore > candidates[i].score)
                                bReplace = TRUE;
                            else if ((bestScore == candidates[i].score) &&
                                     (bestDist < candidates[i].dist))
                                bReplace = TRUE;
                            else
                                bReplace = FALSE;
                            if (bReplace)
                            {
                                bestScore = candidates[i].score;
                                bestDist  = candidates[i].dist;
                                openSlot = i;
                            }
                        }

                        // We found an open slot -- put our candidate here
                        if (openSlot >= 0)
                        {
                            candidates[openSlot].point    = hidePoint;
                            candidates[openSlot].waypoint = waypoint;
                            candidates[openSlot].location = waypoint.Location;
                            candidates[openSlot].score    = score;
                            candidates[openSlot].dist     = dist;
                            if (candidateCount < maxCandidates)
                                candidateCount++;
                        }
                    }
                }
            }

            // Any candidates?
            if (candidateCount > 0)
            {
                // Find a random candidate
                // (candidates moving AWAY from the enemy have a higher
                // probability of being chosen than candidates moving
                // TOWARDS the enemy)

                maxScore = 0;
                for (i=0; i<candidateCount; i++)
                    maxScore += candidates[i].score;
                score = FRand() * maxScore;
                for (i=0; i<candidateCount; i++)
                {
                    score -= candidates[i].score;
                    if (score <= 0)
                        break;
                }
                ScriptedPawn(pawn).destPoint  = candidates[i].point;
                MoveTarget = candidates[i].waypoint;
                ScriptedPawn(pawn).destLoc    = candidates[i].location;
            }
            else
            {
                iterations = 4;
                magnitude = 400*(FRand()*0.4+0.8);  // 400, +/-20%
                rotator1 = Rotator(pawn.Location-Enemy.Location);
                if (!AIPickRandomDestination(100, magnitude, rotator1.Yaw, 0.6, rotator1.Pitch, 0.6, iterations,
                                             FRand()*0.4+0.35, ScriptedPawn(pawn).destLoc))
                    ScriptedPawn(pawn).destLoc = pawn.Location+(VRand()*1200);  // we give up
            }
        }
        else
            ScriptedPawn(pawn).destLoc = pawn.Location+(VRand()*1200);  // we give up
    }

    function BeginState()
    {
        ScriptedPawn(pawn).StandUp();
        Disable('AnimEnd');
        //Disable('Bump');
        ScriptedPawn(pawn).BlockReactions();
        if (!ScriptedPawn(pawn).bCower)
            ScriptedPawn(pawn).bCanConverse = False;
        ScriptedPawn(pawn).bStasis = False;
        ScriptedPawn(pawn).SetupWeapon(false, true);
        ScriptedPawn(pawn).SetDistress(true);
        ScriptedPawn(pawn).EnemyReadiness = 1.0;
        //ReactionLevel  = 1.0;
        ScriptedPawn(pawn).SeekPawn = None;
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
    }

    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
        Enable('AnimEnd');
        //Enable('Bump');
        ScriptedPawn(pawn).ResetReactions();
        if (!ScriptedPawn(pawn).bCower)
            ScriptedPawn(pawn).bCanConverse = True;

        ScriptedPawn(pawn).bStasis = True;
      }
    }

Begin:
    //EnemyLastSeen = 0;
    ScriptedPawn(pawn).destPoint = None;

Surprise:
    if ((1.0-ScriptedPawn(pawn).ReactionLevel) * ScriptedPawn(pawn).SurprisePeriod < 0.25)
        Goto('Flee');

    pawn.Acceleration = vect(0,0,0);
    ScriptedPawn(pawn).PlaySurpriseSound();
    pawn.PlayWaiting();
    Sleep(FRand()*0.5);
    if (Enemy != None)
    {
        TurnToward(Enemy);
        FinishRotation();
    }
    if (ScriptedPawn(pawn).bCower)
        Goto('Flee');
    Sleep(FRand()*0.5+0.5);

Flee:
    if (ScriptedPawn(pawn).bLeaveAfterFleeing)
    {
        ScriptedPawn(pawn).bTransient = true;
        ScriptedPawn(pawn).bDisappear = true;
    }
    if (ScriptedPawn(pawn).bCower)
        Goto('Cower');
    WaitForLanding();
    PickDestination();

Moving:
    Sleep(0.0);

    if (enemy == None)
    {
        pawn.Acceleration = vect(0,0,0);
        pawn.PlayWaiting();
        Sleep(2.0);
        FinishFleeing();
    }

    // Move from pathnode to pathnode until we get where we're going
    if (ScriptedPawn(pawn).destPoint != None)
    {
        ScriptedPawn(pawn).EnableCheckDestLoc(true);
        while (MoveTarget != None)
        {
            if (ScriptedPawn(pawn).ShouldPlayWalk(MoveTarget.Location))
                ScriptedPawn(pawn).PlayRunning();

            MoveToward(MoveTarget, , , , false);

            ScriptedPawn(pawn).CheckDestLoc(MoveTarget.Location, true);
            if (enemy.bDetectable && DeusExPawn(enemy).AICanSee(ScriptedPawn(pawn).destPoint, 1.0, false, false, false, true) > 0)
            {
                PickDestination();
                EnableCheckDestLoc(false);
                Goto('Moving');
            }
            if (MoveTarget == ScriptedPawn(pawn).destPoint)
                break;
            MoveTarget = FindPathToward(ScriptedPawn(pawn).destPoint);
        }
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
    }
    else if (PointReachable(ScriptedPawn(pawn).destLoc))
    {
        if (ScriptedPawn(pawn).ShouldPlayWalk(ScriptedPawn(pawn).destLoc))
            ScriptedPawn(pawn).PlayRunning();

        MoveTo(ScriptedPawn(pawn).destLoc, ,false);

        if (enemy.bDetectable && DeusExPawn(enemy).AICanSee(Pawn, 1.0, false, false, true, true) > 0)
        {
            PickDestination();
            Goto('Moving');
        }
    }
    else
    {
        PickDestination();
        Goto('Moving');
    }

Pausing:
    pawn.Acceleration = vect(0,0,0);

    if (enemy != None)
    {
        if (HidePoint(ScriptedPawn(pawn).destPoint) != None)
        {
            if (ScriptedPawn(pawn).ShouldPlayTurn(pawn.Location + HidePoint(ScriptedPawn(pawn).destPoint).faceDirection))
                ScriptedPawn(pawn).PlayTurning();

            TurnTo(pawn.Location + HidePoint(ScriptedPawn(pawn).destPoint).faceDirection);
            FinishRotation();
        }
        Enable('AnimEnd');
        ScriptedPawn(pawn).TweenToWaiting(0.2);
        while (AICanSee(enemy, 1.0, false, false, true, true) <= 0)
            Sleep(0.25);
        Disable('AnimEnd');
        FinishAnim();
    }

    Goto('Flee');

Cower:
    if (!InSeat(ScriptedPawn(pawn).useLoc))
        Goto('CowerContinue');

    ScriptedPawn(pawn).PlayRunning();
    MoveTo(ScriptedPawn(pawn).useLoc, ,false);

CowerContinue:
    pawn.Acceleration = vect(0,0,0);
    ScriptedPawn(pawn).PlayCowerBegin();
    FinishAnim();
    ScriptedPawn(pawn).PlayCowering();

    // behavior 3 - cower and occasionally make short runs
    while (true)
    {
        Sleep(FRand()*3+6);

        ScriptedPawn(pawn).PlayCowerEnd();
        FinishAnim();
        if (AIPickRandomDestination(60, 150, 0, 0, 0, 0,
                                    2, FRand()*0.3+0.6, ScriptedPawn(pawn).useLoc))
        {
            if (ScriptedPawn(pawn).ShouldPlayWalk(ScriptedPawn(pawn).useLoc))
                ScriptedPawn(pawn).PlayRunning();
            MoveTo(ScriptedPawn(pawn).useLoc, ,false);
        }
        ScriptedPawn(pawn).PlayCowerBegin();
        FinishAnim();
        ScriptedPawn(pawn).PlayCowering();
    }

    /* behavior 2 - cower forever
    // don't stop cowering
    while (true)
        Sleep(1.0);
    */

    /* behavior 1 - cower only when enemy watching
    if (enemy != None)
    {
        while (AICanSee(enemy, 1.0, false, false, true, true) > 0)
            Sleep(0.25);
    }
    PlayCowerEnd();
    FinishAnim();
    Goto('Pausing');
    */

ContinueFlee:
ContinueFromDoor:
    FinishAnim();
    ScriptedPawn(pawn).PlayRunning();
    if (ScriptedPawn(pawn).bCower)
        Goto('Cower');
    else
        Goto('Moving');

}


// ----------------------------------------------------------------------
// state WaitingFor
//
// Wait for a pawn to become visible, then move to it
// ----------------------------------------------------------------------
state WaitingFor
{
    function SetFall()
    {
        StartFalling('WaitingFor', 'ContinueFollow');
    }

    function bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (pawn.Physics == PHYS_Falling)
            return true;

        Global.HitWall(HitNormal, Wall);
        CheckOpenDoor(HitNormal, Wall);
        return !ScriptedPawn(pawn).bCrouchToPassObstacles;
    }

    event bool NotifyBump(actor bumper)
    {
        // If we hit the guy we're going to, end the state
        if (bumper == ScriptedPawn(pawn).OrderActor)
        {
            GotoState('WaitingFor', 'Done');
            return true;
        }

        // Handle conversations, if need be
        //Global.Bump(bumper);
    }

    function NotifyTouch(actor toucher)
    {
        // If we hit the guy we're going to, end the state
        if (toucher == ScriptedPawn(pawn).OrderActor)
            GotoState('WaitingFor', 'Done');

        // Handle conversations, if need be
//      Global.Touch(toucher);
    }

    function BeginState()
    {
        ScriptedPawn(pawn).StandUp();
        ScriptedPawn(pawn).SetupWeapon(false);
        ScriptedPawn(pawn).SetDistress(false);
        ScriptedPawn(pawn).bStasis = true;
        ScriptedPawn(pawn).SeekPawn = None;
        ScriptedPawn(pawn).EnableCheckDestLoc(true);
    }
    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
        ScriptedPawn(pawn).bStasis = true;
      }
    }

Begin:
    ScriptedPawn(pawn).Acceleration = vect(0, 0, 0);
    if (ScriptedPawn(pawn).orderActor == None)
        GotoState('Idle');
    ScriptedPawn(pawn).PlayWaiting();

Wait:
    Sleep(1.0);
    if (AICanSee(ScriptedPawn(pawn).orderActor, 1.0, false, true, false, true) <= 0)
        Goto('Wait');
    pawn.bStasis = false;

Follow:
    if (IsOverlapping(ScriptedPawn(pawn).orderActor))
        Goto('Done');
    MoveTarget = GetNextWaypoint(ScriptedPawn(pawn).orderActor);
    if ((MoveTarget != None) && (!MoveTarget.PhysicsVolume.bWaterVolume) && (MoveTarget.Physics != PHYS_Falling))
    {
        if ((MoveTarget == ScriptedPawn(pawn).orderActor) && MoveTarget.IsA('Pawn'))
        {
            if (GetNextVector(ScriptedPawn(pawn).orderActor, ScriptedPawn(pawn).useLoc))
            {
                if (ScriptedPawn(pawn).ShouldPlayWalk(ScriptedPawn(pawn).useLoc))
                    ScriptedPawn(pawn).PlayRunning();
                MoveTo(ScriptedPawn(pawn).useLoc,, false);//, MaxDesiredSpeed);
                ScriptedPawn(pawn).CheckDestLoc(ScriptedPawn(pawn).useLoc);
            }
            else
                Goto('Pause');
        }
        else
        {
            if (ScriptedPawn(pawn).ShouldPlayWalk(MoveTarget.Location))
                ScriptedPawn(pawn).PlayRunning();
            MoveToward(MoveTarget,,0,false,false);//, MaxDesiredSpeed);
            ScriptedPawn(pawn).CheckDestLoc(MoveTarget.Location, true);
        }
        if (IsOverlapping(ScriptedPawn(pawn).orderActor))
            Goto('Done');
        else
            Goto('Follow');
    }

Pause:
    pawn.Acceleration = vect(0, 0, 0);
    TurnToward(ScriptedPawn(pawn).orderActor);
    FinishRotation();
    ScriptedPawn(pawn).PlayWaiting();
    Sleep(1.0);
    Goto('Follow');

Done:
    GotoState('Standing');

ContinueFollow:
ContinueFromDoor:
    ScriptedPawn(pawn).PlayRunning();
    Goto('Follow');
}


// ----------------------------------------------------------------------
// Just like Patrolling, but make the pawn transient.
// DXR: Called from C++.
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
// state Paralyzed
//
// Do nothing -- ignore all
// (this state lets ViewModel work correctly)
// ----------------------------------------------------------------------
state Paralyzed
{
    ignores bump, frob, reacttoinjury;
    function BeginState()
    {
        ScriptedPawn(pawn).StandUp();
        ScriptedPawn(pawn).BlockReactions(true);
        ScriptedPawn(pawn).bCanConverse = false;
        ScriptedPawn(pawn).SeekPawn = None;
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
    }
    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        ScriptedPawn(pawn).ResetReactions();
        ScriptedPawn(pawn).bCanConverse = true;
      }
    }

Begin:
    pawn.Acceleration = vect(0,0,0);
    ScriptedPawn(pawn).PlayAnimPivot('Still');
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
        StartFalling('Patrolling', 'ContinuePatrol');
    }

    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (pawn.Physics == PHYS_Falling)
        return true;

        Global.NotifyHitWall(HitNormal, Wall);
        CheckOpenDoor(HitNormal, Wall);

        return !ScriptedPawn(pawn).bCrouchToPassObstacles; // !! if true, pawn will not crouch !!
    }
    
    function AnimEnd(int Channel)
    {
//        if (pawn.Acceleration == vect(0, 0, 0))
//            pawn.PlayWaiting();

        // DXR: HKMilitary13, как ты меня достал !!
        if (MoveTimer < FALLBACK_IF_STUCK_VALUE) // DXR: Дополнительный путь отхода на случай "застревания".
            FallBackIfStuck();
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
        if (PatrolPoint(ScriptedPawn(pawn).destPoint) != None)
        {
            ScriptedPawn(pawn).destPoint = PatrolPoint(ScriptedPawn(pawn).destPoint).NextPatrolPoint;
//          log(pawn@self$" patrolPoint = "$destPoint);
        }
        else
        {
            ScriptedPawn(pawn).destPoint = PickStartPoint();
        }
        if (ScriptedPawn(pawn).destPoint == None)  // can't go anywhere...
        {
            log(pawn@self$" state Patrolling: No patrolPoint found, fallback to Standing, OrderTag ="@ScriptedPawn(pawn).OrderTag);
            GotoState('Standing');
        }
    }

    function BeginState()
    {
        ScriptedPawn(pawn).StandUp();
        SetEnemy(None, ScriptedPawn(pawn).EnemyLastSeen, true);
        Disable('AnimEnd');
        ScriptedPawn(pawn).SetupWeapon(false);
        ScriptedPawn(pawn).SetDistress(false);
        ScriptedPawn(pawn).bStasis = false;
        ScriptedPawn(pawn).SeekPawn = None;
        EnableCheckDestLoc(false);
    }

    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        EnableCheckDestLoc(false);
        Enable('AnimEnd');
        ScriptedPawn(pawn).bStasis = true;
      }
    }

Begin:
    ScriptedPawn(pawn).destPoint = None;

Patrol:
    //Disable('Bump');
    WaitForLanding();
    PickDestination();

Moving:
    // Move from pathnode to pathnode until we get where we're going
    if (ScriptedPawn(pawn).destPoint != None)
    {
        if (!IsPointInCylinder(pawn, ScriptedPawn(pawn).destPoint.Location, 16-pawn.CollisionRadius)) // self?
        {
            scriptedPawn(pawn).EnableCheckDestLoc(true);
            MoveTarget = FindPathToward(ScriptedPawn(pawn).destPoint, false); // 2 false

            while (MoveTarget != None)
            {
                if (scriptedPawn(pawn).ShouldPlayWalk(MoveTarget.Location))
                {
                    //pawn.SetWalking(true);
                    scriptedPawn(pawn).PlayWalking();
                }
                MoveToward(MoveTarget,MoveTarget,0,false, true); // MoveTarget, FocusToThisActor, offset, strafe?, walk?

                scriptedPawn(pawn).CheckDestLoc(MoveTarget.Location, true);

                if (MoveTarget == ScriptedPawn(pawn).destPoint)
                    break;

                MoveTarget = FindPathToward(ScriptedPawn(pawn).destPoint, true);
            }
            scriptedPawn(pawn).EnableCheckDestLoc(false);
        }
    }
    else
        Goto('Patrol');

Pausing:
    if (!scriptedPawn(pawn).bAlwaysPatrol)
        pawn.bStasis = true;

        pawn.Acceleration = vect(0, 0, 0);

    // Turn in the direction dictated by the PatrolPoint
    if (PatrolPoint(ScriptedPawn(pawn).destPoint) != None)
    {
        if ((PatrolPoint(ScriptedPawn(pawn).destPoint).pausetime > 0) || (PatrolPoint(ScriptedPawn(pawn).destPoint).NextPatrolPoint == None))
        {
            if (scriptedPawn(pawn).ShouldPlayTurn(pawn.Location + PatrolPoint(ScriptedPawn(pawn).destPoint).lookdir))
                scriptedPawn(pawn).PlayTurning();

            TurnTo(PatrolPoint(ScriptedPawn(pawn).destPoint).lookdir); //    FocalPoint = Pawn.Location + (1000 * vector(PatrolPoint(ScriptedPawn(pawn).destPoint).Rotation)); Note to self: Don't add pawn location twice :)
            FinishRotation();

            Enable('AnimEnd');
            scriptedPawn(pawn).TweenToWaiting(0.2);
            scriptedPawn(pawn).PlayScanningSound();
            //Enable('Bump');
            sleepTime = PatrolPoint(ScriptedPawn(pawn).destPoint).pausetime * ((-0.9*scriptedPawn(pawn).restlessness) + 1);
            Sleep(sleepTime);
            Disable('AnimEnd');
            //Disable('Bump');
            FinishAnim();
        }
    }
    Goto('Patrol');

ContinuePatrol:
ContinueFromDoor:
    FinishAnim();
    ScriptedPawn(pawn).PlayWalking();
    Goto('Moving');

}

state Sitting
{
    ignores EnemyNotVisible;

    function SetFall()
    {
        StartFalling('Sitting', 'ContinueSitting');
    }

    function AnimEnd(int channel)
    {
        pawn.PlayWaiting();
    }

    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (pawn.Physics == PHYS_Falling)
            return true;

        Global.HitWall(HitNormal, Wall);

        if (!scriptedPawn(pawn).bAcceptBump)
            scriptedPawn(pawn).NextDirection = TURNING_None;

//        Global.HitWall(HitNormal, Wall);
        CheckOpenDoor(HitNormal, Wall);
        return !ScriptedPawn(pawn).bCrouchToPassObstacles;
    }

    function bool HandleTurn(Actor Other)
    {
        if (Other == scriptedPawn(pawn).SeatActor)
            return true;
        else
            global.HandleTurn(Other);
    }

    event bool NotifyBump(actor bumper)
    {
        // If we hit our chair, move to the right place
        if ((bumper == scriptedPawn(pawn).SeatActor) && scriptedPawn(pawn).bAcceptBump)
        {
            scriptedPawn(pawn).bAcceptBump = false;
            GotoState('Sitting', 'CircleToFront');
        }
        else // Handle conversations, if need be
             Global.NotifyBump(bumper);

             return false;
    }

    event Tick(float deltaSeconds)
    {
        local vector endPos;
        local vector newPos;
        local float  delta;

        Global.Tick(deltaSeconds);

        if (scriptedPawn(pawn).bSitInterpolation && (scriptedPawn(pawn).SeatActor != None))
        {
            endPos = SitPosition(scriptedPawn(pawn).SeatActor, scriptedPawn(pawn).SeatSlot);
            if ((deltaSeconds < scriptedPawn(pawn).remainingSitTime) && (scriptedPawn(pawn).remainingSitTime > 0))
            {
                delta = deltaSeconds/scriptedPawn(pawn).remainingSitTime;
                newPos = (endPos-pawn.Location) * delta + pawn.Location;
                scriptedPawn(pawn).remainingSitTime -= deltaSeconds;
            }
            else
            {
                scriptedPawn(pawn).remainingSitTime = 0;
                scriptedPawn(pawn).bSitInterpolation = false;
                newPos = endPos;
                scriptedPawn(pawn).Acceleration = vect(0,0,0);
                scriptedPawn(pawn).Velocity = vect(0,0,0);
                scriptedPawn(pawn).SetBase(scriptedPawn(pawn).SeatActor);
                scriptedPawn(pawn).bSitting = true;
            }
            scriptedPawn(pawn).SetLocation(newPos);
            TurnTo(vector(scriptedPawn(pawn).SeatActor.Rotation + Rot(0, -16384, 0)));
        }
    }

    function Vector SitPosition(Seat seatActor, int slot)
    {
        local float newAssHeight;

        newAssHeight = scriptedPawn(pawn).GetDefaultCollisionHeight() + scriptedPawn(pawn).BaseAssHeight;
        newAssHeight = -(scriptedPawn(pawn).CollisionHeight - newAssHeight);

        return ((seatActor.sitPoint[slot]>>seatActor.Rotation)+seatActor.Location+(vect(0,0,-1)*newAssHeight));
    }

    function vector GetDestinationPosition(Seat seatActor, optional float extraDist)
    {
        local Rotator seatRot;
        local Vector  destPos;

        if (seatActor == None)
            return (pawn.Location);

        seatRot = seatActor.Rotation + Rot(0, -16384, 0);
        seatRot.Pitch = 0;
        destPos = seatActor.Location;
        destPos += vect(0,0,1) * (pawn.CollisionHeight - seatActor.CollisionHeight);
        destPos += Vector(seatRot) * (seatActor.CollisionRadius + pawn.CollisionRadius + extraDist);

        return (destPos);
    }

    function bool IsIntersectingSeat()
    {
        local bool bIntersect;

        bIntersect = false;
        if (scriptedPawn(pawn).SeatActor != None)
            bIntersect = IsOverlapping(scriptedPawn(pawn).SeatActor);

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
        if (!seatActor.PhysicsVolume.bWaterVolume)
        {
            for (i=0; i<seatActor.numSitPoints; i++)
            {
                if (seatActor.sittingActor[i] == None)
                {
                    dist = VSize(SitPosition(seatActor, i) - pawn.Location);
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

        if (scriptedPawn(pawn).bUseFirstSeatOnly && scriptedPawn(pawn).bSeatHackUsed)
        {
            bestSeat = scriptedPawn(pawn).SeatHack;  // use the seat hack
            bestSlot = -1;
            if (!scriptedPawn(pawn).IsSeatValid(bestSeat))
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
            bestSeat = Seat(scriptedPawn(pawn).OrderActor);  // try the ordered seat first
            if (bestSeat != None)
            {
                if (!IsSeatValid(scriptedPawn(pawn).OrderActor))
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
                foreach pawn.RadiusActors(Class'Seat', curSeat, 10000)
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
            bestSeat.sittingActor[bestSlot] = scriptedPawn(pawn);
            scriptedPawn(pawn).SeatLocation       = bestSeat.Location;
            scriptedPawn(pawn).bSeatLocationValid = true;
        }
        else
            scriptedPawn(pawn).bSeatLocationValid = false;

        if (scriptedPawn(pawn).bUseFirstSeatOnly && !scriptedPawn(pawn).bSeatHackUsed)
        {
            scriptedPawn(pawn).SeatHack      = bestSeat;
            scriptedPawn(pawn).bSeatHackUsed = true;
        }

        scriptedPawn(pawn).SeatActor = bestSeat;
        scriptedPawn(pawn).SeatSlot  = bestSlot;
    }

    function FollowSeatFallbackOrders()
    {
        FindBestSeat();
        if (IsSeatValid(scriptedPawn(pawn).SeatActor))
            GotoState('Sitting', 'Begin');
        else
            GotoState('Wandering');
    }

    function BeginState()
    {
        SetEnemy(None, scriptedPawn(pawn).EnemyLastSeen, true);
        Disable('AnimEnd');
        scriptedPawn(pawn).bCanJump = false;

        scriptedPawn(pawn).bAcceptBump = True;

        if (scriptedPawn(pawn).SeatActor == None)
            FindBestSeat();

        scriptedPawn(pawn).bSitInterpolation = false;

        scriptedPawn(pawn).bStasis = false;

        scriptedPawn(pawn).SetupWeapon(false);
        scriptedPawn(pawn).SetDistress(false);
        scriptedPawn(pawn).SeekPawn = None;
        scriptedPawn(pawn).EnableCheckDestLoc(true);
    }

    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        scriptedPawn(pawn).EnableCheckDestLoc(false);
        if (!scriptedPawn(pawn).bSitting)
            scriptedPawn(pawn).StandUp();

        scriptedPawn(pawn).bAcceptBump = True;

        if (scriptedPawn(pawn).JumpZ > 0)
            scriptedPawn(pawn).bCanJump = true;

        scriptedPawn(pawn).bSitInterpolation = false;
        scriptedPawn(pawn).bStasis = true;
      }
    }

Begin:
    WaitForLanding();
    if (!scriptedPawn(pawn).IsSeatValid(scriptedPawn(pawn).SeatActor))
        FollowSeatFallbackOrders();
    if (!scriptedPawn(pawn).bSitting)
        WaitForLanding();
    else
    {
        TurnTo(vector(scriptedPawn(pawn).SeatActor.Rotation + Rot(0, -16384, 0)));
        FinishRotation();
        Goto('ContinueSitting');
    }

MoveToSeat:
    if (IsIntersectingSeat())
        Goto('MoveToPosition');

    // DXR: Special case!
    if ((VSize(scriptedPawn(pawn).SeatActor.Location - Pawn.Location) < CHAIR_IS_CLOSE_DIST) && (bChairFirstHit == false))
    {
        bChairFirstHit = true;
        NotifyBump(scriptedPawn(pawn).SeatActor);
    }

    scriptedPawn(pawn).bAcceptBump = true;
    while (true) // Бесконечный цикл?
    {
        if (!IsSeatValid(scriptedPawn(pawn).SeatActor))
            FollowSeatFallbackOrders();

        scriptedPawn(pawn).destLoc = GetDestinationPosition(scriptedPawn(pawn).SeatActor);
       //else
        if (PointReachable(scriptedPawn(pawn).destLoc))
        {
            if (scriptedPawn(pawn).ShouldPlayWalk(scriptedPawn(pawn).destLoc))
                scriptedPawn(pawn).PlayWalking();
            //MoveTo(scriptedPawn(pawn).destLoc,None, true);//, GetWalkingSpeed());
            MoveTo(scriptedPawn(pawn).destLoc,scriptedPawn(pawn).SeatActor, true);//, GetWalkingSpeed());
            scriptedPawn(pawn).CheckDestLoc(scriptedPawn(pawn).destLoc);

            bSeatIsPointInCylinder = IsPointInCylinder(pawn, GetDestinationPosition(scriptedPawn(pawn).SeatActor), 16, 16);
//            log(pawn@"State Sitting, bSeatIsPointInCylinder ?"@bSeatIsPointInCylinder);
            if (bSeatIsPointInCylinder)
            {
//                log(pawn@"State Sitting, bSeatIsPointInCylinder ?"@bSeatIsPointInCylinder);
                scriptedPawn(pawn).bAcceptBump = false;
                Goto('MoveToPosition');
                break;
            }
        }
        else
        {
            MoveTarget = GetNextWaypoint(scriptedPawn(pawn).SeatActor);
            if (MoveTarget != None)
            {
                if (scriptedPawn(pawn).ShouldPlayWalk(MoveTarget.Location))
                    scriptedPawn(pawn).PlayWalking();
                MoveToward(MoveTarget,/*None*/,0,false,true);//, GetWalkingSpeed());
                scriptedPawn(pawn).CheckDestLoc(MoveTarget.Location, true);
            }
            else
                break;
        }
    }

CircleToFront:
    scriptedPawn(pawn).bAcceptBump = false;
    if (!IsSeatValid(scriptedPawn(pawn).SeatActor))
        FollowSeatFallbackOrders();

    if (scriptedPawn(pawn).ShouldPlayWalk(GetDestinationPosition(scriptedPawn(pawn).SeatActor, 16)))
        scriptedPawn(pawn).PlayWalking();

    //ChairActor = FindPathTo(GetDestinationPosition(scriptedPawn(pawn).SeatActor, 16),,true);
    ChairLoc = GetDestinationPosition(scriptedPawn(pawn).SeatActor, 16);
    ChairActor = FindPathTo(ChairLoc);
    MoveTo(GetDestinationPosition(scriptedPawn(pawn).SeatActor, 16),None,true);
    //MoveTo(GetDestinationPosition(scriptedPawn(pawn).SeatActor, 16),,true);//, 16));//, GetWalkingSpeed());

MoveToPosition:
    if (!IsSeatValid(scriptedPawn(pawn).SeatActor))
        FollowSeatFallbackOrders();

        bChairFirstHit = true;

    scriptedPawn(pawn).bSitting = true;
    scriptedPawn(pawn).EnableCollision(false);
    scriptedPawn(pawn).Acceleration=vect(0,0,0);

Sit:
    scriptedPawn(pawn).Acceleration=vect(0,0,0);
    scriptedPawn(pawn).Velocity=vect(0,0,0);
    if (!IsSeatValid(scriptedPawn(pawn).SeatActor))
        FollowSeatFallbackOrders();

    scriptedPawn(pawn).remainingSitTime = 0.8;
    scriptedPawn(pawn).PlaySittingDown();
    scriptedPawn(pawn).SetBasedPawnSize(scriptedPawn(pawn).CollisionRadius, scriptedPawn(pawn).GetSitHeight());
    scriptedPawn(pawn).SetPhysics(PHYS_Flying);
    scriptedPawn(pawn).StopStanding();
    scriptedPawn(pawn).bSitInterpolation = true;
    while (scriptedPawn(pawn).bSitInterpolation)
        Sleep(0);
    FinishAnim();
    Goto('ContinueSitting');

ContinueFromDoor:
    Goto('MoveToSeat');

ContinueSitting:
    if (!IsSeatValid(scriptedPawn(pawn).SeatActor))
        FollowSeatFallbackOrders();
    scriptedPawn(pawn).SetBasedPawnSize(scriptedPawn(pawn).CollisionRadius, scriptedPawn(pawn).GetSitHeight());
    pawn.SetCollision(pawn.default.bCollideActors, pawn.default.bBlockActors, pawn.default.bBlockPlayers);
    scriptedPawn(pawn).PlaySitting();
    scriptedPawn(pawn).bStasis = true;
    // nil
}

// ----------------------------------------------------------------------
// state HandlingEnemy
//
// Fight-or-flight state
// ----------------------------------------------------------------------
state HandlingEnemy
{
    function BeginState()
    {
        if (Enemy == None)
            GotoState('Seeking');
        else if (ScriptedPawn(pawn).RaiseAlarm == RAISEALARM_BeforeAttacking)
            GotoState('Alerting');
        else
            GotoState('Attacking');
    }
Begin:
}


// ----------------------------------------------------------------------
// state BackingOff
//
// Hack state used to back off when the NPC gets stuck.
// ----------------------------------------------------------------------
state BackingOff
{
    ignores EnemyNotVisible;

    function SetFall()
    {
        StartFalling('BackingOff', 'ContinueRun');
    }

    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (pawn.Physics == PHYS_Falling)
            return true;

        Global.NotifyHitWall(HitNormal, Wall);
        CheckOpenDoor(HitNormal, Wall);
        return !ScriptedPawn(pawn).bCrouchToPassObstacles;
    }

    function bool PickDestination2()
    {
        local bool    bSuccess;
        local float   magnitude;
        local rotator rot;

        magnitude = 300;

        rot = Rotator(Destination-pawn.Location);
        bSuccess = AIPickRandomDestination(64, magnitude, rot.Yaw+32768, 0.8, -rot.Pitch, 0.8, 3, 0.9, ScriptedPawn(pawn).useLoc);

        return bSuccess;
    }

    function bool HandleTurn(Actor Other)
    {
        GotoState('BackingOff', 'Pause');
        return false;
    }

    function BeginState()
    {
        ScriptedPawn(pawn).StandUp();
        ScriptedPawn(pawn).BlockReactions();
        ScriptedPawn(pawn).bStasis = false;
        ScriptedPawn(pawn).bInTransientState = true;
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
        ScriptedPawn(pawn).bCanJump = false;
    }

    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
        if (pawn.JumpZ > 0)
            pawn.bCanJump = true;
        ScriptedPawn(pawn).ResetReactions();
        ScriptedPawn(pawn).bStasis = true;
        ScriptedPawn(pawn).bInTransientState = false;
      }
    }

Begin:
    ScriptedPawn(pawn).useRot = pawn.Rotation;
    if (!PickDestination2())
        Goto('Pause');
    pawn.Acceleration = vect(0,0,0);

MoveAway:
    if (ScriptedPawn(pawn).ShouldPlayWalk(ScriptedPawn(pawn).useLoc))
        ScriptedPawn(pawn).PlayRunning();
    MoveTo(ScriptedPawn(pawn).useLoc, ,false);

Pause:
    pawn.Acceleration = vect(0,0,0);
    pawn.PlayWaiting();
    Sleep(FRand()*2+2);

Done:
    if (HasNextState())
        GotoNextState();
    else
        FollowOrders();  // THIS IS BAD!!!

ContinueRun:
ContinueFromDoor:
    Goto('Done');

}



state FallingState 
{
    //ignores NotifyBump, NotifyHitwall, /*WarnTarget,*/ ReactToInjury;

    event bool NotifyPhysicsVolumeChange(PhysicsVolume NewVolume)
    {
        Global.NotifyPhysicsVolumeChange(newVolume);
        if (newVolume.bWaterVolume)
            GotoState('FallingState', 'Splash');

        return false;
    }

    //choose a jump velocity
    function AdjustJump()
    {
        local float velZ;
        local vector FullVel;

        velZ = pawn.Velocity.Z;
        FullVel = Normal(pawn.Velocity) * pawn.GroundSpeed;

        if (pawn.Location.Z > Destination.Z + pawn.CollisionHeight + 2 * ScriptedPawn(pawn).MaxiStepHeight)
        {
            pawn.Velocity = FullVel;
            pawn.Velocity.Z = velZ;
            pawn.Velocity = EAdjustJump(Pawn.Velocity.Z,pawn.GroundSpeed);
            pawn.Velocity.Z = 0;
            if (VSize(pawn.Velocity) < 0.9 * pawn.GroundSpeed)
            {
                pawn.Velocity.Z = velZ;
                return;
            }
        }

        ScriptedPawn(pawn).Velocity = FullVel;
        ScriptedPawn(pawn).Velocity.Z = ScriptedPawn(pawn).JumpZ + velZ;
        ScriptedPawn(pawn).Velocity = EAdjustJump(Pawn.Velocity.Z,pawn.GroundSpeed);
    }

    singular function BaseChange()
    {
        local float minJumpZ;

        //Global.BaseChange();

        if (pawn.Physics == PHYS_Walking)
        {
            minJumpZ = FMax(pawn.JumpZ, 150.0);
            ScriptedPawn(pawn).bJustLanded = true;
            if (pawn.Health > 0)
            {
                if ((pawn.Velocity.Z < -0.8 * minJumpZ) || pawn.bUpAndOut)
                    GotoState('FallingState', 'Landed');
                else if (pawn.Velocity.Z < -0.8 * pawn.JumpZ)
                    GotoState('FallingState', 'FastLanded');
                else
                    GotoState('FallingState', 'Done');
            }
        }
    }

  event bool NotifyLanded(vector HitNormal)
    {
        local float landVol, minJumpZ;
        local vector legLocation;

        minJumpZ = FMax(pawn.JumpZ, 150.0);

        if ( (pawn.Velocity.Z < -0.8 * minJumpZ) || pawn.bUpAndOut)
        {
            ScriptedPawn(pawn).PlayLanded(pawn.Velocity.Z);
            if (pawn.Velocity.Z < -700)
            {
                legLocation = pawn.Location + vect(-1,0,-1);            // damage left leg
                pawn.TakeDamage(-0.14 * (pawn.Velocity.Z + 700), pawn, legLocation, vect(0,0,0), class'fell');
                legLocation = pawn.Location + vect(1,0,-1);         // damage right leg
                pawn.TakeDamage(-0.14 * (pawn.Velocity.Z + 700), pawn, legLocation, vect(0,0,0), class'fell');
                legLocation = pawn.Location + vect(0,0,1);          // damage torso
                pawn.TakeDamage(-0.04 * (Velocity.Z + 700), pawn, legLocation, vect(0,0,0), class'fell');
            }
            landVol = pawn.Velocity.Z/pawn.JumpZ;
            landVol = 0.005 * pawn.Mass * FMin(5, landVol * landVol);
            if (!pawn.PhysicsVolume.bWaterVolume)
                pawn.PlaySound(ScriptedPawn(pawn).Land, SLOT_Interact, FMin(20, landVol));
        }
        else if ( pawn.Velocity.Z < -0.8 * pawn.JumpZ )
            ScriptedPawn(pawn).PlayLanded(Velocity.Z);

  return true;
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
        ScriptedPawn(pawn).bInterruptState = false;
        ScriptedPawn(pawn).bCanConverse = False;
        ScriptedPawn(pawn).bStasis = False;
        ScriptedPawn(pawn).bInTransientState = true;
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
    }

    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
        ScriptedPawn(pawn).bUpAndOut = false;
        ScriptedPawn(pawn).bInterruptState = true;
        ScriptedPawn(pawn).bCanConverse = True;
        ScriptedPawn(pawn).bStasis = True;
        ScriptedPawn(pawn).bInTransientState = false;
      }
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

          pawn.Velocity.Z = FMax(ScriptedPawn(pawn).JumpZ, 250);
    }
    Goto('LongFall');

FastLanded:
    FinishAnim();
    ScriptedPawn(pawn).TweenToWaiting(0.15);
    Goto('Done');

Landed:
    if (!bIsPlayer) //bots act like players
      ScriptedPawn(pawn).Acceleration = vect(0,0,0);

    FinishAnim();
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
    ScriptedPawn(pawn).bUpAndOut = false;
    FinishAnim();
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
        if (!ScriptedPawn(pawn).bJumpOffPawn)
            AdjustJump();
        else
            ScriptedPawn(pawn).bJumpOffPawn = false;

PlayFall:
        ScriptedPawn(pawn).PlayFalling();
        FinishAnim();
    }
    
    if (pawn.Physics != PHYS_Falling)
        Goto('Done');
    Sleep(2.0);
    Goto('LongFall');

Ducking:
        
}


// Диалог от третьего лица.
state Conversation
{
    event Tick(float deltaTime)
    {
        Global.Tick(deltaTime);

//        LipSynch(deltaTime);
        // Keep turning towards the person we're speaking to
        if (ScriptedPawn(pawn).ConversationActor != None)
        {
            if (ScriptedPawn(pawn).bSitting)
            {
                if (ScriptedPawn(pawn).SeatActor != None)
                    LookAtActor(ScriptedPawn(pawn).ConversationActor, true, true, true, 0, 0.5, ScriptedPawn(pawn).SeatActor.Rotation.Yaw+49152, 5461);
                else
                    LookAtActor(ScriptedPawn(pawn).ConversationActor, false, true, true, 0, 0.5);
            }
            else
                LookAtActor(ScriptedPawn(pawn).ConversationActor, true, true, true, 0, 0.5);
        }
    }

    function LoopHeadConvoAnim()
    {
    }

    function SetOrders(Name orderName, optional Name newOrderTag, optional bool bImmediate)
    {
        local DeusExPlayer dxPlayer;

        dxPlayer = DeusExPlayer(GetPlayerPawn());
        if (dxPlayer != None)
            if (dxPlayer.ConPlay != None)
                if (dxPlayer.ConPlay.GetForcePlay())
                {
                    Global.SetOrders(orderName, newOrderTag, bImmediate);
                    return;
                }

        ScriptedPawn(pawn).ConvOrders   = orderName;
        ScriptedPawn(pawn).ConvOrderTag = newOrderTag;
    }

    function FollowOrders(optional bool bDefer)
    {
        local name tempConvOrders, tempConvOrderTag;

        // hack
        tempConvOrders   = ScriptedPawn(pawn).ConvOrders;
        tempConvOrderTag = ScriptedPawn(pawn).ConvOrderTag;
        ResetConvOrders();  // must do this before calling SetOrders(), or recursion will result

        if (tempConvOrders != '')
            Global.SetOrders(tempConvOrders, tempConvOrderTag, true);
        else
            Global.FollowOrders(bDefer);
    }

    function BeginState()
    {
        local DeusExPlayer dxPlayer;
        local bool         bBlock;
        local Name         Orders;

        ResetConvOrders();
        ScriptedPawn(pawn).EnableCheckDestLoc(false);

        bBlock = True;
        dxPlayer = DeusExPlayer(GetPlayerPawn());
        if (dxPlayer != None)
            if (dxPlayer.ConPlay != None)
                if (dxPlayer.ConPlay.CanInterrupt())
                    bBlock = False;

        ScriptedPawn(pawn).bInterruptState = True;
        if (bBlock)
        {
            ScriptedPawn(pawn).bCanConverse = False;
            ScriptedPawn(pawn).MakePawnIgnored(true);
            ScriptedPawn(pawn).BlockReactions(true);
        }
        else
        {
            ScriptedPawn(pawn).bCanConverse = True;
            ScriptedPawn(pawn).MakePawnIgnored(true);
            ScriptedPawn(pawn).BlockReactions(false);
        }

        // Check if the current state is "WaitingFor", "RunningTo" or "GoingTo", in which case
        // we want the orders to be 'Standing' after the conversation is over.  UNLESS the 
        // ScriptedPawn was going somewhere else (OrderTag != '')

        Orders = ScriptedPawn(pawn).Orders;

        if (((Orders == 'WaitingFor') || (Orders == 'RunningTo') || (Orders == 'GoingTo')) && (ScriptedPawn(pawn).OrderTag == ''))
            SetOrders('Standing');

        ScriptedPawn(pawn).bConversationEndedNormally = False;
        ScriptedPawn(pawn).bInConversation = True;
        ScriptedPawn(pawn).bStasis = False;
        ScriptedPawn(pawn).SetDistress(false);
        ScriptedPawn(pawn).SeekPawn = None;
    }

    function EndState()
    {
        local DeusExPlayer player;
        local bool         bForcePlay;

        bForcePlay = false;
        player = DeusExPlayer(GetPlayerPawn());
        if (player != None)
            if (player.conPlay != None)
                bForcePlay = player.conPlay.GetForcePlay();

        ScriptedPawn(pawn).bConvEndState = true;
        if (!bForcePlay && (ScriptedPawn(pawn).bConversationEndedNormally != true))
            player.AbortConversation();
        ScriptedPawn(pawn).bConvEndState = false;
        ResetConvOrders();

        StopBlendAnims();
        ScriptedPawn(pawn).bInterruptState = true;
        ScriptedPawn(pawn).bCanConverse    = True;
        ScriptedPawn(pawn).MakePawnIgnored(false);
        ScriptedPawn(pawn).ResetReactions();
        ScriptedPawn(pawn).bStasis = True;
        ScriptedPawn(pawn).ConversationActor = None;
    }

Begin:
    pawn.Acceleration = vect(0,0,0);
    pawn.DesiredRotation.Pitch = 0;

    if (!ScriptedPawn(pawn).bSitting && !ScriptedPawn(pawn).bDancing)
        ScriptedPawn(pawn).PlayWaiting();
    // we are now idle
}


//--------------------------------------------//
// Диалог от первого лица (не интерактивный). //
//--------------------------------------------//
state FirstPersonConversation
{
   event Tick(float deltatime)
   {
      Global.Tick(deltaTime);
//    ScriptedPawn(pawn).LipSynch(deltaTime);

        if (ScriptedPawn(pawn).ConversationActor != None)
        {
            if (ScriptedPawn(pawn).bSitting)
            {
                if (ScriptedPawn(pawn).SeatActor != None)
                    LookAtActor(ScriptedPawn(pawn).ConversationActor, true, true, true, 0, 0.5, ScriptedPawn(pawn).SeatActor.Rotation.Yaw+49152, 5461);
                else
                    LookAtActor(ScriptedPawn(pawn).ConversationActor, false, true, true, 0, 0.5);
            }
            else
                LookAtActor(ScriptedPawn(pawn).ConversationActor, true, true, true, 0, 0.5);
        }
   }

     function SetOrders(Name orderName, optional Name newOrderTag, optional bool bImmediate)
     {
         ScriptedPawn(pawn).ConvOrders   = orderName;
         ScriptedPawn(pawn).ConvOrderTag = newOrderTag;
     }

     function FollowOrders(optional bool bDefer)
     {
         local name tempConvOrders, tempConvOrderTag;

         // hack
         tempConvOrders   = ScriptedPawn(pawn).ConvOrders;
         tempConvOrderTag = ScriptedPawn(pawn).ConvOrderTag;
         ResetConvOrders();  // must do this before calling SetOrders(), or recursion will result

         if (tempConvOrders != '')
            Global.SetOrders(tempConvOrders, tempConvOrderTag, true);
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

        ScriptedPawn(pawn).bInterruptState = True;
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
            if ((dxPlayer != None) && (dxPlayer.conPlay != None) && dxPlayer.conPlay.con.IsSpeakingActor(dxPlayer))
                ScriptedPawn(pawn).SetReactions(false, false, false, false, true, false, false, true, false, false, true, true);
            else
                ScriptedPawn(pawn).ResetReactions();
        }
        ScriptedPawn(pawn).bConversationEndedNormally = false;
        ScriptedPawn(pawn).bInConversation = true;
        ScriptedPawn(pawn).bStasis = false;
        ScriptedPawn(pawn).SetDistress(false);
        ScriptedPawn(pawn).SeekPawn = None;
   }

   function EndState()
   {
        local DeusExPlayer player;

        ScriptedPawn(pawn).bConvEndState = true;
        if (ScriptedPawn(pawn).bConversationEndedNormally != true)
        {
            player = DeusExPlayer(GetPlayerPawn());
            player.AbortConversation();
        }
        ScriptedPawn(pawn).bConvEndState = false;
        ScriptedPawn(pawn).ResetConvOrders();

        StopBlendAnims();
        ScriptedPawn(pawn).bInterruptState = true;
        ScriptedPawn(pawn).bCanConverse    = true;
        ScriptedPawn(pawn).MakePawnIgnored(false);
        ScriptedPawn(pawn).ResetReactions();
        ScriptedPawn(pawn).bStasis = true;
        ScriptedPawn(pawn).ConversationActor = None;
   }
Begin:
    pawn.Acceleration = vect(0,0,0);
    pawn.DesiredRotation.Pitch = 0;

    FinishRotation();//

    if (!ScriptedPawn(pawn).bSitting && !ScriptedPawn(pawn).bDancing)
        pawn.PlayWaiting();
}


state Idle
{
    ignores Notifybump, frob, reacttoinjury;

    function BeginState()
    {
        ScriptedPawn(pawn).StandUp();
        ScriptedPawn(pawn).BlockReactions(true);
        ScriptedPawn(pawn).bCanConverse = False;
        ScriptedPawn(pawn).SeekPawn = None;
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
    }
    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        ScriptedPawn(pawn).ResetReactions();
        ScriptedPawn(pawn).bCanConverse = true;
      }
    }

Begin:
    scriptedPawn(pawn).Acceleration = vect(0,0,0);
    scriptedPawn(pawn).DesiredRotation = scriptedPawn(pawn).Rotation;
    scriptedPawn(pawn).PlayAnimPivot('Still');

Idle:
}

//------------------------------------------//
state TakingHit
{
    ignores seeplayer, hearnoise, Notifybump, Notifyhitwall, reacttoinjury;

    function NotifyTakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<damageType> damageType)
    {
        ScriptedPawn(pawn).TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, false);
    }

     event bool NotifyLanded(vector HitNormal)
    {
        //if (pawn.Velocity.Z < -1.4 * pawn.JumpZ)
        //    pawn.MakeNoise(-0.5 * pawn.Velocity.Z/(FMax(pawn.JumpZ, 150.0)));
        pawn.bJustLanded = true;

        return true;
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
      if (ScriptedPawn(pawn) != None)
      {
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
        ScriptedPawn(pawn).bInterruptState = true;
        ScriptedPawn(pawn).ResetReactions();
        ScriptedPawn(pawn).bCanConverse = true;
        ScriptedPawn(pawn).bStasis = true;
        ScriptedPawn(pawn).bInTransientState = false;
      }
    }
        
Begin:
    ScriptedPawn(pawn).Acceleration = vect(0, 0, 0);
    FinishAnim();
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
// state Burning
//
// Whoa-oh-oh, I'm on fire.
// ----------------------------------------------------------------------

state Burning
{
    function ReactToInjury(Pawn instigatedBy, class<DamageType> damageType, ScriptedPawn.EHitLocation hitPos)
    {
        local name newLabel;

        if (pawn.health > 0)
        {
            if (enemy != instigatedBy)
            {
                SetEnemy(instigatedBy);
                newLabel = 'NewEnemy';
            }
            else
                newLabel = 'ContinueBurn';

            if (Enemy != None)
                LastSeenPos = Enemy.Location;
            SetNextState('Burning', newLabel);
            if ((damageType != class'DM_TearGas') && (damageType != class'DM_HalonGas') && (damageType != class'DM_Stunned'))
                GotoDisabledState(damageType, hitPos);
        }
    }

    function SetFall()
    {
        StartFalling('Burning', 'ContinueBurn');
    }

    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (pawn.Physics == PHYS_Falling)
            return true;
        Global.HitWall(HitNormal, Wall);
        CheckOpenDoor(HitNormal, Wall);
        return !ScriptedPawn(pawn).bCrouchToPassObstacles;
    }

    function PickDestination()
    {
        local float           magnitude;
        local float           distribution;
        local int             yaw, pitch;
        local Rotator         rotator1;
        local NavigationPoint nav;
        local float           dist;
        local NavigationPoint bestNav;
        local float           bestDist;

        ScriptedPawn(pawn).destPoint = None;
        bestNav   = None;
        bestDist  = 2000;   // max distance to water

        // Seek out water
        if (ScriptedPawn(pawn).bCanSwim)
        {
            nav = Level.NavigationPointList;
            while (nav != None)
            {
                if (nav.PhysicsVolume.bWaterVolume)
                {
                    dist = VSize(pawn.Location - nav.Location);
                    if (dist < bestDist)
                    {
                        bestNav  = nav;
                        bestDist = dist;
                    }
                }
                nav = nav.nextNavigationPoint;
            }
        }

        if (bestNav != None)
        {
            // It'd be nice if we could traverse all pathnodes and figure out their
            // distances...  unfortunately, it's too slow.  :(

            MoveTarget = FindPathToward(bestNav);
            if (MoveTarget != None)
            {
                ScriptedPawn(pawn).destPoint = bestNav;
                ScriptedPawn(pawn).destLoc   = bestNav.Location;
            }
        }

        // Can't get to water -- run willy-nilly
        if (ScriptedPawn(pawn).destPoint == None)
        {
            if (Enemy == None)
            {
                yaw = 0;
                pitch = 0;
                distribution = 0;
            }
            else
            {
                rotator1 = Rotator(pawn.Location-Enemy.Location);
                yaw = rotator1.Yaw;
                pitch = rotator1.Pitch;
                distribution = 0.5;
            }

            magnitude = 300*(FRand()*0.4+0.8);  // 400, +/-20%
            if (!AIPickRandomDestination(100, magnitude, yaw, distribution, pitch, distribution, 4,
                                         FRand()*0.4+0.35, ScriptedPawn(pawn).destLoc))
                ScriptedPawn(pawn).destLoc = pawn.Location+(VRand()*200);  // we give up
        }
    }

    function BeginState()
    {
        ScriptedPawn(pawn).StandUp();
        ScriptedPawn(pawn).BlockReactions();
        ScriptedPawn(pawn).bCanConverse = False;
        ScriptedPawn(pawn).SetupWeapon(false, true);
        ScriptedPawn(pawn).bStasis = False;
        ScriptedPawn(pawn).SetDistress(true);
        ScriptedPawn(pawn).EnemyLastSeen = 0;
        ScriptedPawn(pawn).SeekPawn = None;
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
    }

    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
        ScriptedPawn(pawn).ResetReactions();
        ScriptedPawn(pawn).bCanConverse = True;
        ScriptedPawn(pawn).bStasis = True;
      }
    }

Begin:
    if (!ScriptedPawn(pawn).bOnFire)
        Goto('Done');
    ScriptedPawn(pawn).PlayOnFireSound();

NewEnemy:
    pawn.Acceleration = vect(0, 0, 0);

Run:
    if (!ScriptedPawn(pawn).bOnFire)
        Goto('Done');
    ScriptedPawn(pawn).PlayPanicRunning();
    PickDestination();
    if (ScriptedPawn(pawn).destPoint != None)
    {
        MoveToward(MoveTarget, , , ,false);
        while ((MoveTarget != None) && (MoveTarget != ScriptedPawn(pawn).destPoint))
        {
            MoveTarget = FindPathToward(ScriptedPawn(pawn).destPoint);
            if (MoveTarget != None)
                MoveToward(MoveTarget, , , ,false);
        }
    }
    else
        MoveTo(ScriptedPawn(pawn).destLoc, ,false);
    Goto('Run');

Done:
    if (ScriptedPawn(pawn).IsValidEnemy(DeusExPawn(Enemy)))
        ScriptedPawn(pawn).HandleEnemy();
    else
        FollowOrders();

ContinueBurn:
ContinueFromDoor:
    Goto('Run');
}


// ----------------------------------------------------------------------
// state RubbingEyes
//
// React to evil things like pepper spray.
// ----------------------------------------------------------------------
state RubbingEyes
{
    ignores seeplayer, hearnoise, notifybump, notifyhitwall;

    function NotifyTakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
    {
        ScriptedPawn(Pawn).TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, false);
    }

    function ReactToInjury(Pawn instigatedBy, class<damageType> damageType, ScriptedPawn.EHitLocation hitPos)
    {
        if ((damageType != class'DM_TearGas') && (damageType != class'DM_HalonGas') && (damageType != class'DM_Stunned'))
            Global.ReactToInjury(instigatedBy, damageType, hitPos);
    }

    function SetFall()
    {
        StartFalling(NextState, NextLabel);
    }

    function AnimEnd(int channel)
    {
        pawn.PlayWaiting();
    }

    function BeginState()
    {
        ScriptedPawn(pawn).StandUp();
        Disable('AnimEnd');
//      LastPainTime = Level.TimeSeconds;
//      LastPainAnim = AnimSequence;
        ScriptedPawn(pawn).bInterruptState = false;
        ScriptedPawn(pawn).BlockReactions();
        ScriptedPawn(pawn).bCanConverse = false;
        ScriptedPawn(pawn).bStasis = false;
        ScriptedPawn(pawn).SetupWeapon(false, true);
        ScriptedPawn(pawn).SetDistress(true);
        ScriptedPawn(pawn).bStunned = true;
        ScriptedPawn(pawn).bInTransientState = true;
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
    }

    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
        ScriptedPawn(pawn).bInterruptState = true;
        ScriptedPawn(pawn).ResetReactions();
        ScriptedPawn(pawn).bCanConverse = true;
        ScriptedPawn(pawn).bStasis = true;
        if (ScriptedPawn(pawn).Health > 0)
            ScriptedPawn(pawn).bStunned = False;
        ScriptedPawn(pawn).bInTransientState = false;
      }
    }

Begin:
    ScriptedPawn(pawn).Acceleration = vect(0, 0, 0);
    ScriptedPawn(pawn).PlayTearGasSound();

RubEyes:
    ScriptedPawn(pawn).PlayRubbingEyesStart();
    pawn.FinishAnim(0);
    ScriptedPawn(pawn).PlayRubbingEyes();
    Sleep(RubbingEyes_Delay);
    ScriptedPawn(pawn).PlayRubbingEyesEnd();
    pawn.FinishAnim(0);
    if (HasNextState())
        GotoNextState();
    else
        GotoState('Wandering');
}



// ----------------------------------------------------------------------
// state Stunned
//
// React to being stunned.
// ----------------------------------------------------------------------
state Stunned
{
    ignores seeplayer, hearnoise, Notifybump, Notifyhitwall;

    function NotifyTakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
    {
        ScriptedPawn(Pawn).TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, false);
    }

    function ReactToInjury(Pawn instigatedBy, class<DamageType> damageType, ScriptedPawn.EHitLocation hitPos)
    {
        if ((damageType != class'DM_TearGas') && (damageType != class'DM_HalonGas') && (damageType != class'DM_Stunned'))
            Global.ReactToInjury(instigatedBy, damageType, hitPos);
    }

    function SetFall()
    {
        StartFalling(NextState, NextLabel);
    }

    function AnimEnd(int channel)
    {
        pawn.PlayWaiting();
    }

    function BeginState()
    {
        ScriptedPawn(pawn).StandUp();
        ScriptedPawn(pawn).Disable('AnimEnd');
        ScriptedPawn(pawn).bInterruptState = false;
        ScriptedPawn(pawn).BlockReactions();
        ScriptedPawn(pawn).bCanConverse = false;
        ScriptedPawn(pawn).bStasis = false;
        ScriptedPawn(pawn).SetupWeapon(false);
        ScriptedPawn(pawn).SetDistress(true);
        ScriptedPawn(pawn).bStunned = true;
        ScriptedPawn(pawn).bInTransientState = true;
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
    }

    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
        ScriptedPawn(pawn).bInterruptState = true;
        ScriptedPawn(pawn).ResetReactions();
        ScriptedPawn(pawn).bCanConverse = true;
        ScriptedPawn(pawn).bStasis = true;

        // if we're dead, don't reset the flag
        if (ScriptedPawn(pawn).Health > 0)
            ScriptedPawn(pawn).bStunned = False;
        ScriptedPawn(pawn).bInTransientState = false;
      }
    }

Begin:
    ScriptedPawn(pawn).Acceleration = vect(0, 0, 0);
    ScriptedPawn(pawn).PlayStunned();
    Sleep(Stunned_Delay);
    if (HasNextState())
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

    function AnimEnd(int channel)
    {
        pawn.PlayWaiting();
    }

    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (pawn.Physics == PHYS_Falling)
            return true;

        Global.NotifyHitWall(HitNormal, Wall);
        CheckOpenDoor(HitNormal, Wall);
        return !ScriptedPawn(pawn).bCrouchToPassObstacles;
    }

    event Tick(float deltaSeconds)
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

        scriptedPawn(pawn).SetupWeapon(false);
        scriptedPawn(pawn).SetDistress(false);
        ScriptedPawn(pawn).SeekPawn = None;
        scriptedPawn(pawn).EnableCheckDestLoc(false);
    }

    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        EnableCheckDestLoc(false);
        scriptedPawn(pawn).bAcceptBump = true;

        if (pawn.JumpZ > 0)
            pawn.bCanJump = true;
        pawn.bStasis = true;

        StopBlendAnims();
      }
    }

Begin:
    WaitForLanding();
    if (!scriptedPawn(pawn).bUseHome)
        Goto('StartStand');

MoveToBase:
    if (!IsPointInCylinder(pawn, scriptedPawn(pawn).HomeLoc, 16-pawn.CollisionRadius))
    {
        ScriptedPawn(pawn).EnableCheckDestLoc(true);
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
    TurnTo(/*pawn.Location + */ScriptedPawn(pawn).HomeRot);
//  FinishRotation();

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
        FinishAnim();
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

    event bool NotifyBump(actor bumper)
    {
        if ((ScriptedPawn(pawn) != None) && (ScriptedPawn(pawn).bAcceptBump))
        {
            // If we get bumped by another actor while we wait, start wandering again
            ScriptedPawn(pawn).bAcceptBump = False;
            Disable('AnimEnd');
            GotoState('Wandering', 'Wander');
        }

        // Handle conversations, if need be
        Global.NotifyBump(bumper);

        return true;
    }

    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (pawn.Physics == PHYS_Falling)
            return true;

        Global.NotifyHitWall(HitNormal, Wall);
        CheckOpenDoor(HitNormal, Wall);

        return true;// !ScriptedPawn(pawn).bCrouchToPassObstacles;
    }

    function bool GoHome()
    {
        if (ScriptedPawn(pawn).bUseHome && !IsNearHome(pawn.Location))
        {
            ScriptedPawn(pawn).destLoc = ScriptedPawn(pawn).HomeLoc;
            ScriptedPawn(pawn).destPoint = None;
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
        local ScriptedPawn.WanderCandidates candidates[5];
        local int              candidateCount;
        local int              maxCandidates;
        local int              maxLastPoints;

        local WanderPoint curPoint;
        local Actor       wayPoint;
        local int         i;
        local int         openSlot;
        local float       maxDist;
        local float       dist;
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
        if ((ScriptedPawn(pawn).RandomWandering < 1) && (FRand() > ScriptedPawn(pawn).RandomWandering))
        {
            // Fill the candidate table
            foreach pawn.RadiusActors(Class'WanderPoint', curPoint, 3000*ScriptedPawn(pawn).wanderlust+1000)  // 1000-4000
            {
                // Make sure we haven't been here recently
                for (i=0; i<maxLastPoints; i++)
                {
                    if (ScriptedPawn(pawn).lastPoints[i] == curPoint)
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
                        dist     = VSize(curPoint.location - pawn.location);
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
            ScriptedPawn(pawn).lastPoints[i] = ScriptedPawn(pawn).lastPoints[i-1];
        ScriptedPawn(pawn).lastPoints[0] = None;

        // Do we have a list of candidates?
        if (candidateCount > 0)
        {
            // Pick a candidate at random
            i = Rand(candidateCount);
            curPoint = candidates[i].point;
            wayPoint = candidates[i].waypoint;
            ScriptedPawn(pawn).lastPoints[0] = curPoint;
            MoveTarget    = wayPoint;
            ScriptedPawn(pawn).destPoint     = curPoint;
        }

        // No candidates -- find a random place to go
        else
        {
            MoveTarget = None;
            ScriptedPawn(pawn).destPoint  = None;
            iterations = 6;  // try up to 6 different directions
            while (iterations > 0)
            {
                // How far will we go?
                magnitude = (ScriptedPawn(pawn).wanderlust*400+200) * (FRand()*0.2+0.9); // 200-600, +/-10%

                // Choose our destination, based on whether we have a home base
                if (!ScriptedPawn(pawn).bUseHome)
                    bSuccess = AIPickRandomDestination(100, magnitude, 0, 0, 0, 0, 1, FRand()*0.4+0.35, ScriptedPawn(pawn).destLoc);
                if (mark != None) // Маркер
                   mark.SetLocation(ScriptedPawn(pawn).destLoc);

                else
                {
                    if (magnitude > ScriptedPawn(pawn).HomeExtent)
                        magnitude = ScriptedPawn(pawn).HomeExtent*(FRand()*0.2+0.9);
                    rot = Rotator(ScriptedPawn(pawn).HomeLoc-pawn.Location);
                    bSuccess = AIPickRandomDestination(50, magnitude, rot.Yaw, 0.25, rot.Pitch, 0.25, 1, FRand()*0.4+0.35, ScriptedPawn(pawn).destLoc);
                }

                // Success?  Break out of the iteration loop
                if (bSuccess)
                    if (IsNearHome(ScriptedPawn(pawn).destLoc))
                        break;

                // We failed -- try again
                iterations--;
            }

            // If we got a destination, go there
            if (iterations <= 0)
            {
                ScriptedPawn(pawn).destLoc = /*pawn.*/Location;
                //log(pawn$" -- iterations are over, gonna stay at my location, Giving extra 10 seconds!");
                //if (MoveTimer >= -20);
                  //  MoveTimer = 10;

            }
        }
    }

    event AnimEnd(int channel)
    {
        pawn.PlayWaiting();
    }

    event BeginState()
    {
        ScriptedPawn(pawn).StandUp();
        SetEnemy(None, ScriptedPawn(pawn).EnemyLastSeen, true);
        Disable('AnimEnd');
        pawn.bCanJump = false;
        ScriptedPawn(pawn).SetupWeapon(false);
        ScriptedPawn(pawn).SetDistress(false);
        ScriptedPawn(pawn).SeekPawn = None;
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
    }

    event EndState()
    {
      local int i;

      if (ScriptedPawn(pawn) != None)
      {
        ScriptedPawn(pawn).bAcceptBump = true;

        ScriptedPawn(pawn).EnableCheckDestLoc(false);

        // Clear out our list of last visited points
        for (i=0; i<ArrayCount(ScriptedPawn(pawn).lastPoints); i++)
            ScriptedPawn(pawn).lastPoints[i] = None;

        if (pawn.JumpZ > 0)
            pawn.bCanJump = true;
      }
    }

Begin:
    ScriptedPawn(pawn).destPoint = None;

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
    if (ScriptedPawn(pawn).destPoint != None)
    {
        if (ScriptedPawn(pawn).ShouldPlayWalk(MoveTarget.Location))
              ScriptedPawn(pawn).PlayWalking();
        MoveToward(MoveTarget,,0,false, true);// GetWalkingSpeed());
        while ((MoveTarget != None) && (MoveTarget != ScriptedPawn(pawn).destPoint))
        {
            MoveTarget = FindPathToward(ScriptedPawn(pawn).destPoint);
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
        Sleep(0.5);

Pausing:
    pawn.Acceleration = vect(0, 0, 0);

    // Turn in the direction dictated by the WanderPoint, if there is one
    ScriptedPawn(pawn).sleepTime = 6.0;
    if (WanderPoint(ScriptedPawn(pawn).destPoint) != None)
    {
        if (WanderPoint(ScriptedPawn(pawn).destPoint).gazeItem != None)
        {
            TurnToward(WanderPoint(ScriptedPawn(pawn).destPoint).gazeItem);
            sleepTime = WanderPoint(ScriptedPawn(pawn).destPoint).gazeDuration;
        }
        else if (WanderPoint(ScriptedPawn(pawn).destPoint).gazeDirection != vect(0, 0, 0))
            TurnTo(pawn.Location + WanderPoint(ScriptedPawn(pawn).destPoint).gazeDirection);
    }
    Enable('AnimEnd');
    ScriptedPawn(pawn).TweenToWaiting(0.2);
    ScriptedPawn(pawn).bAcceptBump = True;
    ScriptedPawn(pawn).PlayScanningSound();
    ScriptedPawn(pawn).sleepTime *= (-0.9*ScriptedPawn(pawn).restlessness) + 1;
    Sleep(ScriptedPawn(pawn).sleepTime);
    Disable('AnimEnd');
    ScriptedPawn(pawn).bAcceptBump = False;
    FinishAnim();
    Goto('Wander');

ContinueWander:
ContinueFromDoor:
    FinishAnim();
    ScriptedPawn(pawn).PlayWalking();
    Goto('Wander');
}


/*-- State Dancing ------------*/

state Dancing
{
    ignores EnemyNotVisible;

    function SetFall()
    {
        StartFalling('Dancing', 'ContinueDance');
    }

    function AnimEnd(int channel)
    {
        ScriptedPawn(pawn).PlayDancing();
    }

    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (pawn.Physics == PHYS_Falling)
            return true;

        Global.NotifyHitWall(HitNormal, Wall);
        CheckOpenDoor(HitNormal, Wall);

        return !ScriptedPawn(pawn).bCrouchToPassObstacles;

    }

    function BeginState()
    {
        if (ScriptedPawn(pawn).bSitting && !ScriptedPawn(pawn).bDancing)
            ScriptedPawn(pawn).StandUp();
        ScriptedPawn(pawn).SetEnemy(None, ScriptedPawn(pawn).EnemyLastSeen, true);
        Disable('AnimEnd');
        ScriptedPawn(pawn).bCanJump = false;

        ScriptedPawn(pawn).bStasis = false;

        ScriptedPawn(pawn).SetupWeapon(false);
        ScriptedPawn(pawn).SetDistress(false);
        ScriptedPawn(pawn).SeekPawn = None;
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
    }

    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
        ScriptedPawn(pawn).bAcceptBump = True;

        if (ScriptedPawn(pawn).JumpZ > 0)
            ScriptedPawn(pawn).bCanJump = true;
        ScriptedPawn(pawn).bStasis = true;

        StopBlendAnims();
      }
    }

Begin:
    WaitForLanding();
    if (ScriptedPawn(pawn).bDancing)
    {
        if (ScriptedPawn(pawn).bUseHome)
        {
            TurnTo(ScriptedPawn(pawn).Location + ScriptedPawn(pawn).HomeRot);
            FinishRotation();
        }
        Goto('StartDance');
    }
    if (!ScriptedPawn(pawn).bUseHome)
        Goto('StartDance');

MoveToBase:
    if (!IsPointInCylinder(pawn, ScriptedPawn(pawn).HomeLoc, 16-pawn.CollisionRadius))
    {
        ScriptedPawn(pawn).EnableCheckDestLoc(true);
        while (true)
        {
            if (PointReachable(ScriptedPawn(pawn).HomeLoc))
            {
                if (ScriptedPawn(pawn).ShouldPlayWalk(ScriptedPawn(pawn).HomeLoc))
                    ScriptedPawn(pawn).PlayWalking();
                MoveTo(ScriptedPawn(pawn).HomeLoc,,true);//, GetWalkingSpeed());
                ScriptedPawn(pawn).CheckDestLoc(ScriptedPawn(pawn).HomeLoc);
                break;
            }
            else
            {
                MoveTarget = FindPathTo(ScriptedPawn(pawn).HomeLoc);
                if (MoveTarget != None)
                {
                    if (ScriptedPawn(pawn).ShouldPlayWalk(MoveTarget.Location))
                        ScriptedPawn(pawn).PlayWalking();
                    MoveToward(MoveTarget,,0,false,true);//, GetWalkingSpeed());
                    ScriptedPawn(pawn).CheckDestLoc(MoveTarget.Location, true);
                }
                else
                    break;
            }
        }
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
    }
    TurnTo(pawn.Location + ScriptedPawn(pawn).HomeRot);
    FinishRotation();

StartDance:
    WaitForLanding();
    pawn.Acceleration=vect(0,0,0);
    Goto('Dance');

ContinueFromDoor:
    Goto('MoveToBase');

Dance:
ContinueDance:
    // nil
    ScriptedPawn(pawn).bDancing = true;
    ScriptedPawn(pawn).PlayDancing();
    ScriptedPawn(pawn).bStasis = true;
    if (!ScriptedPawn(pawn).bHokeyPokey)
        Goto('DoNothing');

Spin:
    Sleep(FRand()*5+5);
    ScriptedPawn(pawn).useRot = pawn.DesiredRotation;
    if (FRand() > 0.5)
    {
        TurnTo(1000*vector(ScriptedPawn(pawn).useRot+rot(0,16384,0)));
    }
    else
    {
        TurnTo(1000*vector(ScriptedPawn(pawn).useRot+rot(0,49152,0)));
    }
    FinishRotation();
    Goto('Spin');

DoNothing:
    // nil
}


// ----------------------------------------------------------------------
// state RunningTo
//
// Move to an actor really fast.
// ----------------------------------------------------------------------
state RunningTo
{
    function SetFall()
    {
        StartFalling('RunningTo', 'ContinueRun');
    }

    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (pawn.Physics == PHYS_Falling)
            return true;

        Global.NotifyHitWall(HitNormal, Wall);
        CheckOpenDoor(HitNormal, Wall);

        return !ScriptedPawn(pawn).bCrouchToPassObstacles;
    }

    function bool NotifyBump(actor bumper)
    {
    // If we hit the guy we're going to, end the state
        if (bumper == ScriptedPawn(pawn).OrderActor)
        {
            GotoState('RunningTo', 'Done');
      return true;
        }
        // Handle conversations, if need be
        Global.NotifyBump(bumper);
    }

    function NotifyTouch(actor toucher)
    {
        // If we hit the guy we're going to, end the state
        if (toucher == ScriptedPawn(pawn).OrderActor)
            GotoState('RunningTo', 'Done');

        // Handle conversations, if need be
        Global.NotifyTouch(toucher);
    }

    function BeginState()
    {
//    log("RunningTo: BeginState()" @ ScriptedPawn(pawn).orderActor);
        ScriptedPawn(pawn).StandUp();
        //BlockReactions();
        ScriptedPawn(pawn).SetupWeapon(false);
        ScriptedPawn(pawn).SetDistress(false);
        ScriptedPawn(pawn).bStasis = false;
        ScriptedPawn(pawn).SeekPawn = None;
        ScriptedPawn(pawn).EnableCheckDestLoc(true);
    }
    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
        //ResetReactions();
        ScriptedPawn(pawn).bStasis = true;
      }
    }

Begin:
    pawn.Acceleration = vect(0, 0, 0);
    if (ScriptedPawn(pawn).orderActor == None)
        Goto('Done');

Follow:
//  log("Follow: RunningTo");
    if (IsOverlapping(ScriptedPawn(pawn).orderActor))
        Goto('Done');
    MoveTarget = GetNextWaypoint(ScriptedPawn(pawn).orderActor);
    if ((MoveTarget != None) && (!MoveTarget.PhysicsVolume.bWaterVolume) && (MoveTarget.Physics != PHYS_Falling))
    {
        if ((MoveTarget == ScriptedPawn(pawn).orderActor) && MoveTarget.IsA('Pawn'))
        {
            if (GetNextVector(ScriptedPawn(pawn).orderActor, ScriptedPawn(pawn).useLoc))
            {
                if (ScriptedPawn(pawn).ShouldPlayWalk(ScriptedPawn(pawn).useLoc))
                    ScriptedPawn(pawn).PlayRunning();
                MoveTo(ScriptedPawn(pawn).useLoc,,false); //MoveTo(useLoc, MaxDesiredSpeed);
                ScriptedPawn(pawn).CheckDestLoc(ScriptedPawn(pawn).useLoc);
            }
            else
                Goto('Pause');
        }
        else
        {
            if (ScriptedPawn(pawn).ShouldPlayWalk(MoveTarget.Location))
                ScriptedPawn(pawn).PlayRunning();
                                         //false
        MoveToward(MoveTarget,, 0, true, false);
            ScriptedPawn(pawn).CheckDestLoc(MoveTarget.Location, true);
        }
        if (IsOverlapping(ScriptedPawn(pawn).orderActor))
            Goto('Done');
        else
            Goto('Follow');
    }

Pause:
//  log("Pause: RunningTo");
    pawn.Acceleration = vect(0, 0, 0);

    TurnToward(ScriptedPawn(pawn).orderActor);
    FinishRotation();

    ScriptedPawn(pawn).PlayWaiting();
    Sleep(1.0);
    Goto('Follow');

Done:
//  log("Done: RunningTo");
    if (ScriptedPawn(pawn).orderActor.IsA('PatrolPoint'))
    {
        TurnTo(/*ScriptedPawn(pawn).Location + */PatrolPoint(ScriptedPawn(pawn).orderActor).lookdir);
        FinishRotation();
    }
    GotoState('Standing');

ContinueRun:
ContinueFromDoor:
    ScriptedPawn(pawn).PlayRunning();
    Goto('Follow');
}

// ----------------------------------------------------------------------
// state GoingTo
//
// Move to an actor.
// ----------------------------------------------------------------------
state GoingTo
{
    function SetFall()
    {
        StartFalling('GoingTo', 'ContinueGo');
    }

    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (pawn.Physics == PHYS_Falling)
            return true;

        Global.NotifyHitWall(HitNormal, Wall);
        CheckOpenDoor(HitNormal, Wall);

        return !ScriptedPawn(pawn).bCrouchToPassObstacles;
    }

    event bool NotifyBump(actor bumper)
    {
        // If we hit the guy we're going to, end the state
        if (bumper == ScriptedPawn(pawn).OrderActor)
        {
            GotoState('GoingTo', 'Done');
            return true;
        }

        Global.NotifyBump(bumper);
        // Handle conversations, if need be
    }

    function NotifyTouch(actor toucher)
    {
        // If we hit the guy we're going to, end the state
        if (toucher == ScriptedPawn(pawn).OrderActor)
            GotoState('GoingTo', 'Done');

        // Handle conversations, if need be
        Global.NotifyTouch(toucher);
    }

    function BeginState()
    {
        ScriptedPawn(pawn).StandUp();
        //BlockReactions();
        ScriptedPawn(pawn).SetupWeapon(false);
        ScriptedPawn(pawn).SetDistress(false);
        ScriptedPawn(pawn).bStasis = False;
        ScriptedPawn(pawn).SeekPawn = None;
        ScriptedPawn(pawn).EnableCheckDestLoc(true);
    }

    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
        //ResetReactions();
        ScriptedPawn(pawn).bStasis = true;
      }
    }

Begin:
    ScriptedPawn(pawn).Acceleration = vect(0, 0, 0);
    if (ScriptedPawn(pawn).orderActor == None)
        Goto('Done');

Follow:
    if (IsOverlapping(ScriptedPawn(pawn).orderActor))
        Goto('Done');
    MoveTarget = GetNextWaypoint(ScriptedPawn(pawn).orderActor);
    if ((MoveTarget != None) && (!MoveTarget.PhysicsVolume.bWaterVolume) && (MoveTarget.Physics != PHYS_Falling))
    {
        if ((MoveTarget == ScriptedPawn(pawn).orderActor) && MoveTarget.IsA('Pawn'))
        {
            if (GetNextVector(ScriptedPawn(pawn).orderActor, ScriptedPawn(pawn).useLoc))
            {
                if (ScriptedPawn(pawn).ShouldPlayWalk(ScriptedPawn(pawn).useLoc))
                    ScriptedPawn(pawn).PlayWalking();

            MoveTo(ScriptedPawn(pawn).useLoc, , true); //MoveTo(useLoc, GetWalkingSpeed());
                ScriptedPawn(pawn).CheckDestLoc(ScriptedPawn(pawn).useLoc);
            }
            else
                Goto('Pause');
        }
        else
        {
            if (ScriptedPawn(pawn).ShouldPlayWalk(MoveTarget.Location))
                ScriptedPawn(pawn).PlayWalking();

        MoveToward(MoveTarget,, 0, false, true);            //MoveToward(MoveTarget, GetWalkingSpeed());
            ScriptedPawn(pawn).CheckDestLoc(MoveTarget.Location, true);
        }
        if (IsOverlapping(ScriptedPawn(pawn).orderActor))
            Goto('Done');
        else
            Goto('Follow');
    }

Pause:
    pawn.Acceleration = vect(0, 0, 0);
    TurnToward(ScriptedPawn(pawn).orderActor);
    FinishRotation();
    ScriptedPawn(pawn).PlayWaiting();
    Sleep(1.0);
    Goto('Follow');

Done:
    if (ScriptedPawn(pawn).orderActor.IsA('PatrolPoint'))
    {
        TurnTo(pawn.Location + PatrolPoint(ScriptedPawn(pawn).orderActor).lookdir);
        FinishRotation();
    }

    GotoState('Standing');

ContinueGo:
ContinueFromDoor:
    ScriptedPawn(pawn).PlayWalking();
    Goto('Follow');
}

// ----------------------------------------------------------------------
// state OpeningDoor
//
// Open a door.
// ----------------------------------------------------------------------
state OpeningDoor
{
    ignores EnemyNotVisible;

    function SetFall()
    {
        StartFalling(NextState, NextLabel);
    }

    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (Physics == PHYS_Falling)
            return true;

        Global.HitWall(HitNormal, Wall);
        if (Target == Wall)
            CheckOpenDoor(HitNormal, Wall);

            return true; // true -- !! don't crouch when opening a door !!
    }

    function bool DoorEncroaches()
    {
        local bool        bEncroaches;
        local DeusExMover dxMover;

        bEncroaches = true;
        dxMover = DeusExMover(Target);
        if (dxMover != None)
        {
            if (IsDoor(dxMover) && (dxMover.MoverEncroachType == ME_IgnoreWhenEncroach))
                bEncroaches = false;
        }
        return bEncroaches;
    }

    function FindBackupPoint()
    {
        local vector hitNorm;
        local rotator rot;
        local vector center;
        local vector area;
        local vector relPos;
        local float  distX, distY;
        local float  dist;

        hitNorm = Normal(ScriptedPawn(pawn).destLoc);
        rot = Rotator(hitNorm);
        DeusExMover(Target).ComputeMovementArea(center, area);
        area.X += pawn.CollisionRadius + 30;
        area.Y += pawn.CollisionRadius + 30;
//      area.Z += pawn.CollisionHeight + 30;//
        relPos = pawn.Location - center;
        if ((relPos.X < area.X) && (relPos.X > -area.X) && (relPos.Y < area.Y) && (relPos.Y > -area.Y))
        {
            // hack
            if (hitNorm.Y == 0)
                hitNorm.Y = 0.00000001;
            if (hitNorm.X == 0)
                hitNorm.X = 0.00000001;
            if (hitNorm.X > 0)
                distX = (area.X - relPos.X)/hitNorm.X;
            else
                distX = (-area.X - relPos.X)/hitNorm.X;
            if (hitNorm.Y > 0)
                distY = (area.Y - relPos.Y)/hitNorm.Y;
            else
                distY = (-area.Y - relPos.Y)/hitNorm.Y;
            dist = FMin(distX, distY);
            if (dist < 45)
                dist = 45;
            else if (dist > 700)
                dist = 700;  // sanity check
            if (!AIDirectionReachable(pawn.Location, rot.Yaw, rot.Pitch, 40, dist, ScriptedPawn(pawn).destLoc))
                ScriptedPawn(pawn).destLoc = pawn.Location;
        }
        else
            ScriptedPawn(pawn).destLoc = pawn.Location;
    }

    function vector FocusDirection()
    {
        return (Vector(Rotation)*30);// + pawn.Location);
    }

    function StopWaiting()
    {
        GotoState('OpeningDoor', 'DoorOpened');
    }

    function AnimEnd(int channel)
    {
        pawn.PlayWaiting();
    }

    function BeginState()
    {
        ScriptedPawn(pawn).StandUp();
        Disable('AnimEnd');
        ScriptedPawn(pawn).bCanJump = false;
        ScriptedPawn(pawn).BlockReactions();
        ScriptedPawn(pawn).bStasis = False;
        ScriptedPawn(pawn).bInTransientState = True;
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
    }

    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
        ScriptedPawn(pawn).bAcceptBump = True;

        if (pawn.JumpZ > 0)
            pawn.bCanJump = true;

        ScriptedPawn(pawn).ResetReactions();
        ScriptedPawn(pawn).bStasis = True;
        ScriptedPawn(pawn).bInTransientState = false;
      }
    }

Begin:
    ScriptedPawn(pawn).destLoc = vect(0,0,0);

BeginHitNormal:
    pawn.Acceleration = vect(0,0,0);
    FindBackupPoint();

    if (!DoorEncroaches())
        if (!FrobDoor(Target))
            Goto('DoorOpened'); 

    ScriptedPawn(pawn).PlayRunning();

    TurnTo(FocusDirection());
    FinishRotation();//
    MoveTo(ScriptedPawn(pawn).destLoc,,false);

    if (DoorEncroaches())
        if (!FrobDoor(Target))
            Goto('DoorOpened');

    pawn.PlayWaiting();

    //CyberP A.K.A Totalitarian: added this block, because Sleeping for 5 secs in combat is bad.
    if (target != None && target.IsA('DeusExMover') && DeusExMover(target).MoveTime < 5.0 && DeusExMover(target).bIsDoor)
    {
       if (enemy != None && !DoorEncroaches())
       {
          Sleep(DeusExMover(target).MoveTime*0.35);
       }
       else
          Sleep(DeusExMover(target).MoveTime*0.55);
    }
    else
        Sleep(OpeningDoorSleepTime);

DoorOpened:
    if (HasNextState())
        GotoNextState();
    else
        FollowOrders();  // THIS IS BAD!!!
}


// ----------------------------------------------------------------------
// state AvoidingPawn
//
// Run away from an onrushing pawn (used for small, dumb critters only).
// ----------------------------------------------------------------------
state AvoidingPawn
{
    ignores EnemyNotVisible;

    function SetFall()
    {
        StartFalling('AvoidingPawn', 'ContinueAvoid');
    }

    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (pawn.Physics == PHYS_Falling)
            return true;

        Global.NotifyHitWall(HitNormal, Wall);
        CheckOpenDoor(HitNormal, Wall);
        return !ScriptedPawn(pawn).bCrouchToPassObstacles;
    }

    function PickDestination()
    {
        local int     iterations;
        local float   magnitude;
        local rotator rot;
        local float   speed;
        local float   time;
        local vector  newPos;
        local float   minDist;

        minDist = 20;
        speed = VSize(Enemy.Velocity);
        if (speed == 0)
            time = 1;
        else
            time  = VSize(Location - Enemy.Location)/speed;
        newPos = Enemy.Location + Enemy.Velocity*(time*0.98);

        magnitude  = 100*(FRand()*0.2+0.9);  // 120, +/-10%
        rot        = Rotator(pawn.Location-newPos);
        iterations = 2;
        if (!AIDirectionReachable(pawn.Location, rot.Yaw, rot.Pitch, minDist, magnitude, ScriptedPawn(Pawn).destLoc))
        {
            rot = Rotator(pawn.Location - Enemy.Location);
            if (!AIDirectionReachable(pawn.Location, rot.Yaw, rot.Pitch, minDist, magnitude, ScriptedPawn(Pawn).destLoc))
            {
                if (speed > 0)
                    rot = Rotator(Enemy.Velocity);
                else
                    rot = Enemy.Rotation;
                if (!AIDirectionReachable(pawn.Location, rot.Yaw, rot.Pitch, minDist, magnitude, ScriptedPawn(Pawn).destLoc))
                {
                    rot.Yaw   = -rot.Yaw;
                    rot.Pitch = -rot.Pitch;
                    if (!AIDirectionReachable(pawn.Location, rot.Yaw, rot.Pitch, minDist, magnitude, ScriptedPawn(Pawn).destLoc))
                        ScriptedPawn(Pawn).destLoc = pawn.Location;  // we give up
                }
            }
        }
    }

    function BeginState()
    {
        ScriptedPawn(Pawn).StandUp();
        ScriptedPawn(Pawn).bCanJump = false;
        ScriptedPawn(Pawn).bStasis = false;
        ScriptedPawn(Pawn).SetupWeapon(false);
        ScriptedPawn(Pawn).SetDistress(false);
        ScriptedPawn(Pawn).SeekPawn = None;
        ScriptedPawn(Pawn).EnableCheckDestLoc(false);
    }

    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        ScriptedPawn(Pawn).EnableCheckDestLoc(false);
        ScriptedPawn(Pawn).bAcceptBump = True;
        if (pawn.JumpZ > 0)
            pawn.bCanJump = true;
        ScriptedPawn(Pawn).bStasis = true;
      }
    }

Begin:
    if (!ScriptedPawn(Pawn).ShouldBeStartled(Enemy))
        Goto('Done');
    Goto('Avoid');

ContinueFromDoor:
    Goto('Avoid');

Avoid:
ContinueAvoid:
    if (!ScriptedPawn(Pawn).ShouldBeStartled(Enemy))
        Goto('Done');

    PickDestination();

    if (ScriptedPawn(Pawn).destLoc == pawn.Location)
        Goto('Pause');

    if (ScriptedPawn(Pawn).ShouldPlayWalk(ScriptedPawn(Pawn).destLoc))
        ScriptedPawn(Pawn).PlayRunning();

    MoveTo(ScriptedPawn(Pawn).destLoc,,false);
    Goto('Avoid');

Pause:
    pawn.PlayWaiting();
    Sleep(0.0);
    Goto('Avoid');

Done:
    if (ScriptedPawn(Pawn).Orders != 'AvoidingPawn')
        FollowOrders();
    else
        GotoState('Wandering');
}

// ----------------------------------------------------------------------
// state Following
//
// Follow an actor
// ----------------------------------------------------------------------

state Following
{
    function SetFall()
    {
        StartFalling('Following', 'ContinueFollow');
    }

    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (pawn.Physics == PHYS_Falling)
            return true;
        Global.HitWall(HitNormal, Wall);
        CheckOpenDoor(HitNormal, Wall);
        return !ScriptedPawn(pawn).bCrouchToPassObstacles;
    }

    event Tick(float deltaSeconds)
    {
        Global.Tick(deltaSeconds);

        if (ScriptedPawn(pawn).BackpedalTimer >= 0)
            ScriptedPawn(pawn).BackpedalTimer += deltaSeconds;

        ScriptedPawn(pawn).animTimer[1] += deltaSeconds;
        if ((pawn.Physics == PHYS_Walking) && (ScriptedPawn(pawn).orderActor != None))
        {
/*          if (Acceleration == vect(0,0,0))
                LookAtActor(orderActor, true, true, true, 0, 0.25);
            else
                PlayTurnHead(LOOK_Forward, 1.0, 0.25);*/
        }
    }

    function bool Follow_PickDestination()
    {
        local float   dist;
        local float   extra;
        local float   distMax;
//      local int     dir;
        local rotator rot;
        local bool    bSuccess;

        bSuccess = false;
        ScriptedPawn(pawn).destPoint = None;
        ScriptedPawn(pawn).destLoc   = vect(0, 0, 0);
        extra = ScriptedPawn(pawn).orderActor.CollisionRadius + pawn.CollisionRadius;
        dist = VSize(ScriptedPawn(pawn).orderActor.Location - pawn.Location);
        dist -= extra;
        if (dist < 0)
            dist = 0;

        if ((dist > 180) || (AICanSee(ScriptedPawn(pawn).orderActor, , false, false, false, true) <= 0))
        {
            if (ActorReachable(ScriptedPawn(pawn).orderActor))
            {
                rot = Rotator(ScriptedPawn(pawn).orderActor.Location - pawn.Location);
                distMax = (dist-180)+45;
                if (distMax > 80)
                    distMax = 80;
                bSuccess = AIDirectionReachable(pawn.Location, rot.Yaw, rot.Pitch, 0, distMax, ScriptedPawn(pawn).destLoc);
            }
            else
            {
                MoveTarget = FindPathToward(ScriptedPawn(pawn).orderActor);
                if (MoveTarget != None)
                {
                    ScriptedPawn(pawn).destPoint = MoveTarget;
                    bSuccess = true;
                }
            }
            ScriptedPawn(pawn).BackpedalTimer = -1;
        }
        else if (dist < 60)
        {
            if (ScriptedPawn(pawn).BackpedalTimer < 0)
                ScriptedPawn(pawn).BackpedalTimer = 0;

            if (ScriptedPawn(pawn).BackpedalTimer > 1.0)  // give the player enough time to converse, if he wants to
            {
                rot = Rotator(pawn.Location - ScriptedPawn(pawn).orderActor.Location);
                bSuccess = AIDirectionReachable(ScriptedPawn(pawn).orderActor.Location, rot.Yaw, rot.Pitch, 60+extra, 120+extra, ScriptedPawn(pawn).destLoc);
            }
        }
        else
            ScriptedPawn(pawn).BackpedalTimer = -1;

        return (bSuccess);
    }

    function BeginState()
    {
        ScriptedPawn(pawn).StandUp();
        //Disable('AnimEnd');
        ScriptedPawn(pawn).bStasis = false;
        ScriptedPawn(pawn).SetupWeapon(false);
        ScriptedPawn(pawn).SetDistress(false);
        ScriptedPawn(pawn).BackpedalTimer = -1;
        ScriptedPawn(pawn).SeekPawn = None;
        ScriptedPawn(pawn).EnableCheckDestLoc(true);
    }

    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
        ScriptedPawn(pawn).bAcceptBump = False;
        //Enable('AnimEnd');
        ScriptedPawn(pawn).bStasis = true;
        StopBlendAnims();
      }
    }

Begin:
    ScriptedPawn(pawn).Acceleration = vect(0, 0, 0);
    ScriptedPawn(pawn).destPoint = None;
    if (ScriptedPawn(pawn).orderActor == None)
        GotoState('Standing');

    if (!Follow_PickDestination())
        Goto('Wait');

Follow:
    if (ScriptedPawn(pawn).destPoint != None)
    {
        if (MoveTarget != None)
        {
            if (ScriptedPawn(pawn).ShouldPlayWalk(MoveTarget.Location))
                ScriptedPawn(pawn).PlayRunning();

            MoveToward(MoveTarget, , , ,false);// MaxDesiredSpeed);
            ScriptedPawn(pawn).CheckDestLoc(MoveTarget.Location, true);
        }
        else
            Sleep(0.0);  // this shouldn't happen
    }
    else
    {
        if (ScriptedPawn(pawn).ShouldPlayWalk(ScriptedPawn(pawn).destLoc))
            ScriptedPawn(pawn).PlayRunning();
        MoveTo(ScriptedPawn(pawn).destLoc,,false);// MaxDesiredSpeed);
        ScriptedPawn(pawn).CheckDestLoc(ScriptedPawn(pawn).destLoc);
    }
    if (Follow_PickDestination())
        Goto('Follow');

Wait:
    //PlayTurning();
    //TurnToward(orderActor);
    pawn.PlayWaiting();

WaitLoop:
    pawn.Acceleration = vect(0,0,0);
    Sleep(0.0);
    if (!Follow_PickDestination())
        Goto('WaitLoop');
    else
        Goto('Follow');

ContinueFollow:
ContinueFromDoor:
    pawn.Acceleration = vect(0,0,0);
    if (Follow_PickDestination())
        Goto('Follow');
    else
        Goto('Wait');

}

// ----------------------------------------------------------------------
// state Shadowing
//
// Quietly tail another character
// ----------------------------------------------------------------------

State Shadowing
{
    function SetFall()
    {
        StartFalling('Shadowing', 'ContinueShadow');
    }

    event Tick(float deltaSeconds)
    {
        local bool  bMove;
        local float deltaValue;

        Global.Tick(deltaSeconds);

        deltaValue = deltaSeconds;

        // If we're running, and we can see our target, STOP RUNNING!
        if (ScriptedPawn(pawn).bRunningStealthy)
        {
            ScriptedPawn(pawn).UpdateActorVisibility(ScriptedPawn(pawn).orderActor, deltaValue, 0.0, false);
            deltaValue = 0;
            if (ScriptedPawn(pawn).EnemyLastSeen <= 0)
            {
                ScriptedPawn(pawn).bRunningStealthy = false;
                ScriptedPawn(pawn).PlayWalking();
                // ScriptedPawn(pawn).DesiredSpeed = ScriptedPawn(pawn).GetWalkingSpeed(); // !! Приводит к рассинхронизации шагов и движения.
            }
        }

        // Are we stopped?
        if (ScriptedPawn(pawn).bPausing)
        {
            // Can we see our target?
            bMove = False;
            ScriptedPawn(pawn).UpdateActorVisibility(ScriptedPawn(pawn).orderActor, deltaValue, 0.5, false);
            deltaValue = 0;

            // No -- move toward him!
            if (ScriptedPawn(pawn).EnemyLastSeen > 0.5)
                bMove = True;

            // We can see him, and we're staring...
            else if (ScriptedPawn(pawn).bStaring)
            {
                // ...can he see us staring at him?
                if (Pawn(ScriptedPawn(pawn).orderActor) != None 
                    && (DeusExPawn(ScriptedPawn(pawn).orderActor).AICanSee(/*self*/pawn, , false, true, false, false) > 0))
                    bMove = True;  // Time to look inconspicuous
            }

            // Move if we need to
            if (bMove)
            {
                if (ScriptedPawn(pawn).bStaring)
                    GotoState('Shadowing', 'StopStaring');
                else
                    GotoState('Shadowing', 'StopPausing');
                ScriptedPawn(pawn).bPausing = False;
                ScriptedPawn(pawn).bStaring = False;
            }
        }
    }

    event bool NotifyBump(actor bumper)
    {
        if (ScriptedPawn(pawn).bAcceptBump)
        {
            // If we get bumped by another actor while we wait, start wandering again
            ScriptedPawn(pawn).bAcceptBump = False;
            ScriptedPawn(pawn).bPausing = False;
            ScriptedPawn(pawn).bStaring = False;
            ScriptedPawn(pawn).Disable('AnimEnd');
            GotoState('Shadowing', 'Shadow');
        }

        // Handle conversations, if need be
        Global.NotifyBump(bumper);
        return true;
    }

    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (pawn.Physics == PHYS_Falling)
            return true;
        Global.NotifyHitWall(HitNormal, Wall);
        CheckOpenDoor(HitNormal, Wall);
        return !ScriptedPawn(pawn).bCrouchToPassObstacles;
    }

    function AnimEnd(int channel)
    {
        pawn.PlayWaiting();
    }

    function float DistanceToTarget()
    {
        return (VSize(pawn.Location - ScriptedPawn(pawn).orderActor.Location));
    }

    function bool PickDestination()
    {
        local Actor   destActor;
        local Vector  distVect;
        local Rotator aRelativeRotation;
        local float   magnitude;
        local float   minDist;
        local float   maxDist;
        local float   bestDist;
        local bool    bDest;
        local float   dist;

        // Init
        ScriptedPawn(pawn).destPoint = None;
        ScriptedPawn(pawn).destLoc   = vect(0, 0, 0);

        // Conveniences
        destActor = ScriptedPawn(pawn).orderActor;
        minDist   = 400;
        maxDist   = 700;
        bestDist  = (maxDist + minDist) * 0.5;

        distVect  = pawn.Location - destActor.Location;
        magnitude = VSize(distVect);

        bDest = False;

        // Can we see the target?
        if (AICanSee(destActor, , false, false, false, true) > 0)
        {
            aRelativeRotation = Rotator(distVect);

            // How far will we go?
            dist = (ScriptedPawn(pawn).wanderlust*300+150) * (FRand()*0.2+0.9); // 150-450, +/-10%

            // Move around inconspicuously, like we're just wandering
            if (magnitude < minDist)  // too close -- move away
                bDest = AIPickRandomDestination(100, dist,
                                                aRelativeRotation.Yaw, 0.8, aRelativeRotation.Pitch, 0.8,
                                                3, FRand()*0.4+0.35, ScriptedPawn(pawn).destLoc);

            else if (magnitude < maxDist)  // just right -- move normally
                bDest = AIPickRandomDestination(100, dist,
                                                aRelativeRotation.Yaw+32768, 0, -aRelativeRotation.Pitch, 0,
                                                2, FRand()*0.4+0.35, ScriptedPawn(pawn).destLoc);

            else  // too far -- move closer
                bDest = AIPickRandomDestination(100, dist,
                                                aRelativeRotation.Yaw+32768, 0.8, -aRelativeRotation.Pitch, 0.8,
                                                3, FRand()*0.4+0.35, ScriptedPawn(pawn).destLoc);
        }

        // Nope -- find a path towards him
        else
        {
            MoveTarget = FindPathToward(destActor);
            if (MoveTarget != None)
            {
                if (!MoveTarget.PhysicsVolume.bWaterVolume && (MoveTarget.Physics != PHYS_Falling))
                {
                    ScriptedPawn(pawn).destPoint = MoveTarget;
                    bDest = True;
                }
            }
        }

        // Return TRUE if we found a place to go
        return (bDest);

    }

    function BeginState()
    {
        ScriptedPawn(pawn).StandUp();
        Disable('AnimEnd');
        ScriptedPawn(pawn).bRunningStealthy = False;
        ScriptedPawn(pawn).bPausing = False;
        ScriptedPawn(pawn).bStaring = False;
        ScriptedPawn(pawn).bStasis = False;
        ScriptedPawn(pawn).SetupWeapon(false);
        ScriptedPawn(pawn).SetDistress(false);
        ScriptedPawn(pawn).SeekPawn = None;
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
    }

    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
        ScriptedPawn(pawn).bAcceptBump = False;
        ScriptedPawn(pawn).Enable('AnimEnd');
        ScriptedPawn(pawn).bRunningStealthy = False;
        ScriptedPawn(pawn).bPausing = False;
        ScriptedPawn(pawn).bStaring = False;
        ScriptedPawn(pawn).bStasis = True;
      }
    }

Begin:
    ScriptedPawn(pawn).EnemyLastSeen = 0;
    ScriptedPawn(pawn).destPoint = None;

Shadow:
    WaitForLanding();

Moving:
    Sleep(0.0);

    // Can we go somewhere?
    if (PickDestination())
    {
        // Are we going to a navigation point?
        if (ScriptedPawn(pawn).destPoint != None)
        {
            if (MoveTarget != None)
            {
                // Run if we're too far away, and we can't see our target
                if ((DistanceToTarget() > STATE_SHADOWING_DIST) && (AICanSee(ScriptedPawn(pawn).orderActor, , false, true, true, true) <= 0))
                {
                    ScriptedPawn(pawn).bRunningStealthy = True;

                    if (ScriptedPawn(pawn).ShouldPlayWalk(MoveTarget.Location))
                        ScriptedPawn(pawn).PlayRunning();

                    MoveToward(MoveTarget, , , ,false);// MaxDesiredSpeed);
                }

                // Otherwise, walk nonchalantly
                else
                {
                    ScriptedPawn(pawn).bRunningStealthy = False;
                    if (ScriptedPawn(pawn).ShouldPlayWalk(MoveTarget.Location))
                        ScriptedPawn(pawn).PlayWalking();

                    MoveToward(MoveTarget, , , ,true);
                    //MoveToward(MoveTarget, GetWalkingSpeed());
                }
            }
        }

        // No pathnode, so walk to a point
        else
        {
            ScriptedPawn(pawn).bRunningStealthy = False;
            if (ScriptedPawn(pawn).ShouldPlayWalk(ScriptedPawn(pawn).destLoc))
                ScriptedPawn(pawn).PlayWalking();
            MoveTo(ScriptedPawn(pawn).destLoc,,true);// GetWalkingSpeed());
        }
    }

    // Can we see the target?  If not, keep walking
    if (AICanSee(ScriptedPawn(pawn).orderActor, , false, false, false, true) <= 0)
        Goto('Moving');

Pausing:
    // Stop
    ScriptedPawn(pawn).bRunningStealthy = False;
    pawn.Acceleration = vect(0, 0, 0);

    // Can the target see us?  If not, stare!
    if (ScriptedPawn(pawn).orderActor.IsA('DeusExPawn') && DeusExPawn(ScriptedPawn(pawn).orderActor).AICanSee(/*self*/pawn, , false, true, false, false) <= 0)
        Goto('Staring');

    // Stop normally
    ScriptedPawn(pawn).sleepTime = 6.0;
    Enable('AnimEnd');
    ScriptedPawn(pawn).TweenToWaiting(0.2);
    ScriptedPawn(pawn).bAcceptBump = True;
    ScriptedPawn(pawn).sleepTime *= (-0.9 * ScriptedPawn(pawn).restlessness) + 1;
    ScriptedPawn(pawn).bStaring = False;
    ScriptedPawn(pawn).bPausing = True;
    Sleep(ScriptedPawn(pawn).sleepTime);

StopPausing:
    // Time to move again
    ScriptedPawn(pawn).bPausing = False;
    ScriptedPawn(pawn).bStaring = False;
    Disable('AnimEnd');
    ScriptedPawn(pawn).bAcceptBump = False;
    FinishAnim();
    Goto('Shadow');

Staring:
    // Stare at the target
    ScriptedPawn(pawn).PlayTurning();
    TurnToward(ScriptedPawn(pawn).orderActor);

    Enable('AnimEnd');
    ScriptedPawn(pawn).TweenToWaiting(0.2);

    // Don't move 'til he looks at us
    ScriptedPawn(pawn).bAcceptBump = True;
    ScriptedPawn(pawn).bStaring = True;
    ScriptedPawn(pawn).bPausing = True;
    while (true)
    {
        ScriptedPawn(pawn).PlayTurning();
        TurnToward(ScriptedPawn(pawn).orderActor);
        ScriptedPawn(pawn).TweenToWaiting(0.2);
        Sleep(0.25);
    }

StopStaring:
    // He's looking, or we can't see him -- time to move
    ScriptedPawn(pawn).bPausing = False;
    ScriptedPawn(pawn).bStaring = False;
    Disable('AnimEnd');
    ScriptedPawn(pawn).bAcceptBump = False;
    FinishAnim();
    Goto('Shadow');

ContinueShadow:
ContinueFromDoor:
    FinishAnim();
    ScriptedPawn(pawn).PlayRunning();
    Goto('Moving');
}

// ----------------------------------------------------------------------
// state Alerting
//
// Warn other NPCs that an enemy is about
// ----------------------------------------------------------------------
State Alerting
{
    function SetFall()
    {
        StartFalling('Alerting', 'ContinueAlert');
    }

    event Tick(float deltaSeconds)
    {
        Global.Tick(deltaSeconds);
    }

    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (pawn.Physics == PHYS_Falling)
            return true;
        Global.NotifyHitWall(HitNormal, Wall);
        CheckOpenDoor(HitNormal, Wall);
        return !ScriptedPawn(pawn).bCrouchToPassObstacles;
    }

    event bool NotifyBump(actor bumper)
    {
        if (ScriptedPawn(pawn).bAcceptBump)
        {
            if (bumper == ScriptedPawn(pawn).AlarmActor)
            {
                ScriptedPawn(pawn).bAcceptBump = False;
                GotoState('Alerting', 'SoundAlarm');
            }
        }

        // Handle conversations, if need be
        Global.NotifyBump(bumper);
        return true;
    }

    function bool IsAlarmReady(Actor actorAlarm)
    {
        local bool      bReady;
        local AlarmUnit alarm;

        bReady = false;
        alarm = AlarmUnit(actorAlarm);
        if ((alarm != None) && !alarm.bDeleteMe)
            if (!alarm.bActive)
                if ((alarm.associatedPawn == None) || (alarm.associatedPawn == /*self*/pawn))
                    bReady = true;

        return bReady;
    }

    function TriggerAlarm()
    {
        if ((ScriptedPawn(pawn).AlarmActor != None) && !ScriptedPawn(pawn).AlarmActor.bDeleteMe)
        {
            if (ScriptedPawn(pawn).AlarmActor.hackStrength > 0)  // make sure the alarm hasn't been hacked
                ScriptedPawn(pawn).AlarmActor.Trigger(/*self*/pawn, Enemy);
        }
    }

    function bool IsAlarmInRange(AlarmUnit alarm)
    {
        local bool bInRange;

        bInRange = false;
        if ((alarm != None) && !alarm.bDeleteMe)
           if ((VSize((alarm.Location - pawn.Location)*vect(1,1,0)) < (pawn.CollisionRadius+alarm.CollisionRadius+24)) && 
               (Abs(alarm.Location.Z - pawn.Location.Z) < (pawn.CollisionHeight+alarm.CollisionHeight)))
                bInRange = true;

        return (bInRange);
    }

    function vector FindAlarmPosition(Actor alarm)
    {
        local vector alarmPos;

        alarmPos = alarm.Location;
        alarmPos += vector(alarm.Rotation.Yaw*rot(0,1,0)) * (pawn.CollisionRadius+alarm.CollisionRadius);

        return (alarmPos);
    }

    function bool GetNextAlarmPoint(AlarmUnit alarm)
    {
        local vector alarmPoint;
        local bool   bValid;

        ScriptedPawn(pawn).destPoint = None;
        ScriptedPawn(pawn).destLoc   = vect(0,0,0);
        bValid    = false;

        if ((alarm != None) && !alarm.bDeleteMe)
        {
            alarmPoint = FindAlarmPosition(alarm);
            if (PointReachable(alarmPoint))
            {
                ScriptedPawn(pawn).destLoc = alarmPoint;
                bValid = true;
            }
            else
            {
                MoveTarget = FindPathTo(alarmPoint);
                if (MoveTarget != None)
                {
                    ScriptedPawn(pawn).destPoint = MoveTarget;
                    bValid = true;
                }
            }
        }

        return (bValid);
    }

    function AlarmUnit FindTarget()
    {
        local ScriptedPawn pawnAlly;
        local AlarmUnit    alarm;
        local float        dist;
        local AlarmUnit    bestAlarm;
        local float        bestDist;

        bestAlarm = None;

        // Do we have any allies on this level?
        foreach AllActors(Class'ScriptedPawn', pawnAlly)
            if (ScriptedPawn(pawn).GetPawnAllianceType(pawnAlly) == ALLIANCE_Friendly)
                break;

        // Yes, so look for an alarm box that isn't active...
        if (pawnAlly != None)
        {
            foreach RadiusActors(Class'AlarmUnit', alarm, ALARM_UNIT_FIND_RADIUS)
            {
                if (ScriptedPawn(pawn).GetAllianceType(alarm.Alliance) != ALLIANCE_Hostile)
                {
                    dist = VSize((pawn.Location-alarm.Location)*vect(1,1,2));  // use squished sphere
                    if ((bestAlarm == None) || (dist < bestDist))
                    {
                        bestAlarm = alarm;
                        bestDist  = dist;
                    }
                }
            }

            // Is the nearest alarm already going off?  And can we reach it?
            if (!IsAlarmReady(bestAlarm) || !GetNextAlarmPoint(bestAlarm))
                bestAlarm = None;
        }

        // Return our target alarm box
        return (bestAlarm);
    }

    function bool PickDestination()
    {
        local bool      bDest;
        local AlarmUnit alarm;

        // Init
        ScriptedPawn(pawn).destPoint = None;
        ScriptedPawn(pawn).destLoc   = vect(0, 0, 0);
        bDest     = false;

        // Find an alarm we can trigger
        alarm = FindTarget();
        if (alarm != None)
        {
            // Find a way to get there
            ScriptedPawn(pawn).AlarmActor = alarm;
            alarm.associatedPawn = pawn; /*self*/
            bDest = true;  // if alarm != none, we've already computed the route to the alarm
        }

        // Return TRUE if we were successful
        return (bDest);
    }

    function BeginState()
    {
        ScriptedPawn(pawn).StandUp();
        //Disable('AnimEnd');
        ScriptedPawn(pawn).bAcceptBump = False;
        ScriptedPawn(pawn).bCanConverse = False;
        ScriptedPawn(pawn).AlarmActor = None;
        ScriptedPawn(pawn).bStasis = False;
        ScriptedPawn(pawn).BlockReactions();
        ScriptedPawn(pawn).SetupWeapon(false);
        ScriptedPawn(pawn).SetDistress(false);
        ScriptedPawn(pawn).EnemyReadiness = 1.0;
        ScriptedPawn(pawn).ReactionLevel  = 1.0;
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
    }

    function EndState()
    {
      if (ScriptedPawn(pawn) != None)
      {
        ScriptedPawn(pawn).EnableCheckDestLoc(false);
        ScriptedPawn(pawn).ResetReactions();
        ScriptedPawn(pawn).bAcceptBump = False;
        //Enable('AnimEnd');
        ScriptedPawn(pawn).bCanConverse = True;
        if (ScriptedPawn(pawn).AlarmActor != None)
            if (ScriptedPawn(pawn).AlarmActor.associatedPawn == pawn)
                ScriptedPawn(pawn).AlarmActor.associatedPawn = None;
        ScriptedPawn(pawn).AlarmActor = None;
        ScriptedPawn(pawn).bStasis = True;
      }
    }

Begin:
    if (Enemy == None)
        GotoState('Seeking');
    //EnemyLastSeen = 0;
    ScriptedPawn(pawn).destPoint = None;
    if (ScriptedPawn(pawn).RaiseAlarm == RAISEALARM_Never)
        GotoState('Fleeing');
    if (ScriptedPawn(pawn).AlarmTimer > 0)
        ScriptedPawn(pawn).PlayGoingForAlarmSound();

Alert:
    if (ScriptedPawn(pawn).AlarmTimer > 0)
        Goto('Done');

    WaitForLanding();
    if (!PickDestination())
        Goto('Done');

Moving:
    // Can we go somewhere?
    ScriptedPawn(pawn).bAcceptBump = True;
    ScriptedPawn(pawn).EnableCheckDestLoc(true);
    while (true)
    {
        if (ScriptedPawn(pawn).destPoint != None)
        {
            if (ScriptedPawn(pawn).ShouldPlayWalk(MoveTarget.Location))
                ScriptedPawn(pawn).PlayRunning();
            MoveToward(MoveTarget, , , , false);//, MaxDesiredSpeed);
            ScriptedPawn(pawn).CheckDestLoc(MoveTarget.Location, true);
        }
        else
        {
            if (ScriptedPawn(pawn).ShouldPlayWalk(ScriptedPawn(pawn).destLoc))
                ScriptedPawn(pawn).PlayRunning();
            MoveTo(ScriptedPawn(pawn).destLoc,,false);//, MaxDesiredSpeed);
            ScriptedPawn(pawn).CheckDestLoc(ScriptedPawn(pawn).destLoc);
        }
        if (IsAlarmInRange(ScriptedPawn(pawn).AlarmActor))
            break;
        else if (!GetNextAlarmPoint(ScriptedPawn(pawn).AlarmActor))
            break;
    }
    ScriptedPawn(pawn).EnableCheckDestLoc(false);

SoundAlarm:
    pawn.Acceleration=vect(0,0,0);
    ScriptedPawn(pawn).bAcceptBump = False;
    if (IsAlarmInRange(ScriptedPawn(pawn).AlarmActor))
    {
        TurnToward(ScriptedPawn(pawn).AlarmActor);
        ScriptedPawn(pawn).PlayPushing();
        FinishAnim();
        TriggerAlarm(); 
    }

Done:
    ScriptedPawn(pawn).bAcceptBump = False;
    if (ScriptedPawn(pawn).RaiseAlarm == RAISEALARM_BeforeAttacking)
        GotoState('Attacking');
    else
        GotoState('Fleeing');

ContinueAlert:
ContinueFromDoor:
    Goto('Alert');

}





defaultproperties
{
    bCanOpenDoors=true
    bCanDoSpecial=true
    bIsPlayer=false
    bStasis=false
//    bStasis=true
//    bAdjustFromWalls=true
    bAdjustFromWalls=false
    FovAngle=+90.00
    MinHitWall=9999999827968.00
//    MinHitWall=93372269057156317000.00
    RotationRate=(Pitch=4096,Yaw=50000,Roll=3072)
    AcquisitionYawRate=150000 // How much fast pawn will turn toward enemy
    Skill=2.00
    bSlowerZAcquire=false
}

