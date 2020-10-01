//
// GameInfoExt
// FlagSystem, переписанные функции, коррекция скорости игры.
//

class GameInfoExt extends GameInfo;

var int defaultFlagExpiration;

/*enum EFlagType
{
    FLAG_Bool,
    FLAG_Byte,
    FLAG_Int,
    FLAG_Float,
    FLAG_Name,
    FLAG_Vector,
    FLAG_Rotator,
};*/

event InitGame(string Options, out string Error)
{
    class'DeusExGlobals'.Static.GetGlobals().DxLevelInfo = GetLevelInfo();

    Super.InitGame(Options, Error);
    ClearCurrentDirectory();
}

function DeusExLevelInfo GetLevelInfo()
{
    local DeusExLevelInfo info;

    foreach AllActors(class'DeusExLevelInfo', info)
        break;
    return info;
}


/* Очистить каталог Save\Current */
function ClearCurrentDirectory()
{
  local int v;
  local array<string> c;
  local string sd, current;
  local DeusExGlobals globals;

  globals = class'DeusExGlobals'.static.GetGlobals();
  sd = ConsoleCommand("get System savepath");
  current = sd$"\\Current\\";

   if (!Globals.CurrentSaveDirectoryCleared)
   {
//   log(globals @ Globals.CurrentSaveDirectoryCleared);
     Globals.CurrentSaveDirectoryCleared = true;
//   log(globals @ Globals.CurrentSaveDirectoryCleared);
     c = class'filemanager'.static.FindFiles(current$"*.dxs", true, false);

     if (c.length > 0)
     {
       for(v=0; v<c.length; v++)
       {
        log("Removing file from ''Current'' directory: " $ c[v]);
        class'filemanager'.static.DeleteFile(current $ c[v], false, true);
       }
      }
      else
      log("''Current'' directory is empty.");
   }
}

/*
  Управление FlagSystem как в оригинале (wrapper). Указатель на GameInfo 
  все равно нужно получать :D
  Поддерживаются типы флагов bool и int.
  native static function Array<string> GetAllFlagIds();
*/

final function bool SetInt(coerce String flagName, int newValue, optional bool bAdd, optional int expiration)
{
  local GameFlags.Flag Flag;

  Flag.Id = flagname;
  Flag.Value = newValue;
  Flag.ExpireLevel = expiration;

  class'GameFlags'.static.SetFlag(Flag);

  return true;
}

final function int GetInt(coerce String flagName)
{
  local GameFlags.Flag Flag;

  if (class'GameFlags'.static.GetFlag(flagName, Flag))
  return flag.Value;

  else return -1;
}

final function bool SetBool(coerce String flagName, bool newValue, optional bool bAdd, optional int expiration)
{
  local GameFlags.Flag Flag;

  Flag.Id = flagname;

   if (newValue == true)
       Flag.Value = 1;
   else 
       if (newValue == false)
    Flag.Value = 0;

    Flag.ExpireLevel = expiration;

  class'GameFlags'.static.SetFlag(Flag);
  log("SetFlag="$flagName$", value="$newValue$", expires at mission "$expiration,'FlagSystem');

  return true;
}

/*final function bool GetBool(coerce String flagName)
{
  local GameFlags.Flag Flag;
  local bool bResult;

  if (class'GameFlags'.static.GetFlag(flagName, Flag))
  {
     if (flag.value == 0)
         bResult = false;
     else if (flag.value == 1)
         bResult = true;
  }

//  bResult = class'GameFlags'.static.GetFlag(flagName, Flag);
//  log("Checking value of flag: "$flagName$"="$bResult, 'FlagSystem');

  return bResult;
}*/

final function bool GetBool(coerce String flagName) {
    local GameFlags.Flag Flag;
    local bool bResult;

    bResult = class'GameFlags'.static.GetFlag(flagName, Flag) && flag.value == 1;
//  log("GetBool for flag "$flagName$" result = "$bResult);
    return bResult;
}

final function bool CheckFlag(coerce String flagName/*, optional EFlagType flagType*/)
{
  local GameFlags.Flag Flag;

  return class'GameFlags'.static.GetFlag(flagName, Flag);

/*  if (class'GameFlags'.static.GetFlag(flagname, Flag))
  {
   if (flagname == flag.id)
      return true;
  }
  return false;*/
}

final function bool DeleteFlag(coerce String flagName/*, optional EFlagType flagType*/)
{
  local GameFlags.Flag Flag;

  if (class'GameFlags'.static.GetFlag(flagName, Flag))
  {
    class'GameFlags'.static.DeleteFlag(flagName);
    return true;
  }
 else return false;
}

final function SetExpiration(coerce String flagName, /*EFlagType flagType,*/ int expiration)
{
  local GameFlags.Flag Flag;

  if (class'GameFlags'.static.GetFlag(flagname, Flag))
  {
    Flag.ExpireLevel = expiration;
    class'GameFlags'.static.SetFlag(Flag);
  }
}

final function int GetExpiration(coerce String flagName /*,EFlagType flagType*/)
{
  local GameFlags.Flag Flag;

  if (class'GameFlags'.static.GetFlag(flagname, Flag))
  {
    return Flag.ExpireLevel;
  }
  return 0;
}

// Moved to C++
final function DeleteExpiredFlags(int criteria)
{
/*  local array<string> myFlags;
    local int i;

    myFlags = class'GameFlags'.static.GetAllFlagIds(true); // True -- вернуть в регистре "как есть"

    for (i=0; i<myFlags.Length; i++)
    {
      if (Getexpiration(myFlags[i], FLAG_Bool) >= criteria)
        DeleteFlag(myFlags[i]);
    }*/
    //log(myFlags[i],'ExpiredFlag');

  class'GameFlags'.static.DeleteExpiredFlags(criteria);
  log("Deleted expired flags up to "$criteria,'FlagSystem');
}

final function SetDefaultExpiration(int expiration)
{
    defaultFlagExpiration = expiration;
}

final function DeleteAllFlags()
{
  local array<string> myFlags;
    local int i;

    myFlags = class'GameFlags'.static.GetAllFlagIds(false); // True -- вернуть в регистре "как есть"

    for (i=0; i<myFlags.Length; i++)
    {
      class'GameFlags'.static.DeleteFlag(myFlags[i]);
    }
    log("All flags removed",'FlagSystem');
}

// Delete Almost All flags!
final function DeleteAlmostAllFlags()
{
  local array<string> myFlags;
    local int i;

    myFlags = class'GameFlags'.static.GetAllFlagIds(false); // True -- вернуть в регистре "как есть"
    for (i=0; i<myFlags.Length; i++)
    {
      if (myFlags[i] ~= "SKTemp_SkillPointsAvail")
      continue;
      if (myFlags[i] ~= "SKTemp_SkillPointsTotal")
      continue;

   class'GameFlags'.static.DeleteFlag(myFlags[i]);
    }
    log("Almost all flags removed !",'FlagSystem');
}

function ResetFlags()
{
   DeleteAlmostAllFlags();
}


// Do nothing.
function DiscardInventory(Pawn Other);
function ScoreKill(Controller Killer, Controller Other);
function AddDefaultInventory(pawn PlayerPawn)
{
   // do nothing
}

// 
// Установка правильной скорости игры.
// Super().WrongThings не вызывается!!!
//
function SetGameSpeed(Float T)
{
    local float OldSpeed;

    if (!AllowGameSpeedChange())
    {
        Level.TimeDilation = 1.0;
        GameSpeed = 1.0;
        Default.GameSpeed = GameSpeed;
    }
    else
    {
        OldSpeed = GameSpeed;
        GameSpeed = FMax(T, 0.1);
        Level.TimeDilation = 1.0 * GameSpeed;
        if ( GameSpeed != OldSpeed )
        {
            Default.GameSpeed = GameSpeed;
            class'GameInfo'.static.StaticSaveConfig();
        }
    }
    SetTimer(Level.TimeDilation, true);
}

function bool AllowGameSpeedChange()
{
    if (Level.NetMode == NM_Standalone)
        return true;
    else
        return false;
}

function bool ShouldRespawn(Pickup Other)
{
   return false;
}





















