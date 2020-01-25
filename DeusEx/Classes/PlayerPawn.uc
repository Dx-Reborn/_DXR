/*

*/

class PlayerPawn extends DeusExPlayerPawn
                         config (DXRConfig);

// ��� ��� �������� �����, ��������� .default ����� ������� �������� ��������.
const DefaultPlayerHeight = 43.5;
const DefaultPlayerRadius = 20.0;

var travel inventory objects[10]; // for toolbelt

var(Flags) editconst array<byte> RawByteFlags; // ���������� ����� ���� Tavel??

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

var transient cameraeffect ce;    // ��������� �� ������ ������
var bool bMblurActive;

var() editconst DeusExDecoration carriedDecoration;
var travel class<DeusExDecoration> carriedDecorationClass;
var travel rotator carriedDecorationRotation;

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
    local ConHistoryEvent che;
    che = new(Outer) class'ConHistoryEvent';

    return che;
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

// ����������� *.con ������
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

// ToDo: �������� ����� � ������� ��� � ���������?
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
  local PlayerController PC;
  local CameraEffect CameraEffectFound;
  local int i;
 
  PC = Level.GetLocalPlayerController();
  if (PC != None)
  {
    for (i = 0; i <PC.CameraEffects.Length; i++)
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
  ��� ��������� ������������� Motion Blur.
  ����� ����� ������������ �������� ������ 30, ���� ������, �� ������
  ����������� ���������.
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


simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
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

// ��� �������� ��� ��� ����.
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

/*
   Code from Postal2. Fixes a bug,
   when inventory items are duplicated 
   after traveling to new map.
*/
/*function bool AddInventory(inventory NewItem)
{
    // Skip if already in the inventory.
    local inventory Inv;
    local Inventory currinv;
    local actor Last;

    Last = self;
    
    // The item should not have been destroyed if we get here.
    if (NewItem ==None)
    {
        Warn("PlayerPawn.AddInventory(): tried to add none inventory to "$self);
        return false;
    }

    for(Inv=Inventory; Inv!=None; Inv=Inv.Inventory)
    {
        if(Inv == NewItem)
            return false;
        Last = Inv;
    }

    //log("addinventory "$NewItem);
    // Check if we already have a class of this type in our inventory.
    // If so, try to just add more of it
    currinv = FindInventoryType(NewItem.class);
//    log(self@"currInv ="@currinv);
    // You'll only have this in your inventory *and* have this function
    // get called if you've just done a level warp. Normally after a pickup
    // this function won't get called if you already have ammo.
    if(Ammunition(currinv) != None)
    {
        // This is touchy and may not work. This was a work around for the
        // original ammo bug from Epic in here. The problem was if you picked
        // up a weapon and then warped to a new level, it duplicated the ammo
        // in your inventory.
        // Now, the pickup adds ammo to the weapon, and then when you warp
        // your weapon is added, and ammo (from the inventory which also travelled)
        // is added THEN to your weapon. Before both was happening, so you'd
        // get both things in a warp.
        currinv.Destroy();
        return false;

        // Trying to figure out why ammo is added again when you warp 
        //  between levels.
        Ammunition(currinv).AddAmmo(Ammunition(NewItem).AmmoAmount);
//        log("tried to add me again, even though i'm already here "$currinv);
//        currinv.Destroy();
//        return false;

    }
    else
    {
        // Add to back of inventory chain (so minimizes net replication effect).
        NewItem.SetOwner(Self);
        NewItem.Inventory = None;
        Last.Inventory = NewItem;

        if (Controller != None)
            Controller.NotifyAddInventory(NewItem);

    log("Added inventory item --"@NewItem);
    }

    return true;
}*/


defaultproperties
{
   bCanCrouch=true
   bCanFly=true
   MyAutoAim=1.00
}
