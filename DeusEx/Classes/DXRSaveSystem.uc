/*-----------------------------------------------------------------------------
  Для удобства организации.
  Все функции переходов и сохранений должны быть здесь.
  Обязательно наличие заполненного DeusExLevelInfo.

  03/04/2018: Избавилась от привязки к номеру слота. Как-то сложно и
  громоздко всё это смотрится 0_o :)

-----------------------------------------------------------------------------*/

class DXRSaveSystem extends PlayerControllerEXT;

const MAX_SAVE_SLOTS = 100;
const SAVE_PREFIX = "SAVE_";

var transient bool bIsQuickLoading; // transient для того чтобы значение переменной никогда не сохранялось.

/*--- Создать каталог Save\Current\ ---*/
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
}

/*event TravelPostAccept()
{
  Super.TravelPostAccept();
  log(self @ "TravelPostAccept()");
}*/

/*--- Перед тем как покинуть карту, необходимо ее сохранить ---*/
event PreClientTravel()
{
   Super.PreClientTravel();

    if (!bIsQuickLoading)
        SaveCurrentMap();
}

/*--- Похоже что это то, что мне нужно! ---*/
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
  Быстрое сохранение и загрузка
  ToDo: Ошибка -- в Current ничего не копировать!
  Log: Save=3.653415
  Log: Moving '..\D43k_SAVE\QuickSave\Save.tmp' to '..\D43k_SAVE\QuickSave\SaveInfo.dxs'
  Init: Shut down moving brush tracker for Level Autoplay.MyLevel
  Log: Save=21.084093
  Log: Moving '..\D43k_SAVE\QuickSave\Save.tmp' to '..\D43k_SAVE\QuickSave\08_NYC_Smug.dxs'
  Init: Initialized moving brush tracker for Level Autoplay.MyLevel
---------------------------------*/
exec function QuickSave()
{
//  local Actor A;
  local bool Fsave;
  local string Quick, sd;
  local DeusExLevelInfo info;
  local DeusExGameEngine eng;

  // Если ничего нет, то уходим.
  eng = class'DeusExGameEngine'.static.GetEngine();
  if (eng == None)
  {
     ClientMessage("Can't Save game -- Unable to get pointer to DeusExGameEngine!");
     return;
  }

  info = GetLevelInfo();
  if (info == None)
  {
     ClientMessage("Can't Save game -- Unable to find DeusExLevelInfo actor!");
     return;
  }

    // Don't allow saving if:
    //
    // 1) The player is dead
    // 2) We're on the logo map
    // 4) We're interpolating (playing outtro)
    // 3) A datalink is playing
    if (((info != None) && (info.MissionNumber < 0)) || ((pawn.IsInState('Dying')) || (IsInState('Paralyzed')) || (IsInState('Interpolating'))) || (Human(pawn).dataLinkPlay != None) ||
         pawn.Physics == PHYS_Falling)
    {
       ClientMessage("Cannot save game right now!");
       log("Cannot save game right now!",'SaveSystem');
       return;
    }

  sd = ConsoleCommand("get System savepath"); // Получить путь к сохранениям
  Quick = sd$"\\QuickSave"; // Соединить строки
  Fsave = class'filemanager'.static.MakeDirectory(Quick, true);
  if (!FSave)
  {
     ClientMessage("Can't create"@Quick@"directory!"); // Каталог не был создан, выходим.
     return;
  }

//  eng.SaveGameEx(sd$"\\Current\\"$GetLevelInfo().mapName$".dxs"); // Сохраняем...
  eng.SaveGameEx(sd$"\\QuickSave\\"$GetLevelInfo().mapName$".dxs"); // Сохраняем...
  if (class'FileManager'.static.FileSize(sd$"\\QuickSave\\"$GetLevelInfo().mapName$".dxs") == -1)   // Проверяем что файл существует.
  {
     ClientMessage("SaveGame failed! Aborting."); // Нет? Выходим.
     return;
  }

  ClientMessage("яSaved:  яяя"$GetLevelInfo().mapName);
  Saveflags(); // Сохранить флаги...
  CreateSaveInfoQuick(); // Записать информацию...


  FSave = class'filemanager'.static.CopyFile("..\\Saves\\SaveInfo.uvx",Quick$"\\"$"SaveInfo.dxs" , true, true); // Скопировать её...
  if (!FSave)
  {
     ClientMessage("Can't copy saveinfo!");
     return;
  }

  FSave = class'filemanager'.static.CopyFile("..\\Saves\\DXRPlayerData.uvx",Quick$"\\"$"DXRPlayerData.uvx" , true, true); // Скопировать данные игрока (заметки, переписки)
  if (!FSave) 
  {
     ClientMessage("Can't copy DXRPlayerData!");
     return;
  }

  // Скриншот...
  class'DxUtil'.static.PrepareShotForSaveGame(self.XLevel, Quick);

  CopyCurrentFiles(Quick);
}

//  ClientTravel("?loadgame=" $ saveIndex, TRAVEL_Absolute, False);
/* Быстрая загрузка */
exec function QuickLoad()
{
  local string path, whatMap, sd;
  local object dxs, ds;

  sd = ConsoleCommand("get System savepath");
  path = sd$"\\QuickSave\\SaveInfo.dxs";

  dxs = class'PackageManager'.static.LoadUnrealPackage(path, 0x1000); // надо посмотреть что за флаг ))
  if (dxs != none)
  {
    ds = dxs.DynamicLoadObject("SaveInfo.MyDeusExSaveInfo", class'DeusExSaveInfo');
    whatMap = DeusExSaveInfo(ds).mapName;

    CopyToCurrent(sd$"\\QuickSave\\*.dxs", sd$"\\QuickSave\\", true);

    bIsQuickLoading = true;
    ClientTravel(sd$"\\QuickSave\\"$whatMap$".dxs?load?", TRAVEL_Absolute, false);
    return;
  }
  else
  ClientMessage(path$" not found!");
}


exec function SaveSlot(string slot, string desc)
{
  local bool Fsave;
  local string Save, sd;
    local DeusExLevelInfo info;

/*  if ((slot > MAX_SAVE_SLOTS) || (slot < 0))
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


/* Загрузить игру из слота под именем slot */
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
          continue; // Пропустить служебный каталог

       if (savedGames[h] ~= slot)
       {
          Log("Found Save Slot "$slot);
          CopyToCurrent(src2$"\\"$slot$"\\*.dxs", src2$"\\"$slot);
          break;
       }
     }
   }
}

/* Как CopyCurrentFiles, только наоборот :) */
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
//       continue; // Пропустить текущий уровень

       log(src2 $ WhatToCopy[i]@dest$WhatToCopy[i]$" : Copying files to Current\\");
       if (class'filemanager'.static.CopyFile(src2 $ WhatToCopy[i],dest $ WhatToCopy[i], true, true) == false)
        {
          log("FAILED to copy"$src2 $ WhatToCopy[i]$" -> "$dest $ WhatToCopy[i]);
//          class'filemanager'.static.CopyFile(src2 $ WhatToCopy[i],dest $ WhatToCopy[i]$LockedExt, true, false);
        }
     }
   }
}

/* Скопировать собранные по переходам карты в слот сохранения */
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
       if (WhatToCopy[i] ~= "saveinfo.dxs") // Такого не должно быть никогда, но вдруг?
           continue; // пропустить "saveinfo.dxs"

       clientmessage(src2$WhatToCopy[i]$" -> "$dest$"\\"$WhatToCopy[i]);
                 log(src2$WhatToCopy[i]$" -> "$dest$"\\"$WhatToCopy[i]);
       Fcopy = class'filemanager'.static.CopyFile(src2$WhatToCopy[i],dest$"\\"$WhatToCopy[i], true, true);

     }
   }
}

/*-------------------------------------------------------------
  Сохраняет карту без информации об игроке
  Исследования показали что из файла сохранения нужно исключить
  как минимум контроллер, самого игрока и ReplicationInfo.
  Чтобы исключить актор, достаточно присвоить ему флаг
  RF_Transient, и движок при записи пропустит его.

  Эта функция вызывается из события PreClientTravel() в этом-же
  контроллере.

  09/05/2018: дополнительно нужно исключить:
  * Системы навыков и аугментаций
-------------------------------------------------------------*/
exec function SaveCurrentMap()
{
  local bool Fsave;
  local string Quick, sd;
    local DeusExLevelInfo info;
    local Augmentation aug;
    local Skill skl;
    local beam lt;
    local Inventory anItem;
    local LightProjector lp;

    info = GetLevelInfo();
    gl = class'DeusExGlobals'.static.GetGlobals();

    /* Исключает информацию из сохранения */
  class'ObjectManager'.static.SetObjectFlags(pawn, RF_Transient); // исключить игрока
  class'ObjectManager'.static.SetObjectFlags(PlayerReplicationInfo, RF_Transient); // исключить PlayerReplicationInfo
  class'ObjectManager'.static.SetObjectFlags(self, RF_Transient); // исключить контроллер

  if (human(pawn).carriedDecoration != none)
  class'ObjectManager'.static.SetObjectFlags(Human(pawn).carriedDecoration, RF_Transient); // исключить переносимый предмет, поскольку Destroy() на него не действует ((

  if (human(pawn).AugmentationSystem != none)
  class'ObjectManager'.static.SetObjectFlags(Human(pawn).AugmentationSystem, RF_Transient);

  if (human(pawn).SkillSystem != none)
  class'ObjectManager'.static.SetObjectFlags(Human(pawn).SkillSystem, RF_Transient);

  for (anItem=pawn.Inventory; anItem!=None; anItem=anItem.Inventory)
  {
//    gl.SaveInventoryItem(anItem, anItem.GetInvPosX(), anItem.GetInvPosY(), anItem.GetBeltPos());
//    class'ObjectManager'.static.SetObjectFlags(anItem, RF_Transient);
    log("setting RF_Transient for "$anItem);
    //pawn.DeleteInventory(anItem);
  }

/*  foreach AllActors(class'Inventory', inv)
  {
    if (inv.owner.IsA('DeusExPlayer'))
    {
      log("Transient inventory:"@amm);
      class'ObjectManager'.static.SetObjectFlags(inv, RF_Transient);
    }
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
  foreach AllActors(class'LightProjector', lp)
  {
    if (lt != none)
    class'ObjectManager'.static.SetObjectFlags(lp, RF_Transient);
  }


  consolecommand("SAVEGAME 100");

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
  Проверить, существует ли сохраненный вариант карты.
  Возвращает True если да.
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
//      ClientMessage(whatWasFound[i]);
      SaveWithPath=ds;
//    ClientMessage(ts);
//    ClientMessage(ds@"= True");
      return true;
      break;
    }
    if (whatWasFound[i] != ts)
    {
//      ClientMessage(whatWasFound[i]);
//    ClientMessage(ts@"=False");
      log("Saved version of "$whatMap$" not found",'SaveSystem');
      return false;
      break;
    }
  }
}

/*--- Встроенные в UT средства записи пакетов ---*/
/* Сначала необходимо освободить и удалить файл с данными. */
/* Для быстрого сохранения */
exec function CreateSaveInfoQuick()
{
  local DeusExGameInfo hx;
  local DeusExSaveInfo dx;

  hx = DeusExGameInfo(level.game);

//  class'PackageManager'.static.ReleasePackage("..\\Saves\\SaveInfo.uvx", 0x0010);
  class'FileManager'.static.DeleteFile("..\\Saves\\SaveInfo.uvx", false, true);

  dx = hx.CreateDataObject(class'DeusExSaveInfo', "MyDeusExSaveInfo", "SaveInfo");
  dx.MapName=GetLevelInfo().mapName;
  dx.Description="Quick Save";      // User entered description
  dx.MissionLocation=GetLevelInfo().MissionLocation;    // Mission Location
  dx.saveCount = Human(pawn).saveCount++;           // По логике так должно быть
  dx.saveTime = Human(pawn).savetime;           // Duration of play, in seconds. Берется из DeusExPlayer
  dx.bCheatsEnabled = bCheatsEnabled;    // Set to TRUE If Cheats were enabled!!
  dx.Year = level.Year;             // Year.
  dx.Month = level.Month;               // Month.
  dx.Day = level.Day;               // Day of month.
  dx.Hour = level.Hour;             // Hour.
  dx.Minute =   level.Minute;           // Minute.
  dx.Second = level.Second;             // Second.

  hx.SavePackage("SaveInfo");
  hx.SavePlayerData();
}

/* ... и для отдельного слота */
exec function CreateSaveInfo(string slot, optional string desc)
{
  local DeusExGameInfo hx;
  local DeusExSaveInfo dx;

  hx = DeusExGameInfo(level.game);

//  class'PackageManager'.static.ReleasePackage("..\\Saves\\SaveInfo.uvx", 0x0010);
  class'FileManager'.static.DeleteFile("..\\Saves\\SaveInfo.uvx", false, true);

  dx = hx.CreateDataObject(class'DeusExSaveInfo', "MyDeusExSaveInfo", "SaveInfo");
  dx.MapName=GetLevelInfo().mapName;
  dx.Description=desc;      // User entered description
     if (desc == "")
        dx.Description = GetLevelInfo().MissionLocation; // Чтобы описание не было пустым :)
  dx.MissionLocation=GetLevelInfo().MissionLocation;    // Mission Location
  dx.saveCount = Human(pawn).saveCount++;           // По логике так должно быть
  dx.saveTime = Human(pawn).savetime;           // Duration of play, in seconds. Берется из DeusExPlayer
  dx.bCheatsEnabled = bCheatsEnabled;    // Set to TRUE If Cheats were enabled!!
  dx.Year = level.Year;             // Year.
  dx.Month = level.Month;               // Month.
  dx.Day = level.Day;               // Day of month.
  dx.Hour = level.Hour;             // Hour.
  dx.Minute =   level.Minute;           // Minute.
  dx.Second = level.Second;             // Second.

  hx.SavePackage("SaveInfo");
}

/*--- Для проверки ---*/
//exec function loadflags()
event PostLoadSavedGame()
{
  class'GameFlags'.static.ImportFlagsFromArray(class'DeusExGlobals'.static.GetGlobals().RawByteFlags);
  SetInitialState();
}

exec function saveflags()
{
  class'DeusExGlobals'.static.GetGlobals().RawByteFlags = class'GameFlags'.static.ExportFlagsToArray();
}





