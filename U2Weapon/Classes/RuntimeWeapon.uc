/*
  Old-style weapon without WeaponFire. Based on UE2Runtime weapon class.
*/
class RuntimeWeapon extends Weapon
                            placeable;

#exec obj load file=DeusExItems.ukx

//
// enums for weapons (duh)
//
enum EEnemyEffective
{
	ENMEFF_All,
	ENMEFF_Organic,
	ENMEFF_Robot
};

enum EEnviroEffective
{
	ENVEFF_All,
	ENVEFF_Air,
	ENVEFF_Water,
	ENVEFF_Vacuum,
	ENVEFF_AirWater,
	ENVEFF_AirVacuum,
	ENVEFF_WaterVacuum
};

enum EConcealability
{
	CONC_None,
	CONC_Visual,
	CONC_Metal,
	CONC_All
};

enum EAreaType
{
	AOE_Point,
	AOE_Cone,
	AOE_Sphere
};

enum ELockMode
{
	LOCK_None,
	LOCK_Invalid,
	LOCK_Range,
	LOCK_Acquire,
	LOCK_Locked
};

//-----------------------------------------------------------------------------
// Weapon ammo information:
var()	class<ammunition> AmmoName;     // Type of ammo used.
var		travel ammunition	AmmoType;	// Inventory Ammo being used.
var() class<ammunition>		AmmoNames[3];			// three possible types of ammo per weapon
var() class<Projectile> ProjectileNames[3];		// projectile classes for different ammo
var() class<projectile> ProjectileClass;
var() class<projectile> AltProjectileClass;
var() int projectileSpeed;
var() travel byte ReloadCount;			// Amount of ammo depletion before reloading. 0 if no reloading is done.
var()	int     PickupAmmoCount;		// Amount of ammo initially in pick-up item.
//-----------------------------------------------------------------------------
// Weapon firing/state information:
var		bool	  bPointing;		// Indicates weapon is being pointed
var		bool	  bWeaponUp;		// Used in Active State
var		bool	  bChangeWeapon;	// Used in Active State
var		bool	  bRapidFire;		// used by pawn animations in determining firing animation, and for net replication
var		bool	  bForceReload;

var		float	StopFiringTime;	// repeater weapons use this
var		int		AutoSwitchPriority;
var     vector	FireOffset;			// Offset from first person eye position for projectile/trace start
var		texture	CrossHair;
var		Powerups Affector;			// powerup chain currently affecting this weapon

//-----------------------------------------------------------------------------
// AI information
var		float	AimError;		// Aim Error for bots (note this value doubled if instant hit weapon)
var		float	TraceDist;		// how far instant hit trace fires go
var		float   MaxRange;		// max range of weapon for non-trace hit attacks
var		Rotator AdjustedAim;

//-----------------------------------------------------------------------------
// Sound Assignments
var() sound FireSound;
var() sound Misc1Sound;
var() sound Misc2Sound;
var() sound Misc3Sound;
var() sound PickupSound;
var() sound LandSound;

// messages
var   Color NameColor;	// used when drawing name on HUD
var		bool	bSteadyToggle;
var		bool bForceFire, bForceAltFire;
var string	LeftHandedMesh;	// string of name of left-handed view mesh (if different)

//-----------------------------------------------------------------------------
// first person Muzzle Flash
// weapon is responsible for setting and clearing bMuzzleFlash whenever it wants the
// MFTexture drawn on the canvas (see RenderOverlays() )

var					float	FlashTime;			// time when muzzleflash will be cleared (set in RenderOverlays())
var(MuzzleFlash)	float	MuzzleScale;		// scaling of muzzleflash
var(MuzzleFlash)	float	FlashOffsetY;		// flash center offset from centered Y (as pct. of Canvas Y size) 
var(MuzzleFlash)	float	FlashOffsetX;		// flash center offset from centered X (as pct. of Canvas X size) 
var(MuzzleFlash)	float	FlashLength;		// How long muzzle flash should be displayed in seconds
var(MuzzleFlash)	float	MuzzleFlashSize;	// size of (square) texture
var					texture MFTexture;			// first-person muzzle flash sprite
var					byte	FlashCount;			// when incremented, draw muzzle flash for current frame
var					bool	bAutoFire;			// when changed, draw muzzle flash for current frame
var					bool	bMuzzleFlash;		// if !=0 show first-person muzzle flash
var					bool	bSetFlashTime;		// reset FlashTime clock when false
var					bool	bDrawMuzzleFlash;	// enable first-person muzzle flash

//-----------------------------------------------------------------------------
// third person muzzleflash

var	bool	bMuzzleFlashParticles;
var	mesh	MuzzleFlashMesh;
var	float	MuzzleFlashScale;
var	ERenderStyle MuzzleFlashStyle;
var	texture MuzzleFlashTexture;
var float FireAdjust;

// camera shakes //
var(ShakeView) vector ShakeRotMag;           // how far to rot view
var(ShakeView) vector ShakeRotRate;          // how fast to rot view
var(ShakeView) float  ShakeRotTime;          // how much time to rot the instigator's view
var(ShakeView) vector ShakeOffsetMag;        // max view offset vertically
var(ShakeView) vector ShakeOffsetRate;       // how fast to offset view vertically
var(ShakeView) float  ShakeOffsetTime;       // how much time to offset view

var FireProperties aFireProperties;

//
// DEUS_EX AJY - additions (from old DeusExPickup)
//
var bool					bCanUseObjectBelt; // Can this object be placed on the object belt?
var texture					Icon;         // Icon for the inventory window
var texture					largeIcon;         // Larger-than-usual icon for the inventory window
var int						largeIconWidth;    // Width of graphic in texture
var int						largeIconHeight;   // Height of graphic in texture
var(Inventory) int						invSlotsX;         // Number of horizontal inv. slots this item takes
var(Inventory) int						invSlotsY;         // Number of vertical inv. slots this item takes
var(Inventory) travel int				invPosX;           // X position on the inventory window
var(Inventory) travel int				invPosY;           // Y position on the inventory window
var(ObjectBelt) travel bool				bInObjectBelt;     // Is this object actually in the object belt?
var(ObjectBelt) travel int				beltPos;           // Position on the object belt
var localized String		beltDescription;   // Description used on the object belt
var localized string PickupMessage;

var	  bool bHeldItem;	// Set once an item has left pickup state.
var	  bool bSleepTouch; // Set when item is touched when leaving sleep state.
var() bool bWeaponStay;
var() bool bAmbientGlow;

// New from 1.1112fm
var vector SwingOffset;     // offsets for this weapon swing.
var float MinWeaponAcc;        // Minimum accuracy for a weapon at all.  Affects only multiplayer.
var float MinSpreadAcc;        // Minimum accuracy for multiple slug weapons (shotgun).  Affects only multiplayer,
                               // keeps shots from all going in same place (ruining shotgun effect)
var float MinProjSpreadAcc;

var(WeaponAI) bool	  bWarnTarget;		 // When firing projectile, warn the target
var(WeaponAI) bool	  bAltWarnTarget;	 // When firing alternate projectile, warn the target

/*----------------------------------------------------------------------------------------------------------------
 Properties to behave like old-style weapons. Third person mesh is not used, because there is better replacement.
----------------------------------------------------------------------------------------------------------------*/
var() vertmesh PickupViewMesh; // Only VertMesh is supported! But for powerups (like sodacan) any mesh type will work fine.
                               // UE2.5 supports three types of models: Skeletal mesh (or just Mesh), StaticMesh and VertMesh.
                               // VertMesh is like old-style meshes from Unreal. Use only when really required. Don't use
                               // VertMesh for first-person items (two meshes will be always rendered).
var() mesh FirstPersonViewMesh; // Skeletal mesh for FP view.

var() const float  FirstPersonDrawScale;
var() const vector FirstPersonDrawScale3D;
var() const float  PickupViewDrawScale;
var() const vector PickupViewDrawScale3D;

// Do not fill these arrays if you want to leave all skins as defined in the package.
var() array<material> PickupViewSkins; // materials for Pickup version
var() array<material> FirstPersonViewSkins; // materials for FP version


function Rotator AdjustAim(Vector Start, float InAimError)
{
	if ( !aFireProperties.bInitialized )
	{
		aFireProperties.AmmoClass = AmmoType.class;//AmmoClass;
		aFireProperties.ProjectileClass = AmmoType.ProjectileClass;
		aFireProperties.WarnTargetPct = AmmoType.WarnTargetPct;
		aFireProperties.MaxRange = MaxRange;//();
		aFireProperties.bTossed = bTossedOut;
		aFireProperties.bTrySplash = AmmoType.bRecommendSplashDamage;
		aFireProperties.bLeadTarget = AmmoType.bLeadTarget;
		aFireProperties.bInstantHit = AmmoType.bInstantHit;
		aFireProperties.bInitialized = true;
	}
    return Instigator.AdjustAim(aFireProperties, Start, InAimError);
}

event TravelPostAccept()
{
	Super.TravelPostAccept();
	if (Pawn(Owner) == None)
		return;
	if (AmmoName != None)
	{
		AmmoType = Ammunition(Pawn(Owner).FindInventoryType(AmmoName));
		if (AmmoType == None)
		{
			AmmoType = Spawn(AmmoName);	// Create ammo type required		
			Pawn(Owner).AddInventory(AmmoType);		// and add to player's inventory
			AmmoType.AmmoAmount = PickUpAmmoCount; 
			AmmoType.GotoState('Idle2');
		}
		else
		{
		AmmoType.RestoreAmmoAmount();
		log("AmmoType.AmmoAmount="$AmmoType.AmmoAmount);
		}

	}
	if (self == Pawn(Owner).Weapon)
		BringUp();
	else GotoState('');
}

function GiveAmmo(Pawn Other)
{
	if ( AmmoName == None )
		return;

	AmmoType = Ammunition(Other.FindInventoryType(AmmoName));
	if (AmmoType != None)
		AmmoType.AddAmmo(PickUpAmmoCount);
	else
	{
		AmmoType = Spawn(AmmoName);	// Create ammo type required		
		Other.AddInventory(AmmoType);		// and add to player's inventory
		AmmoType.BecomeItem();
		AmmoType.AmmoAmount = PickUpAmmoCount; 
		AmmoType.GotoState('Idle2');
	}
}

/*
HandlePickupQuery()
If picking up another weapon of the same class, add its ammo.
If ammo count was at zero, check if should auto-switch to this weapon.
*/
function bool HandlePickupQuery(inventory Item)
{
	local Pawn P;

	if (Item.Class == Class)
	{
		if (RuntimeWeapon(item).bWeaponStay && (!RuntimeWeapon(item).bHeldItem || RuntimeWeapon(item).bTossedOut))
			return true;

		P = Pawn(Owner);

		if (AmmoType != None)
		{
      // DEUS_EX CNN - never switch weapons automatically, but do add the ammo
			AmmoType.AddAmmo(RuntimeWeapon(Item).PickupAmmoCount);
		}
		P.ClientMessage(RuntimeWeapon(Item).PickupMessage @ Item.itemName, 'Pickup');

		Item.PlaySound(RuntimeWeapon(Item).PickupSound);
		Item.Destroy();//SetRespawn();
		return true;
	}
	if (Inventory == None)
		return false;

	return Inventory.HandlePickupQuery(Item);
}

/* Render useful information on HUD */
simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	local string T;
	local name Anim;
	local float frame,rate;

	Canvas.SetDrawColor(0,255,0);
	Canvas.DrawText("WEAPON "$GetItemName(string(self)));
	YPos += YL;
	Canvas.SetPos(4,YPos);

	T = "     STATE: "$GetStateName()$" Timer: "$TimerCounter;

	if ( Default.ReloadCount > 0 )
		T = T$" Reload Count: "$ReloadCount;

	Canvas.DrawText(T, false);
	YPos += YL;
	Canvas.SetPos(4,YPos);
	
	if ( DrawType == DT_StaticMesh )		
		Canvas.DrawText("     StaticMesh "$StaticMesh$" AmbientSound "$AmbientSound, false);
	else 
		Canvas.DrawText("     Mesh "$Mesh$" AmbientSound "$AmbientSound, false);
	YPos += YL;
	Canvas.SetPos(4,YPos);
	if ( Mesh != None )
	{
		// mesh animation
		GetAnimParams(0,Anim,frame,rate);
		T = "     AnimSequence "$Anim$" Frame "$frame$" Rate "$rate;
		if ( bAnimByOwner )
			T= T$" Anim by Owner";
		
		Canvas.DrawText(T, false);
		YPos += YL;
		Canvas.SetPos(4,YPos);
	}

	if ( AmmoType == None )
	{
		Canvas.DrawText("ERROR - NO AMMUNITION");
		YPos += YL;
		Canvas.SetPos(4,YPos);
	}
	else
		AmmoType.DisplayDebug(Canvas,YL,YPos);
}

/*--- Animation && other functions -----------------------------------*/
simulated function PlaySelect()
{
	bForceFire = false;
	bForceAltFire = false;
	if (!IsAnimating() || !AnimIsInGroup(0,'Select'))
		PlayAnim('Select',1.0,0.0);
	Owner.PlaySound(SelectSound, SLOT_Misc, 1.0);	
}

simulated function PlayPostSelect()
{
	GotoState('Idle');
	AnimEnd(0);
}

simulated function TweenDown()
{
	local name Anim;
	local float frame,rate;

	if (/*IsAnimating()*/ GetAnimSequence() != '' && AnimIsInGroup(0,'Select'))
	{
		GetAnimParams(0,Anim,frame,rate);
		TweenAnim(Anim, frame * 0.4); //0.4
	}
	else
		PlayAnim('Down', 1.0, 0.05);
}

simulated function bool PutDown()
{
	bChangeWeapon = true;
	GotoState('DownWeapon');		// DEUS_EX CNN - added to force the weapon down
	return true; 
}

simulated function BringUp(optional weapon PrevWeapon)
{
	if ((PrevWeapon != None) && PrevWeapon.HasAmmo())
		OldWeapon = PrevWeapon;
	else
		OldWeapon = None;
	if (Instigator.IsHumanControlled())
	{
		SetHand(PlayerController(Instigator.Controller).Handedness);
		PlayerController(Instigator.Controller).EndZoom();
	}	
	bWeaponUp = false;
	PlaySelect();
	GotoState('Active');
}


function SwitchToWeaponWithAmmo()
{
	// if local player, switch weapon
	//Instigator.Controller.SwitchToBestWeapon();
	if (bChangeWeapon)
	{
		GotoState('DownWeapon');
		return;
	}
	else
		GotoState('Idle');
}

simulated function ClientFinish();

function CheckAnimating();
simulated function PlayIdleAnim();

simulated function bool NeedsToReload()
{
	return (bForceReload || (Default.ReloadCount > 0) && (ReloadCount == 0));
}

// Override in subclasses
function TraceFire(float Accuracy);

//Spawn appropriate effects at hit location, any weapon lights, and damage hit actor
function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z);

simulated function vector GetFireStart(vector X, vector Y, vector Z)
{
	return (Instigator.Location + Instigator.EyePosition() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z); 
}

/* if projectile class is None, spawns class defined in AmmoType */
simulated function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn);

simulated function PlayFiring();

simulated function bool RepeatFire()
{
	return bRapidFire;
}


simulated function Fire(float Value);
simulated function AltFire(float Value);

function ServerStopFiring();


simulated function PlayReloading()
{
	AnimEnd(0);
}


// DEUS_EX STM - added
function PlayLandingSound()
{
	if (LandSound != None)
		PlaySound(LandSound);
}

function BecomePickup()
{
	if (Physics != PHYS_Falling)
		RemoteRole    = ROLE_SimulatedProxy;

	LinkMesh(PickupViewMesh);
	SetDrawScale(PickupViewDrawScale);
	SetDrawScale3D(PickupViewDrawScale3D);
	SetDrawType(DT_Mesh);
	Skins.Length = PickupViewSkins.Length;
  Skins = PickupViewSkins;

	bOnlyOwnerSee = false;
	bHidden       = false;
	NetPriority   = 1.4;
	SetCollision(true, false, false);		// make things block actors as well - DEUS_EX CNN
}                    //true

function BecomeItem()
{
log(self$" BecomeItem? ");
	RemoteRole    = ROLE_SimulatedProxy;

	LinkMesh(FirstPersonViewMesh);
	SetDrawScale(FirstPersonDrawScale);
	SetDrawScale3D(FirstPersonDrawScale3D);
	SetDrawType(DT_Mesh);
	Skins.Length = FirstPersonViewSkins.Length;
  Skins = FirstPersonViewSkins;

	bOnlyOwnerSee = true;
	bHidden       = true;
	NetPriority   = 1.4;
	SetCollision(false, false, false);
	SetPhysics(PHYS_None);
	AmbientGlow = 0;
}

function inventory SpawnCopy(pawn Other)
{
	local inventory Copy;
	local RuntimeWeapon newWeapon;

	Copy = self;

	RuntimeWeapon(Copy).bHeldItem = true;
	RuntimeWeapon(Copy).bTossedOut = false;

	// DEUS_EX AJY
	// Give weapon ammo before giving to player	
	RuntimeWeapon(Copy).GiveAmmo(Other);
	Copy.GiveTo(Other);
	
	newWeapon = RuntimeWeapon(Copy);
	newWeapon.Instigator = Other;
//	newWeapon.SetSwitchPriority(Other);

	newWeapon.AmbientGlow = 0;
	return newWeapon;
}

function GiveTo(pawn Other)
{
	Instigator = Other;
	BecomeItem();
	Other.AddInventory(Self);
	GotoState('Idle2');
}

function DropFrom(vector StartLocation)
{
	if (!SetLocation(StartLocation))
		return; 

	if (Instigator != None)
	{
		DetachFromPawn(Instigator);
		Instigator.DeleteInventory(self);
	}

	SetDefaultDisplayProperties();
	Instigator = None;
	StopAnimating();

	SetPhysics(PHYS_Falling);
	RemoteRole = ROLE_DumbProxy;
	BecomePickup();
	NetPriority = 2.5;
	bCollideWorld = true;

	bTossedOut = true;

	Inventory = None;

	if (AmmoType != None)
	{
		if (String(RuntimeAmmunition(AmmoType).Mesh) == "DeusExItems.TestBox")
		{
			PickupAmmoCount = AmmoType.AmmoAmount;
			AmmoType.AmmoAmount = 0;
		}
		else
			PickupAmmoCount = 0;
	}

	GotoState('PickUp', 'Dropped');
}


function Finish();


/*--- States ---------------------------------------------------------*/

auto state() Pickup
{
	singular function PhysicsVolumeChange(PhysicsVolume NewVolume)
	{
		local float splashsize;
		local actor splash;

		if(NewVolume.bWaterVolume)// && !Region.Zone.bWaterZone ) 
		{
			splashSize = 0.000025 * Mass * (250 - 0.5 * Velocity.Z);
			if (NewVolume.EntrySound != None)
				PlaySound(NewVolume.EntrySound, SLOT_Interact, splashSize);
			if (NewVolume.EntryActor != None )
			{
				splash = Spawn(NewVolume.EntryActor); 
				if (splash != None)
					splash.SetDrawScale(2 * splashSize);
			}
		}
	}

	// Validate touch, and if valid trigger event.
	function bool ValidTouch(actor Other)
	{
		local Actor A;

		if (Other.IsA('pawn') && Pawn(Other).bCanPickupInventory && (Pawn(Other).Health > 0) && Level.Game.PickupQuery(Pawn(Other), self))
		{
			if(Event != '')
				foreach AllActors( class 'Actor', A, Event )
					A.Trigger(Other, Other.Instigator);
			return true;
		}
		return false;
	}
		
  //when frobbed by an actor - DEUS_EX CNN
	function Frob(Actor Other, Inventory frobWith)
	{
		// If touched by a player pawn, let him pick this up.
		if (ValidTouch(Other))
		{
			SpawnCopy(Pawn(Other));
				Pawn(Other).ClientMessage(PickupMessage @ itemName, 'Pickup');
			PlaySound(PickupSound);		
			if (Level.Game.GameDifficulty > 1)
				Other.MakeNoise(0.1 * Level.Game.GameDifficulty);
		}
		else if (bTossedOut && (Other.Class == Class) && Inventory(Other).bTossedOut)
				Destroy();
	}

	// Landed on ground.
	function Landed(Vector HitNormal)
	{
		local rotator newRot;
		newRot = Rotation;
		newRot.pitch = 0;
		SetRotation(newRot);
		PlayLandingSound();  // DEUS_EX STM - added
	}

	// Make sure no pawn already touching (while touch was disabled in sleep).
	function CheckTouching()
	{
		local int i;

		bSleepTouch = false;
		for ( i=0; i<4; i++ )
			if ( (Touching[i] != None) && Touching[i].IsA('Pawn') )
				Touch(Touching[i]);
	}
	function BeginState()
	{
		BecomePickup();
		bCollideWorld = true;
		if ( Level.bStartup )
			bAlwaysRelevant = true;
	}

	function EndState()
	{
		bCollideWorld = false;
		bSleepTouch = false;
	}

Begin:
	BecomePickup();

Dropped:
	if (bAmbientGlow)
		AmbientGlow=255;
	if (bSleepTouch)
		CheckTouching();
}


state Idle
{
	function bool IsIdle()
	{
		return true;
	}

	simulated function ForceReload()
	{
		ServerForceReload();
	}

	function ServerForceReload()
	{
		if (AmmoType.HasAmmo())
			GotoState('Reloading');
	}	
	
	simulated function AnimEnd(int Channel)
	{
		PlayIdleAnim();
	}

	simulated function bool PutDown()
	{
		GotoState('DownWeapon');
		return True;
	}

Begin:
	bPointing=False;
	if ( NeedsToReload() && AmmoType.HasAmmo() )
		GotoState('Reloading');
/*	if ( !AmmoType.HasAmmo() ) 
		Instigator.Controller.SwitchToBestWeapon();*/  //Goto Weapon that has Ammo
	if (Instigator.PressingFire()) Fire(0.0); // execute Fire()
	if (Instigator.PressingAltFire()) AltFire(0.0);	//execute AltFire()
	PlayIdleAnim();
}


/* DownWeapon
Putting down weapon in favor of a new one.  No firing in this state
*/
State DownWeapon
{
  ignores Fire, AltFire;

	function ServerFire() {}
	function ServerAltFire() {}

	simulated function bool PutDown()
	{
			Pawn(Owner).ChangedWeapon();//
		return true; //just keep putting it down
	}

	simulated function BeginState()
	{
		OldWeapon = None;
		bChangeWeapon = false;
		bMuzzleFlash = false;
	}

Begin:
	TweenDown();
	FinishAnim();
	Pawn(Owner).ChangedWeapon();
}

state Active
{
	function Fire(float F) 
	{
	}

	function AltFire(float F) 
	{
	}

	function bool PutDown()
	{
		if (bWeaponUp || (GetAnimFrame() < 0.75))
			GotoState('DownWeapon');
		else
			bChangeWeapon = true;
		return True;
	}

	function BeginState()
	{
		bChangeWeapon = false;
	}

Begin:
	FinishAnim();
	if (bChangeWeapon)
		GotoState('DownWeapon');
	bWeaponUp = True;
	PlayPostSelect();
	FinishAnim();
	Finish();
}


/* 
   Fire on the client side. This state is only entered on the network client of the player that is firing this weapon. 
*/
state ClientFiring
{
	function Fire(float Value) {}
	function AltFire(float Value) {}

	simulated function AnimEnd(int Channel)
	{
		ClientFinish();
		CheckAnimating();
	}

	function CheckAnimating()
	{
		if (!IsAnimating())
			warn(self$" stuck in ClientFiring and not animating!");
	}

	simulated function EndState()
	{
		AmbientSound = None;
		if (RepeatFire() && !bPendingDelete)
			ServerStopFiring();
	}
}

state NormalFire
{
	function Fire(float F) 
	{
	}
	function AltFire(float F) 
	{
	}

Begin:
	FinishAnim();
	Finish();
}

state AltFiring
{
	function Fire(float F) 
	{
	}

	function AltFire(float F) 
	{
	}

Begin:
	FinishAnim();
	Finish();
}

defaultproperties
{
   bUseDynamicLights=true
   bOrientOnSlope=true
   pickupAmmoCount=10
   ReloadCount=10
   PickupMessage="You found:"

   FirstPersonDrawScale=1.00
   FirstPersonDrawScale3D=(X=1.00,Y=1.00,Z=1.00)
   PickupViewDrawScale=1.00
   PickupViewDrawScale3D=(X=1.00,Y=1.00,Z=1.00)
}
