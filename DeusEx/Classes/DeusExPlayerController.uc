//=============================================================================
// DeusExPlayerController
// Контроллер игрока
// В отличие от UE1/1.5, здесь управление игрока обрабатывается контроллером,
// подобно этому, искуственный интеллект управляется AiController...
//=============================================================================

class DeusExPlayerController extends DXRSaveSystem;

event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
   Super.PlayerCalcView(ViewActor, CameraLocation, CameraRotation);

   if (pawn != none)
   {
      // check for spy drone and freeze player's view
      if (Human(pawn).bSpyDroneActive)
      {
         if (Human(pawn).aDrone != None)
         {
            // First-person view.
            CameraLocation = Human(pawn).Location;
            CameraLocation.Z += Human(pawn).EyeHeight;
            CameraLocation += Human(pawn).WalkBob;
            return;
         }
      }

      // Check if we're in first-person view or third-person.  If we're in first-person then
      // we'll just render the normal camera view.  Otherwise we want to place the camera
      // as directed by the conPlay.cameraInfo object.
      if (bBehindView && (!Human(pawn).InConversation()) && (pawn != none))
      {
          Super.PlayerCalcView(ViewActor, CameraLocation, CameraRotation);
          return;
      }

      if ((!Human(pawn).InConversation()) || (Human(pawn).conPlay.GetDisplayMode() == DM_FirstPerson))
      {
         // First-person view.
         ViewActor = Human(pawn);
         CameraRotation = GetViewRotation();
         CameraLocation = Human(pawn).Location;
         CameraLocation.Z += Human(pawn).EyeHeight;
         CameraLocation += Human(pawn).WalkBob;
         return;
      }

      // Allow the ConCamera object to calculate the camera position and 
      // rotation for us (in other words, take this sloppy routine and 
      // hide it elsewhere).
      if (Human(pawn).conPlay.cameraInfo.CalculateCameraPosition(ViewActor, CameraLocation, CameraRotation) == false)
          Super.PlayerCalcView(ViewActor, CameraLocation, CameraRotation);
   }

/*      if (DeusExHUD(myHUD) != None)
      {
          DeusExHUD(myHUD).debug_CamLoc = CameraLocation;
          DeusExHUD(myHUD).debug_CamRot = CameraRotation;
      }*/
}

//------------------------------------------------
// Вспомогательные команды (читы)
//------------------------------------------------
exec function Fly()
{
if (!bCheatsEnabled)
return;

    if ( Pawn != None )
    {
        Pawn.UnderWaterTime = Pawn.Default.UnderWaterTime;  
        ClientMessage("You feel much lighter");
        Pawn.SetCollision(true, true , true);
        Pawn.bCollideWorld = true;
        GotoState('PlayerFlying');
    }
}

exec function Walk()
{   
if (!bCheatsEnabled)
return;

    if ( Pawn != None )
    {
        Pawn.UnderWaterTime = Pawn.Default.UnderWaterTime;  
        Pawn.SetCollision(true, true , true);
        Pawn.SetPhysics(PHYS_Walking);
        Pawn.bCollideWorld = true;
        GotoState('PlayerWalking');
    }
}

exec function ToggleFlyWalk()
{
if (!bCheatsEnabled)
return;

    if(IsInState('PlayerFlying'))
        Walk();
    else
        Fly();
}

exec function SpawnMass(Name ClassName, optional int TotalCount)
{
    local actor        spawnee;
    local vector       spawnPos;
    local vector       center;
    local rotator      direction;
    local int          maxTries;
    local int          count;
    local int          numTries;
    local float        maxRange;
    local float        range;
    local float        angle;
    local class<Actor> spawnClass;
    local string        holdName;

    if (!bCheatsEnabled)
        return;

    if (instr(ClassName, ".") == -1)
        holdName = "DeusEx." $ ClassName;
    else
        holdName = "" $ ClassName;  // barf

    spawnClass = class<actor>(DynamicLoadObject(holdName, class'Class'));
    if (spawnClass == None)
    {
        ClientMessage("Illegal actor name "$GetItemName(String(ClassName)));
        return;
    }

    if (totalCount <= 0)
        totalCount = 10;
    if (totalCount > 250)
        totalCount = 250;
    maxTries = totalCount*2;
    count = 0;
    numTries = 0;
    maxRange = sqrt(totalCount/3.1416)*4*SpawnClass.Default.CollisionRadius;

    direction = GetViewRotation();
    direction.pitch = 0;
    direction.roll  = 0;
    center = Location + Vector(direction)*(maxRange+SpawnClass.default.CollisionRadius+CollisionRadius+20);
    while ((count < totalCount) && (numTries < maxTries))
    {
        angle = FRand()*3.14159265359*2;
        range = sqrt(FRand())*maxRange;
        spawnPos.X = sin(angle)*range;
        spawnPos.Y = cos(angle)*range;
        spawnPos.Z = 0;
        spawnee = spawn(SpawnClass,,,center+spawnPos, GetViewRotation());
        if (spawnee != None)
            count++;
        numTries++;
    }

    ClientMessage(count$" actor(s) spawned");

}

exec function Summon(string ClassName)
{
    local class<actor> NewClass;
    local vector SpawnLoc;

  if (!bCheatsEnabled)
  return;

    log("Fabricate " $ ClassName);
    NewClass = class<actor>(DynamicLoadObject(ClassName, class'Class'));
    if( NewClass!=None )
    {
        if (Pawn != None)
            SpawnLoc = Pawn.Location;
        else
            SpawnLoc = Location;
        Spawn(NewClass,,,SpawnLoc + 72 * Vector(Rotation) + vect(0,0,1) * 15);
    }
}

// Переходы по картам
event TravelPostAccept()
{
  super.TravelPostAccept();
  Human(pawn).TravelPostAccept();
}

event PreClientTravel()
{
  local actor act;

    super.PreClientTravel();

         foreach AllActors(class'Actor', act)
         {
            act.PreTravel();
         }
//  Human(pawn).PreClientTravel();
} 

//================================================================================================================
// Dump player inventory and ammo types to log
exec function DumpInv()
{
    local Inventory inv;
//  local DeusExWeapon weap;

        Log("********************DumpInv(): Player inventory: BEGIN********************");
            inv = Pawn.Inventory;
            while (inv != None)
                {
                    Log("   "$inv);
                    /*weap = DeusExWeapon(inv);
                    if (weap != None)
                    Log("      "$weap.AmmoName);*/
                    inv = inv.inventory;
                }
        Log("********************DumpInv(): Player inventory END********************");
}

exec function KillPl()
{
   class'ObjectManager'.static.SetObjectFlags(player, RF_Transient);
}

function bool PlayerCanRestart(PlayerController aPlayer)
{
    return false;
}

exec function CDObj(class objClass, string objName, string packageName)
{
    Level.Game.CreateDataObject(objClass, objName, packageName);
}

exec function sp(string packageName)
{
        Level.Game.SavePackage(packageName);
}

// Функции для тестирования функций :)
/*exec function saveflags()
{
    DeusExGameInfo(Level.Game).saveflags();
}

exec function loadflags()
{
    DeusExGameInfo(Level.Game).loadflags();
}

exec function RemoveAllFlags()
{
    DeusExGameInfo(Level.Game).RemoveAllFlags();
}*/


/*
native final function Manifest  GetSavedGames();
native final function Object    CreateDataObject ( class objClass, string objName, string packageName );
native final function bool      DeleteDataObject ( class objClass, string objName, string packageName );
native final function Object    LoadDataObject   ( class objClass, string objName, string packageName );
native final iterator function  AllDataObjects   ( class objClass, out Object obj, string packageName );
native final function bool      SavePackage      ( string packageName );
native final function bool      DeletePackage    ( string packageName );*/
/*  Variable is too large (x bytes, 255 max)
    Static arrays and large structs can only be accessed from outside the object containing them 
when they use less than 255 bytesx of memory. This restriction may seem weird, but you'll have to live with it. 
Try using a dynamic array instead of a static one, break doen the struct into several class properties or use
 accessor functions to work around this restriction. */

exec function ViewSPawn()
{
  if (!bCheatsEnabled)
  return;

  consoleCommand("ViewClass Pawn");
}

// -== Для использования в CameraPoint ==-
state Paralyzed
{
    ignores all;

    exec function Fire(optional float F)
    {
      if (GetLevelInfo().MapName~="00_Intro") //|| (GetFlagBase().GetBool('PlayerTraveling')))
          return;
      else
          ClientOpenMenu(class'GameEngine'.default.MainMenuClass);
    }

    exec function AltFire(optional float F)
    {
       Fire(F);
    }

    event PlayerTick(float deltaTime)
    {
        Human(pawn).UpdateInHand();
//      ShowHud(False);
        Human(pawn).bPhysicsAnimUpdate = false;
        ViewFlash(deltaTime);
        // Почему я должна тебя заставлять?
        Human(pawn).EyeHeight = 0.0;//4;
        Human(pawn).BaseEyeHeight = 0.0;//4;
    }

Begin:
    if (Human(pawn).bOnFire)
        Human(pawn).ExtinguishFire();

        Human(pawn).bDetectable = False;

    // put away your weapon
    if (Human(pawn).Weapon != None)
    {
//      Human(pawn).Weapon.bHideWeapon = True;
        Human(pawn).Weapon = None;
        Human(pawn).PutInHand(None);
    }

    // can't carry decorations across levels
    if (Human(pawn).CarriedDecoration != None)
    {
        Human(pawn).CarriedDecoration.Destroy();
        Human(pawn).CarriedDecoration = None;
    }

    Human(pawn).SetPhysics(PHYS_Flying);//None);
    Human(pawn).PlayAnim('Still');
//  Human(pawn).BaseEyeHeight=0.0;
    Stop;

Letterbox:
    if (Human(pawn).bOnFire)
        Human(pawn).ExtinguishFire();

    Human(pawn).bDetectable = False;

    // put away your weapon
    if (Human(pawn).Weapon != None)
    {
//      Human(pawn).Weapon.bHideWeapon = True;
        Human(pawn).Weapon = None;
        Human(pawn).PutInHand(None);
    }

    // can't carry decorations across levels
    if (Human(pawn).CarriedDecoration != None)
    {
        Human(pawn).CarriedDecoration.Destroy();
        Human(pawn).CarriedDecoration = None;
    }

    Human(pawn).SetPhysics(PHYS_Flying); //None);
    Human(pawn).PlayAnim('Still');
//  Human(pawn).BaseEyeHeight=0.0;
//  if (rootWindow != None)
//      rootWindow.NewChild(class'CinematicWindow');
}

exec function DateTime()
{
  local string atime, year, month, dayOfWeek, day;

  atime = class'DxUtil'.static.SecondsToTime(human(pawn).savetime);
  clientmessage(atime);

  atime = Level.Hour$":"$level.Minute$":"$level.Second$"."$level.Millisecond;
  year = string(level.Year);
  month = class'DxUtil'.static.GetMonthStr(level.Month);
  day = string(level.day);
  dayOfWeek = class'DxUtil'.static.GetDayOfWeekRus(Level.DayOfWeek);

  clientMessage("Year = "$year$", month = "$month$", day of week = "$dayOfWeek$"->"$Level.DayOfWeek$", day of month = "$day$" time(hh/mm/.ms) ="$atime);
}

exec function DateTimeAmerican()
{
  local string atime, year, month, dayOfWeek, day;

  atime = class'DxUtil'.static.SecondsToTime(human(pawn).savetime);
  clientmessage(atime);

  atime = Level.Hour$":"$level.Minute$":"$level.Second$"."$level.Millisecond;
  year = string(level.Year);
  month = class'DxUtil'.static.GetMonthStr(level.Month);
  day = string(level.day);
  dayOfWeek = class'DxUtil'.static.GetDayOfWeekStr(Level.DayOfWeek);

  clientMessage("Year = "$year$", month = "$month$", day of week = "$dayOfWeek$"->"$Level.DayOfWeek$", day of month = "$day$" time(hh/mm/ss/.ms) ="$atime);
}

event object OpenMenuEx(string Menu, optional bool bDisconnect,optional string Msg1, optional string Msg2)
{
    local object wtf;

    // GUIController calls UnpressButtons() after it's been activated...once active, it swallows
    // all input events, preventing GameEngine from parsing script execs commands -- rjp
    wtf = DeusExGuiController(Player.GUIController).OpenMenuEx(Menu, Msg1, Msg2);
    if (wtf != none)
        UnPressButtons();

    if (bDisconnect)
    {
        // Use delayed console command, in case the menu that was opened had bDisconnectOnOpen=True -- rjp
        if (Player.Console != None)
            Player.Console.DelayedConsoleCommand("DISCONNECT");
        else ConsoleCommand("Disconnect");
    }
  return wtf;   
}

/*singular event UnPressButtons()
{
    bFire = 0;
    bAltFire = 0;
    //bDuck = 0;
    bRun = 0;
    bVoiceTalk = 0;
//    ResetInput();
} */


defaultproperties
{
    MidGameMenuClass="DXRMenu.DeusExMidGameMenu"
    PawnClass=class'DeusEx.JCDentonMale'
    bCheatsEnabled=true
}




