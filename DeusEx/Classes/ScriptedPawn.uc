/*

*/
class ScriptedPawn extends DeusExNPCPawn
            config (DXRConfig)
            abstract;

#exec obj load file=DeusExCharacters.ukx

var name AlarmTag;

var		bool		bCanGlide;   // DEUS_EX STM -- added for flying/swimming states

var		bool		bJumpOffPawn;		

// Blending Animation control - DEUS_EX CNN
var          float        BlendAnimLast[4];        // Last frame.
var          float        BlendAnimMinRate[4];     // Minimum rate for velocity-scaled animation.
var			 float		  OldBlendAnimRate[4];	   // Animation rate of previous animation (= AnimRate until animation completes).
var			 plane		  SimBlendAnim[4];		   // replicated to simulated proxies.

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

var WanderPoint      lastPoints[2];
var float            Restlessness;  // 0-1
var float            Wanderlust;    // 0-1
var float            Cowardice;     // 0-1

var(Pawn) class<carcass> CarcassType;		// mesh to use when killed from the front

// Advanced AI attributes.
var     HomeBase    HomeActor;      // home base
var     Vector      HomeLoc;        // location of home base
var     Vector      HomeRot;        // rotation of home base
var     bool        bUseHome;       // true if home base should be used

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
var transient ShadowProjector PawnShadow;

var DXRAIController DController;
var DeusExPlayer myDxPlayer;

var DeusExGameInfo flagBase;
var DeusExLevelInfo dxLevel;

/*- Assing Conversations to pawn ---------------------------------------------------------------------------------*/
function ConDialogue FindConversationByName(string conName)
{
  local int y;

  for (y=0; y<conList.length; y++)
  {
//    if (conList[y].Name == conName)
    if (caps(conList[y].Name) == caps(conName))
        return conList[y];
//    break;
//    log("found conversationByName="$conName);
//    conv = conList[y];
  }
//  return conv;
}

function AddRefCount()
{
	local bool barkPrefix;
	local conDialogue con;
	local int y;

	DecreaseRefCount();

	for (y=0; y<conList.length; y++)
	{
		con = conList[y];
		barkPrefix = (Left(con.Name, Len(con.OwnerName) + 5) == (con.OwnerName $ CON_BARK_PREFIX));

			if (BarkBindName != con.OwnerName || !barkPrefix)
			{
					if (BindName != con.OwnerName)
						continue;
				if (BarkBindName != "")
				{
					if (BarkBindName == "" || barkPrefix)
						continue;
				}
			}
//	 log("Increased refcount for "$con, 'AddRefCount');
	 con.ownerRefCount++;
	}
}

function DecreaseRefCount()
{
	local int y;

	for (y=0; y<conList.length; y++)
	{
     conList[y].ownerRefCount--;
	}
}

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

// ђҐЈЁбва жЁп *.con д ©«®ў
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

function LoadConsForMission(int mission)
{
  local int convos, barks;

  if (bindName != "")
    convos = class'ConversationManager'.static.GetConversations(conList, mission, bindName, "");
//    log(convos);


  if (barkBindName != "")
    barks = class'ConversationManager'.static.GetConversations(conList, mission, BarkbindName, "");
//    log(barks);
}



function float LastRendered()
{
   return LastRenderTime; //Level.TimeSeconds;
}


function WarnTarget(Pawn shooter, float projSpeed, vector FireDir)
{
	// AI controlled creatures may duck
	// if not falling, and projectile time is long enough
	// often pick opposite to current direction (relative to shooter axis)
}

function Touch(actor toucher)
{
   super.Touch(toucher);

   if (DXRAIController(controller) != none)
      DXRAIController(controller).NotifyTouch(toucher);
}


// ----------------------------------------------------------------------
// PreBeginPlay()
// ----------------------------------------------------------------------
function PreBeginPlay()
{

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

  // DXR: Fix walking speed by just one line of code :)
  WalkingPct = WalkingSpeed;

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
//		Controller.GoToState(orders);
		Controller.pawn = self;
		//SetOrders(orders);
	}
	CreateShadow();

/*		if (CollisionHeight > 9)
		{
      class'ActorManager'.static.SetDefaultCollisionSize(self, CollisionRadius, defHeight - 4.5);
//      log("Default collision Radius/Height ="@default.CollisionRadius @ default.CollisionHeight);
    }
		else
      class'ActorManager'.static.SetDefaultCollisionSize(self, CollisionRadius, defHeight * 0.5);*/
}

event PostLoadSavedGame()
{
  if (shadow == none)
    CreateShadow();
	ConBindEvents();
}

event Destroyed()
{
	local DeusExPlayer player;

	// Pass a message to conPlay, if it exists in the player, that 
	// this pawn has been destroyed.  This is used to prevent 
	// bad things from happening in converseations.

	player = DeusExPlayer(GetPlayerPawn());

	if ((player != None) && (player.conPlay != None))
      player.conPlay.ActorDestroyed(Self);

  if (PawnShadow != none)
      PawnShadow.Destroy();

	Super.Destroyed();
}

function bool SetEnemy(Pawn newEnemy, optional float newSeenTime, optional bool bForce)
{
   return DXRAiController(controller).SetEnemy(newEnemy, newSeenTime, bForce);
}

function HitWall(vector HitLocation, Actor hitActor)
{
	local ScriptedPawn avoidPawn;

	// We only care about HitWall as it pertains to level geometry
	if (hitActor != Level)
		return;

	// Are we walking?
	if ((Physics == PHYS_Walking) && (Acceleration != vect(0,0,0)) && bWalkAround && (AvoidWallTimer <= 0))
	{
		// Are we turning?
		if (TurnDirection != TURNING_None)
		{
			AvoidWallTimer = 1.0;

			// About face
			TurnDirection    = NextDirection;
			NextDirection    = TURNING_None;
			bClearedObstacle = false;

			// Avoid pairing off
			avoidPawn = ScriptedPawn(ActorAvoiding);
			if (avoidPawn != None)
			{
				if ((avoidPawn.Acceleration != vect(0,0,0)) && (avoidPawn.Physics == PHYS_Walking) && (avoidPawn.TurnDirection != TURNING_None) && (avoidPawn.ActorAvoiding == self))
				{
					if ((avoidPawn.TurnDirection == TURNING_Left) && (TurnDirection == TURNING_Right))
						TurnDirection = TURNING_None;
					else if ((avoidPawn.TurnDirection == TURNING_Right) && (TurnDirection == TURNING_Left))
						TurnDirection = TURNING_None;
				}
			}

			// Stopped turning?  Shut down
			if (TurnDirection == TURNING_None)
			{
				ActorAvoiding = None;
				//bAdvancedTactics = false;
//				controller.bPreparingMove = false;
				controller.MoveTimer -= 4.0;
				ObstacleTimer = 0;
			}
		}
	}
}

// ----------------------------------------------------------------------
// SetHomeBase()
// ----------------------------------------------------------------------
function SetHomeBase(vector baseLocation, optional rotator baseRotator, optional float baseExtent)
{
//	local vector vectRot;

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
// SetSeekLocation()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// GetCarcassData()
// ----------------------------------------------------------------------



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
function ReactToProjectiles(actor other);



// ----------------------------------------------------------------------
// InstigatorToPawn()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// EnableShadow()
// ----------------------------------------------------------------------
function EnableShadow(bool bEnable)
{
/*	if (PawnShadow != None)
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

    if(bActorShadows && bPawnShadows && (Level.NetMode != NM_DedicatedServer))
    {
        PawnShadow = Spawn(class'ShadowProjector',Self,'',Location);
        PawnShadow.RootMotion = true;// Без смещения
        PawnShadow.ShadowActor = self;
        PawnShadow.bBlobShadow = bBlobShadow;
        PawnShadow.LightDirection = Normal(vect(1,1,3));
        PawnShadow.LightDistance = 320;
        PawnShadow.MaxTraceDistance = 350;
        PawnShadow.InitShadow();
    }
}


// ----------------------------------------------------------------------
// KillShadow()
// ----------------------------------------------------------------------
function KillShadow()
{
	if (PawnShadow != None)
	{
		PawnShadow.Destroy();
		PawnShadow = None;
	}
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
  }
  else if (!bInWorld && bEnter)
  {
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


// ----------------------------------------------------------------------
// GetDefaultCollisionHeight()
// ----------------------------------------------------------------------
function float GetDefaultCollisionHeight()
{
	return (Default.CollisionHeight-4.5);
}


// ----------------------------------------------------------------------
// GetCrouchHeight()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// GetSitHeight()
// ----------------------------------------------------------------------
function float GetSitHeight()
{
	return (GetDefaultCollisionHeight()+(BaseAssHeight*0.5));
}

// ----------------------------------------------------------------------
// IsPointInCylinder()
// ----------------------------------------------------------------------
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




// ----------------------------------------------------------------------
// GetNextWaypoint()
// ----------------------------------------------------------------------


// ----------------------------------------------------------------------
// GetNextVector()
// ----------------------------------------------------------------------



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
	log("FindTaggedActor returned "$bestActor);
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



// ----------------------------------------------------------------------
// UpdateActorVisibility()
// ----------------------------------------------------------------------



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



// ----------------------------------------------------------------------
// CheckCycle() [internal use only]
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// CheckEnemyPresence()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// CheckBeamPresence
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// CheckCarcassPresence()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// AddProjectileToList()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// IsProjectileDangerous()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// GetProjectileList()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// IsLocationDangerous()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// ComputeAwayVector()
// ----------------------------------------------------------------------



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
//		if (Weapon == None)
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
	local DeusExWeaponInv dxWeapon;
	local Weapon       oldWeapon;

	if (Weapon != None)
	{
		dxWeapon = DeusExWeaponInv(Weapon);
		if ((dxWeapon == None) || !dxWeapon.bNativeAttack)
		{
			oldWeapon = Weapon;
			SetWeapon(None);
			oldWeapon.DropFrom(Location);
		}
	}
}

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
//		if (Inventory != None)
//			Inventory.ChangedWeapon();
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

//	if (Inventory != None)
//		Inventory.ChangedWeapon();
//	if (Weapon != None)
//		Weapon.BringUp();

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
//	local float minLevel;

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
//	local float        newLevel;
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

	return pawnActor;

}




// ----------------------------------------------------------------------
// ReactToInjury()
// ----------------------------------------------------------------------
function ReactToInjury(Pawn instigatedBy, class<DamageType> damageType, EHitLocation hitPos)
{
	local Name currentState;
	local bool bHateThisInjury;
	local bool bFearThisInjury;

	if ((health > 0) && (instigatedBy != None) && (bLookingForInjury || bLookingForIndirectInjury))
	{
		currentState = Controller.GetStateName();

		bHateThisInjury = ShouldReactToInjuryType(damageType, bHateInjury, bHateIndirectInjury);
		bFearThisInjury = ShouldReactToInjuryType(damageType, bFearInjury, bFearIndirectInjury);

		if (bHateThisInjury)
			IncreaseAgitation(instigatedBy);
		if (bFearThisInjury)
			IncreaseFear(instigatedBy, 2.0);

		if (SetEnemy(instigatedBy))
		{
			SetDistressTimer();
			Controller.SetNextState('HandlingEnemy');
		}
		else if (bFearThisInjury && IsFearful())
		{
			SetDistressTimer();
			SetEnemy(instigatedBy, , true);
			Controller.SetNextState('Fleeing');
		}
		else
		{
//			if (instigatedBy.bIsPlayer)
//				ReactToFutz();
			Controller.SetNextState(currentState);
		}
		DXRAiController(Controller).GotoDisabledState(damageType, hitPos);
	}
}




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
//  local vector placeToStand;

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
	if ((Health < -100) && !IsA('Robot'))
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
					if ((DeusExWeaponInv(item) != None) && (DeusExWeaponInv(item).bNativeAttack))
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
//								 Level.Game.ReduceDamage(actualDamage, DamageType, self, instigatedBy);

	if (bInvincible) //ReducedDamageType == 'All') //God mode
		actualDamage = 0;
//	else if (Inventory != None) //then check if carrying armor
//		actualDamage = Inventory.ReduceDamage(actualDamage, DamageType, HitLocation);

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

	// calculate our hit extents
	headOffsetZ = CollisionHeight * 0.7;
	headOffsetY = CollisionRadius * 0.3;
	armOffset   = CollisionRadius * 0.35;

	hitPos = HITLOC_None;

	if (actualDamage > 0)
	{
		if (offset.z > headOffsetZ)		// head
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
		else if (offset.z < 0.0)	// legs
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
		else						// arms and torso
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
	log("hit position:"@hitpos);

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
			bleedRate += (origHealth-Health)/(0.3*Default.Health);  // 1/3 of default health = bleed profusely

//	if (CarriedDecoration != None)
//		DropDecoration();

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

	ReactToInjury(instigatedBy, damageType, hitPos);
	log(self@"Damaged by"@instigatedBy@"amount:"@Damage);
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



// ----------------------------------------------------------------------
// CheckOpenDoor()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// EncroachedBy()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// EncroachedByMover()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// FrobDoor()
// ----------------------------------------------------------------------


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
//	local texture oldSkin;

	if (newScaleGlow == 0)
		newScaleGlow = ScaleGlow;

//	oldSkin = Skin;
	for (i=0; i<skins.length; i++)
	{
		curSkin = skins[i]; //GetMeshTexture(i);
		Skins[i] = GetStyleTexture(newStyle, curSkin, newTex);
	}
//	Skin      = GetStyleTexture(newStyle, Skin, newTex);
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
//	Skin      = default.Skin;
	ScaleGlow = default.ScaleGlow;
	Style     = default.Style;
}

// ----------------------------------------------------------------------
// EnableCloak()
// beware! called from C++
// ----------------------------------------------------------------------
function EnableCloak(bool bEnable)
{
	if (!bHasCloak || (CloakEMPTimer > 0) || (Health <= 0) || bOnFire)
		bEnable = false;

	if (bEnable && !bCloakOn)
	{
		SetSkinStyle(STY_Translucent, Texture'WhiteStatic', 0.05);
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
//	SetDistressTimer();
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

//	log(self@"Try to PlayIdleSound()");

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
//			dxPlayer.StartAIBarkConversation(self, BM_Futz); // Џ®Є  в Є
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
//	ClientMessage("PlayIdle()");
	if (PhysicsVolume.bWaterVolume)
		LoopAnimPivot('Tread', , 0.3, , GetSwimPivot());
	else
	{
		if (HasTwoHandedWeapon())
			PlayAnimPivot('Idle12H', , 0.3);
		else
			PlayAnimPivot('Idle1', , 0.3);
	}
}

// ----------------------------------------------------------------------
// PlayTakeHitSound()
// ----------------------------------------------------------------------
function PlayTakeHitSound(int Damage, class <damageType> damageType, int Mult)
{
	local Sound hitSound;
	local float volume;

	if (Level.TimeSeconds - LastPainSound < 0.25)
		return;
	if (Damage <= 0)
		return;

	LastPainSound = Level.TimeSeconds;

	if (Damage <= 30)
		hitSound = HitSound1;
	else
		hitSound = HitSound2;
	volume = FMax(Mult*TransientSoundVolume, Mult*2.0);

//	SetDistressTimer();
	PlaySound(hitSound, SLOT_Pain, volume,,, RandomPitch());
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
// PlayFootStep()
//
// Plays footstep sounds based on the texture group
// (yes, I know this looks nasty -- I'll have to figure out a cleaner way to do this)
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
	local float shakeRadius, shakeMagnitude;
	local float playerDist;

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
					if (rnd < 0.25)
						stepSound = Sound'CarpetStep1';
					else if (rnd < 0.5)
						stepSound = Sound'CarpetStep2';
					else if (rnd < 0.75)
						stepSound = Sound'CarpetStep3';
					else
						stepSound = Sound'CarpetStep4';
					break;

				case 'Foliage':
				case 'Earth':
					volumeMultiplier = 0.6;
					if (rnd < 0.25)
						stepSound = Sound'GrassStep1';
					else if (rnd < 0.5)
						stepSound = Sound'GrassStep2';
					else if (rnd < 0.75)
						stepSound = Sound'GrassStep3';
					else
						stepSound = Sound'GrassStep4';
					break;

				case 'Metal':
				case 'Ladder':
					volumeMultiplier = 1.0;
					if (rnd < 0.25)
						stepSound = Sound'MetalStep1';
					else if (rnd < 0.5)
						stepSound = Sound'MetalStep2';
					else if (rnd < 0.75)
						stepSound = Sound'MetalStep3';
					else
						stepSound = Sound'MetalStep4';
					break;

				case 'Ceramic':
				case 'Glass':
				case 'Tiles':
					volumeMultiplier = 0.7;
					if (rnd < 0.25)
						stepSound = Sound'TileStep1';
					else if (rnd < 0.5)
						stepSound = Sound'TileStep2';
					else if (rnd < 0.75)
						stepSound = Sound'TileStep3';
					else
						stepSound = Sound'TileStep4';
					break;

				case 'Wood':
					volumeMultiplier = 0.7;
					if (rnd < 0.25)
						stepSound = Sound'WoodStep1';
					else if (rnd < 0.5)
						stepSound = Sound'WoodStep2';
					else if (rnd < 0.75)
						stepSound = Sound'WoodStep3';
					else
						stepSound = Sound'WoodStep4';
					break;

				case 'Brick':
				case 'Concrete':
				case 'Stone':
				case 'Stucco':
				default:
					volumeMultiplier = 0.7;
					if (rnd < 0.25)
						stepSound = Sound'StoneStep1';
					else if (rnd < 0.5)
						stepSound = Sound'StoneStep2';
					else if (rnd < 0.75)
						stepSound = Sound'StoneStep3';
					else
						stepSound = Sound'StoneStep4';
					break;
			}
		}
	}
	else
		stepSound = WalkSound;

	// compute sound volume, range and pitch, based on mass and speed
	speedFactor = VSize(Velocity)/120.0;
	massFactor  = Mass/150.0;
	radius      = 768.0;
	maxRadius   = 2048.0;
//	volume      = (speedFactor+0.2)*massFactor;//
//	volume      = (speedFactor+0.7)*massFactor;
	volume      = massFactor*1.5;
	range       = radius * volume;
	pitch       = (volume+0.5);
	volume      = 1.0; // DXR: I hear these sounds almost everywhere! 
//	log(self@"FootStep sound volume = "$volume$" within range(Radius) ="$range/6);
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

simulated function PlayFootStepLeft()
{
    PlayFootStep();
}

simulated function PlayFootStepRight()
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



// ----------------------------------------------------------------------
// PlayRunningAndFiring()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// PlayReloadBegin()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// PlayReload()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// PlayReloadEnd()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// TweenToShoot()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// PlayShoot()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// TweenToCrouchShoot()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// PlayCrouchShoot()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// TweenToAttack()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// PlayAttack()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// PlayTurning()
// ----------------------------------------------------------------------
function PlayTurning()
{
//	ClientMessage("PlayTurning()");
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
//	ClientMessage("TweenToWalking()");
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
//	ClientMessage("TweenToRunning()");
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
//	ClientMessage("PlayRunning()");
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
//	ClientMessage("PlayPanicRunning()");
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
//	ClientMessage("TweenToWaiting()");
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
// PlayWaiting()
// ----------------------------------------------------------------------
function PlayWaiting()
{
 if (Controller.IsInState('Paralyzed') || bSitting || bDancing || bStunned)
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
simulated event PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	local Vector X, Y, Z;
	local float dotp;

//	ClientMessage("PlayDying()");
	if (PhysicsVolume.bWaterVolume)
		PlayAnimPivot('WaterDeath',, 0.1);
	else if (bSitting)  // if sitting, always fall forward
		PlayAnimPivot('DeathFront',, 0.1);
	else
	{
		GetAxes(Rotation, X, Y, Z);
		dotp = (Location - HitLoc) dot X;

		// die from the correct side
		if (dotp < 0.0)		// shot from the front, fall back
			PlayAnimPivot('DeathBack',, 0.1);
		else				// shot from the back, fall front
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

//	EnableCloak(false);

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

	foreach BasedActors(class'Fire', f)
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
	// Return True if this NPC is in a conversable state                       // DXR: Sitting for now uses PHYS_Spider.
	return (bCanConverse && bInterruptState && ((Physics == PHYS_Walking) || (Physics == PHYS_Spider /*PHYS_Flying*/)));
//	return true; // for now
}

// ----------------------------------------------------------------------
// CanConverseWithPlayer()
// ----------------------------------------------------------------------
function bool CanConverseWithPlayer(DeusExPlayer dxPlayer)
{
/*	local name alliance1, alliance2, carcname;  // temp vars

	if (GetPawnAllianceType(dxPlayer) == ALLIANCE_Hostile)
		return false;
	else if ((GetStateName() == 'Fleeing') && (Enemy != dxPlayer) && (IsValidEnemy(Enemy, false)))  // hack
		return false;
	else if (GetCarcassData(dxPlayer, alliance1, alliance2, carcname))
		return false;
	else*/
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

//	UpdateReactionCallbacks();
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



// ----------------------------------------------------------------------
// ComputeThrowAngles()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// AISafeToThrow()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// AICanShoot()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// ComputeTargetLead()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// GetPawnWeaponRanges()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// GetWeaponBestRange()
// ----------------------------------------------------------------------
function GetWeaponBestRange(DeusExWeaponInv dxWeapon, out float bestRangeMin, out float bestRangeMax)
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




// ----------------------------------------------------------------------
// ReadyForNewEnemy()
// ----------------------------------------------------------------------



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
			if ((Controller.Enemy == checkPawn)) //|| (AICanSee(checkPawn, , false, false, true, true) > 0))
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
// ----------------------------------------------------------------------
function FindBestEnemy(bool bIgnoreCurrentEnemy)
{
	local Pawn  nextPawn;
	local Pawn  bestPawn;
	local float bestDist;
	local int   bestThreatLevel;
	local float newSeenTime;

	bestPawn        = None;
	bestDist        = 0;
	bestThreatLevel = 0;

	if (!bIgnoreCurrentEnemy && (Controller.Enemy != None))
		CheckEnemyParams(Controller.Enemy, bestPawn, bestThreatLevel, bestDist);
	foreach RadiusActors(class'Pawn', nextPawn, 2000)  // arbitrary
		if (Controller.enemy != nextPawn)
			CheckEnemyParams(nextPawn, bestPawn, bestThreatLevel, bestDist);

	if (bestPawn != Controller.Enemy)
		newSeenTime = 0;
	else
		newSeenTime = EnemyLastSeen;

	SetEnemy(bestPawn, newSeenTime, true);

	EnemyTimer = 0;
}




// ----------------------------------------------------------------------
// ShouldStrafe()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// ShouldFlee()
// ----------------------------------------------------------------------



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



// ----------------------------------------------------------------------
// ComputeBestFiringPosition()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// SetAttackAngle()
//
// Sets the angle from which an asynchronous attack will occur
// (hack needed for DeusExWeapon)
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// AdjustAim()
//
// Adjust the aim at target
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// IsThrownWeapon()
// ----------------------------------------------------------------------
function bool IsThrownWeapon(DeusExWeaponInv testWeapon)
{
	local Class<ThrownProjectile> throwClass;
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
	return bIsThrown;
}





function bool InStasis()
{
   if ((DistanceFromPlayer() > 1200.0) && (LastRenderTime > 5.0))
   return true;
   else return false;


//   return bStasis;
}
// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
// CALLBACKS AND OVERRIDDEN FUNCTIONS
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------
function Tick(float deltaTime)
{
//	local float        dropPeriod;
//	local float        adjustedRate;
	local DeusExPlayer player;
	local name         stateName;
	local vector       loc;
	local bool         bDoLowPriority;
	local bool         bCheckOther;
	local bool         bCheckPlayer;

	player = DeusExPlayer(GetPlayerPawn());
	myDxPlayer = player;

	Super.Tick(deltaTime);

	bDoLowPriority = true;
	bCheckPlayer   = true;
	bCheckOther    = true;

	if (bTickVisibleOnly)
	{
		if (DistanceFromPlayer() > 1200)
			bDoLowPriority = false;
		if (DistanceFromPlayer() > 2500)
			bCheckPlayer = false;
		if ((DistanceFromPlayer() > 600) && (LastRendered() >= 5.0))
			bCheckOther = false;
	}

	if (bDisappear && (InStasis() || (LastRendered() > 5.0)))
	{
	 if (Controller != none)
	  Controller.Destroy();

		Destroy();
		return;
	}

	if (AvoidWallTimer > 0)
	{
		AvoidWallTimer -= deltaTime;
		if (AvoidWallTimer < 0)
			AvoidWallTimer = 0;
	}

	if (AvoidBumpTimer > 0)
	{
		AvoidBumpTimer -= deltaTime;
		if (AvoidBumpTimer < 0)
			AvoidBumpTimer = 0;
	}

	if (ObstacleTimer > 0)
	{
		ObstacleTimer -= deltaTime;
		if (ObstacleTimer < 0)
			ObstacleTimer = 0;
	}
//
	if /*(*/(Controller != none) //&& (controller.bAdvancedTactics))
	{
		if ((Acceleration == vect(0,0,0)) || (Physics != PHYS_Walking) || (TurnDirection == TURNING_None))
		{
			//bAdvancedTactics = false;
//			controller.bPreparingMove = false;
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
				player.StartConversation(Self, IM_Radius);
		}

/*		if (CheckEnemyPresence(deltaTime, bCheckPlayer, bCheckOther))
			HandleEnemy();
		else
		{
			CheckBeamPresence(deltaTime);
			if (bDoLowPriority || LastRendered() < 5.0)
				CheckCarcassPresence(deltaTime);  // hacky -- may change state!
		}*/
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
  controller.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType); // Send to controller?

	TakeDamageBase(Damage, instigatedBy, hitlocation, momentum, damageType, true);
}

// ----------------------------------------------------------------------
// Timer()
// ----------------------------------------------------------------------
function Timer()
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



// ----------------------------------------------------------------------
// ZoneChange()
// ----------------------------------------------------------------------
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

//	if (CarriedDecoration != None)
//		return false;
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
		start.Z += 1.1 * MaxStepHeight + CollisionHeight;
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



// ----------------------------------------------------------------------
// SwitchToBestWeapon()
// ----------------------------------------------------------------------
function bool SwitchToBestWeapon()
{
	local Inventory    inv;
	local DeusExWeaponInv curWeapon;
	local float        score;
	local DeusExWeaponInv dxWeapon;
	local DeusExWeaponInv bestWeapon;
	local float        bestScore;
	local int          fallbackLevel;
	local int          curFallbackLevel;
	local bool         bBlockSpecial;
	local bool         bValid;
	local bool         bWinner;
	local float        minRangeA, accRange;
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

	bBlockSpecial = false;
	dxWeapon = DeusExWeaponInv(Weapon);
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

		if (DeusExWeaponInv(Controller.Enemy.Weapon) != None)
			DeusExWeaponInv(Controller.Enemy.Weapon).GetWeaponRanges(minEnemy, accEnemy, maxEnemy);

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
			i = 0;
			while (loopInv != None)
			{
				i++;
				if (i > 300)
					break;
				log("   Inventory "$i$" - "$loopInv);
				loopInv = loopInv.Inventory;
			}
		}

		curWeapon = DeusExWeaponInv(inv);
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
				if ((curWeapon.EnviroEffective == ENVEFF_Air) || (curWeapon.EnviroEffective == ENVEFF_Vacuum) || (curWeapon.EnviroEffective == ENVEFF_AirVacuum))
					if (curWeapon.PhysicsVolume.bWaterVolume)
						bValid = false;
			}

			if (bValid)
			{
				GetWeaponBestRange(curWeapon, minRangeA, accRange);
				cutoffRange = minRangeA+(CollisionRadius+enemyRadius);
				range = (accRange - minRangeA) * 0.5;
				centerRange = minRangeA + range;
				if (range < 50)
					range = 50;
				if (enemyRange < centerRange)
					score = (centerRange - enemyRange)/range;
				else
					score = (enemyRange - centerRange)/range;
				if ((minRangeA >= minEnemy) && (accRange <= accEnemy))
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

// ----------------------------------------------------------------------
// HandleTurn()
// ----------------------------------------------------------------------
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
  if (bEnableCheckDest)
  {
    if (DestAttempts >= 2)
    {
      dxDecoration = DeusExDecoration(Other);
      scrPawn      = ScriptedPawn(Other);
      if (dxDecoration != None)
      {
        if (!dxDecoration.bInvincible && !dxDecoration.bExplosive) // ha ha ha !!!!!!!!!!
        {
          dxDecoration.HitPoints = 0;
          dxDecoration.TakeDamage(1, self, dxDecoration.Location, vect(0,0,0), class'DM_Shot');
          bHandle = false;
        }
        else if (DestAttempts >= 3)
        {
          bHackState = true;
          bHandle    = false;
        }
      }
      else if (scrPawn != None)
      {
        if (DestAttempts >= 3)
        {
          if (scrPawn.Controller.GetStateName() != 'BackingOff')
          {
            bHackState = true;
            bHandle    = false;
          }
        }
      }
    }

    if (bHackState)
   BackOff();
  }

  return (bHandle);
}

// ----------------------------------------------------------------------
// Bump()
// ----------------------------------------------------------------------

/*function Bump(actor Other)
{
  local Rotator      rot1, rot2;
  local int          yaw;
  local ScriptedPawn avoidPawn;
  local DeusExPlayer dxPlayer;
  local bool         bTurn;

//  log(self@"Bumped by "$Other);

  // Handle futzing and projectiles
  if (Other.Physics == PHYS_Falling)
  {
    if (DeusExProjectile(Other) != None)
    log("Projectile reaction here!", self.name);
//      ReactToProjectiles(Other);
    else
    {
      dxPlayer = DeusExPlayer(Other.Instigator);
      if ((Other != dxPlayer) && (dxPlayer != None))
			ReactToFutz();
    }
  }
  
  // Have we walked into another (non-level) actor?
  bTurn = false;
  if ((Physics == PHYS_Walking) && (Acceleration != vect(0,0,0)) && bWalkAround && (Other != Level) && !Other.IsA('Mover'))
    if ((TurnDirection == TURNING_None) || (AvoidBumpTimer <= 0))
      if (HandleTurn(Other))
        bTurn = true;

  // Turn away from the actor
  if (bTurn)
  {
    // If we're not already turning, start
    if (TurnDirection == TURNING_None)
    {
      // Give ourselves a little extra time
      controller.MoveTimer += 4.0;

      rot1 = Rotator(Other.Location-Location);  // direction of object being bumped
      rot2 = Rotator(Acceleration);  // direction we wish to go
      yaw  = (rot2.Yaw - rot1.Yaw) & 65535;
      if (yaw > 32767)
        yaw -= 65536;

      // Depending on the angle we bump the actor, turn left or right
      if (yaw < 0)
      {
        TurnDirection = TURNING_Left;
        NextDirection = TURNING_Right;
      }
      else
      {
        TurnDirection = TURNING_Right;
        NextDirection = TURNING_Left;
      }
      bClearedObstacle = false;
    }

    // Ignore multiple bumps in a row
    // BOOGER! Ignore same bump actor?
    if (AvoidBumpTimer <= 0)
    {
      AvoidBumpTimer   = 0.2;
      ActorAvoiding    = Other;
      bClearedObstacle = false;

		// Enable AlterDestination()
			//Controller.bAdvancedTactics = true;

      avoidPawn = ScriptedPawn(ActorAvoiding);

      // Avoid pairing off
      if (avoidPawn != None)
      {
        if ((avoidPawn.Acceleration != vect(0,0,0)) && (avoidPawn.Physics == PHYS_Walking) &&
            (avoidPawn.TurnDirection != TURNING_None) && (avoidPawn.ActorAvoiding == self))
        {
          if ((avoidPawn.TurnDirection == TURNING_Left) && (TurnDirection == TURNING_Right))
          {
            TurnDirection = TURNING_Left;
            if (NextDirection != TURNING_None)
              NextDirection = TURNING_Right;
          }
          else if ((avoidPawn.TurnDirection == TURNING_Right) && (TurnDirection == TURNING_Left))
          {
            TurnDirection = TURNING_Right;
            if (NextDirection != TURNING_None)
              NextDirection = TURNING_Left;
          }
        }
      }
    }
  }
}    */


function AlterDestination()
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
	local ETurning oldTurnDir;

	oldTurnDir = TurnDirection;

	// Sanity check -- are we done walking around the actor?
	if (TurnDirection != TURNING_None)
	{
		if (!bWalkAround)
			TurnDirection = TURNING_None;
		else if (bClearedObstacle)
			TurnDirection = TURNING_None;
		else if (ActorAvoiding == None)
			TurnDirection = TURNING_None;
		else if (ActorAvoiding.bDeleteMe)
			TurnDirection = TURNING_None;
		else if (!IsPointInCylinder(ActorAvoiding, Location, CollisionRadius*2, CollisionHeight*2))
			TurnDirection = TURNING_None;
	}

	// Are we still turning?
	if (TurnDirection != TURNING_None)
	{
		bAround = false;

		// Is our destination point inside the actor we're walking around?
		bPointInCylinder = IsPointInCylinder(ActorAvoiding, controller.Destination, CollisionRadius-8, CollisionHeight-8);
		if (bPointInCylinder)
		{
			dist1 = VSize((Location - ActorAvoiding.Location)*vect(1,1,0));
			dist2 = VSize((Location - Controller.Destination)*vect(1,1,0));

			// Are we on the right side of the actor?
			if (dist1 > dist2)
			{
				// Just make a beeline, if possible
				tempVect = Controller.Destination - ActorAvoiding.Location;
				tempVect.Z = 0;
				tempVect = Normal(tempVect) * (ActorAvoiding.CollisionRadius + CollisionRadius);
				if (tempVect == vect(0,0,0))
				{
					controller./*Destination*/ focalPoint = Location;
					controller.Destination = Location;
				}
				else
				{
					tempVect += ActorAvoiding.Location;
					tempVect.Z = Controller.Destination.Z;
					controller./*Destination*/ focalPoint = tempVect;
					controller.Destination = tempVect;
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
			dir      = Rotator(ActorAvoiding.Location-Location);
			avoidYaw = dir.Yaw;
			dir      = Rotator(controller.Destination-Location);
			destYaw  = dir.Yaw;

			if (TurnDirection == TURNING_Left)
				angle = (avoidYaw - destYaw) & 65535;
			else
				angle = (destYaw - avoidYaw) & 65535;
			if (angle < 0)
				angle += 65536;

			// If the angle is between 90 and 180 degrees, we've cleared the obstacle
			if (bPointInCylinder || (angle < 16384) || (angle > 32768))  // haven't cleared the actor yet
			{
				if (TurnDirection == TURNING_Left)
					moveYaw = avoidYaw - 16384;
				else
					moveYaw = avoidYaw + 16384;
				controller./*Destination*/ focalPoint = Location + Vector(rot(0,1,0)*moveYaw)*400;
				controller.Destination = Location + Vector(rot(0,1,0)*moveYaw)*400;
			}
			else  // cleared the actor -- move on
				TurnDirection = TURNING_None;
		}
	}

	if (TurnDirection == TURNING_None)
	{
		if (ObstacleTimer > 0)
		{
			TurnDirection = oldTurnDir;
			bClearedObstacle = true;
		}
	}
	else
		ObstacleTimer = 1.5;

	// Reset if done turning
	if (TurnDirection == TURNING_None)
	{
		NextDirection    = TURNING_None;
		ActorAvoiding    = None;
		bAdvancedTactics = false;
		ObstacleTimer    = 0;
		bClearedObstacle = true;

		if (oldTurnDir != TURNING_None)
			controller.MoveTimer -= 4.0;
	}
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
			flagName = class'DxUtil'.static.StringToName(BindName$"_Dead");
			GetflagBase().SetBool(flagName, True);

			// make sure the flag never expires
			GetflagBase().SetExpiration(flagName, FLAG_Bool, 0);

			if (bStunned)
			{
				flagName = class'DxUtil'.static.StringToName(BindName$"_Unconscious");
				GetflagBase().SetBool(flagName, True);

				// make sure the flag never expires
				GetflagBase().SetExpiration(flagName, FLAG_Bool, 0);
			}
		}
	}
	GoToState('Dying');
}


function SetInitialState()
{
  Super.SetInitialState();

  Controller.SetFall();
  //InitializePawn();
}

function InitializePawn()
{
	if (!bInitialized)
	{
		InitializeInventory();
		InitializeAlliances();
		InitializeHomeBase();

		BlockReactions();

		if (Alliance != '')
			ChangeAlly(Alliance, 1.0, true);

		if (!bInWorld)
		{
			// tricky
			bInWorld = true;
			LeaveWorld();
		}

		// hack!
//		animTimer[1] = 20.0;
//		PlayTurnHead(LOOK_Forward, 1.0, 0.0001);

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
	local DeusExWeaponInv    weapons[8];
	local int                weaponCount;
	local DeusExWeaponInv    firstWeapon;

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
					if (inv != None)
					{
						inv.InitialState='Idle2';
						inv.GiveTo(Self);
						inv.SetBase(Self);
						if ((firstWeapon == None) && (Weapon(inv) != None))
							firstWeapon = DeusExWeaponInv(inv);
					}
				}
			}
			if (firstWeapon != None)
				weapons[WeaponCount++] = firstWeapon;
		}
	}
	for (i=0; i<weaponCount; i++)
	{
		if ((weapons[i].AmmoType == None) && (weapons[i].AmmoName != None) && (weapons[i].AmmoName != class'AmmoNoneInv'))
		{
			weapons[i].AmmoType = Ammunition(FindInventoryType(weapons[i].AmmoName));
			if (weapons[i].AmmoType == None)
			{
				weapons[i].AmmoType = spawn(weapons[i].AmmoName);
				weapons[i].AmmoType.InitialState='Idle2';
				weapons[i].AmmoType.GiveTo(Self);
				weapons[i].AmmoType.SetBase(Self);
			}
		}
	}
	SetupWeapon(false);
}







// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// EnterConversationState()
// ----------------------------------------------------------------------
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
	ignores SeePlayer, EnemyNotVisible, HearNoise, KilledBy, Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, WarnTarget, /*Died,*/ Timer, TakeDamage;

	event Landed(vector HitNormal)
	{
		SetPhysics(PHYS_Walking);
	}

	function Tick(float deltaSeconds)
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
		EnableCheckDestLoc(false);
		StandUp();

		bInterruptState = false;
		BlockReactions(true);
		bCanConverse = False;
		bStasis = False;
		SetDistress(true);
		DeathTimer = 0;
	}

	function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
	{
	   Global.Died(Killer, damageType, HitLocation);
	}


Begin:
  Sleep(0.1);
	MoveFallingBody();

	DesiredRotation.Pitch = 0;
	DesiredRotation.Roll  = 0;

	// if we don't gib, then wait for the animation to finish
	if ((Health > -100) && !IsA('Robot'))
		FinishAnim();

	SetWeapon(None);

	bHidden = true;

	Acceleration = vect(0,0,0);
	Controller.Destroy();
	SpawnCarcass();
	Destroy();
}


/*event Landed(vector HitNormal)
{
    super.Landed(HitNormal);
} */

/*
function JumpOffPawn()
{
	Velocity += (60 + CollisionRadius) * VRand();
	Velocity.Z = 180 + CollisionHeight;
	SetPhysics(PHYS_Falling);
	bJumpOffPawn = true;
	SetFall();
  //log("ERROR - JumpOffPawn should not be called!");
}*/



function SetOrders(Name orderName, optional Name newOrderTag, optional bool bImmediate)
{
   Controller.SetOrders(orderName, newOrderTag, bImmediate);
}


// ----------------------------------------------------------------------
// Reloading()
// ----------------------------------------------------------------------

function Reloading(DeusExWeaponInv reloadWeapon, float reloadTime)
{
	if (reloadWeapon == Weapon)
		ReloadTimer = reloadTime;
}

// ----------------------------------------------------------------------
// DoneReloading()
// ----------------------------------------------------------------------

function DoneReloading(DeusExWeaponInv reloadWeapon)
{
	if (reloadWeapon == Weapon)
		ReloadTimer = 0;
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
  if (level.GetLocalPlayerController().pawn != none)
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

function DeusExLevelInfo GetLevelInfo()
{
	local DeusExLevelInfo info;

	foreach AllActors(class'DeusExLevelInfo', info)
		break;

		if (info != none)
		    DxLevel = info;

	return info;
}


function bool PlayTurnHead(ELookDirection dir, float rate, float tweentime);
function LipSynch(float deltatime);

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

function float GetLastConEndTime()	// Time when last conversation ended
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
     WalkingSpeed=0.400000
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
     CrouchHeight=26.0
     CrouchRadius=20.0

     //  bCanOpenDoors=True
     //  bIsHuman=True
     AirSpeed=320.000000
     AccelRate=200.000000
     JumpZ=120.000000
     HearingThreshold=0.150000
     
     Texture=Texture'Engine.S_Pawn'
		 bAcceptsProjectors=true
		 ControllerClass=class'DXRAiController'

 			bCanWalkOffLedges=true
			bAvoidLedges=false		// don't get too close to ledges
			bStopAtLedges=false		// if bAvoidLedges and bStopAtLedges, Pawn doesn't try to walk along the edge at all
		  bCanClimbLadders=true

		  bSpecialCalcView=true
      RotationRate=(Pitch=4096,Yaw=50000,Roll=3072)

			physics=phys_falling//none

			bPhysicsAnimUpdate=false
			bFullVolume=false

			bActorShadows=true

      bIgnoreOutOfWorld=true // Don't destroy if fell out of world

      bShouldBaseAtStartup=true

      SoundOcclusion=OCCLUSION_BSP

      bCanFly=false
}
