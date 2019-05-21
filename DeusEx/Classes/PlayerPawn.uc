/*

*/

class PlayerPawn extends DeusExPlayerPawn
                         config (DXRConfig);

// Это для возврата назад, поскольку .default будет заменен нативной функцией.
const DefaultPlayerHeight = 43.5;
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

var(Flags) editconst travel array<byte> RawByteFlags;

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

// used while crouching
var travel bool bForceDuck;
var travel bool bCrouchOn;				// used by toggle crouch // travel
var travel bool bWasCrouchOn;			// used by toggle crouch
var bool bIsCrouching;
var travel byte lastbDuck;				// used by toggle crouch

var transient cameraeffect ce;    // Указатель на эффект камеры
var bool bMblurActive;

var() editconst	DeusExDecoration carriedDecoration;

var DeusExGameInfo flagBase;
var DeusExLevelInfo dxLevel;

/*- Assing Conversations to pawn ---------------------------------------------------------------------------------*/
function ConDialogue FindConversationByName(string conName)
{
  local int y;

  for (y=0; y<conList.length; y++)
  {
//    if (conList[y].Name == conName)
    if (caps(conList[y].Name) == caps(conName))
        return conList[y];
//    break;
//    log("found conversationByName="$conName);
//    conv = conList[y];
  }
//  return conv;
}

function AddRefCount()
{
	local bool barkPrefix;
	local conDialogue con;
	local int y;

	DecreaseRefCount();

	for (y=0; y<conList.length; y++)
	{
		con = conList[y];
		barkPrefix = (Left(con.Name, Len(con.OwnerName) + 5) == (con.OwnerName $ CON_BARK_PREFIX));

			if (BarkBindName != con.OwnerName || !barkPrefix)
			{
					if (BindName != con.OwnerName)
						continue;
				if (BarkBindName != "")
				{
					if (BarkBindName == "" || barkPrefix)
						continue;
				}
			}
//	 log("Increased refcount for "$con, 'AddRefCount');
	 con.ownerRefCount++;
	}
}

function DecreaseRefCount()
{
	local int y;

	for (y=0; y<conList.length; y++)
	{
     conList[y].ownerRefCount--;
	}
}

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

function LoadConsForMission(int mission)
{
  local int convos, barks;

  if (bindName != "")
    convos = class'ConversationManager'.static.GetConversations(conList, mission, bindName, "");
//    log(convos);


  if (barkBindName != "")
    barks = class'ConversationManager'.static.GetConversations(conList, mission, BarkbindName, "");
//    log(barks);
}


function PostBeginPlay()
{
  super.PostBeginPlay();
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

// The player wants to switch to weapon group numer I.
function SwitchWeapon (byte F)
{
	local weapon newWeapon;

	if ( Inventory == None )
		return;
	if ( (Weapon != None) && (Weapon.Inventory != None) )
		newWeapon = Weapon.Inventory.WeaponChange(F, false);
	else
		newWeapon = None;	
	if ( newWeapon == None )
		newWeapon = Inventory.WeaponChange(F, false);
	if ( newWeapon == None )
		return;

	if ( Weapon == None )
	{
		PendingWeapon = newWeapon;
		ChangedWeapon();
	}
	else if ( (Weapon != newWeapon) && Weapon.PutDown())
		PendingWeapon = newWeapon;
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
//	if ( PendingWeapon == None )
//		PendingWeapon = Weapon;

	PlayWeaponSwitch(PendingWeapon);
//	if ((PendingWeapon != None) && (PendingWeapon.Mass > 20) && (carriedDecoration != None))
//		DropDecoration();
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

function SwitchToBestWeapon();



// Just changed to pendingWeapon
/*function ChangedWeapon()
{
	local Weapon OldWeapon;

	OldWeapon = Weapon;

	if (Weapon == PendingWeapon)
	{
		if ( Weapon == None )
		{
			Controller.SwitchToBestWeapon();
			return;
		}
		else if ( Weapon.IsInState('DownWeapon') ) 
			Weapon.GotoState('Idle');
		PendingWeapon = None;
		ServerChangedWeapon(OldWeapon, Weapon);
		return;
	}
	if ( PendingWeapon == None )
		PendingWeapon = Weapon;
		
	Weapon = PendingWeapon;
	if ( (Weapon != None) && (Level.NetMode == NM_Client) )
		Weapon.BringUp(OldWeapon);
	PendingWeapon = None;
	Weapon.Instigator = self;
	ServerChangedWeapon(OldWeapon, Weapon);
	if ( Controller != None )
		Controller.ChangedWeapon();
}*/

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

    if (controller.IsInState('Interpolating'))
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
    else if (Controller.IsInState('Conversation'))
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


defaultproperties
{
   bCanCrouch=true
   bCanFly=true
}
