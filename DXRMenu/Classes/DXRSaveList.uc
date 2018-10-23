/* Список сохранений */

class DXRSaveList extends GUI2K4MultiColumnList;

CONST SAVEDIRMASK = "*save*.*";

struct SaveStruct
{
    var string ExtraData;
    var string SaveName;
    var string SaveDate;
    var texture screenshot;
    var string path;
    var string map;
};

var localized string strName, strLocation, strSaveCount, strPlayTime, strCheatsEnabled;
//Name:"$tempArray[1]$"|Location: " $ tempArray[2] $"|Save count: "$ tempArray[3] $"|Play time : "$class'DxUtil'.static.SecondsToTime(int(tempArray[4]))$"|Cheats enabled? "$tempArray[5];

var() array<SaveStruct> SaveData;
var string MySelectionStyle;
var GUIStyles SelStyle;
var string current;

function testfunca()
{
 log(self@" test func a");
}

/* прочитать информацию из SaveInfo.dxs и передать её.*/
function string GetSaveInfoData(string file, int what)
{
  local object dxs, ds;
//  local DeusExGameInfo inf;
  local array<string> tempArray;

//  inf = DeusExGameInfo(PlayerOwner().level.game);

  dxs = class'PackageManager'.static.LoadUnrealPackage(file, 0x0000);
  ds = dxs.DynamicLoadObject("SaveInfo.MyDeusExSaveInfo", class'DeusExSaveInfo');

  tempArray[0] = DeusExSaveInfo(ds).mapName;
  tempArray[1] = DeusExSaveInfo(ds).Description;		// User entered description
  tempArray[2] = DeusExSaveInfo(ds).MissionLocation;	// Mission Location
  tempArray[3] = string(DeusExSaveInfo(ds).saveCount);			// По логике так должно быть
  tempArray[4] = string(DeusExSaveInfo(ds).saveTime);			// Duration of play, in seconds. Берется из DeusExPlayer
  tempArray[5] = string(DeusExSaveInfo(ds).bCheatsEnabled);    // Set to TRUE If Cheats were enabled!!

/*  tempArray[6] = string(DeusExSaveInfo(ds).Year);
  tempArray[7] = string(DeusExSaveInfo(ds).Month);
  tempArray[8] = string(DeusExSaveInfo(ds).Day);
  tempArray[9] = string(DeusExSaveInfo(ds).Hour);
  tempArray[10] = string(DeusExSaveInfo(ds).Minute);
  tempArray[11] = string(DeusExSaveInfo(ds).Second);*/

  /* ...как-то сложно все это выглядит, не знаю...*/

  class'PackageManager'.static.UnloadUnrealPackage(dxs);

  if (what == 6)
  return class'DxUtil'.static.GetFileTime(file);
//  "Date: "$tempArray[6]$"."$tempArray[7]$"."$tempArray[8]$" Time: "$tempArray[9]$":"$tempArray[10]$":"$tempArray[11];

  if (what == 0)
  return strName $ tempArray[1] $ strLocation $ tempArray[2] $ strSaveCount $ tempArray[3] $ strPlayTime $ class'DxUtil'.static.SecondsToTime(int(tempArray[4])) $ strCheatsEnabled $ tempArray[5];

  if (what == 1)
  return tempArray[1];

  if (what == 2)
  return file;

  if (what == 3)
  return tempArray[0];

/*  if (what == 4)
  return tempArray[4];

  if (what == 5)
  return tempArray[5];*/
}


function bool InternalOnClick(GUIComponent Sender)
{
//  testfunca();
  super.InternalOnClick(Sender);

  if (DXRLoadWindow(PageOwner) != none)
    {
      DXRLoadWindow(PageOwner).sScreenShot.image = SaveData[CurrentListId()].screenshot;
      DXRLoadWindow(PageOwner).InternalOnClick(self);
    }

  if (DXRSaveWindow(PageOwner) != none)
    {
      DXRSaveWindow(PageOwner).sScreenShot.image = SaveData[CurrentListId()].screenshot;
      DXRSaveWindow(PageOwner).InternalOnClick(self);
    }

//     = lSaveList.alist.SaveData[lSaveList.alist.CurrentListId()].screenshot;
  
  return true;// super.InternalOnClick(Sender);
}


function FindSaveGames()
{
  local int i;
  local string sd;
  local array<string> dirs;
//  local array<string> datastrings;

  sd = PlayerOwner().ConsoleCommand("get System savepath");

//native static function Array<string> FindFiles(string Path, bool DoListFiles, bool DoListDirs);
  dirs = class'filemanager'.static.FindFiles(sd$"\\"$SAVEDIRMASK, false, true);

  for(i=0; i<dirs.length; i++)
  {
    SaveData.Length=dirs.length;

    SaveData[i].ExtraData = GetSaveInfoData(sd$"\\"$dirs[i]$"\\saveinfo.dxs", 0);
    SaveData[i].SaveName = GetSaveInfoData(sd$"\\"$dirs[i]$"\\saveinfo.dxs", 1); //sd$"\\"$dirs[i];
    SaveData[i].SaveDate = GetSaveInfoData(sd$"\\"$dirs[i]$"\\saveinfo.dxs", 6); //GetSaveInfoData(sd$"\\"$dirs[i]$"\\saveinfo.dxs"); //GetFileTime(sd$"\\"$dirs[i]$"\\saveinfo.dxs");
    SaveData[i].path = sd$"\\"$dirs[i];
    SaveData[i].screenshot = class'DxUtil'.static.Jpg2Tex(sd$"\\"$dirs[i]$"\\ScreenShot.jpg");
    SaveData[i].map = GetSaveInfoData(sd$"\\"$dirs[i]$"\\saveinfo.dxs", 3);
    AddedItem();
  }

//  SaveData.Length=data.length;

/*  for(i=0; i<dirs.length; i++)
  {
    files = class'filemanager'.static.FindFiles(sd$"\\"$dirs[i]$"\\saveinfo.*", true, false);
    log(sd$"\\"$dirs[i]);
    SaveData[i].SaveName=data[i];
    AddedItem();
  }*/

/*    if (files.length > 0)
    {
      for(k=0; k<files.length; k++)
      {
         log(files[k]);
      }
    }*/
}


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
//    ResX = MyController.ResX;

    // set delegates
    OnDrawItem  = MyOnDrawItem;

    Super.Initcomponent(MyController, MyOwner);
    SelStyle = Controller.GetStyle(MySelectionStyle,FontScale);

    FindSaveGames();
}

function Clear()
{
    SaveData.Remove(0,SaveData.Length);
    ItemCount = 0;
    Super.Clear();
}

function MyOnDrawItem(Canvas Canvas, int i, float X, float Y, float W, float H, bool bSelected, bool bPending)
{
    local float CellLeft, CellWidth;

    // Draw the selection border
    if( bSelected )
        SelStyle.Draw(Canvas,MSAT_Pressed, X, Y-2, W, H+2 );

    GetCellLeftWidth(0, CellLeft , CellWidth);
    Style.DrawText(Canvas, MenuState, X+CellLeft, Y, CellWidth, H, TXTA_Left, ""$SaveData[SortData[i].SortItem].SaveName, FontScale);

    GetCellLeftWidth(1, CellLeft, CellWidth);
    Style.DrawText(Canvas, MenuState, X+CellLeft, Y, CellWidth, H, TXTA_Left, ""$SaveData[SortData[i].SortItem].SaveDate, FontScale);
}

function string GetSortString(int i)
{
    local string s;

    switch( SortColumn )
    {
    case 0:
        s = Left(caps(SaveData[i].SaveName), 2);
        break;
    case 1:
        s = Left(caps(SaveData[i].SaveDate), 8);
        break;
    default:
        s = Left(caps(SaveData[i].SaveDate), 8);
        break;
    }
    return s;
}


defaultproperties
{
    MySelectionStyle="STY_DXR_ListSelection"
    ColumnHeadings(0)="Name (Description)"
    ColumnHeadings(1)="Date & time"

    InitColumnPerc(0)=0.70
    InitColumnPerc(1)=0.30

    SortColumn=1
    SortDescending=False
    ExpandLastColumn=false      // If true & columns widths do not add up to 100%, last column will be stretched

    CellSpacing=0

    strName="Save Name: "
    strLocation="|Location: "
    strSaveCount="|Save count: "
    strPlayTime="|Play time: "
    strCheatsEnabled="|Cheats enabled = "
}
