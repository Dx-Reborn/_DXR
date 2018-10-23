/* -------------------------------------------------------------------------------------
   Для хранения данных на время игры. Данные сохраняются при переходах с карты на карту. 
   При выходе из игры (завершение процесса) данные будут утеряны.
   
   Переменные можно добавлять и свои тоже.
------------------------------------------------------------------------------------- */

class DeusExGlobals extends Object config (DeusExGlobals);// transient;

const RF_Native = 0x04000000;

var string LevelName;
var bool CurrentSaveDirectoryCleared;
var int Flags;
var transient texture lastScreenShot; // последний сделанный скриншот (для фона)
var medicalBot lastMedBot; // указатель на медбота, которым воспользовался игрок. С ремонтным было проще )))

var config int MenuThemeIndex; // Store menu theme index here, so i can read it at any time, from any object.
var config int HUDThemeIndex; // Store HUD theme index here, so i can read it at any time, from any object.

/*-- Для переносимых декораций (чтобы можно было забрать коробку на другой уровень )))--*/
var string TravelDeco; // переносимая декорация
var rotator decoRotation; // вращение переносимой декорации

var DeusExPlayer player;

/*-- Заметки игрока --*/
struct SDeusExNote
{
  var() String text;				// Note text stored here.
  var() array<string> NoteText;
  var() bool bUserNote;		// True if this is a user-entered note
  var() name textTag;			// Text tag, used for DataCube notes to prevent the same note fromgetting added more than once
};
var() array<SDeusExNote> Notes;

/*-- Цели игрока --*/
struct SDeusExGoal
{
  var() Name goalName;			// Goal name, "GOAL_somestring"
  var() String text;				// Actual goal text
  var() bool bPrimaryGoal;		// True if Primary Goal
  var() bool bCompleted;			// True if Completed
};
var() array<SDeusExGoal> Goals;

/*-- История диалогов --*/
struct sConHistoryEvent
{
  var() String conSpeaker;			// Speaker
  var() String speech;				// Speech
  var() /*int soundID;*/ string SoundPath;				// Sound file associated with speech
};

struct sConHistory
{
  var() String conOwnerName;		// String name of conversation owner
  var() String strLocation;			// String description of location
  var() String strDescription;		// Conversation Description
  var() bool bInfoLink;			// True if InfoLink
  var() array<sConHistoryEvent> conHistoryEvents;
};
var() array<sConHistory> myConHistory;

struct sSavedAugs
{
  var() bool bHasIt;
  var() bool bBoosted;
  var() bool bIsActive;
  var() int HotKeyNum;
  var() int currentLevel;
  var() string InternalAugmentationName;
};
var() array<sSavedAugs> mySavedAugs;

// Содержит массив диалогов
//var(Conversation) transient array<ConDialogue> ArrayOfCons;


// На случай если флаги перестанут умещаться в TravelInfo, их нужно будет сохранять в пакет вместе с заметками и т.п.
//var() array<byte> FlagsArray;
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

var() int Ammo10mmInv;
var() int Ammo20mmInv;
var() int Ammo3006Inv;
var() int Ammo762mmInv;
var() int AmmoBatteryInv;
var() int AmmoDartFlareInv;
var() int AmmoDartInv;
var() int AmmoDartPoisonInv;
var() int AmmoEMPGrenadeInv;
var() int AmmoGasGrenadeInv;
var() int AmmoGraySpitInv;
var() int AmmoGreaselSpitInv;
var() int AmmoLAMInv;
var() int AmmoNanoVirusGrenadeInv;
var() int AmmoNapalmInv;
var() int AmmoPepperInv;
var() int AmmoPlasmaInv;
var() int AmmoRocketInv;
var() int AmmoRocketMiniInv;
var() int AmmoRocketRobotInv;
var() int AmmoRocketWPInv;
var() int AmmoSabotInv;
var() int AmmoShellInv;
var() int AmmoShurikenInv;
var() int AmmoNoneInv;
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

function resetAll()
{
 mySavedAugs.length = 0;
 myConHistory.length = 0;
 Notes.length = 0;
 Goals.length = 0;

 TravelDeco = "";
 lastMedBot = none;

 Ammo10mmInv = 0;
 Ammo20mmInv = 0;
 Ammo3006Inv = 0;
 Ammo762mmInv = 0;
 AmmoBatteryInv = 0;
 AmmoDartFlareInv = 0;
 AmmoDartInv = 0;
 AmmoDartPoisonInv = 0;
 AmmoEMPGrenadeInv = 0;
 AmmoGasGrenadeInv = 0;
 AmmoGraySpitInv = 0;
 AmmoGreaselSpitInv = 0;
 AmmoLAMInv = 0;
 AmmoNanoVirusGrenadeInv = 0;
 AmmoNapalmInv = 0;
 AmmoPepperInv = 0;
 AmmoPlasmaInv = 0;
 AmmoRocketInv = 0;
 AmmoRocketMiniInv = 0;
 AmmoRocketRobotInv = 0;
 AmmoRocketWPInv = 0;
 AmmoSabotInv = 0;
 AmmoShellInv = 0;
 AmmoShurikenInv = 0;
 AmmoNoneInv = 0;
}

function SaveAug(augmentation aug)
{
  local int x, a;

/* Такой Aug еще не сохранен, тогда добавить массив */
  if (GetSavedAug(aug.InternalAugmentationName) == "none")
  {
    x = mySavedAugs.Length;
    mySavedAugs.Length = x + 1; // добавить 1 к длине массива
    mySavedAugs[x].bHasIt = aug.bHasIt; // присвоить данные к элементу массива
    mySavedAugs[x].currentLevel = aug.currentLevel;
    mySavedAugs[x].InternalAugmentationName = aug.InternalAugmentationName;
    mySavedAugs[x].HotKeyNum = aug.HotKeyNum;
    mySavedAugs[x].bIsActive = aug.bIsActive;
  }
  else
  { /* Уже есть, тогда обновить данные */
    for(a=0; a<mySavedAugs.Length; a++)
    {
      if (mySavedAugs[a].InternalAugmentationName ==  aug.InternalAugmentationName)
      {
        mySavedAugs[a].bHasIt = aug.bHasIt; // присвоить данные к элементу массива
        mySavedAugs[a].currentLevel = aug.currentLevel;
        mySavedAugs[a].InternalAugmentationName = aug.InternalAugmentationName;
        mySavedAugs[a].HotKeyNum = aug.HotKeyNum;
        mySavedAugs[a].bIsActive = aug.bIsActive;
      }
    }
  }
}

//InternalAugmentationName
/* */
function string GetSavedAug(string intAugName)
{
  local int x;

  for(x=0; x<mySavedAugs.Length; x++)
  {
    if (mySavedAugs[x].InternalAugmentationName == intAugName)
    {
      return mySavedAugs[x].InternalAugmentationName;
    }
  }
  return "none";
}

/*-- Управление заметками --*/
function AddNote(optional array<String> strNote, optional bool bUserNote, optional bool bShowInLog, optional name NewTag)
{
  local int x;

  x = Notes.Length;
  Notes.Length = x + 1; // добавить 1 к длине массива
  Notes[x].NoteText = strNote; // присвоить данные к элементу массива
  Notes[x].bUserNote = bUserNote;
  Notes[x].textTag = NewTag;
}

function name GetNote(Name textTag)
{
  local int x;

  for(x=0; x<Notes.Length; x++)
  {
    if (Notes[x].textTag == textTag)
    {
      return Notes[x].textTag;
    }
  }
  return 'none';
}

// --== Управление задачами ==--
// ----------------------------------------------------------------------
// AddGoal()
//
// Adds a new goal to the list of goals the player is carrying around.
// ----------------------------------------------------------------------
function name AddGoal(Name goalName, bool bPrimaryGoal, optional string goalText)
{
  local int x;
  local name newGoal;

  newGoal = FindGoal(goalName);
  if (newGoal == 'none')
  {
   x = Goals.Length;
   Goals.Length = x + 1; // добавить 1 к длине массива
   Goals[x].goalName = goalName;			// Goal name, "GOAL_somestring"
   Goals[x].bPrimaryGoal = bPrimaryGoal;		// True if Primary Goal
   Goals[x].text = goalText;

   player.ClientMessage(player.GoalAdded);
   player.PlaySound(Sound'LogGoalAdded');

   return goalName;
  }
 return 'none';
}

// ----------------------------------------------------------------------
// FindGoal()
// ----------------------------------------------------------------------
function name FindGoal(Name goalName)
{
  local int x;

  for(x=0; x<Goals.Length; x++)
  {
    if (Goals[x].goalName == goalName)
    {
      return Goals[x].goalName;
    }
  }
 return 'none';
}

// ----------------------------------------------------------------------
// Adds a new goal to the list of goals the player is carrying around.
// ----------------------------------------------------------------------
exec function GoalAdd(Name goalName, String goalText, optional bool bPrimaryGoal)
{
  local int x;
  local name newGoal;

  if (!player.dxpc.bCheatsEnabled)
		return;

  newGoal = FindGoal(goalName);
  if (newGoal == 'none')
  {
   x = Goals.Length;
   Goals.Length = x + 1; // добавить 1 к длине массива
   Goals[x].text = goalText;
   Goals[x].goalName = goalName;			// Goal name, "GOAL_somestring"
   Goals[x].bPrimaryGoal = bPrimaryGoal;		// True if Primary Goal

   player.ClientMessage(player.GoalAdded);
   player.PlaySound(Sound'LogGoalAdded');
  }
}

// ----------------------------------------------------------------------
// Sets a goal as a Primary Goal
// ----------------------------------------------------------------------
exec function GoalSetPrimary(Name goalName, bool bPrimaryGoal)
{
	local name goal;
	local int x;

	if (!player.dxpc.bCheatsEnabled)
      return;

	goal = FindGoal(goalName);

	if (goal != 'none')

  for(x=0; x<Goals.Length; x++)
  {
    if (Goals[x].goalName == goalName)
    {
      Goals[x].bPrimaryGoal = bPrimaryGoal;
    }
  }
}

// ----------------------------------------------------------------------
// GoalCompleted()
//
// Looks up the goal and marks it as completed.
// ----------------------------------------------------------------------
function GoalCompleted(Name goalName)
{
	local Name goal;
	local int x;

	// Loop through all the goals until we hit the one we're
	// looking for.
	goal = FindGoal(goalName);

	if (goal != 'none')
	{
    for(x=0; x<Goals.Length; x++)
    {
      if (Goals[x].goalName == goal /*goalName*/)
      {
        // Only mark a goal as completed once!
        if (!goals[x].bCompleted)
        {
           goals[x].bCompleted = true;
			     player.PlaySound(Sound'LogGoalCompleted');

           // Let the player know
			     if (goals[x].bPrimaryGoal)
				   player.ClientMessage(player.PrimaryGoalCompleted);
			       else
				   player.ClientMessage(player.SecondaryGoalCompleted);
		    }
		  }
    }
  }
}

// ----------------------------------------------------------------------
// Deletes the specified goal
// Returns True if the goal successfully deleted
// ----------------------------------------------------------------------
function bool DeleteGoal(name goalToDelete)
{
  local int z;

  if (FindGoal(goalToDelete) == 'none')
      return false;

   for(z=0; z<Goals.Length; z++)
   {
     if (Goals[z].goalName == goalToDelete)
         goals.remove(z, 1);
          break;
           return true;
   }
}

// ----------------------------------------------------------------------
// DeleteAllGoals()
//
// Deletes *ALL* Goals
// ----------------------------------------------------------------------
function DeleteAllGoals()
{
	Goals.Length = 0;
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
  local int z;

   for(z=0; z<Goals.Length; z++)
   {
     if ((Goals[z].bPrimaryGoal) || (goals[z].bPrimaryGoal && goals[z].bCompleted))
         goals.remove(z, 1);
   }
}
// --== !Управление задачами ==--

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
function AssignEvents(Actor LinkedActors[10], Actor invokeActor, levelInfo level, conDialogue con)
{
	local DXRPawn pawn;
	local DeusExDecoration deco;

	foreach level.DynamicActors(class'DXRPawn',pawn)
          AssignEventsToActor(LinkedActors, invokeActor, pawn, con);

	foreach level.DynamicActors(class'DeusExDecoration',deco)
          AssignEventsToActor(LinkedActors, invokeActor, deco, con);
}


function AssignEventsToActor(Actor LinkedActors[10], Actor invokeActor, Actor LinkActor, conDialogue con)
{
  local int i;

	if (LinkActor.GetBindName() == "" || (invokeActor != LinkActor && invokeActor != none && invokeActor.GetBindName() == LinkActor.GetBindName()))
		return;

  for (i=0; i<con.EventList.length; i++)
  {
		if (AssignConEvent(invokeActor,LinkActor,con, con.eventList[i]))
			AddAssignedActor(LinkedActors, LinkActor);
  }
}

function AddAssignedActor(Actor LinkedActors[10], Actor LinkActor)
{
	local int i;

	for (i=0; i<10; i++)
	{
		if (LinkedActors[i] == LinkActor)
		{
			return;
		}
		if (LinkedActors[i] != none)
		{
			continue;
		}
		LinkedActors[i] = LinkActor;
    return;
	}
}

function AssignActorEvents(Actor LinkActor, ConDialogue con)
{
  local int i;

  for (i=0; i<con.EventList.length; i++)
  {
    AssignConEvent(LinkActor, LinkActor, con, con.EventList[i]);
  }
}
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
function bool AssignConEvent(Actor invokeActor, Actor LinkActor, ConDialogue con, ConEvent event)
{
  local bool bResult;

  if (ConEventTransferObject(event) != none) // Transfer Item
  {
    bResult = false;

    if ((LinkActor.GetBarkBindName() == ConEventTransferObject(event).fromName && con.bFirstPerson) || LinkActor.GetBindName() == ConEventTransferObject(event).fromName)
	  {
		  ConEventTransferObject(event).fromActor = LinkActor;
		  bResult = true;
	  }
	  if ((LinkActor.GetBarkBindName() == ConEventTransferObject(event).toName && con.bFirstPerson) || LinkActor.GetBindName() == ConEventTransferObject(event).toName)
	  {
		  ConEventTransferObject(event).toActor = LinkActor;
		  bResult = true;
    }
     ConEventTransferObject(event).giveObject = class<inventory>(DynamicLoadObject(ConEventTransferObject(event).CheckTransferObjectPackage $ ConEventTransferObject(event).objectName$"Inv", class'Class', true));
	   return bResult;
  }
  else if (ConEventCheckObject(event) != none) // Check item
  {
     if (Left(ConEventCheckObject(event).objectName, 3) == "NK_")
         ConEventCheckObject(event).checkObject = none;
     else
         ConEventCheckObject(event).checkObject = class<inventory>(DynamicLoadObject(ConEventCheckObject(event).CheckTransferObjectPackage $ ConEventCheckObject(event).objectName$"Inv", class'Class', true));
     return false;
  }
  else if (ConEventSpeech(event) != none)  // Speech
  {
     if (LinkActor.GetBindName() == ConEventSpeech(event).speakerName || (invokeActor == LinkActor && LinkActor.GetBarkBindName() == ConEventSpeech(event).speakerName))
     {
		     ConEventSpeech(event).speaker = LinkActor;
		     return true;
	   }
	   if (LinkActor.GetBindName() == ConEventSpeech(event).speakingToName || (invokeActor == LinkActor && LinkActor.GetBarkBindName() == ConEventSpeech(event).speakingToName))
	   {
		     ConEventSpeech(event).speakingTo = LinkActor;
		     return true;
	   }
	   return false;
  }
  else if (ConEventAnimation(event) != none) // Play Animation (Not implemented for now)
  {
     if ((LinkActor.GetBarkBindName() == ConEventAnimation(event).eventOwnerName && con.bFirstPerson) || LinkActor.GetBindName() == ConEventAnimation(event).eventOwnerName)
     {
         ConEventAnimation(event).eventOwner = LinkActor;
         return true;
     }
     return false;
  }
  else if (ConEventTrade(event) != none) // Start trade (Not implemented for now)
  {
     if ((LinkActor.GetBarkBindName() == ConEventTrade(event).eventOwnerName && con.bFirstPerson) || LinkActor.GetBindName() == ConEventTrade(event).eventOwnerName)
     {
         ConEventTrade(event).eventOwner = LinkActor;
         return true;
	   }
	   return false;
  }
}

function string GetRandomLabel(ConEventRandom ev)
{
	local int labelIndex;

	if (ev.labels.Length > 0)
	{
		if (ev.cycleIndex == ev.labels.Length)
			ev.bLabelsCycled = true;

		if (!ev.bCycleEvents || ev.bCycleRandom && ev.bLabelsCycled)
			labelIndex = Rand(ev.labels.Length);

		else if (!ev.bCycleOnce || ev.cycleIndex!=(ev.labels.Length -1))
			labelIndex = ev.cycleIndex++ % ev.labels.Length;

		else
			labelIndex = ev.labels.Length -1;

		return ev.labels[labelIndex];
	}
	else
		return "";
}

// GetLabel() and GetLabelCount() was used only in The Nameless mod.
function String GetLabel(int labelIndex, ConEventRandom event)
{
	if (labelIndex >= 0 && labelIndex < event.labels.Length)
		return event.labels[labelIndex];
	else
		return "";
}


/*--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

static function DeusExGlobals GetGlobals() {
	local GameManager gm;

	gm = class'GameManager'.static.GetGameManager();
	if (gm.GlobalObject == None) {
		// We fool garbage collector to protect our global object from destruction
		gm.GlobalObject = new(gm, "", RF_Public | RF_Transient | RF_Native) class'DeusExGlobals';
	}
	return DeusExGlobals(gm.GlobalObject);
}

defaultproperties {
	LevelName = "Intro"
	CurrentSaveDirectoryCleared = false
	Flags = 0

	TravelDeco=""
}
