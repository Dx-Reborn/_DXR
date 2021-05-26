/*

*/

class PlayerPawn extends DeusExPlayerPawn;

const DefaultPlayerHeight = 43.5;
const DefaultPlayerRadius = 20.0;
const RADAR_DIST = 3000;
const TRACE_LOS_DIST = 8000;  // Максимальная дистанция для работы аугментаций. CullDistance для ScriptedPawn также 8000.
const MAX_FIRE_ACTORS = 1;
const MAX_INVENTORY_CELLS = 30;
const TOOLBELT_LENGTH = 10;

var() travel inventory objects[TOOLBELT_LENGTH]; // DXR: for toolbelt
var() travel Weapon myWeapon; // DXR: I have no idea why pawn.weapon is set to None after traveling...
var() travel Powerups mySelectedItem; // Same...

var localized String InventoryFull;
var localized String TooMuchAmmo;
var localized String TooHeavyToLift;
var localized String CannotLift;
var localized String NoRoomToLift;
var localized String CanCarryOnlyOne;
var localized String CannotDropHere;
var localized String HandsFull;
var localized String NoteAdded;
var localized String GoalAdded;
var localized String PrimaryGoalCompleted;
var localized String SecondaryGoalCompleted;
var localized String EnergyDepleted;
var localized String AddedNanoKey;
var localized String HealedPointsLabel;
var localized String HealedPointLabel;
var localized String SkillPointsAward;
var localized String QuickSaveGameTitle;

                                              // When player management menu (Inventory or Augmentations for example) is opened...
var config int InterfaceMode;                 // 0 = Pause game, 1 = Set gamespeed to 0.1, 2 = Do nothing (RealTime)
var config bool bObjectNames;                 // Object names on/off
var config bool bNPCHighlighting;             // NPC highlighting when new convos
var config bool bSubtitles;                   // True if Conversation Subtitles are on
var config float logTimeout;                  // Log Timeout Value
var config byte  maxLogLines;                 // Maximum number of log lines visible
var config bool bHUDShowAllAugs;              // TRUE = Always show Augs on HUD

var config bool bHitDisplayVisible;           // Индикатор здоровья
var config bool bAmmoDisplayVisible;          // ToDo: Implement this.
var config bool bAugDisplayVisible;           // ToDo: Implement this.
var config bool bCompassVisible;              // ToDo: Implement this.
var config bool bCrosshairVisible;            // ToDo: Implement this.
var bool bSkipCrosshair; // DXR: Не отображать перекрестие для некоторых случаев

var config bool bAutoReload;
var config bool bDisplayAllGoals;             // ToDo: Implement this.
var config int  UIBackground;                 // 0 = Render 3D, 1 = Snapshot, 2 = Black // ToDo: Check alternative way.
var config bool bDisplayCompletedGoals;       // ToDo: Implement this.
var config bool bShowAmmoDescriptions;        // ToDo: Implement this.
var config bool bConfirmSaveDeletes;          // ToDo: Implement this.
var config bool bConfirmNoteDeletes;          // ToDo: Implement this.
var config bool bAskedToTrain;                // Useless now? 
var config bool bSoundsForLadderVolumes;      // Play sounds when moving in LadderVolume

// DXR: New options (from Vanilla Matters, but can be turned on/off)
var config bool bLeftClickForLastItem;
var config int RemainingAmmoMode;// 0: by clips (default), 1: by rounds

// DXR: New option to display debug info, in addition to built-in ShowDebug()
var config bool bExtraDebugInfo;

// used while crouching
var travel bool bForceDuck;
var travel bool bCrouchOn;              // used by toggle crouch // travel
var travel bool bWasCrouchOn;           // used by toggle crouch
var config bool bAlwaysRun;             // True to default to running

var travel int LighterUseCount; // Lighter use counter

var config bool bToggleWalk;
var config bool bToggleCrouch;             // True to let key toggle crouch
var bool bIsCrouching;
var travel byte lastbDuck;          // used by toggle crouch

var transient cameraeffect ce;    // Указатель на эффект камеры
var bool bMblurActive;

var() editconst DeusExDecoration carriedDecoration;
var travel class<DeusExDecoration> carriedDecorationClass;
var travel rotator carriedDecorationRotation;

var vector savedDecoLocation;

var DeusExGameInfo flagBase;
var DeusExLevelInfo dxLevel;

var travel float MyAutoAim;
var float hitmarkerTime; // Для индикатора попадания
var float vsTime1;
var bool bVsEnabled;
var float vScale;

var float HeadWoundTimer;

// Radar
var float RadarPosX, RadarPosY, RadarScale, MinEnemyDist;
var material RadarBackground;



var ConHistory conHistory;           // Conversation History

final function ConHistory CreateHistoryObject()
{
    local ConHistory ch;
    ch = new(Outer) class'ConHistory';

    return ch;
}

final function ConHistoryEvent CreateHistoryEvent()
{
    local ConHistoryEvent che;
    che = new(Outer) class'ConHistoryEvent';

    return che;
}


function PlayInAir();
function HeadHealthChanged(float fValue);

function int StandingCount()
{
    local int count;
    local actor a;

    foreach BasedActors(class'Actor', A)
      if (!A.IsA('Inventory'))
        count++;

 return count;
}

function p_HandleWalking();
exec function PutInHand(optional Inventory inv);

function PlayBodyThud()
{
    PlaySound(sound'BodyThud', SLOT_Interact);
}

/*- Assing Conversations to pawn ---------------------------------------------------------------------------------*/

function ConBindEvents()
{
    local DeusExLevelInfo dxInfo;

    foreach AllActors(class'DeusExLevelInfo', dxInfo)
    {
        if (dxInfo != none)
            break;
    }
    if (dxInfo != none)
    {
        RegisterConFiles(dxinfo.ConversationsPath);
        LoadConsForMission(dxinfo.missionNumber);
        AddRefCount();
    }
    else
        log("DeusExLevelInfo not found! Failed to register conversations.");
}

// Регистрация *.con файлов
function RegisterConFiles(string Path)
{
  local array<byte> bt;
  local array<string> conFiles;
  local int f, res;

  conFiles = class'FileManager'.static.FindFiles(Path$"*.con", true, false);

  if (conFiles.length == 0)
     {
       log("ERROR -- No *.con files found !");
       return;
     }

  for (f=0; f<conFiles.length; f++)
  {
    bt = class'DXUtil'.static.GetFileAsArray(Path$conFiles[f]);
    res = class'ConversationManager'.static.RegisterConFile(Path$conFiles[f],bt);
  }
}

//function PostSetInitialState()


function PreBeginPlay()
{
   super.PreBeginPlay();
   ConBindEvents();
}

event PostLoadSavedGame()
{
   log(self@"PostLoadSavedGame()?");
   ConBindEvents();
}

// ToDo: Добавить экран с текстом как в оригинале?
function ShowCredits(optional bool bLoadIntro)
{
   if (bLoadIntro)
       ConsoleCommand("open DxOnly");

   log("ShowCredits(bLoadIntro?) "$bLoadIntro);
}

function DeusExGameInfo getFlagBase()
{
   if (flagBase == none)
      flagBase = DeusExGameInfo(Level.Game);

   return flagBase;
}

function DeusExLevelInfo GetLevelInfo()
{
    local DeusExLevelInfo info;

    foreach AllActors(class'DeusExLevelInfo', info)
        break;

        if (info != none)
            DxLevel = info;

    return info;
}

function float RandomPitch()
{
    return (1.1 - 0.2*FRand());
}

/*
  FindCameraEffect

  Looks for an existing CameraEffect object in the CameraEffects array first.
  Only if it doesn't find one, it takes one from the ObjectPool.
  That CameraEffect will be returned.
*/
function CameraEffect FindCameraEffect(class<CameraEffect> CameraEffectClass, optional byte mBlurStrength)
{
  local PlayerController PC;
  local CameraEffect CameraEffectFound;
  local int i;
 
  PC = Level.GetLocalPlayerController();
  if (PC != None)
  {
    for (i=0; i<PC.CameraEffects.Length; i++)
         if ( PC.CameraEffects[i].Class == CameraEffectClass)
         {
            CameraEffectFound = PC.CameraEffects[i];
            break;
         }

         if (CameraEffectFound == None)
         {
             CameraEffectFound = CameraEffect(Level.ObjectPool.AllocateObject(CameraEffectClass));
         }
         if (CameraEffectFound != None)
         {
              PC.AddCameraEffect(CameraEffectFound);

              if (CameraEffectFound.IsA('MotionBlur'))
                  motionBlur(CameraEffectFound).BlurAlpha = mBlurStrength;
         }
  }
  return CameraEffectFound;
}

/*
  RemoveCameraEffect

  Removes one reference to the CameraEffect from the CameraEffects array. If
  there are any more references to the same CameraEffect object, they remain
  there. The CameraEffect will be put back in the ObjectPool if no other
  references to it are left in the CameraEffects array.
*/
function RemoveCameraEffect(CameraEffect CameraEffect)
{
  local PlayerController PlayerControllerLocal;
  local int i;
 
  PlayerControllerLocal = Level.GetLocalPlayerController();
  if (PlayerControllerLocal != None)
  {
    PlayerControllerLocal.RemoveCameraEffect(CameraEffect);
    for (i = 0; i <PlayerControllerLocal.CameraEffects.Length; i++)
      if (PlayerControllerLocal.CameraEffects[i] == CameraEffect)
      {
        log(CameraEffect@"still in CameraEffects array");
        return;
      }
    log("Freeing"@CameraEffect);
    Level.ObjectPool.FreeObject(CameraEffect);
  }
}

/*
  Для упрощения использования Motion Blur.
  Имеет смысл использовать значения меньше 30, если больше, то эффект
  практически незаметен.
*/
exec function blur(byte howMuch)
{
  ce = FindCameraEffect(class'motionblur', howMuch);

  if (ce != none)
      bMblurActive = true;
}

exec function unblur()
{
   if (ce != none)
       RemoveCameraEffect(ce);

       bMblurActive = false;
}


function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
   Super.DisplayDebug(Canvas, YL, YPos);

   if (SelectedItem == None)
   {
       Canvas.SetDrawColor(0,255,0);
       Canvas.DrawText("NO SelectedItem");
       YPos += YL;
       Canvas.SetPos(4,YPos);
   }
   else
       SelectedItem.DisplayDebug(Canvas,YL,YPos);
}

function DropDecoration();

// Just changed to pendingWeapon
function ChangedWeapon()
{
    local Weapon OldWeapon;

    OldWeapon = Weapon;

    if (Weapon == PendingWeapon)
    {
        if (Weapon == None)
            SwitchToBestWeapon();
        else if (Weapon.IsInState('DownWeapon')) 
            Weapon.BringUp();
        if (Weapon != None)
            Weapon.SetDefaultDisplayProperties();
        Inventory.ChangedWeapon(); // tell inventory that weapon changed (in case any effect was being applied)
        PendingWeapon = None;
        return;
    }
    // removed these lines so you don't automatically pick another weapon - DEUS_EX CNN
//  if ( PendingWeapon == None )
//      PendingWeapon = Weapon;

    PlayWeaponSwitch(PendingWeapon);
    if ((PendingWeapon != None) && (PendingWeapon.Mass > 20) && (carriedDecoration != None))
        DropDecoration();
    if (Weapon != None)
        Weapon.SetDefaultDisplayProperties();
        
    Weapon = PendingWeapon;
    myWeapon = PendingWeapon; // DXR: New
    Inventory.ChangedWeapon(); // tell inventory that weapon changed (in case any effect was being applied)
    if (Weapon != None)
    {
        Weapon.BringUp(OldWeapon);
    }
    PendingWeapon = None;
}

function bool SwitchToBestWeapon();

// Для проверки что это есть.
exec function CheckMusic()
{
  local int fHandle;
  local string CheckSong;

  CheckSong = DxLevel.AmbientMusic;
   fHandle = class'FileManager'.static.FileSize("..\\Music\\"$CheckSong$".ogg");
   log("Checking for soundFile "$CheckSong$" result="$fhandle);

  CheckSong = DxLevel.DeadMusic;
   fHandle = class'FileManager'.static.FileSize("..\\Music\\"$CheckSong$".ogg");
   log("Checking for soundFile "$CheckSong$" result="$fhandle);

  CheckSong = DxLevel.CombatMusic;
   fHandle = class'FileManager'.static.FileSize("..\\Music\\"$CheckSong$".ogg");
   log("Checking for soundFile "$CheckSong$" result="$fhandle);

  CheckSong = DxLevel.DeadMusic;
   fHandle = class'FileManager'.static.FileSize("..\\Music\\"$CheckSong$".ogg");
   log("Checking for soundFile "$CheckSong$" result="$fhandle);

  CheckSong = DxLevel.ConvoMusic;
   fHandle = class'FileManager'.static.FileSize("..\\Music\\"$CheckSong$".ogg");
   log("Checking for soundFile "$CheckSong$" result="$fhandle);

  CheckSong = DxLevel.OutroMusic;
   fHandle = class'FileManager'.static.FileSize("..\\Music\\"$CheckSong$".ogg");
   log("Checking for soundFile "$CheckSong$" result="$fhandle);
}



function rotator AdjustAim(float projSpeed, vector projStart, int aimerror, bool bLeadTarget, bool bWarnTarget)
{
    local vector FireDir, AimSpot, HitNormal, HitLocation;
    local actor BestTarget;
    local float bestAim, bestDist;
    local actor HitActor;
    
    FireDir = vector(GetViewRotation());
    HitActor = Trace(HitLocation, HitNormal, projStart + 4000 * FireDir, projStart, true);
    if ((HitActor != None) && HitActor.bProjTarget)
    {
        if (bWarnTarget && HitActor.IsA('Pawn'))
            Pawn(HitActor).WarnTarget(self, projSpeed, FireDir);
        return GetViewRotation();
    }

    bestAim = FMin(0.93, MyAutoAim);
    BestTarget = controller.PickTarget(bestAim, bestDist, FireDir, projStart, 14000);

    if (bWarnTarget && (Pawn(BestTarget) != None))
        Pawn(BestTarget).WarnTarget(self, projSpeed, FireDir);  

    if ( (Level.NetMode != NM_Standalone) || (Level.Game.GameDifficulty > 2) 
        || PlayerController(Controller).bAlwaysMouseLook || ((BestTarget != None) && (bestAim < MyAutoAim)) || (MyAutoAim >= 1) )
        return GetViewRotation();
    
    if (BestTarget == None)
    {
        bestAim = MyAutoAim;
        BestTarget = Controller.PickAnyTarget(bestAim, bestDist, FireDir, projStart);
        if (BestTarget == None)
            return GetViewRotation();
    }

    AimSpot = projStart + FireDir * bestDist;
    AimSpot.Z = BestTarget.Location.Z + 0.3 * BestTarget.CollisionHeight;

    return rotator(AimSpot - projStart);
}

function DeleteInventory(inventory Item)
{
    // If this item is in our inventory chain, unlink it.
    local actor Link;
    local int Count;

    if ((Item == Weapon) || (Item == myWeapon))
    {
        Weapon = None;
        myWeapon = None;
    }
    if ((Item == SelectedItem) || (Item == mySelectedItem))
    {
        SelectedItem = None;
        mySelectedItem = None;
    }
    for(Link = Self; Link!=None; Link=Link.Inventory)
    {
        if(Link.Inventory == Item)
        {
            Link.Inventory = Item.Inventory;
            Item.Inventory = None;
            Link.NetUpdateTime = Level.TimeSeconds - 1;
            Item.NetUpdateTime = Level.TimeSeconds - 1;
            break;
        }
        if (Level.NetMode == NM_Client)
        {
            Count++;
            if (Count > 1000)
            break;
        }
    }
    Item.SetOwner(None);
} 


function bool AddInventory( inventory NewItem )
{
    // Skip if already in the inventory.
   local inventory Inv;
    
   // The item should not have been destroyed if we get here.
   if (NewItem == None)
       log("tried to add none inventory to "$self);

   for(Inv=Inventory; Inv!=None; Inv=Inv.Inventory)
       if(Inv == NewItem)
          return false;

   // DEUS_EX AJY
   // Update the previous owner's inventory chain
   if (NewItem.Owner != None)
       Pawn(NewItem.Owner).DeleteInventory(NewItem);

   // Add to front of inventory chain.
   NewItem.SetOwner(Self);
   NewItem.Inventory = Inventory;
   Inventory = NewItem;

   return true;
}

function HitMarkerTick(float deltaTime)
{
    local DeusExHUD hd;

    hd = DeusExHud(DeusExPlayerController(Controller).myHUD);
    vsTime1 += deltaTime;

    if (hitmarkerTime > 0)
    {
        if (hd != None)
        {
            hitmarkerTime -= deltaTime;

            if (hitmarkerTime < 0.05 || IsInState('Dying'))
            {
                hitmarkerTime = 0;
            }
        }
    }
    vSpringTick(deltaTime);
    HeadWoundEffects(deltaTime);
}

function vSpringTick(float deltaTime)
{
   if (!bVsEnabled)
       return;

   vsTime1 += deltaTime;
   vScale = 0.8 + class'DxUtil'.static.pulse(vsTime1, 0.1, 1.0); //(0.1 * (1+sin(2 * pi * 1.0 * vsTime1))); // DXR: Пульсация в диапазоне от 0.2 до 0.0
//   class'DeusExGameEngine'.static.GetEngine().SetCinematicsRatio(vScale);
   DeusExPlayerController(Controller).Player.Console.DelayedConsoleCommand("CINEMATICSRATIO "$ vScale);
}

exec function VSpring()
{
   vsTime1 = 0;
   bVsEnabled = !bVsEnabled;
   class'DeusExGameEngine'.static.GetEngine().SetCinematicsBlackBars(bVsEnabled);
}

exec function addHWE(float fValue)
{
   Blur(1);
   HeadWoundTimer += fValue;
}

function HeadWoundEffects(float deltaTime)
{
    local float mult;
    local Rotator rot;
    local HUD hud;

    hud = DeusExPlayerController(Controller).myHUD;

    // Имитация головокружения
    if (HeadWoundTimer > 0)
    {
        if (hud != none)
        {
//            DeusExHud(hud).bGrayPoison = true;
  //          DeusExHud(hud).bDoubledPoisonEffect = false;
        }

        mult = FClamp(HeadWoundTimer / 10.0, 0.0, 3.0);
        rot.Pitch = 1024.0 * Cos(Level.TimeSeconds * mult) * deltaTime * mult;
        rot.Yaw = 1024.0 * Sin(Level.TimeSeconds * mult) * deltaTime * mult;
        rot.Roll = 0;

        rot.Pitch = FClamp(rot.Pitch, -4096, 4096);
        rot.Yaw = FClamp(rot.Yaw, -4096, 4096);

        SetViewRotation(rot += GetViewRotation());

        HeadWoundTimer -= deltaTime;

        if (HeadWoundTimer < 0)
            HeadWoundTimer = 0;
    }
    else
    {
        if (hud != None)
        {
//             DeusExHud(hud).bGrayPoison = false;
        }
    }
}

exec function ListStasis()
{
   local DeusExPawn wtf;

   foreach AllActors(class'DeusExPawn', wtf)
           log("Pawn: "$wtf@"bStasis"@wtf.bStasis@"= and controller.bStasis="$wtf.Controller.bStasis);
}

exec function TestGunther()
{
    local GuntherHermann gh;

    foreach DynamicActors(class'GuntherHermann', gh)  // Find a pawn
    break;

    if (gh != None)
    {
        gh.Health = 0;
        gh.HealthTorso = 0;
        gh.bInvincible = false;
        gh.GoToState('KillSwitchActivated');
    }
}

// For debugging
exec function listConvos()
{
   local int i, x;
   local DeusExPawn pwn;

   foreach DynamicActors(class'DeusExPawn', pwn)
   {
       for (i=0; i<pwn.ConList.Length; i++)
       {
           log(pwn @ pwn.ConList[i]);
           for (x=0; x<pwn.ConList[i].EventList.Length; x++)
                log("Events:"@pwn.ConList[i].EventList[x]);
       }
   }


/*    while(i < ConList.Length)
    {
        log("Conversation: " $ conlist[i]);
        i++;
    }*/
}


exec function CleanupConvos()
{
    local ScriptedPawn dxp;
    local int i;

    foreach dynamicactors(class'ScriptedPawn', dxp)
    {
       for(i=0; i<dxp.conlist.length; i++)
       {
           if (CAPS(dxp.conlist[i].OwnerName) != CAPS(dxp.BindName))
               dxp.conlist.remove(i,1);
       }
    }
}

defaultproperties
{
   bCanCrouch=true
   bCanFly=true
   MyAutoAim=1.00
}

/*


// A trace that has the hitlocation set to the end if it hits nothing, the normal fixed if it hits the back of a face and
// the hitlocation moved 3 units towards the surface if it hits a static mesh...
static function Actor CleanTrace (Actor TraceOwner, Vector End, Vector Start, out Vector HitLocation, out Vector HitNormal, optional bool bTraceActors, optional vector Extent, optional out Material HitMaterial)
{
    local Actor T;
    T = TraceOwner.Trace(HitLocation, HitNormal, End, Start, bTraceActors, Extent, HitMaterial);
    if (T == None)
    {
        HitLocation = End;
        return None;
    }
    if (T.DrawType == DT_StaticMesh)
        HitLocation -= HitNormal*3;
    if (HitNormal Dot Normal(End - Start) > 0.0)
        HitNormal *= -1;
    return T;
}
*/