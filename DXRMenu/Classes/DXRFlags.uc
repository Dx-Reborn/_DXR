/* ------------------------------------------
   Список флагов (GameFlags)
------------------------------------------ */

class DXRFlags extends DXWindowTemplate;

var GUIListBox flagList;
var GUIEditBox eFlagName;
var GUIButton bSetTrue, bSetFalse, bExtra, bClose, bSave, bLoad, bDelete;
var array<String> FlagsArray;

function CreateMyControls()
{
  flagList = new(none) class'GUIListBox'; 
  flagList.SelectedStyleName="STY_DXR_ListSelection";
  flagList.StyleName = "STY_DXR_Listbox";
  flagList.list.TextAlign=TXTA_Left;
//  flagList.OnChange=ModListChange;
  flagList.WinHeight = 256;
  flagList.WinWidth = 512;
  flagList.WinLeft = 16;
  flagList.WinTop = 32;
	AppendComponent(flagList, true);

	eFlagName = new(none) class'GUIEditBox';
  eFlagName.StyleName="STY_DXR_EditBox";
	eFlagName.bScaleToParent = false;
	eFlagName.FontScale = FNS_Small;
	eFlagName.bMaskText = false;
	eFlagName.MaxWidth = 128;
	eFlagName.WinHeight = 18;
  eFlagName.WinWidth = 305;
  eFlagName.WinLeft = 226;
  eFlagName.WinTop = 363;
	AppendComponent(eFlagName, true);

	/* -- Кнопки ------------------------------------------------------- */
	bSetTrue = new(none) class'GUIButton';
  bSetTrue.StyleName="STY_DXR_MediumButton";
  bSetTrue.OnClick = InternalOnClick;
  bSetTrue.FontScale = FNS_Small;
  bSetTrue.WinHeight = 21;
  bSetTrue.WinWidth = 150;
  bSetTrue.WinLeft = 68;
  bSetTrue.WinTop = 292;
  bSetTrue.caption="Set True";
	AppendComponent(bSetTrue, true);

	bSetFalse = new(none) class'GUIButton';
  bSetFalse.StyleName="STY_DXR_MediumButton";
  bSetFalse.OnClick = InternalOnClick;
  bSetFalse.FontScale = FNS_Small;
  bSetFalse.WinHeight = 21;
  bSetFalse.WinWidth = 150;
  bSetFalse.WinLeft = 224;
  bSetFalse.WinTop = 292;
  bSetFalse.caption="Set False";
	AppendComponent(bSetFalse, true);

	bExtra = new(none) class'GUIButton';
  bExtra.StyleName="STY_DXR_MediumButton";
  bExtra.OnClick = InternalOnClick;
  bExtra.FontScale = FNS_Small;
  bExtra.WinHeight = 21;
  bExtra.WinWidth = 150;
  bExtra.WinLeft = 380;
  bExtra.WinTop = 292;
  bExtra.caption="Add flag";
	AppendComponent(bExtra, true);
	/* ---------------------------------------------------------------------- */
	bClose = new(none) class'GUIButton';
  bClose.StyleName="STY_DXR_MediumButton";
  bClose.OnClick = InternalOnClick;
  bClose.FontScale = FNS_Small;
  bClose.WinHeight = 21;
  bClose.WinWidth = 150;
  bClose.WinLeft = 68;
  bClose.WinTop = 328;
  bClose.caption="Close";
	AppendComponent(bClose, true);

	bSave = new(none) class'GUIButton';
  bSave.StyleName="STY_DXR_MediumButton";
  bSave.OnClick = InternalOnClick;
  bSave.FontScale = FNS_Small;
  bSave.WinHeight = 21;
  bSave.WinWidth = 150;
  bSave.WinLeft = 224;
  bSave.WinTop = 328;
  bSave.caption="SaveToPlayer";
	AppendComponent(bSave, true);

	bLoad = new(none) class'GUIButton';
  bLoad.StyleName="STY_DXR_MediumButton";
  bLoad.OnClick = InternalOnClick;
  bLoad.FontScale = FNS_Small;
  bLoad.WinHeight = 21;
  bLoad.WinWidth = 150;
  bLoad.WinLeft = 380;
  bLoad.WinTop = 328;
  bLoad.caption="LoadFromPlayer";
	AppendComponent(bLoad, true);
	/* ---------------------------------------------------------------------- */
	bDelete = new(none) class'GUIButton';
  bDelete.StyleName="STY_DXR_MediumButton";
  bDelete.OnClick = InternalOnClick;
  bDelete.FontScale = FNS_Small;
  bDelete.WinHeight = 21;
  bDelete.WinWidth = 150;
  bDelete.WinLeft = 68;
  bDelete.WinTop = 364;
  bDelete.caption="Delete";
	AppendComponent(bDelete, true);

	fillList();
}

function fillList()
{
  local int x;
  local gameflags.flag Flag;

  flagList.List.Clear();
  flagsArray.length = 0;

  FlagsArray = class'GameFlags'.static.GetAllFlagIds(true);

  if (FlagsArray.Length > 0)
  {
   for(x=0; x<FlagsArray.Length; x++)
   {
     flagList.List.Add(FlagsArray[x] $" = "$ class'GameFlags'.static.GetFlag(FlagsArray[x], Flag) $"("$ flag.value $ ")");
   }
  }
}


function bool InternalOnClick(GUIComponent Sender)
{
  if (Sender == bSetTrue) // Выставить значение флага в True
  {
     DeusExGameInfo(PlayerOwner().level.game).SetBool(flagList.list.Get(true), true,,);
     fillList();
  }
  if (Sender == bSetFalse) //...false
  {
     DeusExGameInfo(PlayerOwner().level.game).SetBool(flagList.list.Get(false), true,,);
     fillList();
  }
  if (Sender == bExtra)
  {

  }
  if (Sender == bClose)
  {
     Controller.CloseMenu();
  }
  return false;
}

defaultproperties
{
    WinTitle="List of game flags"

		DefaultHeight=400
		DefaultWidth=534

		MaxPageHeight=400
		MaxPageWidth=534
		MinPageHeight=400
		MinPageWidth=534

	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Texture'DeusExControls.Controls.DeusExButtonWatched' //Background.DX_WinBack_BW'//Material'DeusExControls.Background.DX_WinBack_BW'
		ImageRenderStyle=MSTY_Normal
		ImageStyle=ISTY_Scaled //PartialScaled
		ImageColor=(R=255,G=255,B=255,A=255)
		DropShadow=None
		WinWidth=528
		WinHeight=400 //229
		WinLeft=8
		WinTop=20
		RenderWeight=0.000003
		bBoundToParent=True
		bScaleToParent=True
	End Object
	i_FrameBG=FloatingFrameBackground

	Begin Object Class=GUIHeader Name=TitleBar
		WinWidth=0.58
		WinHeight=128
		WinLeft=-2
		WinTop=-3
		RenderWeight=0.1
		FontScale=FNS_Small
		bUseTextHeight=false
		bAcceptsInput=True
		bNeverFocus=true //False
		bBoundToParent=true
		bScaleToParent=true
		OnMousePressed=FloatingMousePressed
		OnMouseRelease=FloatingMouseRelease
    OnRendered=PaintOnHeader
		ScalingType=SCALE_ALL
    StyleName="STY_DXR_DXWinHeader";
    Justification=TXTA_Left
	End Object
	t_WindowTitle=TitleBar
}