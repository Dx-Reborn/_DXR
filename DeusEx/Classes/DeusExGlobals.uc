/* -------------------------------------------------------------------------------------
  Для хранения данных на время игры. Данные сохраняются при переходах с карты на карту. 
  При выходе из игры (завершение процесса) данные будут утеряны.
   
  Переменные можно добавлять и свои тоже.
------------------------------------------------------------------------------------- */

class DeusExGlobals extends Object config (DeusExGlobals);

const RF_Native = 0x04000000;

var string LevelName;
var bool CurrentSaveDirectoryCleared;
var int Flags;
var transient texture lastScreenShot; // последний сделанный скриншот (для фона)
var medicalBot lastMedBot; // указатель на медбота, которым воспользовался игрок. С ремонтным было проще )))
//var HudOverlay_ConWindowThird conWindow;

var config int MenuThemeIndex; // Store menu theme index here, so i can read it at any time, from any object.
var config int HUDThemeIndex; // Store HUD theme index here, so i can read it at any time, from any object.
var config string MenuTheme;
var config string HUDTheme;

var config int FS_Preset;
var config string FS_PresetString;

/*-- Еще немного настроек --*/
var config bool bBurnStaticObjects; // поверхности (BSP && StaticMeshActor) будут гореть от огнемета?
var config bool bInfiniteAmmoForTurrets; // Бесконечные патроны для турелей?
var config bool bDelayedDecoExplosions; // Взрывающиеся декорации и трупы взрываются не сразу?

var config bool bUseAltWeaponsSounds; // Использовать подхват из дополнительные ресурсы
var config int WS_Preset;
var config string WS_PresetString;

var config bool bHitmarkerOn; // Перемещено из PlayerPawn


// Использовать эффект текста, появляющегося за курсором?
var config bool bUseCursorEffects;

/*-- Для переносимых декораций (чтобы можно было забрать коробку на другой уровень )))--*/
var string TravelDeco; // переносимая декорация
var rotator decoRotation; // вращение переносимой декорации

var DeusExPlayer player;
var DeusExLevelInfo DxLevelInfo; // for faster access from GetLevelInfo(). Set in GameInfoExt::InitGame()

struct SInventoryItem
{
  var() int positionX;
  var() int positionY;
  var() int BeltPosition;
  var() bool bInObjectBelt;
  var() class<Inventory> itemClass;
};
var() array<SInventoryItem> InvItems;

/*-- Заметки игрока --*/
struct SDeusExNote
{
  var() String text;                // Note text stored here.
  var() array<string> NoteText;
  var() bool bUserNote;     // True if this is a user-entered note
  var() name textTag;           // Text tag, used for DataCube notes to prevent the same note fromgetting added more than once
};
var() array<SDeusExNote> Notes;

/*-- Цели игрока --*/
struct SDeusExGoal
{
  var() Name goalName;          // Goal name, "GOAL_somestring"
  var() String text;                // Actual goal text
  var() bool bPrimaryGoal;      // True if Primary Goal
  var() bool bCompleted;            // True if Completed
};
var() array<SDeusExGoal> Goals;

/*-- История диалогов --*/
/*struct sConHistoryEvent
{
  var() String conSpeaker;          // Speaker
  var() String speech;              // Speech
  var() string SoundPath;              // Sound file associated with speech
};

struct sConHistory
{
  var() String conOwnerName;        // String name of conversation owner
  var() String strLocation;         // String description of location
  var() String strDescription;      // Conversation Description
  var() bool bInfoLink;         // True if InfoLink
  var() array<sConHistoryEvent> conHistoryEvents;
};
var() array<sConHistory> myConHistory;
*/
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

var ConPlayBase ConPlayBase;
var ConHistory conHistory;           // Conversation History linked list

// Флаги теперь здесь, поскольку в TravelInfo они уже умещаются.
var() array<byte> RawByteFlags;
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

final function ConHistory CreateHistoryObject()
{
    local ConHistory ch;
    ch = new(Outer) class'ConHistory';

    return ch;
}

final function ConHistoryEvent CreateHistoryEvent()
{
    local ConHistoryEvent ce;
    ce = new(Outer) class'ConHistoryEvent';

    return ce;
}

function SaveInventoryItem(inventory anItem, int posX, int posY, int beltPos)
{
   local int i;

   if (beltPos == 0)
       beltPos = 1;

   if (InvItems.Length == 0)
   {
       AddAnItem(anItem, posX, posY, beltPos);
       return;
   }

   for (i=0; i<InvItems.Length;i++)
   {
      if (InvItems[i].itemClass == anItem.class) // Перезаписать
      {
         log("Overwriting saved item" @ anItem,'SaveInventory');
         InvItems[i].positionX = posX;
         InvItems[i].positionY = posY;
         InvItems[i].BeltPosition = BeltPos;
         InvItems[i].bInObjectBelt = anItem.bInObjectBelt;
         return;
      }
      else 
      {
        AddAnItem(anItem, posX, posY, beltPos);
        return;
      }
   }
}

private function AddAnItem(inventory anItem, int posX, int posY, int beltPos)
{
  local int i;

  i = InvItems.Length;
  InvItems.Length = i+1;

    InvItems[i].itemClass = anItem.class;
    InvItems[i].positionX = posX;
    InvItems[i].positionY = posY;
    InvItems[i].BeltPosition = BeltPos;
    InvItems[i].bInObjectBelt = anItem.bInObjectBelt;

    log("Added saved item" @ anItem,'SaveInventory');
}

function RemoveInventoryItem(class<inventory> anItem)
{
   //
}

function resetAll()
{
 mySavedAugs.length = 0;
// myConHistory.length = 0;
 Notes.length = 0;
 Goals.length = 0;

 TravelDeco = "";
 lastMedBot = none;
}

function SaveAug(augmentation aug)
{
   local int x, a;

   // Такой Aug еще не сохранен, тогда добавить массив
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
   {  // Уже есть, тогда обновить данные
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
   Goals[x].goalName = goalName;            // Goal name, "GOAL_somestring"
   Goals[x].bPrimaryGoal = bPrimaryGoal;        // True if Primary Goal
   Goals[x].text = goalText;

   if (player.ConPlay.dMsg != none) // DXR: Show these messages later.
       player.ConPlay.dMsg.AddMessage(player.GoalAdded, sound'DeusExSounds.UserInterface.LogGoalAdded');
   else
   {
   player.ClientMessage(player.GoalAdded);
   player.PlaySound(Sound'LogGoalAdded');
   }

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
     Goals[x].goalName = goalName;            // Goal name, "GOAL_somestring"
     Goals[x].bPrimaryGoal = bPrimaryGoal;        // True if Primary Goal

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
          Goals[x].bPrimaryGoal = bPrimaryGoal;
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
