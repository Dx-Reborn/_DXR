//
//
//

class WeaponEx extends RuntimeWeapon;

#exec OBJ LOAD FILE=DeusExItems.ukx

var bool				bReadyToFire;			// true if our bullets are loaded, etc.
var() int				LowAmmoWaterMark;		// critical low ammo count
var travel int			ClipCount;				// number of bullets remaining in current clip
var() travel float momentum; // передаваемый импульс

var() class<Skill>		GoverningSkill;			// skill that affects this weapon
var() travel float		NoiseLevel;				// amount of noise that weapon makes when fired
var() EEnemyEffective	EnemyEffective;			// type of enemies that weapon is effective against
var() EEnviroEffective	EnviroEffective;		// type of environment that weapon is effective in
var() EConcealability	Concealability;			// concealability of weapon
var() travel bool		bAutomatic;				// is this an automatic weapon?
var() travel float		ShotTime;				// number of seconds between shots
var() travel float		ReloadTime;				// number of seconds needed to reload the clip
var() int				HitDamage;				// damage done by a single shot (or for shotguns, a single slug)
//var() int				MaxRange;				// absolute maximum range in world units (feet * 16)
var() travel int AccurateRange;			// maximum accurate range in world units (feet * 16)
var() travel float BaseAccuracy;			// base accuracy (0.0 is dead on, 1.0 is far off)

var bool				bCanHaveScope;			// can this weapon have a scope?
var() travel bool		bHasScope;				// does this weapon have a scope?
var() int				ScopeFOV;				// FOV while using scope
var bool				bZoomed;				// are we currently zoomed?
var bool				bWasZoomed;				// were we zoomed? (used during reloading)

var bool				bCanHaveLaser;			// can this weapon have a laser sight?
var() travel bool		bHasLaser;				// does this weapon have a laser sight?
var bool				bLasing;				// is the laser sight currently on?
var EM_LaserBeam Emitter;				// actual laser emitter - valid only when bLasing == True

var bool				bCanHaveSilencer;		// can this weapon have a silencer?
var() travel bool		bHasSilencer;			// does this weapon have a silencer?

var() bool				bCanTrack;				// can this weapon lock on to a target?
var() float				LockTime;				// how long the target must stay targetted to lock
var float				LockTimer;				// used for lock checking
var Actor				Target;					// actor currently targetted
var ELockMode			LockMode;				// is this target locked?
var string				TargetMessage;			// message to print during targetting
var float				TargetRange;			// range to current target
var() Sound				LockedSound;			// sound to play when locked
var() Sound				TrackingSound;			// sound to play while tracking a target
var float				SoundTimer;				// to time the sounds correctly

var() EAreaType			AreaOfEffect;			// area of effect of the weapon
var() bool				bPenetrating;			// shot will penetrate and cause blood
var() float				StunDuration;			// how long the shot stuns the target
var() bool				bHasMuzzleFlash;		// does this weapon have a flash when fired?
var() bool				bHandToHand;			// is this weapon hand to hand (no ammo)?
var() travel float		recoilStrength;			// amount that the weapon kicks back after firing (0.0 is none, 1.0 is large)
var bool				bFiring;				// True while firing, used for recoil
var bool				bOwnerWillNotify;		// True if firing hand-to-hand weapons is dependent on the owner's animations
var bool				bFallbackWeapon;		// If True, only use if no other weapons are available
var bool				bNativeAttack;			// True if weapon represents a native attack
var bool				bEmitWeaponDrawn;		// True if drawing this weapon should make NPCs react
var bool				bUseWhileCrouched;		// True if NPCs should crouch while using this weapon
var bool				bUseAsDrawnWeapon;		// True if this weapon should be carried by NPCs as a drawn weapon

var bool bNearWall;								// used for prox. mine placement
var Vector placeLocation;						// used for prox. mine placement
var Vector placeNormal;							// used for prox. mine placement
var Mover placeMover;							// used for prox. mine placement

var float ShakeTimer;
var float ShakeYaw;
var float ShakePitch;

var float AIMinRange;							// minimum "best" range for AI; 0=default min range
var float AIMaxRange;							// maximum "best" range for AI; 0=default max range
var float AITimeLimit;							// maximum amount of time an NPC should hold the weapon; 0=no time limit
var float AIFireDelay;							// Once fired, use as fallback weapon until the timeout expires; 0=no time limit

var float standingTimer;						// how long we've been standing still (to increase accuracy)
var float currentAccuracy;						// what the currently calculated accuracy is (updated every tick)

//var MuzzleFlash flash;							// muzzle flash actor
var transient material tracedmat;

// Used to track weapon mods accurately.
var bool bCanHaveModBaseAccuracy,bCanHaveModReloadCount,bCanHaveModAccurateRange,bCanHaveModReloadTime,bCanHaveModRecoilStrength;
var travel float ModBaseAccuracy;
var travel float ModReloadCount;
var travel float ModAccurateRange;
var travel float ModReloadTime;
var travel float ModRecoilStrength;

var localized String msgCannotBeReloaded,msgOutOf,msgNowHas,msgAlreadyHas,msgNone,msgLockInvalid,msgLockRange,msgLockAcquire;
var localized String msgLockLocked,msgRangeUnit,msgTimeUnit,msgMassUnit,msgNotWorking;

//
// strings for info display
//
var localized String msgInfoAmmoLoaded,msgInfoAmmo,msgInfoDamage,msgInfoClip,msgInfoROF,msgInfoReload,msgInfoRecoil,msgInfoAccuracy;
var localized String msgInfoAccRange,msgInfoMaxRange,msgInfoMass,msgInfoLaser,msgInfoScope,msgInfoSilencer,msgInfoNA,msgInfoYes;
var localized String msgInfoNo,msgInfoAuto,msgInfoSingle,msgInfoRounds,msgInfoRoundsPerSec,msgInfoSkill,msgInfoWeaponStats;

var() sound CockingSound, ReloadEndSound;
var() Vector ProjSpawnOffset; // +x forward, +y right, +z up
var() float AltRefireRate, RefireRate;
var() travel bool bInstantHit;

var MuzzleFlash flash;							// muzzle flash actor


/*-----------------------------------------------------------------------------------------------------------------------*/
function bool HasReloadMod()
{
	return (ModReloadTime != 0.0);
}

function bool HasMaxReloadMod()
{
	return (ModReloadTime == -0.5);
}

function bool HasClipMod()
{
	return (ModReloadCount != 0.0);
}

function bool HasMaxClipMod()
{
	return (ModReloadCount == 0.5);
}

function bool HasRangeMod()
{
	return (ModAccurateRange != 0.0);
}

function bool HasMaxRangeMod()
{
	return (ModAccurateRange == 0.5);
}

function bool HasAccuracyMod()
{
	return (ModBaseAccuracy != 0.0);
}

function bool HasMaxAccuracyMod()
{
	return (ModBaseAccuracy == 0.5);
}

function bool HasRecoilMod()
{
	return (ModRecoilStrength != 0.0);
}

function bool HasMaxRecoilMod()
{
	return (ModRecoilStrength == -0.5);
}

function int GetinvSlotsX()         // Number of horizontal inv. slots this item takes
{return invSlotsX;}

function int GetinvSlotsY()         // Number of vertical inv. slots this item takes
{return invSlotsY;}

function bool	GetInObjectBelt()     // Is this object actually in the object belt?
{return bInObjectBelt;}

function SetToObjectBelt(optional int position)     // Is this object actually in the object belt?
{bInObjectBelt = true;}

function int GetbeltPos()           // Position on the object belt
{return beltPos;}

function SetbeltPos(int position)           // Position on the object belt
{beltPos = position;}

function string GetDescription()
{return description;}

function string GetbeltDescription()  // Description used on the object belt
{return beltdescription;}

function float GetlargeIconWidth()
{return largeIconWidth;}

function float GetlargeIconHeight()
{return largeIconHeight;}

function int GetinvPosX() // X position on the inventory window
{return invPosX;}

function int GetinvPosY() // Y position on the inventory window
{return invPosY;}

function SetinvPosX(int position) // X position on the inventory window
{invPosX = position;}

function SetinvPosY(int position) // Y position on the inventory window
{invPosY = position;}

function texture GetIcon()
{return icon;}

function texture GetLargeIcon()
{return largeIcon;}


/*function Frob(Actor Frobber, Inventory FrobWith)
{
  pawn(Frobber).ClientMessage(PickupMessage @ ItemName);
  GiveTo(pawn(Frobber));
  BecomeItem();
}

function BecomeItem()
{
	RemoteRole    = ROLE_SimulatedProxy;
	SetDrawType(DT_Mesh);
//	DrawScale     = PlayerViewScale;
	bOnlyOwnerSee = true;
	bHidden       = true;
	NetPriority   = 1.4;
	SetCollision(false, false, false);
	SetPhysics(PHYS_None);
	AmbientGlow = 0;
}*/



defaultproperties
{
    bReadyToFire=True
    LowAmmoWaterMark=10
    NoiseLevel=1.00
    ShotTime=0.50
    reloadTime=1.00
    HitDamage=10
    maxRange=9600
    AccurateRange=4800
    BaseAccuracy=0.50
    ScopeFOV=10
    bPenetrating=True
    bHasMuzzleFlash=True
    bEmitWeaponDrawn=True
    bUseWhileCrouched=True
    bUseAsDrawnWeapon=True
    msgCannotBeReloaded="This weapon can't be reloaded"
    msgOutOf="Out of %s"
    msgNowHas="%s now has %s loaded"
    msgAlreadyHas="%s already has %s loaded"
    msgNone="NONE"
    msgLockInvalid="INVALID"
    msgLockRange="RANGE"
    msgLockAcquire="ACQUIRE"
    msgLockLocked="LOCKED"
    msgRangeUnit="FT"
    msgTimeUnit="SEC"
    msgMassUnit="LBS"
    msgNotWorking="This weapon doesn't work underwater"
    msgInfoAmmoLoaded="Ammo loaded:"
    msgInfoAmmo="Ammo type(s):"
    msgInfoDamage="Base damage:"
    msgInfoClip="Clip size:"
    msgInfoROF="Rate of fire:"
    msgInfoReload="Reload time:"
    msgInfoRecoil="Recoil:"
    msgInfoAccuracy="Base Accuracy:"
    msgInfoAccRange="Acc. range:"
    msgInfoMaxRange="Max. range:"
    msgInfoMass="Mass:"
    msgInfoLaser="Laser sight:"
    msgInfoScope="Scope:"
    msgInfoSilencer="Silencer:"
    msgInfoNA="N/A"
    msgInfoYes="YES"
    msgInfoNo="NO"
    msgInfoAuto="AUTO"
    msgInfoSingle="SINGLE"
    msgInfoRounds="RDS"
    msgInfoRoundsPerSec="RDS/SEC"
    msgInfoSkill="Skill:"
    msgInfoWeaponStats="Weapon Stats:"
    ReloadCount=10
    Misc1Sound=Sound'DeusExSounds.Generic.DryFire'
    LandSound=Sound'DeusExSounds.Generic.DropSmallWeapon'

    PickupMessage="You found"
    ItemName="DEFAULT WEAPON NAME - REPORT THIS AS A BUG"
		Description="DeusExWeaponInv base class"
    Mass=10.00
    Buoyancy=5.00

    invSlotsX=1
    invSlotsY=1

		momentum=1000
		bCanThrow=true
		bDisplayableinv=true
		PlayerViewPivot=(Pitch=0,Roll=0,Yaw=-32768)
    ProjSpawnOffset=(X=0,Y=0,Z=-10)
}