/*

*/
class ScriptedPawn extends DeusExNPCPawn
            config (DXRConfig)
            abstract;

#exec obj load file=DeusExCharacters.ukx

const BEAM_CHECK_RADIUS = 1200;
const BEST_ENEMY_CHECK_RADIUS = 2000;
const SKIP_ENEMY_DISTANCE = 2500;
const MAX_CARCASS_DIST = 1200;
const GIB_HEALTH = -100;

var name AlarmTag;

var bool bJumpOffPawn;
var() bool bCrouchToPassObstacles; // Использовать в Controller > NotifyHitWall, чтобы Pawn пригибался для обхода ПОД препятствием. По умолчанию False.
var bool bbCheckEnemy;

// ----------------------------------------------------------------------
// Structures

struct WanderCandidates
{
    var WanderPoint point;
    var Actor       waypoint;
    var float       dist;
};

struct FleeCandidates
{
    var HidePoint point;
    var Actor     waypoint;
    var Vector    location;
    var float     score;
    var float     dist;
};

struct NearbyProjectile
{
    var DeusExProjectile projectile;
    var vector           location;
    var float            dist;
    var float            range;
};

struct NearbyProjectileList
{
    var NearbyProjectile list[8];
    var vector           center;
};

struct InventoryItem
{
    var() class<Inventory> Inventory;
    var() int              Count;
};


// ----------------------------------------------------------------------
// Variables

var() WanderPoint    lastPoints[2];
var float            Restlessness;  // 0-1
var float            Wanderlust;    // 0-1
var float            Cowardice;     // 0-1

var(Pawn) class<carcass> CarcassType; // mesh to use when killed from the front

// Advanced AI attributes.
var     HomeBase    HomeActor;      // home base
var     Vector      HomeLoc;        // location of home base
var     Vector      HomeRot;        // rotation of home base
var     bool        bUseHome;       // true if home base should be used
var(Pawn) bool bHasHeels;           // Special case for footstepping

var     AlarmUnit   AlarmActor;

var     bool        bInterruptState; // true if the state can be interrupted
var     bool        bCanConverse;    // true if the pawn can converse

var     bool        bInTransientState;  // true if the NPC is in a 3rd-tier (transient) state, like TakeHit

var(Inventory) InventoryItem InitialInventory[8];  // Initial inventory items carried by the pawn

var      vector   SeatLocation;
var      Seat     SeatActor;
var      Seat     SeatHack;
var      bool     bSeatLocationValid;
var      bool     bSeatHackUsed;

var globalconfig bool bPawnShadows;
var globalconfig bool bBlobShadow;

var DeusExPlayer myDxPlayer;

var DeusExGameInfo flagBase;
var DeusExLevelInfo dxLevel;

// Saving/Loading animations
var name    SaveAnim;           // Last anim I was playing when saved
var float   SaveFrame;          // 0 to 1.0 value for what frame we were on
var float   SaveRate;           // value for how fast we were playing the frame, 1.0 is normal.

function RobotFiringEffects();
function PawnFiringEffects();

function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
//    local string T;
    Super.DisplayDebug(Canvas, YL, YPos);

    Canvas.DrawText("я EnemyLastSeen = "$EnemyLastSeen $ 
    lastPoints[0] @"0 LastPoints 1"@ lastPoints[1]);
//                    " CycleIndex = "$CycleIndex$
//                    " PotentialEnemyTimer = "$PotentialEnemyTimer $ 
//                    " bbCheckEnemy = " $bbCheckEnemy $
//                    " AIVisibility = " $ AIVisibility(self, false));
}

function Draw_DebugLine()
{
//   if (AIDirReach_Location != vect(0,0,0))
//       DrawStayingDebugLine(Location, AIDirReach_Location, 255, 221, 100);

//   if (AIPickRandom_Location != vect(0,0,0))
//       DrawStayingDebugLine(Location, AIPickRandom_Location, 0, 0, 255);

//    if (destPoint != None)
//        DrawStayingDebugLine(Location, DestPoint.Location, 55, 121, 100);

//    if (destLoc != vect(0,0,0))
//        DrawStayingDebugLine(Location, destLoc, 55, 121, 100);

}

event AnimEnd(int channel)
{
//   ClearStayingDebugLines();
}

event PreSaveGame()
{
    // Make anything that was playing an anim in the 0 channel restore properly.
    // Only get them for channel 0.
    GetAnimParams(0, SaveAnim, SaveFrame, SaveRate);
    if(SaveFrame < 0.0)
        SaveFrame = 0.0;
    else if(SaveFrame > 1.0)
        SaveFrame = 1.0;

        SimAnim.AnimSequence = SaveAnim;
        SimAnim.bAnimLoop = false;
        SimAnim.AnimRate = SaveRate;
        SimAnim.AnimFrame = SaveFrame;
        SimAnim.TweenRate = 0.0;
}

event PostLoadSavedGame()
{
//    log(self@"PostLoadSavedGame() called !");

    // Force the animations to restart
    if(SaveAnim != '')
    {
        SetAnimFrame(SaveFrame, 0);

        if (bDancing)
           PlayDancing();
        else
        PlayAnim(SaveAnim, SaveRate, , 0);
    }

    if (shadow == none)
        CreateShadow();

  ConBindEvents();
}

event ObstacleTimerIsOver()
{
  if ((Controller != None) && (controller.MoveTarget != None))
   Controller.Focus = controller.MoveTarget;
}

// Заглушка, для того чтобы собиралось.
final function float ParabolicTrace(out vector finalLocation,optional vector startVelocity,optional vector startLocation,optional bool bCheckActors,
                                    optional vector cylinder,optional float maxTime,optional float elasticity,optional bool bBounce,optional float landingSpeed,
                                    optional float  granularity)
{
   finalLocation = Controller.Enemy.Location;
   return 1.2f + FRand();
}

function float GetCrouchHeight()
{
    return (Default.CollisionHeight*0.65);
}

function TakeDrowningDamage()
{
    // DEUS_EX CNN - make drowning damage happen from center
    TakeDamage(5, None, Location, vect(0,0,0), class'DM_Drowned');
}

/*- Assing Conversations to pawn ---------------------------------------------------------------------------------*/
function ConBindEvents()
{
    local DeusExLevelInfo dxInfo;

    foreach AllActors(class'DeusExLevelInfo', dxInfo)
    {
        if (dxInfo != none)
            break;
    }
    if (dxInfo != none)
    {
       RegisterConFiles(dxinfo.ConversationsPath);
       LoadConsForMission(dxinfo.missionNumber);
       AddRefCount();
    }
    else
        log("DeusExLevelInfo not found! Failed to register conversations.");
}

// Регистрация *.con файлов
function RegisterConFiles(string Path)
{
  local array<byte> bt;
  local array<string> conFiles;
  local int f, res;

  conFiles = class'FileManager'.static.FindFiles(Path$"*.con", true, false);

  if (conFiles.length == 0)
  {
     log("ERROR -- No *.con files found !");
     return;
  }

  for (f=0; f<conFiles.length; f++)
  {
     bt = class'DXUtil'.static.GetFileAsArray(Path$conFiles[f]);
     res = class'ConversationManager'.static.RegisterConFile(Path$conFiles[f],bt);
  }
}

/* 
   AI controlled creatures may duck
   if not falling, and projectile time is long enough
   often pick opposite to current direction (relative to shooter axis)

   DXR: Maybe send this to controller?
*/
function WarnTarget(Pawn shooter, float projSpeed, vector FireDir);

function Touch(actor toucher)
{
   super.Touch(toucher);

   if (DXRAIController(controller) != none)
       DXRAIController(controller).NotifyTouch(toucher);
}

// ToDo: Add support for changeable presets?
function sound GetBulletHitSound()
{
    local DeusExGlobals gl;
    local sound aSound;
    local int SoundNum;

    SoundNum = Rand(4);
    gl = class'DeusExGlobals'.static.GetGlobals();

    if (SoundNum == 3)
        aSound = sound(DynamicLoadObject("DESO_Flam.BodyHit.BodyHit_a", class'Sound', false));
    else if (SoundNum == 2)
        aSound = sound(DynamicLoadObject("DESO_Flam.BodyHit.BodyHit_b", class'Sound', false));
    else if (SoundNum == 1)
        aSound = sound(DynamicLoadObject("DESO_Flam.BodyHit.BodyHit_c", class'Sound', false));
    else if (SoundNum == 0)
        aSound = sound(DynamicLoadObject("DESO_Flam.BodyHit.BodyHit_d", class'Sound', false));

    return aSound;
}


// ----------------------------------------------------------------------
// PreBeginPlay()
// ----------------------------------------------------------------------
function PreBeginPlay()
{
    // Added angular size computation - DEUS_EX STM
  MinAngularSize = tan(AngularResolution*0.5*Pi/180.0);
  MinAngularSize *= MinAngularSize;

  // TODO:
  //
  // Okay, we need to save the base eye height right now becase it's
  // obliterated in Pawn.uc with the following:
  //
  //  EyeHeight = 0.8 * CollisionHeight; //FIXME - if all baseeyeheights set right, use them
  //  BaseEyeHeight = EyeHeight;
  //
  // This must be fixed after ECTS.

  Super.PreBeginPlay();

  // Set our alliance
  SetAlliance(Alliance);

  // Set up callbacks
//  UpdateReactionCallbacks();

}

// ----------------------------------------------------------------------
// PostBeginPlay()
// ----------------------------------------------------------------------
event PostBeginPlay()
{
  local float defHeight;

  defHeight = collisionHeight;

    ConBindEvents();

    Super.PostBeginPlay();

    if ((ControllerClass != None) && (Controller == None))
    {
        Controller = spawn(ControllerClass);
        Controller.pawn = self;
    }

    if (Controller != None)
    {
        Controller.Possess(self);
        Controller.pawn = self;
    }
    CreateShadow();
}

event Destroyed()
{
    local DeusExPlayer player;

    // Pass a message to conPlay, if it exists in the player, that 
    // this pawn has been destroyed.  This is used to prevent 
    // bad things from happening in conversations.
    player = DeusExPlayer(GetPlayerPawn());

    if ((player != None) && (player.conPlay != None))
         player.conPlay.ActorDestroyed(Self);

    ClearStayingDebugLines();
    Super.Destroyed();
}

function bool SetEnemy(Pawn newEnemy, optional float newSeenTime, optional bool bForce)
{
    if (bForce || IsValidEnemy(DeusExPawn(newEnemy)))
    {
        if (newEnemy != Controller.Enemy)
            EnemyTimer = 0;
        Controller.Enemy = newEnemy;
        EnemyLastSeen    = newSeenTime;

        return True;
    }
    else
        return False;
}

function HandToHandAttack()
{
    local DeusExWeapon dxWeapon;

    dxWeapon = DeusExWeapon(Weapon);
    if (dxWeapon != None)
        dxWeapon.OwnerHandToHandAttack();
}

// ----------------------------------------------------------------------
// SetHomeBase()
// ----------------------------------------------------------------------
function SetHomeBase(vector baseLocation, optional rotator baseRotator, optional float baseExtent)
{
    if (baseExtent == 0)
        baseExtent = 800;

    HomeTag    = '';
    HomeActor  = None;
    HomeLoc    = baseLocation;
    HomeRot    = vector(baseRotator)*100;
    HomeExtent = baseExtent;
    bUseHome   = true;
}

// ----------------------------------------------------------------------
// ClearHomeBase()
// ----------------------------------------------------------------------
function ClearHomeBase()
{
    HomeTag  = '';
    bUseHome = false;
}

// ----------------------------------------------------------------------
// IsSeatValid()
// ----------------------------------------------------------------------
function bool IsSeatValid(Actor checkActor)
{
    local DeusExPlayer player;
    local Seat       checkSeat;

    checkSeat = Seat(checkActor);
    if (checkSeat == None)
        return false;
    else if (checkSeat.bDeleteMe)
        return false;
    else if (!bSitAnywhere && (VSize(checkSeat.Location-checkSeat.InitialPosition) > 70))
        return false;
    else
    {
        player = DeusExPlayer(level.GetLocalPlayerController().pawn);
        if (player != None)
        {
            if (player.CarriedDecoration == checkSeat)
                return false;
        }
        return true;
    }
}

// ----------------------------------------------------------------------
// SetDistress()
// ----------------------------------------------------------------------
function SetDistress(bool bDistress)
{
    bDistressed = bDistress;
    if (bDistress && bEmitDistress)
        class'EventManager'.static.AIStartEvent(self, 'Distress', EAITYPE_Visual);
    else
        class'EventManager'.static.AIEndEvent(self,'Distress', EAITYPE_Visual);
}

// ----------------------------------------------------------------------
// SetDistressTimer()
// ----------------------------------------------------------------------
function SetDistressTimer()
{
    DistressTimer = 0;
}

// ----------------------------------------------------------------------
// GetCarcassData()
// ----------------------------------------------------------------------
function bool GetCarcassData(actor sender, out Name killer, out Name alliance,out Name CarcassName, optional bool bCheckName)
{
    local DeusExPlayer  dxPlayer;
    local DeusExCarcass carcass;
    local POVCorpse     corpseItem;
    local bool          bCares;
    local bool          bValid;

    alliance = '';
    killer   = '';

    bValid   = false;
    dxPlayer = DeusExPlayer(sender);
    carcass  = DeusExCarcass(sender);

    if (dxPlayer != None)
    {
        corpseItem = POVCorpse(dxPlayer.inHand);
        if (corpseItem != None)
        {
            if (corpseItem.bEmitCarcass)
            {
                alliance    = corpseItem.Alliance;
                killer      = corpseItem.KillerAlliance;
                CarcassName = corpseItem.CarcassName;
                bValid      = true;
            }
        }
    }
    else if (carcass != None)
    {
        if (carcass.bEmitCarcass)
        {
            alliance    = carcass.Alliance;
            killer      = carcass.KillerAlliance;
            CarcassName = carcass.CarcassName;
            bValid      = true;
        }
    }

    bCares = false;
    if (bValid && (!bCheckName || !HaveSeenCarcass(CarcassName)))
    {
        if (bFearCarcass)
            bCares = true;
        else
        {
            if (GetAllianceType(alliance) == ALLIANCE_Friendly)
            {
                if (bHateCarcass)
                    bCares = true;
                else if (bReactCarcass)
                {
                    if (GetAllianceType(killer) == ALLIANCE_Hostile)
                        bCares = true;
                }
            }
        }
    }

    return bCares;
}




// ----------------------------------------------------------------------
// ReactToFutz()
// ----------------------------------------------------------------------
function ReactToFutz()
{
    if (bLookingForFutz && bReactFutz && (FutzTimer <= 0) && !bDistressed)
    {
        FutzTimer = 2.0;
        PlayFutzSound();
    }
}



// ----------------------------------------------------------------------
// ReactToProjectiles()
// ----------------------------------------------------------------------
function ReactToProjectiles(Actor projectileActor)
{
    local DeusExProjectile dxProjectile;
    local Pawn             inst;

    if ((bFearProjectiles || bReactProjectiles) && bLookingForProjectiles)
    {
        dxProjectile = DeusExProjectile(projectileActor);
        if ((dxProjectile == None) || IsProjectileDangerous(dxProjectile))
        {
            inst = Pawn(projectileActor);
            if (inst == None)
                inst = projectileActor.Instigator;
            if (inst != None)
            {
                if (bFearProjectiles)
                    IncreaseFear(inst, 2.0);
                if (SetEnemy(DeusExPawn(inst)))
                {
                    SetDistressTimer();
                    HandleEnemy();
                }
                else if (bFearProjectiles && IsFearful())
                {
                    SetDistressTimer();
                    SetEnemy(inst, , true);
                    Controller.GotoState('Fleeing');
                }
                else if (bAvoidHarm)
                    Controller.SetState('AvoidingProjectiles');
            }
        }
    }
}

// ----------------------------------------------------------------------
// EnableShadow()
// ----------------------------------------------------------------------
function EnableShadow(bool bEnable)
{
/*  if (PawnShadow != None)
    {
        if (bEnable)
            PawnShadow.AttachProjector(0.5);//AttachDecal(32,vect(0.1,0.1,0));
        else
            PawnShadow.DetachProjector(true);//DetachDecal();
    }*/ // Should I disable shadow or destroy it?
}


// ----------------------------------------------------------------------
// CreateShadow()
// ----------------------------------------------------------------------
function CreateShadow()
{
/*  if(RealtimeShadow != none)
     return;

    if(bActorShadows && bPawnShadows && (Level.NetMode != NM_DedicatedServer))
    {
        RealtimeShadow = Spawn(class'Effect_ShadowController',self,'',Location);
        RealtimeShadow.Instigator = self;
        RealtimeShadow.Initialize();
    }*/
}


// ----------------------------------------------------------------------
// KillShadow()
// ----------------------------------------------------------------------
function KillShadow()
{
/*    if (PawnShadow != None)
    {
        PawnShadow.Destroy();
        PawnShadow = None;
    }*/
}



// ----------------------------------------------------------------------
// EnterWorld()
// ----------------------------------------------------------------------
function EnterWorld()
{
  PutInWorld(true);
}


// ----------------------------------------------------------------------
// LeaveWorld()
// ----------------------------------------------------------------------
function LeaveWorld()
{
  PutInWorld(false);
}


// ----------------------------------------------------------------------
// PutInWorld()
// ----------------------------------------------------------------------
function PutInWorld(bool bEnter)
{
  if (bInWorld && !bEnter)
  {
    bInWorld            = false;
    Controller.GotoState('Idle');
//       log("Not in world, controller state = "$Controller.GetStateName());
    bHidden             = true;
    bDetectable         = false;
//            bCanCommunicate     = false;  
    WorldPosition       = Location;
    bWorldCollideActors = bCollideActors;
    bWorldBlockActors   = bBlockActors;
    bWorldBlockPlayers  = bBlockPlayers;
    SetCollision(false, false, false);
    bCollideWorld       = false;
    SetPhysics(PHYS_None);

    KillShadow();
    SetLocation(Location+vect(0,0,20000));  // move it out of the way
//    Disable('Tick');  // DXR: New line
  }
  else if (!bInWorld && bEnter)
  {
//    Enable('Tick'); // DXR: New line
    bInWorld    = true;
    bHidden     = Default.bHidden;
    bDetectable = Default.bDetectable;
//            bCanCommunicate = Default.bCanCommunicate;
    SetLocation(WorldPosition);
    SetCollision(bWorldCollideActors, bWorldBlockActors, bWorldBlockPlayers);
    bCollideWorld = Default.bCollideWorld;
    SetMovementPhysics();
    CreateShadow();
    FollowOrders();
  }
}





// ----------------------------------------------------------------------
// MakePawnIgnored()
// ----------------------------------------------------------------------
function MakePawnIgnored(bool bNewIgnore)
{
    if (bNewIgnore)
    {
        bIgnore = bNewIgnore;
        // to restore original behavior, uncomment the next line
        //bDetectable = !bNewIgnore;
    }
    else
    {
        bIgnore = Default.bIgnore;
        // to restore original behavior, uncomment the next line
        //bDetectable = Default.bDetectable;
    }
}


// ----------------------------------------------------------------------
// EnableCollision() [for sitting state]
// ----------------------------------------------------------------------
function EnableCollision(bool bSet)
{
  EnableShadow(bSet);

  if (bSet)
    SetCollision(Default.bCollideActors, Default.bBlockActors, Default.bBlockPlayers);
  else
    SetCollision(True, False, True);
}

// ----------------------------------------------------------------------
// SetBasedPawnSize()
// ----------------------------------------------------------------------
function bool SetBasedPawnSize(float newRadius, float newHeight)
{
    local float  oldRadius, oldHeight;
    local bool   bSuccess;
    local vector centerDelta;
    local float  deltaEyeHeight;

    if (newRadius < 0)
        newRadius = 0;
    if (newHeight < 0)
        newHeight = 0;

    oldRadius = CollisionRadius;
    oldHeight = CollisionHeight;

    if ((oldRadius == newRadius) && (oldHeight == newHeight))
        return true;

    centerDelta    = vect(0, 0, 1)*(newHeight-oldHeight);
    deltaEyeHeight = GetDefaultCollisionHeight() - Default.BaseEyeHeight;

    bSuccess = false;
    if ((newHeight <= CollisionHeight) && (newRadius <= CollisionRadius))  // shrink
    {
        SetCollisionSize(newRadius, newHeight);
        if (Move(centerDelta))
            bSuccess = true;
        else
            SetCollisionSize(oldRadius, oldHeight);
    }
    else
    {
        if (Move(centerDelta))
        {
            SetCollisionSize(newRadius, newHeight);
            bSuccess = true;
        }
    }

    if (bSuccess)
    {
        PrePivotOffset  = vect(0, 0, 1)*(GetDefaultCollisionHeight()-newHeight);
        PrePivot        -= centerDelta;
        DesiredPrePivot -= centerDelta;
        BaseEyeHeight   = newHeight - deltaEyeHeight;
    }

    return (bSuccess);
}

// ----------------------------------------------------------------------
// ResetBasedPawnSize()
// ----------------------------------------------------------------------
function ResetBasedPawnSize()
{
  SetBasedPawnSize(Default.CollisionRadius, GetDefaultCollisionHeight());
}

function float GetDefaultCollisionHeight()
{
    return (Default.CollisionHeight-4.5);
}

function float GetSitHeight()
{
    return (GetDefaultCollisionHeight()+(BaseAssHeight*0.5));
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


event Attach(Actor other)
{
   SupportActor(other);
}

// ----------------------------------------------------------------------
// SupportActor()
//
// Modified from DeusExDecoration.uc
// Called when something lands on us
// ----------------------------------------------------------------------
function SupportActor(Actor standingActor)
{
    local vector newVelocity;
    local float  angle;
    local float  zVelocity;
    local float  baseMass;
    local float  standingMass;
    local vector damagePoint;
    local float  damage;

    if ((standingActor.IsA('Inventory')) || (standingActor.IsA('Powerups')) || (standingActor.IsA('InventoryAttachment')))
    return;

    standingMass = FMax(1, standingActor.Mass);
    baseMass     = FMax(1, Mass);
    if ((Physics == PHYS_Swimming) && PhysicsVolume.bWaterVolume)
    {
        newVelocity = standingActor.Velocity;
        newVelocity *= 0.5*standingMass/baseMass;
        AddVelocity(newVelocity);
    }
    else
    {
        zVelocity    = standingActor.Velocity.Z;
        damagePoint  = Location + vect(0,0,1)*(CollisionHeight-1);
        damage       = (1 - (standingMass/baseMass) * (zVelocity/100));

        // Have we been stomped?
        if ((zVelocity*standingMass < -7500) && (damage > 0) && WillTakeStompDamage(standingActor))
            TakeDamage(damage, standingActor.Instigator, damagePoint, 0.2*standingActor.Velocity, class'DM_stomped');
    }

    // Bounce the actor off the pawn
    angle = FRand()*Pi*2;
    newVelocity.X = cos(angle);
    newVelocity.Y = sin(angle);
    newVelocity.Z = 0;
    newVelocity *= FRand()*25 + 25;
    newVelocity += standingActor.Velocity;
    newVelocity.Z = 50;
    standingActor.Velocity = newVelocity;
    standingActor.SetPhysics(PHYS_Falling);
}




// ----------------------------------------------------------------------
// FindOrderActor()
// ----------------------------------------------------------------------
function FindOrderActor()
{
    if (Orders == 'Attacking')
        OrderActor = FindTaggedActor(OrderTag, true, Class'Pawn');
    else
        OrderActor = FindTaggedActor(OrderTag);
}

/* ToDo: Это может быть полезно! */
function bool PlayBeginAttack()
{
    return false;
}

// ----------------------------------------------------------------------
// FindTaggedActor()
// ----------------------------------------------------------------------
function Actor FindTaggedActor(Name actorTag, optional bool bRandom, optional Class<Actor> tagClass)
{
    local float dist;
    local float bestDist;
    local actor bestActor;
    local actor tempActor;

    bestActor = None;
    bestDist  = 1000000;

    if (tagClass == None)
        tagClass = Class'Actor';

    // if no tag, then assume the player is the target
    if (actorTag == '')
        bestActor = GetPlayerPawn();
    else
    {
        foreach AllActors(tagClass, tempActor, actorTag)
        {
            if (tempActor != self)
            {
                dist = VSize(tempActor.Location - Location);
                if (bRandom)
                    dist *= FRand()*0.6+0.7;  // +/- 30%
                if ((bestActor == None) || (dist < bestDist))
                {
                    bestActor = tempActor;
                    bestDist  = dist;
                }
            }
        }
    }
    return bestActor;
}

// ----------------------------------------------------------------------
// FollowOrders()
// ----------------------------------------------------------------------
function FollowOrders(optional bool bDefer)
{
  DXRAiController(Controller).FollowOrders(bDefer);
}

// ----------------------------------------------------------------------
// ResetConvOrders()
// ----------------------------------------------------------------------
function ResetConvOrders()
{
    ConvOrders   = '';
    ConvOrderTag = '';
}


// ----------------------------------------------------------------------
// GenerateTotalHealth()
//
// this will calculate a weighted average of all of the body parts
// and put that value in the generic Health
// NOTE: head and torso are both critical
// ----------------------------------------------------------------------
function GenerateTotalHealth()
{
    local float limbDamage, headDamage, torsoDamage;

    if (!bInvincible)
    {
        // Scoring works as follows:
        // Disabling the head (100 points damage) will kill you.
        // Disabling the torso (100 points damage) will kill you.
        // Disabling 2 1/2 limbs (250 points damage) will kill you.
        // Combinations can also do you in -- 50 points damage to the head
        // and 125 points damage to the limbs, for example.

        // Note that this formula can produce numbers less than zero, so we'll clamp our
        // health value...

        // Compute total limb damage
        limbDamage  = 0;
        if (Default.HealthLegLeft > 0)
            limbDamage += float(Default.HealthLegLeft-HealthLegLeft)/Default.HealthLegLeft;
        if (Default.HealthLegRight > 0)
            limbDamage += float(Default.HealthLegRight-HealthLegRight)/Default.HealthLegRight;
        if (Default.HealthArmLeft > 0)
            limbDamage += float(Default.HealthArmLeft-HealthArmLeft)/Default.HealthArmLeft;
        if (Default.HealthArmRight > 0)
            limbDamage += float(Default.HealthArmRight-HealthArmRight)/Default.HealthArmRight;
        limbDamage *= 0.4;  // 2 1/2 limbs disabled == death

        // Compute total head damage
        headDamage  = 0;
        if (Default.HealthHead > 0)
            headDamage  = float(Default.HealthHead-HealthHead)/Default.HealthHead;

        // Compute total torso damage
        torsoDamage = 0;
        if (Default.HealthTorso > 0)
            torsoDamage = float(Default.HealthTorso-HealthTorso)/Default.HealthTorso;

        // Compute total health, relative to original health level
        Health = FClamp(Default.Health - ((limbDamage+headDamage+torsoDamage)*Default.Health), 0.0, Default.Health);
    }
    else
    {
        // Pawn is invincible - reset health to defaults
        HealthHead     = Default.HealthHead;
        HealthTorso    = Default.HealthTorso;
        HealthArmLeft  = Default.HealthArmLeft;
        HealthArmRight = Default.HealthArmRight;
        HealthLegLeft  = Default.HealthLegLeft;
        HealthLegRight = Default.HealthLegRight;
        Health         = Default.Health;
    }
}




// ----------------------------------------------------------------------
// UpdatePoison()
// ----------------------------------------------------------------------
function UpdatePoison(float deltaTime)
{
    if ((Health <= 0) || bDeleteMe)  // no more pain -- you're already dead!
        return;

    if (poisonCounter > 0)
    {
        poisonTimer += deltaTime;
        if (poisonTimer >= 2.0)  // pain every two seconds
        {
            poisonTimer = 0;
            poisonCounter--;
            TakeDamage(poisonDamage, Poisoner, Location, vect(0,0,0), class'DM_PoisonEffect');
        }
        if ((poisonCounter <= 0) || (Health <= 0) || bDeleteMe)
            StopPoison();
    }
}


// ----------------------------------------------------------------------
// StartPoison()
// ----------------------------------------------------------------------
function StartPoison(int Damage, Pawn newPoisoner)
{
    if ((Health <= 0) || bDeleteMe)  // no more pain -- you're already dead!
        return;

    poisonCounter = 8;    // take damage no more than eight times (over 16 seconds)
    poisonTimer   = 0;    // reset pain timer
    Poisoner      = newPoisoner;
    if (poisonDamage < Damage)  // set damage amount
        poisonDamage = Damage;
}


// ----------------------------------------------------------------------
// StopPoison()
// ----------------------------------------------------------------------
function StopPoison()
{
    poisonCounter = 0;
    poisonTimer   = 0;
    poisonDamage  = 0;
    Poisoner      = None;
}

// ----------------------------------------------------------------------
// HasEnemyTimedOut()
// ----------------------------------------------------------------------
function bool HasEnemyTimedOut()
{
    if (EnemyTimeout > 0)
    {
        if (EnemyLastSeen > EnemyTimeout)
            return true;
        else
            return false;
    }
    else
        return false;
}

// ----------------------------------------------------------------------
// UpdateActorVisibility()
// ----------------------------------------------------------------------
function UpdateActorVisibility(actor seeActor, float deltaSeconds, float checkTime, bool bCheckDir)
{
    local bool bCanSee;

    CheckPeriod += deltaSeconds;
    if (CheckPeriod >= checkTime)
    {
        CheckPeriod = 0.0;
        if (seeActor != None)
            bCanSee = (AICanSee(seeActor, ComputeActorVisibility(seeActor), false, bCheckDir, true, true) > 0);
        else
            bCanSee = false;
        if (bCanSee)
            EnemyLastSeen = 0;
        else if (EnemyLastSeen <= 0)
            EnemyLastSeen = 0.01;
    }
    if (EnemyLastSeen > 0)
        EnemyLastSeen += deltaSeconds;
}




// ----------------------------------------------------------------------
// ComputeActorVisibility()
// ----------------------------------------------------------------------
function float ComputeActorVisibility(actor seeActor)
{
    local float AVisibility;

    if (seeActor.IsA('DeusExPlayer'))
        AVisibility = DeusExPlayer(seeActor).CalculatePlayerVisibility(self);
    else
        AVisibility = 1.0;

    return (AVisibility);
}

// ----------------------------------------------------------------------
// UpdateReactionLevel() [internal use only]
// ----------------------------------------------------------------------
function UpdateReactionLevel(bool bRise, float deltaSeconds)
{
    local float surpriseTime;

    // Handle surprise levels...
    if (bRise)
    {
        if (ReactionLevel < 1.0)
        {
            surpriseTime = SurprisePeriod;
            if (surpriseTime <= 0)
                surpriseTime = 0.00000001;
            ReactionLevel += deltaSeconds/surpriseTime;
            if (ReactionLevel > 1.0)
                ReactionLevel = 1.0;
        }
    }
    else
    {
        if (ReactionLevel > 0.0)
        {
            surpriseTime = 7.0;
            ReactionLevel -= deltaSeconds/surpriseTime;
            if (ReactionLevel <= 0.0)
                ReactionLevel = 0.0;
        }
    }
}



// ----------------------------------------------------------------------
// CheckCycle() [internal use only]
// ----------------------------------------------------------------------
final function DeusExPawn CheckCycle()
{
    local float attackPeriod;
    local float maxAttackPeriod;
    local float sustainPeriod;
    local float decayPeriod;
    local float minCutoff;
    local DeusExPawn  cycleEnemy;

    attackPeriod    = 0.5;
    maxAttackPeriod = 4.5;
    sustainPeriod   = 3.0;
    decayPeriod     = 4.0;

    minCutoff = attackPeriod/maxAttackPeriod;

    cycleEnemy = None;

    if (CycleCumulative <= 0)  // no enemies seen during this cycle
    {
        CycleTimer -= CyclePeriod;
        if (CycleTimer <= 0)
        {
            CycleTimer = 0;
            EnemyReadiness -= CyclePeriod/decayPeriod;
            if (EnemyReadiness < 0)
                EnemyReadiness = 0;
        }
    }
    else  // I saw somebody!
    {
        CycleTimer = sustainPeriod;
        CycleCumulative *= 2;  // hack
        if (CycleCumulative < minCutoff)
            CycleCumulative = minCutoff;
        else if (CycleCumulative > 1.0)
            CycleCumulative = 1.0;
        EnemyReadiness += CycleCumulative*CyclePeriod/attackPeriod;
        if (EnemyReadiness >= 1.0)
        {
            EnemyReadiness = 1.0;
            if (IsValidEnemy(DeusExPawn(CycleCandidate)))
                cycleEnemy = DeusExPawn(CycleCandidate);
        }
        else if (EnemyReadiness >= SightPercentage)
            if (IsValidEnemy(DeusExPawn(CycleCandidate)))
                DXRAiController(Controller).HandleSighting(DeusExPawn(CycleCandidate));
    }
    CycleCumulative = 0;
    CyclePeriod     = 0;
    CycleCandidate  = None;
    CycleDistance   = 0;

    return (cycleEnemy);

}

// Проверить наличие света, исходящего от игрока.
function/* bool*/ CheckBeamPresence(float deltaSeconds)
{
    local DeusExPlayer player;
    local Beam         beamActor;
    local bool         bReactToBeam;

    if (bReactPresence && bLookingForEnemy && (BeamCheckTimer <= 0) && (LastRendered() < 5.0))
    {
        BeamCheckTimer = 1.0;
        player = DeusExPlayer(GetPlayerPawn());
        if (player != None)
        {
            bReactToBeam = false;
            if (IsValidEnemy(player))
            {
                foreach RadiusActors(class'Beam', beamActor, BEAM_CHECK_RADIUS)
                {
                    if ((beamActor.Owner == player) && (beamActor.LightType != LT_None) && (beamActor.LightBrightness > 32))
                    {
                        if (VSize(beamActor.Location - Location) < (beamActor.LightRadius+1)*25)
                            bReactToBeam = true;
                        else
                        {
                            if (AICanSee(beamActor, , false, true, false, false) > 0)
                            {
                                if (FastTrace(beamActor.Location, Location+vect(0,0,1)*BaseEyeHeight))
                                    bReactToBeam = true;
                            }
                        }
                    }
                    if (bReactToBeam)
                        break;
                }
            }
            if (bReactToBeam)
                DXRAiController(Controller).HandleSighting(player);
        }
    }
}


// ----------------------------------------------------------------------
// CheckCarcassPresence()
// Проверяет наличие трупов
// ----------------------------------------------------------------------
function CheckCarcassPresence(float deltaSeconds)
{
    local Actor         carcass;
    local Name          CarcassName;
    local int           lastCycle;
    local DeusExCarcass body;
    local DeusExPlayer  player;
    local float         aVisibility;
    local Name          KillerAlliance;
    local Name          killedAlliance;
    local DeusExPawn    killer;
    local DeusExPawn    bestKiller;
    local float         dist;
    local float         bestDist;
//    local float         maxCarcassDist;
    local int           maxCarcassCount;

    if (bFearCarcass && !bHateCarcass && !bReactCarcass)  // Major hack!
        maxCarcassCount = 1;
    else
        maxCarcassCount = ArrayCount(Carcasses);

    //if ((bHateCarcass || bReactCarcass || bFearCarcass) && bLookingForCarcass && (CarcassTimer <= 0))
    if ((bHateCarcass || bReactCarcass || bFearCarcass) && (NumCarcasses < maxCarcassCount))
    {
//        maxCarcassDist = 1200;
        if (CarcassCheckTimer <= 0)
        {
            CarcassCheckTimer = 0.1;
            carcass           = None;
            lastCycle         = BodyIndex;
            foreach CycleActors(Class'DeusExCarcass', body, BodyIndex)
            {
                if (body.Physics != PHYS_Falling)
                {
                    if (VSize(body.Location-Location) < MAX_CARCASS_DIST /*maxCarcassDist*/)
                    {
                        if (GetCarcassData(body, KillerAlliance, killedAlliance, CarcassName, true))
                        {
                            aVisibility = AICanSee(body, ComputeActorVisibility(body), true, true, true, true);
                            if (aVisibility > 0)
                                carcass = body;
                            break;
                        }
                    }
                }
            }
            if (lastCycle >= BodyIndex)
            {
                if (carcass == None)
                {
                    player = DeusExPlayer(GetPlayerPawn());
                    if (player != None)
                    {
                        if (VSize(player.Location-Location) < MAX_CARCASS_DIST /*maxCarcassDist*/)
                        {
                            if (GetCarcassData(player, KillerAlliance, killedAlliance, CarcassName, true))
                            {
                                aVisibility = AICanSee(player, ComputeActorVisibility(player), true, true, true, true);
                                if (aVisibility > 0)
                                    carcass = player;
                            }
                        }
                    }
                }
            }
            if (carcass != None)
            {
                CarcassTimer = 120;
                AddCarcass(CarcassName);
                if (bLookingForCarcass)
                {
                    if (KillerAlliance == 'Player')
                        killer = DeusExPlayer(GetPlayerPawn());
                    else
                    {
                        bestKiller = None;
                        bestDist   = 0;
                        foreach AllActors(Class'DeusExPawn', killer)  // hack
                        {
                            if (killer.Alliance == KillerAlliance)
                            {
                                dist = VSize(killer.Location - Location);
                                if ((bestKiller == None) || (bestDist > dist))
                                {
                                    bestKiller = killer;
                                    bestDist   = dist;
                                }
                            }
                        }
                        killer = bestKiller;
                    }
                    if (bHateCarcass)
                    {
                        PotentialEnemyAlliance = KillerAlliance;
                        PotentialEnemyTimer    = 15.0;
                        bNoNegativeAlliances   = false;
                    }
                    if (bFearCarcass)
                        IncreaseFear(killer, 2.0);

                    if (bFearCarcass && IsFearful() && !IsValidEnemy(killer))
                    {
                        SetDistressTimer();
                        SetEnemy(killer, , true);
                        Controller.GotoState('Fleeing');
                    }
                    else
                    {
                        SetDistressTimer();
                        DXRAiController(Controller).SetSeekLocation(killer, carcass.Location, SEEKTYPE_Carcass);
                        HandleEnemy();
                    }
                }
            }
        }
    }
}




// ----------------------------------------------------------------------
// AddProjectileToList()
// ----------------------------------------------------------------------
function AddProjectileToList(out NearbyProjectileList projList,DeusExProjectile proj, vector projPos,float dist, float range)
{
    local int   pos;
    local int   bestPos;
    local float worstDist;

    bestPos   = -1;
    worstDist = dist;
    pos       = 0;
    while (pos < ArrayCount(projList.list))
    {
        if (projList.list[pos].projectile == None)
        {
            bestPos = pos;
            break;  // short-circuit loop
        }
        else
        {
            if (worstDist < projList.list[pos].dist)
            {
                worstDist = projList.list[pos].dist;
                bestPos   = pos;
            }
        }

        pos++;
    }

    if (bestPos >= 0)
    {
        projList.list[bestPos].projectile = proj;
        projList.list[bestPos].location   = projPos;
        projList.list[bestPos].dist       = dist;
        projList.list[bestPos].range      = range;
    }
}

// ----------------------------------------------------------------------
// IsProjectileDangerous()
// ----------------------------------------------------------------------
function bool IsProjectileDangerous(DeusExProjectile projectile)
{
    local bool bEvil;

    if (projectile.IsA('Cloud'))
        bEvil = true;
    else if (projectile.IsA('ThrownProjectile'))
    {
        if (projectile.IsA('SpyDrone')) // DXR: Наверное SpyDrone (было SpyBot)?
            bEvil = false;
        else if ((ThrownProjectile(projectile) != None) && (ThrownProjectile(projectile).bProximityTriggered))
            bEvil = false;
        else
            bEvil = true;
    }
    else
        bEvil = false;

    return (bEvil);
}



// ----------------------------------------------------------------------
// GetProjectileList()
// ----------------------------------------------------------------------
function int GetProjectileList(out NearbyProjectileList projList, vector Location)
{
    local float            dist;
    local int              count;
    local DeusExProjectile curProj;
    local ThrownProjectile throwProj;
    local Cloud            cloudProj;
    local vector           HitNormal, HitLocation;
    local vector           extent;
    local vector           traceEnd;
    local Actor            hitActor;
    local float            range;
    local vector           pos;
    local float            time;
    local float            maxTime;
    local float            elasticity;
    local int              i;
    local bool             bValid;

    for (i=0; i<ArrayCount(projList.list); i++)
        projList.list[i].projectile = None;
    projList.center = Location;

    maxTime = 2.0;
    foreach RadiusActors(Class'DeusExProjectile', curProj, 1000)
    {
        if (IsProjectileDangerous(curProj))
        {
            throwProj = ThrownProjectile(curProj);
            cloudProj = Cloud(curProj);
            extent   = vect(1,1,0)*curProj.CollisionRadius;
            extent.Z = curProj.CollisionHeight;

            range    = VSize(extent);
            if (curProj.bExplodes)
                if (range < curProj.blastRadius)
                    range = curProj.blastRadius;
            if (cloudProj != None)
                if (range < cloudProj.cloudRadius)
                    range = cloudProj.cloudRadius;
            range += CollisionRadius+60;

            if (throwProj != None)
                elasticity = throwProj.Elasticity;
            else
                elasticity = 0.2;

            bValid = true;
            if (throwProj != None)
                if (throwProj.bProximityTriggered)  // HACK!!!
                    bValid = false;

            if (((curProj.Physics == PHYS_Falling) || (curProj.Physics == PHYS_Projectile) || (curProj.Physics == PHYS_None)) && bValid)
            {
                pos = curProj.Location;
                dist = VSize(Location - curProj.Location);
                AddProjectileToList(projList, curProj, pos, dist, range);
                if (curProj.Physics == PHYS_Projectile)
                {
                    traceEnd = curProj.Location + curProj.Velocity*maxTime;
                    hitActor = Trace(HitLocation, HitNormal, traceEnd, curProj.Location, true, extent);
                    if (hitActor == None)
                        pos = traceEnd;
                    else
                        pos = HitLocation;
                    dist = VSize(Location - pos);
                    AddProjectileToList(projList, curProj, pos, dist, range);
                }
                else if (curProj.Physics == PHYS_Falling)
                {
                    time = ParabolicTrace(pos, curProj.Velocity, curProj.Location, true, extent, maxTime, elasticity, curProj.bBounce, 60);
                    if (time > 0)
                    {
                        dist = VSize(Location - pos);
                        AddProjectileToList(projList, curProj, pos, dist, range);
                    }
                }
            }
        }
    }

    count = 0;
    for (i=0; i<ArrayCount(projList.list); i++)
        if (projList.list[i].projectile != None)
            count++;

    return (count);

}



// ----------------------------------------------------------------------
// IsLocationDangerous()
// ----------------------------------------------------------------------
function bool IsLocationDangerous(NearbyProjectileList projList,vector Location)
{
    local bool  bDanger;
    local int   i;
    local float dist;

    bDanger = false;
    for (i=0; i<ArrayCount(projList.list); i++)
    {
        if (projList.list[i].projectile == None)
            break;
        if (projList.center == Location)
            dist = projList.list[i].dist;
        else
            dist = VSize(projList.list[i].location - Location);
        if (dist < projList.list[i].range)
        {
            bDanger = true;
            break;
        }
    }

    return (bDanger);

}




// ----------------------------------------------------------------------
// ComputeAwayVector()
// ----------------------------------------------------------------------
function vector ComputeAwayVector(NearbyProjectileList projList)
{
    local vector          awayVect;
    local vector          tempVect;
    local rotator         tempRot;
    local int             i;
//    local float           dist;
    local int             yaw;
//    local int             absYaw;
//    local int             bestYaw;
//    local NavigationPoint navPoint;
    local NavigationPoint bestPoint;
    local float           segmentDist;

    segmentDist = GroundSpeed*0.5;

    awayVect = vect(0, 0, 0);
    for (i=0; i<ArrayCount(projList.list); i++)
    {
        if ((projList.list[i].projectile != None) &&
            (projList.list[i].dist < projList.list[i].range))
        {
            tempVect = projList.list[i].location - projList.center;
            if (projList.list[i].dist > 0)
                tempVect /= projList.list[i].dist;
            else
                tempVect = VRand();
            awayVect -= tempVect;
        }
    }

    if (awayVect != vect(0, 0, 0))
    {
        awayVect += Normal(Velocity*vect(1,1,0))*0.9;  // bias to direction already running
        yaw = Rotator(awayVect).Yaw;
        bestPoint = controller.FindRandomDest(); //None;
        /*foreach ReachableNavPoints(Class'NavigationPoint', navPoint, None, dist)
        {

            tempRot = Rotator(navPoint.Location - Location);
            absYaw = (tempRot.Yaw - Yaw) & 65535;
            if (absYaw > 32767)
                absYaw -= 65536;
            absYaw = Abs(absYaw);
            if ((bestPoint == None) || (bestYaw > absYaw))
            {
                bestPoint = navPoint;
                bestYaw = absYaw;
            }
        }*/
        if (bestPoint != None)
            awayVect = bestPoint.Location-Location;
        else
        {
            tempRot = Rotator(awayVect);
            tempRot.Pitch += Rand(7282)-3641;   // +/- 20 degrees
            tempRot.Yaw   += Rand(7282)-3641;   // +/- 20 degrees
            awayVect = Vector(tempRot)*segmentDist;
        }
    }
    else
        awayVect = VRand()*segmentDist;

    return (awayVect);

}




// ----------------------------------------------------------------------
// SetupWeapon()
// ----------------------------------------------------------------------
function SetupWeapon(bool bDrawWeapon, optional bool bForce)
{
    if (bKeepWeaponDrawn && !bForce)
        bDrawWeapon = true;

    if (ShouldDropWeapon())
        DropWeapon();
    else if (bDrawWeapon)
    {
        SwitchToBestWeapon();
    }
    else
        SetWeapon(None);
}

// ----------------------------------------------------------------------
// DropWeapon()
// ----------------------------------------------------------------------
function DropWeapon()
{
    local DeusExWeapon dxWeapon;
    local Weapon       oldWeapon;

    if (Weapon != None)
    {
        dxWeapon = DeusExWeapon(Weapon);
        if ((dxWeapon == None) || !dxWeapon.bNativeAttack)
        {
            oldWeapon = Weapon;
            SetWeapon(None);
            oldWeapon.DropFrom(Location);
        }
    }
}

function SwitchWeapon(byte F);
// ----------------------------------------------------------------------
// SetWeapon()
// ----------------------------------------------------------------------

function SetWeapon(Weapon newWeapon)
{
    if (Weapon == newWeapon)
    {
        if (Weapon != None)
        {
            if (Weapon.IsInState('DownWeapon'))
                Weapon.BringUp();

                  Weapon.AttachToPawn(self); // Attach to bone
            Weapon.SetDefaultDisplayProperties();
        }
        if (Inventory != None)
            Inventory.ChangedWeapon();
        PendingWeapon = None;
        return;
    }

    PlayWeaponSwitch(newWeapon);
    if (Weapon != None)
    {
        Weapon.SetDefaultDisplayProperties();
        Weapon.PutDown();
    }

    Weapon = newWeapon;

    if (Inventory != None)
        Inventory.ChangedWeapon();
    if (Weapon != None)
        Weapon.BringUp();

    PendingWeapon = None;
}


function IncreaseFear(Actor actorInstigator, float addedFearLevel, optional float newFearTimer)
{
    local DeusExPawn inst;

    inst = InstigatorToPawn(actorInstigator);
    if (inst != None)
    {
        if (FearTimer < (FearSustainTime-newFearTimer))
            FearTimer = FearSustainTime-newFearTimer;
        if (FearTimer > 0)
        {
            if (addedFearLevel > 0)
            {
                FearLevel += addedFearLevel;
                if (FearLevel > 1.0)
                    FearLevel = 1.0;
            }
        }
    }
}

function IncreaseAgitation(Actor actorInstigator, optional float AgitationLevel)
{
    local DeusExPawn inst;
//  local float minLevel;

    inst = InstigatorToPawn(actorInstigator);
    if (inst != None)
    {
        AgitationTimer = AgitationSustainTime;
        if (AgitationCheckTimer <= 0)
        {
            AgitationCheckTimer = 1.5;  // hardcoded for now
            if (AgitationLevel == 0)
            {
                if (MaxProvocations < 0)
                    MaxProvocations = 0;
                AgitationLevel = 1.0/(MaxProvocations+1);
            }
            if (AgitationLevel > 0)
            {
                bAlliancesChanged    = True;
                bNoNegativeAlliances = False;
                AgitateAlliance(inst.Alliance, AgitationLevel);
            }
        }
    }
}

function DecreaseAgitation(Actor actorInstigator, float AgitationLevel)
{
//  local float        newLevel;
    local DeusExPlayer player;
    local DeusExPawn      inst;

    player = DeusExPlayer(GetPlayerPawn());

    if (Inventory(actorInstigator) != None)
    {
        if (Inventory(actorInstigator).Owner != None)
            actorInstigator = Inventory(actorInstigator).Owner;
    }
    else if (DeusExDecoration(actorInstigator) != None)
        actorInstigator = player;

    instigator = DeusExPawn(actorInstigator);
    if ((instigator == None) || (instigator == self))
        return;

    AgitationTimer  = AgitationSustainTime;
    if (AgitationLevel > 0)
    {
        bAlliancesChanged    = True;
        bNoNegativeAlliances = False;
        AgitateAlliance(inst.Alliance, -AgitationLevel);
    }
}

function DeusExPawn InstigatorToPawn(Actor eventActor)
{
    local DeusExPawn pawnActor;

    if (Inventory(eventActor) != None)
    {
        if (Inventory(eventActor).Owner != None)
            eventActor = Inventory(eventActor).Owner;
    }
    else if (DeusExDecoration(eventActor) != None)
        eventActor = GetPlayerPawn();
    else if (DeusExProjectile(eventActor) != None)
        eventActor = eventActor.Instigator;

    pawnActor = DeusExPawn(eventActor);
    if (pawnActor == self)
        pawnActor = None;

//        log(self@" << InstigatorToPawn returns >> "@pawnActor);
    return pawnActor;
}




// ----------------------------------------------------------------------
// ReactToInjury()
// ----------------------------------------------------------------------
// Moved to DXRAIController //


// ----------------------------------------------------------------------
// TakeHit()
// ----------------------------------------------------------------------
function TakeHit(EHitLocation hitPos)
{
    if (hitPos != HITLOC_None)
    {
        PlayTakingHit(hitPos);
        controller.GotoState('TakingHit');
    }
    else
        DXRAiController(controller).GotoNextState();
}




// ----------------------------------------------------------------------
// ComputeFallDirection()
// ----------------------------------------------------------------------
function ComputeFallDirection(float totalTime, int numFrames, out vector moveDir, out float stopTime)
{
    // Determine direction, and how long to slide
    if (GetAnimSequence() == 'DeathFront')
    {
        moveDir = Vector(DesiredRotation) * Default.CollisionRadius*0.75;
        if (numFrames > 5)
            stopTime = totalTime * ((numFrames-5)/float(numFrames));
        else
            stopTime = totalTime * 0.5;
    }
    else if (GetAnimSequence() == 'DeathBack')
    {
        moveDir = -Vector(DesiredRotation) * Default.CollisionRadius*0.75;
        if (numFrames > 5)
            stopTime = totalTime * ((numFrames-5)/float(numFrames));
        else
            stopTime = totalTime * 0.9;
    }
}


function bool IsFearful()
{
    if (FearLevel >= 1.0)
        return true;
    else
        return false;
}

// ----------------------------------------------------------------------
// WillTakeStompDamage()
// ----------------------------------------------------------------------
function bool WillTakeStompDamage(Actor stomper)
{
    return true;
}

// ----------------------------------------------------------------------
// DrawShield()
// ----------------------------------------------------------------------
function DrawShield()
{
    local EllipseEffect shield;

    shield = Spawn(class'EllipseEffect', Self,, Location, Rotation);
    if (shield != None)
        shield.SetBase(Self);
}

function bool IsOverlapping(Actor CheckActor)
{
  return class'ActorManager'.static.IsOverlapping(self, CheckActor);
}


// ----------------------------------------------------------------------
// StandUp()
// ----------------------------------------------------------------------
function StandUp(optional bool bInstant)
{
  if (bSitting)
  {
    bSitInterpolation = false;
    bSitting          = false;

    EnableCollision(true);
    SetBase(None);
    SetPhysics(PHYS_Falling);
    ResetBasedPawnSize();

    if (!bInstant && (SeatActor != None) && IsOverlapping(SeatActor))
    {
      bStandInterpolation = true;
      remainingStandTime  = 0.3;
      StandRate = (Vector(SeatActor.Rotation+Rot(0, -16384, 0))*CollisionRadius) / remainingStandTime;
    }
    else
      StopStanding();
  }

  if (SeatActor != None)
  {
    if (SeatActor.sittingActor[seatSlot] == self)
      SeatActor.sittingActor[seatSlot] = None;
    SeatActor = None;
  }

  if (bDancing)
    bDancing = false;
}

function Carcass SpawnCarcass()
{
    local DeusExCarcass carc;
    local vector loc;
    local Inventory item, nextItem;
    local FleshFragment chunk;
    local int i;
    local float size;

    // if we really got blown up good, gib us and don't display a carcass
    if ((Health < GIB_HEALTH) && !IsA('Robot'))
    {
        size = (CollisionRadius + CollisionHeight) / 2;
        if (size > 10.0)
        {
            for (i=0; i<size/4.0; i++)
            {
                loc.X = (1-2*FRand()) * CollisionRadius;
                loc.Y = (1-2*FRand()) * CollisionRadius;
                loc.Z = (1-2*FRand()) * CollisionHeight;
                loc += Location;
                chunk = spawn(class'FleshFragment', None,, loc);
                if (chunk != None)
                {
                    chunk.SetDrawScale(size / 25);
                    chunk.SetCollisionSize(chunk.CollisionRadius / chunk.DrawScale, chunk.CollisionHeight / chunk.DrawScale);
                    chunk.bFixedRotationDir = True;
                    chunk.RotationRate = RotRand(False);
                }
            }
        }

        return None;
    }

    // spawn the carcass
    carc = DeusExCarcass(Spawn(CarcassType));

    if ( carc != None )
    {
        if (bStunned)
            carc.bNotDead = True;

        carc.Initfor(self);

        // move it down to the floor
        loc = Location;
        loc.z -= Default.CollisionHeight;
        loc.z += carc.Default.CollisionHeight;
        carc.SetLocation(loc);
        carc.Velocity = Velocity;
        carc.Acceleration = Acceleration;

//        log(self$" Inventory = "$Inventory);

        // give the carcass the pawn's inventory if we aren't an animal or robot
        if (!IsA('Animal') && !IsA('Robot'))
        {
            if (Inventory != None)
            {
                do
                {
                    item = Inventory;
                    nextItem = item.Inventory;
                    DeleteInventory(item);
                    if ((DeusExWeapon(item) != None) && (DeusExWeapon(item).bNativeAttack))
                        item.Destroy();
                    else
                        carc.AddInventory(item);
                    item = nextItem;
                }
                until (item == None);
            }
        }
    }

    return carc;
}



// ----------------------------------------------------------------------
// FilterDamageType()
// ----------------------------------------------------------------------
function bool FilterDamageType(Pawn instigatedBy, Vector hitLocation, Vector offset, class<DamageType> damageType)
{
    // Special cases for certain damage types
    if (damageType == class'DM_HalonGas')
        if (bOnFire)
            ExtinguishFire();

    if (damageType == class'DM_EMP')
    {
        CloakEMPTimer += 10;  // hack - replace with skill-based value
        if (CloakEMPTimer > 20)
            CloakEMPTimer = 20;
        EnableCloak(bCloakOn);
        return false;
    }
    return true;
}

// ----------------------------------------------------------------------
// ModifyDamage()
// ----------------------------------------------------------------------
function float ModifyDamage(int Damage, Pawn instigatedBy, Vector hitLocation, Vector offset, class <damageType> damageType, vector Momentum)
{
    local int   actualDamage;
    local float headOffsetZ, headOffsetY, armOffset;

    actualDamage = Damage;

    // calculate our hit extents
    headOffsetZ = CollisionHeight * 0.7;
    headOffsetY = CollisionRadius * 0.3;
    armOffset   = CollisionRadius * 0.35;

    // if the pawn is stunned, damage is 4X
    if (bStunned)
        actualDamage *= 4;

    // if the pawn is hit from behind at point-blank range, he is killed instantly
    else if (offset.x < 0)
        if ((instigatedBy != None) && (VSize(instigatedBy.Location - Location) < 64))
            actualDamage  *= 10;
    //function int ReduceDamage( int Damage, pawn injured, pawn instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType )
    actualDamage = Level.Game.ReduceDamage(actualDamage, self, instigatedBy, HitLocation, Momentum, DamageType);
//                               Level.Game.ReduceDamage(actualDamage, DamageType, self, instigatedBy);

    if (bInvincible) //ReducedDamageType == 'All') //God mode
        actualDamage = 0;
//  else if (Inventory != None) //then check if carrying armor
//      actualDamage = Inventory.ReduceDamage(actualDamage, DamageType, HitLocation);

    // gas, EMP and nanovirus do no damage
    if (damageType == class'DM_TearGas' || damageType == class'DM_EMP' || damageType == class'DM_NanoVirus')
        actualDamage = 0;

    return actualDamage;
}



// ----------------------------------------------------------------------
// ShieldDamage()
// ----------------------------------------------------------------------
function float ShieldDamage(class <damageType> damageType)
{
    return 1.0;
}

// ----------------------------------------------------------------------
// ImpartMomentum()
// ----------------------------------------------------------------------
function ImpartMomentum(Vector momentum, Pawn instigatedBy)
{
    if (Physics == PHYS_None)
        SetMovementPhysics();
    if (Physics == PHYS_Walking)
        momentum.Z = 0.4 * VSize(momentum);
    if ( instigatedBy == self )
        momentum *= 0.6;
    momentum = momentum/Mass;
    AddVelocity(momentum);
}

// ----------------------------------------------------------------------
// AddVelocity()
// ----------------------------------------------------------------------
function AddVelocity(Vector momentum)
{
    if (VSize(momentum) > 0.001)
        Super.AddVelocity(momentum);
}


// ----------------------------------------------------------------------
// CanShowPain()
// ----------------------------------------------------------------------
function bool CanShowPain()
{
    if (bShowPain && (TakeHitTimer <= 0))
        return true;
    else
        return false;
}


// ----------------------------------------------------------------------
// IsPrimaryDamageType()
// ----------------------------------------------------------------------
function bool IsPrimaryDamageType(class<DamageType> damageType)
{
    local bool bPrimary;

    switch (damageType)
    {
        case class'DM_Exploded':
        case class'DM_TearGas':
        case class'DM_HalonGas':
        case class'DM_PoisonGas':
        case class'DM_PoisonEffect':
        case class'DM_Radiation':
        case class'DM_EMP':
        case class'DM_Drowned':
        case class'DM_NanoVirus':
            bPrimary = false;
            break;

        case class'DM_Stunned':
        case class'DM_KnockedOut':
        case class'DM_Burned':
        case class'DM_Flamed':
        case class'DM_Poison':
        case class'DM_Shot':
        case class'DM_Sabot':
        default:
            bPrimary = true;
            break;
    }
    return (bPrimary);
}




// ----------------------------------------------------------------------
// ShouldReactToInjuryType()
// ----------------------------------------------------------------------
function bool ShouldReactToInjuryType(class<DamageType> damageType, bool bHatePrimary, bool bHateSecondary)
{
    local bool bIsPrimary;

    bIsPrimary = IsPrimaryDamageType(damageType);
    if ((bHatePrimary && bIsPrimary) || (bHateSecondary && !bIsPrimary))
        return true;
    else
        return false;
}

// ----------------------------------------------------------------------
// HandleDamage()
// ----------------------------------------------------------------------
function EHitLocation HandleDamage(int actualDamage, Vector hitLocation, Vector offset, class <damageType> damageType)
{
    local EHitLocation hitPos;
    local float        headOffsetZ, headOffsetY, armOffset;
//    local EM_HeadHit   HeadEffect; // DXR: New local variable

    // calculate our hit extents
    headOffsetZ = CollisionHeight * 0.7;
    headOffsetY = CollisionRadius * 0.3;
    armOffset   = CollisionRadius * 0.35;

    hitPos = HITLOC_None;

    if (actualDamage > 0)
    {
        if (offset.z > headOffsetZ)     // head
        {
            // narrow the head region
            if ((Abs(offset.x) < headOffsetY) || (Abs(offset.y) < headOffsetY))
            {
                // don't allow headshots with stunning weapons
                if ((damageType == class'DM_Stunned') || (damageType == class'DM_KnockedOut'))
                    HealthHead -= actualDamage;
                else
                    HealthHead -= actualDamage * 8;
                if (offset.x < 0.0)
                    hitPos = HITLOC_HeadBack;
                else
                    hitPos = HITLOC_HeadFront;

                    // DXR: Spawn DX_HeadHit effect if headshot!
//                    if ((HealthHead == actualDamage) && ((damageType != class'DM_Stunned') || (damageType != class'DM_KnockedOut')))
//                    {
//                       HeadEffect = spawn(class'EM_HeadHit',,,hitLocation, rotation);
//                    }
                    // DXR: End of changes.

            }
            else  // sides of head treated as torso
            {
                HealthTorso -= actualDamage * 2;
                if (offset.x < 0.0)
                    hitPos = HITLOC_TorsoBack;
                else
                    hitPos = HITLOC_TorsoFront;
            }
        }
        else if (offset.z < 0.0)    // legs
        {
            if (offset.y > 0.0)
            {
                HealthLegRight -= actualDamage * 2;
                if (offset.x < 0.0)
                    hitPos = HITLOC_RightLegBack;
                else
                    hitPos = HITLOC_RightLegFront;
            }
            else
            {
                HealthLegLeft -= actualDamage * 2;
                if (offset.x < 0.0)
                    hitPos = HITLOC_LeftLegBack;
                else
                    hitPos = HITLOC_LeftLegFront;
            }

            // if this part is already dead, damage the adjacent part
            if ((HealthLegRight < 0) && (HealthLegLeft > 0))
            {
                HealthLegLeft += HealthLegRight;
                HealthLegRight = 0;
            }
            else if ((HealthLegLeft < 0) && (HealthLegRight > 0))
            {
                HealthLegRight += HealthLegLeft;
                HealthLegLeft = 0;
            }

            if (HealthLegLeft < 0)
            {
                HealthTorso += HealthLegLeft;
                HealthLegLeft = 0;
            }
            if (HealthLegRight < 0)
            {
                HealthTorso += HealthLegRight;
                HealthLegRight = 0;
            }
        }
        else                        // arms and torso
        {
            if (offset.y > armOffset)
            {
                HealthArmRight -= actualDamage * 2;
                if (offset.x < 0.0)
                    hitPos = HITLOC_RightArmBack;
                else
                    hitPos = HITLOC_RightArmFront;
            }
            else if (offset.y < -armOffset)
            {
                HealthArmLeft -= actualDamage * 2;
                if (offset.x < 0.0)
                    hitPos = HITLOC_LeftArmBack;
                else
                    hitPos = HITLOC_LeftArmFront;
            }
            else
            {
                HealthTorso -= actualDamage * 2;
                if (offset.x < 0.0)
                    hitPos = HITLOC_TorsoBack;
                else
                    hitPos = HITLOC_TorsoFront;
            }

            // if this part is already dead, damage the adjacent part
            if (HealthArmLeft < 0)
            {
                HealthTorso += HealthArmLeft;
                HealthArmLeft = 0;
            }
            if (HealthArmRight < 0)
            {
                HealthTorso += HealthArmRight;
                HealthArmRight = 0;
            }
        }
    }

    GenerateTotalHealth();

    return hitPos;
}




// ----------------------------------------------------------------------
// TakeDamageBase()
// ----------------------------------------------------------------------
function TakeDamageBase(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class <damageType> damageType, bool bPlayAnim)
{
    local int          actualDamage;
    local Vector       offset;
    local float        origHealth;
    local EHitLocation hitPos;
    local float        shieldMult;

    // use the hitlocation to determine where the pawn is hit
    // transform the worldspace hitlocation into objectspace
    // in objectspace, remember X is front to back
    // Y is side to side, and Z is top to bottom
    offset = (hitLocation - Location) << Rotation;

    if (!CanShowPain())
        bPlayAnim = false;

    // Prevent injury if the NPC is intangible
    if (!bBlockActors && !bBlockPlayers && !bCollideActors)
        return;

    // No damage + no damage type = no reaction
    if ((Damage <= 0) && (damageType == None))
        return;

    // Block certain damage types; perform special ops on others
    if (!FilterDamageType(instigatedBy, hitLocation, offset, damageType))
        return;

    // Impart momentum
    ImpartMomentum(momentum, instigatedBy);

    actualDamage = ModifyDamage(Damage, instigatedBy, hitLocation, offset, damageType, momentum);

    // DXR: Added Hitmarker.
    if (instigatedBy != None && instigatedBy.IsA('PlayerPawn'))
    {
       if ((class'DeusExGlobals'.static.GetGlobals().bHitmarkerOn) && (PlayerPawn(instigatedBy) != None))
            PlayerPawn(instigatedBy).hitmarkerTime = 0.5;
    }

    if (actualDamage > 0)
    {
        shieldMult = ShieldDamage(damageType);
        if (shieldMult > 0)
            actualDamage = Max(int(actualDamage*shieldMult), 1);
        else
            actualDamage = 0;
        if (shieldMult < 1.0)
            DrawShield();
    }

    origHealth = Health;

    hitPos = HandleDamage(actualDamage, hitLocation, offset, damageType);
    if (!bPlayAnim || (actualDamage <= 0))
        hitPos = HITLOC_None;

    if (bCanBleed)
        if ((damageType != class'DM_Stunned') && (damageType != class'DM_TearGas') && (damageType != class'DM_HalonGas') &&
            (damageType != class'DM_PoisonGas') && (damageType != class'DM_Radiation') && (damageType != class'DM_EMP') &&
            (damageType != class'DM_NanoVirus') && (damageType != class'DM_Drowned') && (damageType != class'DM_KnockedOut') &&
            (damageType != class'DM_Poison') && (damageType != class'DM_PoisonEffect'))
            {
                bleedRate += (origHealth-Health)/(0.3*Default.Health);  // 1/3 of default health = bleed profusely
            }

    if ((actualDamage > 0) && (damageType == class'DM_Poison'))
        StartPoison(Damage, instigatedBy);

    if (Health <= 0)
    {
        DXRAiController(Controller).ClearNextState();
        if ( actualDamage > mass )
            Health = -1 * actualDamage;
        SetEnemy(instigatedBy, 0, true);

        // gib us if we get blown up
        if (DamageType == class'DM_Exploded')
            Health = -10000;
        else
            Health = -1;

//        log("Inventory = "$Inventory);
        Died(instigatedBy.controller, damageType, HitLocation);

        if ((DamageType == class'DM_Flamed') || (DamageType == class'DM_Burned'))
        {
            bBurnedToDeath = true;
            ScaleGlow *= 0.1;  // blacken the corpse
        }
        else
            bBurnedToDeath = false;

        return;
    }
    // play a hit sound
    if (DamageType != class'DM_Stunned')
        PlayTakeHitSound(actualDamage, damageType, 1);

    if ((DamageType == class'DM_Flamed') && !bOnFire)
        CatchFire();

//    log(self@"Damaged by"@instigatedBy@"amount:"@Damage);
    DXRAIController(Controller).ReactToInjury(instigatedBy, damageType, hitPos);
}




// ----------------------------------------------------------------------
// IsNearHome()
// ----------------------------------------------------------------------
function bool IsNearHome(vector position)
{
  local bool bNear;

  bNear = true;
  if (bUseHome)
  {
    if (VSize(HomeLoc-position) <= HomeExtent)
    {
      if (!FastTrace(position, HomeLoc))
        bNear = false;
    }
    else
      bNear = false;
  }

  return bNear;
}




// ----------------------------------------------------------------------
// IsDoor()
// ----------------------------------------------------------------------
function bool IsDoor(Actor door, optional bool bWarn)
{
   return DXRAIController(Controller).IsDoor(door, bWarn);
}



// ----------------------------------------------------------------------
// CheckOpenDoor()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// EncroachedBy()
// ----------------------------------------------------------------------
// overridden so indestructable NPCs aren't InstaGibbed by stupid movement code
event EncroachedBy(actor Other)
{
}






// ----------------------------------------------------------------------
// EncroachedByMover()
// ----------------------------------------------------------------------
function EncroachedByMover(Mover encroacher)
{
    local DeusExMover dxMover;

    dxMover = DeusExMover(encroacher);
    if (dxMover != None)
        if (!dxMover.bInterpolating && IsDoor(dxMover))
            FrobDoor(dxMover);
}

// ----------------------------------------------------------------------
// FrobDoor()
// ----------------------------------------------------------------------
function bool FrobDoor(actor Target)
{
    return DXRAIController(Controller).FrobDoor(Target);
}


// ----------------------------------------------------------------------
// PlayAnimPivot()
// ----------------------------------------------------------------------
function PlayAnimPivot(name Sequence, optional float Rate, optional float TweenTime, optional vector NewPrePivot)
{
  if (Rate == 0)
    Rate = 1.0;
  if (TweenTime == 0)
    TweenTime = 0.1;
  PlayAnim(Sequence, Rate, TweenTime);
  PrePivotTime    = TweenTime;
  DesiredPrePivot = NewPrePivot + PrePivotOffset;
  if (PrePivotTime <= 0)
    PrePivot = DesiredPrePivot;
}


// ----------------------------------------------------------------------
// LoopAnimPivot()
// ----------------------------------------------------------------------
function LoopAnimPivot(name Sequence, optional float Rate, optional float TweenTime, optional float MinRate, optional vector NewPrePivot)
{
  if (Rate == 0)
    Rate = 1.0;
  if (TweenTime == 0)
    TweenTime = 0.1;
  LoopAnim(Sequence, Rate, TweenTime, MinRate);
  PrePivotTime    = TweenTime;
  DesiredPrePivot = NewPrePivot + PrePivotOffset;
  if (PrePivotTime <= 0)
    PrePivot = DesiredPrePivot;
}


// ----------------------------------------------------------------------
// TweenAnimPivot()
// ----------------------------------------------------------------------
function TweenAnimPivot(name Sequence, float TweenTime, optional vector NewPrePivot)
{
  if (TweenTime == 0)
    TweenTime = 0.1;
  TweenAnim(Sequence, TweenTime);
  PrePivotTime    = TweenTime;
  DesiredPrePivot = NewPrePivot + PrePivotOffset;
  if (PrePivotTime <= 0)
    PrePivot = DesiredPrePivot;
}

// ----------------------------------------------------------------------
// HasTwoHandedWeapon()
// ----------------------------------------------------------------------
function bool HasTwoHandedWeapon()
{
  if ((Weapon != None) && (Weapon.Mass >= 30))
    return True;
  else
    return False;
}


// ----------------------------------------------------------------------
// GetStyleTexture()
// ----------------------------------------------------------------------
function material GetStyleTexture(ERenderStyle newStyle, material oldTex, optional material newTex)
{
    local material defaultTex;

    if  (newStyle == STY_Translucent)
        defaultTex = Texture'BlackMaskTex';
    else if (newStyle == STY_Modulated)
        defaultTex = Texture'GrayMaskTex';
    else if (newStyle == STY_Masked)
        defaultTex = Texture'PinkMaskTex';
    else
        defaultTex = Texture'BlackMaskTex';

    if (oldTex == None)
        return defaultTex;
    else if (oldTex == Texture'BlackMaskTex')
        return Texture'BlackMaskTex';  // hack
    else if (oldTex == Texture'GrayMaskTex')
        return defaultTex;
    else if (oldTex == Texture'PinkMaskTex')
        return defaultTex;
    else if (newTex != None)
        return newTex;
    else
        return oldTex;

}

// ----------------------------------------------------------------------
// SetSkinStyle()
// ----------------------------------------------------------------------
function SetSkinStyle(ERenderStyle newStyle, optional material newTex, optional float newScaleGlow)
{
    local int      i;
    local material curSkin;
//  local texture oldSkin;

    if (newScaleGlow == 0)
        newScaleGlow = ScaleGlow;

//  oldSkin = Skin;
    for (i=0; i<skins.length; i++)
    {
        curSkin = skins[i]; //GetMeshTexture(i);
        Skins[i] = GetStyleTexture(newStyle, curSkin, newTex);
    }
//  Skin      = GetStyleTexture(newStyle, Skin, newTex);
    ScaleGlow = newScaleGlow;
    Style     = newStyle;
}

// ----------------------------------------------------------------------
// ResetSkinStyle()
// ----------------------------------------------------------------------
function ResetSkinStyle()
{
    local int i;

    for (i=0; i<skins.length; i++)
        Skins[i] = default.Skins[i];

    ScaleGlow = default.ScaleGlow;
    Style     = default.Style;
}

// ----------------------------------------------------------------------
// EnableCloak()
// beware! called from C++
// ----------------------------------------------------------------------
event EnableCloak(bool bEnable)
{
    if (!bHasCloak || (CloakEMPTimer > 0) || (Health <= 0) || bOnFire)
        bEnable = false;

    if (bEnable && !bCloakOn)
    {
//      SetSkinStyle(STY_Translucent, Texture'WhiteStatic', 0.05);
        SetSkinStyle(STY_Translucent, Shader'WhiteStatic_SH', 0.05);
        KillShadow();
        bCloakOn = bEnable;
    }
    else if (!bEnable && bCloakOn)
    {
        ResetSkinStyle();
        CreateShadow();
        bCloakOn = bEnable;
    }
}




// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// SOUND FUNCTIONS
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// PlayBodyThud()
// Заметка: это должно быть из оповещения модели.
// Подсказка:
//#exec MESH NOTIFY MESH=mp_jumpsuit SEQ=DeathFront       TIME=0.3        FUNCTION=PlayBodyThud
//#exec MESH NOTIFY MESH=mp_jumpsuit SEQ=DeathBack        TIME=0.5        FUNCTION=PlayBodyThud
// ----------------------------------------------------------------------
function PlayBodyThud()
{
    PlaySound(sound'BodyThud', SLOT_Interact);
}


// ----------------------------------------------------------------------
// RandomPitch()
//
// Repetitive sound pitch randomizer to help make some sounds
// sound less monotonous
// ----------------------------------------------------------------------
function float RandomPitch()
{
    return (1.1 - 0.2*FRand());
}

// ----------------------------------------------------------------------
// Gasp()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// PlayDyingSound()
// ----------------------------------------------------------------------
function PlayDyingSound()
{
    SetDistressTimer();
    PlaySound(Die, SLOT_Pain,,,, RandomPitch());
    class'EventManager'.static.AISendEvent(self,'LoudNoise', EAITYPE_Audio);

    if (bEmitDistress)
        class'EventManager'.static.AISendEvent(self,'Distress', EAITYPE_Audio);
}

// ----------------------------------------------------------------------
// PlayIdleSound()
// ----------------------------------------------------------------------
function PlayIdleSound()
{
    local DeusExPlayer dxPlayer;

//  log(self@"Try to PlayIdleSound()");

    dxPlayer = DeusExPlayer(GetPlayerPawn());
    if (dxPlayer != None)
        dxPlayer.StartAIBarkConversation(self, BM_Idle);
}

// ----------------------------------------------------------------------
// PlayScanningSound()
// ----------------------------------------------------------------------
function PlayScanningSound()
{
    local DeusExPlayer dxPlayer;

    dxPlayer = DeusExPlayer(GetPlayerPawn());
    if (dxPlayer != None)
        dxPlayer.StartAIBarkConversation(self, BM_Scanning);
}



// ----------------------------------------------------------------------
// PlayPreAttackSearchingSound()
// ----------------------------------------------------------------------
function PlayPreAttackSearchingSound()
{
    local DeusExPlayer dxPlayer;

    dxPlayer = DeusExPlayer(GetPlayerPawn());
    if ((dxPlayer != None) && (SeekPawn == dxPlayer))
        dxPlayer.StartAIBarkConversation(self, BM_PreAttackSearching);
}

// ----------------------------------------------------------------------
// PlayPreAttackSightingSound()
// ----------------------------------------------------------------------
function PlayPreAttackSightingSound()
{
    local DeusExPlayer dxPlayer;

    dxPlayer = DeusExPlayer(GetPlayerPawn());
    if ((dxPlayer != None) && (SeekPawn == dxPlayer))
        dxPlayer.StartAIBarkConversation(self, BM_PreAttackSighting);
}

// ----------------------------------------------------------------------
// PlayPostAttackSearchingSound()
// ----------------------------------------------------------------------
function PlayPostAttackSearchingSound()
{
    local DeusExPlayer dxPlayer;

    dxPlayer = DeusExPlayer(GetPlayerPawn());
    if ((dxPlayer != None) && (SeekPawn == dxPlayer))
        dxPlayer.StartAIBarkConversation(self, BM_PostAttackSearching);
}

// ----------------------------------------------------------------------
// PlayTargetAcquiredSound()
// ----------------------------------------------------------------------
function PlayTargetAcquiredSound()
{
    local DeusExPlayer dxPlayer;

    dxPlayer = DeusExPlayer(GetPlayerPawn());
    if ((dxPlayer != None) && (Controller.Enemy == dxPlayer))
        dxPlayer.StartAIBarkConversation(self, BM_TargetAcquired);
}

// ----------------------------------------------------------------------
// PlayTargetLostSound()
// ----------------------------------------------------------------------
function PlayTargetLostSound()
{
    local DeusExPlayer dxPlayer;

    dxPlayer = DeusExPlayer(GetPlayerPawn());
    if ((dxPlayer != None) && (SeekPawn == dxPlayer))
        dxPlayer.StartAIBarkConversation(self, BM_TargetLost);
}

// ----------------------------------------------------------------------
// PlaySearchGiveUpSound()
// ----------------------------------------------------------------------
function PlaySearchGiveUpSound()
{
    local DeusExPlayer dxPlayer;

    dxPlayer = DeusExPlayer(GetPlayerPawn());
    if ((dxPlayer != None) && (SeekPawn == dxPlayer))
        dxPlayer.StartAIBarkConversation(self, BM_SearchGiveUp);
}

// ----------------------------------------------------------------------
// PlayNewTargetSound()
// ----------------------------------------------------------------------
function PlayNewTargetSound();

// ----------------------------------------------------------------------
// PlayGoingForAlarmSound()
// ----------------------------------------------------------------------
function PlayGoingForAlarmSound()
{
    local DeusExPlayer dxPlayer;

    dxPlayer = DeusExPlayer(GetPlayerPawn());
    if ((dxPlayer != None) && (controller.Enemy == dxPlayer))
        dxPlayer.StartAIBarkConversation(self, BM_GoingForAlarm);
}


// ----------------------------------------------------------------------
// PlayOutOfAmmoSound()
// ----------------------------------------------------------------------
function PlayOutOfAmmoSound()
{
    local DeusExPlayer dxPlayer;

    dxPlayer = DeusExPlayer(GetPlayerPawn());
    if (dxPlayer != None)
        dxPlayer.StartAIBarkConversation(self, BM_OutOfAmmo);
}


// ----------------------------------------------------------------------
// PlayCriticalDamageSound()
// ----------------------------------------------------------------------
function PlayCriticalDamageSound()
{
    local DeusExPlayer dxPlayer;

    dxPlayer = DeusExPlayer(GetPlayerPawn());
    if ((dxPlayer != None) && (controller.Enemy == dxPlayer))
        dxPlayer.StartAIBarkConversation(self, BM_CriticalDamage);
}


// ----------------------------------------------------------------------
// PlayAreaSecureSound()
// ----------------------------------------------------------------------
function PlayAreaSecureSound()
{
    local DeusExPlayer dxPlayer;

    // Should we do a player check here?

    dxPlayer = DeusExPlayer(GetPlayerPawn());
    if ((dxPlayer != None) && (controller.Enemy == dxPlayer))
        dxPlayer.StartAIBarkConversation(self, BM_AreaSecure);
}

// ----------------------------------------------------------------------
// PlayFutzSound()
// ----------------------------------------------------------------------
function PlayFutzSound()
{
    local DeusExPlayer dxPlayer;
    local string conName;

    dxPlayer = DeusExPlayer(GetPlayerPawn());
    if (dxPlayer != None)
    {
        if (dxPlayer.barkManager != None)
        {
            conName = dxPlayer.barkManager.BuildBarkName(self, BM_Futz);
            dxPlayer.StartConversationByName(conName, self, !bInterruptState);
        }
    }
}




// ----------------------------------------------------------------------
// PlayOnFireSound()
// ----------------------------------------------------------------------
function PlayOnFireSound()
{
    local DeusExPlayer dxPlayer;

    dxPlayer = DeusExPlayer(GetPlayerPawn());
    if (dxPlayer != None)
        dxPlayer.StartAIBarkConversation(self, BM_OnFire);
}

// ----------------------------------------------------------------------
// PlayTearGasSound()
// ----------------------------------------------------------------------
function PlayTearGasSound()
{
    local DeusExPlayer dxPlayer;

    dxPlayer = DeusExPlayer(GetPlayerPawn());
    if (dxPlayer != None)
        dxPlayer.StartAIBarkConversation(self, BM_TearGas);
}

// ----------------------------------------------------------------------
// PlayCarcassSound()
// ----------------------------------------------------------------------
function PlayCarcassSound()
{
    local DeusExPlayer dxPlayer;

    dxPlayer = DeusExPlayer(GetPlayerPawn());
    if ((dxPlayer != None) && (SeekPawn == dxPlayer))
        dxPlayer.StartAIBarkConversation(self, BM_Gore);
}

// ----------------------------------------------------------------------
// PlaySurpriseSound()
// ----------------------------------------------------------------------
function PlaySurpriseSound()
{
    local DeusExPlayer dxPlayer;

    dxPlayer = DeusExPlayer(GetPlayerPawn());
    if ((dxPlayer != None) && (controller.Enemy == dxPlayer))
        dxPlayer.StartAIBarkConversation(self, BM_Surprise);
}

// ----------------------------------------------------------------------
// PlayAllianceHostileSound()
// ----------------------------------------------------------------------
function PlayAllianceHostileSound()
{
    local DeusExPlayer dxPlayer;

    dxPlayer = DeusExPlayer(GetPlayerPawn());
    if ((dxPlayer != None) && (controller.Enemy == dxPlayer))
        dxPlayer.StartAIBarkConversation(self, BM_AllianceHostile);
}

// ----------------------------------------------------------------------
// PlayAllianceFriendlySound()
// ----------------------------------------------------------------------
function PlayAllianceFriendlySound()
{
    local DeusExPlayer dxPlayer;

    dxPlayer = DeusExPlayer(GetPlayerPawn());
    if ((dxPlayer != None) && (controller.Enemy == dxPlayer))
        dxPlayer.StartAIBarkConversation(self, BM_AllianceFriendly);
}


function PlayIdle()
{
//  ClientMessage("PlayIdle()");
    if (PhysicsVolume.bWaterVolume)
        LoopAnimPivot('Tread', , 0.3, , GetSwimPivot());
    else
    {
        if (HasTwoHandedWeapon())
            PlayAnimPivot('Idle12H', , 0.3);
        else
          if (HasAnim('Idle1')) // Устраняет спамлог для коммандос MJ12.
            PlayAnimPivot('Idle1', , 0.3);
    }
}

// ----------------------------------------------------------------------
// PlayTakeHitSound()
// ----------------------------------------------------------------------
function PlayTakeHitSound(int Damage, class<damageType> damageType, int Mult)
{
    local Sound hitSound;
    local float volume;

    if (Level.TimeSeconds - LastPainSound < 0.25)
        return;
    if (Damage <= 0)
        return;

    LastPainSound = Level.TimeSeconds;

    //Lork: Use extra pain sounds if appropriate
    if(hitSound1 == sound'MalePainSmall' || hitSound1 == sound'FemalePainSmall')
    {
        if(PhysicsVolume.bWaterVolume && damageType == class'DM_Drowned')
        {
            if(bIsFemale)
                hitSound = sound'FemaleDrown';
            else
                hitSound = sound'MaleDrown';
        }
        else if(damageType == class'DM_PoisonGas')
        {
            if(!bIsFemale)
                hitSound = sound'MaleCough';
        }
        else if(damage >= 60)
        {
            if(bIsFemale)
                hitSound = sound'FemalePainLarge';
            else
                hitSound = sound'MalePainLarge';
        }
    }
    
    if(hitSound == None)
    {
        if (Damage <= 30)
            hitSound = HitSound1;
        else
            hitSound = HitSound2;
    }
    volume = FMax(Mult*TransientSoundVolume, Mult*2.0);

    SetDistressTimer();
    PlaySound(hitSound, SLOT_Pain, volume,,, RandomPitch());

    // DXR: Added bulletHitSounds
    if (damageType == class'DM_Shot' || damageType == class'DM_AutoShot')
        PlaySound(GetBulletHitSound(), SLOT_Misc,volume * 2,,1024.00,);

    if ((hitSound != None) && bEmitDistress)
        class'EventManager'.static.AISendEvent(self,'Distress', EAITYPE_Audio, volume);
}





// ----------------------------------------------------------------------
// GetFloorMaterial()
//
// Gets the name of the texture group that we are standing on
// ----------------------------------------------------------------------
function name GetFloorMaterial()
{
    local vector EndTrace, HitLocation, HitNormal;
    local actor target;
    local int texFlags;
    local name texName, texGroup;

    // trace down to our feet
    EndTrace = Location - CollisionHeight * 2 * vect(0,0,1);

  foreach class'ActorManager'.static.TraceTexture(self,class'Actor', target, texName, texGroup, texFlags, HitLocation, HitNormal, EndTrace)
    {
        if ((target == Level) || target.IsA('Mover'))
            break;
    }

    return texGroup;
}

// ----------------------------------------------------------------------
// Plays footstep sounds based on the texture group
// ----------------------------------------------------------------------
function PlayFootStep()
{
    local Sound stepSound;
    local float rnd;
    local name mat;
    local float speedFactor, massFactor;
    local float volume, pitch, range;
    local float radius, maxRadius;
    local float volumeMultiplier;
    local DeusExPlayer dxPlayer;
    local DeusExGlobals gl;
    local float shakeRadius, shakeMagnitude;
    local float playerDist;
    local int FS_Index;

    gl = class'DeusExGlobals'.static.GetGlobals();
    FS_Index = gl.FS_Preset;

    rnd = FRand();
    mat = GetFloorMaterial();

    volumeMultiplier = 1.0;
    if (WalkSound == None)
    {
        if (PhysicsVolume.bWaterVolume)
        {
            if (rnd < 0.33)
                stepSound = Sound'WaterStep1';
            else if (rnd < 0.66)
                stepSound = Sound'WaterStep2';
            else
                stepSound = Sound'WaterStep3';
        }
        else
        {
            switch(mat)
            {
                case 'Textile':
                case 'Paper':
                    volumeMultiplier = 0.7;
                    stepSound = class'DXRFootStepManager'.static.GetStepPaper(FS_Index);
                   /* if (rnd < 0.25)
                        stepSound = Sound'CarpetStep1';
                    else if (rnd < 0.5)
                        stepSound = Sound'CarpetStep2';
                    else if (rnd < 0.75)
                        stepSound = Sound'CarpetStep3';
                    else
                        stepSound = Sound'CarpetStep4';*/
                    break;

                case 'Foliage':
                    stepSound = class'DXRFootStepManager'.static.GetFoliageStep(FS_Index);
                     break;

                case 'Earth':
                    volumeMultiplier = 0.6;
                    stepSound = class'DXRFootStepManager'.static.GetEarthStep(FS_Index);
                    /*if (rnd < 0.25)
                        stepSound = Sound'GrassStep1';
                    else if (rnd < 0.5)
                        stepSound = Sound'GrassStep2';
                    else if (rnd < 0.75)
                        stepSound = Sound'GrassStep3';
                    else
                        stepSound = Sound'GrassStep4';*/
                    break;

                case 'Metal':
                case 'Ladder':
                    volumeMultiplier = 1.0;
/*                    if ((bIsFemale) && (bHasHeels))
                    {
                       if (rnd < 0.25)
                          stepSound = Sound'Heels.Heels_Metal_Tip_a';
                       else if (rnd < 0.5)
                          stepSound = Sound'Heels.Heels_Metal_Tip_b';
                       else if (rnd < 0.75)
                          stepSound = Sound'Heels.Heels_Metal_Tip_c';
                       else
                          stepSound = Sound'Heels.Heels_Metal_Tip_d';
                    }
                    else*/
                    stepSound = class'DXRFootStepManager'.static.GetMetalStep(FS_Index);
                    /*if (rnd < 0.25)
                        stepSound = Sound'MetalStep1';
                    else if (rnd < 0.5)
                        stepSound = Sound'MetalStep2';
                    else if (rnd < 0.75)
                        stepSound = Sound'MetalStep3';
                    else
                        stepSound = Sound'MetalStep4';*/
                    break;

                case 'Glass':
                    volumeMultiplier = 0.7;
                    stepSound = class'DXRFootStepManager'.static.GetGlassStep(FS_Index);
                    break;

                case 'Ceramic':
                case 'Tiles':
                    volumeMultiplier = 0.7;
                    stepSound = class'DXRFootStepManager'.static.GetCeramicStep(FS_Index);
                    /*if (rnd < 0.25)
                        stepSound = Sound'TileStep1';
                    else if (rnd < 0.5)
                        stepSound = Sound'TileStep2';
                    else if (rnd < 0.75)
                        stepSound = Sound'TileStep3';
                    else
                        stepSound = Sound'TileStep4';*/
                    break;

                case 'Wood':
                    volumeMultiplier = 0.7;
/*                    if ((bIsFemale) && (bHasHeels))
                    {
                       if (rnd < 0.25)
                          stepSound = Sound'Heels.Heels_WoodFloor_a';
                       else if (rnd < 0.5)
                          stepSound = Sound'Heels.Heels_WoodFloor_b';
                       else if (rnd < 0.75)
                          stepSound = Sound'Heels.Heels_WoodFloor_c';
                       else
                          stepSound = Sound'Heels.Heels_WoodFloor_d';
                    }
                    else*/
                    stepSound = class'DXRFootStepManager'.static.GetWoodStep(FS_Index);
                    /*if (rnd < 0.25)
                        stepSound = Sound'WoodStep1';
                    else if (rnd < 0.5)
                        stepSound = Sound'WoodStep2';
                    else if (rnd < 0.75)
                        stepSound = Sound'WoodStep3';
                    else
                        stepSound = Sound'WoodStep4';*/
                    break;

                case 'Brick':
                case 'Concrete':
                case 'Stone':
                case 'Stucco':
                default:
                    volumeMultiplier = 0.7;
/*                    if ((bIsFemale) && (bHasHeels))
                    {
                       if (rnd < 0.25)
                          stepSound = Sound'Heels.Heels_Metal_Tip_a';
                       else if (rnd < 0.5)
                          stepSound = Sound'Heels.Heels_Metal_Tip_b';
                       else if (rnd < 0.75)
                          stepSound = Sound'Heels.Heels_Metal_Tip_c';
                       else
                          stepSound = Sound'Heels.Heels_Metal_Tip_d';
                    }
                    else*/
                    stepSound = class'DXRFootStepManager'.static.GetDefaultStep(FS_Index);
                    /*if (rnd < 0.25)
                        stepSound = Sound'StoneStep1';
                    else if (rnd < 0.5)
                        stepSound = Sound'StoneStep2';
                    else if (rnd < 0.75)
                        stepSound = Sound'StoneStep3';
                    else
                        stepSound = Sound'StoneStep4';*/
                    break;
            }
        }
    }
    else
        stepSound = WalkSound;

    // compute sound volume, range and pitch, based on mass and speed
    speedFactor = VSize(Velocity)/120.0;
    massFactor  = Mass/150.0;
    radius      = 256;//768.0;
    maxRadius   = 1200;//2048.0;
//  volume      = (speedFactor+0.2)*massFactor;
//  volume      = (speedFactor+0.7)*massFactor;
    volume      = massFactor*1.5;
    range       = radius * volume;
    pitch       = (volume+0.5);
    volume      = 1.0;
    range       = FClamp(range, 0.01, maxRadius);
    pitch       = FClamp(pitch, 1.0, 1.5);

    // play the sound and send an AI event
    PlaySound(stepSound, SLOT_Interact, volume, , range/6, pitch);

    class'EventManager'.static.AISendEvent(self, 'LoudNoise', EAITYPE_Audio, volume*volumeMultiplier, range*volumeMultiplier);

    // Shake the camera when heavy things tread
    if (Mass > 400)
    {
        dxPlayer = DeusExPlayer(GetPlayerPawn());
        if (dxPlayer != None)
        {
            playerDist = DistanceFromPlayer();
            shakeRadius = FClamp((Mass-400)/600, 0, 1.0) * (range*0.5);
            shakeMagnitude = FClamp((Mass-400)/1600, 0, 1.0);
            shakeMagnitude = FClamp(1.0-(playerDist/shakeRadius), 0, 1.0) * shakeMagnitude;
            if (shakeMagnitude > 0)
                dxPlayer.JoltView(shakeMagnitude);
        }
    }
}

function PlayFootStepLeft()
{
    PlayFootStep();
}

function PlayFootStepRight()
{
    PlayFootStep();
}

function name GetWeaponBoneFor(Inventory I)
{
    return '0';
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// ANIMATION CALLS
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// GetSwimPivot()
// ----------------------------------------------------------------------
function vector GetSwimPivot()
{
    // THIS IS A HIDEOUS, UGLY, MASSIVELY EVIL HACK!!!!
    return (vect(0,0,1)*CollisionHeight*0.65);
}


// ----------------------------------------------------------------------
// GetWalkingSpeed()
// ----------------------------------------------------------------------
function float GetWalkingSpeed()
{
  if (Physics == PHYS_Swimming)
    return MaxDesiredSpeed;
  else
    return WalkingSpeed;
}

// ----------------------------------------------------------------------
// PlayTurnHead()
// ----------------------------------------------------------------------
function bool PlayTurnHead(ELookDirection dir, float rate, float tweentime)
{
    local name lookName;
    local bool bSuccess;

    if (dir == LOOK_Left)
        lookName = 'HeadLeft';
    else if (dir == LOOK_Right)
        lookName = 'HeadRight';
    else if (dir == LOOK_Up)
        lookName = 'HeadUp';
    else if (dir == LOOK_Down)
        lookName = 'HeadDown';
    else
        lookName = 'Still';

//    bSuccess = false;
  //  if (BlendAnimSequence[3] != lookName)
//    {
        //if (animTimer[1] > 0.00)
        //{
           // animTimer[1] = 0;
           // if (BlendAnimSequence[3] == '')
         //       BlendAnimSequence[3] = 'Still';
            PlayAnim(lookName, rate, tweentime, 3);
            bSuccess = true;
     //   }
   //}

    return (bSuccess);
}



// ----------------------------------------------------------------------
// PlayRunningAndFiring()
// ----------------------------------------------------------------------
function PlayRunningAndFiring()
{
    local DeusExWeapon W;
    local vector       v1, v2;
    local float        dotp;

    bIsWalking = false;

    W = DeusExWeapon(Weapon);

    if (W != None)
    {
        if (PhysicsVolume.bWaterVolume)
        {
            if (W.bHandToHand)
                LoopAnimPivot('Tread',,0.1,,GetSwimPivot());
            else
                LoopAnimPivot('TreadShoot',,0.1,,GetSwimPivot());
        }
        else
        {
            if (W.bHandToHand)
                LoopAnimPivot('Run',runAnimMult,0.1);
            else
            {
                v1 = Normal((Controller.Enemy.Location - Location)*vect(1,1,0));
                if (destPoint != None)
                    v2 = Normal((destPoint.Location - Location)*vect(1,1,0));
                else
                    v2 = Normal((destLoc - Location)*vect(1,1,0));
                dotp = Abs(v1 dot v2);
                if (dotp < 0.70710678)  // running sideways
                {
                    if (HasTwoHandedWeapon())
                        LoopAnimPivot('Strafe2H',runAnimMult,0.1);
                    else
                        LoopAnimPivot('Strafe',runAnimMult,0.1);
                }
                else
                {
                    if (HasTwoHandedWeapon())
                        LoopAnimPivot('RunShoot2H',runAnimMult,0.1);
                    else
                        LoopAnimPivot('RunShoot',runAnimMult,0.1);
                }
            }
        }
    }
}

// ----------------------------------------------------------------------
// PlayReloadBegin()
// ----------------------------------------------------------------------
function PlayReloadBegin()
{
    PlayAnimPivot('ReloadBegin',, 0.1);
}

// ----------------------------------------------------------------------
// PlayReload()
// ----------------------------------------------------------------------
function PlayReload()
{
    LoopAnimPivot('Reload',,0.2);
}

// ----------------------------------------------------------------------
// PlayReloadEnd()
// ----------------------------------------------------------------------
function PlayReloadEnd()
{
    PlayAnimPivot('ReloadEnd',, 0.1);
}


// ----------------------------------------------------------------------
// TweenToShoot()
// ----------------------------------------------------------------------
function TweenToShoot(float tweentime)
{
    if (PhysicsVolume.bWaterVolume)
        TweenAnimPivot('TreadShoot', tweentime, GetSwimPivot());
    else if (!bCrouching)
    {
        if (!IsWeaponReloading())
        {
            if (HasTwoHandedWeapon())
                TweenAnimPivot('Shoot2H', tweentime);
            else
                TweenAnimPivot('Shoot', tweentime);
        }
        else
            PlayReload();
    }
}

// ----------------------------------------------------------------------
// PlayShoot()
// ----------------------------------------------------------------------
function PlayShoot()
{
    if (PhysicsVolume.bWaterVolume)
        PlayAnimPivot('TreadShoot', , 0, GetSwimPivot());
    else
    {
        if (HasTwoHandedWeapon())
        {
            PlayAnimPivot('Shoot2H', , 0);
            PawnFiringEffects();
        }
        else
        {
            PlayAnimPivot('Shoot', , 0);
            PawnFiringEffects();
        }
    }
}

// ----------------------------------------------------------------------
// TweenToCrouchShoot()
// ----------------------------------------------------------------------
function TweenToCrouchShoot(float tweentime)
{
    if (PhysicsVolume.bWaterVolume)
        TweenAnimPivot('TreadShoot', tweentime, GetSwimPivot());
    else
        TweenAnimPivot('CrouchShoot', tweentime);
}

// ----------------------------------------------------------------------
// PlayCrouchShoot()
// ----------------------------------------------------------------------
function PlayCrouchShoot()
{
    if (PhysicsVolume.bWaterVolume)
        PlayAnimPivot('TreadShoot', , 0, GetSwimPivot());
    else
        PlayAnimPivot('CrouchShoot', , 0);
}

// ----------------------------------------------------------------------
// TweenToAttack()
// ----------------------------------------------------------------------
function TweenToAttack(float tweentime)
{
    if (PhysicsVolume.bWaterVolume)
        TweenAnimPivot('Tread', tweentime, GetSwimPivot());
    else
    {
        if (bUseSecondaryAttack)
            TweenAnimPivot('AttackSide', tweentime);
        else
            TweenAnimPivot('Attack', tweentime);
    }
}

// ----------------------------------------------------------------------
// PlayAttack()
// ----------------------------------------------------------------------
function PlayAttack()
{
    if (PhysicsVolume.bWaterVolume)
        PlayAnimPivot('Tread',,,GetSwimPivot());
    else
    {
        if (bUseSecondaryAttack)
            PlayAnimPivot('AttackSide');
        else
            PlayAnimPivot('Attack');
    }
}

// ----------------------------------------------------------------------
// PlayTurning()
// ----------------------------------------------------------------------
function PlayTurning()
{
//  ClientMessage("PlayTurning()");
    if (PhysicsVolume.bWaterVolume)
        LoopAnimPivot('Tread', , , , GetSwimPivot());
    else
    {
        if (HasTwoHandedWeapon())
            TweenAnimPivot('Walk2H', 0.1);
        else
            TweenAnimPivot('Walk', 0.1);
    }
}

// ----------------------------------------------------------------------
// TweenToWalking()
// ----------------------------------------------------------------------
function TweenToWalking(float tweentime)
{
//  ClientMessage("TweenToWalking()");
    bIsWalking = True;
    if (PhysicsVolume.bWaterVolume)
        TweenAnimPivot('Tread', tweentime, GetSwimPivot());
    else
    {
        if (HasTwoHandedWeapon())
            TweenAnimPivot('Walk2H', tweentime);
        else
            TweenAnimPivot('Walk', tweentime);
    }
}

// ----------------------------------------------------------------------
// PlayWalking()
// ----------------------------------------------------------------------
function PlayWalking()
{
  bIsWalking = True;
  if (PhysicsVolume.bWaterVolume)
    LoopAnimPivot('Tread', , 0.15, , GetSwimPivot());
  else
  {
    if (HasTwoHandedWeapon())
      LoopAnimPivot('Walk2H',walkAnimMult, 0.15);
    else
      LoopAnimPivot('Walk',walkAnimMult, 0.15);
  }
}

// ----------------------------------------------------------------------
// TweenToRunning()
// ----------------------------------------------------------------------
function TweenToRunning(float tweentime)
{
//  ClientMessage("TweenToRunning()");
    bIsWalking = False;
    if (PhysicsVolume.bWaterVolume)
        LoopAnimPivot('Tread',, tweentime,, GetSwimPivot());
    else
    {
        if (HasTwoHandedWeapon())
            LoopAnimPivot('RunShoot2H', runAnimMult, tweentime);
        else
            LoopAnimPivot('Run', runAnimMult, tweentime);
    }
}

// ----------------------------------------------------------------------
// PlayRunning()
// ----------------------------------------------------------------------
function PlayRunning()
{
//  ClientMessage("PlayRunning()");
    bIsWalking = False;
    if (PhysicsVolume.bWaterVolume)
        LoopAnimPivot('Tread',,,,GetSwimPivot());
    else
    {
        if (HasTwoHandedWeapon())
            LoopAnimPivot('RunShoot2H', runAnimMult);
        else
            LoopAnimPivot('Run', runAnimMult);
    }
}

function PlayPushing()
{
    PlayAnimPivot('PushButton', , 0.15);
}

function PlayStunned()
{
    LoopAnimPivot('Shocked');
}

function PlayRubbingEyesStart()
{
    PlayAnimPivot('RubEyesStart', , 0.15);
}

function PlayRubbingEyes()
{
    LoopAnimPivot('RubEyes');
}

function PlayRubbingEyesEnd()
{
    PlayAnimPivot('RubEyesStop');
}

// ----------------------------------------------------------------------
// PlayPanicRunning()
// ----------------------------------------------------------------------
function PlayPanicRunning()
{
//  ClientMessage("PlayPanicRunning()");
    bIsWalking = False;
    if (PhysicsVolume.bWaterVolume)
        LoopAnimPivot('Tread',,,,GetSwimPivot());
    else
        LoopAnimPivot('Panic', runAnimMult);
}


// ----------------------------------------------------------------------
// TweenToWaiting()
// ----------------------------------------------------------------------
function TweenToWaiting(float tweentime)
{
//  ClientMessage("TweenToWaiting()");
    if (PhysicsVolume.bWaterVolume)
        TweenAnimPivot('Tread', tweentime, GetSwimPivot());
    else
    {
        if (HasTwoHandedWeapon())
            TweenAnimPivot('BreatheLight2H', tweentime);
        else
            TweenAnimPivot('BreatheLight', tweentime);
    }
}

// ----------------------------------------------------------------------
// PlayCowerBegin()
// ----------------------------------------------------------------------
function PlayCowerBegin()
{
//  ClientMessage("PlayCowerBegin()");
    if (PhysicsVolume.bWaterVolume)
        LoopAnimPivot('Tread',,,,GetSwimPivot());
    else
        PlayAnimPivot('CowerBegin');
}

// ----------------------------------------------------------------------
// PlayCowering()
// ----------------------------------------------------------------------

function PlayCowering()
{
//  ClientMessage("PlayCowering()");
    if (PhysicsVolume.bWaterVolume)
        LoopAnimPivot('Tread',,,,GetSwimPivot());
    else
        LoopAnimPivot('CowerStill');
}


// ----------------------------------------------------------------------
// PlayCowerEnd()
// ----------------------------------------------------------------------

function PlayCowerEnd()
{
//  ClientMessage("PlayCowerEnd()");
    if (PhysicsVolume.bWaterVolume)
        LoopAnimPivot('Tread',,,,GetSwimPivot());
    else
        PlayAnimPivot('CowerEnd');
}




// ----------------------------------------------------------------------
// PlayWaiting()
// ----------------------------------------------------------------------
function PlayWaiting()
{
 if (Controller.IsInState('Paralyzed') || Controller.IsInState('Attacking') || Controller.IsInState('Fleeing') || bSitting || bDancing || bStunned)
    return;

 if (Acceleration == vect(0, 0, 0))
 {
//  ClientMessage("PlayWaiting()");
  if (PhysicsVolume.bWaterVolume)
    LoopAnimPivot('Tread', , 0.3, , GetSwimPivot());

  else 
  {
    if (HasTwoHandedWeapon())
      LoopAnimPivot('BreatheLight2H', , 0.3);
    else
      LoopAnimPivot('BreatheLight', , 0.3);
  }
 }
}


function PlayLanded(float impactVel)
{
//  ClientMessage("PlayLanded()");
  bIsWalking = True;
  if (impactVel < -12*CollisionHeight)
    PlayAnimPivot('Land');
}

// ----------------------------------------------------------------------
// PlayTakingHit()
// ----------------------------------------------------------------------
function PlayTakingHit(EHitLocation hitPos)
{
    local vector pivot;
    local name   animName;

    animName = '';
    if (!PhysicsVolume.bWaterVolume)
    {
        switch (hitPos)
        {
            case HITLOC_HeadFront:
                animName = 'HitHead';
                break;
            case HITLOC_TorsoFront:
                animName = 'HitTorso';
                break;
            case HITLOC_LeftArmFront:
                animName = 'HitArmLeft';
                break;
            case HITLOC_RightArmFront:
                animName = 'HitArmRight';
                break;

            case HITLOC_HeadBack:
                animName = 'HitHeadBack';
                break;
            case HITLOC_TorsoBack:
            case HITLOC_LeftArmBack:
            case HITLOC_RightArmBack:
                animName = 'HitTorsoBack';
                break;

            case HITLOC_LeftLegFront:
            case HITLOC_LeftLegBack:
                animName = 'HitLegLeft';
                break;

            case HITLOC_RightLegFront:
            case HITLOC_RightLegBack:
                animName = 'HitLegRight';
                break;
        }
        pivot = vect(0,0,0);
    }
    else
    {
        switch (hitPos)
        {
            case HITLOC_HeadFront:
            case HITLOC_TorsoFront:
            case HITLOC_LeftLegFront:
            case HITLOC_RightLegFront:
            case HITLOC_LeftArmFront:
            case HITLOC_RightArmFront:
                animName = 'WaterHitTorso';
                break;

            case HITLOC_HeadBack:
            case HITLOC_TorsoBack:
            case HITLOC_LeftLegBack:
            case HITLOC_RightLegBack:
            case HITLOC_LeftArmBack:
            case HITLOC_RightArmBack:
                animName = 'WaterHitTorsoBack';
                break;
        }
        pivot = GetSwimPivot();
    }

    if (animName != '')
        PlayAnimPivot(animName, , 0.1, pivot);

}

// ----------------------------------------------------------------------
// PlayDying()
// ----------------------------------------------------------------------
event PlayDying(class<DamageType> DamageType, vector HitLoc)
{
    local Vector X, Y, Z;
    local float dotp;

//  ClientMessage("PlayDying()");
    if (PhysicsVolume.bWaterVolume)
        PlayAnimPivot('WaterDeath',, 0.1);
    else if (bSitting)  // if sitting, always fall forward
        PlayAnimPivot('DeathFront',, 0.1);
    else
    {
        GetAxes(Rotation, X, Y, Z);
        dotp = (Location - HitLoc) dot X;

        // die from the correct side
        if (dotp < 0.0)     // shot from the front, fall back
            PlayAnimPivot('DeathBack',, 0.1);
        else                // shot from the back, fall front
            PlayAnimPivot('DeathFront',, 0.1);
    }

    // don't scream if we are stunned
    if ((damageType == class'DM_Stunned') || (damageType == class'DM_KnockedOut') ||
        (damageType == class'DM_Poison') || (damageType == class'DM_PoisonEffect'))
    {
        bStunned = True;
        if (bIsFemale)
            PlaySound(Sound'FemaleUnconscious', SLOT_Pain,,,, RandomPitch());
        else
            PlaySound(Sound'MaleUnconscious', SLOT_Pain,,,, RandomPitch());
    }
    else
    {
        bStunned = False;
        PlayDyingSound();
    }
}



// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// FIRE ROUTINES
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// CatchFire()
// ----------------------------------------------------------------------
function CatchFire()
{
    local Fire f;
    local int i;
    local vector loc;

    if (bOnFire || PhysicsVolume.bWaterVolume || (BurnPeriod <= 0) || bInvincible)
        return;

    bOnFire = True;
    burnTimer = 0;

    EnableCloak(false);

    for (i=0; i<8; i++)
    {
        loc.X = 0.5*CollisionRadius * (1.0-2.0*FRand());
        loc.Y = 0.5*CollisionRadius * (1.0-2.0*FRand());
        loc.Z = 0.6*CollisionHeight * (1.0-2.0*FRand());
        loc += Location;
        f = Spawn(class'Fire', Self,, loc);
        if (f != None)
        {
            f.SetDrawScale(0.5*FRand() + 1.0);

            // turn off the sound and lights for all but the first one
            if (i > 0)
            {
                f.AmbientSound = None;
                f.LightType = LT_None;
            }

            // turn on/off extra fire and smoke
            if (FRand() < 0.5)
                f.smokeGen.Destroy();
            if (FRand() < 0.5)
                f.AddFire();
        }
    }

    // set the burn timer
    SetTimer(1.0, True);
}



// ----------------------------------------------------------------------
// ExtinguishFire()
// ----------------------------------------------------------------------
function ExtinguishFire()
{
    local Fire f;

    bOnFire = False;
    burnTimer = 0;
    SetTimer(0, False);

    //foreach BasedActors(class'Fire', f)
    foreach RadiusActors(class'Fire', f, 100)
      if (f.Owner == Self)
            f.Destroy();
}

// ----------------------------------------------------------------------
// UpdateFire()
// ----------------------------------------------------------------------
function UpdateFire()
{
    // continually burn and do damage
    HealthTorso -= 5;
    GenerateTotalHealth();
    if (Health <= 0)
    {
        TakeDamage(10, None, Location, vect(0,0,0), class'DM_Burned');
        ExtinguishFire();
    }
}




// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// CONVERSATION FUNCTIONS
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// CanConverse()
// ----------------------------------------------------------------------
function bool CanConverse()
{
    // Return True if this NPC is in a conversable state
    return (bCanConverse && bInterruptState && ((Physics == PHYS_Walking) || (Physics == PHYS_Flying)));
}

// ----------------------------------------------------------------------
// CanConverseWithPlayer()
// ----------------------------------------------------------------------
function bool CanConverseWithPlayer(DeusExPlayer dxPlayer)
{
    local name alliance1, alliance2, carcname;  // temp vars

    if (GetPawnAllianceType(dxPlayer) == ALLIANCE_Hostile)
        return false;
    else if ((Controller.GetStateName() == 'Fleeing') && (Controller.Enemy != dxPlayer) && (IsValidEnemy(DeusExPawn(Controller.Enemy), false)))  // hack // TypeCast to DeusExPawn 
        return false;
    else if (GetCarcassData(dxPlayer, alliance1, alliance2, carcname))
        return false;
    else
        return true;
}

// ----------------------------------------------------------------------
// EndConversation()
// ----------------------------------------------------------------------
function EndConversation()
{
    Super.EndConversation();

    if ((Controller.GetStateName() == 'Conversation') || (Controller.GetStateName() == 'FirstPersonConversation'))
    {
        bConversationEndedNormally = True;

        if (!bConvEndState)
            FollowOrders();
    }

    bInConversation = False;
}

function SetReactions(bool bEnemy, bool bLoudNoise, bool bAlarm, bool bDistress,
                      bool bProjectile, bool bFutz, bool bHacking, bool bShot, bool bWeapon, bool bCarcass,
                      bool bInjury, bool bIndirectInjury)
{
    bLookingForEnemy          = bEnemy;
    bLookingForLoudNoise      = bLoudNoise;
    bLookingForAlarm          = bAlarm;
    bLookingForDistress       = bDistress;
    bLookingForProjectiles    = bProjectile;
    bLookingForFutz           = bFutz;
    bLookingForHacking        = bHacking;
    bLookingForShot           = bShot;
    bLookingForWeapon         = bWeapon;
    bLookingForCarcass        = bCarcass;
    bLookingForInjury         = bInjury;
    bLookingForIndirectInjury = bIndirectInjury;

//  UpdateReactionCallbacks();
}


// ----------------------------------------------------------------------
// BlockReactions()
// ----------------------------------------------------------------------

function BlockReactions(optional bool bBlockInjury)
{
    SetReactions(false, false, false, false, false, false, false, false, false, false, !bBlockInjury, !bBlockInjury);
}


// ----------------------------------------------------------------------
// ResetReactions()
// ----------------------------------------------------------------------

function ResetReactions()
{
    SetReactions(true, true, true, true, true, true, true, true, true, true, true, true);
}

// ----------------------------------------------------------------------
// ShouldBeStartled()  [stub function, overridden by subclasses]
// ----------------------------------------------------------------------

function bool ShouldBeStartled(Pawn startler)
{
  return false;
}


// ----------------------------------------------------------------------
// ShouldPlayTurn()
// ----------------------------------------------------------------------

function bool ShouldPlayTurn(vector lookdir)
{
  local Rotator rot;

  rot = Rotator(lookdir);
  rot.Yaw = (rot.Yaw - Rotation.Yaw) & 65535;
  if (rot.Yaw > 32767)
    rot.Yaw = 65536 - rot.Yaw;  // negate
  if (rot.Yaw > 4096)
    return true;
  else
    return false;
}


// ----------------------------------------------------------------------
// ShouldPlayWalk()
// ----------------------------------------------------------------------

function bool ShouldPlayWalk(vector movedir)
{
  local vector diff;

  if (Physics == PHYS_Falling)
    return true;
  else if (Physics == PHYS_Walking)
  {
    diff = (movedir - Location) * vect(1,1,0);
    if (VSize(diff) < 16)
      return false;
    else
      return true;
  }
  else if (VSize(movedir-Location) < 16)
    return false;
  else
    return true;
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// ALLIANCE ROUTINES
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// SetAlliance()
// ----------------------------------------------------------------------
function SetAlliance(Name newAlliance)
{
    Alliance = newAlliance;
}

// ----------------------------------------------------------------------
// ChangeAlly()
// ----------------------------------------------------------------------
function ChangeAlly(Name newAlly, optional float allyLevel, optional bool bPermanent, optional bool bHonorPermanence)
{
    local int i;

   // log(self@Alliance@".ChangeAlly -- newAlly = "$newAlly$" allyLevel = "$allyLevel $" bPermanent? ="@bPermanent);

    // Members of the same alliance will ALWAYS be friendly to each other
    if (newAlly == Alliance)
    {
        allyLevel  = 1;
        bPermanent = true;
    }

    if (bHonorPermanence)
    {
        for (i=0; i<16; i++)
            if (AlliancesEx[i].AllianceName == newAlly)
                if (AlliancesEx[i].bPermanent)
                    break;
        if (i < 16)
            return;
    }

    if (allyLevel < -1)
        allyLevel = -1;
    if (allyLevel > 1)
        allyLevel = 1;

    for (i=0; i<16; i++)
        if ((AlliancesEx[i].AllianceName == newAlly) || (AlliancesEx[i].AllianceName == ''))
            break;

    if (i >= 16)
        for (i=15; i>0; i--)
            AlliancesEx[i] = AlliancesEx[i-1];

    AlliancesEx[i].AllianceName         = newAlly;
    AlliancesEx[i].AllianceLevel        = allyLevel;
    AlliancesEx[i].AgitationLevel       = 0;
    AlliancesEx[i].bPermanent           = bPermanent;

    bAlliancesChanged    = True;
    bNoNegativeAlliances = False;
}


// ----------------------------------------------------------------------
// AgitateAlliance()
// ----------------------------------------------------------------------
function AgitateAlliance(Name newEnemy, float agitation)
{
    local int   i;
    local float oldLevel;
    local float newLevel;

    if (newEnemy != '')
    {
        for (i=0; i<16; i++)
            if ((AlliancesEx[i].AllianceName == newEnemy) || (AlliancesEx[i].AllianceName == ''))
                break;

        if (i < 16)
        {
            if ((AlliancesEx[i].AllianceName == '') || !(AlliancesEx[i].bPermanent))
            {
                if (AlliancesEx[i].AllianceName == '')
                    AlliancesEx[i].AllianceLevel = 0;
                oldLevel = AlliancesEx[i].AgitationLevel;
                newLevel = oldLevel + agitation;
                if (newLevel > 1.0)
                    newLevel = 1.0;
                AlliancesEx[i].AllianceName   = newEnemy;
                AlliancesEx[i].AgitationLevel = newLevel;
                if ((newEnemy == 'Player') && (oldLevel < 1.0) && (newLevel >= 1.0))  // hack
                    PlayerAgitationTimer = 2.0;
                bAlliancesChanged = True;
            }
        }
    }
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// ATTACKING FUNCTIONS
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// AISafeToShoot()
// ----------------------------------------------------------------------
function bool AISafeToShoot(out Actor hitActor, vector traceEnd, vector traceStart,optional vector extent, optional bool bIgnoreLevel) //
{
    local Actor            traceActor;
    local Vector           hitLocation;
    local Vector           hitNormal;
    local DeusExPawn       tracePawn;
    local DeusExDecoration traceDecoration;
    local DeusExMover      traceMover;
    local bool             bSafe;

    // Future improvement:
    // Ideally, this should use the ammo type to determine how many shots
    // it will take to destroy an obstruction, and call it unsafe if it takes
    // more than x shots.  Also, if the ammo is explosive, and the
    // obstruction is too close, it should never be safe...

    bSafe    = true;
    hitActor = None;

    foreach TraceActors(Class'Actor', traceActor, hitLocation, hitNormal,traceEnd, traceStart, extent)
    {
        if (hitActor == None)
            hitActor = traceActor;
        if (traceActor == Level)
        {
            if (!bIgnoreLevel)
                bSafe = false;
            break;
        }
        tracePawn = DeusExPawn(traceActor);
        if (tracePawn != None)
        {
            if (tracePawn != self)
            {
                if (GetPawnAllianceType(tracePawn) == ALLIANCE_Friendly)
                    bSafe = false;
                break;
            }
        }
        traceDecoration = DeusExDecoration(traceActor);
        if (traceDecoration != None)
        {
            if (traceDecoration.bExplosive || traceDecoration.bInvincible)
            {
                bSafe = false;
                break;
            }
            if ((traceDecoration.HitPoints > 20) || (traceDecoration.minDamageThreshold > 4))  // hack
            {
                bSafe = false;
                break;
            }
        }
        traceMover = DeusExMover(traceActor);
        if (traceMover != None)
        {
            if (!traceMover.bBreakable)
            {
                bSafe = false;
                break;
            }
            else if ((traceMover.doorStrength > 0.2) || (traceMover.minDamageThreshold > 8))  // hack
            {
                bSafe = false;
                break;
            }
            else  // hack
                break;
        }
        if (Inventory(traceActor) != None)
        {
            bSafe = false;
            break;
        }
    }
    return (bSafe);
}



// ----------------------------------------------------------------------
// ComputeThrowAngles()
// ----------------------------------------------------------------------
function bool ComputeThrowAngles(vector traceEnd, vector traceStart,float speed,out Rotator angle1, out Rotator angle2)
{
    local float   deltaX, deltaY;
    local float   x, y;
    local float   tanAngle1, tanAngle2;
    local float   A, B, C;
    local float   m, n;
    local float   sqrtTerm;
    local float   gravity;
//  local float   traceYaw;
    local bool    bValid;

    bValid = false;

    // Reduce our problem to two dimensions
    deltaX = traceEnd.X - traceStart.X;
    deltaY = traceEnd.Y - traceStart.Y;
    x = sqrt(deltaX*deltaX + deltaY*deltaY);
    y = traceEnd.Z - traceStart.Z;

    gravity = -PhysicsVolume.Gravity.Z;
    if ((x > 0) && (gravity > 0))
    {
        A = -gravity*x*x;
        B = 2*speed*speed*x;
        C = -gravity*x*x - 2*y*speed*speed;

        sqrtTerm = B*B - 4*A*C;
        if (sqrtTerm >= 0)
        {
            m = -B/(2*A);
            n = sqrt(sqrtTerm)/(2*A);

            tanAngle1 = atan(m+n, 1);
            tanAngle2 = atan(m-n, 1);

            angle1 = Rotator(traceEnd - traceStart);
            angle2 = angle1;
            angle1.Pitch = tanAngle1*32768/Pi;
            angle2.Pitch = tanAngle2*32768/Pi;

            bValid = true;
        }
    }

    return bValid;
}
/*
so in your case:

tanAngle1 = atan(m+n, 1);
tanAngle2 = atan(m-n, 1);

also consider this:

m = -B;
n = sqrt(sqrtTerm);
// Declare a new variable
o = 2 * A;

tanAngle1 = atan(m + n, o);
tanAngle2 = atan(m - n, o);
*/

// ----------------------------------------------------------------------
// AISafeToThrow()
// ----------------------------------------------------------------------
function bool AISafeToThrow(vector traceEnd, vector traceStart, float throwAccuracy,optional vector extent)
{
    local float                   time1, time2, tempTime;
    local vector                  pos1,  pos2,  tempPos;
    local rotator                 rot1,  rot2,  tempRot;
    local rotator                 bestAngle;
    local bool                    bSafe;
    local DeusExWeapon         dxWeapon;
    local Class<ThrownProjectile> throwClass;

    // Someday, we should check for nearby friendlies within the blast radius
    // before throwing...

    // Sanity checks
    throwClass = None;
    dxWeapon = DeusExWeapon(Weapon);

    if (dxWeapon != None)
        throwClass = class<ThrownProjectile>(dxWeapon.ProjectileClass);
    if (throwClass == None)
        return false;

    if (extent == vect(0,0,0))
    {
        extent = vect(1,1,0) * throwClass.default.CollisionRadius;
        extent.Z = throwClass.default.CollisionHeight;
    }

    if (throwAccuracy < 0.01)
        throwAccuracy = 0.01;

    bSafe = false;
    if (ComputeThrowAngles(traceEnd, traceStart, dxWeapon.ProjectileSpeed, rot1, rot2))
    {
        time1 = ParabolicTrace(pos1, Vector(rot1)*dxWeapon.ProjectileSpeed, traceStart,true, extent, 5.0,throwClass.Default.Elasticity, throwClass.Default.bBounce,60, throwAccuracy);
        time2 = ParabolicTrace(pos2, Vector(rot2)*dxWeapon.ProjectileSpeed, traceStart,true, extent, 5.0,throwClass.Default.Elasticity, throwClass.Default.bBounce,60, throwAccuracy);
        if ((time1 > 0) || (time2 > 0))
        {
            if ((time1 > time2) && (time2 > 0))
            {
                tempTime = time1;
                time1    = time2;
                time2    = tempTime;
                tempPos  = pos1;
                pos1     = pos2;
                pos2     = tempPos;
                tempRot  = rot1;
                rot1     = rot2;
                rot2     = tempRot;
            }
            if (VSize(pos1-traceEnd) <= throwClass.Default.blastRadius)
            {
                if (FastTrace(traceEnd, pos1))
                {
                    if ((VSize(pos1-Location) > throwClass.Default.blastRadius*0.5) || !FastTrace(Location, pos1))
                    {
                        bestAngle = rot1;
                        bSafe     = true;
                    }
                }
            }
        }
        if (!bSafe && (time2 > 0))
        {
            if (VSize(pos2-traceEnd) <= throwClass.Default.blastRadius)
            {
                if (FastTrace(traceEnd, pos2))
                {
                    if ((VSize(pos2-Location) > throwClass.Default.blastRadius*0.5) ||
                        !FastTrace(Location, pos2))
                    {
                        bestAngle = rot2;
                        bSafe     = true;
                    }
                }
            }
        }
    }

    if (bSafe)
        SetViewRotation(bestAngle);

    return (bSafe);
}

// ----------------------------------------------------------------------
// AICanShoot()
// ----------------------------------------------------------------------
function bool AICanShoot(DeusExPawn target, bool bLeadTarget, bool bCheckReadiness,optional float throwAccuracy, optional bool bDiscountMinRange)
{
    local DeusExWeapon dxWeapon;
    local Vector X, Y, Z;
    local Vector projStart, projEnd;
    local float  tempMinRange, tempMaxRange;
    local float  temp;
    local float  dist;
    local float  extraDist;
    local actor  hitActor;
//  local Vector hitLocation, hitNormal;
    local Vector extent;
    local bool   bIsThrown;
    local float  elevation;
    local bool   bSafe;

    if (target == None)
        return false;
    if (target.bIgnore)
        return false;

    dxWeapon = DeusExWeapon(Weapon);
    if (dxWeapon == None)
        return false;
    if (bCheckReadiness && !dxWeapon.bReadyToFire)
        return false;

    if (dxWeapon.ReloadCount > 0)
    {
        if (dxWeapon.AmmoType == None)
            return false;
        if (dxWeapon.AmmoType.AmmoAmount <= 0)
            return false;
    }
    if (FireElevation > 0)
    {
        elevation = FireElevation + (CollisionHeight+target.CollisionHeight);
        if (elevation < 10)
            elevation = 10;
        if (Abs(Location.Z-target.Location.Z) > elevation)
            return false;
    }
    bIsThrown = IsThrownWeapon(dxWeapon);

    extraDist = target.CollisionRadius;
    //extraDist = 0;

    GetPawnWeaponRanges(self, tempMinRange, tempMaxRange, temp);

    if (bDiscountMinRange)
        tempMinRange = 0;

    if (tempMinRange >= tempMaxRange)
        return false;

 SetViewRotation(Rotation);//
    GetAxes(GetViewRotation(), X, Y, Z);
    projStart = dxWeapon.ComputeProjectileStart(X, Y, Z);
    if (bLeadTarget && !dxWeapon.bInstantHit && (dxWeapon.ProjectileSpeed > 0))
    {
        if (bIsThrown)
        {
            // compute target's position 1.5 seconds in the future
            projEnd = target.Location + (target.Velocity*1.5);
        }
        else
        {
            // projEnd = target.Location + (target.Velocity*dist/dxWeapon.ProjectileSpeed);
            if (!ComputeTargetLead(target, projStart, dxWeapon.ProjectileSpeed, 5.0, projEnd))
                return false;
        }
    }
    else
        projEnd = target.Location;

    if (bIsThrown)
        projEnd += vect(0,0,-1)*(target.CollisionHeight-5);

    dist = VSize(projEnd - Location);
    if (dist < 0)
        dist = 0;

    if ((dist < tempMinRange) || (dist-extraDist > tempMaxRange))
        return false;

    if (!bIsThrown)
    {
        bSafe = FastTrace(target.Location, projStart);
        if (!bSafe && target.controller.bIsPlayer)  // players only... hack
        {
            projEnd += vect(0,0,1)*target.BaseEyeHeight;
            bSafe = FastTrace(target.Location + vect(0,0,1)*target.BaseEyeHeight, projStart);
        }
        if (!bSafe)
            return false;
    }

    if (dxWeapon.bInstantHit)
        return (AISafeToShoot(hitActor, projEnd, projStart, , true));
    else
    {
        extent.X = dxWeapon.ProjectileClass.default.CollisionRadius;
        extent.Y = dxWeapon.ProjectileClass.default.CollisionRadius;
        extent.Z = dxWeapon.ProjectileClass.default.CollisionHeight;
        if (bIsThrown && (throwAccuracy > 0))
            return (AISafeToThrow(projEnd, projStart, throwAccuracy,extent));
        else
            return (AISafeToShoot(hitActor, projEnd, projStart, extent*3));
    }
}

// ----------------------------------------------------------------------
// ComputeTargetLead()
// ----------------------------------------------------------------------
function bool ComputeTargetLead(pawn target, vector projectileStart,float projectileSpeed,float maxTime,out Vector hitPos)
{
    local vector targetLoc;
    local vector targetVel;
    local float  termA, termB, termC;
    local float  temp;
    local float  aBase, range;
    local float  time1, time2;
    local bool   bSuccess;

    bSuccess = true;

    targetLoc = target.Location - projectileStart;
    targetVel = target.Velocity;
    if (target.Physics == PHYS_Falling)
        targetVel.Z = 0;

    // Given a target position and velocity, and a projectile speed,
    // compute the position at which a projectile will hit the
    // target if the target continues at its current velocity

    // (Warning: messy computations follow.  I can't believe I remembered
    // enough algebra to figure this out on my own... :)

    termA = targetVel.X*targetVel.X +
            targetVel.Y*targetVel.Y +
            targetVel.Z*targetVel.Z -
            projectileSpeed*projectileSpeed;
    termB = 2*targetLoc.X*targetVel.X +
            2*targetLoc.Y*targetVel.Y +
            2*targetLoc.Z*targetVel.Z;
    termC = targetLoc.X*targetLoc.X +
            targetLoc.Y*targetLoc.Y +
            targetLoc.Z*targetLoc.Z;

    if ((termA < 0.000001) && (termA > -0.000001))  // avoid divide-by-zero errors...
        termA = 0.000001;  // fudge a little when velocities are equal
    temp = termB*termB - 4*termA*termC;
    if (temp < 0)
        bSuccess = false;

    if (bSuccess)
    {
        aBase = -termB/(2*termA);
        range = sqrt(temp)/(2*termA);
        time1 = aBase + range;
        time2 = aBase - range;
        if ((time1 > time2) || (time1 < 0))  // best time first
            time1 = time2;
        if ((time1 < 0) || (time1 >= maxTime))
            bSuccess = false;
    }

    if (bSuccess)
        hitPos = target.Location + target.Velocity*time1;

    return (bSuccess);

}

// ----------------------------------------------------------------------
// GetPawnWeaponRanges()
// ----------------------------------------------------------------------
function GetPawnWeaponRanges(DeusExPawn other, out float minRange, out float maxAccurateRange, out float maxRange)
{
    local DeusExWeapon         pawnWeapon;
//  local class<DeusExProjectile> projectileClass;

    pawnWeapon = DeusExWeapon(other.Weapon);
    if (pawnWeapon != None)
    {
        pawnWeapon.GetWeaponRanges(minRange, maxAccurateRange, maxRange);
        if (IsThrownWeapon(pawnWeapon))  // hack
            minRange = 0;
    }
    else
    {
        minRange         = 0;
        maxAccurateRange = other.CollisionRadius;
        maxRange         = maxAccurateRange;
    }

    if (maxAccurateRange > maxRange)
        maxAccurateRange = maxRange;
    if (minRange > maxRange)
        minRange = maxRange;
}

// ----------------------------------------------------------------------
// GetWeaponBestRange()
// ----------------------------------------------------------------------
function GetWeaponBestRange(DeusExWeapon dxWeapon, out float bestRangeMin, out float bestRangeMax)
{
    local float temp;
    local float minRangeA,   maxRangeA;
    local float AIMinRange, AIMaxRange;

    if (dxWeapon != None)
    {
        dxWeapon.GetWeaponRanges(minRangeA, maxRangeA, temp);
        if (IsThrownWeapon(dxWeapon))  // hack
            minRange = 0;
        AIMinRange = dxWeapon.AIMinRange;
        AIMaxRange = dxWeapon.AIMaxRange;

        if ((AIMinRange > 0) && (AIMinRange >= minRangeA) && (AIMinRange <= maxRangeA))
            bestRangeMin = AIMinRange;
        else
            bestRangeMin = minRange;
        if ((AIMaxRange > 0) && (AIMaxRange >= minRangeA) && (AIMaxRange <= maxRangeA))
            bestRangeMax = AIMaxRange;
        else
            bestRangeMax = maxRangeA;

        if (bestRangeMin > bestRangeMax)
            bestRangeMin = bestRangeMax;
    }
    else
    {
        bestRangeMin = 0;
        bestRangeMax = 0;
    }
}

function bool CheckEnemyPresence(float deltaSeconds,bool bCheckPlayer,bool bCheckOther)
{
    local int          i;
    local int          count;
    local int          checked;
    local DeusExPawn   candidate;
    local float        candidateDist;
    local bool         bCanSee;
    local int          lastCycle;
    local float        aVisibility;
    local DeusExPawn   cycleEnemy;
    local bool         bValid;
    local bool         bPlayer;
    local bool         bValidEnemy;
    local bool         bPotentialEnemy;
    local bool         bCheck;

//if (Name != 'Terrorist23')
//    return false;

//    log(self@"CheckEnemyPresence(bCheckPlayer? "$bCheckPlayer @ "bCheckOther? "$bCheckOther);

    if (DistanceFromPlayer() >= 1200 /*SKIP_ENEMY_DISTANCE*/)
        return false;

    bValid  = false;
    bCanSee = false;

//    log(self@"bReactPresence? bLookingForEnemy? bNoNegativeAlliances? "$bReactPresence @ bLookingForEnemy @ bNoNegativeAlliances);

    if (bReactPresence && bLookingForEnemy && !bNoNegativeAlliances)
    {
        if (PotentialEnemyAlliance != '')
            bCheck = true;
        else
        {
            for (i=0; i<16; i++)
                if ((AlliancesEx[i].AllianceLevel < 0) || (AlliancesEx[i].AgitationLevel >= 1.0))
                    break;
            if (i < 16)
                bCheck = true;
        }
//        log(self@"bCheck? "$bCheck);

        if (bCheck)
        {
            bValid       = true;
            CyclePeriod += deltaSeconds;
            count        = 0;
            checked      = 0;
            lastCycle    = CycleIndex;
            foreach CycleActors(class'DeusExPawn', candidate, CycleIndex)
            {
                bValidEnemy = IsValidEnemy(candidate);

//                log(self@"candidate = "$candidate @"CycleIndex = "$ CycleIndex $ " bValidEnemy? "$bValidEnemy);//

                if (!bValidEnemy && (PotentialEnemyTimer > 0))
                    if (PotentialEnemyAlliance == candidate.Alliance)
                        bPotentialEnemy = true;
                if (bValidEnemy || bPotentialEnemy)
                {
                    count++;
                    bPlayer = candidate.IsA('PlayerPawn');
                    if ((bPlayer && bCheckPlayer) || (!bPlayer && bCheckOther))
                    {
//                        aVisibility = AICanSee(candidate, ComputeActorVisibility(candidate), true, true, true, true);
                        aVisibility = AICanSee(candidate, ComputeActorVisibility(candidate), true, true, true, true);
                        if (aVisibility > 0)
                        {
                            if (bPotentialEnemy)  // We can see the potential enemy; ergo, we hate him
                            {
                                IncreaseAgitation(candidate, 1.0);
                                PotentialEnemyAlliance = '';
                                PotentialEnemyTimer    = 0;
                                bValidEnemy = IsValidEnemy(candidate);
                            }
                            if (bValidEnemy)
                            {
                                aVisibility += VisibilityThreshold;
                                candidateDist = VSize(Location-candidate.Location);
                                if ((CycleCandidate == None) || (CycleDistance > candidateDist))
                                {
                                    CycleCandidate = candidate;
                                    CycleDistance  = candidateDist;
                                }
                                if (!bPlayer)
                                    CycleCumulative += 100000;  // a bit of a hack...
                                else
                                    CycleCumulative += aVisibility;
                            }
                        }
                    }
                    if (count >= 1)
                        break;
                }
                checked++;
                if (checked > 20)  // hacky hardcoded number
                    break;
            }
            if (lastCycle >= CycleIndex)  // have we cycled through all actors?
            {
                cycleEnemy = CheckCycle();
                if (cycleEnemy != None)
                {
                    SetDistressTimer();
                    SetEnemy(cycleEnemy, 0, true);
                    bCanSee = true;
                }
            }
        }
        else
            bNoNegativeAlliances = True;
    }

    // Handle surprise levels...
    if (Controller != None) // DXR: To avoid SpamLog (whem pawn is in Dying state and has no controller)
        UpdateReactionLevel((EnemyReadiness > 0) || (controller.GetStateName() == 'Seeking') || bDistressed, deltaSeconds);

    if (!bValid)
    {
        CycleCumulative = 0;
        CyclePeriod     = 0;
        CycleCandidate  = None;
        CycleDistance   = 0;
        CycleTimer      = 0;
    }

    return (bCanSee);

}


// ----------------------------------------------------------------------
// CheckEnemyParams()  [internal use only]
// ----------------------------------------------------------------------
function CheckEnemyParams(Pawn checkPawn,out Pawn bestPawn, out int bestThreatLevel, out float bestDist)
{
    local ScriptedPawn sPawn;
    local bool         bReplace;
    local float        dist;
    local int          threatLevel;
    local bool         bValid;

    bValid = IsValidEnemy(DeusExPawn(checkPawn));
    if (bValid && (Controller.Enemy != checkPawn))
    {
        // Honor cloaking, radar transparency, and other augs if this guy isn't our current enemy
        if (ComputeActorVisibility(checkPawn) < 0.1)
            bValid = false;
    }

    if (bValid)
    {
        sPawn = ScriptedPawn(checkPawn);

        dist = VSize(checkPawn.Location - Location);
        if (checkPawn.IsA('Robot'))
            dist *= 0.5;  // arbitrary
        if (Controller.Enemy == checkPawn)
            dist *= 0.75;  // arbitrary

        if (sPawn != None)
        {
            if (sPawn.bAttacking)
            {
                if (sPawn.Controller.Enemy == self)
                    threatLevel = 2;
                else
                    threatLevel = 1;
            }
            else if (sPawn.Controller.GetStateName() == 'Alerting')
                threatLevel = 3;
            else if ((sPawn.Controller.GetStateName() == 'Fleeing') || (sPawn.Controller.GetStateName() == 'Burning'))
                threatLevel = 0;
            else if (sPawn.Weapon != None)
                threatLevel = 1;
            else
                threatLevel = 0;
        }
        else  // player
        {
            if (checkPawn.Weapon != None)
                threatLevel = 2;
            else
                threatLevel = 1;
        }

        bReplace = false;
        if (bestPawn == None)
            bReplace = true;
        else if (bestThreatLevel < threatLevel)
            bReplace = true;
        else if (bestDist > dist)
            bReplace = true;

        if (bReplace)
        {
            if (((Controller.Enemy == checkPawn)) || (AICanSee(checkPawn, , false, false, true, true) > 0))
            {
                bestPawn        = checkPawn;
                bestThreatLevel = threatLevel;
                bestDist        = dist;
            }
        }
    }

}

// ----------------------------------------------------------------------
// FindBestEnemy()
//               if ((npc != None) && (npc.Controller != none) && (VSize(npc.Location - Location) < (1600 + npc.CollisionRadius)))
//BEST_ENEMY_CHECK_RADIUS
// ----------------------------------------------------------------------
function FindBestEnemy(bool bIgnoreCurrentEnemy)
{
    local Pawn  nextPawn;
    local Pawn  bestPawn;
    local float bestDist;
    local int   bestThreatLevel;
    local float newSeenTime;
//    local Controller K;

    bestPawn        = None;
    bestDist        = 0;
    bestThreatLevel = 0;

    if (!bIgnoreCurrentEnemy && (Controller.Enemy != None))
        CheckEnemyParams(Controller.Enemy, bestPawn, bestThreatLevel, bestDist);

    foreach RadiusActors(Class'Pawn', nextPawn, 2000)  // arbitrary
        if (Controller.enemy != nextPawn)
            CheckEnemyParams(nextPawn, bestPawn, bestThreatLevel, bestDist);

/*    for (K=Level.ControllerList; K!=None; K=K.NextController)
    {
       if (K.Pawn != None)
           if (VSize(K.Location - Location) < BEST_ENEMY_CHECK_RADIUS + K.Pawn.CollisionRadius)
               nextPawn = K.Pawn;
    }*/
       if (Controller.enemy != nextPawn)
           CheckEnemyParams(nextPawn, bestPawn, bestThreatLevel, bestDist);


    if (bestPawn != Controller.Enemy)
        newSeenTime = 0;
    else
        newSeenTime = EnemyLastSeen;

    SetEnemy(bestPawn, newSeenTime, true);

//    log(self@"FindBestEnemy = "$bestPawn);

    EnemyTimer = 0;
}




// ----------------------------------------------------------------------
// ShouldStrafe()
// ----------------------------------------------------------------------
function bool ShouldStrafe()
{
    // This may be overridden from subclasses
    //return (AICanSee(enemy, 1.0, false, true, true, true) > 0);
    return (AICanShoot(DeusExPawn(controller.enemy), false, false, 0.025, true));
}

// ----------------------------------------------------------------------
// ShouldFlee()
// ----------------------------------------------------------------------
function bool ShouldFlee()
{
    // This may be overridden from subclasses
    if (MinHealth > 0)
    {
        if (Health <= MinHealth)
            return true;
        else if (HealthArmLeft <= 0)
            return true;
        else if (HealthArmRight <= 0)
            return true;
        else if (HealthLegLeft <= 0)
            return true;
        else if (HealthLegRight <= 0)
            return true;
        else
            return false;
    }
    else
        return false;
}

// ----------------------------------------------------------------------
// ShouldDropWeapon()
// ----------------------------------------------------------------------
function bool ShouldDropWeapon()
{
    if (((HealthArmLeft <= 0) || (HealthArmRight <= 0)) && (Health > 0))
        return true;
    else
        return false;
}

// ----------------------------------------------------------------------
// TryLocation()
// ----------------------------------------------------------------------
function bool TryLocation(out vector position, optional float minDist, optional bool bTraceActors,optional NearbyProjectileList projList)
{
    local float   magnitude;
    local vector  normalPos;
    local Rotator rot;
    local bool    bSuccess;

    normalPos = position-Location;
    magnitude = VSize(normalPos);
    if (minDist > magnitude)
        minDist = magnitude;
    rot = Rotator(position-Location);
    bSuccess = AIDirectionReachable(Location, rot.Yaw, rot.Pitch, minDist, magnitude, position);

    if (bSuccess)
    {
        if (bDefendHome && !IsNearHome(position))
            bSuccess = false;
        else if (bAvoidHarm && IsLocationDangerous(projList, position))
            bSuccess = false;
    }

    return (bSuccess);
}



// ----------------------------------------------------------------------
// ComputeBestFiringPosition()
// ----------------------------------------------------------------------
function EDestinationType ComputeBestFiringPosition(out vector newPosition)
{
    local float            selfMinRange, selfMaxRange;
    local float            enemyMinRange, enemyMaxRange;
    local float            temp;
    local float            dist;
    local float            innerRange[2], outerRange[2];
    local Rotator          aRelativeRotation;
    local float            hAngle;//, vAngle;
    local int              acrossDist;
    local float            awayDist;
    local float            extraDist;
    local float            fudgeMargin;
    local int              angle;
    local float            maxDist;
//  local float            distDelta;
    local bool             bInnerValid, bOuterValid;
    local vector           tryVector;
    local EDestinationType destType;
    local float            moveMult;
    local float            reloadMult;
    local float            minArea;
    local float            minDist;
    local float            range;
    local float            margin;

    local NearbyProjectileList projList;
    local vector               projVector;
    local bool                 bUseProjVector;

    local rotator              sprintRot;
    local vector               sprintVect;
    local bool                 bUseSprint;

    // over 9000 !! IDK why.
//  log("ComputeBestFiringPosition() called! ",'ComputeBestFiringPosition');

    destType = DEST_Failure;

    extraDist   = controller.enemy.CollisionRadius*0.5;
    fudgeMargin = 100;
    minArea     = 35;

    GetPawnWeaponRanges(self, selfMinRange, selfMaxRange, temp);
    GetPawnWeaponRanges(DeusExPawn(controller.enemy), enemyMinRange, temp, enemyMaxRange);

    if (selfMaxRange > 1200)
        selfMaxRange = 1200;
    if (enemyMaxRange > 1200)
        enemyMaxRange = 1200;

    // hack, to prevent non-strafing NPCs from trying to back up
    if (!bCanStrafe)
        selfMinRange  = 0;

    minDist = controller.enemy.CollisionRadius + CollisionRadius - (extraDist+1);
    if (selfMinRange < minDist)
        selfMinRange = minDist;
    if (selfMinRange < MinRange)
        selfMinRange = MinRange;
    if (selfMaxRange > MaxRange)
        selfMaxRange = MaxRange;

    dist = VSize(controller.enemy.Location - Location);

    innerRange[0] = selfMinRange;
    innerRange[1] = selfMaxRange;
    outerRange[0] = selfMinRange;
    outerRange[1] = selfMaxRange;

    // hack, to prevent non-strafing NPCs from trying to back up

    if (selfMaxRange > enemyMinRange)
        innerRange[1] = enemyMinRange;
    if ((selfMinRange < enemyMaxRange) && bCanStrafe)  // hack, to prevent non-strafing NPCs from trying to back up
        outerRange[0] = enemyMaxRange;

    range = outerRange[1]-outerRange[0];
    if (range < minArea)
    {
        outerRange[0] = 0;
        outerRange[1] = 0;
    }
    range = innerRange[1]-innerRange[0];
    if (range < minArea)
    {
        innerRange[0] = outerRange[0];
        innerRange[1] = outerRange[1];
        outerRange[0] = 0;
        outerRange[1] = 0;
    }

    // If the enemy can reach us through our entire weapon range, just use the range
    if ((innerRange[0] >= innerRange[1]) && (outerRange[0] >= outerRange[1]))
    {
        innerRange[0] = selfMinRange;
        innerRange[1] = selfMaxRange;
    }

    innerRange[0] += extraDist;
    innerRange[1] += extraDist;
    outerRange[0] += extraDist;
    outerRange[1] += extraDist;

    if (innerRange[0] >= innerRange[1])
        bInnerValid = false;
    else
        bInnerValid = true;
    if (outerRange[0] >= outerRange[1])
        bOuterValid = false;
    else
        bOuterValid = true;

    if (!bInnerValid)
    {
        // ugly
        newPosition = Location;
//      return DEST_SameLocation;
        return destType;
    }

    aRelativeRotation = Rotator(Location - controller.enemy.Location);

    hAngle = (aRelativeRotation.Yaw - controller.enemy.Rotation.Yaw) & 65535;
    if (hAngle > 32767)
        hAngle -= 65536;
    // ignore vertical angle for now

    awayDist   = dist;
    acrossDist = 0;
    maxDist    = GroundSpeed*0.6;  // distance covered in 6/10 second

    if (bInnerValid)
    {
        margin = (innerRange[1]-innerRange[0]) * 0.5;
        if (margin > fudgeMargin)
            margin = fudgeMargin;
        if (awayDist < innerRange[0])
            awayDist = innerRange[0]+margin;
        else if (awayDist > innerRange[1])
            awayDist = innerRange[1]-margin;
    }
    if (bOuterValid)
    {
        margin = (outerRange[1]-outerRange[0]) * 0.5;
        if (margin > fudgeMargin)
            margin = fudgeMargin;
        if (awayDist > outerRange[1])
            awayDist = outerRange[1]-margin;
    }

    if (awayDist > dist+maxDist)
        awayDist = dist+maxDist;
    if (awayDist < dist-maxDist)
        awayDist = dist-maxDist;

    // Used to determine whether NPCs should sprint/avoid aim
    moveMult = 1.0;
    if ((dist <= 180) && controller.enemy.IsA('PlayerPawn') /*controller.bIsPlayer*/ && (controller.enemy.Weapon != None) && (enemyMaxRange < 180))
        moveMult = CloseCombatMult;

    if (bAvoidAim && !controller.enemy.bIgnore && (FRand() <= AvoidAccuracy * moveMult))
    {
        if ((awayDist < enemyMaxRange+maxDist+50) && (awayDist < 800) && (controller.Enemy.Weapon != None))
        {
            if (dist > 0)
                angle = int(atan(CollisionRadius*2.0/dist,1)*32768/Pi);
            else
                angle = 16384;

            if ((hAngle >= -angle) && (hAngle <= angle))
            {
                if (hAngle < 0)
                    acrossDist = (-angle-hAngle)-128;
                else
                    acrossDist = (angle-hAngle)+128;
                if (Rand(20) == 0)
                    acrossDist = -acrossDist;
            }
        }
    }

// projList is implicitly initialized to null...

    bUseProjVector = false;
    if (bAvoidHarm && (FRand() <= HarmAccuracy))
    {
        if (GetProjectileList(projList, Location) > 0)
        {
            if (IsLocationDangerous(projList, Location))
            {
                projVector = ComputeAwayVector(projList);
                bUseProjVector = true;
            }
        }
    }

    reloadMult = 1.0;
    if (IsWeaponReloading() && controller.Enemy.IsA('PlayerPawn') /*controller.bIsPlayer*/)
        reloadMult = 0.5;

    bUseSprint = false;
    if (!bUseProjVector && bSprint && bCanStrafe && !controller.enemy.bIgnore && (FRand() <= SprintRate * 0.5 * moveMult * reloadMult))
    {
        if (bOuterValid || (innerRange[1] > 100))  // sprint on long-range weapons only
        {
            sprintRot = Rotator(controller.enemy.Location - Location);
            if (Rand(2) == 1)
                sprintRot.Yaw += 16384;
            else
                sprintRot.Yaw += 49152;
            sprintRot = RandomBiasedRotation(sprintRot.Yaw, 0.5, 0, 0);
            sprintRot.Pitch = 0;
            sprintVect = Vector(sprintRot)*GroundSpeed*(FRand()+0.5);
            bUseSprint = true;
        }
    }

    if ((acrossDist != 0) || (awayDist != dist) || bUseProjVector || bUseSprint)
    {
        if (Rand(40) != 0)
        {
            if ((destType == DEST_Failure) && bUseProjVector)
            {
                tryVector = projVector + Location;
                if (TryLocation(tryVector, CollisionRadius+16))
                    destType = DEST_NewLocation;
            }
            if ((destType == DEST_Failure) && (acrossDist != 0) && (awayDist != dist))
            {
                tryVector = Vector(aRelativeRotation+(rot(0, 1, 0)*acrossDist)) * awayDist + controller.enemy.Location;
                if (TryLocation(tryVector, CollisionRadius+16, , projList))
                    destType = DEST_NewLocation;
            }
            if ((destType == DEST_Failure) && (awayDist != dist))
            {
                tryVector = Vector(aRelativeRotation)*awayDist + controller.enemy.Location;
                if (TryLocation(tryVector, CollisionRadius+16, , projList))
                    destType = DEST_NewLocation;
            }
            if ((destType == DEST_Failure) && (acrossDist != 0))
            {
                tryVector = Vector(aRelativeRotation+(rot(0, 1, 0)*acrossDist))*dist + controller.enemy.Location;
                if (TryLocation(tryVector, CollisionRadius+16, , projList))
                    destType = DEST_NewLocation;
            }
            if ((destType == DEST_Failure) && bUseSprint)
            {
                tryVector = sprintVect + Location;
                if (TryLocation(tryVector, CollisionRadius+16))
                    destType = DEST_NewLocation;
            }
        }
        if (destType == DEST_Failure)
        {
            if ((moveMult >= 0.5) || (FRand() <= moveMult))
            {
                if (AIPickRandomDestination(CollisionRadius+16, maxDist,
                                            aRelativeRotation.Yaw+32768, 0.6, -aRelativeRotation.Pitch, 0.6, 2,
                                            0.9, tryVector))
                    if (!bDefendHome || IsNearHome(tryVector))
                        if (!bAvoidHarm || !IsLocationDangerous(projList, tryVector))
                            destType = DEST_NewLocation;
            }
            else
                destType = DEST_SameLocation;
        }
        if (destType != DEST_Failure)
        {
            newPosition = tryVector;
//               log("ComputeBestFiringPosition() NewPosition ="@newPosition);
        }
    }
    else
        destType = DEST_SameLocation;

    return destType;
}




// ----------------------------------------------------------------------
// SetAttackAngle()
//
// Sets the angle from which an asynchronous attack will occur
// (hack needed for DeusExWeapon)
// ----------------------------------------------------------------------

function SetAttackAngle()
{
    local bool bCanShoot;

    bCanShoot = false;
    if (Controller.Enemy != None)
        if (AICanShoot(DeusExPawn(Controller.Enemy), true, false, 0.025))
            bCanShoot = true;

    if (!bCanShoot)
        SetViewRotation(Rotation);
}




// ----------------------------------------------------------------------
// AdjustAim()
//
// Adjust the aim at target
// ----------------------------------------------------------------------
function rotator AdjustAim(float projSpeed, vector projStart, int aimerror, bool leadTarget, bool warnTarget)
{
    local rotator     FireRotation;
    local vector      FireSpot;
    local actor       HitActor;
    local vector      vectorArray[3];
    local vector      tempVector;
    local int         i;
    local bool        bIsThrown;
    local DeusExMover dxMover;
    local actor       Target;  // evil fix -- STM

    bIsThrown = IsThrownWeapon(DeusExWeapon(Weapon));

// took this line out for evil fix...
//  if ( Target == None )

    Target = Controller.Enemy;
    if ( Target == None )
        return Rotation;
    if ( !Target.IsA('Pawn') )
        return rotator(Target.Location - Location);

    FireSpot = Target.Location;
    if (leadTarget && (projSpeed > 0))
    {
        if (bIsThrown)
        {
            // compute target's position 1.5 seconds in the future
            FireSpot = target.Location + (target.Velocity*1.5);
        }
        else
        {
            //FireSpot += (Target.Velocity * VSize(Target.Location - ProjStart)/projSpeed);
            ComputeTargetLead(Pawn(Target), ProjStart, projSpeed, 20.0, FireSpot);
        }
    }

    if (bIsThrown)
    {
        vectorArray[0] = FireSpot - vect(0,0,1)*(Target.CollisionHeight-5);  // floor
        vectorArray[1] = vectorArray[0] + Vector(rot(0,1,0)*Rand(65536))*CollisionRadius*1.2;
        vectorArray[2] = vectorArray[0] + Vector(rot(0,1,0)*Rand(65536))*CollisionRadius*1.2;

        for (i=0; i<3; i++)
        {
            if (AISafeToThrow(vectorArray[i], ProjStart, 0.025))
                break;
        }
        if (i < 3)
        {
            FireSpot = vectorArray[i];
            FireRotation = GetViewRotation();
        }
        else
            FireRotation = Rotator(FireSpot - ProjStart);
    }
    else
    {
        dxMover = DeusExMover(Target.Base);
        if ((dxMover != None) && dxMover.bBreakable)
        {
            tempVector = Normal((Location-Target.Location)*vect(1,1,0))*(Target.CollisionRadius*1.01) - vect(0,0,1)*(Target.CollisionHeight*1.01);
            vectorArray[0] = FireSpot + tempVector;
        }
        else if (bAimForHead)
            vectorArray[0] = FireSpot + vect(0,0,1)*(Target.CollisionHeight*0.85);    // head
        else
            vectorArray[0] = FireSpot + vect(0,0,1)*((FRand()*2-1)*Target.CollisionHeight);
        vectorArray[1] = FireSpot + vect(0,0,1)*((FRand()*2-1)*Target.CollisionHeight);
        vectorArray[2] = FireSpot + vect(0,0,1)*((FRand()*2-1)*Target.CollisionHeight);

        for (i=0; i<3; i++)
        {
            if (AISafeToShoot(HitActor, vectorArray[i], ProjStart))
                break;
        }
        if (i < 3)
            FireSpot = vectorArray[i];

        FireRotation = Rotator(FireSpot - ProjStart);
    }

    if (warnTarget && Pawn(Target) != None)
        Pawn(Target).WarnTarget(self, projSpeed, vector(FireRotation)); 

    FireRotation.Yaw = FireRotation.Yaw & 65535;
    if ( (Abs(FireRotation.Yaw - (Rotation.Yaw & 65535)) > 8192)
        && (Abs(FireRotation.Yaw - (Rotation.Yaw & 65535)) < 57343) )
    {
        if ((FireRotation.Yaw > Rotation.Yaw + 32768) || ((FireRotation.Yaw < Rotation.Yaw) && (FireRotation.Yaw > Rotation.Yaw - 32768)))
            FireRotation.Yaw = Rotation.Yaw - 8192;
        else
            FireRotation.Yaw = Rotation.Yaw + 8192;
    }
    SetviewRotation(FireRotation);
    return FireRotation;
}




// ----------------------------------------------------------------------
// IsThrownWeapon()
// ----------------------------------------------------------------------
function bool IsThrownWeapon(DeusExWeapon testWeapon) //
{
/*  local Class<ThrownProjectile> throwClass;
    local bool                    bIsThrown;

    bIsThrown = false;
    if (testWeapon != None)
    {
        if (!testWeapon.bInstantHit)
        {
            throwClass = class<ThrownProjectile>(testWeapon.ProjectileClass);
            if (throwClass != None)
                bIsThrown = true;
        }
    }
    return bIsThrown;*/
    return TestWeapon.IsA('WeaponGrenade');
}

function bool InStasis()
{
   if ((DistanceFromPlayer() > 1200.0) && (LastRendered() > 5.0))
   return true;
   else return false;
//   return bStasis;
}


function HandleEnemy()
{
    Controller.SetState('HandlingEnemy', 'Begin');
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// CALLBACKS AND OVERRIDDEN FUNCTIONS
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------
event Tick(float deltaTime)
{
    local DeusExPlayer player;
    local name         stateName;
    local vector       loc;
    local bool         bDoLowPriority;
    local bool         bCheckOther;
    local bool         bCheckPlayer;

//    if (DistanceFromPlayer() > 2500)
//        return;

    if (!bInWorld)
    return;

    player = DeusExPlayer(GetPlayerPawn());
    myDxPlayer = player;

    Draw_DebugLine();

    animTimer[0] += deltaTime;
    animTimer[1] += deltaTime;
    animTimer[2] += deltaTime;

    if (DistanceFromPlayer() > 2500)
        return;

    bDoLowPriority = true;
    bCheckPlayer   = true;
    bCheckOther    = true;

    UpdateAgitation(deltaTime);
    UpdateFear(deltaTime);

    if (bTickVisibleOnly)
    {
        if (DistanceFromPlayer() > 1200)
            bDoLowPriority = false;
        if (DistanceFromPlayer() > 2500)
            bCheckPlayer = false;
        if ((DistanceFromPlayer() > 600) && (/*LastRenderTime*/LastRendered() >= 5.0))
            bCheckOther = false;
    }

    if ((DXRAIController(Controller) != none) && (DXRAIController(Controller).bUseAlterDest == true))
    {
        if ((Acceleration == vect(0,0,0)) || (Physics != PHYS_Walking) || (TurnDirection == TURNING_None))
        {
            //bAdvancedTactics = false;
            DXRAIController(Controller).bUseAlterDest = false;
            if (TurnDirection != TURNING_None)
                controller.MoveTimer -= 4.0;

            ActorAvoiding    = None;
            NextDirection    = TURNING_None;
            TurnDirection    = TURNING_None;
            bClearedObstacle = true;
            ObstacleTimer    = 0;
        }
    }


    if (bStandInterpolation)
        UpdateStanding(deltaTime);

    // this is UGLY!
    if (bOnFire && (health > 0))
    {
     if (Controller != none)
        stateName = controller.GetStateName();

        if ((stateName != 'Burning') && (stateName != 'TakingHit') && (stateName != 'RubbingEyes'))
           if (Controller != none)
            controller.GotoState('Burning');
    }
    else
    {
        if (bDoLowPriority)
        {
            // Don't allow radius-based convos to interupt other conversations!
        if (Controller != none)
            if ((player != None) && (controller.GetStateName() != 'Conversation') && (controller.GetStateName() != 'FirstPersonConversation'))
               if (ConList.length > 0)
                   player.StartConversation(Self, IM_Radius);
        }

        bbCheckEnemy = CheckEnemyPresence(deltaTime, bCheckPlayer, bCheckOther);
//      log(self@"bCheckEnemy = "$bCheckEnemy);

        if (bbCheckEnemy)
            HandleEnemy();
        else
        {
            CheckBeamPresence(deltaTime);
            if (bDoLowPriority || LastRendered() < 5.0)
                CheckCarcassPresence(deltaTime);  // hacky -- may change state!
        }
    }

    // Randomly spawn an air bubble every 0.2 seconds if we're underwater
    if (HeadVolume.bWaterVolume && bSpawnBubbles && bDoLowPriority)
    {
        swimBubbleTimer += deltaTime;
        if (swimBubbleTimer >= 0.2)
        {
            swimBubbleTimer = 0;
            if (FRand() < 0.4)
            {
                loc = Location + VRand() * 4;
                loc.Z += CollisionHeight * 0.9;
                Spawn(class'AirBubble', Self,, loc);
            }
        }
    }

    // Handle poison damage
    UpdatePoison(deltaTime);
}

// ----------------------------------------------------------------------
// SpurtBlood()
// ----------------------------------------------------------------------
function SpurtBlood()
{
    local vector bloodVector;

    bloodVector = vect(0,0,1)*CollisionHeight*0.5;  // so folks don't bleed from the crotch
    spawn(Class'BloodDrop',,,bloodVector+Location);
}


// ----------------------------------------------------------------------
// TakeDamage()
// ----------------------------------------------------------------------
function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class <damageType> damageType)
{
   // Отправить в контроллер, контроллер обратно передаст TakeDamageBase.
   controller.NotifyTakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
//    TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, true);
}

// ----------------------------------------------------------------------
// Timer()
// ----------------------------------------------------------------------
event Timer()
{
    UpdateFire();
}


function UpdateStanding(float deltaSeconds)
{
    local float  delta;
    local vector newPos;

    if (bStandInterpolation)
    {
        if ((Physics == PHYS_Walking) && (Acceleration != vect(0,0,0)))  // the bastard's walking now
            StopStanding();
        else
        {
            if ((deltaSeconds < remainingStandTime) && (remainingStandTime > 0))
            {
                delta = deltaSeconds;
                remainingStandTime -= deltaSeconds;
            }
            else
            {
                delta = remainingStandTime;
                StopStanding();
            }
            newPos = StandRate*delta;
            Move(newPos);
        }
    }
}

function StopStanding()
{
    if (bStandInterpolation)
    {
        bStandInterpolation = false;
        remainingStandTime  = 0;
        if (Physics == PHYS_Flying)
            SetPhysics(PHYS_Falling);
    }
}


function PhysicsVolumeChange(PhysicsVolume newZone)
{
    local vector jumpDir;

    if (!bInWorld)
        return;

    if (newZone.bWaterVolume)
    {
        EnableShadow(false);
        if (!bCanSwim)
            Controller.MoveTimer = -1.0;
        else if (Physics != PHYS_Swimming)
        {
            if (bOnFire)
                ExtinguishFire();

            PlaySwimming();
            setPhysics(PHYS_Swimming);
        }
        swimBubbleTimer = 0;
    }
    else if (Physics == PHYS_Swimming)
    {
        EnableShadow(true);
        if (bCanFly)
             SetPhysics(PHYS_Flying); 
        else
        { 
            SetPhysics(PHYS_Falling);
            if (bCanWalk && (Abs(Acceleration.X) + Abs(Acceleration.Y) > 0) && CheckWaterJump(jumpDir))
                JumpOutOfWater(jumpDir);
        }
    }
}




// ----------------------------------------------------------------------
// BaseChange()
// ----------------------------------------------------------------------
singular function BaseChange()
{
    Super.BaseChange();

    if (bSitting && !IsSeatValid(SeatActor))
    {
        StandUp();
        if (Controller.GetStateName() == 'Sitting')
            Controller.GotoState('Sitting', 'Begin');
    }
    if (Controller != none)
  Controller.BaseChange();
} 




// ----------------------------------------------------------------------
// PainTimer()
// ----------------------------------------------------------------------


// ----------------------------------------------------------------------
// CheckWaterJump()
// ----------------------------------------------------------------------
function bool CheckWaterJump(out vector WallNormal)
{
    local actor HitActor;
    local vector HitLocation, HitNormal, checkpoint, start, checkNorm, Extent;

//  if (CarriedDecoration != None)
//      return false;
    checkpoint = vector(Rotation);
    checkpoint.Z = 0.0;
    checkNorm = Normal(checkpoint);
    checkPoint = Location + CollisionRadius * checkNorm;
    Extent = CollisionRadius * vect(1,1,0);
    Extent.Z = CollisionHeight;
    HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, false, Extent);
    if ( (HitActor != None) && (Pawn(HitActor) == None) )
    {
        WallNormal = -1 * HitNormal;
        start = Location;
        start.Z += 1.1 * MaxiStepHeight + CollisionHeight;
        checkPoint = start + 2 * CollisionRadius * checkNorm;
        HitActor = Trace(HitLocation, HitNormal, checkpoint, start, true, Extent);
        if (HitActor == None)
            return true;
    }

    return false;
}




// ----------------------------------------------------------------------
// SetMovementPhysics()
// ----------------------------------------------------------------------
function SetMovementPhysics()
{
    if (Physics == PHYS_Falling)
        return;
    if ( PhysicsVolume.bWaterVolume )
        SetPhysics(PHYS_Swimming);
    else
        SetPhysics(PHYS_Walking); 
}


// ----------------------------------------------------------------------
// PreSetMovement()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// ChangedWeapon()
// ----------------------------------------------------------------------
function ChangedWeapon();


// ----------------------------------------------------------------------
// SwitchToBestWeapon()
// ----------------------------------------------------------------------
function bool SwitchToBestWeapon()
{
    local Inventory    inv;
    local DeusExWeapon curWeapon;
    local float        score;
    local DeusExWeapon dxWeapon;
    local DeusExWeapon bestWeapon;
    local float        bestScore;
    local int          fallbackLevel;
    local int          curFallbackLevel;
    local bool         bBlockSpecial;
    local bool         bValid;
    local bool         bWinner;
    local float        aMinRange, accRange;
    local float        range, centerRange;
    local float        cutoffRange;
    local float        enemyRange;
    local float        minEnemy, accEnemy, maxEnemy;
    local ScriptedPawn enemyPawn;
    local Robot        enemyRobot;
    local DeusExPlayer enemyPlayer;
    local float        enemyRadius;
    local bool         bEnemySet;
    local int          loopCount, i;  // hack - check for infinite inventory
    local Inventory    loopInv;       // hack - check for infinite inventory

    if (ShouldDropWeapon())
    {
        DropWeapon();
        return false;
    }

//  log(self@"SwitchToBestWeapon() called !",'SwitchToBestWeapon');

    bBlockSpecial = false;
    dxWeapon = DeusExWeapon(Weapon);
    if (dxWeapon != None)
    {
        if (dxWeapon.AITimeLimit > 0)
        {
            if (SpecialTimer <= 0)
            {
                bBlockSpecial = true;
                FireTimer = dxWeapon.AIFireDelay;
            }
        }

        if(dxWeapon.IsInState('Reload') && !bIsHuman && !IsA('Robot')) //Hack, avoid switching weapons while reloading
            return true;
    }

    bestWeapon      = None;
    bestScore       = 0;
    fallbackLevel   = 0;
    inv             = Inventory;

    bEnemySet   = false;
    minEnemy    = 0;
    accEnemy    = 0;
    enemyRange  = 400;  // default
    enemyRadius = 0;
    enemyPawn   = None;
    enemyRobot  = None;
    if (Controller.Enemy != None)
    {
        bEnemySet   = true;
        enemyRange  = VSize(Controller.Enemy.Location - Location);
        enemyRadius = Controller.Enemy.CollisionRadius;
        if (DeusExWeapon(Controller.Enemy.Weapon) != None)
            DeusExWeapon(Controller.Enemy.Weapon).GetWeaponRanges(minEnemy, accEnemy, maxEnemy);
        enemyPawn   = ScriptedPawn(Controller.Enemy);
        enemyRobot  = Robot(Controller.Enemy);
        enemyPlayer = DeusExPlayer(Controller.Enemy);
    }

    loopCount = 0;
    while (inv != None)
    {
        // THIS IS A MAJOR HACK!!!
        loopCount++;
        if (loopCount == 9999)
        {
            log("********** RUNAWAY LOOP IN SWITCHTOBESTWEAPON ("$self$") **********");
            loopInv = Inventory;

            inv = loopInv;
            i = 0;
            while (loopInv != None)
            {
                i++;
                if (i > 300)
                    break;
                log("   Inventory "$i$" - "$loopInv);

                if(loopInv.Owner != Self && loopInv.Base != Self) // Attempt to half-assed fix the problem if it's some kind of inventory "sharing" issue
                    DeleteInventory(loopInv);

                if(loopInv.Inventory == inv) // circular-linked inventory
                    loopInv.Inventory = None;

                loopInv = loopInv.Inventory;
            }

            inv = None; // break the loop
        }

        curWeapon = DeusExWeapon(inv);
        if (curWeapon != None)
        {
            bValid = true;
            if (curWeapon.ReloadCount > 0)
            {
                if (curWeapon.AmmoType == None)
                    bValid = false;
                else if (curWeapon.AmmoType.AmmoAmount < 1)
                    bValid = false;
            }

            // Ensure we can actually use this weapon here
            if (bValid)
            {
                // lifted from DeusExWeapon...
                if ((curWeapon.EnviroEffective == ENVEFF_Air) || (curWeapon.EnviroEffective == ENVEFF_Vacuum) ||
                    (curWeapon.EnviroEffective == ENVEFF_AirVacuum))
                    if (curWeapon.PhysicsVolume.bWaterVolume)
                        bValid = false;
            }

            if (bValid)
            {
                GetWeaponBestRange(curWeapon, aMinRange, accRange);
                cutoffRange = aMinRange+(CollisionRadius+enemyRadius);
                range = (accRange - aMinRange) * 0.5;
                centerRange = aMinRange + range;
                if (range < 50)
                    range = 50;
                if (enemyRange < centerRange)
                    score = (centerRange - enemyRange)/range;
                else
                    score = (enemyRange - centerRange)/range;
                if ((aMinRange >= minEnemy) && (accRange <= accEnemy))
                    score += 0.5;  // arbitrary
                if ((cutoffRange >= enemyRange-CollisionRadius) && (cutoffRange >= 256)) // do not use long-range weapons on short-range targets
                    score += 10000;

                curFallbackLevel = 3;
                if (curWeapon.bFallbackWeapon && !bUseFallbackWeapons)
                    curFallbackLevel = 2;
                if (!bEnemySet && !curWeapon.bUseAsDrawnWeapon)
                    curFallbackLevel = 1;
                if ((curWeapon.AIFireDelay > 0) && (FireTimer > 0))
                    curFallbackLevel = 0;
                if (bBlockSpecial && (curWeapon.AITimeLimit > 0) && (SpecialTimer <= 0))
                    curFallbackLevel = 0;

                // Adjust score based on opponent and damage type.
                // All damage types are listed here, even the ones that aren't used by weapons... :)
                // (hacky...)

                switch (curWeapon.WeaponDamageType())
                {
                    case class'DM_Exploded':
                        // Massive explosions are always good
                        if (enemyRobot != None)
                            score -= 50.0; // Make military bots use rockets on each other.
                        else
                            score -= 0.2;
                        break;

                    case class'DM_Stunned':
                        if (enemyPawn != None)
                        {
                            if (enemyPawn.bStunned)
                                score += 1000;
                            else
                                score -= 1.5;
                        }
                        if (enemyPlayer != None)
                            score += 10;
                        break;

                    case class'DM_TearGas':
                        if (enemyPawn != None)
                        {
                            if (enemyPawn.bStunned)
                                //score += 1000;
                                bValid = false;
                            else
                                score -= 5.0;
                        }
                        if (enemyRobot != None)
                            //score += 10000;
                            bValid = false;
                        break;
                        
                    case class'DM_KnockedOut':
                        if (enemyRobot != None)
                            //score += 10000;
                            bValid = false;
                        break;

                    case class'DM_HalonGas':
                        if (enemyPawn != None)
                        {
                            if (enemyPawn.bStunned)
                                //score += 1000;
                                bValid = false;
                            else if (enemyPawn.bOnFire)
                                //score += 10000;
                                bValid = false;
                            else
                                score -= 3.0;
                        }
                        if (enemyRobot != None)
                            //score += 10000;
                            bValid = false;
                        break;

                    case class'DM_PoisonGas':
                    case class'DM_Poison':
                    case class'DM_PoisonEffect':
                    case class'DM_Radiation':
                        if (enemyRobot != None)
                            //score += 10000;
                            bValid = false;
                        break;

                    case class'DM_Burned':
                    case class'DM_Flamed':
                    case class'DM_Shot':

                    case class'DM_Shell':
                        if (enemyRobot != None)
                            score += 0.5;
                        break;

                    case class'DM_Sabot':
                        if (enemyRobot != None)
                            score -= 0.5;
                        break;

                    case class'DM_EMP':
                    case class'DM_NanoVirus':
                        if (enemyRobot != None)
                            score -= 5.0;
                        else if (enemyPlayer != None)
                            score += 5.0;
                        else
                            //score += 10000;
                            bValid = false;
                        break;

                    case class'DM_Drowned':
                    default:
                        break;
                }

                // Special case for current weapon
                if ((curWeapon == Weapon) && (WeaponTimer < 10.0))
                {
                    // If we last changed weapons less than five seconds ago,
                    // keep this weapon
                    if (WeaponTimer < 5.0)
                        score = -10;

                    // If between five and ten seconds, use a sliding scale
                    else
                        score -= (10.0 - WeaponTimer)/5.0;
                }

                // Throw a little randomness into the computation...
                else
                {
                    score += FRand()*0.1 - 0.05;
                    if (score < 0)
                        score = 0;
                }

                if (bValid)
                {
                    // ugly
                    if (bestWeapon == None)
                        bWinner = true;
                    else if (curFallbackLevel > fallbackLevel)
                        bWinner = true;
                    else if (curFallbackLevel < fallbackLevel)
                        bWinner = false;
                    else if (bestScore > score)
                        bWinner = true;
                    else
                        bWinner = false;
                    if (bWinner)
                    {
                        bestScore     = score;
                        bestWeapon    = curWeapon;
                        fallbackLevel = curFallbackLevel;
                    }
                }
            }
        }
        inv = inv.Inventory;
    }

    // If we're changing weapons, reset the weapon timers
    if (Weapon != bestWeapon)
    {
        if (!bEnemySet)
            WeaponTimer = 10;  // hack
        else
            WeaponTimer = 0;
        if (bestWeapon != None)
            if (bestWeapon.AITimeLimit > 0)
                SpecialTimer = bestWeapon.AITimeLimit;
        ReloadTimer = 0;
    }

    SetWeapon(bestWeapon);

    return false;
}




// ----------------------------------------------------------------------
// LoopBaseConvoAnim()
// ----------------------------------------------------------------------
function LoopBaseConvoAnim()
{
    // Special case for sitting
    if (bSitting)
    {
        if (!IsAnimating())
            PlaySitting();
    }

    // Special case for dancing
    else if (bDancing)
    {
        if (!IsAnimating())
            PlayDancing();
    }

    // Otherwise, just do the usual shit
    else
        LoopBaseConvoAnim2();

}

function PlayDancing()
{
    if (PhysicsVolume.bWaterVolume)
        LoopAnimPivot('Tread', , 0.3, , GetSwimPivot());
    else
        LoopAnimPivot('Dance', FRand()*0.2+0.9, 0.3);
}

function PlaySittingDown()
{
    PlayAnimPivot('SitBegin', , 0.15);
}

function PlaySitting()
{
    LoopAnimPivot('SitBreathe', , 0.15);
}

function PlayStandingUp()
{
    PlayAnimPivot('SitStand', , 0.15);
}


function PlaySwimming()
{
    LoopAnimPivot('Tread', , , , GetSwimPivot());
}

// ----------------------------------------------------------------------
// BackOff()
// ----------------------------------------------------------------------
function BackOff()
{
    controller.SetNextState(controller.GetStateName(), 'ContinueFromDoor');  // MASSIVE hackage
    controller.SetState('BackingOff');
}


// ----------------------------------------------------------------------
// ResetDestLoc()
// ----------------------------------------------------------------------

function ResetDestLoc()
{
  DestAttempts  = 0;
  LastDestLoc   = vect(9999,9999,9999);  // hack
  LastDestPoint = LastDestLoc;
}


// ----------------------------------------------------------------------
// EnableCheckDestLoc()
// ----------------------------------------------------------------------

function EnableCheckDestLoc(bool bEnable)
{
  if (bEnableCheckDest && !bEnable)
    ResetDestLoc();
  bEnableCheckDest = bEnable;
}

function CheckDestLoc(vector newDestLoc, optional bool bPathnode)
{
    if (VSize(newDestLoc-LastDestLoc) <= 16)  // too close
        DestAttempts++;
    else if (!IsPointInCylinder(self, newDestLoc))
        DestAttempts++;
    else if (bPathnode && (VSize(newDestLoc-LastDestPoint) <= 16))  // too close
        DestAttempts++;
    else
        DestAttempts = 0;
    LastDestLoc = newDestLoc;
    if (bPathnode && (DestAttempts == 0))
        LastDestPoint = newDestLoc;

    if (bEnableCheckDest && (DestAttempts >= 4))
        BackOff();
}

singular event Falling()
{
    if (bCanFly)
    {
        SetPhysics(PHYS_Flying);
        return;
    }
    SetPhysics(PHYS_Falling); //note - done by default in physics
    if (health > 0)
        Controller.SetFall();
}


// ----------------------------------------------------------------------
// Frob()
// ----------------------------------------------------------------------
function Frob(Actor Frobber, Inventory frobWith)
{
    Super.Frob(Frobber, frobWith);

    // Check to see if the Frobber is the player.  If so, then
    // check to see if we need to start a conversation.

    if (DeusExPlayer(Frobber) != None)
    {
        if (DeusExPlayer(Frobber).StartConversation(Self, IM_Frob))
        {
            ConversationActor = Pawn(Frobber);
            return;
        }
    }
}

//function Died(pawn Killer, name damageType, vector HitLocation)
//function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
    local DeusExPlayer player;
    local name flagName;

    // Set a flag when NPCs die so we can possibly check it later
    player = DeusExPlayer(GetPlayerPawn());

    ExtinguishFire();

    // set the instigator to be the killer
    Instigator = Killer.pawn;

    if (player != None)
    {
        // Abort any conversation we may have been having with the NPC
        if (bInConversation)
            player.AbortConversation();

        // Abort any barks we may have been playing
        if (player.BarkManager != None)
            player.BarkManager.ScriptedPawnDied(Self);
    }

    Super.Died(Killer, damageType, HitLocation);  // bStunned is set here

    if (player != None)
    {
        if (bImportant)
        {
            flagName = class'ObjectManager'.static.StringToName(BindName$"_Dead");
            GetflagBase().SetBool(flagName, True);

            // make sure the flag never expires
            GetflagBase().SetExpiration(flagName, FLAG_Bool, 0);

            if (bStunned)
            {
                flagName = class'ObjectManager'.static.StringToName(BindName$"_Unconscious");
                GetflagBase().SetBool(flagName, True);

                // make sure the flag never expires
                GetflagBase().SetExpiration(flagName, FLAG_Bool, 0);
            }
        }
    }
    GoToState('Dying');
}


event SetInitialState()
{
    GoToState('Auto');
//  Super.SetInitialState();

//  Controller.SetFall();
  //InitializePawn();
}

function InitializePawn()
{
    if (!bInitialized)
    {
        InitializeInventory();
        InitializeAlliances();
        InitializeHomeBase();

//        BlockReactions();

        if (Alliance != '')
            ChangeAlly(Alliance, 1.0, true);

        if (!bInWorld)
        {
            // tricky
            bInWorld = true;
            LeaveWorld();
        }

        // hack!
        animTimer[1] = 20.0;
        PlayTurnHead(LOOK_Forward, 1.0, 0.0001);

        bInitialized = true;
    }
}

function InitializeAlliances()
{
    local int i;

    for (i=0; i<8; i++)
        if (InitialAlliances[i].AllianceName != '')
            ChangeAlly(InitialAlliances[i].AllianceName,InitialAlliances[i].AllianceLevel,InitialAlliances[i].bPermanent);

}

function InitializeHomeBase()
{
    if (!bUseHome)
    {
        HomeActor = None;
        HomeLoc   = Location;
        HomeRot   = vector(Rotation);
        if (HomeTag == 'Start')
            bUseHome = true;
        else
        {
            HomeActor = HomeBase(FindTaggedActor(HomeTag, , Class'HomeBase'));
            if (HomeActor != None)
            {
                HomeLoc    = HomeActor.Location;
                HomeRot    = vector(HomeActor.Rotation);
                HomeExtent = HomeActor.Extent;
                bUseHome   = true;
            }
        }
        HomeRot *= 100;
    }
}

function InitializeInventory()
{
    local int                i, j;
    local Inventory          inv;
    local DeusExWeapon    weapons[8];
    local int                weaponCount;
    local DeusExWeapon    firstWeapon;

    // Add initial inventory items
    weaponCount = 0;
    for (i=0; i<8; i++)
    {
        if ((InitialInventory[i].Inventory != None) && (InitialInventory[i].Count > 0))
        {
            firstWeapon = None;
            for (j=0; j<InitialInventory[i].Count; j++)
            {
                inv = None;
                if (Class<Ammunition>(InitialInventory[i].Inventory) != None)
                {
                    inv = FindInventoryType(InitialInventory[i].Inventory);
                    if (inv != None)
                        Ammunition(inv).AmmoAmount += class<Ammunition>(InitialInventory[i].Inventory).default.AmmoAmount;
                }
                if (inv == None)
                {
                    inv = spawn(InitialInventory[i].Inventory, self);
                    //log("spawned InitialInventory["$i$"]"@inv);
                    if (inv != None)
                    {
                        inv.InitialState='Idle2';
                        //inv.GoToState('Idle2');//
                        inv.GiveTo(Self);
                        inv.SetBase(Self);
                        if ((firstWeapon == None) && (Weapon(inv) != None))
                            firstWeapon = DeusExWeapon(inv);
                    }
                }
            }
            if (firstWeapon != None)
                weapons[WeaponCount++] = firstWeapon;
        }
    }
    for (i=0; i<weaponCount; i++)
    {
        if ((weapons[i].AmmoType == None) && (weapons[i].AmmoName != None) && (weapons[i].AmmoName != class'AmmoNone'))
        {
            weapons[i].AmmoType = Ammunition(FindInventoryType(weapons[i].AmmoName));
            if (weapons[i].AmmoType == None)
            {
                weapons[i].AmmoType = spawn(weapons[i].AmmoName);
                weapons[i].AmmoType.InitialState='Idle2';
                //weapons[i].AmmoType.GoToState('Idle2');
                weapons[i].AmmoType.GiveTo(Self);
                weapons[i].AmmoType.SetBase(Self);
            }
        }
    }
    SetupWeapon(false);
}


function bool ReadyForNewEnemy()
{
    if ((Controller.Enemy == None) || (EnemyTimer > 5.0))
        return True;
    else
        return False;
}

function EnterConversationState(bool bFirstPerson, optional bool bAvoidState)
{
    // First check to see if we're already in a conversation state, 
    // in which case we'll abort immediately
    if ((DXRAIController(Controller).GetStateName() == 'Conversation') || (DXRAIController(Controller).GetStateName() == 'FirstPersonConversation'))
        return;

    DXRAIController(Controller).SetNextState(Controller.GetStateName(), 'Begin');

    // If bAvoidState is set, then we don't want to jump into the conversaton state
    // for the ScriptedPawn, because bad things might happen otherwise.

    if (bAvoidState == false)
    {
        if (bFirstPerson == true)
        {
            DXRAIController(Controller).GotoState('FirstPersonConversation','Begin');
        }
        else
        {
            DXRAIController(Controller).GotoState('Conversation','Begin');
        }
    }
}

// ----------------------------------------------------------------------
// STATES
// ----------------------------------------------------------------------
state idle
{
}

// ----------------------------------------------------------------------
// state Dying
//
// Why does the Unreal Dying state suck?
// ----------------------------------------------------------------------
state Dying
{
    ignores SeePlayer, EnemyNotVisible, HearNoise, KilledBy, Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, WarnTarget, Died, Timer, TakeDamage;

    event Landed(vector HitNormal)
    {
        SetPhysics(PHYS_Walking);
    }

    event Tick(float deltaSeconds)
    {
        Global.Tick(deltaSeconds);

        if (DeathTimer > 0)
        {
            DeathTimer -= deltaSeconds;
            if ((DeathTimer <= 0) && (Physics == PHYS_Walking))
                Acceleration = vect(0,0,0);
        }
    }

    function MoveFallingBody()
    {
        local Vector moveDir;
        local float  totalTime;
        local float  speed;
        local float  stopTime;
        local int    numFrames;

        if ((GetAnimRate() > 0) && !IsA('Robot'))
        {
            totalTime = 1.0/GetAnimRate();  // determine how long the anim lasts
            numFrames = int((1.0/(1.0-GetAnimRate()))+0.1);  // count frames (hack)

            // defaults
            moveDir   = vect(0,0,0);
            stopTime  = 0.01;

            ComputeFallDirection(totalTime, numFrames, moveDir, stopTime);

            speed = VSize(moveDir)/stopTime;  // compute speed

            // Set variables necessary for movement when walking
            if (moveDir == vect(0,0,0))
                Acceleration = vect(0,0,0);
            else
                Acceleration = Normal(moveDir)*AccelRate;
            GroundSpeed  = speed;
            DesiredSpeed = 1.0;
            bIsWalking   = false;
            DeathTimer   = stopTime;
        }
        else
            Acceleration = vect(0,0,0);
    }

    function BeginState()
    {
        Controller.GoToState('');
        Controller.Destroy();

        EnableCheckDestLoc(false);
        StandUp();

        // don't do that stupid timer thing in Pawn.uc
/*        AIClearEventCallback('Futz');
        AIClearEventCallback('MegaFutz');
        AIClearEventCallback('Player');
        AIClearEventCallback('WeaponDrawn');
        AIClearEventCallback('LoudNoise');
        AIClearEventCallback('WeaponFire');
        AIClearEventCallback('Carcass');
        AIClearEventCallback('Distress');*/

        bInterruptState = false;
        BlockReactions(true);
        bCanConverse = False;
        bStasis = false;
        SetDistress(true);
        DeathTimer = 0;
    }

Begin:
    MoveFallingBody();
    DesiredRotation.Pitch = 0;
    DesiredRotation.Roll  = 0;

    // if we don't gib, then wait for the animation to finish
    if ((Health > GIB_HEALTH) && !IsA('Robot'))
        FinishAnim();

    SetWeapon(None);
    bHidden = true;
    Acceleration = vect(0,0,0);
    SpawnCarcass();
    Destroy();
}

function JumpOffPawn()
{
/*    Velocity += (60 + CollisionRadius) * VRand();
    Velocity.Z = 180 + CollisionHeight;
    SetPhysics(PHYS_Falling);
    bJumpOffPawn = true;
    SetFall();*/
//  log("ERROR - JumpOffPawn should not be called!");
}



function SetOrders(Name orderName, optional Name newOrderTag, optional bool bImmediate)
{
   Controller.SetOrders(orderName, newOrderTag, bImmediate);
}

function LoopBaseConvoAnim2()
{
    local float rnd;

    rnd = FRand();

    // move arms randomly
    if (bIsSpeaking)
    {
        if (animTimer[2] > 2.5)
        {
            animTimer[2] = 0;
            if (rnd < 0.1)
                PlayAnim('GestureLeft', 0.35, 0.4);
            else if (rnd < 0.2)
                PlayAnim('GestureRight', 0.35, 0.4);
            else if (rnd < 0.3)
                PlayAnim('GestureBoth', 0.35, 0.4);
        }
    }

    // if we're not playing an animation, loop the breathe
    if (!IsAnimating())
        LoopAnim('BreatheLight',, 0.4);
}

function bool IsWeaponReloading()
{
    return (ReloadTimer >= 0.3);
}

function bool SpecialCalcView(out Actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
    return false;
}

function pawn GetPlayerPawn()
{
  local pawn FoundPawn;

  FoundPawn = level.GetLocalPlayerController().myHUD.PawnOwner;
  if (FoundPawn != None && FoundPawn.IsA('DeusExPlayer'))
      return FoundPawn;

  else if (level.GetLocalPlayerController().pawn != none)
      return level.GetLocalPlayerController().pawn;
}

function DeusExGameInfo getFlagBase()
{
    if(flagBase == none)
    {
        flagBase = DeusExGameInfo(Level.Game);
    }
    return flagBase;
}

function LipSynch(float deltatime);

function HandleFutz(Name event, EAIEventState state, XAIParams params)
{
    // React

    if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
        ReactToFutz();  // only players can futz
}

function HandleHacking(Name event, EAIEventState state, XAIParams params)
{
    // Fear, Hate
    local Pawn pawnActor;

    if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
    {
        pawnActor = GetPlayerPawn();
        if (pawnActor != None)
        {
            if (bHateHacking)
                IncreaseAgitation(pawnActor, 1.0);
            if (bFearHacking)
                IncreaseFear(pawnActor, 0.51);
            if (SetEnemy(pawnActor))
            {
                SetDistressTimer();
                HandleEnemy();
            }
            else if (bFearHacking && IsFearful())
            {
                SetDistressTimer();
                SetEnemy(pawnActor, , true);
                Controller.GotoState('Fleeing');
            }
            else  // only players can hack
                ReactToFutz();
        }
    }
}

function HandleWeapon(Name event, EAIEventState state, XAIParams params)
{
    // Fear, Hate
    local DeusExPawn pawnActor;

    if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
    {
        pawnActor = InstigatorToPawn(params.bestActor);
        if (pawnActor != None)
        {
            if (bHateWeapon)
                IncreaseAgitation(pawnActor);
            if (bFearWeapon)
                IncreaseFear(pawnActor, 1.0);

            // Let presence checking handle enemy sighting

            if (!IsValidEnemy(pawnActor))
            {
                if (bFearWeapon && IsFearful())
                {
                    SetDistressTimer();
                    SetEnemy(pawnActor, , true);
                    Controller.GotoState('Fleeing');
                }
                else if (pawnActor.controller.bIsPlayer)
                    ReactToFutz();
            }
        }
    }
}

function HandleShot(Name event, EAIEventState state, XAIParams params)
{
    // React, Fear, Hate
    local DeusExPawn pawnActor;

    if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
    {
        pawnActor = InstigatorToPawn(params.bestActor);
        if (pawnActor != None)
        {
            if (bHateShot)
                IncreaseAgitation(pawnActor);
            if (bFearShot)
                IncreaseFear(pawnActor, 1.0);
            if (SetEnemy(pawnActor))
            {
                SetDistressTimer();
                HandleEnemy();
            }
            else if (bFearShot && IsFearful())
            {
                SetDistressTimer();
                SetEnemy(pawnActor, , true);
                Controller.GotoState('Fleeing');
            }
            else if (pawnActor.Controller.bIsPlayer)
                ReactToFutz();
        }
    }
}

function HandleLoudNoise(Name event, EAIEventState state, XAIParams params)
{
    // React
    local Actor bestActor;
    local DeusExPawn  inst;

    if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
    {
        bestActor = params.bestActor;
        if (bestActor != None)
        {
            inst = DeusExPawn(bestActor);
            if (inst == None)
                inst = DeusExPawn(bestActor.Instigator);
            if (inst != None)
            {
                if (IsValidEnemy(inst))
                {
                    DXRAiController(Controller).SetSeekLocation(inst, bestActor.Location, SEEKTYPE_Sound);
                    HandleEnemy();
                }
            }
        }
    }
}

function HandleProjectiles(Name event, EAIEventState state, XAIParams params)
{
    // React, Fear
//    local DeusExProjectile dxProjectile;

    if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
        if (params.bestActor != None)
            ReactToProjectiles(params.bestActor);
}

function HandleAlarm(Name event, EAIEventState state, XAIParams params)
{
    // React, Fear
    local AlarmUnit      alarm;
    local LaserTrigger   laser;
    local SecurityCamera camera;
    local Computers      computer;
    local DeusExPawn     alarmInstigator;
    local vector         alarmLocation;

    if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
    {
        alarmInstigator = None;
        alarm    = AlarmUnit(params.bestActor);
        laser    = LaserTrigger(params.bestActor);
        camera   = SecurityCamera(params.bestActor);
        computer = Computers(params.bestActor);
        if (alarm != None)
        {
            alarmInstigator = DeusExPawn(alarm.alarmInstigator);
            alarmLocation   = alarm.alarmLocation;
        }
        else if (laser != None)
        {
            alarmInstigator = DeusExPawn(laser.triggerActor);
            if (alarmInstigator == None)
                alarmInstigator = DeusExPawn(laser.triggerActor.Instigator);
            alarmLocation   = laser.actorLocation;
        }
        else if (camera != None)
        {
            alarmInstigator = DeusExPlayer(GetPlayerPawn());  // player is implicit for cameras
            alarmLocation   = camera.playerLocation;
        }
        else if (computer != None)
        {
            alarmInstigator = DeusExPlayer(GetPlayerPawn());  // player is implicit for computers
            alarmLocation   = computer.Location;
        }

        if (bFearAlarm)
        {
            IncreaseFear(alarmInstigator, 2.0);
            if (IsFearful())
            {
                SetDistressTimer();
                SetEnemy(alarmInstigator, , true);
                Controller.GotoState('Fleeing');
            }
        }

        if (alarmInstigator != None)
        {
            if (alarmInstigator.Health > 0)
            {
                if (IsValidEnemy(alarmInstigator))
                {
                    AlarmTimer = 120;
                    SetDistressTimer();
                    DXRAiController(Controller).SetSeekLocation(alarmInstigator, alarmLocation, SEEKTYPE_Sound);
                    HandleEnemy();
                }
            }
        }
    }
}


function HandleDistress(Name event, EAIEventState state, XAIParams params)
{
    // React, Fear, Hate
    local float        seeTime;
    local DeusExPawn   distressee;
    local DeusExPlayer distresseePlayer;
    local ScriptedPawn distresseePawn;
    local DeusExPawn   distressor;
    local DeusExPlayer distressorPlayer;
    local ScriptedPawn distressorPawn;
    local bool         bDistresseeValid;
    local bool         bDistressorValid;
    local float        distressVal;
    local name         stateName;
    local bool         bIsAttacking;//bAttacking;
    local bool         bFleeing;

    bIsAttacking = false;
    seeTime    = 0;

    if (state == EAISTATE_Begin || state == EAISTATE_Pulse)
    {
        distressee = InstigatorToPawn(params.bestActor);
        if (distressee != None)
        {
            if (bFearDistress)
                IncreaseFear(distressee.Controller.Enemy, 1.0);
            bDistresseeValid = false;
            bDistressorValid = false;
            distresseePlayer = DeusExPlayer(distressee);
            distresseePawn   = ScriptedPawn(distressee);
            if (GetPawnAllianceType(distressee) == ALLIANCE_Friendly)
            {
                if (distresseePawn != None)
                {
                    if (distresseePawn.bDistressed && (distresseePawn.EnemyLastSeen <= EnemyTimeout))
                    {
                        bDistresseeValid = true;
                        seeTime          = distresseePawn.EnemyLastSeen;
                    }
                }
                else if (distresseePlayer != None)
                    bDistresseeValid = true;
            }
            if (bDistresseeValid)
            {
                distressor       = DeusExPawn(distressee.Controller.Enemy);
                distressorPlayer = DeusExPlayer(distressor);
                distressorPawn   = ScriptedPawn(distressor);
                if (distressorPawn != None)
                {
                    if (bHateDistress || (distressorPawn.GetPawnAllianceType(distressee) == ALLIANCE_Hostile))
                        bDistressorValid = true;
                }
                else if (distresseePawn != None)
                {
                    if (bHateDistress || (distresseePawn.GetPawnAllianceType(distressor) == ALLIANCE_Hostile))
                        bDistressorValid = true;
                }

                // Finally, react
                if (bDistressorValid)
                {
                    if (bHateDistress)
                        IncreaseAgitation(distressor, 1.0);
                    if (SetEnemy(distressor, seeTime))
                    {
                        SetDistressTimer();
                        HandleEnemy();
                        bIsAttacking = true;
                    }
                }
                // BOOGER! Make NPCs react by seeking if distressor isn't an enemy?
            }

            if (!bIsAttacking && bFearDistress)
            {
                distressVal = 0;
                bFleeing    = false;
                if (distresseePawn != None)
                {
                    stateName = distresseePawn.Controller.GetStateName();
                    if (stateName == 'Fleeing')  // hack -- to prevent infinite fleeing
                    {
                        if (distresseePawn.DistressTimer >= 0)
                        {
                            if (FearSustainTime - distresseePawn.DistressTimer >= 1)
                            {
                                IncreaseFear(distressee.Controller.Enemy, 1.0, distresseePawn.DistressTimer);
                                distressVal = distresseePawn.DistressTimer;
                                bFleeing    = true;
                            }
                        }
                    }
                    else
                    {
                        IncreaseFear(distressee.Controller.Enemy, 1.0);
                        bFleeing = true;
                    }
                }
                else
                {
                    IncreaseFear(distressee.Controller.Enemy, 1.0);
                    bFleeing = true;
                }
                if (bFleeing && IsFearful())
                {
                    if ((DistressTimer > distressVal) || (DistressTimer < 0))
                        DistressTimer = distressVal;
                    SetEnemy(distressee.Controller.Enemy, , true);
                    Controller.GotoState('Fleeing');
                }
            }
        }
    }
}


function UpdateAgitation(float deltaSeconds)
{
    local float mult;
    local float decrement;
    local int   i;

    if (AgitationCheckTimer > 0)
    {
        AgitationCheckTimer -= deltaSeconds;
        if (AgitationCheckTimer < 0)
            AgitationCheckTimer = 0;
    }

    decrement = 0;
    if (AgitationTimer > 0)
    {
        if (AgitationTimer < deltaSeconds)
        {
            mult = 1.0 - (AgitationTimer/deltaSeconds);
            AgitationTimer = 0;
            decrement = mult * (AgitationDecayRate*deltaSeconds);
        }
        else
            AgitationTimer -= deltaSeconds;
    }
    else
        decrement = AgitationDecayRate*deltaSeconds;

    if (bAlliancesChanged && (decrement > 0))
    {
        bAlliancesChanged = False;
        for (i=15; i>=0; i--)
        {
            if ((AlliancesEx[i].AllianceName != '') && (!AlliancesEx[i].bPermanent))
            {
                if (AlliancesEx[i].AgitationLevel > 0)
                {
                    bAlliancesChanged = true;
                    AlliancesEx[i].AgitationLevel -= decrement;
                    if (AlliancesEx[i].AgitationLevel < 0)
                        AlliancesEx[i].AgitationLevel = 0;
                }
            }
        }
    }
}

function UpdateFear(float deltaSeconds)
{
    local float mult;
    local float decrement;

    decrement = 0;
    if (FearTimer > 0)
    {
        if (FearTimer < deltaSeconds)
        {
            mult = 1.0 - (FearTimer/deltaSeconds);
            FearTimer = 0;
            decrement = mult * (FearDecayRate*deltaSeconds);
        }
        else
            FearTimer -= deltaSeconds;
    }
    else
        decrement = FearDecayRate*deltaSeconds;

    if ((decrement > 0) && (FearLevel > 0))
    {
        FearLevel -= decrement;
        if (FearLevel < 0)
            FearLevel = 0;
    }
}


// ----------------------------------------------------------------------
function string GetBindName()
{
    return bindName;
}

function string GetBarkBindName() // Used to bind Barks!
{
    return BarkBindName;
}

function string GetFamiliarName() // For display in Conversations
{
    return FamiliarName;
}

function string GetUnfamiliarName() // For display in Conversations
{
    return UnfamiliarName;
}

function float GetConStartInterval()
{
    return ConStartInterval;
}

function float GetLastConEndTime()  // Time when last conversation ended
{
    return LastConEndTime;
}

// ----------------------------------------------------------------------

defaultproperties
{
     RootBone="DXR_Root"
     HeadBone="3"

     AIHorizontalFov=160.000000
     AspectRatio=2.300000
     BindName="ScriptedPawn"
     FamiliarName="DEFAULT FAMILIAR NAME - REPORT THIS AS A BUG"
     UnfamiliarName="DEFAULT UNFAMILIAR NAME - REPORT THIS AS A BUG"
     Restlessness=0.500000
     Wanderlust=0.500000
     Cowardice=0.500000
     MaxRange=4000.000000
     MinHealth=30.000000
     RandomWandering=1.000000
     bAlliancesChanged=True
     Orders=Wandering
     HomeExtent=800.000000
//     WalkingSpeed=0.400000
     WalkingPct=0.400000
     bCanBleed=True
     ClotPeriod=30.000000
     bShowPain=True
     bCanSit=True
     bLikesNeutral=True
     bUseFirstSeatOnly=True
     bCanConverse=True
     bAvoidAim=True
     AvoidAccuracy=0.400000
     bAvoidHarm=True
     HarmAccuracy=0.800000
     CloseCombatMult=0.300000
     bHateShot=True
     bHateInjury=True
     bReactPresence=True
     bReactProjectiles=True
     bEmitDistress=True
     RaiseAlarm=RAISEALARM_BeforeFleeing
     bMustFaceTarget=True
     FireAngle=360.000000
     MaxProvocations=1
     AgitationSustainTime=30.000000
     AgitationDecayRate=0.050000
     FearSustainTime=25.000000
     FearDecayRate=0.500000
     SurprisePeriod=2.000000
     SightPercentage=0.500000
     bHasShadow=True
     ShadowScale=1.000000
     BaseAssHeight=-26.000000
     EnemyTimeout=4.000000
     bTickVisibleOnly=True
     bInWorld=True
     bHighlight=True
     bHokeyPokey=True
     InitialInventory(0)=(Count=1)
     InitialInventory(1)=(Count=1)
     InitialInventory(2)=(Count=1)
     InitialInventory(3)=(Count=1)
     InitialInventory(4)=(Count=1)
     InitialInventory(5)=(Count=1)
     InitialInventory(6)=(Count=1)
     InitialInventory(7)=(Count=1)
     bSpawnBubbles=True
     bWalkAround=True
     BurnPeriod=30.000000
     DistressTimer=-1.000000
     CloakThreshold=50
     walkAnimMult=0.700000
     runAnimMult=1.000000
     bCanStrafe=True
     bCanWalk=True
     bCanSwim=True

     HealthHead=100
     HealthTorso=100
     HealthLegLeft=100
     HealthLegRight=100
     HealthArmLeft=100
     HealthArmRight=100

     bCanCrouch=true

     CrouchHeight=29.0
     CrouchRadius=25.0

     bIsHuman=true
     AirSpeed=320.000000
     AccelRate=200.000000
     JumpZ=120.000000
     HearingThreshold=0.150000
     
     Texture=Texture'Engine.S_Pawn'
     bAcceptsProjectors=true
     ControllerClass=class'DXRAiController'

     bCanClimbLadders=true

     bSpecialCalcView=true
     RotationRate=(Pitch=4096,Yaw=90000,Roll=3072)

     physics=PHYS_Falling
     bPhysicsAnimUpdate=false
     bFullVolume=false
     bActorShadows=true
     bIgnoreOutOfWorld=true // Don't destroy if fell out of world
     bRotateToDesired=true
     bShouldBaseAtStartup=true
     bCrouchToPassObstacles=false
     SoundOcclusion=OCCLUSION_Default
     bCanFly=false
     CullDistance=8000 // If DistanceFromPlayer > CullDistance, engine will not render this pawn.
     bFastTurnWhenAttacking=true
     bDirectHitWall=false

     TransientSoundVolume=+0.95
     TransientSoundRadius=+50.00

//     bIgnoreLedges=true
//     bDoNotStopAtLedges=true
     bCanWalkOffLedges=true
     bAvoidLedges=false      // don't get too close to ledges
     bStopAtLedges=false     // if bAvoidLedges and bStopAtLedges, Pawn doesn't try to walk along the edge at all
}
