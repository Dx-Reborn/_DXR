//=============================================================================
// ConPlayBase
//=============================================================================

class ConPlayBase extends Actor transient;

const INV_SUFF = "inv";

var enum EPlayModes
{
	PM_Passive,
	PM_Active
} playMode;

var enum EDisplayMode
{
	DM_FirstPerson,
	DM_ThirdPerson, 
	DM_Bark
} displayMode;

// Possible Event Actions
// (from ConObject.uc)

enum EEventAction
{
  EA_NextEvent,
	EA_JumpToLabel,
	EA_JumpToConversation,
	EA_WaitForInput,
	EA_WaitForSpeech,
	EA_WaitForText,
	EA_PlayAnim,
	EA_ConTurnActors,
    EA_PlayChoiceAndNext,
	EA_End
};

// Various and sundry Event Types
enum EEventType
{
	ET_Speech,					// 0
	ET_Choice,					// 1
	ET_SetFlag,					// 2
	ET_CheckFlag,				// 3
	ET_CheckObject,				// 4
	ET_TransferObject,			// 5
	ET_MoveCamera,				// 6	
	ET_Animation,				// 7
	ET_Trade,					// 8
	ET_Jump,					// 9
	ET_Random,					// 10
	ET_Trigger,					// 11
	ET_AddGoal,					// 12
	ET_AddNote,					// 13
	ET_AddSkillPoints,			// 14
	ET_AddCredits,				// 15
	ET_CheckPersona,			// 16
	ET_Comment,					// 17
	ET_End						// 18
};

enum ESpeechFonts
{
	SF_Normal,
	SF_Computer
};

// ----------------------------------------------------------------------
// EFlagType - Flag types

enum EFlagType
{
	FLAG_Bool,
	FLAG_Byte,
	FLAG_Int,
	FLAG_Float,
	FLAG_Name,
	FLAG_Vector,
	FLAG_Rotator,
};

enum EConditions
{
	EC_Less,
	EC_LessEqual,
	EC_Equal,
	EC_GreaterEqual,
	EC_Greater
};

// Event Persona types
enum EPersonaTypes
{
	EP_Credits,
	EP_Health,
	EP_SkillPoints
};

var DeusExHUD  	 rootWindow;		// Scott is that black stuff in the oven
var() ConDialogue con;					// Conversation we're working with
var() ConDialogue startCon;				// Conversation that was -initially- started
var DeusExPlayer player;				// Player Pawn
var() Actor 			 invokeActor;					// Actor who invoked conversation
var() transient ConEvent	 	 currentEvent;
var() int	 	       currentEventIndex; //
var() transient ConEvent     lastEvent;				// Last event
var() Actor        lastActor;				// Last Speaking Actor

var  sound playingSoundId;		// Currently playing speech
var  sound lastSound;

var Int			 		 lastSpeechTextLength;
var Int          missionNumber;
var String		 	 missionLocation;
//var ConHistory	 history;				// Saved History for this convo
var Actor        startActor;			// Actor who triggered convo
var int          saveRadiusDistance;
var int          initialRadius;
var bool         bConversationStarted;
var bool         bForcePlay;

var int x;

// Все диалоги теперь выводятся на оверлеи ГДИ
//var HudOverlay_Cinematic conWinThird;		// Интерактивные
var transient ConWindowActive conWinThird;		// 

var DeusExPlayerController PC;
var float SpeechVolume;

// Used to keep track of Actors involved in this conversation
var() Actor ConActors[10];

// Used to keep track of Actors that were bound to this conversation,
// in the event an actor is destroyed before the conversation is over,
// we abort the conversation to prevent references to destroyed objects
var() Actor ConActorsBound[10];

var() int conActorCount;

function SetStartActor(Actor newStartActor)
{
	startActor = newStartActor;
}

// Sets the conversation to be played.
function bool SetConversation(ConDialogue newCon)
{
	startCon = newCon;
	con      = newCon;

	saveRadiusDistance = con.radiusDistance;

	return True;
}

function SetInitialRadius(int newInitialRadius)
{
	initialRadius = newInitialRadius;
}

// ----------------------------------------------------------------------
// StartConversation()
//
// Starts a conversation.  
//
// 1.  Initializes the Windowing system
// 2.  Gets a pointer to the first Event
// 3.  Jumps into the 'PlayEvent' state
// ----------------------------------------------------------------------

function bool StartConversation(DeusExPlayer newPlayer, optional Actor newInvokeActor, optional bool bForcePlay)
{
	local DeusExLevelInfo aDeusExLevelInfo;
	local DeusExGlobals gl;

	gl = class'DeusExGlobals'.static.GetGlobals();

	// Make sure we have a conversation and a valid Player
	if (( con == None ) || ( newPlayer == None ))
	{
		log("con == None || newPlayer == None, StartConversation failed");
		return False;
	}

	// Make sure the player isn't, uhhrr, you know, DEAD!
	if (newPlayer.IsInState('Dying'))
		return False;

	// Keep a pointer to the player and invoking actor
	player      = newPlayer;

	if (newInvokeActor != None) 
		invokeActor = newInvokeActor;
	else
		invokeActor = startActor;

	log(self@"---------- ConActorsBound: invokeactor is "$invokeActor);

/*	log(self@"conactorsBound 0: "$conActorsBound[0]);
	log(self@"conactorsBound 1: "$conActorsBound[1]);
	log(self@"conactorsBound 2: "$conActorsBound[2]);
	log(self@"conactorsBound 3: "$conActorsBound[3]);
	log(self@"conactorsBound 4: "$conActorsBound[4]);
	log(self@"conactorsBound 5: "$conActorsBound[5]);
	log(self@"conactorsBound 6: "$conActorsBound[6]);
	log(self@"conactorsBound 7: "$conActorsBound[7]);
	log(self@"conactorsBound 8: "$conActorsBound[8]);
	log(self@"conactorsBound 9: "$conActorsBound[9]);*/


	// Bind the conversation events
	// Передача параметра LevelInfo чтобы быстрее прогнать итератор от актора а не от объекта.
	gl.AssignEvents(ConActorsBound, invokeActor, self.level, con);
	//con.BindEvents(ConActorsBound, invokeActor, self.level);

	// Check to see if the conversation has multiple owners, in which case we 
	// want to rebind all the events with this owner.  This allows conversations
	// to be shared by more than one owner.
	if ((con.ownerRefCount > 1) && (invokeActor != None))
	{
	  log("ownerRefCount > 1 && invokeActor="$invokeactor);
	  gl.AssignActorEvents(invokeactor, con);
		//con.BindActorEvents(invokeActor);
	}

	// Check to see if all the actors are on the level.
	// Don't check this for InfoLink conversations, since oftentimes
	// the person speaking via InfoLink *won't* be on the map.
	//
	// If a person speaking on the conversation can't be found 
	// (say, they were ruthlessly MURDERED!) then abort.
	//
	// Hi Ken!

	if ((!bForcePlay) && (!con.bDataLinkCon) && (!con.CheckActors(false))) // true для вывода списка в лог.
	{
		log("forcePlay=false, not datalink, "$con$"CheckActors returned false");
		return False;
	}

	// Now check to make sure that all the actors are a reasonable distance
	// from one another (excluding the player)
	if ((!bForcePlay) && (!con.CheckActorDistances(player)))
	{
		log("forcePlay=false, "$con$"CheckActorDistances("$player$") false");
		return False;
	}

	// Save the mission number and location
	foreach AllActors(class'DeusExLevelInfo', aDeusExLevelInfo)
	{
		if (aDeusExLevelInfo != None)
		{
			missionNumber   = aDeusExLevelInfo.missionNumber;
			missionLocation = aDeusExLevelInfo.MissionLocation;
			break;
		}
	}

	// Save the conversation radius
	saveRadiusDistance = con.radiusDistance;

	// Initialize Windowing System
	PC = DeusExPlayerController(Level.GetLocalPlayerController());
	rootWindow = DeusExHud(PC.myHUD);

	bConversationStarted = True;

	return True;
}

// ----------------------------------------------------------------------
// TerminateConversation()
// ----------------------------------------------------------------------
function TerminateConversation(optional bool bContinueSpeech, optional bool bNoPlayedFlag)
{
// local sound s;
	// Make sure there's no audio playing
	if (!bContinueSpeech)
	{
	 if (player != none)
   class'DxUtil'.static.StopSound(player, playingSoundid);
//   log("TerminateConversation : stopped sound"@ player @ playingSoundid);
  }

	// Set the played flag
	if (!bNoPlayedFlag)
		SetPlayedFlag();

	// Clear the bound event actors
	//con.ClearBindEvents();

	// Reset the conversation radious
	con.radiusDistance = saveRadiusDistance;

	// Notify the conversation participants to go about their
	// business.
	EndConActorStates();

	con          = None;
	currentEvent = None;
	lastEvent    = None;
}

// ----------------------------------------------------------------------
// ConversationStarted()
// ----------------------------------------------------------------------

function bool ConversationStarted()
{
	return bConversationStarted;
}

// ----------------------------------------------------------------------
// SetOriginalRadius()
// ----------------------------------------------------------------------

function SetOriginalRadius(int newOriginalDistance)
{
	saveRadiusDistance = newOriginalDistance;
}

// ----------------------------------------------------------------------
// CanInterrupt()
// ----------------------------------------------------------------------

function bool CanInterrupt()
{
	if (con != None)
		return !con.bCannotBeInterrupted;
	else
		return False;
}

// ----------------------------------------------------------------------
// InterruptConversation()
// ----------------------------------------------------------------------

function InterruptConversation()
{
	SetInterruptedFlag();	
}

// ----------------------------------------------------------------------
// SetPlayedFlag()
// ----------------------------------------------------------------------

function SetPlayedFlag()
{
	local Name flagName;

	if (con != None)
	{
		// Make a note of when this conversation ended
		con.lastPlayedTime = player.Level.TimeSeconds;

		flagName = class'DxUtil'.static.StringToName(con.Name $ "_Played");

		// Only set the Played flag if it doesn't already exist 
		// (some conversations set this intentionally with a longer expiration
		// date so they can be relied up on in future missions)

		if (!player.GetflagBase().GetBool(flagName))
		{
			// Add a flag noting that we've finished this conversation.  
			player.GetflagBase().SetBool(flagName, True);
		}

		// If this was a third-person convo, keep track of when the conversation
		// ended and who it was with (this is used to prevent radius convos
		// from playing immediately after letterbox convos).
		//
		// If this was a first-person convo, keep track of the owner and 
		// play time so we can prevent multiple radius-induced conversations
		// from playing without a pause (we don't want them to run into 
		// each other).

		if (con.bFirstPerson)
		{
			player.lastFirstPersonConvoActor = invokeActor;
			player.lastFirstPersonConvoTime  = con.lastPlayedTime;
		}
		else
		{
			player.lastThirdPersonConvoActor = invokeActor;
			player.lastThirdPersonConvoTime  = con.lastPlayedTime;
		}

	}
}

// ----------------------------------------------------------------------
// SetInterruptedFlag()
// ----------------------------------------------------------------------

function SetInterruptedFlag()
{
	local Name flagName;

	if (con != None)
	{
		flagName = class'DxUtil'.static.StringToName(con.Name $ "_Interrupted");

		// Add a flag noting that we've finished this conversation.  
		player.GetflagBase().SetBool(flagName, True);
	}
}

// ----------------------------------------------------------------------
// StopSpeech()
// ----------------------------------------------------------------------

function StopSpeech()
{
  if (invokeActor != none)
   class'DxUtil'.static.StopSound(invokeActor, playingSoundid);

  if (lastactor != none)
   class'DxUtil'.static.StopSound(lastactor, playingSoundid);

  if (player != none)
   class'DxUtil'.static.StopSound(player, playingSoundid);

  if (startActor != none)
   class'DxUtil'.static.StopSound(startActor, playingSoundid);

//   log("StopSpeech: stopped sound"@ player @ playingSoundid);
}

// ----------------------------------------------------------------------
// GetNextEvent()
//
// Returns the next event
// ----------------------------------------------------------------------

function ConEvent GetNextEvent()
{
	return con.GetNextEvent(currentEvent); //currentEvent.nextEvent;
}

// ----------------------------------------------------------------------
// SetupEventSetFlag()
// ----------------------------------------------------------------------

function EEventAction SetupEventSetFlag(ConEventSetFlag event, out String nextLabel)
{
//	local ConFlagRef currentRef;
    local int y;

    for (y=0; y<event.FlagRefList.length; y++)
    {
      player.GetflagBase().SetBool(event.FlagRefList[y].Name, event.FlagRefList[y].value);
      player.GetflagBase().SetExpiration(event.FlagRefList[y].Name, FLAG_Bool, event.FlagRefList[y].expiration); 
    }

	// Just follow the chain of flag references and set the flags to
	// the proper value!

/*	currentRef = event.flagRef;

	while(currentRef != None)
	{
		player.GetflagBase().SetBool(currentRef.flagName, currentRef.value);
		player.GetflagBase().SetExpiration(currentRef.flagName, FLAG_Bool, currentRef.expiration); 

		currentRef = currentRef.nextFlagRef;
	}*/

	nextLabel = "";
	return EA_NextEvent;
}

// ----------------------------------------------------------------------
// SetupEventCheckFlag()
// ----------------------------------------------------------------------

function EEventAction SetupEventCheckFlag(ConEventCheckFlag event, out String nextLabel)
{
//	local ConFlagRef currentRef;
	local EEventAction action;
  local int y;

	// Default values if we actually make it all the way 
	// through the while loop below.

	nextLabel = event.setLabel;
	action = EA_JumpToLabel;
	
	// Loop through our list of FlagRef's, checking the value of each.
	// If we hit a bad match, then we'll stop right away since there's
	// no point of continuing.

  for (y=0; y<event.FlagRefList.length; y++)
  {
		if (player.GetflagBase().GetBool(event.FlagRefList[y].Name) != (event.FlagRefList[y].value))
		{
//		  log(event.FlagRefList[y].Name,'SetupEventCheckFlag');
			nextLabel = "";
			action = EA_NextEvent;
			break;
		}
  }

/*	currentRef = event.flagRef;

	while( currentRef != None )
	{
		if ( player.GetflagBase().GetBool(currentRef.flagName) != currentRef.value )
		{
			nextLabel = "";
			action = EA_NextEvent;
			break;
		}
		currentRef = currentRef.nextFlagRef;
	}*/
	
	return action;
}

// ----------------------------------------------------------------------
// SetupEventTrade()
// ----------------------------------------------------------------------

function EEventAction SetupEventTrade(ConEventTrade event, out String nextLabel)
{
	nextLabel = "";
	return EA_NextEvent;
}

// ----------------------------------------------------------------------
// SetupEventCheckObject()
//
// Checks to see if the player has the given object.  If so, then we'll
// just fall through and continue running code.  Otherwise we'll jump
// to the supplied label.
// ----------------------------------------------------------------------

function EEventAction SetupEventCheckObject(ConEventCheckObject event, out String nextLabel)
{
	local EEventAction nextAction;
	local Name keyName;
	local bool bHasObject;

	// Okay this is some HackyHack stuff here.  We want the ability to 
	// check if the player has a particular nanokey.  Sooooooo.
	
	if ((event.checkObject == None) && (Left(event.objectName, 3) == "NK_"))
	{
		// Look for key
		keyName    = class'DxUtil'.static.StringToName(Right(event.ObjectName, Len(event.ObjectName) - 3));
		bHasObject = ((player.KeyRing != None) && (player.KeyRing.HasKey(keyName)));
	}
	else 
	{
		bHasObject = (player.FindInventoryType(event.checkObject) != None);
	}

	// Now branch appropriately

	if (bHasObject)
	{
		nextAction = EA_NextEvent;
		nextLabel  = "";
	}
	else
	{
		nextAction = EA_JumpToLabel;
		nextLabel  = event.failLabel;
	}

	return nextAction;
}

// ----------------------------------------------------------------------
// SetupEventTransferObject()
//
// Gives a Pawn the specified object.  The object will be created out of
// thin air (spawned) if there's no "fromActor", otherwise it's 
// transfered from one pawn to another.
//
// We now allow this to work without the From actor, which can happen
// in InfoLinks, since the FromActor may not even be on the map.
// This is useful for tranferring DataVaultImages.
// ----------------------------------------------------------------------

function EEventAction SetupEventTransferObject(ConEventTransferObject event, out String nextLabel)
{
	local EEventAction nextAction;
	local Inventory invItemFrom;
	local Inventory invItemTo;
	local ammunition AmmoType;
	local bool bSpawnedItem;
	local bool bSplitItem;
	local int itemsTransferred;//, temp;


/*	log("SetupEventTransferObject()------------------------------------------");
	log("  event = " $ event);
	log("  event.giveObject = " $ event.giveObject);
	log("  event.fromActor  = " $ event.fromActor );
	log("  event.toActor    = " $ event.toActor );*/

	itemsTransferred = 1;

	if ( event.failLabel != "" )
	{
		nextAction = EA_JumpToLabel;
		nextLabel  = event.failLabel;
	}
	else
	{
		nextAction = EA_NextEvent;
		nextLabel = "";
	}

	// First verify that the receiver exists!
	if (event.toActor == None)
	{
		log("SetupEventTransferObject:  WARNING!  toActor does not exist!");
		log("  Conversation = " $ con.Name);
    log("--------------------------------------------------------------------");
		return nextAction;
	}

	// First, check to see if the giver actually has the object.  If not, then we'll
	// fabricate it out of thin air.  (this is useful when we want to allow
	// repeat visits to the same NPC so the player can restock on items in some
	// scenarios).
	//
	// Also check to see if the item already exists in the recipient's inventory

	if (event.fromActor != None)
		invItemFrom = Pawn(event.fromActor).FindInventoryType(event.giveObject);

	invItemTo   = Pawn(event.toActor).FindInventoryType(event.giveObject);

	log("  invItemFrom = " $ invItemFrom);
	log("  invItemTo   = " $ invItemTo);

	// If the player is doing the giving, make sure we remove it from 
	// the object belt.

	// If the giver doesn't have the item then we must spawn a copy of it
	if (invItemFrom == None)
	{
		invItemFrom = Spawn(event.giveObject);
		bSpawnedItem = True;
	}

	// If we're giving this item to the player and he does NOT yet have it,
	// then make sure there's enough room in his inventory for the 
	// object!

	if ((invItemTo == None) &&
		(DeusExPlayer(event.toActor) != None) && 
	    (DeusExPlayer(event.toActor).FindInventorySlot(invItemFrom, True) == False))
	{
		// First destroy the object if we previously Spawned it
		if (bSpawnedItem)
			invItemFrom.Destroy();
				
		return nextAction;
	}

	// Okay, there's enough room in the player's inventory or we're not 
	// transferring to the player in which case it doesn't matter.
	//
	// Now check if the recipient already has the item.  If so, we are just
	// going to give it to him, with a few special cases.  Otherwise we
	// need to spawn a new object.

	if (invItemTo != None)
	{
		// Check if this item was in the player's hand, and if so, remove it
		RemoveItemFromPlayer(invItemFrom);

		// If this is ammo, then we want to just increment the ammo count
		// instead of adding another ammo to the inventory

		if (invItemTo.IsA('ammunition'))
		{
			// If this is Ammo and the player already has it, make sure the player isn't
			// already full of this ammo type! (UGH!)
			if (!ammunition(invItemTo).AddAmmo(ammunition(invItemFrom).AmmoAmount))
			{
				invItemFrom.Destroy();
				return nextAction;
			}

			// Destroy our From item
			invItemFrom.Destroy();		
		}

		// Pawn cannot have multiple weapons, but we do want to give the 
		// player any ammo from the weapon
		else if ((invItemTo.IsA('DeusExWeaponInv')) && (DeusExPlayer(event.ToActor) != None))
		{

			AmmoType = ammunition(DeusExPlayer(event.ToActor).FindInventoryType(DeusExWeaponInv(invItemTo).AmmoName));

			if ( AmmoType != None )
			{
				// Special case for Grenades and LAMs.  Blah.
				if ((AmmoType.IsA('AmmoEMPGrenadeInv')) || 
				    (AmmoType.IsA('AmmoGasGrenadeInv')) || 
					(AmmoType.IsA('AmmoNanoVirusGrenadeInv')) ||
					(AmmoType.IsA('AmmoLAMInv')))
				{
					if (!AmmoType.AddAmmo(event.TransferCount))
					{
						invItemFrom.Destroy();
						return nextAction;
					}
				}
				else
				{
					if (!AmmoType.AddAmmo(DeusExWeaponInv(invItemTo).PickUpAmmoCount))
					{
						invItemFrom.Destroy();
						return nextAction;
					}

					event.TransferCount = DeusExWeaponInv(invItemTo).PickUpAmmoCount;
					itemsTransferred = event.TransferCount;
				}

				if (event.ToActor.IsA('DeusExPlayer'))
					DeusExPlayer(event.ToActor).UpdateAmmoBeltText(AmmoType);

				// Tell the player he just received some ammo!
				invItemTo = AmmoType;
			}
			else
			{
				// Don't want to show this as being received in a convo
				invItemTo = None;
			}

			// Destroy our From item
			invItemFrom.Destroy();
			invItemFrom = None;
		}

		// Otherwise check to see if we need to transfer more than 
		// one of the given item
		else
		{
			itemsTransferred = AddTransferCount(invItemFrom, invItemTo, event, Pawn(event.toActor), False);

			// If no items were transferred, then the player's inventory is full or 
			// no more of these items can be stacked, so abort.
			if (itemsTransferred == 0)
				return nextAction;

			// Now destroy the originating object (which we either spawned
			// or is sitting in the giver's inventory), but check to see if this 
			// item still has any copies left first

			if (((invItemFrom.IsA('DeusExPickupInv')) && (DeusExPickupInv(invItemFrom).bCanHaveMultipleCopies) && (DeusExPickupInv(invItemFrom).NumCopies <= 0)) ||
			   ((invItemFrom.IsA('DeusExPickupInv')) && (!DeusExPickupInv(invItemFrom).bCanHaveMultipleCopies)) ||
			   (!invItemFrom.IsA('DeusExPickupInv')))
			{
				invItemFrom.Destroy();
				invItemFrom = None;
			}
		}
	}

	// Okay, recipient does *NOT* have the item, so it must be give
	// to that pawn and the original destroyed
	else
	{
		// If the item being given is a stackable item and the 
		// recipient isn't receiving *ALL* the copies, then we 
		// need to spawn a *NEW* copy and give that to the recipient.
		// Otherwise just do a "SpawnCopy", which transfers ownership
		// of the object to the new owner.

		if ((invItemFrom.IsA('DeusExPickupInv')) && (DeusExPickupInv(invItemFrom).bCanHaveMultipleCopies) && (DeusExPickupInv(invItemFrom).NumCopies > event.transferCount))
		{
			itemsTransferred = event.TransferCount;
			invItemTo = Spawn(event.giveObject);
			invItemTo.GiveTo(Pawn(event.toActor));
			DeusExPickupInv(invItemFrom).NumCopies -= event.transferCount;
			bSplitItem   = True;
			bSpawnedItem = True;
		}
		else
		{
//				log("invItemTo = invItemFrom.SpawnCopy(Pawn(event.toActor))"); //////////////////
//			invItemTo = invItemFrom.Spawn(Pawn(event.toActor));
			invItemTo = invItemFrom.SpawnCopy(Pawn(event.toActor));
		}

		log("  invItemFrom = "$  invItemFrom);
		log("  invItemTo   = " $ invItemTo);

		if (DeusExPlayer(event.toActor) != None)
			DeusExPlayer(event.toActor).FindInventorySlot(invItemTo);

		// Check if this item was in the player's hand *AND* that the player is 
		// giving the item to someone else.
		if ((DeusExPlayer(event.fromActor) != None) && (!bSplitItem))
			RemoveItemFromPlayer(invItemFrom);

		// If this was a DataVaultImage, then the image needs to be 
		// properly added to the datavault
		if ((invItemTo.IsA('DataVaultImageInv')) && (event.toActor.IsA('DeusExPlayer')))
		{
			DeusExPlayer(event.toActor).AddImage(DataVaultImageInv(invItemTo));
				
//			if (conWinThird != None)
//			{
//         conWinThird.recentItemTime = 3.0;
//         temp = conWinThird.recentItems.Length;
//         conWinThird.recentItems.Length = temp + 1;
//         conWinThird.recentItems[temp] = inventory[x].class;
//			}
//				conWinThird.ShowReceivedItem(invItemTo, 1);
//			else
//				DeusExRootWindow(player.rootWindow).hud.receivedItems.AddItem(invItemTo, 1);

			invItemFrom = None;
			invItemTo   = None;
		}

		// Special case for Credit Chits also
		else if ((invItemTo.IsA('CreditsInv')) && (event.toActor.IsA('DeusExPlayer')))
		{
//			if (conWinThird != None)
//				conWinThird.ShowReceivedItem(invItemTo, Credits(invItemTo).numCredits);
//			else
//				DeusExRootWindow(player.rootWindow).hud.receivedItems.AddItem(invItemTo, Credits(invItemTo).numCredits);

			player.Credits += CreditsInv(invItemTo).numCredits;
			
			invItemTo.Destroy();

			invItemFrom = None;
			invItemTo   = None;
		}

		// Now check to see if the transfer event specified transferring
		// more than one copy of the object
		else
		{
			itemsTransferred = AddTransferCount(invItemFrom, invItemTo, event, Pawn(event.toActor), True);

			// If no items were transferred, then the player's inventory is full or 
			// no more of these items can be stacked, so abort.
			if (itemsTransferred == 0)
			{
				invItemTo.Destroy();
				return nextAction;
			}

			// Update the belt text
			if (invItemTo.IsA('ammunition'))
				player.UpdateAmmoBeltText(Ammunition(invItemTo));
			else
				player.UpdateBeltText(invItemTo);
		}
	}

	// Show the player that he/she/it just received something!
	if ((DeusExPlayer(event.toActor) != None) && (conWinThird != None) && (invItemTo != None))
	{
//		if (conWinThird != None)
//			conWinThird.ShowReceivedItem(invItemTo, itemsTransferred);
//		else
//			DeusExRootWindow(player.rootWindow).hud.receivedItems.AddItem(invItemTo, itemsTransferred);
	}

	nextAction = EA_NextEvent;
	nextLabel = "";

	return nextAction;
}

// ---------------------------------------------------------------------
// AddTransferCount()
// ----------------------------------------------------------------------

function int AddTransferCount(Inventory invItemFrom, Inventory invItemTo, ConEventTransferObject event, pawn transferTo, bool bSpawned)
{
	local ammunition AmmoType;
	local int itemsTransferred;
	local DeusExPickupInv giveItem;

	itemsTransferred = 1;

/*	log("AddTransferCount()-------------------------------");
	log("  invItemFrom = " $ invItemFrom);
	log("  invItemTo   = " $ invItemTo);
	log("  transferTo  = " $ transferTo);
	log("  bSpawned    = " $ bSpawned);
	log("  event.transferCount = " $ event.transferCount);
	log("-------------------------------------------------");*/

	if (invItemTo == None)
		return 0;

	// If this is a Weapon, then we need to just add additional 
	// ammo.
	if (invItemTo.IsA('DeusExWeaponInv'))
	{
		if (event.transferCount > 1)
		{
			AmmoType = ammunition(transferTo.FindInventoryType(DeusExWeaponInv(invItemTo).AmmoName));

			if ( AmmoType != None )
			{
				itemsTransferred = DeusExWeaponInv(invItemTo).PickUpAmmoCount * (event.transferCount - 1);
				AmmoType.AddAmmo(itemsTransferred);

				// For count displayed
				itemsTransferred++;
			}
		}
	}

	// If this is a DeusExPickup and he already has it, just 
	// increment the count
	else if ((invItemTo.IsA('DeusExPickupInv')) && (DeusExPickupInv(invItemTo).bCanHaveMultipleCopies))
	{
		// If the item was spawned, then it will already have a copy count of 1, so we
		// only want to add to that if it was specified to transfer > 1 items.

		if (bSpawned)
		{
			itemsTransferred = event.transferCount;
			if (event.transferCount > 1)
			{
				DeusExPickupInv(invItemTo).NumCopies += event.transferCount - 1;

				if (DeusExPickupInv(invItemTo).NumCopies > DeusExPickupInv(invItemTo).maxCopies)
				{
					itemsTransferred = DeusExPickupInv(invItemTo).maxCopies;
					DeusExPickupInv(invItemTo).NumCopies = DeusExPickupInv(invItemTo).maxCopies;
				}
			}
		}

		// Wasn't spawned, so add the appropriate amount (if transferCount
		// isn't specified, just add one).

		else
		{
			if (event.transferCount > 0)
				itemsTransferred = event.transferCount;
			else
				itemsTransferred = 1;

			if ((DeusExPickupInv(invItemTo).NumCopies + itemsTransferred) > DeusExPickupInv(invItemTo).MaxCopies)
				itemsTransferred = DeusExPickupInv(invItemTo).MaxCopies - DeusExPickupInv(invItemTo).NumCopies;

			DeusExPickupInv(invItemTo).NumCopies += itemsTransferred;

			if ((DeusExPickupInv(invItemFrom) != None) && (invItemFrom != InvItemTo))
				DeusExPickupInv(invItemFrom).NumCopies -= itemsTransferred;
		}

		// Update the belt text
		DeusExPickupInv(invItemTo).UpdateBeltText();
	}
	else if ((invItemTo.IsA('DeusExPickupInv')) && (!bSpawned))
	{
		giveItem = DeusExPickupInv(Spawn(invItemTo.Class));
		giveItem.GiveTo(transferTo);
 
		// Just give the player another one of these fucking things
		if ((DeusExPlayer(transferTo) != None) && (DeusExPlayer(transferTo).FindInventorySlot(giveItem)))
			itemsTransferred = 1;
		else
			itemsTransferred = 0;
	}

log("  return itemsTransferred = " $ itemsTransferred);

	return itemsTransferred;
}

// ----------------------------------------------------------------------
// RemoveItemFromPlayer()
//
// Check if this item was in the player's hand
// ----------------------------------------------------------------------

function RemoveItemFromPlayer(Inventory item)
{
	if ((player != None) && (item != None))
		player.RemoveItemDuringConversation(item);
}

// ----------------------------------------------------------------------
// SetupEventJump()
// ----------------------------------------------------------------------

function EEventAction SetupEventJump(ConEventJump event, out String nextLabel)
{
	local EEventAction nextAction;

	// Check to see if the jump label is empty.  If so, then we just want
	// to fall through to the next event.  This can happen when jump
	// events get inserted during the import process.  ConEdit will not
	// allow the user to create events like this. 

	if ( event.jumpLabel == "" ) 
	{
		nextAction = EA_NextEvent;
		nextLabel = "";
	}
	else
	{
		// Jump to a specific label.  We can also jump into another conversation
		nextLabel = event.jumpLabel;

		if ( event.jumpCon != None )
			nextAction = EA_JumpToConversation;
		else
			nextAction = EA_JumpToLabel;
	}

	return nextAction;
}

// ----------------------------------------------------------------------
// SetupEventAnimation
// ----------------------------------------------------------------------

function EEventAction SetupEventAnimation(ConEventAnimation event, out String nextLabel)
{
	nextLabel = "";
	return EA_PlayAnim;
}

// ----------------------------------------------------------------------
// SetupEventRandomLabel()
// ----------------------------------------------------------------------

function EEventAction SetupEventRandomLabel(ConEventRandom event, out String nextLabel)
{
  local DeusExGlobals gl;

  gl = class'DeusExGlobals'.static.GetGlobals();

	// Pick a random label
	nextLabel = gl.GetRandomLabel(event); //event.GetRandomLabel();
	return EA_JumpToLabel;
}

// ----------------------------------------------------------------------
// SetupEventTrigger()
// ----------------------------------------------------------------------

function EEventAction SetupEventTrigger(ConEventTrigger event, out String nextLabel)
{
	local Actor anActor;

	// Loop through all the actors, firing a trigger for each
	foreach AllActors(class'Actor', anActor, class'DxUtil'.static.StringToName(event.triggerTag))
		anActor.Trigger(lastActor, Pawn(lastActor));

	return EA_NextEvent;
}

// ----------------------------------------------------------------------
// SetupEventAddGoal()
//
// TODO: Add support for goals longer than 255 characters.  
// ----------------------------------------------------------------------

function EEventAction SetupEventAddGoal(ConEventAddGoal event, out String nextLabel)
{
	local /*DeusExGoal*/ name goal;

	// First check to see if this goal exists
	goal = player.FindGoal(class'DxUtil'.static.StringToName(event.goalNameString));

	if ((goal == 'None') && (!event.bGoalCompleted))
	{
		// Add this goal to the player's goals
	    goal = player.AddGoal(class'DxUtil'.static.StringToName(event.goalNameString), event.bPrimaryGoal, event.goalText);
//		goal.SetText(event.goalText);
	}
	// Check if we're just marking this goal as complete
	else if (( goal != 'None' ) && ( event.bGoalCompleted ))
	{
		player.GoalCompleted(class'DxUtil'.static.StringToName(event.goalNameString));
	}

	return EA_NextEvent;
}

// ----------------------------------------------------------------------
// SetupEventAddNote()
//
// TODO: Add support for notes longer than 255 characters.  
// ----------------------------------------------------------------------

function EEventAction SetupEventAddNote(ConEventAddNote event, out String nextLabel)
{
  local array<string> temparray;

  temparray[0] = event.noteText;
	// Only add the note if it hasn't been added already (in case the 
	// PC has the same conversation more than once)

	if (!event.bNoteAdded)
	{
		// Add the note to the player's list of notes
		player.AddNote(/*event.noteText*/temparray, False, True);
		event.bNoteAdded = True;
	}
	return EA_NextEvent;
}

// ----------------------------------------------------------------------
// SetupEventAddSkillPoints()
// ----------------------------------------------------------------------

function EEventAction SetupEventAddSkillPoints(ConEventAddSkillPoints event, out String nextLabel)
{
	player.SkillPointsAdd(event.pointsToAdd);

	nextLabel = "";
	return EA_NextEvent;
}

// ----------------------------------------------------------------------
// SetupEventAddCredits()
//
// Adds the specified number of credits to the player.  If the 
// 'creditsToTransfer' variable is negative, this will cause
// the credits to get deducted from the player's credits total.
// ----------------------------------------------------------------------

function EEventAction SetupEventAddCredits(ConEventAddCredits event, out String nextLabel)
{
	player.credits += event.creditsToAdd;

	// Make sure we haven't gone into the negative
	player.credits = Max(player.credits, 0);

	nextLabel = "";
	return EA_NextEvent;
}

// ----------------------------------------------------------------------
// SetupEventCheckPersona()
// ----------------------------------------------------------------------

function EEventAction SetupEventCheckPersona(ConEventCheckPersona event, out String nextLabel)
{
	local EEventAction action;
	local int personaValue;
	local bool bPass;

	// First determine which persona item we're checking
	switch(event.personaType)
	{
		case EP_Credits:
//		  log(event@"checking EP_Credits, value in event ="$event.value,'Credits');//
			personaValue = player.Credits;
			break;

		case EP_Health:
			player.GenerateTotalHealth();
			personaValue = player.Health;
			break;

		case EP_SkillPoints:
			personaValue = player.SkillPointsAvail;
			break;
	}

	// Now decide what to do baby!
	switch(event.condition)
	{
		case EC_Less:
			bPass = (personaValue < event.value);
			break;

		case EC_LessEqual:
			bPass = (personaValue <= event.value);
			break;

		case EC_Equal:
			bPass = (personaValue == event.Value);
			break;

		case EC_GreaterEqual:
			bPass = (personaValue >= event.Value);
			break;

		case EC_Greater:
			bPass = (personaValue > event.Value);
			break;
	}

	if (bPass)
	{
//	  log("passed, jump to "$event$" label="$event.jumpLabel);
		nextLabel = event.jumpLabel;
		action = EA_JumpToLabel;
	}
	else
	{
		nextLabel = "";
		action = EA_NextEvent;
	}

	return action;
}

// ----------------------------------------------------------------------
// SetupEventEnd()
// ----------------------------------------------------------------------

function EEventAction SetupEventEnd(ConEventEnd event, out String nextLabel)
{
	nextLabel = "";
	return EA_End;
}

// ----------------------------------------------------------------------
// SetupHistory()
// ----------------------------------------------------------------------
function SetupHistory(String ownerName, optional Bool bInfoLink)
{
	local Name flagName;
	local bool bBarkConvo;
	local DeusExGlobals gl;

	gl = class'DeusExGlobals'.static.GetGlobals();

	// If this conversation has already been played, we don't want
	// to record it again
	//
	// Also ignore Bark conversations.

	bBarkConvo = (Left(con.Name, Len(con.OwnerName) + 5) == (con.OwnerName $ "_Bark"));
	flagName   = class'DxUtil'.static.StringToName(con.Name $ "_Played");

	if ((player.GetflagBase().GetBool(flagName) == False) && (!bBarkConvo))
	{
    x = gl.myConHistory.Length;
    gl.myConHistory.Length = x + 1; // добавить 1 к длине массива
	  gl.myConHistory[x].conOwnerName = ownerName;
		gl.myConHistory[x].strLocation = MissionLocation;
		gl.myConHistory[x].strDescription = con.Description;
		gl.myConHistory[x].bInfoLink = bInfoLink;
	}
}

// -------------------------------------------------------------------------
// AddHistoryEvent()
// -------------------------------------------------------------------------

function AddHistoryEvent(String eventSpeaker, ConEventSpeech eventSpeech)
{
//	local ConHistoryEvent newEvent;
	local DeusExGlobals gl;
	local int c;

	gl = class'DeusExGlobals'.static.GetGlobals();

  c = gl.myConHistory[x].conHistoryEvents.Length;
  gl.myConHistory[x].conHistoryEvents.Length = c + 1; // добавить 1 к длине массива
  gl.myConHistory[x].conHistoryEvents[c].conSpeaker = eventSpeaker;
  gl.myConHistory[x].conHistoryEvents[c].speech = eventSpeech.speech;
  gl.myConHistory[x].conHistoryEvents[c].soundPath = eventSpeech.soundPath;

//  log(gl.myConHistory[x].conHistoryEvents[c].speech);
}

// -------------------------------------------------------------------------
// AddHistoryEventChoice()
// -------------------------------------------------------------------------

function AddHistoryEventChoice(String eventSpeaker, ConChoice choice)
{
	local DeusExGlobals gl;
	local int c;

	gl = class'DeusExGlobals'.static.GetGlobals();

  c = gl.myConHistory[x].conHistoryEvents.Length;
  gl.myConHistory[x].conHistoryEvents.Length = c + 1; // добавить 1 к длине массива
  gl.myConHistory[x].conHistoryEvents[c].conSpeaker = eventSpeaker;
  gl.myConHistory[x].conHistoryEvents[c].speech = choice.ChoiceText;
  gl.myConHistory[x].conHistoryEvents[c].soundPath = choice.soundPath;
}


// ----------------------------------------------------------------------
// TurnSpeakingActors()
//
// Attempts to turn the speaking actor to the person being spoken to.
// If the speaking actor is not a scriptedpawn, then abort.
// ----------------------------------------------------------------------

function TurnSpeakingActors(Actor speaker, Actor speakingTo)
{
	if (!bForcePlay)
	{
		TurnActor(speaker,    speakingTo);
		TurnActor(speakingTo, speaker);
	}
	else
	{
		if ((speaker != None) && (speaker.IsA('ScriptedPawn')))
			ScriptedPawn(speaker).EnterConversationState(con.bFirstPerson);
		if ((speakingTo != None) && (speakingTo.IsA('ScriptedPawn')))
			ScriptedPawn(speakingTo).EnterConversationState(con.bFirstPerson);
	}
}

// ----------------------------------------------------------------------
// TurnActor()
// ----------------------------------------------------------------------

function TurnActor(Actor turnActor, Actor turnTowards)
{
	// Check to see if each Actor is already in the conversation
	// state.  If not, they need to be in that state.  Just don't 
	// add the player

	if (DeusExPlayer(turnActor) == None)
	{
		AddConActor(turnActor, con.bFirstPerson);

		if ((turnActor != None) && (turnActor.IsA('ScriptedPawn')))
			ScriptedPawn(turnActor).ConversationActor = turnTowards;
	}
	else
		DeusExPlayer(turnActor).ConversationActor = turnTowards;
}

// ----------------------------------------------------------------------
// AddConActor()
//
// Adds this pawn to the list of actors speaking in this conversation,
// and sets the pawn's conversation state
// ----------------------------------------------------------------------

function AddConActor(Actor newConActor, bool bFirstPerson)
{	
	if ((!bForcePlay) && (newConActor != None))
	{
		// Only do if we have space and this pawn isn't already speaking
		if ((!IsConActorInList(newConActor)) && (conActorCount < 9))
		{
			ConActors[conActorCount++] = newConActor;

			if (newConActor.IsA('ScriptedPawn'))
				ScriptedPawn(newConActor).EnterConversationState(bFirstPerson);
			else if (newConActor.IsA('DeusExDecoration'))
				DeusExDecoration(newConActor).EnterConversationState(bFirstPerson);
		}
	}
}

// ----------------------------------------------------------------------
// IsConActorInList()
// ----------------------------------------------------------------------

function bool IsConActorInList(Actor conActor, optional bool bRemoveActor)
{
	local int conActorIndex;
	local bool bFound;

	for(conActorIndex=0; conActorIndex<conActorCount; conActorIndex++)
	{
		if (ConActors[conActorIndex] == conActor)
		{
			if (bRemoveActor)
				ConActors[conActorIndex] = None;

			bFound = True;
			break;
		}
	}

	return bFound;
}

// ----------------------------------------------------------------------
// EndConActorStates()
//
// Loops through the ConActors[] array and kicks 'em out of
// conversation mode
// ----------------------------------------------------------------------

function EndConActorStates()
{
	local int conActorIndex;

	if (!bForcePlay)
	{
		for(conActorIndex=conActorCount-1; conActorIndex>=0; conActorIndex--)
		{
			if (ConActors[conActorIndex] != None)
			{
				ConActors[conActorIndex].EndConversation();
				ConActors[conActorIndex] = None;
				conActorCount--;
			}
		}

		// Make sure the invoking actor, if a DeusExDecoration or ScriptedPawn,
		// is not stuck in the conversation state
		if (ScriptedPawn(invokeActor) != None )
			ScriptedPawn(invokeActor).EndConversation();
		else if (DeusExDecoration(invokeActor) != None )
			DeusExDecoration(invokeActor).EndConversation();
	}
}

// ----------------------------------------------------------------------
// ActorDestroyed()
//
// Called when an actor gets destroyed via some external process.
// Check our list of ConActors, if the destroyed actors is in this list,
// then:
//
// 1) Remove the actor from the ConActors array
// 2) Immediately abort the conversation (this is done to prevent a 
//    crash by referencing a destroyed object)
// ----------------------------------------------------------------------

function ActorDestroyed(Actor destroyedActor)
{
	local int conActorIndex;

	for(conActorIndex=0; conActorIndex<ArrayCount(ConActorsBound); conActorIndex++)
	{
		if (ConActorsBound[conActorIndex] == destroyedActor)
		{
			// First check to see if it's in the ConActors list, in 
			// which case it needs to be removed before we abort
			// (so it doesn't try to do anything with that variable)
			IsConActorInList(destroyedActor, True);

			// Abort the conversation!!!
			TerminateConversation();
			break;
		}
	}
}

// ----------------------------------------------------------------------
// SetForcePlay()
// ----------------------------------------------------------------------
function SetForcePlay(bool bNewForcePlay)
{
	bForcePlay = bNewForcePlay;
}

// ----------------------------------------------------------------------
// GetForcePlay()
// ----------------------------------------------------------------------
function bool GetForcePlay()
{
	return bForcePlay;
}

// ----------------------------------------------------------------------
// Проверить, существует ли файл озвучивания для этого события.

function String CheckConversationsAudio(Object ev)
{
   local DeusExLevelInfo dxl;
   local string tempstr, aPath;
   local int fhandle;

   foreach AllActors(class'DeusExLevelInfo',dxl)
   break;

   aPath = dxl.ConAudioPath;

   if (ev.IsA('ConChoice'))
       tempStr = aPath $ ConChoice(ev).SoundPath;
   else if (ev.IsA('ConEventSpeech'))
       tempStr = aPath $ ConEventSpeech(ev).SoundPath;

   fhandle = class'FileManager'.static.FileSize(tempstr);
//   log("Checking for soundFile "$tempStr$" result="$fhandle);

   if (fhandle == -1) // -1 = Нет файла
   {
     log("Sound file "$tempStr$" NOT FOUND! result="$fhandle);
     return "";
   }
   return tempStr;
}

function Sound GetSound(string path)
{
  local DeusExLevelInfo dxl;
  local string aPath;
  local sound tmp;//, reused;
  local bool bResult;

  foreach AllActors(class'DeusExLevelInfo',dxl)
  break;

  aPath = dxl.ConAudioPath;

/*  foreach AllObjects(class'Sound', reused)
  {
    if (reused == LastSound)
    break;
  }

    log("Reused USound "$reused);
    return LastSound;
*/

//  bResult = class'DxUtil'.static.LoadSoundFromFile(aPath $ Path, tmp, none);
   bResult = class'SoundManager'.static.LoadSound(aPath $ Path, tmp, outer);

  if (bResult)
  {
      LastSound = tmp;
      return tmp;
  }
  return none;
}

final function ConCamera CreateConCamera()
{
	local ConCamera rezultat;

	// Не создавать, если такой уже есть.
	foreach AllObjects(class'ConCamera', rezultat)
	break;

	if (rezultat != none)
	    return rezultat;

	else if (rezultat == none)
      rezultat = new(Outer) class'ConCamera';

	return rezultat; 
}



// ----------------------------------------------------------------------


defaultproperties
{
}
