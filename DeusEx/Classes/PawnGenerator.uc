//=============================================================================
// PawnGenerator.
//=============================================================================
class PawnGenerator extends Effects
	abstract;

struct PawnTypes  {
	var() int                 Count;
	var   int                 CurCount;
	var() Class<ScriptedPawn> PawnClass;
};

struct PawnData  {
	var bool                bValid;
	var ScriptedPawn        Pawn;
	var Class<ScriptedPawn> PawnClass;
};

var   PawnTypes      PawnClasses[8];   // All classes that will be generated
var() Name           Orders;           // Orders for generated pawns
var() Name           OrderTag;         // Order tag for generated pawns
var() Name           Alliance;         // Alliance for generated pawns
var() bool           bGeneratorIsHome; // True if this generator should act as a home base
var() float          PawnHomeExtent;   // Extent of the home area; 0 means the extent is the same as the radius
var() float          ActiveArea;       // Maximum player distance from generator
var() float          Radius;           // Radius in which to spawn pawns
var() bool           bTriggered;       // True if this generator will be triggered
var() int            MaxCount;         // Maximum number of pawns in existence at any one time

var(Special) bool    bPawnsTransient;  // True if pawns should disappear when out of range
var(Special) bool    bRandomCount;     // If True, number of generated pawns will be random
var(Special) bool    bRandomTypes;     // If True, pawn classes will be randomized (with correct distribution)
var(Special) bool    bRepopulate;      // True if generator will spawn pawns forever
var          bool    bLOSCheck;        // True if we should check LOS if pawns are transient (OBSOLESCENT!)

var(Special) float   Focus;            // 0=pawns will face random directions; 1=pawns will face
                                       // same direction as pawn generator

var   int            PawnCount;        // Current number of pawns in existence
var   int            PoolCount;        // Total number of pawns that will EVER be generated
var   PawnData       Pawns[32];        // All pawns currently in existence
var   GeneratorScout Scout;            // Scout pawn used to place pawns
var   bool           bActive;          // True if this generator is active
var   float          TryTimer;         // Timer used to generate pawns
var   vector         GroundLocation;   // Starting point
var   bool           bDying;           // True if no more pawns should be generated
var   bool           bScoutInit;       // True if the scout has been initialized

var   vector         LastGenLocation;  // Last location
var   rotator        LastGenRotation;  // Last rotation

var   vector         SumVelocities;    // Cumulative velocities of all pawns; used for flocking
var   vector         FlockCenter;      // Rough average center point of a flock
var   float          VelocityTimer;    // Timer for checking velocities
var   vector         RandomVelocity;   // Random velocity for turns
var   float          TurnPeriod;       // Amount of time to add a "turn" velocity
var   float          CoastPeriod;      // Amount of time to coast without adding velocity
var   float          CoastTimer;       // Timer for adding random velocities
var   float          StatusTimer;      // Should we do a StatusUpdate this frame


// ----------------------------------------------------------------------
// PostBeginPlay()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// Destroyed()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// Burst()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// StopGenerator()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// ComputeGroundLocation()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// SetPawnHome()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// SetAllHome()
// ----------------------------------------------------------------------




// ----------------------------------------------------------------------
// Trigger()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// SpawnScout()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// GenerateRandomVelocity()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// GenerateCoastPeriod()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// IsPawnValid()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// InvalidatePawn()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// IsActorUnnecessary()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// PlayerCanSeeActor()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// FindUsedPawnClass()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// PickRandomClass()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// CheckPawnStatus()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// UpdateSumVelocities()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// GetClassPhysics()
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// GeneratePawn()
// ----------------------------------------------------------------------

defaultproperties
{
     PawnClasses(0)=(Count=1)
     PawnClasses(1)=(Count=1)
     PawnClasses(2)=(Count=1)
     PawnClasses(3)=(Count=1)
     PawnClasses(4)=(Count=1)
     PawnClasses(5)=(Count=1)
     PawnClasses(6)=(Count=1)
     PawnClasses(7)=(Count=1)
     Orders=Wandering
     ActiveArea=2000.000000
     Radius=600.000000
     bLOSCheck=True
     TurnPeriod=0.800000
     CoastPeriod=8.000000
     bHidden=True
     bDirectional=True
     Texture=Texture'Engine.S_Inventory'
     CollisionRadius=10.000000
     CollisionHeight=6.000000
}
