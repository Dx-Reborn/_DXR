/*-----------------------------------------------------------------------------
  ��� �������� �����������.
  ��� ������� ��������� � ���������� ������ ���� �����.
  ����������� ������� ������������ DeusExLevelInfo.

  03/04/2018: ���������� �� �������� � ������ �����. ���-�� ������ �
  ��������� �� ��� ��������� 0_o :)

-----------------------------------------------------------------------------*/

class DXRSaveSystem extends PlayerControllerEXT;

/* ��������� (� ������� ������������� �� ��� � �������� �����)
  LOAD_None			= 0x0000,	// No flags.
	LOAD_NoFail			= 0x0001,	// Critical error if load fails.
	LOAD_NoWarn			= 0x0002,	// Don't display warning if load fails.
	LOAD_Throw			= 0x0008,	// Throw exceptions upon failure.
	LOAD_Verify			= 0x0010,	// Only verify existance; don't actually load.
	LOAD_AllowDll		= 0x0020,	// Allow plain DLLs.
	LOAD_DisallowFiles  = 0x0040,	// Don't load from file.
	LOAD_NoVerify       = 0x0080,   // Don't verify imports yet.
	LOAD_Forgiving      = 0x1000,   // Forgive missing imports (set them to NULL).
	LOAD_Quiet			= 0x2000,   // No log warnings.
	LOAD_NoRemap        = 0x4000,   // No remapping of packages.*/

CONST MAX_SAVE_SLOTS = 100;
CONST SAVE_PREFIX = "SAVE_";
var transient bool bIsQuickLoading; // transient ��� ���� ����� �������� ���������� ������� �� �����������.

/*--- ������� ������� Save\Current\ ---*/
function SetInitialState()
{
  local string dir;

  dir = ConsoleCommand("get System savepath");
  if (dir != "")
  {
   class'filemanager'.static.MakeDirectory(dir$"\\Current", true);
  }
  else if (dir == "")
  {
   class'filemanager'.static.MakeDirectory("..\\DxSave\\Current", true);
   ConsoleCommand("set System savepath ..\\DxSave");
   SaveConfig();
  }

  super.SetInitialState();
}


/*�������*/
exec function savelevel()
{
	class'GameManager'.static.SaveLevel(Self.XLevel, "xxx1.usa");
}

event TravelPostAccept()
{
  Super.TravelPostAccept();
  log(self @ "TravelPostAccept()");
}

/*--- ����� ��� ��� �������� �����, ���������� �� ��������� ---*/
event PreClientTravel()
{
   Super.PreClientTravel();

    if (!bIsQuickLoading)
    SaveCurrentMap();
}

/*--- ������ ��� ��� ��, ��� ��� �����! ---*/
event ClientTravel(string URL, ETravelType TravelType, bool bItems)
{
  local string temp, mapN, rest, stroka;

  if (bIsQuickLoading)
  {
   super.ClientTravel(URL, TravelType, bItems);
   return;
  }

  temp = URL;

  Divide(temp, "#", mapN, rest);

  if (CheckSavedVersion(MapN, stroka) == true)
  {
   URL = stroka$"#"$rest;
   log("Found saved version of: "$mapN$" -->"$stroka,'DXRSaveSystem');
   super.ClientTravel(URL, TravelType, bItems);
  }
  else
  super.ClientTravel(URL, TravelType, bItems);
}


/*---------------------------------
  ������� ���������� � ��������
---------------------------------*/
exec function QuickSave()
{
//  local Actor A;
  local bool Fsave;
  local string Quick, sd;
	local DeusExLevelInfo info;

	info = GetLevelInfo();

	// Don't allow saving if:
	//
	// 1) The player is dead
	// 2) We're on the logo map
	// 4) We're interpolating (playing outtro)
	// 3) A datalink is playing
	if (((info != None) && (info.MissionNumber < 0)) || ((pawn.IsInState('Dying')) || (IsInState('Paralyzed')) || (IsInState('Interpolating'))) || (Human(pawn).dataLinkPlay != None))
	{
	   ClientMessage("Cannot save right now!");
	   log("Cannot save right now!",'SaveSystem');
	   return;
	}
	log("Trying to save game...",'SaveSystem');
	consolecommand("SAVEGAME 9");

  sd = ConsoleCommand("get System savepath");
  Quick = sd$"\\QuickSave";
  Fsave = class'filemanager'.static.MakeDirectory(Quick, true);
  if (!FSave) 
  ClientMessage("Can't create directory!");

  /* ����������... */

//  class'GameManager'.static.SaveLevel(Self.XLevel, sd$"\\Current\\"$GetLevelInfo().mapName$".dxs");

//  Fsave = class'filemanager'.static.CopyFile(sd$"\\Current\\"$GetLevelInfo().mapName$".dxs", Quick$"\\"$GetLevelInfo().mapName$".dxs", true, true);
  Fsave = class'filemanager'.static.CopyFile(sd$"\\Save9.usa", Quick$"\\"$GetLevelInfo().mapName$".dxs", true, true);
  if (!FSave)
  ClientMessage("Can't copy savefile!");

  ClientMessage("�Saved:  ���"$GetLevelInfo().mapName);
  CreateSaveInfoQuick(); // �������� ����������...

  FSave = class'filemanager'.static.CopyFile("..\\Saves\\SaveInfo.uvx",Quick$"\\"$"SaveInfo.dxs" , true, true); // ����������� �...
  if (!FSave) 
  ClientMessage("Can't copy saveinfo!");

  FSave = class'filemanager'.static.CopyFile("..\\Saves\\DXRPlayerData.uvx",Quick$"\\"$"DXRPlayerData.uvx" , true, true); // ����������� ������ ������ (�������, ���������)
  if (!FSave) 
  ClientMessage("Can't copy DXRPlayerData !");

  // ��������...
  class'DxUtil'.static.PrepareShotForSaveGame(self.XLevel, Quick);

  CopyCurrentFiles(Quick);

//  if (!FSave) //else
//  ClientMessage("Saving map �FAILED ���"$GetLevelInfo().mapName);
}

//  ClientTravel("?loadgame=" $ saveIndex, TRAVEL_Absolute, False);
exec function QuickLoad()
{
  local string path, whatMap, sd;
  local object dxs, ds;

  sd = ConsoleCommand("get System savepath");
  path = sd$"\\QuickSave\\SaveInfo.dxs";

  dxs = class'PackageManager'.static.LoadUnrealPackage(path, 0x1000); // ���� ���������� ��� �� ���� ))
  if (dxs != none)
  {
    ds = dxs.DynamicLoadObject("SaveInfo.MyDeusExSaveInfo", class'DeusExSaveInfo');
    whatMap = DeusExSaveInfo(ds).mapName;
//    class'PackageManager'.static.ReleasePackage(path);

    CopyToCurrent(sd$"\\QuickSave\\*.dxs", sd$"\\QuickSave\\", true);

    bIsQuickLoading = true;
//    ClientTravel(sd$"\\Current\\"$whatMap$".dxs?load", TRAVEL_Partial, false);
    ClientTravel(sd$"\\QuickSave\\"$whatMap$".dxs?load", TRAVEL_Absolute, false);
//    ClientTravel(sd$"\\QuickSave\\"$whatMap$".dxs?load", TRAVEL_Partial, false);
  }
  else
  ClientMessage(path$" not found!");
}


exec function SaveSlot(string slot, string desc)
{
  local bool Fsave;
  local string Save, sd;
	local DeusExLevelInfo info;

/*	if ((slot > MAX_SAVE_SLOTS) || (slot < 0))
	{
	  clientMessage("ERROR : SaveSlot must be in range from 0 to "$MAX_SAVE_SLOTS);
	  log("SaveSlot must be in range from 0 to "$MAX_SAVE_SLOTS,'SaveSystem');
    return;
	}*/

	info = GetLevelInfo();
  sd = ConsoleCommand("get System savepath");
	Save = sd$"\\"$SAVE_PREFIX$slot;

	if (((info != None) && (info.MissionNumber < 0)) || ((pawn.IsInState('Dying')) || (IsInState('Paralyzed')) || (IsInState('Interpolating'))) || (Human(pawn).dataLinkPlay != None))
	{
	   ClientMessage("Cannot save right now!");
	   log("Cannot save right now!",'SaveSystem');
	   return;
	}
	CreateSaveInfo(slot, desc);

	consoleCommand("SaveGame 10");
  class'GameManager'.static.SaveLevel(Self.XLevel, sd$"\\Current\\"$GetLevelInfo().mapName$".dxs");

  Fsave = class'filemanager'.static.MakeDirectory(Save, true);
  if (!FSave)
  log("Failed to create directory"$Save,'SaveSystem');

/*  Fsave = class'filemanager'.static.MoveFile(sd$"\\Save200.usa", Save$"\\"$GetLevelInfo().mapName$".dxs", true, true);
  if (!FSave)
  log("Failed to copy savefile",'SaveSystem');*/

  Fsave = class'filemanager'.static.CopyFile("..\\Saves\\SaveInfo.uvx",Save$"\\"$"SaveInfo.dxs" , true, true);
  if (!FSave)
  log("Failed to copy SaveInfo"$Save,'SaveSystem');

  CopyCurrentFiles(save);
}


/* ��������� ���� �� ����� ��� ������ slot */
exec function LoadSlot(string slot)
{
  local int h;
  local string src, src2;//, s1;
  local array <string> savedGames;


  src = ConsoleCommand("get System savepath");
  src2 = ConsoleCommand("get System savepath");
  src $= "\\*.*";
//  s1 = cSAVESLOT$slot;

  savedGames = class'filemanager'.static.FindFiles(src, false, true);

   if (savedGames.length > 0)
   {
     for(h=0; h<savedGames.length; h++)
     {
       if (savedGames[h] ~= "Current")
          continue; // ���������� ��������� �������

       if (savedGames[h] ~= slot)
       {
          Log("Found Save Slot "$slot);
          CopyToCurrent(src2$"\\"$slot$"\\*.dxs", src2$"\\"$slot);
          break;
       }
     }
   }
}

/* ��� CopyCurrentFiles, ������ �������� :) */
function CopyToCurrent(string src, string src2, optional bool bSkipInfo)
{
//  local bool Fcopy;
  local int i;
  local string sd, dest, currmap;
  local array <string> WhatToCopy;

  sd = ConsoleCommand("get System savepath");
  currmap = GetLevelInfo().mapName$".dxs";
  dest = sd$"\\Current\\";

  log(src@dest);

  WhatToCopy = class'filemanager'.static.FindFiles(src, true, false);

   if (WhatToCopy.length > 0)
   {
     log(level.hour$":"$level.minute$":"$level.second$" --- contents ------------------------------------------");
     for(i=0; i<WhatToCopy.length; i++)
     {
       if (bSkipInfo && WhatToCopy[i] ~= "saveinfo.dxs")
       continue;

//       if (WhatToCopy[i] ~= currmap)
//       continue; // ���������� ������� �������

       log(src2 $ WhatToCopy[i]@dest$WhatToCopy[i]$" : Copying files to Current\\");
       if (class'filemanager'.static.CopyFile(src2 $ WhatToCopy[i],dest $ WhatToCopy[i], true, true) == false)
        {
          log("FAILED to copy"$src2 $ WhatToCopy[i]$" -> "$dest $ WhatToCopy[i]);
//          class'filemanager'.static.CopyFile(src2 $ WhatToCopy[i],dest $ WhatToCopy[i]$LockedExt, true, false);
        }
     }
   }
}

/* ����������� ��������� �� ��������� ����� � ���� ���������� */
exec function CopyCurrentFiles(string dest)
{
  local bool Fcopy;
  local int i;
  local string sd, src, src2;
  local array <string> WhatToCopy;

  sd = ConsoleCommand("get System savepath");
  src = sd$"\\Current\\*.dxs";
  src2 = sd$"\\Current\\";

  log(src@dest);

  WhatToCopy = class'filemanager'.static.FindFiles(src, true, false);

   if (WhatToCopy.length > 0)
   {
     for(i=0; i<WhatToCopy.length; i++)
     {
       if (WhatToCopy[i] ~= "saveinfo.dxs") // ������ �� ������ ���� �������, �� �����?
           continue; // ���������� "saveinfo.dxs"

       clientmessage(src2$WhatToCopy[i]$" -> "$dest$"\\"$WhatToCopy[i]);
                 log(src2$WhatToCopy[i]$" -> "$dest$"\\"$WhatToCopy[i]);
       Fcopy = class'filemanager'.static.CopyFile(src2$WhatToCopy[i],dest$"\\"$WhatToCopy[i], true, true);

     }
   }
}

/*-------------------------------------------------------------
  ��������� ����� ��� ���������� �� ������
  ������������ �������� ��� �� ����� ���������� ����� ���������
  ��� ������� ����������, ������ ������ � ReplicationInfo.
  ����� ��������� �����, ���������� ��������� ��� ����
  RF_Transient, � ������ ��� ������ ��������� ���.

  ��� ������� ���������� �� ������� PreClientTravel() � ����-��
  �����������.

  09/05/2018: ������������� ����� ���������:
  * ������� ������� � �����������
-------------------------------------------------------------*/
exec function SaveCurrentMap()
{
  local bool Fsave;
  local string Quick, sd;
	local DeusExLevelInfo info;
	local Augmentation aug;
	local Skill skl;
	local beam lt;
//	local inventory inv;
	local Ammunition amm;
//	local GameReplicationInfo gri;

	info = GetLevelInfo();
	/* ��������� ���������� �� ���������� */
  class'ObjectManager'.static.SetObjectFlags(Human(pawn), RF_Transient); // ��������� ������
  class'ObjectManager'.static.SetObjectFlags(PlayerReplicationInfo, RF_Transient); // ��������� PlayerReplicationInfo
  class'ObjectManager'.static.SetObjectFlags(self, RF_Transient); // ��������� ����������

  if (human(pawn).carriedDecoration != none)
  class'ObjectManager'.static.SetObjectFlags(Human(pawn).carriedDecoration, RF_Transient); // ��������� ����������� �������, ��������� Destroy() �� ���� �� ��������� ((

  if (human(pawn).AugmentationSystem != none)
  class'ObjectManager'.static.SetObjectFlags(Human(pawn).AugmentationSystem, RF_Transient);

  if (human(pawn).SkillSystem != none)
  class'ObjectManager'.static.SetObjectFlags(Human(pawn).SkillSystem, RF_Transient);

  foreach AllActors(class'Ammunition', amm)//inv)
  {
//    if ((inv != none) && (inv.owner.IsA('DeusExPlayer')))
    if ((amm != none) && (amm.Owner != none) && (amm.owner.IsA('DeusExPlayer')))
    {
      log("Transient inventory:"@amm);
      DeusExAmmoInv(amm).SaveAmmoAmount(); // :)
      class'ObjectManager'.static.SetObjectFlags(amm, RF_Transient);
      amm.Destroy();
    }
  }

/*  foreach AllActors(class'GameReplicationInfo', gri)
  {
    if (gri != none)
    class'ObjectManager'.static.SetActorFlags(gri, RF_Transient);
  }*/
  foreach AllActors(class'Augmentation', aug)
  {
    if (aug != none)
    class'ObjectManager'.static.SetObjectFlags(aug, RF_Transient);
  }
  foreach AllActors(class'Skill', skl)
  {
    if (skl != none)
    class'ObjectManager'.static.SetObjectFlags(skl, RF_Transient);
  }
  foreach AllActors(class'Beam', lt)
  {
    if (lt != none)
    class'ObjectManager'.static.SetObjectFlags(lt, RF_Transient);
  }


	consolecommand("SAVEGAME 100");
//  class'filemanager'.static.SetActorFlags(Actor A, int NewFlags);

  sd = ConsoleCommand("get System savepath");
  Quick = sd$"\\Current";
  Fsave = class'filemanager'.static.MakeDirectory(Quick, true);
  Fsave = class'filemanager'.static.MoveFile(sd$"\\Save100.usa", Quick$"\\"$GetLevelInfo().mapName$".dxs", true, true);
  if (Fsave)
  Log("Saved map "$GetLevelInfo().mapName,'SaveSystem');
  else
  Log("Saving map "$GetLevelInfo().mapName$" FAILED!",'SaveSystem');
}

/*-------------------------------------------------------------
  ���������, ���������� �� ����������� ������� �����.
  ���������� True ���� ��.
-------------------------------------------------------------*/
exec function bool CheckSavedVersion(string whatMap, optional out string SaveWithPath)
{
  local array <string> whatWasFound;
  local string temp, ts, ds;
  local int i;

  ds = ConsoleCommand("get System savepath");
  temp = ds$"\\Current\\";
  ds = temp$whatmap$".dxs";
  whatWasFound = class'filemanager'.static.FindFiles(ds, true, false);
  ts = class'DxUtil'.static.StripPathFromFileName(ds);
                                   //(string Path, bool DoListFiles, bool DoListDirs);
  log("Looking for "$ds$" ...",'SaveSystem');

  if (ts ~= "00_Intro")
      return false;

  for(i=0; i<whatWasFound.length; i++)
  {
// log(whatWasFound[i]);
    if (whatWasFound[i] ~= ts)
    {
//    	ClientMessage(whatWasFound[i]);
      SaveWithPath=ds;
//    ClientMessage(ts);
//    ClientMessage(ds@"= True");
      return true;
      break;
    }
    if (whatWasFound[i] != ts)
    {
//  	ClientMessage(whatWasFound[i]);
//    ClientMessage(ts@"=False");
      log("Saved version of "$whatMap$" not found",'SaveSystem');
      return false;
      break;
    }
  }
}

/*--- ���������� � UT �������� ������ ������� ---*/
/* ������� ���������� ���������� � ������� ���� � �������. */
/* ��� �������� ���������� */
exec function CreateSaveInfoQuick()
{
  local DeusExGameInfo hx;
  local DeusExSaveInfo dx;

  hx = DeusExGameInfo(level.game);

//  class'PackageManager'.static.ReleasePackage("..\\Saves\\SaveInfo.uvx", 0x0010);
  class'FileManager'.static.DeleteFile("..\\Saves\\SaveInfo.uvx", false, true);

  dx = hx.CreateDataObject(class'DeusExSaveInfo', "MyDeusExSaveInfo", "SaveInfo");
  dx.MapName=GetLevelInfo().mapName;
  dx.Description="Quick Save";		// User entered description
  dx.MissionLocation=GetLevelInfo().MissionLocation;	// Mission Location
  dx.saveCount = Human(pawn).saveCount++;			// �� ������ ��� ������ ����
  dx.saveTime = Human(pawn).savetime;			// Duration of play, in seconds. ������� �� DeusExPlayer
  dx.bCheatsEnabled=DeusExPlayerController(level.getlocalPlayerController()).bCheatsEnabled;    // Set to TRUE If Cheats were enabled!!
  dx.Year = level.Year;				// Year.
  dx.Month = level.Month;				// Month.
  dx.Day = level.Day;				// Day of month.
  dx.Hour = level.Hour;				// Hour.
  dx.Minute =	level.Minute;			// Minute.
  dx.Second = level.Second;				// Second.

  hx.SavePackage("SaveInfo");
  hx.SavePlayerData();
}

/* ... � ��� ���������� ����� */
exec function CreateSaveInfo(string slot, optional string desc)
{
  local DeusExGameInfo hx;
  local DeusExSaveInfo dx;

  hx = DeusExGameInfo(level.game);

//  class'PackageManager'.static.ReleasePackage("..\\Saves\\SaveInfo.uvx", 0x0010);
  class'FileManager'.static.DeleteFile("..\\Saves\\SaveInfo.uvx", false, true);

  dx = hx.CreateDataObject(class'DeusExSaveInfo', "MyDeusExSaveInfo", "SaveInfo");
  dx.MapName=GetLevelInfo().mapName;
  dx.Description=desc;		// User entered description
     if (desc == "")
        dx.Description = GetLevelInfo().MissionLocation; // ����� �������� �� ���� ������ :)
  dx.MissionLocation=GetLevelInfo().MissionLocation;	// Mission Location
  dx.saveCount = Human(pawn).saveCount++;			// �� ������ ��� ������ ����
  dx.saveTime = Human(pawn).savetime;			// Duration of play, in seconds. ������� �� DeusExPlayer
  dx.bCheatsEnabled=DeusExPlayerController(level.getlocalPlayerController()).bCheatsEnabled;    // Set to TRUE If Cheats were enabled!!
  dx.Year = level.Year;				// Year.
  dx.Month = level.Month;				// Month.
  dx.Day = level.Day;				// Day of month.
  dx.Hour = level.Hour;				// Hour.
  dx.Minute =	level.Minute;			// Minute.
  dx.Second = level.Second;				// Second.

  hx.SavePackage("SaveInfo");
}

/*--- ��� �������� ---*/
//exec function loadflags()
event PostLoadSavedGame()
{
  class'GameFlags'.static.ImportFlagsFromArray(PlayerPawn(Pawn).RawByteFlags);
  SetInitialState();
}

exec function saveflags()
{
  PlayerPawn(Pawn).RawByteFlags = class'GameFlags'.static.ExportFlagsToArray();
}





