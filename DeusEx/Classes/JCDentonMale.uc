//=============================================================================
// JCDentonMale.
//=============================================================================
class JCDentonMale extends Human config;

var travel class TravelClass;
var bool bMouseMode;

event TravelPostAccept()
{
    Super.TravelPostAccept();

    switch(PlayerSkin)
    {
        case 0: Skins[0] = Texture'JCDentonTex0'; break;
        case 1: Skins[0] = Texture'JCDentonTex4'; break;
        case 2: Skins[0] = Texture'JCDentonTex5'; break;
        case 3: Skins[0] = Texture'JCDentonTex6'; break;
        case 4: Skins[0] = Texture'JCDentonTex7'; break;
    }
}

// ----------------------------------------------------------------------
// Dumps the inventory grid to the log file.  Useful for debugging only.
// ----------------------------------------------------------------------
exec function DumpInventoryGrid()
{
    local int slotsCol;
    local int slotsRow;
    local String gridRow;

    log("DumpInventoryGrid()");
    log("_____________________________________________________________");
    
    log("        1 2 3 4 5");
    log("-----------------");


    for(slotsRow=0; slotsRow < maxInvRows; slotsRow++)
    {
        gridRow = "Row #" $ slotsRow $ ": ";

        for (slotsCol=0; slotsCol < maxInvCols; slotsCol++)
        {
            if ( invSlots[(slotsRow * maxInvCols) + slotsCol] == 1)
                gridRow = gridRow $ "X ";
            else
                gridRow = gridRow $ "  ";
        }
        
        log(gridRow);
    }
    log("_____________________________________________________________");
}


exec function Quick()
{
  local bool Fsave;
  local string Quick, sd;

  sd = ConsoleCommand("get System savepath");
  Quick = sd$"\\QuickSave";
  Fsave = class'filemanager'.static.MakeDirectory(Quick, true);
  Fsave = class'filemanager'.static.CopyFile(sd$"\\Save9.usa", Quick$"\\"$GetLevelInfo().mapName$".dxs", true, true);
  ClientMessage("яSaved map яяя"$GetLevelInfo().mapName);
}

exec function LoadQuick()
{
  Level.GetLocalPlayerController().ClientTravel("..\\DXSave\\QuickSave\\02_NYC_Street.dxs", TRAVEL_Absolute, false);
}


/*native static function SetFlag(Flag Flag);
native static function bool GetFlag(string Id, out Flag Flag);
native static function Array<string> GetAllFlagIds();

native static function Array<byte> ExportFlagsToArray();
native static function ImportFlagsFromArray(Array<byte> SerializedFlags);*/

exec function SaveFlg()
{
  local GameFlags.Flag flg;

  flg.id = "testflag1";
  flg.value = 1; // true
  flg.ExpireLevel = 99;
  class'GameFlags'.static.SetFlag(flg);


  flg.id = "testflag2";
  flg.value = 1; // true 
  flg.ExpireLevel = 99;
  class'GameFlags'.static.SetFlag(flg);

//  store = class'GameFlags'.static.ExportFlagsToArray();
}

exec function RstFlg()
{
//  local GameFlags.Flag flg;

//  class'GameFlags'.static.ImportFlagsFromArray(store);
}

exec function saveCon()
{
   saveconfig();
}

exec function loadmap()
{
  Level.GetLocalPlayerController().ClientOpenMenu("DXRMenu.DXRLoadMap");
}

exec function listflags()
{
  Level.GetLocalPlayerController().ClientOpenMenu("DXRMenu.DXRFlags");
}

exec function listInv()
{
  local inventory i;

  foreach AllActors(class'Inventory', i)
  {
    log("All Inventory actors, owner, invPosX && invPosY: "$i@i.Owner@i.GetInvPosX()@i.GetInvPosY());
  }
}

exec function findammo()
{
  local ammunition a;

  foreach AllActors(class'Ammunition', a)
  {
    log("found ammunition: "$a);
  }
}


exec function findconv()
{
 local int y;

  for (y=0; y<conList.length; y++)
  {
     log("Output: "$conList[y],'RealSpamLog');
     if (conList[y].Name ~= "Woman_BarkTearGas")
     log("found in "$conList[y]);
  }
}

// Совпадение здесь и там! 561=561
exec function flagrefs()
{
  local conFlagRef f;
  local int count;

  foreach AllObjects(class'conFlagRef', f)
  {
    count++;
  }
  log(count);
}

exec function s2(string Path)
{
  local sound LastPlayedSound;

    class'SoundManager'.static.LoadSound(Path, LastPlayedSound, Self);
    PlaySound(LastPlayedSound, SLOT_None, 800, False);
}


exec function CheckConRadius()
{
  local ConDialogue cd;
  foreach AllObjects(class'ConDialogue', cd)
  {
    if (cd.bInvokeRadius)
    {
      log(cd$" invokeradius="$cd.InvokeRadius$" ownerName="$cd.OwnerName);
    }
  }
}

exec function FindLabel(/*string label, */ConDialogue con)
{
  local int k;

   for (k=0; k<con.EventList.length; k++)
   {
      if (con.EventList[k].Label != "")
          log(con.EventList[k]$" has label ="$con.EventList[k].Label, 'ConEvent');
   }
}

exec function testDM()
{
   local DelayedMessage dm;

   dm = spawn(class'DelayedMessage', none);
   dm.SetPlayer(self);
   dm.Activate();
}

exec function testwm()
{
  local string s;

  s = consoleCommand("get ini:Engine.Engine.ViewportManager WindowedViewportX");
  ClientMessage(s);
}

exec function unhidePawns()
{
   local ScriptedPawn sp;

   foreach AllActors(class'ScriptedPawn', sp)
   {
      sp.EnterWorld();
   }
}

// 13 1084
exec function TestJump(int zapros)
{
   local ConEventJump jump;

   forEach AllObjects(class'ConEventJump', jump)
   {
      if (jump.ConId == zapros)
      log(jump);
   }
}

// 13 1084
exec function TestID(int zapros)
{
   local ConDialogue con;

   forEach AllObjects(class'ConDialogue', con)
   {
      if (con.Id == zapros)
      log(con);
   }
}

exec function debugcon()
{
    local HudOverlay_ConWindowThird conwin;

    conwin = Spawn(class'HudOverlay_ConWindowThird',self);
    DeusExHUD(level.GetLocalPlayerController().myHUD).AddHudOverlay(conwin);
}

exec function invokeCon()
{
  Level.GetLocalPlayerController().ClientOpenMenu("DXRMenu.InvokeConWindow");
}



// Used to check var travel class.
/*exec function SetTravelClass(class InTravelClass)
{
    TravelClass = InTravelClass;

    log( "TravelClass is now "$InTravelClass);
}

exec function GetTravelClass()
{
    log( "TravelClass is "$TravelClass);
}*/

exec function mTest()
{
  bMouseMode = !bMouseMode;

  if (bMouseMode)
  controller.GoToState('PlayerMousing');
  else
  controller.GoToState('PlayerWalking');
}


// Индекс актора
exec function ActorIdx()
{
  local pawn can;
  local int CycleIndex;

  foreach CycleActors(class'Pawn', can, CycleIndex)
  {
     log("Actor="$can$", Index="$CycleIndex);
  }
}

exec function testQ()
{
  local HudOverlay_EndGameQuotes test;

  test = spawn(class'HudOverlay_EndGameQuotes');
    DeusExHud(DeusExPlayerController(Level.GetLocalPlayerController()).myHUD).AddHudOverlay(test);
    test.message = "Проверка сообщения|Checking message|Message test|Testing messages|Checking the area, possible contact";
  test.StartMessage();
}


exec function spd() // в® Ґбвм SavePlayerData()
{
  DeusExGameInfo(Level.game).SavePlayerData();
}

exec function rpd() // RestorePlayerData
{
  DeusExGameInfo(Level.game).RestorePlayerData("..\\Saves");
}

// Отображает информацию без переключения на этот актор
exec function DebugPawn(name ActorName)
{
    local Actor A;

    ForEach AllActors(class'Actor', A)
        if (A.Name == ActorName)
        {
            PlayerController(Controller).SetViewTarget(A);
            PlayerController(Controller).myHUD.bShowDebugInfo = true;
            PlayerController(Controller).bBehindView = false;
            return;
        }
}

exec function reachPath()
{
  local navigationPoint np;
  local int i;

  log("NavPoints within 1000 UU ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");

  for (Np=Level.NavigationPointList; Np!=None; Np=Np.NextNavigationPoint )
  {
    if (Abs(VSize(NP.Location - Location)) <= 1000)
    {
      if (controller.PointReachable(np.location))
      {
       for (i=0; i<np.PathList.Length;i++)
       {
          log(np @ np.pathlist[i]$" distance = " $ np.pathlist[i].distance);
       }
      }
    }
  }
}

//ScriptLog: NavPoint and dist = Autoplay.PathNode408 251.000000
//ScriptLog: NavPoint and dist = Autoplay.PathNode28 354.000000
/*
ScriptLog: 01_Nyc_UnatcoIsland.PathNode28 01_Nyc_UnatcoIsland.ReachSpec40265 distance = 227
ScriptLog: 01_Nyc_UnatcoIsland.PathNode28 01_Nyc_UnatcoIsland.ReachSpec40264 distance = 317
ScriptLog: 01_Nyc_UnatcoIsland.PathNode28 01_Nyc_UnatcoIsland.ReachSpec40270 distance = 359
ScriptLog: 01_Nyc_UnatcoIsland.PathNode28 01_Nyc_UnatcoIsland.ReachSpec40271 distance = 457
ScriptLog: 01_Nyc_UnatcoIsland.PathNode28 01_Nyc_UnatcoIsland.ReachSpec40266 distance = 575

ScriptLog: 01_Nyc_UnatcoIsland.PathNode407 01_Nyc_UnatcoIsland.ReachSpec35598 distance = 317
ScriptLog: 01_Nyc_UnatcoIsland.PathNode407 01_Nyc_UnatcoIsland.ReachSpec35603 distance = 342
ScriptLog: 01_Nyc_UnatcoIsland.PathNode407 01_Nyc_UnatcoIsland.ReachSpec35607 distance = 372
ScriptLog: 01_Nyc_UnatcoIsland.PathNode407 01_Nyc_UnatcoIsland.ReachSpec35604 distance = 538
ScriptLog: 01_Nyc_UnatcoIsland.PathNode407 01_Nyc_UnatcoIsland.ReachSpec35609 distance = 539

ScriptLog: 01_Nyc_UnatcoIsland.PathNode408 01_Nyc_UnatcoIsland.ReachSpec35583 distance = 227
ScriptLog: 01_Nyc_UnatcoIsland.PathNode408 01_Nyc_UnatcoIsland.ReachSpec35588 distance = 315
ScriptLog: 01_Nyc_UnatcoIsland.PathNode408 01_Nyc_UnatcoIsland.ReachSpec35589 distance = 452
ScriptLog: 01_Nyc_UnatcoIsland.PathNode408 01_Nyc_UnatcoIsland.ReachSpec35585 distance = 646

ScriptLog: 01_Nyc_UnatcoIsland.MapExit0 01_Nyc_UnatcoIsland.ReachSpec23265 distance = 315
ScriptLog: 01_Nyc_UnatcoIsland.MapExit0 01_Nyc_UnatcoIsland.ReachSpec23262 distance = 359
ScriptLog: 01_Nyc_UnatcoIsland.MapExit0 01_Nyc_UnatcoIsland.ReachSpec23267 distance = 912

ScriptLog: 01_Nyc_UnatcoIsland.PathNode476 01_Nyc_UnatcoIsland.ReachSpec17534 distance = 240
ScriptLog: 01_Nyc_UnatcoIsland.PathNode476 01_Nyc_UnatcoIsland.ReachSpec17528 distance = 372
ScriptLog: 01_Nyc_UnatcoIsland.PathNode476 01_Nyc_UnatcoIsland.ReachSpec17530 distance = 452
ScriptLog: 01_Nyc_UnatcoIsland.PathNode476 01_Nyc_UnatcoIsland.ReachSpec17527 distance = 457
*/

exec function m08()
{
   GetFlagBase().SetBool('StantonDowd_Played', true,, 9);
   GetFlagBase().SetBool('DL_Exit_Played', true,, 9);
}

exec function m09()
{
   GetFlagBase().SetBool('MS_ShipBreeched', true,, 9);
}

function PostSaveGame()
{
   ClientMessage("PostSaveGame() from UDxrNativeGameEngine called!");
      log("PostSaveGame() from UDxrNativeGameEngine called!");
}

exec function DVect()
{
   local vector vc;

   vc = vect(-10.000000,14.000000,22.000000);

   log(vc / 90);

//(X=-10.000000,Y=14.000000,Z=22.000000)
}

exec function Radar()
{
   bRadarActive =!bRadarActive;
}

exec function audioLog()
{
   spawn(class'HUDOverlay_AudioLog');
}

exec function wtF()
{
/*  local inventory anItem;

  for (anItem=Inventory; anItem!=None; anItem=anItem.Inventory)
       if (!anitem.IsA('Powerups'))
           anItem.TravelPostAccept();*/


    log(class'DeusExGameEngine'.static.GetEngine().GLevel);
}

exec function SaveTest()
{
   local DeusExGameEngine UDXR;

   UDXR = class'DeusExGameEngine'.static.GetEngine();
   UDXR.SaveGameEx("..\\DXSave\\Test1.dxs");
}

exec function LoadTest()
{
   Level.GetLocalPlayerController().ClientTravel("..\\DXSave\\Test1.dxs?load?", TRAVEL_Absolute, false);
//       Level.GetLocalPlayerController().ClientTravel( "?load=9", TRAVEL_Absolute, false);
}
/*
RandomBiasedRotation_Yaw( 0, 0.5, 0, 0.5 ) //
RandomBiasedRotation_Pitch( 0, 0.5, 0, 0.5 ) //

  RandomBiasedRotation_Yaw(0, 0.0, 0, 1.0).txt //
RandomBiasedRotation_Pitch(0, 0.0, 0, 1.0).txt //

   RandomBiasedRotation_Yaw(0, 1.0, 0, 0.0).txt
RandomBiasedRotation_Pitch( 0, 1.0, 0, 0.0).txt



*/
exec function aWholeBunch()
{
  local rotator rt;
  local int i;

  for (i=0; i<100000; i++)
  {
     rt = RandomBiasedRotation(0, 0.0, 0, 1.0);
     log(rt.Pitch,'Pitch');
//     log(rt.Yaw,'Yaw');
  }
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     CarcassType=Class'DeusEx.JCDentonMaleCarcass'
     JumpSound=Sound'DeusExSounds.Player.MaleJump'
     HitSound1=Sound'DeusExSounds.Player.MalePainSmall'
     HitSound2=Sound'DeusExSounds.Player.MalePainMedium'
     Land=Sound'DeusExSounds.Player.MaleLand'
     die=Sound'DeusExSounds.Player.MaleDeath'
     Mesh=Mesh'DeusExCharacters.GM_Trench'
     skins(0)=Texture'DeusExCharacters.Skins.JCDentonTex0'
     skins(1)=Texture'DeusExCharacters.Skins.JCDentonTex2'
     skins(2)=Texture'DeusExCharacters.Skins.JCDentonTex3'
     skins(3)=Texture'DeusExCharacters.Skins.JCDentonTex0'
     skins(4)=Texture'DeusExCharacters.Skins.JCDentonTex1'
     skins(5)=Texture'DeusExCharacters.Skins.JCDentonTex2'
     skins(6)=Material'DeusExCharacters.Skins.SH_FramesTex4'
     skins(7)=Material'DeusExCharacters.Skins.FB_LensesTex5'
}
