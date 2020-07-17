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

function bool PlayTurnHead(ELookDirection newLookDir, float rate, float tweentime)
{
    if (bCanTurnHead)
    {
        if (Super.PlayTurnHead(newLookDir, rate, tweentime))
        {
            AIAddViewRotation = rot(0,0,0); // default
            switch (newLookDir)
            {
                case LOOK_Left:
                    AIAddViewRotation = rot(0,-5461,0);  // 30 degrees left
                    break;
                case LOOK_Right:
                    AIAddViewRotation = rot(0,5461,0);   // 30 degrees right
                    break;
                case LOOK_Up:
                    AIAddViewRotation = rot(5461,0,0);   // 30 degrees up
                    break;
                case LOOK_Down:
                    AIAddViewRotation = rot(-5461,0,0);  // 30 degrees down
                    break;

                case LOOK_Forward:
                    AIAddViewRotation = rot(0,0,0);      // 0 degrees
                    break;
            }
        }
        else
            return false;
    }
    else
        return false;
}


function float ModifyDamage(int Damage, Pawn instigatedBy, Vector hitLocation, Vector offset, class<damageType> damageType, vector Momentum)
{
    local float actualDamage;

    actualDamage = Super.ModifyDamage(Damage, instigatedBy, hitLocation, offset, damageType, Momentum);

    if (damageType == class'DM_Stunned')
        actualDamage = 0;

    return actualDamage;
}

function EHitLocation HandleDamage(int Damage, Vector hitLocation, Vector offset, class<damageType> damageType)
{
    local EHitLocation hitPos;

    hitPos = HITLOC_None;

    if (offset.X < 0.0)
        hitPos = HITLOC_TorsoBack;
    else
        hitPos = HITLOC_TorsoFront;

    if (!bInvincible)
        Health -= Damage;

    return hitPos;

}

function ComputeFallDirection(float totalTime, int numFrames, out vector moveDir, out float stopTime);

function DeusExPawn FrightenedByPawn()
{
    local DeusExPawn  candidate;
    local bool        bCheck;
    local DeusExPawn  fearPawn;

    fearPawn = None;
    if ((!bFleeBigPawns) || (!bBlockActors && !bBlockPlayers))
        return fearPawn;

    foreach RadiusActors(Class'DeusExPawn', candidate, 500)
    {
        bCheck = false;
        if (!ClassIsChildOf(candidate.class, class))
        {
            if (candidate.bBlockActors)
            {
                if (bBlockActors && !candidate.controller.bIsPlayer)
                    bCheck = true;
                else if (bBlockPlayers && candidate.controller.bIsPlayer)
                    bCheck = true;
            }
        }

        if (bCheck)
        {
            if ((candidate.MaxiStepHeight < CollisionHeight*1.5) && (candidate.CollisionHeight*0.5 <= CollisionHeight))
                bCheck = false;
        }

        if (bCheck)
        {
            if (ShouldBeStartled(candidate))
            {
                fearPawn = candidate;
                break;
            }
        }
    }
    return fearPawn;
}

function bool ShouldBeStartled(Pawn startler)
{
    local float speed;
    local float time;
    local float dist;
    local float dist2;
    local bool  bPh33r;

    bPh33r = false;
    if (startler != None)
    {
        speed = VSize(startler.Velocity);
        if (speed >= 20)
        {
            dist = VSize(Location - startler.Location);
            time = dist/speed;
            if (time <= 2.0)
            {
                dist2 = VSize(Location - (startler.Location+startler.Velocity*time));
                if (dist2 < speed*0.6)
                    bPh33r = true;
            }
        }
    }

    return bPh33r;
}


function FleeFromPawn(Pawn fleePawn)
{
    Controller.SetEnemy(fleePawn, , true);
    Controller.GotoState('AvoidingPawn');
}


function vector GetSwimPivot()
{
    // THIS IS A HIDEOUS, UGLY, MASSIVELY EVIL HACK!!!!
    return (vect(0,0,0));
}


function PlayIdleSound();
function PlaySearchingSound();
function PlayScanningSound();
function PlayTargetAcquiredSound();
function PlayTargetLostSound();
function PlayGoingForAlarmSound();
function PlayOutOfAmmoSound();
function PlayCriticalDamageSound();
function PlayAreaSecureSound();
// Approximately five million stubbed out functions...
function PlayRunningAndFiring();
function TweenToShoot(float tweentime);
function PlayShoot();
function TweenToAttack(float tweentime);
function PlayAttack();
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
function PlayCowerBegin();
function PlayCowering();
function PlayCowerEnd();


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
 if (Controller.IsInState('Paralyzed') || Controller.IsInState('Eating') || Controller.IsInState('Attacking') || bSitting || bDancing || bStunned)
    return;

 if (Acceleration == vect(0, 0, 0))
    LoopAnimPivot('BreatheLight', , 0.3);
}

function TweenToSwimming(float tweentime)
{
    TweenAnimPivot('Tread', tweentime, GetSwimPivot()); // Swim?
}

function PlaySwimming()
{
    LoopAnimPivot('Tread', , , , GetSwimPivot());
}

function PlayDying(class<DamageType> damageType, vector hitLoc)
{
    local Vector X, Y, Z;
    local float dotp;

    if (bPlayDying)
    {
        GetAxes(Rotation, X, Y, Z);
        dotp = (Location - HitLoc) dot X;

        // die from the correct side
        if (dotp < 0.0)     // shot from the front, fall back
            PlayAnimPivot('DeathBack',, 0.1);
        else                // shot from the back, fall front
            PlayAnimPivot('DeathFront',, 0.1);
    }
    PlayDyingSound();
}

function PlayPauseWhenEating();

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

function PlayEatingSound();

function float GetMaxDistance(Actor foodActor)
{
  local float maxDist;

  if (foodActor != None)
  {
      maxDist = foodActor.CollisionRadius + CollisionRadius;
      return maxDist;
  }

  return 0.0;
}

// DXR: converted to UDebugger-friendly version.
function bool IsInRange(Actor foodActor)
{
  local float range, col_sum;
  local bool bIsInRange;

  if (foodActor == None)
  return false;

      range = VSize(foodActor.Location-Location);
      col_sum = GetMaxDistance(foodActor) + 20;
      bIsInRange = (range <= col_sum);

      return bIsInRange;
      //return (VSize(foodActor.Location-Location) <= GetMaxDistance(foodActor)+20);

  return false;
}

function bool GetFeedSpot(Actor foodActor, out vector feedSpot)
{
    local rotator rot;
    local bool bFoodReachable;
    local float MaxDist;
    local DestLocMarker marker;

    if (IsInRange(foodActor))
    {
        feedSpot = Location;
        return true;
    }
    else
    {
        rot = Rotator(foodActor.Location - Location);
        maxDist = GetMaxDistance(foodActor);
        bFoodReachable = AIDirectionReachable(foodActor.Location, rot.Yaw, rot.Pitch, 0, MaxDist, feedSpot);

        marker = DXRAiController(Controller).mark;
        if (marker != None) // Маркер
            marker.SetLocation(feedspot);

        return bFoodReachable;
    }
}

function bool IsValidFood(Actor foodActor)
{
    if (foodActor == None)
        return false;
    else if (foodActor.bDeleteMe)
        return false;
    else if (foodActor.PhysicsVolume.bWaterVolume)
        return false;
    else if ((foodActor.Physics == PHYS_Swimming) || (foodActor.Physics == PHYS_Falling))
        return false;
    else if (!ClassIsChildOf(foodActor.Class, FoodClass))
        return false;
    else
        return true;
}

function bool InterestedInFood()
{
    if (((Controller.GetStateName() == 'Wandering') || (Controller.GetStateName() == 'Standing') || (Controller.GetStateName() == 'Patrolling')) && (LastRendered() < 10.0))
        return true;
    else if (bFoodOverridesAttack && ((Controller.GetStateName() == 'Attacking') || (Controller.GetStateName() == 'Seeking')) && (aggressiveTimer <= 0))
        return true;
    else
        return false;
}

function SpewBlood(vector Position)
{
    spawn(class'BloodSpurt', , , Position);
    spawn(class'BloodDrop', , , Position);
    if (FRand() < 0.5)
        spawn(class'BloodDrop', , , Position);
}

// Called from Anim_Notify
function Chomp()
{
    Munch(Food);  // mmm... finger-lickin' good!
}

function vector GetChompPosition()
{
    return (Location+Vector(Rotation)*CollisionRadius);
}

function Munch(Actor foodActor)
{
    if (IsValidFood(foodActor) && IsInRange(Food))
    {
        foodActor.TakeDamage(FoodDamage, self, foodActor.Location, vect(0,0,0), class'DM_Munch');  // finger-lickin' good!
        if (bMessyEater)
            SpewBlood(GetChompPosition());
        Health += FoodHealth;
        if (Health > Default.Health)
            Health = Default.Health;
    }
}

function bool ShouldFlee()
{
    return (Health <= MinHealth);
}

function bool ShouldDropWeapon()
{
    return false;
}

function Tick(float deltaSeconds)
{
    local Actor  curFood;
    local int    lastIndex;
    local float  dist;
    local vector tempVect;

    Super.Tick(deltaSeconds);

    if (checkAggTimer > 0)
    {
        checkAggTimer -= deltaSeconds;
        if (checkAggTimer < 0)
            checkAggTimer = 0;
    }

    if (aggressiveTimer > 0)
    {
        aggressiveTimer -= deltaSeconds;
        if (aggressiveTimer < 0)
            aggressiveTimer = 0;
    }

    if ((FoodClass != None) && InterestedInFood())
    {
        FoodTimer += deltaSeconds;
        if (FoodTimer > 0.5)
        {
            FoodTimer = 0;
            lastIndex = FoodIndex;
            foreach CycleActors(FoodClass, curFood, FoodIndex)
            {
                if (IsValidFood(curFood))
                {
                    dist = VSize(curFood.Location - Location);
                    if ((dist < 400) || ((dist < 800) && (AICanSee(curFood, , false, true, false, false) > 0.0)))
                    {
                        if ((BestFood == None) || (dist < BestDist))
                        {
                            if (GetFeedSpot(curFood, tempVect))
                            {
                                BestDist  = dist;
                                BestFood  = curFood;
                                FoodIndex = 0;
                            }
                            break;
                        }
                    }
                }
            }
            if (lastIndex >= FoodIndex)  // have we cycled through all actors?
            {
                if (BestFood != None)
                {
                    if (bBefriendFoodGiver && (BestFood.Instigator != None))
                        DecreaseAgitation(BestFood.Instigator, 2);
                    Food = BestFood;
                    Controller.SetState('Eating');
                }
                BestFood = None;
            }
        }
    }
    else
        FoodTimer = 0;

}




defaultproperties
{
     FoodDamage=10
     FoodHealth=3
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
     ControllerClass=class'AnimalController'
}
