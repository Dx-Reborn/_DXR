/*-----------------------------------------------------------------------------
  DeusExPlayer: a Pawn, controlled by DeusExPlayerController.

  Uses code from the following mods:
  GMDX
  Vanilla Matters
-----------------------------------------------------------------------------*/

#exec obj load file=DeusExStaticMeshes
#exec obj load file=DeusExCharacters.ukx
#exec obj load file=DeusExSounds
#exec obj load file=STALKER_Sounds

class DeusExPlayer extends PlayerPawn
                           config;


const maxAmountOfFire = 4;
var const string DefaultStartMap;

// When player management menu (Inventory or Augmentations for example) is opened...
var globalconfig int InterfaceMode; // 0 = Pause game, 1 = Set gamespeed to 0.1, 2 = Do nothing (RealTime)
var globalconfig bool bUseToggleCrouch;
var globalconfig bool bUseToggleWalk;
var /*globalconfig*/ bool bToggleCrouch;				// True to let key toggle crouch
var globalconfig bool bObjectNames;					// Object names on/off
var globalconfig bool bNPCHighlighting;				// NPC highlighting when new convos
var globalconfig bool bSubtitles;					// True if Conversation Subtitles are on
var globalconfig bool bAlwaysRun;					// True to default to running
var globalconfig float logTimeout;					// Log Timeout Value
var globalconfig byte  maxLogLines;					// Maximum number of log lines visible
var globalconfig bool bHUDShowAllAugs;				// TRUE = Always show Augs on HUD
var globalconfig byte translucencyLevel;			// 0 - 10?
var globalconfig bool bObjectBeltVisible;
var globalconfig bool bHitDisplayVisible;
var globalconfig bool bAmmoDisplayVisible;
var globalconfig bool bAugDisplayVisible;	
var globalconfig bool bDisplayAmmoByClip;	
var globalconfig bool bCompassVisible;
var globalconfig bool bCrosshairVisible;
var globalconfig bool bAutoReload;
var globalconfig bool bDisplayAllGoals;
var globalconfig int  UIBackground;					// 0 = Render 3D, 1 = Snapshot, 2 = Black
var globalconfig bool bDisplayCompletedGoals;
var globalconfig bool bShowAmmoDescriptions;
var globalconfig bool bConfirmSaveDeletes;
var globalconfig bool bConfirmNoteDeletes;
var globalconfig bool bAskedToTrain;
// DXR: New options (from Vanilla Matters, but can be turned on/off)
var globalconfig bool bLeftClickForLastItem;
var globalconfig int RemainingAmmoMode;// 0: by clips (default), 1: by rounds
// DXR: New option to display debug info, in addition to built-in ShowDebug()
var globalconfig bool bExtraDebugInfo;

var globalconfig bool bHUDBordersVisible;
var globalconfig bool bHUDBordersTranslucent;
var globalconfig bool bHUDBackgroundTranslucent;
var globalconfig bool bMenusTranslucent;

var() travel int itemFovCorrection;

var() editconst Actor FrobTarget;
//var float MaxFrobDistance;
var float FrobTime;

var class<carcass> CarcassType;
var transient bool bJustPickupCorpse;

var float humanAnimRate;
var() float ReducedDamagePct;

// shake variables
var float JoltMagnitude;  // magnitude of bounce imposed by heavy footsteps

//var travel Inventory SelectedItem;	// currently selected inventory item
var(ToolBelt) travel inventory belt[10];
var(ToolBelt) travel int currentBeltNum;

// Name and skin assigned to PC by player on the Character Generation screen
var travel String	TruePlayerName;
var() travel int    PlayerSkin;

var() transient bool bTPA_OnlyOnce;

// Combat Difficulty, set only at new game time
var travel float CombatDifficulty;

var() travel AugmentationManager AugmentationSystem; // Augmentation system vars
var() travel SkillManager SkillSystem; // Skill system vars

// Used to keep track of # of saves
var() travel int saveCount;
var() travel float saveTime;

var() travel int SkillPointsTotal;
var() travel int SkillPointsAvail;

// Credits (money) the player has
var travel int Credits;

// Energy the player has
var travel float Energy;
var travel float EnergyMax;
var travel float EnergyDrain;			// amount of energy left to drain
var travel float EnergyDrainTotal;		// total amount of energy to drain


/* -- Сохраняемые данные ------------------------------------------------------------------------- */
struct SNanoKeyStruct
{
	var() name             KeyID;
	var() localized String Description;
};
var() travel array<SNanoKeyStruct> NanoKeys; // ключи
var() /*travel*/ NanoKeyRingInv KeyRing;
/* ----------------------------------------------------------------------------------------------- */
struct SDeusExNote
{
  var() String text;				// Note text stored here.
  var() array<string> NoteText;
  var() bool bUserNote;		// True if this is a user-entered note
  var() name textTag;			// Text tag, used for DataCube notes to prevent the same note fromgetting added more than once
};
var() array<SDeusExNote> Notes;
var() travel string personalNoteA, personalNoteB, personalNoteC, personalNoteD;
/* ----------------------------------------------------------------------------------------------- */
struct SDeusExGoal
{
  var() Name goalName;			// Goal name, "GOAL_somestring"
  var() String text;				// Actual goal text
  var() bool bPrimaryGoal;		// True if Primary Goal
  var() bool bCompleted;			// True if Completed
};
var() array<SDeusExGoal> Goals;

/* ----------------------------------------------------------------------------------------------- */
var() array<string> logMessages; // Сообщения (ClientMessage)
/* -- !Сохраняемые данные ------------------------------------------------------------------------ */

var int fireDamage;

// Inventory System Vars
var() travel byte				invSlots[30];		// 5x6 grid of inventory slots
var editconst int	maxInvRows;			// Maximum number of inventory rows
var editconst int	maxInvCols;			// Maximum number of inventory columns

var() travel Inventory		inHand;				// The current object in hand
var() travel Inventory		inHandPending;		// The pending item waiting to be put in hand
var() travel bool				bInHandTransition;	// The inHand is being swapped out

var travel Inventory VM_lastInHand;				// Last item in hand before PutInHand( None ).

// toggle walk
var bool bToggleWalk;

// used by lots of stuff
var name FloorMaterial;
var name WallMaterial;
var Vector WallNormal;

// drug effects on the player
var float drugEffectTimer;

// bleeding variables
var     float       BleedRate;      // how profusely the player is bleeding; 0-1
var     float       DropCounter;    // internal; used in tick()
var()   float       ClotPeriod;     // seconds it takes bleedRate to go from 1 to 0

// poison dart effects on the player
var float poisonTimer;      // time remaining before next poison TakeDamage
var int   poisonCounter;    // number of poison TakeDamages remaining
var int   poisonDamage;     // damage taken from poison effect

// length of time player can stay underwater
// modified by SkillSwimming, AugAqualung, and Rebreather
var float swimDuration;
var float swimTimer;
var float swimBubbleTimer;
// Чтобы не изобретать велосипед с переделыванием FootStepping()...
var float swimSoundTimer;

// map that we're about to travel to after we finish interpolating
var String NextMap;

var bool bStartingNewGame;							// Set to True when we're starting a new game. 
var bool bSavingSkillsAugs;

var() sound JumpSound;

// transient для безопасности.
var transient ShadowProjector PlayerShadow;

var travel bool bStartNewGameAfterIntro;

// Put spy drone here instead of HUD
var bool bSpyDroneActive;
var int spyDroneLevel;
var float spyDroneLevelValue;
var SpyDrone aDrone;

// Conversation Invocation Methods
enum EInvokeMethod
{
	IM_Bump,
	IM_Frob,
	IM_Sight,
	IM_Radius,
	IM_Named,
	IM_Other
};

// conversation info
var Actor ConversationActor;
var Actor lastThirdPersonConvoActor;
var float lastThirdPersonConvoTime;
var Actor lastFirstPersonConvoActor;
var float lastFirstPersonConvoTime;
var ConPlay conPlay;
var DataLinkPlay dataLinkPlay;

// Used to manage NPC Barks
var travel BarkManager barkManager;
var bool bInConversation;
var string strStartMap;

var transient DeusExGlobals gl;
var transient PlayerInterfacePanel winInv;

var DeusExPlayerController dxpc;

/* В оригинале используется при начале новой игры. Предполагаю
   что просто очищает каталог Current. Готовая функция уже есть,
   нужно просто выставить флаг, обозначающий что это еще не 
   сделано. После загрузки новой карты сработает InitGame и
   выполнит все что нужно :) */
final function DeleteSaveGameFiles(optional String saveDirectory)
{
  gl = class'DeusExGlobals'.static.GetGlobals();
  gl.CurrentSaveDirectoryCleared = false;
}

/* -------------------------------------------------------------------------------------------
   Сохранить флаги в массив байт.
 -------------------------------------------------------------------------------------------*/
function SaveTravelData()
{
  RawByteFlags = class'GameFlags'.static.ExportFlagsToArray();
}
/* -------------------------------------------------------------------------------------------
   Восстановить флаги из массива байт.
 -------------------------------------------------------------------------------------------*/
function RestoreTravelData()
{
  class'GameFlags'.static.ImportFlagsFromArray(RawByteFlags);
}

function DeleteInventory(inventory item)
{
	// Vanilla Matters: Make sure VM_lastInHand is deleted properly.
  if (item == VM_lastInHand)
      VM_lastInHand = None;

	// If the item was inHand, clear the inHand
	if (inHand == item)
	{
		SetInHand(None);
		SetInHandPending(None);
	}

	// Make sure the item is removed from the inventory grid
	RemoveItemFromSlot(item);

	if (winInv != None)
	{
		// If the inventory screen is active, we need to send notification
		// that the item is being removed
			winInv.InventoryDeleted(item);

		// Remove the item from the object belt
//		if (root != None)
//			root.DeleteInventory(item);
	}

	Super.DeleteInventory(item);
  ValidateBelt();
}


// TODO: Add HUD icons for this
function AddChargedDisplay(ChargedPickupInv item)
{
//	DeusExRootWindow(rootWindow).hud.activeItems.AddIcon(item.ChargedIcon, item);
}

function RemoveChargedDisplay(ChargedPickupInv item)
{
//	DeusExRootWindow(rootWindow).hud.activeItems.RemoveIcon(item);
}


// ----------------------------------------------------------------------
// SetLogTimeout()
// ----------------------------------------------------------------------
function SetLogTimeout(float newLogTimeout)
{
	logTimeout = newLogTimeout;
}

// ----------------------------------------------------------------------
// GetLogTimeout()
// ----------------------------------------------------------------------
function float GetLogTimeout()
{
	return logTimeout;
}

// ----------------------------------------------------------------------
// SetMaxLogLines()
// ----------------------------------------------------------------------
function SetMaxLogLines(byte newLogLines)
{
	maxLogLines = newLogLines;
}

// ----------------------------------------------------------------------
// GetMaxLogLines()
// ----------------------------------------------------------------------

function byte GetMaxLogLines()
{
	return maxLogLines;
}

// turns the scope on or off for the current weapon
exec function ToggleScope()
{
	local DeusExWeaponInv W;

	if (dxpc.RestrictInput())
		return;

	W = DeusExWeaponInv(Weapon);
	if (W != None)
		W.ScopeToggle();
}

// turns the laser sight on or off for the current weapon
exec function ToggleLaser()
{
	local DeusExWeaponInv W;

	if (dxpc.RestrictInput())
		return;

	W = DeusExWeaponInv(Weapon);
	if (W != None)
		W.LaserToggle();
}

// Called when one of the player's weapons is reloading
function Reloading(DeusExWeaponInv weapon, float reloadTime)
{
//	if (!IsLeaning() && !bIsCrouching && (Physics != PHYS_Swimming) && !IsInState('Dying'))
		PlayAnim('Reload', 1.0 / reloadTime, 0.1);
}

simulated function bool CanThrowWeapon()
{
    return true;// ((Weapon != None) && Weapon.CanThrow());
}

// ----------------------------------------------------------------------
// --== Быстрый доступ (ToolBelt) ==--
// ----------------------------------------------------------------------  
function putOnBelt(Inventory item)
{
  local int x;

  //if (ItemNotForBelt(item))
  if ((item != none) && (!item.bDisplayableInv))
  return;

   for(x=0; x<10; x++) //10
   {
     if (item.class == belt[x].class) // Сравниваем именно класс, а не указатель на предмет.
     {                                
//       log("belt="$belt[x] @ "item= "$item);
       break; //return;
     }
     else if(belt[x] == none)
     {
//        break;//
        belt[x] = item;
        item.SetbeltPos(x);
        return;
     }
   }
}

exec function ActivateBelt(int objectNum)
{
	if ((DeusExPlayerController(controller)).RestrictInput())
		return;

	if (CarriedDecoration == None)
	{
    ActivateObjectInBelt(objectNum);
	}
}


// Проверить, не осталось ли на панели быстрого доступа 
// несуществующих предметов.
exec function ValidateBelt()
{
  local int x;

   for(x=0; x<10; x++)
   {
    if (belt[x] != none) // no spamlog.
    {
       if (belt[x].owner != self)
           belt[x] = none;
    }
   }
}

// Don't place these item to toolbelt, since they should be used in special way.
// Aug cannisters (install and upgrade)
// Nanokeys
// Ammunition
// Datavault Images
function bool ItemNotForBelt(inventory item)
{
  if (item.isA('AugmentationCannisterInv') || item.isA('AugmentationUpgradeCannisterInv') || 
      item.isA('NanoKeyInv') || item.IsA('Ammunition') || item.IsA('DataVaultImageInv'))
  return true;
}

/* ----------------------------------------------------------------------------------------------- */
// --== Управление заметками ==--
// ----------------------------------------------------------------------
// Adds a new note to the list of notes the player is carrying around.
// ----------------------------------------------------------------------
function AddNote(optional array<String> strNote, optional Bool bUserNote, optional bool bShowInLog, optional name NewTag)
{
  gl = class'DeusExGlobals'.static.GetGlobals();
  gl.AddNote(strNote, bUserNote,,NewTag);

	// Optionally show the note in the log
	if (bShowInLog)
	{
   if (ConPlay.dMsg != none) // DXR: Show these messages later.
       ConPlay.dMsg.AddMessage(NoteAdded, sound'DeusExSounds.UserInterface.LogNoteAdded');
   else
   {
		ClientMessage(NoteAdded);
		PlaySound(Sound'LogNoteAdded');
	 }
	}
}

// ----------------------------------------------------------------------
// Loops through the notes and searches for the TextTag passed in
// ----------------------------------------------------------------------
function name GetNote(Name textTag)
{
  gl = class'DeusExGlobals'.static.GetGlobals();
  return gl.GetNote(textTag);

/*  local int x;

  for(x=0; x<Notes.Length; x++)
  {
    if (Notes[x].textTag == textTag)
    {
      return Notes[x].textTag;
    }
  }
 return 'none';*/
}

// ----------------------------------------------------------------------
// Deletes the specified note
// Returns True if the note successfully deleted
// Заметки теперь удаляются из оконного интерфейса, а для удаления
// всех достаточно обнулить массив.
// ----------------------------------------------------------------------
function bool DeleteNote(string Note)
{
/*  local int x;

  gl = class'DeusExGlobals'.static.GetGlobals();

  for(x=0; x<gl.Notes.Length; x++)
  {
    if (Notes[x].text == Note)
    {
			Notes.Remove(x,1);
      return true;
    }
  }*/
 return true;//false;
}

// ----------------------------------------------------------------------
// Deletes *ALL* Notes
// ----------------------------------------------------------------------
function DeleteAllNotes()
{
  gl = class'DeusExGlobals'.static.GetGlobals();
	gl.Notes.Length = 0;
}

/* Пользовательские заметки теперь добавляются через интерфейс */
exec function NoteAdd(String noteText, optional bool bUserNote)
{
/*  local int x;

    x = Notes.Length;
    Notes.Length = x + 1; // добавить 1 к длине массива
    Notes[x].text = noteText; // присвоить данные к элементу массива
    Notes[x].bUserNote = bUserNote;*/
}

// --== Управление задачами ==--
// ----------------------------------------------------------------------
// AddGoal()
//
// Adds a new goal to the list of goals the player is carrying around.
// ----------------------------------------------------------------------
function name AddGoal(Name goalName, bool bPrimaryGoal, optional string goalText)
{
  gl = class'DeusExGlobals'.static.GetGlobals();
  gl.Player = self;
  return gl.AddGoal(goalName, bPrimaryGoal, goalText);
}

// ----------------------------------------------------------------------
// FindGoal()
// ----------------------------------------------------------------------
function name FindGoal(Name goalName)
{
  gl = class'DeusExGlobals'.static.GetGlobals();
  gl.Player = self;
  return gl.FindGoal(goalName);
}

// ----------------------------------------------------------------------
// Adds a new goal to the list of goals the player is carrying around.
// ----------------------------------------------------------------------
exec function GoalAdd(Name goalName, String goalText, optional bool bPrimaryGoal)
{
  gl = class'DeusExGlobals'.static.GetGlobals();
  gl.Player = self;
  gl.GoalAdd(goalName, goalText, bPrimaryGoal);
}

// ----------------------------------------------------------------------
// Sets a goal as a Primary Goal
// ----------------------------------------------------------------------
exec function GoalSetPrimary(Name goalName, bool bPrimaryGoal)
{
  gl = class'DeusExGlobals'.static.GetGlobals();
  gl.Player = self;
  gl.GoalSetPrimary(goalName, bPrimaryGoal);
}

// ----------------------------------------------------------------------
// GoalCompleted()
//
// Looks up the goal and marks it as completed.
// ----------------------------------------------------------------------
function GoalCompleted(Name goalName)
{
  gl = class'DeusExGlobals'.static.GetGlobals();
  gl.Player = self;
  gl.GoalCompleted(goalName);
}

// ----------------------------------------------------------------------
// Deletes the specified goal
// Returns True if the goal successfully deleted
// ----------------------------------------------------------------------
function bool DeleteGoal(name goalToDelete)
{
  gl = class'DeusExGlobals'.static.GetGlobals();
  gl.Player = self;
  return gl.DeleteGoal(goalToDelete);
}

// ----------------------------------------------------------------------
// DeleteAllGoals()
//
// Deletes *ALL* Goals
// ----------------------------------------------------------------------
function DeleteAllGoals()
{
  gl = class'DeusExGlobals'.static.GetGlobals();
	gl.Goals.Length = 0;
}

// ----------------------------------------------------------------------
// ResetGoals()
//
// Called when progressing to the next mission.  Deletes all
// completed Primary Goals as well as *ALL* Secondary Goals
// (regardless of status)
// ----------------------------------------------------------------------
function ResetGoals()
{
  gl.ResetGoals();
}
// --== !Управление задачами ==--


final function UpdateTimePlayed(float deltaTime)
{
	saveTime += deltaTime;
}

//
// Find out what mission we're in.
// return the current mission number
//
function int getMissionNum()
{
    return DeusExGameInfo(Level.Game).missionNumber;
}

//
// Stores an image in the player's data vault.
// @param image the data vault image being added
//
function addImage(DataVaultImageInv image)
{
 if (FindInventoryType(image.class) == none)
   {
      image = spawn(image.class);
      image.Frob(self, none);
   }
}


// ----------------------------------------------------------------------
// UsingChargedPickup
// ----------------------------------------------------------------------

function bool UsingChargedPickup(class<ChargedPickupInv> itemclass)
{
   local inventory CurrentItem;
   local bool bFound;

   bFound = false;
   
   for (CurrentItem = Inventory; ((CurrentItem != None) && (!bFound)); CurrentItem = CurrentItem.inventory)
   {
      if ((CurrentItem.class == itemclass) && (CurrentItem.IsActive()))
         bFound = true;
   }
   return bFound;
}

	
// ----------------------------------------------------------------------
// IsEmptyItemSlot()
//
// Returns True if the item will fit in this slot
// ----------------------------------------------------------------------
function bool IsEmptyItemSlot(Inventory anItem, int col, int row)
{
	local int slotsCol;
	local int slotsRow;
	local Bool bEmpty;

	if ( anItem == None )
		return False;

	// First make sure the item can fit horizontally
	// and vertically
	if ((col + anItem.GetinvSlotsX() > maxInvCols) || (row + anItem.GetinvSlotsY() > maxInvRows))
			return False;

	// Now check this and the needed surrounding slots
	// to see if all the slots are empty

	bEmpty = true;
	for(slotsRow=0; slotsRow < anItem.GetinvSlotsY(); slotsRow++)
	{
		for (slotsCol=0; slotsCol < anItem.GetinvSlotsX(); slotsCol++)
		{
			if (invSlots[((slotsRow + row) * maxInvCols) + (slotsCol + col)] == 1)
			{
				bEmpty = false;
				break;
			}
		}

		if (!bEmpty)
			break;
	}

	return bEmpty;
}

// ----------------------------------------------------------------------
// IsEmptyItemSlotXY()
//
// Returns True if the item will fit in this slot
// ----------------------------------------------------------------------
function Bool IsEmptyItemSlotXY(int invSlotsX, int invSlotsY, int col, int row)
{
	local int slotsCol;
	local int slotsRow;
	local Bool bEmpty;

	// First make sure the item can fit horizontally
	// and vertically
	if ((col + invSlotsX > maxInvCols) || (row + invSlotsY > maxInvRows))
			return False;

	// Now check this and the needed surrounding slots
	// to see if all the slots are empty

	bEmpty = true;
	for(slotsRow=0; slotsRow < invSlotsY; slotsRow++)
	{
		for (slotsCol=0; slotsCol < invSlotsX; slotsCol++)
		{
			if (invSlots[((slotsRow + row) * maxInvCols) + (slotsCol + col)] == 1)
			{
				bEmpty = false;
				break;
			}
		}
		if (!bEmpty)
			break;
	}
	return bEmpty;
}

// ----------------------------------------------------------------------
// SetInvSlots()
// ----------------------------------------------------------------------
function SetInvSlots(Inventory anItem, int newValue)
{
	local int slotsCol;
	local int slotsRow;

	if ( anItem == None )
		return;

	// Make sure this item is located in a valid position
	if (( anItem.GetinvPosX() != -1 ) && (anItem.GetinvPosY() != -1))
	{
		// fill inventory slots
		for( slotsRow=0; slotsRow < anItem.GetinvSlotsY(); slotsRow++ )
			for ( slotsCol=0; slotsCol < anItem.GetinvSlotsX(); slotsCol++ )
				invSlots[((slotsRow + anItem.GetinvPosY()) * maxInvCols) + (slotsCol + anItem.GetinvPosX())] = newValue;
	}
}

// ----------------------------------------------------------------------
// PlaceItemInSlot()
// ----------------------------------------------------------------------
function PlaceItemInSlot(Inventory anItem, int col, int row)
{
	// Save in the original Inventory item also
	log("PlaceItemInSlot. AnItem is="$anItem@"InvPosX="$col@"InvPosY="$row);
	anItem.SetInvPosX(col);
	anItem.SetinvPosY(row);

	SetInvSlots(anItem, 1);
}

// ----------------------------------------------------------------------
// RemoveItemFromSlot()
//
// Removes an inventory item from the inventory grid
// ----------------------------------------------------------------------
function RemoveItemFromSlot(Inventory anItem)
{
	if (anItem != None)
	{
		SetInvSlots(anItem, 0);
		anItem.SetinvPosX(-1);
		anItem.SetinvPosY(-1);
	}
}

// ----------------------------------------------------------------------
// ClearInventorySlots()
//
// Not for the foolhardy
// ----------------------------------------------------------------------
function ClearInventorySlots()
{
	local int slotIndex;

	for(slotIndex=0; slotIndex<arrayCount(invSlots); slotIndex++)
		invSlots[slotIndex] = 0;
}

// ----------------------------------------------------------------------
// FindInventorySlot()
//
// Searches through the inventory slot grid and attempts to find a 
// valid location for the item passed in.  Returns True if the item
// is placed, otherwise returns False.
// ----------------------------------------------------------------------
function bool FindInventorySlot(Inventory anItem, optional Bool bSearchOnly)
{
	local bool bPositionFound;
	local int row;
	local int col;
//	local int newSlotX;
//	local int newSlotY;
//	local ammo foundAmmo;

	if (anItem == None)
		return False;
	
	// Special checks for objects that do not require phsyical inventory
	// in order to be picked up:
	// 
	// - NanoKeys
	// - DataVaultImages
	// - Credits
	// - Ammo

	if ((anItem.IsA('DataVaultImageInv')) || (anItem.IsA('NanoKeyInv')) || (anItem.IsA('CreditsInv')) || (anItem.IsA('Ammunition')))
		return True;

	bPositionFound = false;

	// Loop through all slots, looking for a fit
	for (row=0; row<maxInvRows; row++)
	{	
		if (row + anItem.GetinvSlotsY() > maxInvRows)
			break;

		// Make sure the item can fit vertically
		for(col=0; col<maxInvCols; col++)
		{
			if (IsEmptyItemSlot(anItem, col, row))
			{
				bPositionFound = True;
				break;
			}
		}
		if (bPositionFound)
			break;
	}
	if ((bPositionFound) && (!bSearchOnly))
		PlaceItemInSlot(anItem, col, row);

	return bPositionFound;
}
				
// ----------------------------------------------------------------------
// FindInventorySlotXY()
//
// Searches for an available slot given the number of horizontal and
// vertical slots this item takes up.
// ----------------------------------------------------------------------
function bool FindInventorySlotXY(int invSlotsX, int invSlotsY, out int newSlotX, out int newSlotY)
{
	local bool bPositionFound;
	local int row;
	local int col;

	bPositionFound = false;

	// Loop through all slots, looking for a fit
	for (row=0; row<maxInvRows; row++)
	{	
		if (row + invSlotsY > maxInvRows)
			break;

		// Make sure the item can fit vertically
		for(col=0; col<maxInvCols; col++)
		{
			if (IsEmptyItemSlotXY(invSlotsX, invSlotsY, col, row))
			{
				newSlotX = col;
				newSlotY = row;

				bPositionFound = True;
				break;
			}
		}

		if (bPositionFound)
			break;
	}

	return bPositionFound;
}

// ----------------------------------------------------------------------
// DumpInventoryGrid()
//
// Dumps the inventory grid to the log file.  Useful for debugging only.
// ----------------------------------------------------------------------

exec function DumpInventoryGrid()
{
	local int slotsCol;
	local int slotsRow;
	local String gridRow;

	log("DumpInventoryGrid()");
	log("_____________________________________________________________");
	
	log("        1 2 3 4 5");
	log("-----------------");


	for(slotsRow=0; slotsRow < maxInvRows; slotsRow++)
	{
		gridRow = "Row #" $ slotsRow $ ": ";

		for (slotsCol=0; slotsCol < maxInvCols; slotsCol++)
		{
			if ( invSlots[(slotsRow * maxInvCols) + slotsCol] == 1)
				gridRow = gridRow $ "X ";
			else
				gridRow = gridRow $ "  ";
		}
		
		log(gridRow);
	}
	log("_____________________________________________________________");
}

exec function SwitchAmmo()
{
	if (inHand.IsA('DeusExWeaponInv'))
		DeusExWeaponInv(inHand).CycleAmmo();
}

// ----------------------------------------------------------------------
// ReloadWeapon()
//
// reloads the currently selected weapon
// ----------------------------------------------------------------------

exec function ReloadWeapon()
{
	local DeusExWeaponInv W;

	if (DeusExPlayerController(controller).RestrictInput())
		return;

	W = DeusExWeaponInv(Weapon);
	if (W != None)
		W.ReloadAmmo();
}

event PreSaveGame()
{
  SaveTravelData();
} 

// ----------------------------------------------------------------------
// ParseLeftClick()
// ----------------------------------------------------------------------
exec function ParseLeftClick()
{
	//
	// ParseLeftClick deals with things in your HAND
	//
	// Precedence:
	// - Detonate spy drone
	// - Fire (handled automatically by user.ini bindings)
	// - Use inHand
	// DXR: pickup corpse without checking its inventory.
	//

	local SpyDrone myDrone;
	local AugDrone anAug;
//	local bool bBinocsActive;

	if (DeusExPlayerController(controller).RestrictInput())
		return;

//  if (frobTarget != none)
//  {
	    if ((frobTarget != none) && (frobTarget.IsA('DeusExCarcass')) && (inHand == none))
	    {
        bJustPickupCorpse = true;
        DeusExCarcass(frobTarget).frob(self, none);
      }
//  }

	// if the spy drone augmentation is active, blow it up
	if (DeusExHud(DeusExPlayerController(Level.GetLocalPlayerController()).myHUD).bSpyDroneActive)
	{
		myDrone = DeusExHud(DeusExPlayerController(Level.GetLocalPlayerController()).myHUD).aDrone;
		if (myDrone != None)
		{
			myDrone.Explode(myDrone.Location, vect(0,0,1));
			foreach AllActors(class'AugDrone', anAug)
				anAug.Deactivate();

			return;
		}
	}

	if ((inHand != None) && !bInHandTransition)
	{
		if (inHand.Activatable())
			inHand.Activate();

		else if (FrobTarget != None)
		{
			// special case for using keys or lockpicks on doors
			if (FrobTarget.IsA('DeusExMover'))
				if (inHand.IsA('NanoKeyRingInv') || inHand.IsA('LockpickInv'))
					DoFrob(Self, inHand);

			// special case for using multitools on hackable things
			if (FrobTarget.IsA('HackableDevices'))
				if (inHand.IsA('MultitoolInv'))
					DoFrob(Self, inHand);
		}
	}
 else if ((VM_lastInHand != None) && (bLeftClickForLastItem))
          PutInHand(VM_lastInHand);
}


// ----------------------------------------------------------------------
// ParseRightClick()
// ----------------------------------------------------------------------

exec function ParseRightClick()
{
	//
	// ParseRightClick deals with things in the WORLD
	//
	// Precedence:
	// - Pickup highlighted Inventory
	// - Frob highlighted object
	// - Grab highlighted Decoration
	// - Put away (or drop if it's a deco) inHand
	//

	local Inventory oldInHand;
//	local Inventory frobInv;
	local Decoration oldCarriedDecoration;
	local Vector loc;

	if (DeusExPlayerController(controller).RestrictInput())
		return;

	oldInHand = inHand;
	oldCarriedDecoration = CarriedDecoration;

	if (FrobTarget != None)
		loc = FrobTarget.Location;

	if (FrobTarget != None)
	{
		// First check if this is a NanoKey, in which case we just
		// want to add it to the NanoKeyRing without disrupting
		// what the player is holding

		if (FrobTarget.IsA('NanoKey'))
		{
			PickupNanoKey(NanoKey(FrobTarget));
			FrobTarget.Destroy();
			FrobTarget = None;
			return;
		}
		else if (FrobTarget.IsA('inventory'))
		{
			// If this is an item that can be stacked, check to see if 
			// we already have one, in which case we don't need to 
			// allocate more space in the inventory grid.
			// 
			// TODO: This logic may have to get more involved if/when 
			// we start allowing other types of objects to get stacked.

      if (HandleItemPickup(FrobTarget, True) == False)
				return;

			// if the frob succeeded, put it in the player's inventory
			if (Inventory(FrobTarget).Owner == Self)
			{
				FindInventorySlot(Inventory(FrobTarget));
				FrobTarget = None;
			}
		}
		else if (FrobTarget.IsA('Decoration') && Decoration(FrobTarget).bPushable)
		{
			GrabDecoration();
		}
		else
		{
			// otherwise, just frob it
			DoFrob(Self, None);
		}
	}
	else
	{
		// if there's no FrobTarget, put away an inventory item or drop a decoration
		// or drop the corpse
		if ((inHand != None) && inHand.IsA('POVCorpse'))
			DropItem();
		else
			PutInHand(None);
	}

	if ((oldInHand == None) && (inHand != None))
		PlayPickupAnim(loc);
	else if ((oldCarriedDecoration == None) && (CarriedDecoration != None))
		PlayPickupAnim(loc);
}

exec function NextItem();


function bool HandleItemPickup(Actor FrobTarget, optional bool bSearchOnly)
{
	local bool bCanPickup;
	local bool bSlotSearchNeeded;
	local Inventory foundItem;

	log("HandleItemPickup received "$FrobTarget);

	bSlotSearchNeeded = True;
	bCanPickup = True;

	// Special checks for objects that do not require phsyical inventory
	// in order to be picked up:
	// 
	// - NanoKeys
	// - DataVaultImages
	// - Credits

	if ((FrobTarget.IsA('DataVaultImageInv')) || (FrobTarget.IsA('NanoKeyInv')) || (FrobTarget.IsA('CreditsInv')))
	{
		bSlotSearchNeeded = False;
	}
	else if (FrobTarget.IsA('AugmentationCannisterInv'))
	{
			bSlotSearchNeeded = true;
	}
	else if (FrobTarget.IsA('DeusExPickupInv'))
	{
		// If an object of this type already exists in the player's inventory *AND*
		// the object is stackable, then we don't need to search.
		if ((FindInventoryType(FrobTarget.class) != None) && (DeusExPickupInv(FrobTarget).bCanHaveMultipleCopies))
			bSlotSearchNeeded = False;
	}
	else 
	{
		// If this isn't ammo or a weapon that we already have, 
		// check if there's enough room in the player's inventory
		// to hold this item.

		foundItem = GetWeaponOrAmmo(Inventory(FrobTarget));

		if (foundItem != None)
		{
			bSlotSearchNeeded = False;

			// if this is an ammo, and we're full of it, abort the pickup
			if (foundItem.IsA('Ammunition'))
			{
				if (Ammunition(foundItem).AmmoAmount >= Ammunition(foundItem).MaxAmmo)
				{
					ClientMessage(TooMuchAmmo);
					bCanPickup = False;
				}
			}

			// If this is a grenade or LAM (what a pain in the ass) then also check
			// to make sure we don't have too many grenades already
			else if ((foundItem.IsA('WeaponEMPGrenadeInv')) || (foundItem.IsA('WeaponGasGrenadeInv')) || (foundItem.IsA('WeaponNanoVirusGrenadeInv')) || (foundItem.IsA('WeaponLAMInv')))
			{
				if (DeusExWeaponInv(foundItem).AmmoType.AmmoAmount >= DeusExWeaponInv(foundItem).AmmoType.MaxAmmo)
				{
					ClientMessage(TooMuchAmmo);
					bCanPickup = False;
				}
			}


			// Otherwise, if this is a single-use weapon, prevent the player
			// from picking up

			else if (foundItem.IsA('DeusExWeaponInv'))
			{
				// If these fields are set as checked, then this is a 
				// single use weapon, and if we already have one in our 
				// inventory another cannot be picked up (puke). 

				bCanPickup = !((DeusExWeaponInv(foundItem).ReloadCount == 0) && (DeusExWeaponInv(foundItem).PickupAmmoCount == 0) && (DeusExWeaponInv(foundItem).AmmoName != None));

				if (!bCanPickup)
					ClientMessage(Sprintf(CanCarryOnlyOne, foundItem.itemName));
			}
		}
	}
	
	if (bSlotSearchNeeded && bCanPickup)
	{
		if (FindInventorySlot(Inventory(FrobTarget), bSearchOnly) == False)
		{
			ClientMessage(Sprintf(InventoryFull, Inventory(FrobTarget).itemName));
			bCanPickup = False;		
		}
	}

	if (bCanPickup)
	{
		DoFrob(Self, inHand);
		log("bCanPickup="$bCanPickup);
		putOnBelt(inventory(frobTarget)); // Добавить в быстрый доступ
	}

	log("HandleItemPickup return value is "$bCanPickup);
	return bCanPickup;
}

function Inventory GetWeaponOrAmmo(Inventory queryItem)
{
	// First check to see if this item is actually a weapon or ammo
	if ((Weapon(queryItem) != None) || (Ammunition(queryItem) != None))
		return FindInventoryType(queryItem.Class);
	else 
		return None;
}

// ----------------------------------------------------------------------
// DoFrob()
// 
// Frob the target
// ----------------------------------------------------------------------

function DoFrob(Actor Frobber, Inventory frobWith)
{
	local Actor A;

	// make sure nothing is based on us if we're an inventory
	if (FrobTarget.IsA('Inventory'))
		foreach FrobTarget.BasedActors(class'Actor', A)
			A.SetBase(None);

	FrobTarget.Frob(Frobber, frobWith);

	// if the object destroyed itself, get out
	if (FrobTarget == None)
		return;

	// if the inventory item aborted it's own pickup, get out
	if (FrobTarget.IsA('Inventory') && (FrobTarget.Owner != Self))
		return;

	// alert NPCs that I'm messing with stuff
	if (FrobTarget.isOwned())
		class'EventManager'.static.AISendEvent(self,'Futz', EAITYPE_Visual);

	// play an animation
	PlayPickupAnim(FrobTarget.Location);

	// set the base so the inventory follows us around correctly
	if (FrobTarget.IsA('Inventory'))
		FrobTarget.SetBase(Frobber);
}

// ----------------------------------------------------------------------
// PickupNanoKey()
// 
// Picks up a NanoKey
//
// 1. Add KeyID to list of keys
// 2. Destroy NanoKey (since the user can't have it in his/her inventory)
// ----------------------------------------------------------------------
function PickupNanoKey(NanoKey newKey)
{
  KeyRing = NanoKeyRingInv(FindInventoryType(class'NanoKeyRingInv'));
	KeyRing.GiveKey(newKey.KeyID, newKey.Description);
	ClientMessage(Sprintf(AddedNanoKey, newKey.Description));
}

function bool IsLeaning()
{
	return (DeusExPlayerController(controller).curLeanDist != 0);
}

// check to see if the player can lift a certain decoration taking
// into account his muscle augs
function bool CanBeLifted(DeusExDecoration deco)
{
	local int augLevel, augMult;
	local float maxLift;

	maxLift = 50;
	if (AugmentationSystem != None)
	{
		augLevel = AugmentationSystem.GetClassLevel(class'AugMuscle');
		augMult = 1;
		if (augLevel >= 0)
			augMult = augLevel+2;
		maxLift *= augMult;
	}

	if (!deco.bPushable || (deco.Mass > maxLift) || (deco.StandingCount() > 1)) // Больше 1 потому что еще есть заглушка
	{
		if (deco.bPushable)
			ClientMessage(TooHeavyToLift);
		else
			ClientMessage(CannotLift);

		return False;
	}

	return True;
}


function PostBeginPlay()
{
	local DeusExLevelInfo info;
	local int levelInfoCount;

	Super.PostBeginPlay();

	// Check to make sure there's only *ONE* DeusExLevelInfo and go fucking *BOOM* if we find more than one.
	levelInfoCount = 0;
	foreach AllActors(class'DeusExLevelInfo', info)
		levelInfoCount++;

	Assert(levelInfoCount <= 1);
	
	InitializeSubSystems();
}

function SkillPointsAdd(int numPoints)
{
	if (numPoints > 0)
	{
		SkillPointsAvail += numPoints;
		SkillPointsTotal += numPoints;

		if (ConPlay.dMsg != none) // DXR: Show these messages later.
        ConPlay.dMsg.AddMessage(Sprintf(SkillPointsAward, numPoints), sound'DeusExSounds.UserInterface.LogSkillPoints');
		else
		{
		ClientMessage(Sprintf(SkillPointsAward, numPoints));
		PlaySound(sound'DeusExSounds.UserInterface.LogSkillPoints');
		}
	}
}


// ----------------------------------------------------------------------
// PreTravel() - Called when a ClientTravel is about to happen
// PreClientTravel происходит только в контроллере, поэтому вызов
// этой функции происходит из DeusExPlayerController.
// ----------------------------------------------------------------------
function preTravel() //PreClientTravel()
{
  SaveTravelDecoration();

  // Set a flag designating that we're traveling,
  // so MissionScript can check and not call FirstFrame() for this map.
 	GetflagBase().SetBool("PlayerTraveling", True, True, 0);
  SaveSkillPoints();


  if (dataLinkPlay != None)
    dataLinkPlay.AbortAndSaveHistory();

  // If the player is burning (Fire! Fire!), extinguish him
  // before the map transition.  This is done to fix stuff 
  // that's fucked up.
  ExtinguishFire();
}

function InitializeSubSystems()
{
	// Spawn the BarkManager
	if (BarkManager == None)
		BarkManager = Spawn(class'BarkManager', Self);

	// install the augmentation system if not found
	if (AugmentationSystem == None)
	{
		AugmentationSystem = Spawn(class'AugmentationManager', Self);
		AugmentationSystem.CreateAugmentations(Self);
		AugmentationSystem.AddDefaultAugmentations();
	}
	else
	{
		AugmentationSystem.SetPlayer(Self);
	}

	// install the skill system if not found
	if (SkillSystem == None)
	{
		SkillSystem = Spawn(class'SkillManager', Self);
		SkillSystem.CreateSkills(Self);
	}
	else
	{
		SkillSystem.SetPlayer(Self);
	}

	// Give the player a keyring
	CreateKeyRing();
}

// ----------------------------------------------------------------------
// CreateKeyRing()
// ----------------------------------------------------------------------

function CreateKeyRing()
{
  KeyRing = NanoKeyRingInv(FindInventoryType(class'NanoKeyRingInv'));
  if (KeyRing != None)
  {
	//belt[9]=KeyRing;
	belt[0]=KeyRing;
   return;
  }

	if (KeyRing == None)
	{
		KeyRing = Spawn(class'NanoKeyRingInv', Self);
		KeyRing.SetBase(Self);
		KeyRing.InitialState='Idle2';
		KeyRing.Frob(Self, none);
//		KeyRing.giveto(Self);
		belt[0]=KeyRing;
	}
}

event TravelPostAccept()
{
	local DeusExLevelInfo info;
	local MissionScript scr;
	local bool bScriptRunning;
	local augmentation aug;

	dxpc = DeusExPlayerController(Controller);

if (!bTPA_OnlyOnce)
 {
  log(self@"TravelPostAccept()");

	// reset the keyboard
//	DeusExPlayerController(Level.GetLocalPlayerController()).ResetKeyboard();
	info = GetLevelInfo();

	// Make sure any charged pickups that were active 
	// before travelling are still active.
//	RefreshChargedPickups();

	// Make sure the Skills and Augmentation systems 
	// are properly initialized and reset.

	RestoreSkillPoints();

	if (SkillSystem != None)
	{
		SkillSystem.SetPlayer(Self);
	}

	if (AugmentationSystem != None)
	{
		// set the player correctly
		AugmentationSystem.SetPlayer(Self);
		AugmentationSystem.RefreshAugDisplay();

		foreach AllActors(class'Augmentation', aug)
     if (aug != none)
      aug.RestoreAugLevel();
	}

	// Make sure any objects that care abou the PlayerSkin
	// are notified
	UpdatePlayerSkin();

	// If the player was carrying a decoration, restore it!
	RestoreTravelDecoration();

	// If the player was carrying a decoration, make sure
	// it's placed back in his hand (since the location
	// info won't properly travel)
//	PutCarriedDecorationInHand();

	// Reset FOV
	SetFOVAngle(DeusExPlayerController(controller).Default.DesiredFOV);

	// If the player had a scope view up, make sure it's 
	// properly restore
//	RestoreScopeView();

	// make sure the mission script has been spawned correctly
	if (info != None)
	{
		bScriptRunning = False;
		foreach AllActors(class'MissionScript', scr)
			bScriptRunning = True;

		if (!bScriptRunning)
			info.SpawnScript();
	}

	// make sure the player's eye height is correct
	BaseEyeHeight = CollisionHeight - (GetDefaultCollisionHeight() - Default.BaseEyeHeight);

  belt[0]=FindInventoryType(Class'nanokeyringinv');

  bTPA_OnlyOnce = true;
 }
}

function UpdatePlayerSkin()
{
	local PaulDenton paul;
	local PaulDentonCarcass paulCarcass;
	local JCDentonMaleCarcass jcCarcass;
	local JCDouble jc;

	// Paul Denton
	foreach AllActors(class'PaulDenton', paul)
		break;

	if (paul != None)
		paul.SetSkin(Self);

	// Paul Denton Carcass
	foreach AllActors(class'PaulDentonCarcass', paulCarcass)
		break;

	if (paulCarcass != None)
		paulCarcass.SetSkin(Self);

	// JC Denton Carcass
	foreach AllActors(class'JCDentonMaleCarcass', jcCarcass)
		break;

	if (jcCarcass != None)
		jcCarcass.SetSkin(Self);

	// JC's stunt double
	foreach AllActors(class'JCDouble', jc)
		break;

	if (jc != None)
		jc.SetSkin(Self);
}

// ----------------------------------------------------------------------
// Landed()
//
// copied from Engine.PlayerPawn new landing code for Deus Ex
// zero damage if falling from 15 feet or less
// scaled damage from 15 to 60 feet
// death over 60 feet
// ----------------------------------------------------------------------
function Landed(vector HitNormal)
{
  local vector legLocation;
	local int augLevel;
	local float augReduce, dmg;

	//Note - physics changes type to PHYS_Walking by default for landed pawns
	PlayLanded(Velocity.Z);
	if (Velocity.Z < -1.4 * JumpZ)
	{
		MakeNoise(-0.5 * Velocity.Z/(FMax(JumpZ, 150.0)));
		if (Velocity.Z < -700) // && (ReducedDamageType != 'All'))
			if ( Role == ROLE_Authority )
      {
				// check our jump augmentation and reduce falling damage if we have it
				// jump augmentation doesn't exist anymore - use Speed instaed
				// reduce an absolute amount of damage instead of a relative amount
				augReduce = 0;
				if (AugmentationSystem != None)
				{
					augLevel = AugmentationSystem.GetClassLevel(class'AugSpeed');
					if (augLevel >= 0)
						augReduce = 15 * (augLevel+1);
				}

				dmg = Max((-0.16 * (Velocity.Z + 700)) - augReduce, 0);
				legLocation = Location + vect(-1,0,-1);			// damage left leg
				TakeDamage(dmg, None, legLocation, vect(0,0,0), class'fell');

				legLocation = Location + vect(1,0,-1);			// damage right leg
				TakeDamage(dmg, None, legLocation, vect(0,0,0), class'fell');

				dmg = Max((-0.06 * (Velocity.Z + 700)) - augReduce, 0);
				legLocation = Location + vect(0,0,1);			// damage torso
				TakeDamage(dmg, None, legLocation, vect(0,0,0), class'fell');
      }
	}
	else if ((Level.Game != None) && (Level.Game.GameDifficulty > 1) && (Velocity.Z > 0.5 * JumpZ))
		MakeNoise(0.1 * Level.Game.GameDifficulty);
    bJustLanded = true;

}


// ----------------------------------------------------------------------
// SpawnCarcass()
//
// copied from Engine.PlayerPawn
// modified to let carcasses have inventories
// ----------------------------------------------------------------------
function Carcass SpawnCarcass()
{
	local DeusExCarcass carc;
//	local Inventory item;
	local Vector loc;

	// don't spawn a carcass if we've been gibbed
	if (Health < -80)
		return None;

	carc = DeusExCarcass(Spawn(CarcassType));
	if (carc != None)
	{
		carc.Initfor(self);

		// move it down to the ground
		loc = Location;
		loc.z -= CollisionHeight;
		loc.z += carc.CollisionHeight;
		carc.SetLocation(loc);

		if (Controller != None)
			carc.bPlayerCarcass = true;
		SetMoveTarget(carc); //for Player 3rd person views

		// give the carcass the player's inventory
//		for (item=Inventory; item!=None; item=item.Inventory)
//		{
//			DeleteInventory(item);
//			carc.AddInventory(item);
//		}
	}

	return carc;
}

State Dying
{
	ignores all;

	function Fire(optional float F)
	{
	}

	// destroy our shadow
	function KillShadow()
	{
		if (Shadow != None)
			Shadow.Destroy();
	}

	function TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
	{
	}

	function BeginState()
	{
		local int i;

		log(self$" dying");
		SetPhysics(PHYS_Falling);
		bInvulnerableBody = true;
		if ( Controller != None )
		{
			if ( Controller.bIsPlayer )
				Controller.PawnDied(self);
		//	else
			//	Controller.Destroy();
		}

		for (i = 0; i < Attached.length; i++)
			if (Attached[i] != None)
				Attached[i].PawnBaseDied();
	}


Begin:
	FrobTime = Level.TimeSeconds;
	DeusExPlayerController(Controller).bBehindView = false;//True;
	Velocity = vect(0,0,0);
	Acceleration = vect(0,0,0);
	DeusExPlayerController(Controller).DesiredFOV = DeusExPlayerController(Controller).Default.DesiredFOV;
	FinishAnim();
	KillShadow();

	// hide us and spawn the carcass
	bHidden = True;
	SpawnCarcass();
}


// ----------------------------------------------------------------------
// SetBasedPawnSize()
// ----------------------------------------------------------------------

function bool SetBasedPawnSize(float newRadius, float newHeight)
{
/*	local float  oldRadius, oldHeight;
	local bool   bSuccess;
	local vector centerDelta, lookDir, upDir;
	local float  deltaEyeHeight;
	local Decoration savedDeco;

	if (newRadius < 0)
		newRadius = 0;
	if (newHeight < 0)
		newHeight = 0;

	oldRadius = DefaultPlayerRadius;
	oldHeight = DefaultPlayerHeight;

  if ((oldRadius == newRadius) && (oldHeight == newHeight))
			return true;

	centerDelta    = vect(0, 0, 1)*(newHeight-oldHeight);
	deltaEyeHeight = GetDefaultCollisionHeight() - Default.BaseEyeHeight;

	if (CarriedDecoration != None)
		savedDeco = CarriedDecoration;

	bSuccess = false;
	if ((newHeight <= DefaultPlayerHeight) && (newRadius <= DefaultPlayerHeight))  // shrink
	{
		SetDefaultCollisionSize(newRadius, newHeight);
		if (Move(centerDelta))
			bSuccess = true;
		else
			SetDefaultCollisionSize(oldRadius, oldHeight);
	}
	else
	{
		if (Move(centerDelta))
		{
			SetDefaultCollisionSize(newRadius, newHeight);
			bSuccess = true;
		}
	}

	if (bSuccess)
	{
		// make sure we don't lose our carried decoration
		if (savedDeco != None)
		{
			savedDeco.SetPhysics(PHYS_None);
			savedDeco.SetBase(Self);
			savedDeco.SetCollision(False, False, False);

			// reset the decoration's location
			lookDir = Vector(Rotation);
			lookDir.Z = 0;				
			upDir = vect(0,0,0);
			upDir.Z = CollisionHeight / 2;		// put it up near eye level
			savedDeco.SetLocation(Location + upDir + (0.5 * CollisionRadius + CarriedDecoration.CollisionRadius) * lookDir);
		}

//		PrePivotOffset  = vect(0, 0, 1)*(GetDefaultCollisionHeight()-newHeight);
		PrePivot        -= centerDelta;
//		DesiredPrePivot -= centerDelta;
		BaseEyeHeight   = newHeight - deltaEyeHeight;

		log(PrePivot);

			//EyeHeight		-= centerDelta.Z;
	}*/
	return true;//(bSuccess);
}

function bool ResetBasedPawnSize()
{
	return SetBasedPawnSize(DefaultPlayerRadius, GetDefaultCollisionHeight());
}

function float GetDefaultCollisionHeight()
{
	return (DefaultPlayerHeight);
}

event EndCrouch(float HeightAdjust)
{
//if (controller.bDuck != 1)
  SetDefaultCollisionSize(CrouchRadius, DefaultPlayerHeight);

  Super.EndCrouch(HeightAdjust);
}

event StartCrouch(float HeightAdjust)
{
  SetDefaultCollisionSize(CrouchRadius, CrouchHeight);

  Super.StartCrouch(HeightAdjust);
}


function float GetCurrentGroundSpeed()
{
	local float augValue, speed;

	augValue = AugmentationSystem.GetAugLevelValue(class'AugSpeed');
	if (augValue == -1.0)
		augValue = 1.0;

	speed = Default.GroundSpeed * augValue;

	return speed;
}

function ShouldCrouch(bool Crouch)
{
   bWantsToCrouch = (Crouch || bToggleCrouch);
} 

exec function ToggleCrouch()
{
  if (bUseToggleCrouch)
    bToggleCrouch = !bToggleCrouch;
}

function float GetCrouchHeight()
{
  return (Default.CollisionHeight*0.65);
}
/*
event Bump(Actor other)
{
  super.Bump(other);
}
  */


function bool DoJump(bool bUpdating)
{
	if ((CarriedDecoration != None) && (CarriedDecoration.Mass > 20))
		return false;
	else if (bForceDuck || IsLeaning())
		return false;

	if ((Physics == PHYS_Walking) || (Physics == PHYS_Ladder))
	{

	if (controller.bDuck == 1)
	  StartCrouch(16);

		if (fRand() > 0.65) // как в GMDX
			PlaySound(JumpSound, SLOT_None, 1.5, true, 1200, 1.0 - 0.2*FRand() );
		PlayInAir();

		Velocity.Z = JumpZ;

		// reduce the jump velocity if you are crouching
		if (bIsCrouched)
			Velocity.Z *= 0.9;

		if (Base != Level)
			Velocity.Z += Base.Velocity.Z;

		SetPhysics(PHYS_Falling);

		if (bCountJumps && (Role == ROLE_Authority))
			Inventory.OwnerEvent('Jumped');
	}
	return true;
}

function PlayInAir();

// ----------------------------------------------------------------------
// PlayPickupAnim()
// ----------------------------------------------------------------------
function PlayPickupAnim(Vector locPickup)
{
	if (Location.Z - locPickup.Z < 16)
		PlayAnim('PushButton',,0.1);
	else
		PlayAnim('Pickup',,0.1);
}

// ----------------------------------------------------------------------
// event HeadZoneChange
// ----------------------------------------------------------------------
event HeadVolumeChange(PhysicsVolume newHeadVolume)
{
	local float mult;

	if (Controller == None)
		return;
	if (HeadVolume.bWaterVolume)
	{
		if (!newHeadVolume.bWaterVolume)
		{
			if ( Controller.bIsPlayer && (BreathTime > 0) && (BreathTime < 8) )
				Gasp();
			BreathTime = -1.0;
		}
	}
	else if (newHeadVolume.bWaterVolume)
	{
		BreathTime = UnderWaterTime;
//		bIsCrouching = False;
		bCrouchOn = False;
		bWasCrouchOn = False;
		DeusExPlayerController(Controller).bDuck = 0;
		lastbDuck = 0;
		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);
		mult = SkillSystem.GetSkillLevelValue(class'SkillSwimming');
		swimDuration = UnderWaterTime * mult;
		swimTimer = swimDuration;
		WaterSpeed = Default.WaterSpeed * mult;
	}
}

/*event HeadZoneChange(ZoneInfo newHeadZone)
{
	if ( Level.NetMode == NM_Client )
		return;

	// hack to get the zone's ambientsound working until Tim fixes it
	if (newHeadZone.AmbientSound != None)
		newHeadZone.SoundRadius = 255;
	if (HeadRegion.Zone.AmbientSound != None)
		HeadRegion.Zone.SoundRadius = 0;

	if (newHeadZone.bWaterZone && !HeadRegion.Zone.bWaterZone)
	{
		// make sure we're not crouching when we start swimming
		bIsCrouching = False;
		bCrouchOn = False;
		bWasCrouchOn = False;
		bDuck = 0;
		lastbDuck = 0;
		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);
		mult = SkillSystem.GetSkillLevelValue(class'SkillSwimming');
		swimDuration = UnderWaterTime * mult;
		swimTimer = swimDuration;
		WaterSpeed = Default.WaterSpeed * mult;
	}

	Super.HeadZoneChange(newHeadZone);
}*/

// пригодится...
function bool TouchingWaterVolume()
{
	local PhysicsVolume V;

	ForEach TouchingActors(class'PhysicsVolume',V)
		if ( V.bWaterVolume )
			return true;

	return false;
}

// ----------------------------------------------------------------------
// SpawnBlood()
// ----------------------------------------------------------------------

function SpawnBlood(Vector HitLocation, float Damage)
{
	local int i;

	spawn(class'BloodSpurt',,,HitLocation);
	spawn(class'BloodDrop',,,HitLocation);
	for (i=0; i<int(Damage); i+=10)
		spawn(class'BloodDrop',,,HitLocation);
}

// ----------------------------------------------------------------------
// StopPoison()
// 
// Stop the pain
// ----------------------------------------------------------------------

function StopPoison()
{
	poisonCounter = 0;
	poisonTimer   = 0;
	poisonDamage  = 0;
}

// ----------------------------------------------------------------------
// UpdatePoison()
// 
// Get all woozy 'n' stuff
// ----------------------------------------------------------------------
function UpdatePoison(float deltaTime)
{
	if (Health <= 0)  // no more pain -- you're already dead!
		return;

	if (InConversation())  // kinda hacky...
		return;

	if (poisonCounter > 0)
	{
		poisonTimer += deltaTime;
		if (poisonTimer >= 2.0)  // pain every two seconds
		{
			poisonTimer = 0;
			poisonCounter--;
			TakeDamage(poisonDamage, None, Location, vect(0,0,0), class'DM_PoisonEffect');
		}
		if ((poisonCounter <= 0) || (Health <= 0))
			StopPoison();
	}
}

// ----------------------------------------------------------------------
// StartPoison()
// simulated function SetViewRotation(rotator NewRotation ) // это пригодится!
// Gakk!  We've been poisoned!
// ----------------------------------------------------------------------
exec function StartPoison(int Damage)
{
	if (Health <= 0)  // no more pain -- you're already dead!
		return;

	if (InConversation())  // kinda hacky...
		return;

	poisonCounter = 4;    // take damage no more than four times (over 8 seconds)
	poisonTimer   = 0;    // reset pain timer
	if (poisonDamage < Damage)  // set damage amount
		poisonDamage = Damage;
	drugEffectTimer += 4;  // make the player vomit for the next four seconds
}

// ----------------------------------------------------------------------
// Bleed()
// 
// Let the blood flow
// ----------------------------------------------------------------------
function Bleed(float deltaTime)
{
	local float  dropPeriod;
	local float  adjustedRate;
	local vector bloodVector;

	// Copied from ScriptedPawn::Tick()
	bleedRate = FClamp(bleedRate, 0.0, 1.0);
	if (bleedRate > 0)
	{
		adjustedRate = (1.0-bleedRate)*1.0+0.1;  // max 10 drops per second
		dropPeriod = adjustedRate / FClamp(VSize(Velocity)/512.0, 0.05, 1.0);
		dropCounter += deltaTime;
		while (dropCounter >= dropPeriod)
		{
			bloodVector = vect(0,0,1)*CollisionHeight*0.5;  // so folks don't bleed from the crotch
			spawn(Class'BloodDrop',,,bloodVector+Location);
			dropCounter -= dropPeriod;
		}
		bleedRate -= deltaTime/clotPeriod;
	}
	if (bleedRate <= 0)
	{
		dropCounter = 0;
		bleedRate   = 0;
	}
}


// ----------------------------------------------------------------------
// DrugEffects()
// ----------------------------------------------------------------------
function DrugEffects(float deltaTime)
{
	local float mult, fov;
	local Rotator rot;
	local HUD hud;

	hud = DeusExPlayerController(Controller).myHUD;

	// random wandering and swaying when drugged
	if (drugEffectTimer > 0)
	{
		if (hud != none)
		{
        DeusExHud(hud).bGrayPoison=true;
        DeusExHud(hud).bDoubledPoisonEffect=false;
/*        			if (drugEffectTimer > 10)
        				{
	        				DeusExHud(hud).bDoubledPoisonEffect=true;
	        			}*/
		}

		mult = FClamp(drugEffectTimer / 10.0, 0.0, 3.0);
		rot.Pitch = 1024.0 * Cos(Level.TimeSeconds * mult) * deltaTime * mult;
		rot.Yaw = 1024.0 * Sin(Level.TimeSeconds * mult) * deltaTime * mult;
		rot.Roll = 0;

		rot.Pitch = FClamp(rot.Pitch, -4096, 4096);
		rot.Yaw = FClamp(rot.Yaw, -4096, 4096);

		SetViewRotation(rot += GetViewRotation());

		fov = DeusExPlayerController(Controller).Default.DesiredFOV - drugEffectTimer + Rand(2);
		fov = FClamp(fov, 30, DeusExPlayerController(Controller).Default.DesiredFOV);
		DeusExPlayerController(Controller).DesiredFOV = fov;

		drugEffectTimer -= deltaTime;
		if (drugEffectTimer < 0)
			drugEffectTimer = 0;
	}
	else
	{
		if (hud != None)
		{
				DeusExHud(hud).bGrayPoison=false;
				DeusExHud(hud).bDoubledPoisonEffect=false;
//				DeusExPlayerController(Controller).DesiredFOV = DeusExPlayerController(Controller).Default.DesiredFOV;
		}
	}
}


function AddDamageDisplay(class<DamageType> DamageType, vector hitOffset)
{
	local HUD hud;

	hud = DeusExPlayerController(Controller).myHUD;

	if (hud != none)
	DeusExHud(hud).AddDamageIcon(damageType, hitOffset);
}


// ----------------------------------------------------------------------
// TakeDamage()
// ----------------------------------------------------------------------
function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	local int actualDamage;
	local bool /*bAlreadyDead,*/ bPlayAnim;
	local Vector offset;
	local float headOffsetZ, headOffsetY, armOffset;
	local float origHealth;
	local DeusExLevelInfo info;

	origHealth = Health;

	// use the hitlocation to determine where the pawn is hit
	// transform the worldspace hitlocation into objectspace
	// in objectspace, remember X is front to back
	// Y is side to side, and Z is top to bottom
	offset = (hitLocation - Location) << Rotation;

	// add a HUD icon for this damage type
	if ((damageType == class'DM_Poison') || (damageType == class'DM_PoisonEffect'))  // hack
		AddDamageDisplay(class'DM_PoisonGas', offset);
	else
		AddDamageDisplay(damageType, offset);

	// nanovirus damage doesn't affect us
	if (damageType == class'DM_NanoVirus')
		return;

	// handle poison
	if (damageType == class'DM_Poison')
		StartPoison(Damage);

	// reduce our damage correctly
	if (ReducedDamageType == damageType)
		actualDamage = float(actualDamage) * (1.0 - ReducedDamagePct);

	// check for augs or inventory items
	DXReduceDamage(Damage, damageType, hitLocation, actualDamage, False);

//	if (ReducedDamageType == 'All') //God mode
	if (inGodMode())
		actualDamage = 0;

	// EMP attacks drain BE energy
	if (damageType == class'DM_EMP')
	{
		EnergyDrain += actualDamage;
		EnergyDrainTotal += actualDamage;
		PlayTakeHitSound(actualDamage, damageType, 1);
		return;
	}

	bPlayAnim = True;

	// if we're burning, don't play a hit anim when taking burning damage
	if (damageType == class'DM_Burned')
		bPlayAnim = False;

	if (Physics == PHYS_None)
		SetMovementPhysics();
	if (Physics == PHYS_Walking)
		momentum.Z = 0.4 * VSize(momentum);
	if ( EventInstigator == self )
		momentum *= 0.6;
	momentum = momentum/Mass;

	// calculate our hit extents
	headOffsetZ = CollisionHeight * 0.8;
	headOffsetY = CollisionRadius * 0.3;
	armOffset = CollisionRadius * 0.35;

	if (offset.z > headOffsetZ)		// head
	{
		// narrow the head region
		if ((Abs(offset.x) < headOffsetY) || (Abs(offset.y) < headOffsetY))
		{
			HealthHead -= actualDamage * 2;
			if (bPlayAnim)
				PlayAnim('HitHead', , 0.1);
		}
	}
	else if (offset.z < 0.0)	// legs
	{
		if (offset.y > 0.0)
		{
			HealthLegRight -= actualDamage;
			if (bPlayAnim)
				PlayAnim('HitLegRight', , 0.1);
		}
		else
		{
			HealthLegLeft -= actualDamage;
			if (bPlayAnim)
				PlayAnim('HitLegLeft', , 0.1);
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
			HealthArmRight -= actualDamage;
			if (bPlayAnim)
				PlayAnim('HitArmRight', , 0.1);
		}
		else if (offset.y < -armOffset)
		{
			HealthArmLeft -= actualDamage;
			if (bPlayAnim)
				PlayAnim('HitArmLeft', , 0.1);
		}
		else
		{
			HealthTorso -= actualDamage * 2;
			if (bPlayAnim)
				PlayAnim('HitTorso', , 0.1);
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

	// check for a back hit and play the correct anim
	if ((offset.x < 0.0) && bPlayAnim)
	{
		if (offset.z > headOffsetZ)		// head from the back
		{
			// narrow the head region
			if ((Abs(offset.x) < headOffsetY) || (Abs(offset.y) < headOffsetY))
				PlayAnim('HitHeadBack', , 0.1);
		}
		else
			PlayAnim('HitTorsoBack', , 0.1);
	}

	// check for a water hit
	if (PhysicsVolume.bWaterVolume) //(Region.Zone.bWaterZone)
	{
		if ((offset.x < 0.0) && bPlayAnim)
			PlayAnim('WaterHitTorsoBack',,0.1);
		else
			PlayAnim('WaterHitTorso',,0.1);
	}

	GenerateTotalHealth();

	if ((damageType != class'DM_Stunned') && (damageType != class'DM_TearGas') && (damageType != class'DM_HalonGas') &&
	    (damageType != class'DM_PoisonGas') && (damageType != class'DM_Radiation') && (damageType != class'DM_EMP') &&
	    (damageType != class'DM_NanoVirus') && (damageType != class'Drowned') && (damageType != class'DM_KnockedOut'))
		bleedRate += (origHealth-Health)/30.0;  // 30 points of damage = bleed profusely

	if (CarriedDecoration != None)
		DropDecoration();

	// don't let the player die in the training mission
	info = DeusExPlayerController(controller).GetLevelInfo();
	if ((info != None) && (info.MissionNumber == 0))
	{
		if (Health <= 0)
		{
			HealthTorso = FMax(HealthTorso, 10);
			HealthHead = FMax(HealthHead, 10);
			GenerateTotalHealth();
		}
	}

	if (Health > 0)
	{
		if (EventInstigator != None)
			DeusExPlayerController(controller).damageAttitudeTo(EventInstigator, damage);
		PlayHit(Damage, EventInstigator, hitLocation, damageType, momentum);
		class'EventManager'.static.AISendEvent(self, 'Distress', EAITYPE_Visual);
	}
	else
	{
		NextState = '';
		PlayDeathHit(actualDamage, hitLocation, damageType, momentum);
		if ( actualDamage > mass )
			Health = -1 * actualDamage;
		DeusExPlayerController(controller).Enemy = EventInstigator;
//function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
// Какой контроллер вызвал смерть, это должен быть контроллер ИИ, но можно указать None
		Died(None, damageType, HitLocation);
		bHidden=true;
		GoToState('Dying');
//		Died( None, class'DamTypeMutant', Location);
		return;
	}
	MakeNoise(1.0); 

	if ((DamageType == class'DM_Flamed') && !bOnFire)
		CatchFire();
}

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
// CatchFire()
// ----------------------------------------------------------------------
function CatchFire()
{
	local Fire f;
	local int i;
	local vector loc;

	if (bOnFire || PhysicsVolume.bWaterVolume)
		return;

	bOnFire = True;
	burnTimer = 0;

	for (i=0; i<maxAmountOfFire; i++)
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
				f.smokeGen.kill(); //Destroy();
			if (FRand() < 0.5)
				f.AddFire();
		}
	}

	// set the burn timer
	SetTimer(1.0, True);
}

// ----------------------------------------------------------------------
// Timer()
//
// continually burn and do damage
// ----------------------------------------------------------------------

function Timer()
{
	if (!InConversation() && bOnFire)
	{
		TakeDamage(fireDamage, None, Location, vect(0,0,0), class'DM_Burned');

		if (HealthTorso <= 0)
		{
			TakeDamage(10, None, Location, vect(0,0,0), class'DM_Burned');
			ExtinguishFire();
		}
	}
}



//----------------------
// АЙ! ОЙ!

function PlayTakeHitSound(int Damage, class<damageType> damageType, int Mult);
/*{
	local float rnd;

	if ( Level.TimeSeconds - LastPainSound < FRand() + 0.5)
		return;

	LastPainSound = Level.TimeSeconds;

	if (PhysicsVolume.bWaterVolume) 
	{
		if (damageType == class'Drowned')
		{
			if (FRand() < 0.8)
				self.PlaySound(sound'MaleDrown', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
		}
		else
			self.PlaySound(sound'MalePainSmall', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
	}
	else
	{
		if ((damageType == class'DM_TearGas') || (damageType == class'DM_HalonGas'))
			self.PlaySound(sound'MaleEyePain', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
		else if (damageType == class'DM_PoisonGas')
			self.PlaySound(sound'MaleCough', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
		else
		{
			rnd = FRand();
			if (rnd < 0.33)
				self.PlaySound(sound'MalePainSmall', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
			else if (rnd < 0.66)
				self.PlaySound(sound'MalePainMedium', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
			else
				self.PlaySound(sound'MalePainLarge', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
		}
		class'EventManager'.static.AISendEvent(self, 'LoudNoise', EAITYPE_Audio, FMax(Mult * TransientSoundVolume, Mult * 2.0));
	}
}*/

function RestoreAllHealth()
{
	HealthHead = default.HealthHead;
	HealthTorso = default.HealthTorso;
	HealthLegLeft = default.HealthLegLeft;
	HealthLegRight = default.HealthLegRight;
	HealthArmLeft = default.HealthArmLeft;
	HealthArmRight = default.HealthArmRight;
	Health = default.Health;
}

// ----------------------------------------------------------------------
// DXReduceDamage()
//
// Calculates reduced damage from augmentations and from inventory items
// Also calculates a scalar damage reduction based on the mission number
// ----------------------------------------------------------------------
//function bool DXReduceDamage(int Damage, name damageType, vector hitLocation, out int adjustedDamage, bool bCheckOnly)
function bool DXReduceDamage(int Damage, class<DamageType> DamageType, vector hitLocation, out int adjustedDamage, bool bCheckOnly)
{
	local float newDamage;
	local float augLevel, skillLevel;
	local float pct;
	local HazMatSuitInv suit;
	local BallisticArmorInv armor;
	local bool bReduced;

	bReduced = False;
	newDamage = Float(Damage);

	if ((damageType == class'DM_TearGas') || (damageType == class'DM_PoisonGas') || (damageType == class'DM_Radiation') ||
		(damageType == class'DM_HalonGas')  || (damageType == class'DM_PoisonEffect') || (damageType == class'DM_Poison'))
	{
		if (AugmentationSystem != None)
			augLevel = AugmentationSystem.GetAugLevelValue(class'AugEnviro');

		if (augLevel >= 0.0)
			newDamage *= augLevel;

		// get rid of poison if we're maxed out
		if (newDamage ~= 0.0)
		{
			StopPoison();
			drugEffectTimer -= 4;	// stop the drunk effect
			if (drugEffectTimer < 0)
				drugEffectTimer = 0;
		}

		// go through the actor list looking for owned HazMatSuits
		// since they aren't in the inventory anymore after they are used
		foreach AllActors(class'HazMatSuitInv', suit)
			if ((suit.Owner == Self) && suit.bActive)
			{
				skillLevel = SkillSystem.GetSkillLevelValue(class'SkillEnviro');
				newDamage *= 0.75 * skillLevel;
			}
	}

	if ((damageType == class'DM_Shot') || (damageType == class'DM_Sabot') || (damageType == class'DM_Exploded'))
	{
		// go through the actor list looking for owned BallisticArmor
		// since they aren't in the inventory anymore after they are used
		foreach AllActors(class'BallisticArmorInv', armor)
			if ((armor.Owner == Self) && armor.bActive)
			{
				skillLevel = SkillSystem.GetSkillLevelValue(class'SkillEnviro');
				newDamage *= 0.5 * skillLevel;
			}
	}

	if (damageType == class'DM_HalonGas')
	{
		if (bOnFire && !bCheckOnly)
			ExtinguishFire();
	}

	if (damageType == class'DM_Shot')
	{
		if (AugmentationSystem != None)
			augLevel = AugmentationSystem.GetAugLevelValue(class'AugBallistic');

		if (augLevel >= 0.0)
			newDamage *= augLevel;
	}

	if (damageType == class'DM_EMP')
	{
		if (AugmentationSystem != None)
			augLevel = AugmentationSystem.GetAugLevelValue(class'AugEMP');

		if (augLevel >= 0.0)
			newDamage *= augLevel;
	}

	if ((damageType == class'DM_Burned') || (damageType == class'DM_Flamed') ||
		(damageType == class'DM_Exploded') || (damageType == class'DM_Shocked'))
	{
		if (AugmentationSystem != None)
			augLevel = AugmentationSystem.GetAugLevelValue(class'AugShield');

		if (augLevel >= 0.0)
			newDamage *= augLevel;
	}

	if (newDamage < Damage)
	{
		if (!bCheckOnly)
		{
			pct = 1.0 - (newDamage / Float(Damage));
			SetDamagePercent(pct);
			DeusExPlayerController(controller).ClientFlash(0.01, vect(0, 0, 50));
		}
		bReduced = True;
	}
	else
	{
		if (!bCheckOnly)
			SetDamagePercent(0.0);
	}


	//
	// Reduce or increase the damage based on the combat difficulty setting
	// 
	if (damageType == class'DM_Shot')
	{
		newDamage *= CombatDifficulty;

		// always take at least one point of damage
		if ((newDamage <= 1) && (Damage > 0))
			newDamage = 1;
	}

	adjustedDamage = Int(newDamage);

	return bReduced;
}

// ----------------------------------------------------------------------
// PlayHit()
// ----------------------------------------------------------------------
//function PlayHit(float Damage, vector HitLocation, class damageType, vector Momentum)
function PlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> damageType, vector Momentum)
{
	local float rnd;
	local int actualDamage;

	if ((Damage > 0) && (damageType == class'DM_Shot') || (damageType == class'DM_Exploded'))
		SpawnBlood(HitLocation, Damage);

	PlayTakeHitSound(Damage, damageType, 1);

	// if we actually took the full damage, flash the screen and play the sound
	if (!DXReduceDamage(Damage, damageType, HitLocation, actualDamage, True))
	{
		if /*(*/ (damage > 0) //|| (!Controller.bGodMode) )
		{
			rnd = FClamp(Damage, 20, 100);
			if (damageType == class'DM_Burned')
				DeusExPlayerController(controller).ClientFlash(rnd * 0.002, vect(200,100,100));
			else if (damageType == class'DM_Flamed')
				DeusExPlayerController(controller).ClientFlash(rnd * 0.002, vect(200,100,100));
			else if (damageType == class'DM_Radiation')
				DeusExPlayerController(controller).ClientFlash(rnd * 0.002, vect(100,100,0));
			else if (damageType == class'DM_PoisonGas')
				DeusExPlayerController(controller).ClientFlash(rnd * 0.002, vect(50,150,0));
			else if (damageType == class'DM_TearGas')
				DeusExPlayerController(controller).ClientFlash(rnd * 0.002, vect(150,150,0));
			else if (damageType == class'Drowned')
				DeusExPlayerController(controller).ClientFlash(rnd * 0.002, vect(0,100,200));
			else if (damageType == class'DM_EMP')
				DeusExPlayerController(controller).ClientFlash(rnd * 0.002, vect(0,200,200));
			else 
				DeusExPlayerController(controller).ClientFlash(rnd * 0.002, vect(50,0,0));

//			DeusExPlayerController(controller).DamageShake(damage * 10);
		}
	}
}

// ----------------------------------------------------------------------
// PlayDeathHit()
// ----------------------------------------------------------------------

function PlayDeathHit(float Damage, vector HitLocation, class<DamageType> DamageType, vector Momentum)
{
	PlayDying(damageType, HitLocation);
}

// ----------------------------------------------------------------------
// SetDamagePercent()
//
// Set the percentage amount of damage that's being absorbed
// ----------------------------------------------------------------------

function SetDamagePercent(float percent)
{
	local HUD hud;
	// Указатель на ГДИ
	hud = DeusExPlayerController(Controller).myHUD;
	DeusExHUD(hud).SetPercent(percent);
}

// ----------------------------------------------------------------------
// ExtinguishFire()
// ----------------------------------------------------------------------

function ExtinguishFire()
{
	local Fire f;

	foreach BasedActors(class'Fire', f)
		{
			if (f != none)
			{
			  f.Destroy();
      }
		}

	bOnFire = False;
	burnTimer = 0;
	SetTimer(0, False);

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
	local float ave, avecrit;

	ave = (HealthLegLeft + HealthLegRight + HealthArmLeft + HealthArmRight) / 4.0;

	if ((HealthHead <= 0) || (HealthTorso <= 0))
		avecrit = 0;
	else
		avecrit = (HealthHead + HealthTorso) / 2.0;

	if (avecrit == 0)
		Health = 0;
	else
		Health = (ave + avecrit) / 2.0;
}


// ----------------------------------------------------------------------
// AddAugmentationDisplay()
// ----------------------------------------------------------------------
function AddAugmentationDisplay(Augmentation aug)
{
	ClientMessage(aug);
}

// ----------------------------------------------------------------------
// RemoveAugmentationDisplay()
// ----------------------------------------------------------------------

function RemoveAugmentationDisplay(Augmentation aug)
{
	ClientMessage(aug);
}

// ----------------------------------------------------------------------
// ClearAugmentationDisplay()
// ----------------------------------------------------------------------

function ClearAugmentationDisplay()
{
	ClientMessage("ClearAugmentationDisplay()");
}

// ----------------------------------------------------------------------
// UpdateAugmentationDisplayStatus()
// ----------------------------------------------------------------------

function UpdateAugmentationDisplayStatus(Augmentation aug)
{
	ClientMessage(aug);
}

// ----------------------------------------------------------------------
// ActivateAugmentation()
// ----------------------------------------------------------------------

exec function ActivateAugmentation(int num)
{
//	local Augmentation anAug;
//	local int count, wantedSlot, slotIndex;
//	local bool bFound;

	if (DeusExPlayerController(Controller).RestrictInput())
		return;

	if (Energy == 0)
	{
		ClientMessage(EnergyDepleted);
		PlaySound(AugmentationSystem.FirstAug.DeactivateSound, SLOT_None);
		return;
	}

	if (AugmentationSystem != None)
		AugmentationSystem.ActivateAugByKey(num);
}


// ----------------------------------------------------------------------
// AugAdd()
//
// Augmentation system functions
// exec functions for command line for demo
// ----------------------------------------------------------------------

exec function AugAdd(class<Augmentation> aWantedAug)
{
	local Augmentation anAug;

	if (!DeusExPlayerController(Controller).bCheatsEnabled)
		return;

	if (AugmentationSystem != None)
	{
		anAug = AugmentationSystem.GivePlayerAugmentation(aWantedAug);

		if (anAug == None)
			ClientMessage(GetItemName(String(aWantedAug)) $ " is not a valid augmentation!");
	}
}

// ----------------------------------------------------------------------
// JoltView()
// ----------------------------------------------------------------------

event JoltView(float newJoltMagnitude)
{
	if (Abs(JoltMagnitude) < Abs(newJoltMagnitude))
		JoltMagnitude = newJoltMagnitude;
}

// ----------------------------------------------------------------------
// UpdateEyeHeight()
// ----------------------------------------------------------------------

event UpdateEyeHeight(float DeltaTime)
{
	Super.UpdateEyeHeight(DeltaTime);

	if (JoltMagnitude != 0)
	{
		if ((Physics == PHYS_Walking) && (Bob != 0))
			EyeHeight += (JoltMagnitude * 5);
		JoltMagnitude = 0;
	}
}

// ----------------------------------------------------------------------
// MaintainEnergy()
// ----------------------------------------------------------------------

function MaintainEnergy(float deltaTime)
{
	local Float energyUse;

	// make sure we can't continue to go negative if we take damage
	// after we're already out of energy
	if (Energy <= 0)
	{
		Energy = 0;
		EnergyDrain = 0;
		EnergyDrainTotal = 0;
	}

	// Don't waste time doing this if the player is dead or paralyzed
	if ((!IsInState('Dying')) && (!IsInState('Paralyzed')) && (Energy > 0))
	{
		// Decrement energy used for augmentations
		energyUse = AugmentationSystem.CalcEnergyUse(deltaTime);
		
		Energy -= EnergyUse;

		// Calculate the energy drain due to EMP attacks
		if (EnergyDrain > 0)
		{
			energyUse = EnergyDrainTotal * deltaTime;
			Energy -= EnergyUse;
			EnergyDrain -= EnergyUse;
			if (EnergyDrain <= 0)
			{
				EnergyDrain = 0;
				EnergyDrainTotal = 0;
			}
		}

		// If the player's energy drops to zero, deactivate 
		// all augmentations
		if (Energy <= 0)
		{
			ClientMessage(EnergyDepleted);
			Energy = 0;
			EnergyDrain = 0;
			EnergyDrainTotal = 0;
			AugmentationSystem.DeactivateAll();
		}
	}
}

// ----------------------------------------------------------------------
// HealPart()
// ----------------------------------------------------------------------

function HealPart(out int points, out int amt)
{
	local int spill;

	points += amt;
	spill = points - 100;
	if (spill > 0)
		points = 100;
	else
		spill = 0;

	amt = spill;
}

// ----------------------------------------------------------------------
// CalculateSkillHealAmount()
// ----------------------------------------------------------------------

function int CalculateSkillHealAmount(int baseHealPoints)
{
	local float mult;
	local int adjustedHealAmount;

	// check skill use
	if (SkillSystem != None)
	{
		mult = SkillSystem.GetSkillLevelValue(class'SkillMedicine');

		// apply the skill
		adjustedHealAmount = baseHealPoints * mult;
	}

	return adjustedHealAmount;
}


// ----------------------------------------------------------------------
// HealPlayer()
// ----------------------------------------------------------------------
function int HealPlayer(int baseHealPoints, optional Bool bUseMedicineSkill)
{
//	local float mult;
	local int adjustedHealAmount;
	local int origHealAmount;

	if (bUseMedicineSkill)
		adjustedHealAmount = CalculateSkillHealAmount(baseHealPoints);
	else
		adjustedHealAmount = baseHealPoints;

	origHealAmount = adjustedHealAmount;

	if (adjustedHealAmount > 0)
	{
		if (bUseMedicineSkill)
			PlaySound(sound'MedicalHiss', SLOT_None,,, 256);

		HealPart(HealthHead, adjustedHealAmount);
		HealPart(HealthTorso, adjustedHealAmount);
		HealPart(HealthLegRight, adjustedHealAmount);
		HealPart(HealthLegLeft, adjustedHealAmount);
		HealPart(HealthArmRight, adjustedHealAmount);
		HealPart(HealthArmLeft, adjustedHealAmount);

		GenerateTotalHealth();

		adjustedHealAmount = origHealAmount - adjustedHealAmount;

		if (origHealAmount == baseHealPoints)
		{
			if (adjustedHealAmount == 1)
				ClientMessage(Sprintf(HealedPointLabel, adjustedHealAmount));
			else
				ClientMessage(Sprintf(HealedPointsLabel, adjustedHealAmount));
		}
		else
		{
			ClientMessage(Sprintf(HealedPointsLabel, adjustedHealAmount));
		}
	}
	return adjustedHealAmount;
}



// ----------------------------------------------------------------------
// ChargePlayer()
// ----------------------------------------------------------------------

function int ChargePlayer(int baseChargePoints)
{
	local int chargedPoints;

	chargedPoints = Min(EnergyMax - Int(Energy), baseChargePoints);

	Energy += chargedPoints;

	return chargedPoints;	
}

// ----------------------------------------------------------------------
// GrabDecoration()
//
// This overrides GrabDecoration() in Pawn.uc
// lets the strength augmentation affect how much the player can lift
// ----------------------------------------------------------------------
function GrabDecoration()
{
	// can't grab decorations while leaning
	if (IsLeaning())
		return;
	if (Controller.IsInState('PlayerSwimming'))
		return;

	// can't grab decorations while holding something else
	if (inHand != None)
	{
		ClientMessage(HandsFull);
		return;
	}

	if (carriedDecoration == None)
		if ((FrobTarget != None) && FrobTarget.IsA('DeusExDecoration') && (Weapon == None))
			if (CanBeLifted(DeusExDecoration(FrobTarget)))
			{
				CarriedDecoration = DeusExDecoration(FrobTarget);
				PutCarriedDecorationInHand();
			}
}

// ----------------------------------------------------------------------
// PutCarriedDecorationInHand()
// ----------------------------------------------------------------------
function PutCarriedDecorationInHand()
{
	local vector lookDir, upDir;

	if (CarriedDecoration != None)
	{
		lookDir = Vector(Rotation);
		lookDir.Z = 0;				
		upDir = vect(0,0,0);
		upDir.Z = CollisionHeight / 2;		// put it up near eye level
		CarriedDecoration.SetPhysics(PHYS_Falling);
		  
		if ( CarriedDecoration.SetLocation(Location + upDir + (0.5 * CollisionRadius + CarriedDecoration.CollisionRadius) * lookDir) )
		{
      CarriedDecoration.bHardAttach = true;

			CarriedDecoration.SetPhysics(PHYS_None);
			CarriedDecoration.SetBase(self);
			CarriedDecoration.SetCollision(False, False, False);
			CarriedDecoration.bCollideWorld = False;

			// make it translucent
			// Похоже придется добавлять прозрачные текстуры, добавление оверлея дает неожиданный эффект: весь уровень просвечивает!
			CarriedDecoration.Style = STY_Translucent;
			CarriedDecoration.ScaleGlow = 1.0;
			CarriedDecoration.bUnlit = True;

			FrobTarget = None;
		}
		else
		{
			ClientMessage(NoRoomToLift);
			CarriedDecoration = None;
		}
	}
}

function RepairInventory()
{
	local byte				LocalInvSlots[30];		// 5x6 grid of inventory slots
	local int i;
	local int slotsCol;
	local int slotsRow;
	local Inventory curInv;

//	if ((Level.NetMode != NM_Standalone) && (bBeltIsMPInventory))
//	  return;

	//clean out our temp inventory.
	for (i = 0; i < 30; i++)
	  LocalInvSlots[i] = 0;

	// go through our inventory and fill localinvslots
	if (Inventory != None)
	{
	  for (curInv = Inventory; curInv != None; curInv = curInv.Inventory)
	  {
		 // Make sure this item is located in a valid position
		 if (( curInv.GetinvPosX() != -1 ) && (curInv.GetinvPosY() != -1 ))
		 {
			// fill inventory slots
			for( slotsRow=0; slotsRow < curInv.GetinvSlotsY(); slotsRow++ )
			   for (slotsCol=0; slotsCol < curInv.GetinvSlotsX(); slotsCol++)
				  LocalInvSlots[((slotsRow + curInv.GetinvPosY()) * maxInvCols) + (slotscol + curInv.GetinvPosX())] = 1;
		 }
	  }
	}

	// verify that the 2 inventory grids match
	for (i = 0; i < 30; i++)
	  if (LocalInvSlots[i] < invSlots[i]) //don't stuff slots, that can get handled elsewhere, just clear ones that need it
	  {
		 log("ERROR!!! Slot "$i$" should be "$LocalInvSlots[i]$", but isn't!!!!, repairing");
		 invSlots[i] = LocalInvSlots[i];
	  }

}


exec function NextBeltItem()
{
	local int slot, startSlot;

//	if (RestrictInput())
//		return;

	if (CarriedDecoration == None)
	{
		slot = 0;

			if (inHandPending != None)
				slot = inHandPending.GetbeltPos();
			else if (inHand != None)
				slot = inHand.GetbeltPos();

			startSlot = slot;
			do
			{
				if (++slot >= 10)
					slot = 0;
			}
			until (ActivateObjectInBelt(slot) || (startSlot == slot));
		}
}

exec function PrevBeltItem()
{
	local int slot, startSlot;

//	if (RestrictInput())
//		return;

	if (CarriedDecoration == None)
	{
		slot = 1;

			if (inHandPending != None)
				slot = inHandPending.GetbeltPos();
			else if (inHand != None)
				slot = inHand.GetbeltPos();

			startSlot = slot;
			do
			{
				if (--slot <= -1)
					slot = 9;
			}
			until (ActivateObjectInBelt(slot) || (startSlot == slot));
	}
}

function bool ActivateObjectInBelt(int pos)
{
	local Inventory item;
	local bool retval;

	retval = False;

			item = belt[pos];
				// if the object is an ammo box, load the correct ammo into
				// the gun if it is the current weapon
/*				if ((item != None) && item.IsA('Ammo') && (Weapon != None))
					DeusExWeaponInv(Weapon).LoadAmmoType(Ammo(item));
				else
				{*/
					PutInHand(item);
					if (item != None)
					{
						currentBeltNum=item.GetbeltPos();
						log("currentBeltNum="$currentBeltNum);
						retval = True;
					}
				//}

	return retval;
}



// ----------------------------------------------------------------------
// PutInHand()
//
// put the object in the player's hand and draw it in front of the player
// ----------------------------------------------------------------------
exec function PutInHand(optional Inventory inv)
{
	if (DeusExPlayerController(Controller).RestrictInput())
		return;

	// can't put anything in hand if you're using a spy drone
	if ((inHand == None) && DeusExHud(DeusExPlayerController(Level.GetLocalPlayerController()).myHUD).bSpyDroneActive)
		return;

	// can't do anything if you're carrying a corpse
	if ((inHand != None) && inHand.IsA('POVCorpse'))
		return;

	if (inv != None)
	{
		// can't put ammo in hand
		if (inv.IsA('Ammunition'))
			return;

		// Can't put an active charged item in hand
//		if ((inv.IsA('ChargedPickup')) && (ChargedPickup(inv).IsActive()))DeusExPowerups
		if ((inv.IsA('DeusExPickupInv')) && (DeusExPickupInv(inv).IsActive()))
			return;
	}

	// Vanilla Matters: If putting None in hand then saves the previous inHand item.
	else if ( inHand != None )
		VM_lastInHand = inHand;

	if (CarriedDecoration != None)
		DropDecoration();

	SetInHandPending(inv);
}

function SetInHandPending(Inventory newInHandPending)
{
	inHandPending = newInHandPending;
}

// ----------------------------------------------------------------------
// Called every frame
// Checks the state of inHandPending and deals with animation and crap
// 1. Check for pending item
// 2. Play down anim (and deactivate) for inHand and wait for it to finish
// 3. Assign inHandPending to inHand (and SelectedItem)
// 4. Play up anim for inHand
// ----------------------------------------------------------------------
function UpdateInHand()
{
	local bool bSwitch;

	if (inHand != inHandPending)
	{
		bInHandTransition = True;
		bSwitch = False;
		if (inHand != None)
		{
			// turn it off if it is on
			if (Powerups(InHand).bActive)
				Powerups(InHand).Activate();

			if (inHand.IsA('SkilledToolInv'))
			{
				if (inHand.IsInState('Idle'))
					SkilledToolInv(inHand).PutDown();
				else if (inHand.IsInState('Idle2'))
					bSwitch = True;
			}
			else if (inHand.IsA('DeusExWeaponInv'))
			{
				if (inHand.IsInState('Idle') || inHand.IsInState('Reloading'))
				{
					DeusExWeaponInv(inHand).PutDown();
				}
				else if ((inHand.IsInState('DownWeapon') && (Weapon == None)))
					bSwitch = True;
			}
			else
			{
				bSwitch = True;
			}
		}
		else
		{
			bSwitch = True;
		}

		// OK to actually switch?
		if (bSwitch)
		{
			SetInHand(inHandPending);
			SelectedItem = DeusExPickupInv(inHandPending);//

			if (inHand != None)
			{
				if (inHand.IsA('SkilledToolInv'))
					SkilledToolInv(inHand).BringUp();
				else if (inHand.IsA('DeusExWeaponInv'))
					SwitchWeapon(DeusExWeaponInv(inHand).InventoryGroup);
			}
		}
	}
	else
	{
		bInHandTransition = False;

		// Added this code because it's now possible to reselect an in-hand
		// item while we're putting it down, so we need to bring it back up...

		if (inHand != None)
		{
			// if we put the item away, bring it back up
			if (inHand.IsA('SkilledToolInv'))
			{
				if (inHand.IsInState('Idle2'))
					SkilledToolInv(inHand).BringUp();
			}
			else if (inHand.IsA('DeusExWeaponInv'))
			{
				if (inHand.IsInState('DownWeapon') && (Weapon == None))
					SwitchWeapon(DeusExWeaponInv(inHand).InventoryGroup);
			}
		}
	}
	UpdateCarcassEvent();
}




// ----------------------------------------------------------------------
// MakePlayerIgnored()
// ----------------------------------------------------------------------
function MakePlayerIgnored(bool bNewIgnore)
{
	bIgnore = bNewIgnore;
	// to restore original behavior, uncomment the next line
	//bDetectable = !bNewIgnore;
}


// ----------------------------------------------------------------------
// CalculatePlayerVisibility()
// ----------------------------------------------------------------------
function float CalculatePlayerVisibility(ScriptedPawn P)
{
	local float vis;

	vis = 1.0;
	if ((P != None) && (AugmentationSystem != None))
	{
		if (P.IsA('Robot'))
		{
			// if the aug is on, give the player full invisibility
			if (AugmentationSystem.GetAugLevelValue(class'AugRadarTrans') != -1.0)
				vis = 0.0;
		}
		else
		{
			// if the aug is on, give the player full invisibility
			if (AugmentationSystem.GetAugLevelValue(class'AugCloak') != -1.0)
				vis = 0.0;
		}
		// go through the actor list looking for owned AdaptiveArmor
		// since they aren't in the inventory anymore after they are used
      if (UsingChargedPickup(class'AdaptiveArmorInv'))
			{
				vis = 0.0;
			}
	}
	return vis;
}


// ----------------------------------------------------------------------
// UpdateCarcassEvent()
// Small hack for sending carcass events
// ----------------------------------------------------------------------
function UpdateCarcassEvent()
{
	if ((inHand != None) && (inHand.IsA('POVCorpse')))
		class'EventManager'.static.AIStartEvent(self,'Carcass', EAITYPE_Visual);
	else
		class'EventManager'.static.AIEndEvent(self,'Carcass', EAITYPE_Visual);
}

// ----------------------------------------------------------------------
// SetInHand()
// ----------------------------------------------------------------------

function SetInHand(Inventory newInHand)
{
	inHand = newInHand;

	// Notify the hud
	// HUD постоянно обновляется, принудительно обновлять не нужно.
//		ClientMessage("SetInHand="$newInHand);
}


// ----------------------------------------------------------------------
// lets the player throw a decoration instead of just dropping it
// ----------------------------------------------------------------------

exec function DropDecoration()
{
	local Vector X, Y, Z, dropVect, origLoc, HitLocation, HitNormal, extent;
	local float velscale, size, mult;
	local bool bSuccess;
	local Actor hitActor;

	bSuccess = False;

	if (CarriedDecoration != None)
	{
		origLoc = CarriedDecoration.Location;
		GetAxes(Rotation, X, Y, Z);

		// if we are highlighting something, try to place the object on the target
		if ((FrobTarget != None) && !FrobTarget.IsA('Pawn'))
		{
			CarriedDecoration.Velocity = vect(0,0,0);

			// try to drop the object about one foot above the target
			size = FrobTarget.CollisionRadius - CarriedDecoration.CollisionRadius * 2;
			dropVect.X = size/2 - FRand() * size;
			dropVect.Y = size/2 - FRand() * size;
			dropVect.Z = FrobTarget.CollisionHeight + CarriedDecoration.CollisionHeight + 16;
			dropVect += FrobTarget.Location;
		}
		else
		{
			// throw velocity is based on augmentation
			if (AugmentationSystem != None)
			{
				mult = AugmentationSystem.GetAugLevelValue(class'AugMuscle');
				if (mult == -1.0)
					mult = 1.0;
			}

			if (IsLeaning())
				CarriedDecoration.Velocity = vect(0,0,0);
			else
				CarriedDecoration.Velocity = Vector(GetViewRotation()) * mult * 500 + vect(0,0,220) + 40 * VRand();

			// scale it based on the mass
			velscale = FClamp(CarriedDecoration.Mass / 20.0, 1.0, 40.0);

			CarriedDecoration.Velocity /= velscale;
			dropVect = Location + (CarriedDecoration.CollisionRadius + CollisionRadius + 4) * X;
			dropVect.Z += BaseEyeHeight;
		}

		// is anything blocking the drop point? (like thin doors)
		if (FastTrace(dropVect))
		{
			CarriedDecoration.SetCollision(True, True, True);
			CarriedDecoration.bCollideWorld = True;

			// check to see if there's space there
			extent.X = CarriedDecoration.CollisionRadius;
			extent.Y = CarriedDecoration.CollisionRadius;
			extent.Z = 1;
			hitActor = Trace(HitLocation, HitNormal, dropVect, CarriedDecoration.Location, True, extent);

			if ((hitActor == None) && CarriedDecoration.SetLocation(dropVect))
				bSuccess = True;
			else
			{
				CarriedDecoration.SetCollision(False, False, False);
				CarriedDecoration.bCollideWorld = False;
			}
		}

		// if we can drop it here, then drop it
		if (bSuccess)
		{
			CarriedDecoration.bWasCarried = True;
			CarriedDecoration.SetBase(None);
			CarriedDecoration.SetPhysics(PHYS_Falling);
			CarriedDecoration.Instigator = Self;
			CarriedDecoration.bHardAttach = false;//

			// turn off translucency
			CarriedDecoration.Style = CarriedDecoration.Default.Style;
			CarriedDecoration.bUnlit = CarriedDecoration.Default.bUnlit;
//      CarriedDecoration.OverlayMaterial=none; //shader'DeusExStaticMeshes.Glass.GlassSH1';
//      CarriedDecoration.OverlayTimer=0.1;
      CarriedDecoration.ResetScaleGlow();

			CarriedDecoration = None;
		}
		else
		{
			// otherwise, don't drop it and display a message
			CarriedDecoration.SetLocation(origLoc);
			ClientMessage(CannotDropHere);
		}
	}
}

function TossWeapon(Vector TossVel)
{
   Super.TossWeapon(TossVel);
   ValidateBelt();
}

// ----------------------------------------------------------------------
// DropItem()
//
// throws an item where you are currently looking
// or places it on your currently highlighted object
// if None is passed in, it drops what's inHand
// ----------------------------------------------------------------------
exec function bool DropItem(optional Inventory inv, optional bool bDrop)
{
	local Inventory item;
	local Inventory previousItemInHand;
	local Vector X, Y, Z, dropVect;
	local float size, mult;
	local DeusExCarcass carc;
	local class<DeusExCarcass> carcClass;
	local bool bDropped;
	local bool bRemovedFromSlots;
	local int  itemPosX, itemPosY;

	bDropped = True;

	if (DeusExPlayerController(controller).RestrictInput())
		return False;

	if (inv == None)
	{
		previousItemInHand = inHand;
		item = inHand;
	}
	else
	{
		item = inv;
	}

	if (item != None)
	{
		GetAxes(Rotation, X, Y, Z);
		dropVect = Location + (CollisionRadius + 2*item.CollisionRadius) * X;
		dropVect.Z += BaseEyeHeight;

		// check to see if we're blocked by terrain
		if (!FastTrace(dropVect))
		{
			ClientMessage(CannotDropHere);
			return False;
		}

		// don't drop it if it's in a strange state
		if (item.IsA('DeusExWeaponInv'))
		{
			if (!DeusExWeaponInv(item).IsInState('Idle') && !DeusExWeaponInv(item).IsInState('Idle2') && !DeusExWeaponInv(item).IsInState('DownWeapon') && !DeusExWeaponInv(item).IsInState('Reload'))
			{
				return False;
			}
			else		// make sure the scope/laser are turned off
			{
				DeusExWeaponInv(item).ScopeOff();
				DeusExWeaponInv(item).LaserOff();
			}
		}

		// Don't allow active ChargedPickups to be dropped
		if ((item.IsA('ChargedPickupInv')) && (ChargedPickupInv(item).bIsActive))//  ()))
			return False;

		// don't let us throw away the nanokeyring
		if (item.IsA('NanoKeyRingInv'))
			return False;

		// take it out of our hand
		if (item == inHand)
			PutInHand(None);

		// handle throwing pickups that stack
		if (item.IsA('DeusExPickupInv'))
		{
			// turn it off if it is on
			if (DeusExPickupInv(item).bActive)
				DeusExPickupInv(item).Activate();

			DeusExPickupInv(item).NumCopies--;
			UpdateBeltText(item);	

			if (DeusExPickupInv(item).NumCopies > 0)
			{
				// put it back in our hand, but only if it was in our
				// hand originally!!!
				if (previousItemInHand == item)
					PutInHand(previousItemInHand);

				item = Spawn(item.class, self);//, Owner);
			}
			else
			{
				// Keep track of this so we can undo it 
				// if necessary
				bRemovedFromSlots = True;
				itemPosX = item.GetinvPosX();
				itemPosY = item.GetinvPosY();

				// Remove it from the inventory slot grid
				RemoveItemFromSlot(item);

				// make sure we have one copy to throw!
				DeusExPickupInv(item).NumCopies = 1;
			}
		}
		else
		{
			// Keep track of this so we can undo it 
			// if necessary
			bRemovedFromSlots = True;
			itemPosX = item.GetinvPosX();
			itemPosY = item.GetinvPosY();

			// Remove it from the inventory slot grid
			RemoveItemFromSlot(item);
		}

		// if we are highlighting something, try to place the object on the target
		if ((FrobTarget != None) && !item.IsA('POVCorpse'))
		{
			item.Velocity = vect(0,0,0);

			// play the correct anim
			PlayPickupAnim(FrobTarget.Location);

			// try to drop the object about one foot above the target
			size = FrobTarget.CollisionRadius - item.CollisionRadius * 2;
			dropVect.X = size/2 - FRand() * size;
			dropVect.Y = size/2 - FRand() * size;
			dropVect.Z = FrobTarget.CollisionHeight + item.CollisionHeight + 16;
			if (FastTrace(dropVect))
			{
				item.DropFrom(FrobTarget.Location + dropVect);
			}
			else
			{
				ClientMessage(CannotDropHere);
				bDropped = False;
			}
		}
		else
		{
			// throw velocity is based on augmentation
			if (AugmentationSystem != None)
			{
				mult = AugmentationSystem.GetAugLevelValue(class'AugMuscle');
				if (mult == -1.0)
					mult = 1.0;
			}

			if (bDrop)
			{
				item.Velocity = VRand() * 30;

				// play the correct anim
				PlayPickupAnim(item.Location);
			}
			else
			{
				item.Velocity = Vector(GetViewRotation()) * mult * 300 + vect(0,0,220) + 40 * VRand();

				// play a throw anim
				PlayAnim('Attack',,0.1);
			}

			GetAxes(GetViewRotation(), X, Y, Z);
			dropVect = Location + 0.8 * CollisionRadius * X;
			dropVect.Z += BaseEyeHeight;

			// if we are a corpse, spawn the actual carcass
			if (item.IsA('POVCorpse'))
			{
				if (POVCorpse(item).carcClassString != "")
				{
					carcClass = class<DeusExCarcass>(DynamicLoadObject(POVCorpse(item).carcClassString, class'Class'));
					if (carcClass != None)
					{
						carc = Spawn(carcClass);
						if (carc != None)
						{
							carc.LinkMesh(carc.Mesh2);
							carc.KillerAlliance = POVCorpse(item).KillerAlliance;
							carc.KillerBindName = POVCorpse(item).KillerBindName;
							carc.Alliance = POVCorpse(item).Alliance;
							carc.bNotDead = POVCorpse(item).bNotDead;
							carc.bEmitCarcass = POVCorpse(item).bEmitCarcass;
							carc.CumulativeDamage = POVCorpse(item).CumulativeDamage;
							carc.MaxDamage = POVCorpse(item).MaxDamage;
							carc.itemName = POVCorpse(item).CorpseItemName;
							carc.CarcassName = POVCorpse(item).CarcassName;
							carc.Inventory = POVCorpse(item).CarcassInv; // DXR: Restore inventory
							carc.Velocity = item.Velocity * 0.5;
							item.Velocity = vect(0,0,0);
							carc.bHidden = False;
							carc.SetPhysics(PHYS_Falling);
							carc.SetScaleGlow();
							if (carc.SetLocation(dropVect))
							{
								// must circumvent PutInHand() since it won't allow
								// things in hand when you're carrying a corpse
								SetInHandPending(None);
								item.Destroy();
								item = None;
							}
							else
								carc.bHidden = True;
						}
					}
				}
			}
			else
			{
				if (FastTrace(dropVect))
				{
					item.DropFrom(dropVect);
					item.bFixedRotationDir = True;
					item.RotationRate.Pitch = (32768 - Rand(65536)) * 4.0;
					item.RotationRate.Yaw = (32768 - Rand(65536)) * 4.0;
				}
			}
		}

		// if we failed to drop it, put it back inHand
		if (item != None)
		{
			if (((inHand == None) || (inHandPending == None)) && (item.Physics != PHYS_Falling))
			{
				PutInHand(item);
				ClientMessage(CannotDropHere);
				bDropped = False;
			}
			else
			{
				item.Instigator = Self;
			}
		}
	}
	else if (CarriedDecoration != None)
	{
		DropDecoration();

		// play a throw anim
		PlayAnim('Attack',,0.1);
	}

	// If the drop failed and we removed the item from the inventory
	// grid, then we need to stick it back where it came from so
	// the inventory doesn't get fucked up.

	if ((bRemovedFromSlots) && (item != None) && (!bDropped))
	{
		item.SetinvPosX(itemPosX);
		item.SetinvPosY(itemPosY);
		SetInvSlots(item, 1);
//    PlaceItemInSlot(item, itemPosX, itemPosY);
	}

	if (bDropped)
		if (item == VM_lastInHand)
        VM_lastInHand = None;

	ValidateBelt(); //
	return bDropped;
}


event Attach(Actor Other)
{
  SupportActor(Other);
}

event Detach(Actor Other)
{
  SupportActor(Other);
}


/* ----------------------------------------------------------------------
  Called when something lands on us
  Пока точно как в оригинале не работает (декорация, свалившаяся на
  игрока должна сама убегать, но теперь хотя-бы не цепляется к нему,
  что уже очень хорошо.
 ----------------------------------------------------------------------*/
function SupportActor(Actor standingActor)
{
	local vector newVelocity;
	local float  angle;
	local float  zVelocity;
	local float  baseMass;
	local float  standingMass;
	local vector damagePoint;
	local float  damage;

  standingActor.SetBase(self);                                         

  if ((standingactor.IsA('Inventory')) || (standingactor.IsA('Pickup')) || (standingactor.IsA('InventoryAttachment')) || (standingactor == carriedDecoration))
	return;

//	if (standingactor == carriedDecoration)
//	return;

	zVelocity    = standingActor.Velocity.Z;
	standingMass = FMax(1, standingActor.Mass);
	baseMass     = FMax(1, Mass);
	damagePoint  = Location + vect(0,0,1)*(CollisionHeight-1);
	damage       = (1 - (standingMass/baseMass) * (zVelocity/100));

	// Have we been stomped?
	if ((zVelocity*standingMass < -7500) && (damage > 0))
		TakeDamage(damage, standingActor.Instigator, damagePoint, 0.2*standingActor.Velocity, class'DM_stomped');

	// Bounce the actor off the player
	angle = FRand()*Pi*2;
	newVelocity.X = cos(angle);
	newVelocity.Y = sin(angle);
	newVelocity.Z = 0;
	newVelocity *= FRand()*25 + 25;
	newVelocity += standingActor.Velocity;
	newVelocity.Z = 50;
	standingActor.Velocity = newVelocity;
	standingActor.SetPhysics(PHYS_Falling);
}

simulated function vector CalcDrawOffset(inventory Inv)
{
	local vector DrawOffset;

	if ( Controller == None )
		return (Inv.PlayerViewOffset >> Rotation) + BaseEyeHeight * vect(0,0,1);

//	DrawOffset = ((0.9/Weapon.DisplayFOV * 100 * ModifiedPlayerViewOffset(Inv)) >> GetViewRotation() );
	DrawOffset = ((0.9/itemFovCorrection * 100 * ModifiedPlayerViewOffset(Inv)) >> GetViewRotation() );
	if ( !IsLocallyControlled() )
		DrawOffset.Z += BaseEyeHeight;
	else
	{
		DrawOffset.Z += EyeHeight;
     if( bWeaponBob )
      {
		    DrawOffset += WeaponBob(Inv.BobDamping);
        DrawOffset += CameraShake();
      }
	}
	return DrawOffset;
}


// Обращение к контроллеру
function SetFOVAngle(float newFOV)
{
	DeusExPlayerController(Controller).FOVAngle = newFOV;
}

// ----------------------------------------------------------------------
// AllEnergy()
// ----------------------------------------------------------------------

exec function AllEnergy()
{
	if (!DeusExPlayerController(Controller).bCheatsEnabled)
		return;

	Energy = default.Energy;
}

exec function AllAmmo()
{
	local Inventory Inv;

	if( !DeusExPlayerController(Controller).bCheatsEnabled )
		return;

	// DEUS_EX CNN - make this be limited by the MaxAmmo per ammo instead of 999
	for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory ) 
		if (Ammunition(Inv)!=None) 
			Ammunition(Inv).AmmoAmount  = Ammunition(Inv).MaxAmmo;
}	

exec function AllSkills()
{
	if (!DeusExPlayerController(Controller).bCheatsEnabled)
		return;

	AllSkillPoints();
	SkillSystem.AddAllSkills();
}

// ----------------------------------------------------------------------
// AllSkillPoints()
// ----------------------------------------------------------------------

exec function AllSkillPoints()
{
	if (!DeusExPlayerController(Controller).bCheatsEnabled)
		return;

	SkillPointsTotal = 115900;
	SkillPointsAvail = 115900;
}

exec function owner()
{
	ClientMessage(OwnerName);
}


/* -------------------------------------------------------------------------------------------
   Воспроизводит звуки шагов. Функция UT2004 переписана на основе оригинальной.
   ВАЖНО! Частота шагов в режиме от первого лица привязана к покачиванию (bobdamping),
   а в режиме behindview к событиям модели (оповещение анимации).
 -------------------------------------------------------------------------------------------*/
function FootStepping(int Side)
{
	local Sound stepSound;
	local float rnd;
	local float speedFactor, massFactor;
	local float volume, pitch, range;
	local float radius, mult;
	local float volumeMultiplier;

	rnd = FRand();

	volumeMultiplier = 1.0;
	if (controller.IsInState('PlayerSwimming') || (Physics == PHYS_Swimming))
	{
		volumeMultiplier = 0.5;
		if (rnd < 0.5)
			stepSound = Sound'Swimming';
		else
			stepSound = Sound'Treading';
	}
	else if (PhysicsVolume.bWaterVolume)
	{
		volumeMultiplier = 1.0;
		if (rnd < 0.33)
			stepSound = Sound'WaterStep1';
		else if (rnd < 0.66)
			stepSound = Sound'WaterStep2';
		else
			stepSound = Sound'WaterStep3';
	}
	else
	{
		switch(GetFloorMaterial())
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

	// compute sound volume, range and pitch, based on mass and speed
	if (controller.IsInState('PlayerSwimming') || (Physics == PHYS_Swimming))
		speedFactor = WaterSpeed/180.0;
	else
		speedFactor = VSize(Velocity)/180.0;

	massFactor  = Mass/150.0;
	radius      = 375.0;
	volume      = (speedFactor+0.2) * massFactor;
	range       = radius * volume;
	pitch       = (volume+0.5);
	volume      = FClamp(volume, 0, 1.0) * 0.5;		// Hack to compensate for increased footstep volume.											
	range       = FClamp(range, 0.01, radius*4);
	pitch       = FClamp(pitch, 1.0, 1.5);

	// AugStealth decreases our footstep volume
	mult = AugmentationSystem.GetAugLevelValue(class'AugStealth');
	if (mult == -1.0)
		mult = 1.0;
	volume *= mult;

	// play the sound and send an AI event
	PlaySound(stepSound, SLOT_Interact, volume, , range, pitch);
	class'EventManager'.static.AISendEvent(self, 'LoudNoise', EAITYPE_Audio, volume*volumeMultiplier, range*volumeMultiplier);
}

// Контроль лестниц (вертикальных, LadderVolume) >>
// 
// Металлические лестницы
// Идея и звуки из мода GMDX
//
function LadderStepSounds()
{
	local float			rnd;
	local sound 		StepSound;

	if (!DeusExPlayerController(controller).isInState('PlayerClimbing'))
	return;

	rnd = FRand();

		if (rnd < 0.25)
		stepSound = Sound'pl_ladder1';
		else if (rnd < 0.5)
		stepSound = Sound'pl_ladder2';
		else if (rnd < 0.75)
		stepSound = Sound'pl_ladder3';
		else
		stepSound = Sound'pl_ladder4';

	PlaySound(StepSound, SLOT_Interact, 0.9,,400,RandomPitch());
}

//
// Деревянные лестницы (звуки стандартные из UT2004)
//
function WLadderStepSounds()
{
	local float			rnd;
	local sound 		StepSound;

	if (!DeusExPlayerController(controller).isInState('PlayerClimbing'))
	return;

	rnd = FRand();

/*		if (rnd < 0.25)
		stepSound = Sound'BFootStepWood1';
		else if (rnd < 0.5)
		stepSound = Sound'BFootStepWood6';
		else if (rnd < 0.75)
		stepSound = Sound'BFootStepWood3';
		else
		stepSound = Sound'BFootStepWood5';*/

	PlaySound(StepSound, SLOT_Interact, 0.9,,400,RandomPitch());
}

function ClimbLadder(LadderVolume L)
{
	OnLadder = L;
	SetRotation(OnLadder.WallDir);
	SetPhysics(PHYS_Ladder);
	if (IsHumanControlled())
		{
			if (L.IsA('DeusExLadderVolume'))
			{
				if (DeusExLadderVolume(L).bIsWoodLadder)
							DeusExPlayerController(Controller).bUsingWoodenLadder=true;
			}
			else
			DeusExPlayerController(Controller).bUsingWoodenLadder=false;
			DeusExPlayerController(Controller).GotoState('PlayerClimbing');
		}
}

// <<

// ----------------------------------------------------------------------
// GetWallMaterial()
//
// gets the name of the texture group that we are facing
// DXR: Probably never used, even in mods. Or was used before release?
// ----------------------------------------------------------------------
function name GetWallMaterial(out vector wallNormal)
{
	local vector EndTrace, HitLocation, HitNormal;
	local actor target;
	local int texFlags, grabDist;
	local name texName, texGroup;

	// if we are falling, then increase our grabbing distance
	if (Physics == PHYS_Falling)
		grabDist = 3.0;
	else
		grabDist = 1.5;

	// trace out in front of us
	EndTrace = Location + (Vector(Rotation) * CollisionRadius * grabDist);

 	foreach class'ActorManager'.static.TraceTexture(self,class'Actor', target, texName, texGroup, texFlags, HitLocation, HitNormal, EndTrace)
	{
		if (target == Level)
			break;
	}

	wallNormal = HitNormal;

	return texGroup;
}

// ----------------------------------------------------------------------
// GetFloorMaterial()
//
// gets the name of the texture group that we are standing on
// ----------------------------------------------------------------------
function name GetFloorMaterial()
{
	local vector EndTrace, HitLocation, HitNormal, Start;
	local actor target;
	local int texFlags;
	local name texName, texGroup;
	local material mat;

	// trace down to our feet
	EndTrace = Location - CollisionHeight * 1.1 * vect(0,0,1); //*2

	foreach class'ActorManager'.static.TraceTexture(self, class'Actor', target, texName, texGroup, texFlags, HitLocation, HitNormal, EndTrace)
	{
		if (target == Level) // movers are staticmeshes in this version of the engine.
			break;
	}
  if (texGroup == 'None') // None? Then try built-in Trace().
	{
     Start = Location - Vect(0,0,1)*CollisionHeight;
     EndTrace = Start - Vect(0,0,32);
	   Trace(HitLocation, HitNormal, EndTrace, Start, false, , mat);

	   if (mat != none)
         texGroup = class'DxUtil'.static.GetMaterialGroup(mat);
	}

//	ClientMessage("TexName="$texName @ "texGroup="$texGroup @ "target="$target @ "mat="$mat);
	return texGroup;
}


function CheckBob(float DeltaTime, vector Y)
{
	local float OldBobTime;
	local int m,n;

	OldBobTime = BobTime;
	Super.CheckBob(DeltaTime,Y);

	if (((Physics != PHYS_Walking) && (Physics != PHYS_Ladder)) || (VSize(Velocity) < 10) || ((PlayerController(Controller) != None) && PlayerController(Controller).bBehindView)) // !-add
		return;

	m = int(0.5 * Pi + 9.0 * OldBobTime/Pi);
	n = int(0.5 * Pi + 9.0 * BobTime/Pi);

	if ((m != n)  && !bIsCrouched)
		{
			FootStepping(0);
		}
}

function PlayFootStep(int Side)
{
		FootStepping(Side);
		return;
}

/*simulated function PlayFootStepLeft()
{
    PlayFootStep(-1);
}

simulated function PlayFootStepRight()
{
    PlayFootStep(1);
}*/

function name GetWeaponBoneFor(Inventory I)
{
	return '0'; // кость для держания
}


function inWaterRight()
{
	local float rnd;

	rnd = Frand();
	if (rnd < 0.5)
	PlaySound(sound'Swimming', SLOT_Interact,,,, RandomPitch());
		else
	PlaySound(sound'Treading', SLOT_Interact,,,, RandomPitch());
}

function inWaterLeft()
{
	local float rnd;

	rnd = Frand();
	if (rnd < 0.5)
	PlaySound(sound'Swimming', SLOT_Interact,,,, RandomPitch());
		else
	PlaySound(sound'Treading', SLOT_Interact,,,, RandomPitch());
}

exec function ToggleWalk()
{
	if (DeusExPlayerController(controller).RestrictInput())
		return;

 if (bAlwaysRun)
	bToggleWalk = !bToggleWalk;
}

// ----------------------------------------------------------------------
// UpdateBeltText()
// ----------------------------------------------------------------------

function UpdateBeltText(Inventory item)
{
/*	local DeusExRootWindow root;

	root = DeusExRootWindow(rootWindow);

	// Update object belt text
	if ((item.bInObjectBelt) && (root != None))
		root.hud.belt.UpdateObjectText(item.beltPos);		*/
}

// ----------------------------------------------------------------------
// UpdateAmmoBeltText()
//
// Loops through all the weapons in the player's inventory and updates
// the ammo for any that matches the ammo type passed in.
// ----------------------------------------------------------------------

function UpdateAmmoBeltText(Ammunition ammo)
{
/*	local Inventory inv;

	inv = Inventory;
	while(inv != None)
	{
		if ((inv.IsA('DeusExWeapon')) && (DeusExWeapon(inv).AmmoType == ammo))
			UpdateBeltText(inv);

		inv = inv.Inventory;
	}*/
}


function DoneReloading(DeusExWeaponInv weapon);


function ResetConversationHistory()
{
}


function PlayTurning();

simulated function bool ForceDefaultCharacter()
{
    return false;
}

exec function ShowInventoryWindow()
{
	DeusExPlayerController(controller).ClientOpenMenu("DXRMenu.GUI_Player");
}


function PostIntro()
{
	if (bStartNewGameAfterIntro)
	{
		bStartNewGameAfterIntro = False;
		StartNewGame(strStartMap);
	}
	else
	{
		Level.Game.SendPlayer(DeusExPlayerController(Self.controller), "dxonly");
	}
}


function ShowIntro(optional bool bStartNewGame)
{
  bStartNewGameAfterIntro = bStartNewGame;

  // Make sure all augmentations are OFF before going into the intro
  AugmentationSystem.DeactivateAll();

  // Reset the player
  Level.Game.SendPlayer(DeusExPlayerController(Self.controller), "00_Intro");
}

exec function StartNewGame(String startMap)
{
	// Set a flag designating that we're traveling,
	// so MissionScript can check and not call FirstFrame() for this map.
	getFlagBase().SetBool('PlayerTraveling', True, True, 0);

	SaveSkillPoints();
	ResetPlayer();
	DeleteSaveGameFiles();

	bStartingNewGame = True;

	// Send the player to the specified map!
	if (startMap == "")
		Level.Game.SendPlayer(DeusExPlayerController(Self.controller), DefaultStartMap);		// TODO: Must be stored somewhere!
	else
		Level.Game.SendPlayer(DeusExPlayerController(Self.controller), startMap);
}

// ----------------------------------------------------------------------
// Called when a new game is started. 
// 1) Erase all flags except those beginning with "SKTemp_"
// 2) Dumps inventory
// 3) Restore any other defaults
// ----------------------------------------------------------------------
exec function ResetPlayer(optional bool bTraining)
{
	local inventory anItem;
//	local inventory nextItem;

	ResetPlayerToDefaults();

	// Reset Augmentations
	if (AugmentationSystem != None)
	{
		AugmentationSystem.ResetAugmentations();
		AugmentationSystem.Destroy();
		AugmentationSystem = None;
	}

	// Give the player a pistol and a prod
	if (!bTraining)
	{
		anItem = Spawn(class'WeaponPistolInv');
		frobTarget = anItem;
//		DoFrob(self, none);
     HandleItemPickup(anItem,false);
    putOnBelt(anItem);

		anItem = Spawn(class'WeaponProdInv');
		frobTarget = anItem;
//		DoFrob(self, none);
     HandleItemPickup(anItem,false);
    putOnBelt(anItem);

		anItem = Spawn(class'MedKitInv');
		frobTarget = anItem;
//		DoFrob(self, none);
     HandleItemPickup(anItem,false);
    putOnBelt(anItem);
	}
}

// ----------------------------------------------------------------------
// Resets all travel variables to their defaults
// ----------------------------------------------------------------------
function ResetPlayerToDefaults()
{
	local inventory anItem;
//	local inventory nextItem;
//	local int x;

	// reset the image linked list
//	FirstImage = None;

  getFlagBase().DeleteAlmostAllFlags();

	// Remove all the keys from the keyring before
	// it gets destroyed
	if (KeyRing != None)
	{
		KeyRing.RemoveAllKeys();
		NanoKeys.length = 0; // убрать все ключи из карманов
		KeyRing.destroy();// = None;
	}

	while(Inventory != None)
	{
		anItem = Inventory;
		DeleteInventory(anItem);
		anItem.Destroy();
	}

	// Clear object belt

/*	if (DeusExRootWindow(rootWindow) != None)
		DeusExRootWindow(rootWindow).hud.belt.ClearBelt();*/

	// clear the notes and the goals
	DeleteAllNotes();
	DeleteAllGoals();

	// Nuke the history
	ResetConversationHistory();

	// Other defaults
	Credits = Default.Credits;
	Energy  = Default.Energy;
	SkillPointsTotal = Default.SkillPointsTotal;
	SkillPointsAvail = Default.SkillPointsAvail;

	SetInHandPending(None);
	SetInHand(None);

	bInHandTransition = False;

	RestoreAllHealth();
//	ClearLog();

	// Reset save count/time
	saveCount = 0;
	saveTime  = 0.0;

	// Reinitialize all subsystems we've just nuked
	InitializeSubSystems();
}


// ----------------------------------------------------------------------
// Restore skill point variables
// ----------------------------------------------------------------------
function RestoreSkillPoints()
{
	bSavingSkillsAugs = False;

	// Get the skill points available
	if (GetflagBase().CheckFlag("SKTemp_SkillPointsAvail"))
	{
		SkillPointsAvail = GetflagBase().GetInt("SKTemp_SkillPointsAvail");
		GetflagBase().DeleteFlag("SKTemp_SkillPointsAvail");
	}

	// Get the skill points total
	if (GetflagBase().CheckFlag("SKTemp_SkillPointsTotal"))
	{
		SkillPointsTotal = GetflagBase().GetInt("SKTemp_SkillPointsTotal");
		GetflagBase().DeleteFlag("SKTemp_SkillPointsTotal");
	}
}

// ----------------------------------------------------------------------
// Saves out skill points, used when starting a new game
// ----------------------------------------------------------------------
function SaveSkillPoints()
{
	// Save/Restore must be done as atomic unit
	if (bSavingSkillsAugs)
		return;

	bSavingSkillsAugs = True;

	// Save the skill points available
	GetflagBase().SetInt("SKTemp_SkillPointsAvail", SkillPointsAvail);

	// Save the skill points available
	GetflagBase().SetInt("SKTemp_SkillPointsTotal", SkillPointsTotal);
}

exec function SaveTravelDecoration()
{
  if (carriedDecoration != none)
  {
    gl = class'DeusExGlobals'.static.GetGlobals();
    gl.TravelDeco = "DeusEx."$CarriedDecoration.GetHumanReadableName();
    gl.decoRotation = CarriedDecoration.rotation;
  }
}

/* Восстановить переносимый предмет */
exec function RestoreTravelDecoration()
{
	local class<DeusExDecoration> myDeco;
	local DeusExDecoration finalDeco;
  local vector lookDir, upDir;
/*	local vector loc;

	loc = location;
	loc.Z = CollisionHeight / 2.5;*/

  gl = class'DeusExGlobals'.static.GetGlobals();

  if (gl.TravelDeco != "")
      myDeco = class<DeusExDecoration>(DynamicLoadObject(gl.TravelDeco, class'Class'));

  if (myDeco != none)
  {
  log("********* Restoring travelDeco...");
    gl.TravelDeco = "";
  	finalDeco = Spawn(myDeco, self);
		lookDir = Vector(Rotation);
		lookDir.Z = 0;				
		upDir = vect(0,0,0);
		upDir.Z = CollisionHeight / 2;		// put it up near eye level
  	finalDeco.SetLocation(Location + upDir + (0.5 * CollisionRadius + finalDeco.CollisionRadius) * lookDir);
  	Frob(self, none);
  }
}


static function string GetTruePlayerName()
{
  return default.TruePlayerName;
}

static function string GetPlayerFirstName()
{
  local string f, l;

  Divide(default.TruePlayerName, " ", f, l);
  return f;
}

function string GetBindName()
{return bindName;}

function string GetBarkBindName() // Used to bind Barks!
{return BarkBindName;}

function string GetFamiliarName() // For display in Conversations
{return FamiliarName;}

function string GetUnfamiliarName() // For display in Conversations
{return UnfamiliarName;}

function float GetConStartInterval()
{return ConStartInterval;}

function float GetLastConEndTime()	// Time when last conversation ended
{return LastConEndTime;}
//-------------------------------------


// Called by ConPlay when a conversation has finished.
function EndConversation()
{
  LastConEndTime = Level.TimeSeconds;

	// If we're in a bForcePlay (cinematic) conversation,
	// force the CinematicWindow to be displayd
	if ((conPlay != None) && (conPlay.GetForcePlay()))
	{
//		if (DeusExRootWindow(rootWindow) != None)
//			DeusExRootWindow(rootWindow).NewChild(class'CinematicWindow');
		ClientMessage("STUB for cinematic HUD here!!!");
	}

	conPlay = None;

	// Check to see if we need to resume any DataLinks that may have
	// been aborted when we started this conversation
	ResumeDataLinks();

//	StopBlendAnims();

	// We might already be dead at this point (someone drop a LAM before
	// entering the conversation?) so we want to make sure the player
	// doesn't suddenly jump into a non-DEATH state.
	//
	// Also make sure the player is actually in the Conversation state
	// before attempting to kick him out of it.

	if ((Health > 0) && ((Controller.IsInState('Conversation')) || (Controller.IsInState('FirstPersonConversation')) || (NextState == 'Interpolating')))
	{
		if (NextState == '')
			Controller.GotoState('PlayerWalking');
		else
			Controller.GotoState(NextState);
	}
}

// ----------------------------------------------------------------------
// ResumeDataLinks()
// ----------------------------------------------------------------------
function ResumeDataLinks()
{
	if (dataLinkPlay != None)
		dataLinkPlay.ResumeDataLinks();
}

// ----------------------------------------------------------------------
// AbortConversation()
// ----------------------------------------------------------------------
function AbortConversation(optional bool bNoPlayedFlag)
{
	if (conPlay != None)
		conPlay.TerminateConversation(False, bNoPlayedFlag);
}

// ----------------------------------------------------------------------
// CanStartConversation()
//
// Returns true if we can start a conversation.  Basically this means
// that
//
// 1) If in conversation, bCannotBeInterrutped set to False
// 2) If in conversation, if we're not in a third-person convo
// 3) The player isn't in 'bForceDuck' mode
// 4) The player isn't DEAD!
// 5) The player isn't swimming
// 6) The player isn't CheatFlying (ghost)
// 7) The player isn't in PHYS_Falling
// 8) The game is in 'bPlayersOnly' mode
// 9) UI screen of some sort isn't presently active.
// ----------------------------------------------------------------------
function bool CanStartConversation()
{
	if (((conPlay != None) && (conPlay.CanInterrupt() == False)) || ((conPlay != None) && (conPlay.con.bFirstPerson != True)) ||
		 ((bForceDuck == True ) && ((HealthLegLeft > 0) ||
		 (IsInState('Dying')) || (HealthLegRight > 0))) ||
		 (DeusExPlayerController(controller).IsInState('PlayerSwimming')) ||
		 (DeusExPlayerController(controller).IsInState('PlayerFlying')) 	||
		 (Physics == PHYS_Falling) || (Level.bPlayersOnly))
		 {
//				ClientMessage("CanStartConversation FALSE");
				return False;
		 }
	else
		return True;
}

// Checks to see if a valid conversation exists for this moment in time
// between the ScriptedPawn and the PC.  If so, then it triggers the 
// conversation system and returns TRUE when finished.
function bool StartConversation(Actor invokeActor, EInvokeMethod invokeMethod, optional ConDialogue con, optional bool bAvoidState,optional bool bForcePlay)
{
	// First check to see the actor has any conversations or if for some
	// other reason we're unable to start a conversation (typically if 
	// we're alread in a conversation or there's a UI screen visible)

	if ((!bForcePlay) && ((invokeActor.GetconList().length == 0) || (!CanStartConversation())))
	{
//		ClientMessage("Start Conversation returned FALSE");
		return False;
	}

	// Make sure the other actor can converse
	if ((!bForcePlay) && ((ScriptedPawn(invokeActor) != None) && (!ScriptedPawn(invokeActor).CanConverse())))
	{
//		ClientMessage("Start Conversation returned FALSE");
		return False;
	}

	// If we have a conversation passed in, use it.  Otherwise check to see
	// if the passed in actor actually has a valid conversation that can be
	// started.

	if (con == None)
		con = GetActiveConversation(invokeActor, invokeMethod);

	// If we have a conversation, put the actor into "Conversation Mode".
	// Otherwise just return false.
	//
	// TODO: Scan through the conversation and put *ALL* actors involved
	//       in the conversation into the "Conversation" state??

	if ( con != None )
	{
		// Check to see if this conversation is already playing.  If so,
		// then don't start it again.  This prevents a multi-bark conversation
		// from being abused.
		if ((conPlay != None) && (conPlay.con == con))
			return False;

		// Now check to see if there's a conversation playing that is owned
		// by the InvokeActor *and* the player has a speaking part *and*
		// it's a first-person convo, in which case we want to abort here.
		if (((conPlay != None) && (conPlay.invokeActor == invokeActor)) && 
		    (conPlay.con.bFirstPerson) &&
			(conPlay.con.IsSpeakingActor(Self)))
			return False;

		// Check if the person we're trying to start the conversation 
		// with is a Foe and this is a Third-Person conversation.  
		// If so, ABORT!
		if ((!bForcePlay) && ((!con.bFirstPerson) && (ScriptedPawn(invokeActor) != None) && (ScriptedPawn(invokeActor).GetPawnAllianceType(Self) == ALLIANCE_Hostile)))
			return False;

		// If the player is involved in this conversation, make sure the 
		// scriptedpawn even WANTS to converse with the player.
		//
		// I have put a hack in here, if "con.bCanBeInterrupted" 
		// (which is no longer used as intended) is set, then don't 
		// call the ScriptedPawn::CanConverseWithPlayer() function

		if ((!bForcePlay) && ((con.IsSpeakingActor(Self)) && (!con.bCanBeInterrupted) && (ScriptedPawn(invokeActor) != None) && (!ScriptedPawn(invokeActor).CanConverseWithPlayer(Self))))
			return False;

		// Hack alert!  If this is a Bark conversation (as denoted by the 
		// conversation name, since we don't have a field in ConEdit), 
		// then force this conversation to be first-person
		if (Left(con.Name, Len(con.OwnerName) + 5) == (con.OwnerName $ "_Bark"))
			con.bFirstPerson = True;

		// Make sure the player isn't ducking.  If the player can't rise
		// to start a third-person conversation (blocked by geometry) then 
		// immediately abort the conversation, as this can create all 
		// sorts of complications (such as the player standing through
		// geometry!!)

		if ((!con.bFirstPerson) && (ResetBasedPawnSize() == False))
			return False;

		// If ConPlay exists, end the current conversation playing
		if (conPlay != None)
		{
			// If we're already playing a third-person conversation, don't interrupt with
			// another *radius* induced conversation (frobbing is okay, though).
			if ((conPlay.con != None) && (conPlay.con.bFirstPerson) && (invokeMethod == IM_Radius))
				return False;

			conPlay.InterruptConversation();
			conPlay.TerminateConversation();
		}

		// If this is a first-person conversation _and_ a DataLink is already
		// playing, then abort.  We don't want to give the user any more 
		// distractions while a DL is playing, since they're pretty important.
		if ( dataLinkPlay != None )
		{
			if (con.bFirstPerson)
				return False;
			else
				dataLinkPlay.AbortAndSaveHistory();
		}

		// Found an active conversation, so start it
		conPlay = Spawn(class'ConPlay');
		conPlay.SetStartActor(invokeActor);
		conPlay.SetConversation(con);
		conPlay.SetForcePlay(bForcePlay);
		conPlay.SetInitialRadius(VSize(Location - invokeActor.Location));

		// If this conversation was invoked with IM_Named, then save away
		// the current radius so we don't abort until we get outside 
		// of this radius + 100.
		if ((invokeMethod == IM_Named) || (invokeMethod == IM_Frob))
		{
			conPlay.SetOriginalRadius(con.InvokeRadius);
			con.InvokeRadius = VSize(invokeActor.Location - Location);
		}

		// If the invoking actor is a ScriptedPawn, then force this person 
		// into the conversation state
		if ((!bForcePlay) && (ScriptedPawn(invokeActor) != None ))
			ScriptedPawn(invokeActor).EnterConversationState(con.bFirstPerson, bAvoidState);

		// Do the same if this is a DeusExDecoration
		if ((!bForcePlay) && (DeusExDecoration(invokeActor) != None ))
			DeusExDecoration(invokeActor).EnterConversationState(con.bFirstPerson, bAvoidState);

		// If this is a third-person convo, we're pretty much going to 
		// pause the game.  If this is a first-person convo, then just 
		// keep on going..
		//
		// If this is a third-person convo *AND* 'bForcePlay' == True, 
		// then use first-person mode, as we're playing an intro/endgame
		// sequence and we can't have the player in the convo state (bad bad bad!)

		if ((!con.bFirstPerson) && (!bForcePlay))
		{
//			if 	(!DeusExPlayerController(Controller).IsInState('Conversation'))
//			{
				DeusExPlayerController(Controller).GotoState('Conversation');
//			}
		}
		else
		{
			if (!conPlay.StartConversation(Self, invokeActor, bForcePlay))
			{
				AbortConversation(True);
			}
		}
		return True;
	}
	else
	{
		return False;
	}
}

// CheckActiveConversationRadius()
// If there's a first-person conversation active, checks to make sure
// that the player has not walked far away from the conversation owner.
// If so, the conversation is aborted.
function CheckActiveConversationRadius()
{
	local int checkRadius;

	// Ignore if conPlay.GetForcePlay() returns True

	if ((conPlay != None) && (!conPlay.GetForcePlay()) && (conPlay.ConversationStarted()) && (conPlay.displayMode == DM_FirstPerson) && (conPlay.StartActor != None))
	{
		// If this was invoked via a radius, then check to make sure the player doesn't
		// exceed that radius plus

		if (conPlay.con.bInvokeRadius)
			checkRadius = conPlay.con.InvokeRadius + 100;
		else
			checkRadius = 300;

		// Add the collisioncylinder since some objects are wider than others
		checkRadius += conPlay.StartActor.CollisionRadius;

		if (VSize(conPlay.startActor.Location - Location) > checkRadius)
		{
			// Abort the conversation
			conPlay.TerminateConversation(True);
		}
	}
}

// Checks to see how far all the actors are away from each other
// to make sure the conversation should continue.
function CheckActorDistances()
{
	if ((conPlay != None) && (!conPlay.GetForcePlay()) && (conPlay.ConversationStarted()) && (conPlay.displayMode == DM_ThirdPerson))
	{
		if (!conPlay.con.CheckActorDistances(Self))
			conPlay.TerminateConversation(True);
	}
}

// This routine searches all the conversations in this chain until it 
// finds one that is valid for this situation.  It returns the 
// conversation or None if none are found.
function ConDialogue GetActiveConversation(Actor invokeActor, EInvokeMethod invokeMethod)
{
	local int i;
	local ConDialogue con;
	local /*Name*/ string flagName;
	local bool bAbortConversation;

	// If we don't have a valid invokeActor or the flagbase
	// hasn't yet been initialized, immediately abort.
	if ((invokeActor == None) || (GetflagBase() == None))
		return None;

	bAbortConversation = True;

	// Force there to be a one second minimum between conversations 
	// with the same NPC
	if ((invokeActor.GetLastConEndTime() != 0) && ((Level.TimeSeconds - invokeActor.GetLastConEndTime()) < 1.0))
		return None;

	// In a loop, go through the conversations, checking each.
//	conListItem = ConListItem(invokeActor.GetConListItems());

//	while (conListItem != None)
  for (i=0; i<invokeActor.GetConList().length; i++)
	{
		con = ConDialogue(invokeActor.GetConList()[i]);//conListItem.con;

		bAbortConversation = false;

		// Ignore Bark conversations, as these are started manually
		// by the AI system.  Do this by checking to see if the first
		// part of the conversation name is in the form, 
		//
		// ConversationOwner_Bark

		if (Left(con.Name, Len(con.OwnerName) + 5) == (con.OwnerName $ "_Bark"))
			bAbortConversation = True;

		if (!bAbortConversation)
		{
			// Now check the invocation method to make sure
			// it matches what was passed in

			switch(invokeMethod)
			{
				// Removed Bump conversation starting functionality, all convos
				// must now be "Frobbed" to start (excepting Radius, of course).
				case IM_Bump:
				case IM_Frob:
					bAbortConversation = !(con.bInvokeFrob || con.bInvokeBump);
					break;

				case IM_Sight:
					bAbortConversation = !con.bInvokeSight;
					break;

				case IM_Radius:
					if (con.bInvokeRadius)
					{
   					// Calculate the distance between the player and the owner
						// and if the player is inside that radius, we've passed 
						// this check.

						bAbortConversation = !CheckConversationInvokeRadius(invokeActor, con);
						//log("GetActiveConversation = "$bAbortConversation);

						// First check to make sure that at least 10 seconds have passed
						// before playing a radius-induced conversation after a letterbox
						// conversation with the player
						//
						// Check:
						//  
						// 1.  Player finished letterbox convo in last[ 10 seconds
						// 2.  Conversation was with this NPC
						// 3.  This new radius conversation is with same NPC.

						if ((!bAbortConversation) && ((Level.TimeSeconds - lastThirdPersonConvoTime) < 10) && (lastThirdPersonConvoActor == invokeActor))
						{
							bAbortConversation = True;
              //log("GetActiveConversation = "$bAbortConversation);
						}

						// Now check if this conversation ended in the last ten seconds or so
						// We want to prevent the user from getting trapped inside the same 
						// radius conversation 
						
						if ((!bAbortConversation) && (con.lastPlayedTime > 0))
						{
							bAbortConversation = ((Level.TimeSeconds - con.lastPlayedTime) < 10);
              //log("GetActiveConversation = "$bAbortConversation);
						}

						// Now check to see if the player just ended a radius, third-person
						// conversation with this NPC in the last 5 seconds.  If so, punt, 
						// because we don't want these to chain together too quickly.

						if ((!bAbortConversation) && ((Level.TimeSeconds - lastFirstPersonConvoTime) < 5) && (lastFirstPersonConvoActor == invokeActor))
						{
							bAbortConversation = True;
              //log("GetActiveConversation = "$bAbortConversation);
						}
//           DeusExHUD(level.GetLocalPlayerController().myHUD).DebugConString = "InvokerActor = яя_"$invokeActor$"___, ConDialogue = яя_"$con;
  //         DeusExHUD(level.GetLocalPlayerController().myHUD).DebugConString2 = "bAbortConversation?="$bAbortConversation @"con.radiusDistance = _яя"$con.radiusDistance;
					}
					else
					{
						bAbortConversation = True;
            //log("GetActiveConversation = "$bAbortConversation);
					}
					break;

				case IM_Other:
				default:
					break;
			}
		}

		// Now check to see if these two actors are too far apart on their Z
		// axis so we don't get conversations triggered when someone jumps on
		// someone else, or when actors are on two different levels.

		if (!bAbortConversation)
		{
			bAbortConversation = !CheckConversationHeightDifference(invokeActor, 20);// 20);

			// If the height check failed, look to see if the actor has a LOS view
			// to the player in which case we'll allow the conversation to continue
			
			if (bAbortConversation)
				bAbortConversation = !CanActorSeePlayer(invokeActor);
		}

		// Check if this conversation is only to be played once 
		if ((!bAbortConversation) && (con.bDisplayOnce))
		{
			//flagName = class'DxUtil'.static.StringToName(con.Name $ "_Played");
			flagName = con.Name $ "_Played";
			bAbortConversation = (GetflagBase().GetBool(flagName) == True);
		}

		if (!bAbortConversation)
		{
			// Then check to make sure all the flags that need to be
			// set are.
			bAbortConversation = !CheckFlagRefs(con.flagRefList);
		}

		if (!bAbortConversation)
	      break;
//		conListItem = conListItem.next;
	}

	if (bAbortConversation)
		return None;
	else
	  {
//	  log("return conDialogue "$con);
		return con;
		}
}

// Starts an AI Bark conversation, which really isn't a conversation
// as much as a simple bark.  
function bool StartAIBarkConversation(Actor conOwner,EventManager.EBarkModes barkMode)
{
	if ((conOwner == None) || (conOwner.GetConList().length == 0) || (barkManager == None) || ((conPlay != None) && (conPlay.con.bFirstPerson != true)))
	{
//	  clientMessage("Can't start BARK!");
		return false;
	}
	else
	{
//    clientMessage("Похоже баркменеджер барахлит -_-");
		return (barkManager.StartBark(ScriptedPawn(conOwner), barkMode));
	}
}

// Starts a conversation by looking for the name passed in.
// Calls StartConversation() if a match is found.
function bool StartConversationByName(string conName,	Actor conOwner,	optional bool bAvoidState, optional bool bForcePlay)
{
//	local ConListItem conListItem;
	local ConDialogue con;
	local int  dist, i;
	local bool bConversationStarted;

	bConversationStarted = False;

	if (conOwner == None)
		return False;

	//conListItem = ConListItem(conOwner.GetconListItems());

//	while(conListItem != None)
  for (i=0; i<conOwner.GetConList().length; i++)
	{
	  con = ConDialogue(conOwner.GetConList()[i]);

		if (con.Name == conName)
		{
			con = ConDialogue(conOwner.GetConList()[i]);
			break;
		}
//		conListItem = conListItem.next;
	}

	// Now check to see that we're in a respectable radius.
	if (con != None)
	{
		dist = VSize(Location - conOwner.Location);

		// 800 = default sound radius, from unscript.cpp
		//
		// If "bForcePlay" is set, then force the conversation
		// to play!

		if ((dist <= 800) || (bForcePlay))
			bConversationStarted = StartConversation(conOwner, IM_Named, con, bAvoidState, bForcePlay);
	}
	return bConversationStarted;
}


// Returns True if this conversation can be invoked given the 
// invoking actor and the conversation passed in.
function bool CheckConversationInvokeRadius(Actor invokeActor, ConDialogue con)
{
	local int  radius, invRadius;
	local int  dist;

	dist = VSize(Location - invokeActor.Location);
	radius = con.InvokeRadius;

	invRadius = Max(16, radius);

	return (dist <= invRadius);
}

// Checks to make sure the player and the invokeActor are fairly close
// to each other on the Z Plane.  Returns True if they are an 
// acceptable distance, otherwise returns False.
function bool CheckConversationHeightDifference(Actor invokeActor, int heightOffset)
{
	local Int dist;

	dist = Abs(Location.Z - invokeActor.Location.Z) - Abs(Default.CollisionHeight - CollisionHeight);

	if (dist > (Abs(CollisionHeight - invokeActor.CollisionHeight) + heightOffset))
		return False;
	else
		return True;
}

// GetActiveDataLink()
// Loops through the conversations belonging to the player and checks
// to see if the datalink conversation passed in can be found.  Also
// checks to the "PlayedOnce" flag to prevent datalink transmissions
// from playing more than one (unless intended).
function ConDialogue GetActiveDataLink(String datalinkName)
{
	local Name flagName;
//	local ConListItem conListItem;
	local ConDialogue con;
	local bool bAbortDataLink;
	local bool bDatalinkFound;
	local bool bDataLinkNameFound;
	local int i;

	// Abort immediately if the flagbase isn't yet initialized
	if (GetflagBase() == None)
		return None;

//	conListItem = ConListItem(conListItems);

	// In a loop, go through the conversations, checking each.
//	while ( conListItem != None )
  for (i=0; i<conList.length; i++)
	{
		con = conList[i];  //conListItem.con;

		if (Caps(datalinkName) == Caps(con.Name))
		{
			// Now check if this DataLink is only to be played
			// once 
			bDataLinkNameFound = true;
			bAbortDataLink = false;

			if (con.bDisplayOnce)
			{
				flagName = class'DxUtil'.static.StringToName(con.Name $ "_Played");
				bAbortDataLink = (getFlagBase().GetBool(flagName) == true);
			}

			// Check the flags for this DataLink
			if ((!bAbortDataLink) && (CheckFlagRefs(con.flagRefList) == true))
			{
				bDatalinkFound = True;
				break;
			}

		}
//		conListItem = conListItem.next;
	}

	if (bDatalinkFound)
	{
		return con;
	}
	else
	{
		// Print a warning if this DL couldn't be found based on its name
		if (bDataLinkNameFound == false)
		{
			log("WARNING! INFOLINK NOT FOUND!! Name = " $ datalinkName);
			ClientMessage("WARNING! INFOLINK NOT FOUND!! Name = " $ datalinkName);
		}
		return None;
	}
}

// Returns a name that can be displayed in the conversation.  
//
// The first time we speak to someone we'll use the Unfamiliar name.
// For subsequent conversations, use the Familiar name.  As a fallback,
// the BindName will be used if both of the other two fields
// are blank.
//
// If this is a DeusExDecoration and the Familiar/Unfamiliar names
// are blank, then use the decoration's ItemName instead.  This is 
// for use in the FrobDisplayWindow.
function String GetDisplayName(Actor actor, optional bool bUseFamiliar)
{
	local String displayName;

	// Sanity check
	if (actor == None) //  || (player == None)) // || (rootWindow == None))
		return "";

	// If we've spoken to this person already, use the 
	// Familiar Name
	if ((actor.GetFamiliarName() != "") && ((actor.GetLastConEndTime() > 0) || (bUseFamiliar)))
		displayName = actor.GetFamiliarName();

	if ((displayName == "") && (actor.GetUnfamiliarName() != ""))
		displayName = actor.GetUnfamiliarName();

	if (displayName == "")
	{
		if (actor.IsA('DeusExDecoration'))
			displayName = DeusExDecoration(actor).itemName;
		else
			displayName = actor.GetBindName();
	}
	return displayName;
}

// ----------------------------------------------------------------------
// CheckFlagRefs()
//
// Loops through the flagrefs passed in and sees if the current flag
// settings in the game match this set of flags.  Returns True if so,
// otherwise False.
// ----------------------------------------------------------------------
function bool CheckFlagRefs(Array<ConFlagRef> flagRef)
{
  local int k;
	// Loop through our list of FlagRef's, checking the value of each.
	// If we hit a bad match, then we'll stop right away since there's
	// no point of continuing.

  for (k=0; k<flagref.length; k++)
	{
		if (GetflagBase().GetBool(flagref[k].Name) != flagRef[k].value)
			return false;
	}
	// If we made it this far, then the flags check out.
	return True;
}

// ----------------------------------------------------------------------
// Start InfoLink transmission...
// ----------------------------------------------------------------------
function bool StartDataLinkTransmission(String datalinkName, Optional DataLinkTrigger datalinkTrigger)
{
	local ConDialogue activeDataLink;
	local bool bDataLinkPlaySpawned;

	// Don't allow DataLinks to start if we're in PlayersOnly mode
	if (Level.bPlayersOnly)
		return False;

	activeDataLink = GetActiveDataLink(datalinkName);

	if (activeDataLink != None)
	{
		// Search to see if there's an active DataLinkPlay object 
		// before creating one

		if (dataLinkPlay == None)
		{
			datalinkPlay = Spawn(class'DataLinkPlay');
			bDataLinkPlaySpawned = True;
		}

		// Call SetConversation(), which returns 
		if (datalinkPlay.SetConversation(activeDataLink))
		{
			datalinkPlay.SetTrigger(datalinkTrigger);

			if (datalinkPlay.StartConversation(Self))
			{
				return True;
			}
			else
			{
				// Datalink must already be playing, or in queue
				if (bDataLinkPlaySpawned)
				{
					datalinkPlay.Destroy();
					datalinkPlay = None;
				}
				
				return False;
			}
		}
		else
		{
			// Datalink must already be playing, or in queue
			if (bDataLinkPlaySpawned)
			{
				datalinkPlay.Destroy();
				datalinkPlay = None;
			}
			return False;
		}
	}
	else
	{
		return False;
	}
}

function bool CanActorSeePlayer(Actor invokeActor)
{
	return FastTrace(invokeActor.Location);
}

// Returns True if the player is currently engaged in conversation
function bool InConversation()
{
	if ( conPlay == None )
	{
		return False;
	}
	else
	{
		if (conPlay.con != None)
			return ((conPlay.con.bFirstPerson == False) && (!conPlay.GetForcePlay()));
		else
			return False;
	}
}

function RemoveItemDuringConversation(Inventory item)
{
	if (item != None)
	{
		// take it out of our hand
		if (item == inHand)
			PutInHand(None);

		// Make sure it's removed from the inventory grid
		RemoveItemFromSlot(item);

		// Make sure the item is deactivated!
		if (item.IsA('DeusExWeaponInv'))
		{
			DeusExWeaponInv(item).ScopeOff();
			DeusExWeaponInv(item).LaserOff();
			log("Deactivated DeusExWeaponInv");
		}
		else if (item.IsA('DeusExPickup'))
		{
			// turn it off if it is on
			if (DeusExPickupInv(item).bActive)
				DeusExPickupInv(item).Activate();
		}
		
		if (conPlay != None)
			conPlay.SetInHand(None);
	}
}
	

/* ----------------------------------------------------------------- */
defaultproperties
{
		bCanWalkOffLedges=true
		bAvoidLedges=false		// don't get too close to ledges
		bStopAtLedges=false		// if bAvoidLedges and bStopAtLedges, Pawn doesn't try to walk along the edge at all

    TruePlayerName="JC Denton"
		BarkBindName="JCDenton"
    BindName="JCDenton"
    FamiliarName="JC Denton"  // CodeName is FamiliarName
    UnfamiliarName="JC Denton"


    Bob=0.00096
    strStartMap="01_NYC_UNATCOIsland"
	  Mesh=SkeletalMesh'DeusExCharacters.GM_Trench'
	  DrawType=DT_Mesh
		itemFovCorrection=75
	  GroundSpeed=320.0
		WaterSpeed=300.00
//    AirSpeed=4000.000000
    AccelRate=1000.000000
//     AccelRate=2048.000000
    JumpZ=300.000000
//    BaseEyeHeight=32.000000
    BaseEyeHeight=40.000000
    UnderWaterTime=20.000000
    Mass=150.000000
    Buoyancy=155.000000

    DodgeSpeedFactor=1.500000
    DodgeSpeedZ=210.000000
    AirControl=0.050000

    CrouchRadius=20.00
    CrouchHeight=16.0

    CollisionRadius=20.00
    CollisionHeight=43.5

    bUseCylinderCollision=true
    bCanPickupInventory=true
    bCanStrafe=True
	  DrawScale=1.0
	  bPhysicsAnimUpdate=false
    bCanSwim=true
	  bActorShadows=true
	  bCanClimbLadders=true
	  LadderSpeed=80.0

	  Skins(0)=Texture'DeusExCharacters.Skins.JCDentonTex0'
	  Skins(1)=Texture'DeusExCharacters.Skins.JCDentonTex2'
	  Skins(2)=Texture'DeusExCharacters.Skins.JCDentonTex3'
	  Skins(3)=Texture'DeusExCharacters.Skins.JCDentonTex0'
	  Skins(4)=Texture'DeusExCharacters.Skins.JCDentonTex1'
	  Skins(5)=Texture'DeusExCharacters.Skins.JCDentonTex2'
	  Skins(6)=Material'DeusExCharacters.Skins.SH_FramesTex4'
	  Skins(7)=Material'DeusExCharacters.Skins.FB_LensesTex5'

    JumpSound=Sound'DeusExSounds.Player.MaleJump'

	  bDetectable=true

    HealthHead=100
    HealthTorso=100
    HealthLegLeft=100
    HealthLegRight=100
    HealthArmLeft=100
    HealthArmRight=100
		Health=100

	  SkillPointsTotal=5000
	  SkillPointsAvail=5000
	  Credits=500
	  Energy=100.00
	  EnergyMax=100.00
    CombatDifficulty=1.00
    SoundVolume=64

    InventoryFull="You don't have enough room in your inventory to pick up the %s"
    TooMuchAmmo="You already have enough of that type of ammo"
    TooHeavyToLift="It's too heavy to lift"
    CannotLift="You can't lift that"
    NoRoomToLift="There's no room to lift that"
    CanCarryOnlyOne="You can only carry one %s"
    CannotDropHere="Can't drop that here"
    HandsFull="Your hands are full"
    NoteAdded="Note Received - Check DataVault For Details"
    GoalAdded="Goal Received - Check DataVault For Details"
    PrimaryGoalCompleted="Primary Goal Completed"
    SecondaryGoalCompleted="Secondary Goal Completed"
    EnergyDepleted="Bio-electric energy reserves depleted"
    AddedNanoKey="%s added to Nano Key Ring"
    HealedPointsLabel="Healed %d points"
    HealedPointLabel="Healed %d point"
    SkillPointsAward="%d skill points awarded"
    QuickSaveGameTitle="Quick Save"

    ControllerClass=class'DeusEx.DeusExPlayerController'

		bObjectNames=true					// Object names on/off
		bNPCHighlighting=true				// NPC highlighting when new convos
		bSubtitles=true					// True if Conversation Subtitles are on
		logTimeout=10					// Log Timeout Value
		maxLogLines=8					// Maximum number of log lines visible

    maxInvRows=6
    maxInvCols=5

    bUseCompressedPosition=false
    bAutoActivate=false

		fireDamage=1 // для тестирования пока 1
    Alliance=Player

    currentBeltNum=0
    bLOSHearing=false// true

    DefaultStartMap="01_NYC_UNATCOIsland"
}
