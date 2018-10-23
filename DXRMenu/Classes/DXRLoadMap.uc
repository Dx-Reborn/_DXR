/*
   Load a map from list, like in DeusEx. 
   I will use fileManager to find maps.
*/

class DXRLoadMap extends DxWindowTemplate;

var GUIListBox mapList;
var GUIButton bLoad, bLoadTravel, bClose;

var() array<string> spisokKart;
var() string DXRMapsLocation, DXRMapsLocation_Linux, selectedMap;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);
	CreateLMControls();
}

function CreateLMControls()
{
  // list of maps in UT2004\Maps\DX\
  mapList = new class'GUIListBox'; 
  mapList.SelectedStyleName="STY_DXR_ListSelection";
  mapList.StyleName = "STY_DXR_Listbox";
  mapList.list.TextAlign=TXTA_Left;
  mapList.WinHeight = 245;
  mapList.WinWidth = 344;
  mapList.WinLeft = 16;
  mapList.WinTop = 32;
	AppendComponent(mapList, true);
  mapList.OnChange = MapListChange;
  mapList.MyScrollBar.WinWidth = 16;

  bLoad = new class'GUIButton';
  bLoad.OnClick=InternalOnClick;
  bLoad.fontScale = FNS_Small;
  bLoad.StyleName="STY_DXR_MediumButton";
  bLoad.Caption = "Just load";
  bLoad.Hint="Load map, travelling actors will not be saved";
  bLoad.WinHeight = 21;
  bLoad.WinWidth = 180;
  bLoad.WinLeft = 15;
  bLoad.WinTop = 306;
	AppendComponent(bLoad, true);

  bLoadTravel = new class'GUIButton';
  bLoadTravel.OnClick=InternalOnClick;
  bLoadTravel.fontScale = FNS_Small;
  bLoadTravel.StyleName="STY_DXR_MediumButton";
  bLoadTravel.Caption = "Travel to";
  bLoadTravel.Hint="Travel to this map, all travelling actors and variables will be saved.";
  bLoadTravel.WinHeight = 21;
  bLoadTravel.WinWidth = 180;
  bLoadTravel.WinLeft = 15;
  bLoadTravel.WinTop = 280;
	AppendComponent(bLoadTravel, true);

  bClose = new class'GUIButton';
  bClose.OnClick=InternalOnClick;
  bClose.fontScale = FNS_Small;
  bClose.StyleName="STY_DXR_MediumButton";
  bClose.Caption = "Close";
  bClose.Hint="Close this window";
  bClose.WinHeight = 21;
  bClose.WinWidth = 124;
  bClose.WinLeft = 220;
  bClose.WinTop = 280;
	AppendComponent(bClose, true);

	fillMapList();
}

function fillMapList()
{
  local int i;

  spisokKart = class'filemanager'.static.FindFiles(DXRMapsLocation $ "*.ut2", true, false);

	for (i=0;i<spisokKart.Length;i++)
	  	MapList.List.Add(spisokKart[i]);
}

function bool InternalOnClick(GuiComponent Sender)
{
 if (Sender==bLoadTravel)
  PlayerOwner().ClientTravel(DXRMapsLocation$selectedMap, TRAVEL_Relative, true);

 if (Sender==bLoad)
  PlayerOwner().ConsoleCommand("Open"@DXRMapsLocation$selectedMap);// $ "?loadonly");

 if (Sender==bClose)
  Controller.CloseMenu();

  return true;
}

function mapListChange(GUIComponent Sender)
{
  selectedMap = mapList.list.Get(true);
}


defaultproperties
{
    WinTitle="Load map"

		DefaultHeight=340
		DefaultWidth=370

		MaxPageHeight=340
		MaxPageWidth=370
		MinPageHeight=340
		MinPageWidth=370

    DXRMapsLocation="..\\Maps\\"
    DXRMapsLocation_Linux="..//Maps//DX//"

		leftEdgeCorrectorX=4
		leftEdgeCorrectorY=0
		leftEdgeHeight=168

		RightEdgeCorrectorX=405
		RightEdgeCorrectorY=20
		RightEdgeHeight=140

		TopEdgeCorrectorX=304
		TopEdgeCorrectorY=16
    TopEdgeLength=100

    TopRightCornerX=402
    TopRightCornerY=16

	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Texture'VisionBlue'
		ImageRenderStyle=MSTY_Normal
		ImageStyle=ISTY_PartialScaled
		ImageColor=(R=1,G=1,B=1,A=255)
		DropShadow=None
		WinWidth=362
		WinHeight=322
		WinLeft=8
		WinTop=20
		RenderWeight=0.000003
		bBoundToParent=True
		bScaleToParent=True
	End Object
	i_FrameBG=FloatingFrameBackground
}

