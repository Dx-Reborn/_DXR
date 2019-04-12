class NPCPawn extends DXRPawn
                      //abstract
                      exportstructs
                      native;

cpptext
{
	NO_DEFAULT_CONSTRUCTOR(ANPCPawn)

	UBOOL IsValidEnemy(ADXRPawn *testPawn, UBOOL bCheckAlliance=TRUE);
	EAllianceType GetAllianceType(FName allianceName);
  EAllianceType GetPawnAllianceType(ADXRPawn *queryPawn);

	UBOOL Tick(FLOAT deltaSeconds, ELevelTick tickType);
	void UpdateAgitation(FLOAT deltaSeconds);
	void UpdateFear(FLOAT deltaSeconds);
	UBOOL HaveSeenCarcass(FName carcassName);
	void AddCarcass(FName carcassName);

  UBOOL InStasis(void);
}

enum EDestinationType  {
	DEST_Failure,
	DEST_NewLocation,
	DEST_SameLocation
};


enum EAllianceType  {
	ALLIANCE_Friendly,
	ALLIANCE_Neutral,
	ALLIANCE_Hostile
};


enum ERaiseAlarmType  {
	RAISEALARM_BeforeAttacking,
	RAISEALARM_BeforeFleeing,
	RAISEALARM_Never
};


enum ESeekType  {
	SEEKTYPE_None,
	SEEKTYPE_Sound,
	SEEKTYPE_Sight,
	SEEKTYPE_Guess,
	SEEKTYPE_Carcass
};


enum EHitLocation  {
	HITLOC_None,
	HITLOC_HeadFront,
	HITLOC_HeadBack,
	HITLOC_TorsoFront,
	HITLOC_TorsoBack,
	HITLOC_LeftLegFront,
	HITLOC_LeftLegBack,
	HITLOC_RightLegFront,
	HITLOC_RightLegBack,
	HITLOC_LeftArmFront,
	HITLOC_LeftArmBack,
	HITLOC_RightArmFront,
	HITLOC_RightArmBack
};


enum ETurning  {
	TURNING_None,
	TURNING_Left,
	TURNING_Right
};


// ----------------------------------------------------------------------
// Structures
struct InitialAllianceInfo  {
	var() Name  AllianceName;
	var() float AllianceLevel;
	var() bool  bPermanent;
};

struct AllianceInfoEx  {
	var Name  AllianceName;
	var float AllianceLevel;
	var float AgitationLevel;
	var bool  bPermanent;
};


// ----------------------------------------------------------------------
// Variables
var(Combat) float    BaseAccuracy;  // 0-1 or thereabouts
var(Combat) float    MaxRange;
var(Combat) float    MinRange;
var(Combat) float    MinHealth;

var(AI) float    RandomWandering;  // 0-1

var float       sleepTime;
var Actor       destPoint;
var Vector      destLoc;
var Vector      useLoc;
var Rotator     useRot;
var float       seekDistance;  // OBSOLETE
var int         SeekLevel;
var ESeekType   SeekType;
var Pawn        SeekPawn;
var float       CarcassTimer;
var float       CarcassHateTimer;  // OBSOLETE
var float       CarcassCheckTimer;
var name        PotentialEnemyAlliance;
var float       PotentialEnemyTimer;
var float       BeamCheckTimer;
var bool        bSeekPostCombat;
var bool        bSeekLocation;
var bool        bInterruptSeek;
var bool        bAlliancesChanged;         // set to True whenever someone changes AlliancesEx[i].AllianceLevel to indicate we must do alliance updating
var bool        bNoNegativeAlliances;      // True means we know all alliances are currently +, allows us to skip CheckEnemyPresence's slow part

var bool        bSitAnywhere;
var bool        bSitInterpolation;
var bool        bStandInterpolation;
var float       remainingSitTime;
var float       remainingStandTime;
var vector      StandRate;
var float       ReloadTimer;
var bool        bReadyToReload;

// Advanced AI attributes.
var(Orders) name	Orders;         // orders a creature is carrying out 
                                  // will be initial state, plus creature will attempt
                                  // to return to this state

var(Orders) name  OrderTag;       // tag of object referred to by orders
var(Orders) name  HomeTag;        // tag of object to use as home base
var(Orders) float HomeExtent;     // extent of home base
var         actor OrderActor;     // object referred to by orders (if applicable)
var         name  NextAnim;       // used in states with multiple, sequenced animations	
var         float WalkingSpeed;   // 0-1

var(Combat)	float ProjectileSpeed;
var         name  LastPainAnim;

var         vector DesiredPrePivot;
var         float  PrePivotTime;
var         vector PrePivotOffset;

var     bool        bCanBleed;      // true if an NPC can bleed
var     float       BleedRate;      // how profusely the NPC is bleeding; 0-1
var     float       DropCounter;    // internal; used in tick()
var()   float       ClotPeriod;     // seconds it takes bleedRate to go from 1 to 0

var     bool        bAcceptBump;    // ugly hack
var     bool        bCanFire;       // true if pawn is capable of shooting asynchronously
var(AI) bool        bKeepWeaponDrawn;  // true if pawn should always keep weapon drawn
var(AI) bool        bShowPain;      // true if pawn should play pain animations
var(AI) bool        bCanSit;        // true if pawn can sit
var(AI) bool        bAlwaysPatrol;  // true if stasis should be disabled during patrols
var(AI) bool        bPlayIdle;      // true if pawn should fidget while he's standing
var(AI) bool        bLeaveAfterFleeing;  // true if pawn should disappear after fleeing
var(AI) bool        bLikesNeutral;  // true if pawn should treat neutrals as friendlies
var(AI) bool        bUseFirstSeatOnly;   // true if only the nearest chair should be used for 
var(AI) bool        bCower;         // true if fearful pawns should cower instead of fleeing

var()   bool        bImportant;      // true if this pawn is game-critical
var()   bool        bInvincible;     // true if this pawn cannot be killed

var     bool        bInitialized;    // true if this pawn has been initialized

var(Combat) bool    bAvoidAim;      // avoid enemy's line of fire
var(Combat) bool    bAimForHead;    // aim for the enemy's head
var(Combat) bool    bDefendHome;    // defend the home base

var         bool    bSeekCover;     // seek cover
var         bool    bSprint;        // sprint in random directions
var(Combat) bool    bUseFallbackWeapons;  // use fallback weapons even when others are available
var         float   AvoidAccuracy;  // how well we avoid enemy's line of fire; 0-1
var         bool    bAvoidHarm;     // avoid painful projectiles, gas clouds, etc.
var         float   HarmAccuracy;   // how well we avoid harm; 0-1
var         float   CrouchRate;     // how often the NPC crouches, if bCrouch enabled; 0-1
var         float   SprintRate;     // how often the NPC randomly sprints if bSprint enabled; 0-1
var         float   CloseCombatMult;  // multiplier for how often the NPC sprints in close combat; 0-1

// If a stimulation is enabled, it causes an NPC to hate the stimulator
//var(Stimuli) bool   bHateFutz;
var(Stimuli) bool   bHateHacking;  // new
var(Stimuli) bool   bHateWeapon;
var(Stimuli) bool   bHateShot;
var(Stimuli) bool   bHateInjury;
var(Stimuli) bool   bHateIndirectInjury;  // new
//var(Stimuli) bool   bHateGore;
var(Stimuli) bool   bHateCarcass;  // new
var(Stimuli) bool   bHateDistress;
//var(Stimuli) bool   bHateProjectiles;

// If a reaction is enabled, the NPC will react appropriately to a stimulation
var(Reactions) bool bReactFutz;  // new
var(Reactions) bool bReactPresence;         // React to the presence of an enemy (attacking)
var(Reactions) bool bReactLoudNoise;        // Seek the source of a loud noise (seeking)
var(Reactions) bool bReactAlarm;            // Seek the source of an alarm (seeking)
var(Reactions) bool bReactShot;             // React to a gunshot fired by an enemy (attacking)
//var(Reactions) bool bReactGore;             // React to gore appropriately (seeking)
var(Reactions) bool bReactCarcass;          // React to gore appropriately (seeking)
var(Reactions) bool bReactDistress;         // React to distress appropriately (attacking)
var(Reactions) bool bReactProjectiles;      // React to harmful projectiles appropriately

// If a fear is enabled, the NPC will run away from the stimulator
var(Fears) bool     bFearHacking;           // Run away from a hacker
var(Fears) bool     bFearWeapon;            // Run away from a person holding a weapon
var(Fears) bool     bFearShot;              // Run away from a person who fires a shot
var(Fears) bool     bFearInjury;            // Run away from a person who causes injury
var(Fears) bool     bFearIndirectInjury;    // Run away from a person who causes indirect injury
var(Fears) bool     bFearCarcass;           // Run away from a carcass
var(Fears) bool     bFearDistress;          // Run away from a person causing distress
var(Fears) bool     bFearAlarm;             // Run away from the source of an alarm
var(Fears) bool     bFearProjectiles;       // Run away from a projectile

var(AI) bool        bEmitDistress;          // TRUE if NPC should emit distress

var(AI) ERaiseAlarmType RaiseAlarm;         // When to raise an alarm

var     bool        bLookingForEnemy;             // TRUE if we're actually looking for enemies
var     bool        bLookingForLoudNoise;         // TRUE if we're listening for loud noises
var     bool        bLookingForAlarm;             // TRUE if we're listening for alarms
var     bool        bLookingForDistress;          // TRUE if we're looking for signs of distress
var     bool        bLookingForProjectiles;       // TRUE if we're looking for projectiles that can harm us
var     bool        bLookingForFutz;              // TRUE if we're looking for people futzing with stuff
var     bool        bLookingForHacking;           // TRUE if we're looking for people hacking stuff
var     bool        bLookingForShot;              // TRUE if we're listening for gunshots
var     bool        bLookingForWeapon;            // TRUE if we're looking for drawn weapons
var     bool        bLookingForCarcass;           // TRUE if we're looking for carcass events
var     bool        bLookingForInjury;            // TRUE if we're looking for injury events
var     bool        bLookingForIndirectInjury;    // TRUE if we're looking for secondary injury events

var     bool        bFacingTarget;          // True if pawn is facing its target
var(Combat) bool    bMustFaceTarget;        // True if an NPC must face his target to fire
var(Combat) float   FireAngle;              // TOTAL angle (in degrees) in which a pawn may fire if bMustFaceTarget is false
var(Combat) float   FireElevation;          // Max elevation distance required to attack (0=elevation doesn't matter)

var(AI) int         MaxProvocations;
var     float       AgitationSustainTime;
var     float       AgitationDecayRate;
var     float       AgitationTimer;
var     float       AgitationCheckTimer;
var     float       PlayerAgitationTimer;  // hack

var     float       FearSustainTime;
var     float       FearDecayRate;
var     float       FearTimer;
var     float       FearLevel;

var     float       EnemyReadiness;
var     float       ReactionLevel;
var     float       SurprisePeriod;
var     float       SightPercentage;
var     float       CycleTimer;
var     float       CyclePeriod;
var     float       CycleCumulative;
var     Pawn        CycleCandidate;
var     float       CycleDistance;

var     float       AlarmTimer;
var     float       WeaponTimer;
var     float       FireTimer;
var     float       SpecialTimer;
var     float       CrouchTimer;
var     float       BackpedalTimer;

var     bool        bHasShadow;
var     float       ShadowScale;
var     bool        bDisappear;

var(Alliances) InitialAllianceInfo InitialAlliances[8];
var            AllianceInfoEx      AlliancesEx[16];
var            bool                bReverseAlliances;

var(Pawn) float     BaseAssHeight;

var(AI)   float     EnemyTimeout;
var       float     CheckPeriod;
var       float     EnemyLastSeen;
var       int       SeatSlot;

var       int       CycleIndex;
var       int       BodyIndex;
var       bool      bRunningStealthy;
var       bool      bPausing;
var       bool      bStaring;
var       bool      bAttacking;
var       bool      bDistressed;
var       bool      bStunned;
var       bool      bSitting;
var       bool      bDancing;
var       bool      bCrouching;

var       bool      bCanTurnHead;

var(AI)   bool      bTickVisibleOnly;   // Temporary?
var()     bool      bInWorld;
var       vector    WorldPosition;
var       bool      bWorldCollideActors;
var       bool      bWorldBlockActors;
var       bool      bWorldBlockPlayers;

var()     bool      bHighlight;         // should this object not highlight when focused?

var(AI)   bool      bHokeyPokey;

var       bool      bConvEndState;

var bool bConversationEndedNormally;
var bool bInConversation;
var Actor ConversationActor;						// Actor currently speaking to or speaking to us

var float swimBubbleTimer;
var bool  bSpawnBubbles;

var      bool     bUseSecondaryAttack;

var      bool     bWalkAround;
var      bool     bClearedObstacle;
var      bool     bEnableCheckDest;
var      ETurning TurnDirection;
var      ETurning NextDirection;
var      Actor    ActorAvoiding;
var      float    AvoidWallTimer;
var      float    AvoidBumpTimer;
var      float    ObstacleTimer;
var      vector   LastDestLoc;
var      vector   LastDestPoint;
var      int      DestAttempts;

var      float    DeathTimer;
var      float    EnemyTimer;
var      float    TakeHitTimer;

var      name     ConvOrders;
var      name     ConvOrderTag;

var      float    BurnPeriod;

var      float    FutzTimer;

var      float    DistressTimer;

var      bool     bBurnedToDeath;

var      bool     bHasCloak;
var      bool     bCloakOn;
var      int      CloakThreshold;
var      float    CloakEMPTimer;

var      float    poisonTimer;      // time remaining before next poison TakeDamage
var      int      poisonCounter;    // number of poison TakeDamages remaining
var      int      poisonDamage;     // damage taken from poison effect
var      Pawn     Poisoner;         // person who initiated PoisonEffect damage

var      Name     Carcasses[4];     // list of carcasses seen
var      int      NumCarcasses;     // number of carcasses seen

var      float    walkAnimMult;
var      float    runAnimMult;

// ToDo: Проверить свободные номера для этих функций.

native /*(2105)*/ final function bool IsValidEnemy(DXRPawn TestEnemy, optional bool bCheckAlliance);
native /*(2106)*/ final function EAllianceType GetAllianceType(Name AllianceName);
native /*(2107)*/ final function EAllianceType GetPawnAllianceType(DXRPawn QueryPawn);

native /*(2108)*/ final function bool HaveSeenCarcass(Name CarcassName);
native /*(2109)*/ final function AddCarcass(Name CarcassName);


