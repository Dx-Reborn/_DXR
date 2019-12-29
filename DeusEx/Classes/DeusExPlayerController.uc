//=============================================================================
// DeusExPlayerController
// Контроллер игрока
// В отличие от UE1/1.5, здесь управление игрока обрабатывается контроллером,
// подобно этому, искуственный интеллект управляется AiController...
//=============================================================================

class DeusExPlayerController extends DXRSaveSystem;

event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation)
{
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

  if ((!Human(pawn).InConversation()) || (Human(pawn).conPlay.GetDisplayMode() == DM_FirstPerson ))
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

    direction = Pawn.GetViewRotation();
    direction.pitch = 0;
    direction.roll  = 0;
    center = pawn.Location + Vector(direction)*(maxRange+SpawnClass.default.CollisionRadius+pawn.CollisionRadius+20);
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
    NewClass = class<actor>( DynamicLoadObject(ClassName, class'Class'));
    if( NewClass!=None )
    {
        if ( Pawn != None )
            SpawnLoc = Pawn.Location;
        else
            SpawnLoc = Location;
        Spawn( NewClass,,,SpawnLoc + 72 * Vector(Rotation) + vect(0,0,1) * 15 );
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
//  local DeusExWeaponInv weap;

        Log("********************DumpInv(): Player inventory: BEGIN********************");
            inv = Pawn.Inventory;
            while (inv != None)
                {
                    Log("   "$inv);
                    /*weap = DeusExWeaponInv(inv);
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
// ----------------------------------------------------------------------
// ClientFlash()
//
// copied from Engine.PlayerPawn
// modified to add the new flash to the current flash
// ----------------------------------------------------------------------
/*function ClientFlash(float scale, vector fog)
{
    FlashScale = (scale + (1 - ScreenFlashScaling) * (1 - Scale)) * vect(1,1,1);
      flashfog = ScreenFlashScaling * 0.001 * fog;
}*/

// ----------------------------------------------------------------------
// ViewFlash()
// modified so that flash doesn't always go away in exactly half a second.
// ---------------------------------------------------------------------
/*function ViewFlash(float DeltaTime)
{
    local vector goalFog;
    local float goalscale, delta, Step;
    local PhysicsVolume ViewVolume;

    delta = FMin(0.1, DeltaTime);
    goalScale = 1 + ConstantGlowScale;
    goalFog = vect(0,0,0) + ConstantGlowFog;

    if ( Pawn != None )
    {
        if ( bBehindView )
            ViewVolume = Level.GetPhysicsVolume(CalcViewLocation);
        else
            ViewVolume = Pawn.HeadVolume;

            goalScale += ViewVolume.ViewFlash.X;
            goalFog += ViewVolume.ViewFog;
    }                               
    Step = deltaStep * delta * ScreenFlashScaling;
    FlashScale.X = UpdateFlashComponent(FlashScale.X,step,goalScale);
    FlashScale = FlashScale.X * vect(1,1,1);

    FlashFog.X = UpdateFlashComponent(FlashFog.X * flashFogMult,step,goalFog.X);
    FlashFog.Y = UpdateFlashComponent(FlashFog.Y * flashFogMult,step,goalFog.Y);
    FlashFog.Z = UpdateFlashComponent(FlashFog.Z * flashFogMult,step,goalFog.Z);
}*/
//------------------------------------------------------------------
/*function ViewFlash(float DeltaTime)
{
    local float delta;
    local vector goalFog;
    local float goalscale, ReductionFactor;

   ReductionFactor = 2;
   if (FlashTimer > 0)
   {
      if (FlashTimer < Deltatime)
      {
         FlashTimer = 0;
      }
      else
      {
         ReductionFactor = 0;
         FlashTimer -= Deltatime;
      }
   }

   if ( bNoFlash )
    {
        InstantFlash = 0;
        InstantFog = vect(0,0,0);
    }

    delta = FMin(0.1, DeltaTime);
    goalScale = 1 + DesiredFlashScale + ConstantGlowScale + HeadRegion.Zone.ViewFlash.X; 
    goalFog = DesiredFlashFog + ConstantGlowFog + HeadRegion.Zone.ViewFog;
    DesiredFlashScale -= DesiredFlashScale * ReductionFactor * delta;  
    DesiredFlashFog -= DesiredFlashFog * ReductionFactor * delta;
    FlashScale.X += (goalScale - FlashScale.X + InstantFlash) * 10 * delta;
    FlashFog += (goalFog - FlashFog + InstantFog) * 10 * delta;
    InstantFlash = 0;
    InstantFog = vect(0,0,0);

    if ( FlashScale.X > 0.981 )
        FlashScale.X = 1;
    FlashScale = FlashScale.X * vect(1,1,1);

    if ( FlashFog.X < 0.019 )
        FlashFog.X = 0;
    if ( FlashFog.Y < 0.019 )
        FlashFog.Y = 0;
    if ( FlashFog.Z < 0.019 )
        FlashFog.Z = 0;
}*/


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

state Dead
{
ignores SeePlayer, HearNoise, KilledBy, SwitchWeapon, NextWeapon, PrevWeapon;

    exec function ThrowWeapon()
    {
        //clientmessage("Throwweapon while dead, pawn "$Pawn$" health "$Pawn.health);
    }

    function bool IsDead()
    {
        return true;
    }

    exec function Fire(optional float F)
    {
       ConsoleCommand("OPEN DxOnly");
    }

    exec function AltFire(optional float F)
    {
        Fire(F);
    }

    function PlayerMove(float DeltaTime)
    {
        local vector X,Y,Z;
        local rotator ViewRotation;

        if ( !bFrozen )
        {
            if ( bPressedJump )
            {
                Fire(0);
                bPressedJump = false;
            }
            GetAxes(Rotation,X,Y,Z);
            // Update view rotation.
            ViewRotation = Rotation;
            ViewRotation.Yaw += 32.0 * DeltaTime * aTurn;
            ViewRotation.Pitch += 32.0 * DeltaTime * aLookUp;
            if (Pawn != None)
                ViewRotation.Pitch = Pawn.LimitPitch(ViewRotation.Pitch);
            SetRotation(ViewRotation);
            if ( Role < ROLE_Authority ) // then save this move and replicate it
                ReplicateMove(DeltaTime, vect(0,0,0), DCLICK_None, rot(0,0,0));
        }
        else if ( (TimerRate <= 0.0) || (TimerRate > 1.0) )
            bFrozen = false;

        ViewShake(DeltaTime);
        ViewFlash(DeltaTime);
    }

    function FindGoodView()
    {
        local vector cameraLoc;
        local rotator cameraRot, ViewRotation;
        local int tries, besttry;
        local float bestdist, newdist;
        local int startYaw;
        local actor ViewActor;

        ////log("Find good death scene view");
        ViewRotation = Rotation;
        ViewRotation.Pitch = 56000;
        tries = 0;
        besttry = 0;
        bestdist = 0.0;
        startYaw = ViewRotation.Yaw;

        for (tries=0; tries<16; tries++)
        {
            cameraLoc = ViewTarget.Location;
            SetRotation(ViewRotation);
            PlayerCalcView(ViewActor, cameraLoc, cameraRot);
            newdist = VSize(cameraLoc - ViewTarget.Location);
            if (newdist > bestdist)
            {
                bestdist = newdist;
                besttry = tries;
            }
            ViewRotation.Yaw += 4096;
        }

        ViewRotation.Yaw = startYaw + besttry * 4096;
        SetRotation(ViewRotation);
    }

    function Timer()
    {
        if (!bFrozen)
            return;

        bFrozen = false;
        bPressedJump = false;
    }

    function BeginState()
    {
      local Actor A;

      if ( (Pawn != None) && ((Pawn.Controller == self) || (Pawn.Controller == None)) )
            Pawn.Controller = None;
      EndZoom();
      CameraDist = Default.CameraDist;
      FOVAngle = DesiredFOV;
      Pawn = None;
      Enemy = None;
//      bBehindView = true;
      bFrozen = true;
        bJumpStatus = false;
      bPressedJump = false;
      bBlockCloseCamera = true;
        bValidBehindCamera = false;
      bFreeCamera = False;
       if ( Viewport(Player) != None )
        ForEach DynamicActors(class'Actor',A)

        A.NotifyLocalPlayerDead(self);

        FindGoodView();
        SetTimer(1.0, false);
        StopForceFeedback();
        ClientPlayForceFeedback("Damage");  // jdf
        CleanOutSavedMoves();
    }

    function EndState()
    {
      StopForceFeedback();
      bBlockCloseCamera = false;
      CleanOutSavedMoves();
      Velocity = vect(0,0,0);
      Acceleration = vect(0,0,0);

        if (!PlayerReplicationInfo.bOutOfLives)
          bBehindView = false;

        bPressedJump = false;

       StopViewShaking();
    }

Begin:
    Sleep(3.0);
}


// -== Для использования в CameraPoint ==-
state Paralyzed
{
    ignores all;

//  function pawn.TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class <damageType> damageType);
    exec function Fire(optional float F)
    {
      if ((GetLevelInfo().MapName~="00_Intro") || (GetFlagBase().GetBool('PlayerTraveling')))
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
        if ( Player.Console != None )
            Player.Console.DelayedConsoleCommand("DISCONNECT");
        else ConsoleCommand("Disconnect");
    }
  return wtf;   
}

defaultproperties
{
  MidGameMenuClass="DXRMenu.DeusExMidGameMenu"
  PawnClass=class'DeusEx.JCDentonMale'
  bCheatsEnabled=true
}




