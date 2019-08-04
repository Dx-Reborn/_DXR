/*

*/

class PlayerPawn extends DeusExPlayerPawn
                         config (DXRConfig);

// Это для возврата назад, поскольку .default будет заменен нативной функцией.
const DefaultPlayerHeight = 44.5;
const DefaultPlayerRadius = 20.0;
const CrouchedPlayerHeight = 16.0;

enum EMusicMode {
    MUS_Ambient,
    MUS_Combat,
    MUS_Conversation,
    MUS_Outro,
    MUS_Dying
};

var EMusicMode musicMode;
var float savedSongPos;
var float musicCheckTimer;
var float musicChangeTimer;

var(Flags) editconst /*travel*/ array<byte> RawByteFlags; // Безлоговый вылет если Tavel??

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
var config int InterfaceMode; // 0 = Pause game, 1 = Set gamespeed to 0.1, 2 = Do nothing (RealTime)
var config bool bObjectNames;                 // Object names on/off
var config bool bNPCHighlighting;             // NPC highlighting when new convos
var config bool bSubtitles;                   // True if Conversation Subtitles are on
var config float logTimeout;                  // Log Timeout Value
var config byte  maxLogLines;                 // Maximum number of log lines visible
var config bool bHUDShowAllAugs;              // TRUE = Always show Augs on HUD
var config byte translucencyLevel;            // 0 - 10? // DXR: Remove?

var config bool bObjectBeltVisible;           // ToDo: Implement this.
var config bool bHitDisplayVisible;           // ToDo: Implement this.
var config bool bAmmoDisplayVisible;          // ToDo: Implement this.
var config bool bAugDisplayVisible;           // ToDo: Implement this.
var config bool bDisplayAmmoByClip;           // ToDo: Implement this.
var config bool bCompassVisible;              // ToDo: Implement this.
var config bool bCrosshairVisible;            // ToDo: Implement this.

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

var config bool bHUDBordersVisible;
var config bool bHUDBordersTranslucent;
var config bool bHUDBackgroundTranslucent;
var config bool bMenusTranslucent; // Note: PlayerInterface translucency depends on color theme.


// used while crouching
var travel bool bForceDuck;
var travel bool bCrouchOn;              // used by toggle crouch // travel
var travel bool bWasCrouchOn;           // used by toggle crouch
var config bool bAlwaysRun;             // True to default to running

var bool bToggleWalk;
var bool bToggleCrouch;             // True to let key toggle crouch
var bool bIsCrouching;
var travel byte lastbDuck;              // used by toggle crouch

var transient cameraeffect ce;    // Указатель на эффект камеры
var bool bMblurActive;

var() editconst DeusExDecoration carriedDecoration;
var travel class<DeusExDecoration> carriedDecorationClass;
var vector savedDecoLocation;

var DeusExGameInfo flagBase;
var DeusExLevelInfo dxLevel;

var travel float MyAutoAim;

var ConHistory conHistory;           // Conversation History

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


function PlayInAir();

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


function PreBeginPlay()
{
  super.PreBeginPlay();
  ConBindEvents();
}

event PostLoadSavedGame()
{
  log(self@"PostLoadSavedGame()");
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
    if(flagBase == none)
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
simulated function CameraEffect FindCameraEffect(class<CameraEffect> CameraEffectClass, optional byte mBlurStrength)
{
  local PlayerController PlayerControllerLocal;
  local CameraEffect CameraEffectFound;
  local int i;
 
  PlayerControllerLocal = Level.GetLocalPlayerController();
  if (PlayerControllerLocal != None)
  {
    for (i = 0; i <PlayerControllerLocal.CameraEffects.Length; i++)
      if ( PlayerControllerLocal.CameraEffects[i].Class == CameraEffectClass)
      {
        CameraEffectFound = PlayerControllerLocal.CameraEffects[i];
        break;
      }
    if (CameraEffectFound == None)
    {
      CameraEffectFound = CameraEffect(Level.ObjectPool.AllocateObject(CameraEffectClass));
    }
    if (CameraEffectFound != None)
    {
      PlayerControllerLocal.AddCameraEffect(CameraEffectFound);

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
simulated function RemoveCameraEffect(CameraEffect CameraEffect)
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
        Controller.ChangedWeapon(); // tell inventory that weapon changed (in case any effect was being applied)
        PendingWeapon = None;
        return;
    }
    // removed these lines so you don't automatically pick another weapon - DEUS_EX CNN
//  if ( PendingWeapon == None )
//      PendingWeapon = Weapon;

    PlayWeaponSwitch(PendingWeapon);
//  if ((PendingWeapon != None) && (PendingWeapon.Mass > 20) && (carriedDecoration != None))
//      DropDecoration();
    if (Weapon != None)
        Weapon.SetDefaultDisplayProperties();
        
    Weapon = PendingWeapon;
    Controller.ChangedWeapon(); // tell inventory that weapon changed (in case any effect was being applied)
    if ( Weapon != None )
    {
        Weapon.BringUp(OldWeapon);
        if ( (Level.Game != None) && (Level.Game.GameDifficulty > 1) )
            MakeNoise(0.1 * Level.Game.GameDifficulty);
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

function SetMusic(string NewSong, EMusicTransition NewTransition)
{
  if (DeusExPlayerController(Controller) != none)
     DeusExPlayerController(Controller).ClientSetMusic(NewSong, NewTransition);
}

function float GetCurrentSongPosition(); // Empty for now, maybe use MP3 instead of ogg??

function SetInitialState()
{
  DxLevel = GetLevelInfo();

  Super.SetInitialState();

  if(Len(DxLevel.AmbientMusic) > 0)
     SetMusic(DxLevel.AmbientMusic, MTran_SlowFade);
    musicMode = MUS_Ambient;
}

// Some code from DxOgg && Revision DeusEx mods.
function UpdateDynamicMusic(float deltaTime)
{
    local bool bCombat;
    local ScriptedPawn npc;
    local Controller CurController;
    local DeusExLevelInfo info;

    musicCheckTimer += deltaTime;
    musicChangeTimer += deltaTime;

    if (/*controller.*/IsInState('Interpolating'))
    {
        // don't mess with the music on any of the intro maps
        info = GetLevelInfo();
        if ((info != None) && (info.MissionNumber < 0))
        {
            musicMode = MUS_Outro;
            return;
        }
        if (musicMode != MUS_Outro)
        {
            if(Len(DxLevel.OutroMusic) > 0)
            {
                SetMusic(DxLevel.OutroMusic, MTRAN_FastFade);
                musicMode = MUS_Outro;
            }
        }
    }
    else if (Controller != none && Controller.IsInState('Conversation'))
    {
        if (musicMode != MUS_Conversation)
        {
            if(Len(DxLevel.ConvoMusic) > 0)
            {
                // save our place in the ambient track
                if (musicMode == MUS_Ambient)
                    savedSongPos = GetCurrentSongPosition();
                else
                    savedSongPos = 0.0;

                SetMusic(DxLevel.ConvoMusic, MTRAN_Fade);
                musicMode = MUS_Conversation;
            }
        }
    }
    else if (IsInState('Dying'))
    {
        if (musicMode != MUS_Dying)
        {
            if(Len(DxLevel.DeadMusic) > 0)
            {
                SetMusic(DxLevel.DeadMusic, MTRAN_Fade);
                musicMode = MUS_Dying;
            }
        }
    }
    else
    {
        // only check for combat music every second
        if (musicCheckTimer >= 1.0)
        {
            musicCheckTimer = 0.0;
            bCombat = False;

            // check a 100 foot radius around me for combat
            for (CurController = Level.ControllerList; CurController != None; CurController = CurController.NextController)
            {
              npc = ScriptedPawn(CurController.pawn);
              if ((npc != None) && (npc.Controller != none) && (VSize(npc.Location - Location) < (1600 + npc.CollisionRadius)))
              {
                 if ((npc.Controller.GetStateName() == 'Attacking') && (npc.Controller.Enemy == Self))
                 {
                    bCombat = True;
                    break;
                 }
              }
            }
            if (bCombat)
            {
                musicChangeTimer = 0.0;
                if (musicMode != MUS_Combat)
                {
                    if(Len(DxLevel.CombatMusic) > 0)
                    {
                        // save our place in the ambient track
                        if (musicMode == MUS_Ambient)
                            savedSongPos = GetCurrentSongPosition();
                        else
                            savedSongPos = 0.0;

                        SetMusic(DxLevel.CombatMusic, MTRAN_FastFade);
                        musicMode = MUS_Combat;
                    }
                }
            }
            else if (musicMode != MUS_Ambient)
            {
                // wait until we've been out of combat for 5 seconds before switching music
                if (musicChangeTimer >= 5.0)
                {
                    if(Len(DxLevel.AmbientMusic) > 0)
                    {
                        // fade slower for combat transitions
                        if (musicMode == MUS_Combat)
                            SetMusic(DxLevel.AmbientMusic, MTRAN_SlowFade);
                            //SetCurrentOgg(AmbientIntroOggFile, AmbientOggFile, savedSongPos, MTRAN_SlowFade);
                        else
                            SetMusic(DxLevel.AmbientMusic, MTRAN_Fade);

                        savedSongPos = 0.0;
                        musicMode = MUS_Ambient;
                        musicChangeTimer = 0.0;
                    }
                }
            }
        }
    }
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
    BestTarget = controller.PickTarget(bestAim, bestDist, FireDir, projStart, 4000);

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
// ue2
/*native(531) final function pawn PickTarget(out float bestAim, out float bestDist, vector FireDir, vector projStart, float MaxRange);
native(534) final function actor PickAnyTarget(out float bestAim, out float bestDist, vector FireDir, vector projStart);

native(531) final function pawn PickTarget(out float bestAim, out float bestDist, vector FireDir, vector projStart);
native(534) final function actor PickAnyTarget(out float bestAim, out float bestDist, vector FireDir, vector projStart);
*/

defaultproperties
{
   bCanCrouch=true
   bCanFly=true
   MyAutoAim=1.00
}
