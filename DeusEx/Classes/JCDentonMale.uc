//=============================================================================
// JCDentonMale.
//=============================================================================
class JCDentonMale extends Human config;

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



function AddDXInventory(){}

exec function Quick()
{
  local bool Fsave;
  local string Quick, sd;

  sd = ConsoleCommand("get System savepath");
  Quick = sd$"\\QuickSave";
  Fsave = class'filemanager'.static.MakeDirectory(Quick, true);
  Fsave = class'filemanager'.static.CopyFile(sd$"\\Save9.usa", Quick$"\\"$GetLevelInfo().mapName$".dxs", true, true);
  ClientMessage("€Saved map €€€"$GetLevelInfo().mapName);
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

// —овпадение здесь и там! 561=561
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


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
		 CarcassType=Class'DeusEx.JCDentonMaleCarcass'
     //  JumpSound=Sound'DeusExSounds.Player.MaleJump'
     //  HitSound1=Sound'DeusExSounds.Player.MalePainSmall'
     //  HitSound2=Sound'DeusExSounds.Player.MalePainMedium'
     //  Land=Sound'DeusExSounds.Player.MaleLand'
//     die=Sound'DeusExSounds.Player.MaleDeath'
//     Mesh=VertMesh'DeusExCharacters.GM_Trench'
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
