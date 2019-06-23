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
		case 0:	Skins[0] = Texture'JCDentonTex0'; break;
		case 1:	Skins[0] = Texture'JCDentonTex4'; break;
		case 2:	Skins[0] = Texture'JCDentonTex5'; break;
		case 3:	Skins[0] = Texture'JCDentonTex6'; break;
		case 4:	Skins[0] = Texture'JCDentonTex7'; break;
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
  ClientMessage("�Saved map ���"$GetLevelInfo().mapName);
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

exec function testload()
{
  local object wtf;

  wtf = class'PackageManager'.static.LoadUnrealPackage("testContext.u", 0x0080);
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

// ���������� ����� � ���! 561=561
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

exec function getres(int bits)
{
/*	local array<GraphicsManager.Resolution> resl;
	local bool ret;
	ret = class'GraphicsManager'.static.GetResolutionList(resl, bits);
	ClientMessage("Resolution count: " $ resl.Length);
	if (resl.Length > 0)
	{
		ClientMessage("First resolution: " $ resl[0].Width $ "x" $ resl[0].Height);
	}*/
	local array<string> res;
	local int i;

	res = class'DxUtil'.static.GetScreenResolutions(bits);

  for (i=0; i<res.length; i++)
  {
     ClientMessage(res[i]);
  }
}


// ������ ������
exec function ActorIdx()
{
  local pawn can;
  local int CycleIndex;
  local DXRAiController cn;

  foreach AllActors(class'DXRAiController', cn)
  break;

  foreach cn.CycleActors(class'Pawn', can, CycleIndex)
  {
     log("Actor="$can$", Index="$CycleIndex);
  }
}

exec function reachspec()
{
   local reachspec rs;

   foreach AllObjects(class'ReachSpec', rs)
   {
    // �� � ��� ��� �������?
    // ����� ������������� ������ ��� �������, ��������� �� ������� � ������ 44.
      rs.CollisionHeight = 100;
      rs.CollisionRadius = 100;
   }
}

exec function defColl()
{
   SetDefaultCollisionSize(16, 20);
}

exec function testQ()
{
  local HudOverlay_EndGameQuotes test;

  test = spawn(class'HudOverlay_EndGameQuotes');
	DeusExHud(DeusExPlayerController(Level.GetLocalPlayerController()).myHUD).AddHudOverlay(test);
	test.message = "�������� ���������|Checking message|Message test|Testing messages|Checking the area, possible contact";
  test.StartMessage();
}


exec function spd() // � ���� SavePlayerData()
{
  DeusExGameInfo(Level.game).SavePlayerData();
}

exec function rpd() // RestorePlayerData
{
  DeusExGameInfo(Level.game).RestorePlayerData("..\\Saves");
}

// ���������� ���������� ��� ������������ �� ���� �����
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

exec function DxMover()
{
   local DeusExMover mv;
   local vector MinV, MaxV;
//   local vector extLoc;
//   local rotator extRot;

   foreach AllActors(class'DeusExMover', mv)
   {
//   break;

//   extLoc = mv.KeyPos[0]+mv.BasePos;
//   extRot = mv.KeyRot[0]+mv.BaseRot;

   mv.GetBoundingBox(MinV, MaxV);//,optional bool bExact,optional vector testLocation,optional rotator testRotation)
   log("Only first 2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
   log(mv.location);
   log(MinV);
   log(MaxV);
   }

/*   mv.GetBoundingBox(MinV, MaxV, false, extLoc, extRot);
   log("All  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
   log(mv.location);
   log(MinV);
   log(MaxV);
*/
}

exec function reachPath()
{
  local navigationPoint np;
  local int i;

  log("NavPoints within 1000 UU ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
  foreach RadiusActors(class'NavigationPoint', np, 1000, location)
  {
    if (controller.actorReachable(np))
    {
       for (i=0; i<np.PathList.Length;i++)
       {
          log(np @ np.pathlist[i]$" distance = " $ np.pathlist[i].distance);
       }
    }
  }
}

//ScriptLog: NavPoint and dist = Autoplay.PathNode408 251.000000 227
//ScriptLog: NavPoint and dist = Autoplay.PathNode28 354.000000 317
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

     bScriptPostRender=false
     bOnlyOwnerSee=false
}
