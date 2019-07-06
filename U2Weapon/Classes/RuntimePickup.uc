/**/

class RuntimePickup extends powerups abstract
                                     placeable;


var() int           MaxCopies; // сколько можно унести с собой
var bool            bBreakable;		// true if we can destroy this item
var class<Fragment> fragType;		// fragments created when pickup is destroyed

var bool				bCanUseObjectBelt; // Can this object be placed on the object belt?
var() localized string beltDescription, description;
var() texture  	icon, largeicon;
var int					largeIconHeight;   // Height of graphic in texture
var int					largeIconWidth;    // Width of graphic in texture
var int					invSlotsX;         // Number of horizontal inv. slots this item takes
var int					invSlotsY;         // Number of vertical inv. slots this item takes
var travel int				invPosX;           // X position on the inventory window
var travel int				invPosY;           // Y position on the inventory window
var travel bool				bInObjectBelt;     // Is this object actually in the object belt?
var travel int				beltPos;           // Position on the object belt
var travel bool bIsActive, bAmbientGlow;

var	  bool		bSleepTouch;		  // Set when item is touched when leaving sleep state.
var	  bool		bHeldItem;		  // Set once an item has left pickup state.

var() sound LandSound, PickupSound;
var localized string CountLabel,msgTooMany,PickupMessage,msgUsed,M_Activated,M_Selected,M_Deactivated;

var() mesh PickupViewMesh; // vertmesh can be used too, for example non-animated pickups from HDTP can be used.
var() staticMesh PickupViewStaticMesh; // ...or if you prefer StaticMesh

var() mesh FirstPersonViewMesh;
var() StaticMesh FirstPersonViewStaticMesh;

var() bool bUseFirstPersonStaticMesh; // when True, uses StaticMesh
var() bool bUsePickupViewStaticMesh;

var() const float  FirstPersonDrawScale;
var() const vector FirstPersonDrawScale3D;
var() const float  PickupViewDrawScale;
var() const vector PickupViewDrawScale3D;

var() array<material> PickupViewSkins; // materials for Pickup version
var() array<material> FirstPersonViewSkins; // materials for FP version

function RestoreProperties(PlaceableInventory mapinv);




// DEUS_EX STM - added
function PlayLandingSound()
{
	if (LandSound != None)
		PlaySound(LandSound);
}

function material GetMeshTexture(optional int texnum)
{
  return class'ObjectManager'.static.GetActorMeshTexture(self, texnum);
}

function bool HandlePickupQuery(inventory Item)
{
	if (item.class == class) 
	{
		if (bCanHaveMultipleCopies) 
		{   // for items like Artifact
			NumCopies++;
				Pawn(Owner).ClientMessage(PickupMessage @ itemName, 'Pickup');
			Item.Destroy();//SetRespawn();
		}
		else if (bDisplayableInv)
			return false;

		return true;				
	}
	if (Inventory == None)
		return false;

	return Inventory.HandlePickupQuery(Item);
}


function bool IsActive()
{
	return bIsActive;
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
	GotoState('PickUp', 'Dropped');
}


// Toggle Activation of selected Item.
function Activate()
{
	if(bActivatable)
	{
		if (M_Activated != "")
			Pawn(Owner).ClientMessage(ItemName$M_Activated);
		GoToState('Activated');
	}
}

function BecomePickup()
{
	if (Physics != PHYS_Falling)
		RemoteRole    = ROLE_SimulatedProxy;

//	SetPhysics(default.Physics);

	if (bUsePickupViewStaticMesh)
	{
	  SetStaticMesh(PickupViewStaticMesh);
	  SetDrawType(DT_StaticMesh);
	}
	else
	{
	  LinkMesh(PickupViewMesh);
	  SetDrawType(DT_Mesh);
	}
	Skins.Length = PickupViewSkins.Length;
  Skins = PickupViewSkins;
  SetDrawScale(PickupViewDrawScale);
  SetDrawScale3D(PickupViewDrawScale3D);

	bOnlyOwnerSee = false;
	bHidden       = false;
	NetPriority   = 1.4;
	SetCollision(true, false, false);		// make things block actors as well - DEUS_EX CNN
}                    //true

function BecomeItem()
{
	RemoteRole    = ROLE_SimulatedProxy;

	if (bUseFirstPersonStaticMesh)
	{
	  SetStaticMesh(PickupViewStaticMesh);
	  SetDrawType(DT_StaticMesh);
	}
	else
	{
	  LinkMesh(FirstPersonViewMesh);
	  SetDrawType(DT_Mesh);
	}
	Skins.Length = FirstPersonViewSkins.Length;
  Skins = FirstPersonViewSkins;
  SetDrawScale(FirstPersonDrawScale);
  SetDrawScale3D(FirstPersonDrawScale3D);

	bOnlyOwnerSee = true;
	bHidden       = true;
	NetPriority   = 1.4;
	SetCollision(false, false, false);
	SetPhysics(PHYS_None);
	AmbientGlow = 0;
}

function PreBeginPlay()
{
  super.PreBeginPlay();
}

function inventory SpawnCopy(pawn Other)
{
	local inventory Copy;

	Copy = self; //Super.SpawnCopy(Other);
	Copy.Charge = Charge;
	Copy.GiveTo(Other);//
	return Copy;
}


/* -- States ----------------------------------------------------------------------------------- */
auto state Pickup
{
	singular function PhysicsVolumeChange(PhysicsVolume NewVolume)
	{
		local float splashsize;
		local actor splash;

		if (NewVolume.bWaterVolume)// && !Region.Zone.bWaterZone ) 
		{
			splashSize = 0.000025 * Mass * (250 - 0.5 * Velocity.Z);
			if (NewVolume.EntrySound != None )
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

		if (Other.IsA('Pawn') && Pawn(Other).bCanPickupInventory && (Pawn(Other).Health > 0) && Level.Game.PickupQuery(Pawn(Other), self))
		{
			if(Event != '')
				foreach AllActors( class 'Actor', A, Event )
					A.Trigger( Other, Other.Instigator );
			return true;
		}
		return false;
	}
		
	function Frob(Actor Other, Inventory frobWith)
	{
		local Inventory Copy;
		if ( ValidTouch(Other) ) 
		{
			Copy = SpawnCopy(Pawn(Other));

			if (bActivatable && bAutoActivate && Pawn(Other).bAutoActivate) Copy.Activate();
				Pawn(Other).ClientMessage(PickupMessage @ itemName, 'Pickup');
			PlaySound(PickupSound,,2.0);
			//RuntimePickup(Copy).PickupFunction(Pawn(Other));
		}
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

		if (Level.bStartup)
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
	if(bAmbientGlow)
		AmbientGlow=255;
	if(bSleepTouch)
		CheckTouching();
}

state DeActivated
{
}

state Activated
{
	function BeginState()
	{
		bActive = true;
//		if ( Pawn(Owner).bIsPlayer && (ProtectionType1 != '') )
//			Pawn(Owner).ReducedDamageType = ProtectionType1;
	}

	function EndState()
	{
		bActive = false;
//		if ( (Pawn(Owner) != None)
//			&& Pawn(Owner).bIsPlayer && (ProtectionType1 != '') )
//			Pawn(Owner).ReducedDamageType = '';
	}

	function Activate()
	{
		if ((Pawn(Owner) != None) && (M_Deactivated != ""))
			Pawn(Owner).ClientMessage(ItemName$M_Deactivated);	
		GoToState('DeActivated');
	}
}






defaultproperties
{
    bUseDynamicLights=true
		bDisplayableInv=true
		bCanHaveMultipleCopies=true     // if player can possess more than one of this
		bAutoActivate=false			   // automatically activated when picked up
		bActivatable=true      // Whether item can be activated/deactivated (if true, must auto activate)
		PlayerViewPivot=(Pitch=0,Roll=0,Yaw=-32768)
		drawType=DT_Mesh
    NumCopies=1
		maxCopies=10
		invSlotsX=1
		invSlotsY=1
    CountLabel="COUNT:"
    msgTooMany="You can't carry any more of those"
    PickupMessage="You found"
    ItemName="DEFAULT PICKUP NAME - REPORT THIS AS A BUG"
    M_Activated=" activated"
    M_Selected=" selected"
    M_Deactivated=" deactivated"

    FirstPersonDrawScale=1.00
    FirstPersonDrawScale3D=(X=1.00,Y=1.00,Z=1.00)
    PickupViewDrawScale=1.00
    PickupViewDrawScale3D=(X=1.00,Y=1.00,Z=1.00)
}
