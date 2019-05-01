class DeusExPawn extends Pawn abstract native;

// Base class for ALL other DXR pawns


// #ifdef REFACTOR_ME
// TODO: Содержимое REFACTOR_ME-блока не требуется в нативном коде, лучше вынести в базовые подклассы в DeusEx.u

const CON_BARK_PREFIX = "_Bark";

enum ELookDirection {
	LOOK_Forward,
	LOOK_Left,
	LOOK_Right,
	LOOK_Up,
	LOOK_Down
};

var(Conversation) editconst transient array<ConDialogue> conlist; // Диалоги хранятся здесь.
var(Conversation) String BindName,BarkBindName,FamiliarName,UnfamiliarName;
var float ConStartInterval;     // Amount of time required between two convos.
var	travel   float       LastConEndTime;			// Time when last conversation ended

var(AI)        float   AIHorizontalFov;            // degrees
var(AI)        float   AspectRatio;                // horizontal/vertical ratio
var(AI)        float   AngularResolution;          // degrees
var            float   MinAngularSize;             // tan(AngularResolution)^2
var(AI)        float   VisibilityThreshold;        // lowest visible brightness (0-1)
var(AI)        float   SmellThreshold;             // lowest smellable odor (0-1)
var(Alliances) Name    Alliance;                   // alliance tag
var            Rotator AIAddViewRotation;          // rotation added to view rotation for AICanSee()

var(Advanced) bool        bBlockSight;   // True if pawns can't see through this actor.
var(Advanced) bool        bDetectable;   // True if this actor can be detected (by sight, sound, etc).
var(Advanced) bool        bTransient;    // True if this actor should be destroyed when it goes into stasis
var           bool        bIgnore;       // True if this actor should be generally ignored; compliance is voluntary
var(Advanced) bool        bOwned;

var bool bVisionImportant;

var bool bAdvancedTactics; // Для обхода препятствий

var bool bOnFire;
var float burnTimer;


var name	BlendAnimSequence[4];
var float	BlendAnimFrame[4];
var float	BlendAnimRate[4];
var float	BlendTweenRate[4];

var float animTimer[4];		// misc. timers for ambient anims (blink, head, etc.)

var bool bIsSpeaking;
var bool bWasSpeaking;		// were we speaking last frame?  (should we close our mouth?)
var string lastPhoneme, nextPhoneme;
var bool bLipsyncHackActive;

var(Sounds) sound WalkSound;
var(Sounds)	sound	Die;
var(Sounds) sound HitSound1;
var(Sounds) sound HitSound2;
var(Sounds) sound Land;

var() travel int HealthHead;
var() travel int HealthTorso;
var() travel int HealthLegLeft;
var() travel int HealthLegRight;
var() travel int HealthArmLeft;
var() travel int HealthArmRight;

var name NextState; //for queueing states
var name NextLabel; //for queueing states


function array<Object> GetConList() {
   return conList;
}

function RegisterConFiles(string Path);
function AddRefCount();
function DecreaseRefCount();
function ConDialogue FindConversationByName(string conName);
function ConBindEvents();
function LoadConsForMission(int mission);

// #endif // #ifdef REFACTOR_ME


native final iterator function TraceActorsExt(class<Actor> BaseClass, out Actor OutActor, out vector HitLoc, out vector HitNorm, vector End, optional vector Start, optional vector Extent, optional int TraceFlags);

native final function bool WalkReachable(Vector Dest, int ReachFlags, Actor GoalActor);
native final function bool FlyReachable(Vector Dest, int ReachFlags, Actor GoalActor);
native final function bool SwimReachable(Vector Dest, int ReachFlags, Actor GoalActor);
