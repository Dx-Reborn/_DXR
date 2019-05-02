//=============================================================================
// DeusExCarcass.
//=============================================================================

class DeusExCarcass extends Carcass;

#exec obj load file=DeusExCharacters.ukx

// Conversation Related Variables - DEUS_EX AJY
var(Conversation) String BindName;					// Used to bind conversations
var(Conversation) String BarkBindName;				// Used to bind Barks!
var(Conversation) localized String FamiliarName;	// For display in Conversations
var(Conversation) localized String UnfamiliarName;	// For display in Conversations
var transient Object     ConListItems;				// List of ConListItems for this Actor
var	travel   float       LastConEndTime;			// Time when last conversation ended
var(Conversation) float  ConStartInterval;			// Amount of time required between two convos.

var(Advanced) bool            bOwned;
// End additional variables - DEUS_EX STM

// DEUS_EX AMSD Added to make vision aug run faster.  If true, the vision aug needs to check this object more closely.
// Used for heat sources as well as things that blind.
var bool bVisionImportant;

struct InventoryItemCarcass
{
	var() class<Inventory> Inventory;
	var() int              count;
};

var(Display) mesh Mesh2;		// mesh for secondary carcass
var(Display) mesh Mesh3;		// mesh for floating carcass
var(Inventory) InventoryItemCarcass InitialInventory[8];  // Initial inventory items held in the carcass

// Player may want to travel to another map with corpse, so i have to somehow save its inventory...
var inventory holdInventory[8];
var() bool bHighlight;

var String			KillerBindName;		// what was the bind name of whoever killed me?
var Name			KillerAlliance;		// what alliance killed me?
var bool			bGenerateFlies;		// should we make flies?
var FlyGenerator	flyGen;
var Name			Alliance;			// this body's alliance
var Name			CarcassName;		// original name of carcass
var int				MaxDamage;			// maximum amount of cumulative damage
var bool			bNotDead;			// this body is just unconscious
var() bool			bEmitCarcass;		// make other NPCs aware of this body

var bool			bInit;

// Used for Received Items window
var bool bSearchMsgPrinted;

var localized string msgSearching;
var localized string msgEmpty;
var localized string msgNotDead;
var localized string msgAnimalCarcass;
var localized string msgCannotPickup;
var localized String msgRecharged;
var localized string itemName;			// human readable name

var() bool bInvincible;
var bool bAnimalCarcass;
var HudOverlay_received WinReceived;
var DeusExPlayer dxplayer;


// ----------------------------------------------------------------------
// ChunkUp()
// ----------------------------------------------------------------------

function ChunkUp(int Damage)
{
	local int i;
	local float size;
	local Vector loc;
	local FleshFragment chunk;

	// gib the carcass
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
	if (!bAnimalCarcass)
	RestoreItems(); // DXR: to avoid losing important items, relocate inventory to ground.
	Super.ChunkUp(Damage);
}

// ----------------------------------------------------------------------
// TakeDamage()
// ----------------------------------------------------------------------
function TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	local int i;

	if (bInvincible)
		return;

	// only take "gib" damage from these damage types
	if ((damageType == class'DM_Shot') || (damageType == class'DM_Sabot') || (damageType == class'DM_Exploded') || (damageType == class'DM_Munch') ||
	    (damageType == class'DM_Tantalus'))
	{
		if ((damageType != class'DM_Munch') && (damageType != class'DM_Tantalus'))
		{
        spawn(class'BloodSpurt',,,HitLocation);
        spawn(class'BloodDrop',,, HitLocation);
           for (i=0; i<Damage; i+=10)
             spawn(class'BloodDrop',,, HitLocation);
		}

		// this section copied from Carcass::TakeDamage() and modified a little
		if (!bDecorative)
		{
			bBobbing = false;
			SetPhysics(PHYS_Falling);
		}
		if ((Physics == PHYS_None) && (Momentum.Z < 0))
			Momentum.Z *= -1;
		Velocity += 3 * momentum/(Mass + 200);
		if (DamageType == class'DM_Shot')
			Damage *= 0.4;
		CumulativeDamage += Damage;
		if (CumulativeDamage >= MaxDamage)
			ChunkUp(Damage);
		if (bDecorative)
			Velocity = vect(0,0,0);
	}
	SetScaleGlow();
}

// ----------------------------------------------------------------------
// SetScaleGlow()
//
// sets the scale glow for the carcass, based on damage
// DXR: it works in UE2 too, but only after rebuilding lighting.
// ----------------------------------------------------------------------

function SetScaleGlow()
{
	local float pct;

	// scaleglow based on damage
	pct = FClamp(1.0-float(CumulativeDamage)/MaxDamage, 0.1, 1.0);
	ScaleGlow = pct;
}

function SetItemLocation(inventory item, optional bool bExploded)
{
   local vector v;

   if (bExploded)
   {
     item.velocity.x = RandRange(10, 50);
     item.velocity.y = RandRange(10, 50);
     item.velocity.z = RandRange(200, 500);
     item.setPhysics(PHYS_Falling);
     return;
   }


   v = class'DxUtil'.static.VDiskRand2D(collisionRadius);
   v.x += item.location.x;
   v.y += item.location.y;
   v.z = item.location.z;
     item.SetLocation(v);
}

function RestoreItems()
{
  local int i;

	for (i=0; i<8; i++)
	{
		if (holdInventory[i] != None)
		{
       DeleteInventory(holdInventory[i]);
       InitialInventory[i].Inventory = none;
       holdInventory[i].SetInitialState();

       if (holdInventory[i].IsA('Ammunition'))
          {                                                   
            holdInventory[i].bHidden = false;
            holdInventory[i].bOnlyOwnerSee = false;
          }
       SetItemLocation(holdInventory[i], true); // place items randomly within circle
       holdInventory[i] = none;
		}
	}
}

// ----------------------------------------------------------------------
// InitFor()
// ----------------------------------------------------------------------
function InitFor(Actor Other)
{
  local name AnimSequence;
  local float frame, rate;

	if (Other != None)
	{
		Other.GetAnimParams(0,AnimSequence,frame,rate);

		// set as unconscious or add the pawns name to the description
		if (!bAnimalCarcass)
		{
			if (bNotDead)
				itemName = msgNotDead;
			else if (Other.IsA('ScriptedPawn'))
				itemName = itemName $ " (" $ ScriptedPawn(Other).FamiliarName $ ")";
		}

		Mass           = Other.Mass;
		Buoyancy       = Mass * 1.2;
		MaxDamage      = 0.8*Mass;
		if (ScriptedPawn(Other) != None)
			if (ScriptedPawn(Other).bBurnedToDeath)
				CumulativeDamage = MaxDamage-1;

		SetScaleGlow();

		// Will this carcass spawn flies?
		if (bAnimalCarcass)
		{
			itemName = msgAnimalCarcass;
			if (FRand() < 0.2)
				bGenerateFlies = true;
		}
		else if (!Other.IsA('Robot') && !bNotDead)
		{
			if (FRand() < 0.1)
				bGenerateFlies = true;
			bEmitCarcass = true;
		}

		if (Other.GetAnimSequence() == 'DeathFront')
			LinkMesh(Mesh2);

		// set the instigator and tag information
		if (Other.Instigator != None)
		{
			KillerBindName = Other.Instigator.GetBindName();
			KillerAlliance = DeusExPawn(Other.Instigator).Alliance;
		}
		else
		{
			KillerBindName = Other.GetBindName();
			KillerAlliance = '';
		}
		Tag = Other.Tag;
		Alliance = DeusExPawn(Other).Alliance;
		CarcassName = Other.Name;
	}
}

// ----------------------------------------------------------------------
// PostBeginPlay()
// ----------------------------------------------------------------------
function PostBeginPlay()
{
	local int i, j;
	local Inventory inv;

	bCollideWorld = true;

	// Use the carcass name by default
	CarcassName = Name;

	// Add initial inventory items
	for (i=0; i<8; i++)
	{
		if ((InitialInventory[i].inventory != None) && (InitialInventory[i].count > 0))
		{
			for (j=0; j<InitialInventory[i].count; j++)
			{
				inv = spawn(InitialInventory[i].inventory, self);
				if (inv != None)
				{
				  holdInventory[i] = inv;
				    //log(holdInventory[i]);
					inv.bHidden = True;
					inv.SetPhysics(PHYS_None);
					AddInventory(inv);
				}
			}
		}
	}

	// use the correct mesh
	if (PhysicsVolume.bWaterVolume)//(Region.Zone.bWaterZone)
	{
		LinkMesh(Mesh3);
		bNotDead = False;		// you will die in water every time
	}

	if (bAnimalCarcass)
		itemName = msgAnimalCarcass;

	MaxDamage = 0.8*Mass;
	SetScaleGlow();

	SetTimer(30.0, False);

	Super.PostBeginPlay();
}



// ----------------------------------------------------------------------
// ZoneChange()
// ----------------------------------------------------------------------
function PhysicsVolumeChange(PhysicsVolume NewVolume)
{
	Super.PhysicsVolumeChange(NewVolume);

	// use the correct mesh for water
	if (NewVolume.bWaterVolume)
		  LinkMesh(Mesh3);
}

// ----------------------------------------------------------------------
// Destroyed()
// ----------------------------------------------------------------------
function Destroyed()
{
	if (flyGen != None)
	{
//		flyGen.StopGenerator();
		flyGen = None;
	}
	Super.Destroyed();
}

// ----------------------------------------------------------------------
// Tick()
// ----------------------------------------------------------------------
function Tick(float deltaSeconds)
{
	if (!bInit)
	{
		bInit = true;
		if (bEmitCarcass)
			class'EventManager'.static.AIStartEvent(self,'Carcass', EAITYPE_Visual);
	}
	Super.Tick(deltaSeconds);
}


// ----------------------------------------------------------------------
// Timer()
// ----------------------------------------------------------------------
function Timer()
{
	if (bGenerateFlies)
	{
/* flyGen = Spawn(Class'FlyGenerator', , , Location, Rotation);
		if (flyGen != None)
			flyGen.SetBase(self);*/
	}
}

// ----------------------------------------------------------------------
// Frob()
//
// search the body for inventory items and give them to the frobber
// ----------------------------------------------------------------------
function Frob(Actor Frobber, Inventory frobWith)
{
	local Inventory item, nextItem, startItem;
	local Pawn P;
	local DeusExWeaponInv W;
	local bool bFoundSomething;
	local DeusExPlayer player;
	local ammunition AmmoType;
	local bool bPickedItemUp;
	local POVCorpse corpse;
	local DeusExPickupInv invItem;
	local int itemCount;

//log("DeusExCarcass::Frob()--------------------------------");

	// Can we assume only the *PLAYER* would actually be frobbing carci?
	player = DeusExPlayer(Frobber);
	dxplayer = player; // DXR: pointer to our PlayerPawn.

	// if we've already been searched, let the player pick us up
	// don't pick up animal carcii
	if (!bAnimalCarcass)
	{
	 if (player.bJustPickupCorpse)
	     goto JustPickup;
		if ((Inventory == None) && (player != None) && (player.inHand == None))
		{
		  JustPickup:
			if (!bInvincible)
			{
				corpse = Spawn(class'POVCorpse', player);
				if (corpse != None)
				{
					// destroy the actual carcass and put the fake one
					// in the player's hands
					corpse.carcClassString = String(Class);
					corpse.KillerAlliance = KillerAlliance;
					corpse.KillerBindName = KillerBindName;
					corpse.Alliance = Alliance;
					corpse.bNotDead = bNotDead;
					corpse.bEmitCarcass = bEmitCarcass;
					corpse.CumulativeDamage = CumulativeDamage;
					corpse.MaxDamage = MaxDamage;
					corpse.CorpseItemName = itemName;
					corpse.CarcassName = CarcassName;
					corpse.CarcassInv = Inventory; // DXR: Added to save corpse's inventory
					corpse.SetBase(player);
					corpse.Frob(player, None);
					player.PutInHand(corpse);
					Destroy();
					player.bJustPickupCorpse = false;
					return;
				}
			}
		}
	}

	bFoundSomething = False;
	bSearchMsgPrinted = False;
	P = Pawn(Frobber);
	if (P != None)
	{
		// Make sure the "Received Items" display is cleared
//		if (player != None)
//			DeusExRootWindow(player.rootWindow).hud.receivedItems.RemoveItems();

		if (Inventory != None)
		{
			item = Inventory;
			startItem = item;

			do
			{
//log("  item = "$  item);
				nextItem = item.Inventory;
				bPickedItemUp = False;

				if (item.IsA('Ammunition'))
				{
					// Only let the player pick up ammo that's already in a weapon
					DeleteInventory(item);
					item.Destroy();
					item = None;
				}
				else if (item.IsA('DeusExWeaponInv'))
				{
					// Any weapons have their ammo set to a random number of rounds (1-4)
					// unless it's a grenade, in which case we only want to dole out one.
					W = DeusExWeaponInv(item);

					// Grenades and LAMs always pickup 1
					if (W.IsA('WeaponNanoVirusGrenadeInv') || W.IsA('WeaponGasGrenadeInv') || W.IsA('WeaponEMPGrenadeInv') || W.IsA('WeaponLAMInv'))
						W.PickupAmmoCount = 1;
					else
						W.PickupAmmoCount = Rand(4) + 1;
				}
				
				if (item != None)
				{
					bFoundSomething = True;

					if (item.IsA('NanoKey'))
					{
						if (player != None)
						{
							player.PickupNanoKey(NanoKey(item));
							AddReceivedItem(player, item, 1);
							DeleteInventory(item);
							item.Destroy();
							item = None;
						}
						bPickedItemUp = True;
					}
					else if (item.IsA('CreditsInv'))		// I hate special cases
					{
						if (player != None)
						{
							AddReceivedItem(player, item, CreditsInv(item).numCredits);
							player.Credits += CreditsInv(item).numCredits;
							P.ClientMessage(Sprintf(CreditsInv(item).msgCreditsAdded, CreditsInv(item).numCredits));
							DeleteInventory(item);
							item.Destroy();
							item = None;
						}
						bPickedItemUp = True;
					}
					else if (item.IsA('DeusExWeaponInv'))   // I *really* hate special cases
					{
						// Okay, check to see if the player already has this weapon.  If so,
						// then just give the ammo and not the weapon.  Otherwise give
						// the weapon normally. 
						W = DeusExWeaponInv(player.FindInventoryType(item.class));

						// If the player already has this item in his inventory, piece of cake,
						// we just give him the ammo.  However, if the Weapon is *not* in the 
						// player's inventory, first check to see if there's room for it.  If so,
						// then we'll give it to him normally.  If there's *NO* room, then we 
						// want to give the player the AMMO only (as if the player already had 
						// the weapon).

						if ((W != None) || ((W == None) && (!player.FindInventorySlot(item, True))))
						{
							// Don't bother with this is there's no ammo
							if ((DeusExWeaponInv(item).AmmoType != None) && (DeusExWeaponInv(item).AmmoType.AmmoAmount > 0))
							{
								AmmoType = Ammunition(player.FindInventoryType(DeusExWeaponInv(item).AmmoName));

								if ((AmmoType != None) && (AmmoType.AmmoAmount < AmmoType.MaxAmmo))
								{
									AddReceivedItem(player, AmmoType, DeusExWeaponInv(item).PickupAmmoCount);
									AmmoType.AddAmmo(DeusExWeaponInv(item).PickupAmmoCount);

									// Update the ammo display on the object belt
									player.UpdateAmmoBeltText(AmmoType);

									// if this is an illegal ammo type, use the weapon name to print the message
									if (AmmoType.Mesh == Mesh'TestBox')
										P.ClientMessage(/*item.PickupMessage*/msgSearching @ item.itemName, 'Pickup');
									else
										P.ClientMessage(/*AmmoType.PickupMessage*/ msgSearching @ AmmoType.itemName, 'Pickup');

									// Mark it as 0 to prevent it from being added twice
									DeusExWeaponInv(item).AmmoType.AmmoAmount = 0;
								}
							}

							// Print a message "Cannot pickup blah blah blah" if inventory is full
							// and the player can't pickup this weapon, so the player at least knows
							// if he empties some inventory he can get something potentially cooler
							// than he already has. 
							if ((W == None) && (!player.FindInventorySlot(item, True)))
								P.ClientMessage(Sprintf(Player.InventoryFull, item.itemName));

							// Only destroy the weapon if the player already has it.
							if (W != None)
							{
								// Destroy the weapon, baby!
								DeleteInventory(item);
								item.Destroy();
								item = None;
							}

							bPickedItemUp = True;
						}
					}

					else if (item.IsA('DeusExAmmoInv'))
					{
						if (DeusExAmmoInv(item).AmmoAmount == 0)
							bPickedItemUp = True;
					}

					if (!bPickedItemUp)
					{
						// Special case if this is a DeusExPickup(), it can have multiple copies
						// and the player already has it.

						if ((item.IsA('DeusExPickupInv')) && (DeusExPickupInv(item).bCanHaveMultipleCopies) && (player.FindInventoryType(item.class) != None))
						{
							invItem   = DeusExPickupInv(player.FindInventoryType(item.class));
							itemCount = DeusExPickupInv(item).numCopies;

							// Make sure the player doesn't have too many copies
							if ((invItem.MaxCopies > 0) && (DeusExPickupInv(item).numCopies + invItem.numCopies > invItem.MaxCopies))
							{	
								// Give the player the max #
								if ((invItem.MaxCopies - invItem.numCopies) > 0)
								{
									itemCount = (invItem.MaxCopies - invItem.numCopies);
									DeusExPickupInv(item).numCopies -= itemCount;
									invItem.numCopies = invItem.MaxCopies;
									P.ClientMessage(invItem.PickupMessage @ invItem.itemName, 'Pickup');
									AddReceivedItem(player, invItem, itemCount);
								}
								else
								{
									P.ClientMessage(Sprintf(msgCannotPickup, invItem.itemName));
								}
							}
							else
							{
								invItem.numCopies += itemCount;
								DeleteInventory(item);

								P.ClientMessage(invItem.PickupMessage @ invItem.itemName, 'Pickup');
								AddReceivedItem(player, invItem, itemCount);
							}
						}
						else
						{
							// check if the pawn is allowed to pick this up
							if ((P.Inventory == None) || (Level.Game.PickupQuery(P, item)))
							{
								DeusExPlayer(P).FrobTarget = item;
								if (DeusExPlayer(P).HandleItemPickup(Item) != False)
								{
									DeleteInventory(item);
									item.SpawnCopy(P);

									// Show the item received in the ReceivedItems window and also 
									// display a line in the Log

									AddReceivedItem(player, item, 1);
									P.ClientMessage(/*Item.PickupMessage*/ msgSearching @ Item.itemName, 'Pickup');
									//PlaySound(Item.PickupSound);
								}
							}
							else
							{
								DeleteInventory(item);
								item.Destroy();
								item = None;
							}
						}
					}
				}

				item = nextItem;
			}
			until ((item == None) || (item == startItem));
		}

log("  bFoundSomething = " $ bFoundSomething);

		if (!bFoundSomething)
			P.ClientMessage(msgEmpty);
	}

	Super.Frob(Frobber, frobWith);
}




// ----------------------------------------------------------------------
// AddReceivedItem()
// ----------------------------------------------------------------------
function AddReceivedItem(DeusExPlayer player, Inventory item, int count)
{
 if (WinReceived == none)
    {
     WinReceived = spawn(class'HudOverlay_received'); // Create HUD overlay...
     DeusExPlayerController(player.controller).myHUD.AddHudOverlay(WinReceived);// Add it to our HUD...
     WinReceived.AddItem(item); // When overlay just created, add first item.
    }
 else if (WinReceived != none)
   {
     WinReceived.AddItem(item);  //... and others too
     WinReceived.TimerRate += 0.2;
   }

	if (!bSearchMsgPrinted)
	{
//		player.ClientMessage(msgSearching);
		bSearchMsgPrinted = True;
	}

	// Make sure the object belt is updated
	if (item.IsA('DeusExAmmoInv'))
		player.UpdateAmmoBeltText(DeusExAmmoInv(item));
	else
		player.UpdateBeltText(item);
}


// ----------------------------------------------------------------------
// AddInventory()
//
// copied from Engine.Pawn
// Add Item to this carcasses inventory. 
// Returns true if successfully added, false if not.
// ----------------------------------------------------------------------
function bool AddInventory(inventory NewItem)
{
	// Skip if already in the inventory.
	local inventory Inv;

	for(Inv=Inventory; Inv!=None; Inv=Inv.Inventory)
		if(Inv == NewItem)
			return false;

	// The item should not have been destroyed if we get here.
	assert(NewItem!=None);

	// Add to front of inventory chain.
	NewItem.SetOwner(Self);
	NewItem.Inventory = Inventory;
	NewItem.GoToState('idle2');
	// InitialState = 'Idle2'; <- why this does not worsks? 
	Inventory = NewItem;

	return true;
}

// ----------------------------------------------------------------------
// DeleteInventory()
// 
// copied from Engine.Pawn
// Remove Item from this pawn's inventory, if it exists.
// Returns true if it existed and was deleted, false if it did not exist.
// ----------------------------------------------------------------------
function /*bool*/ DeleteInventory(inventory Item)
{
	// If this item is in our inventory chain, unlink it.
	local actor Link;

	for(Link = Self; Link!=None; Link=Link.Inventory)
	{
		if( Link.Inventory == Item )
		{
			Link.Inventory = Item.Inventory;
			break;
		}
	}
	Item.SetOwner(None);
}

// ----------------------------------------------------------------------
// auto state Dead
// ----------------------------------------------------------------------
auto state Dead
{
	function Timer()
	{
		// overrides goddamned lifespan crap
		Global.Timer();
	}

	function HandleLanding()
	{
		local Vector HitLocation, HitNormal, EndTrace;
		local Actor hit;
		local BloodPool pool;

		if (!bNotDead)
		{
			// trace down about 20 feet if we're not in water
			if (!PhysicsVolume.bWaterVolume)//Region.Zone.bWaterZone)
			{
				EndTrace = Location - vect(0,0,320);
				hit = Trace(HitLocation, HitNormal, EndTrace, Location, False);
				pool = spawn(class'BloodPool',,, HitLocation+HitNormal, Rotator(HitNormal));
				if (pool != None)
					pool.maxDrawScale = CollisionRadius / 40.0;
			}

			// alert NPCs that I'm food
			class'EventManager'.static.AIStartEvent(self,'Food', EAITYPE_Visual);
		}

		// by default, the collision radius is small so there won't be as
		// many problems spawning carcii
		// expand the collision radius back to where it's supposed to be
		// don't change animal carcass collisions
		if (!bAnimalCarcass)
			SetCollisionSize(40.0, Default.CollisionHeight);

		// alert NPCs that I'm really disgusting
		if (bEmitCarcass)
			class'EventManager'.static.AIStartEvent(self, 'Carcass', EAITYPE_Visual);
	}

Begin:
	while (Physics == PHYS_Falling)
	{
		Sleep(1.0);
	}
	HandleLanding();
}

function Landed(vector HitNormal)
{
  super.Landed(HitNormal);

  if (!PhysicsVolume.bWaterVolume)
      PlaySound(sound'pl_jumpland1');
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     BindName="DeadBody"
     bVisionImportant=True
     bHighlight=True
     msgSearching="You found:"
     msgEmpty="You don't find anything"
     msgNotDead="Unconscious"
     msgAnimalCarcass="Animal Carcass"
     msgCannotPickup="You cannot pickup the %s"
     msgRecharged="Recharged %d points"
     ItemName="Dead Body"
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.000000
     DrawType=DT_MESH
     CollisionRadius=20.000000
     CollisionHeight=7.000000
     bCollideWorld=False
     Mass=150.000000
     Buoyancy=170.000000
     bOrientOnSlope=true
     Physics=PHYS_Falling
}
