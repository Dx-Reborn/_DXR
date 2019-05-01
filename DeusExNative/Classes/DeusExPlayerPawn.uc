class DeusExPlayerPawn extends DeusExPawn native;


// #ifdef REFACTOR_ME
// TODO: —одержимое REFACTOR_ME-блока не требуетс€ в нативном коде, лучше вынести в базовые подклассы в DeusEx.u

enum EMusicMode {
	MUS_Ambient,
	MUS_Combat,
	MUS_Conversation,
	MUS_Outro,
	MUS_Dying
};

var EMusicMode musicMode;
var float savedSongPos;
var float musicCheckTimer;
var float musicChangeTimer;

var(Flags) editconst travel array<byte> RawByteFlags;

var localized String InventoryFull;
var localized String TooMuchAmmo;
var localized String TooHeavyToLift;
var localized String CannotLift;
var localized String NoRoomToLift;
var localized String CanCarryOnlyOne;
var localized String CannotDropHere;
var localized String HandsFull;
var localized String NoteAdded;
var localized String GoalAdded;
var localized String PrimaryGoalCompleted;
var localized String SecondaryGoalCompleted;
var localized String EnergyDepleted;
var localized String AddedNanoKey;
var localized String HealedPointsLabel;
var localized String HealedPointLabel;
var localized String SkillPointsAward;
var localized String QuickSaveGameTitle;

// used while crouching
var travel  bool bForceDuck;
var travel bool bCrouchOn;				// used by toggle crouch // travel
var travel bool bWasCrouchOn;			// used by toggle crouch
var travel byte lastbDuck;				// used by toggle crouch

var transient cameraeffect ce;    // ”казатель на эффект камеры
var bool bMblurActive;

// #endif // #ifdef REFACTOR_ME
