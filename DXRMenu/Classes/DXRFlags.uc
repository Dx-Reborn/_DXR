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
  flagList.WinHeight = 290;
  flagList.WinWidth = 520;
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
  eFlagName.WinWidth = 212;
  eFlagName.WinLeft = 327;
  eFlagName.WinTop = 370;
	eFlagName.OnChange = editBoxChanged;
	AppendComponent(eFlagName, true);
	eFlagName.AllowedCharSet = "0123456789_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

	/* -- Кнопки ------------------------------------------------------- */
	bSetTrue = new(none) class'GUIButton';
  bSetTrue.StyleName="STY_DXR_MediumButton";
  bSetTrue.OnClick = InternalOnClick;
  bSetTrue.FontScale = FNS_Small;
  bSetTrue.WinHeight = 21;
  bSetTrue.WinWidth = 150;
  bSetTrue.WinLeft = 12;
  bSetTrue.WinTop = 395;
  bSetTrue.caption="Set True";
  bSetTrue.Hint = "Set value of selected flag to TRUE";
	AppendComponent(bSetTrue, true);

	bSetFalse = new(none) class'GUIButton';
  bSetFalse.StyleName="STY_DXR_MediumButton";
  bSetFalse.OnClick = InternalOnClick;
  bSetFalse.FontScale = FNS_Small;
  bSetFalse.WinHeight = 21;
  bSetFalse.WinWidth = 150;
  bSetFalse.WinLeft = 12;
  bSetFalse.WinTop = 370;
  bSetFalse.caption="Set False";
  bSetFalse.Hint = "Set value of selected flag to FALSE";
	AppendComponent(bSetFalse, true);

	bExtra = new(none) class'GUIButton';
  bExtra.StyleName="STY_DXR_MediumButton";
  bExtra.OnClick = InternalOnClick;
  bExtra.FontScale = FNS_Small;
  bExtra.WinHeight = 21;
  bExtra.WinWidth = 150;
  bExtra.WinLeft = 170;
  bExtra.WinTop = 370;
  bExtra.caption="Add flag";
  bExtra.Hint = "Type flagName and click this button to add it. Value of the flag is TRUE by default";
	AppendComponent(bExtra, true);
	/* ---------------------------------------------------------------------- */
	bClose = new(none) class'GUIButton';
  bClose.StyleName="STY_DXR_MediumButton";
  bClose.OnClick = InternalOnClick;
  bClose.FontScale = FNS_Small;
  bClose.WinHeight = 21;
  bClose.WinWidth = 150;
  bClose.WinLeft = 396;
  bClose.WinTop = 421;
  bClose.caption="Close";
	AppendComponent(bClose, true);

	bSave = new(none) class'GUIButton';
  bSave.StyleName="STY_DXR_MediumButton";
  bSave.OnClick = InternalOnClick;
  bSave.FontScale = FNS_Small;
  bSave.WinHeight = 21;
  bSave.WinWidth = 150;
  bSave.WinLeft = 166;
  bSave.WinTop = 421;
  bSave.caption="SaveToPlayer";
	AppendComponent(bSave, true);

	bLoad = new(none) class'GUIButton';
  bLoad.StyleName="STY_DXR_MediumButton";
  bLoad.OnClick = InternalOnClick;
  bLoad.FontScale = FNS_Small;
  bLoad.WinHeight = 21;
  bLoad.WinWidth = 150;
  bLoad.WinLeft = 6;
  bLoad.WinTop = 421;
  bLoad.caption="Reload List";
  bLoad.Hint = "Update list of flags, in case if MissionScripts or other events changed some of them";
	AppendComponent(bLoad, true);
	/* ---------------------------------------------------------------------- */
	bDelete = new(none) class'GUIButton';
  bDelete.StyleName="STY_DXR_MediumButton";
  bDelete.OnClick = InternalOnClick;
  bDelete.FontScale = FNS_Small;
  bDelete.WinHeight = 21;
  bDelete.WinWidth = 150;
  bDelete.WinLeft = 170;
  bDelete.WinTop = 395;
  bDelete.caption="Delete";
	AppendComponent(bDelete, true);

	fillList();
  editBoxChanged(eFlagName);
}

function fillList()
{
  local int x;
  local gameflags.flag Flag;
  local string valueStr;

  flagList.List.Clear();
  flagsArray.length = 0;

  FlagsArray = class'GameFlags'.static.GetAllFlagIds(true);

  if (FlagsArray.Length > 0)
  {
   for(x=0; x<FlagsArray.Length; x++)
   {
     class'GameFlags'.static.GetFlag(FlagsArray[x], Flag);

        if (Flag.value == 0)
            valueStr = "яFALSE";
   else if (Flag.value == 1)
            valueStr = "я@TRUE";

     flagList.List.Add(FlagsArray[x]$"| = "$valueStr$", expires at "$flag.ExpireLevel);
   }
  }
}


function bool InternalOnClick(GUIComponent Sender)
{
  local string str, flagStr, uStr, valueStr;
  local gameFlags.Flag Flag;

  if (Sender == bSetTrue) // Выставить значение флага в True
  {
     str = flagList.list.Get(true);
     Divide(str, "|", flagStr, uStr);

     class'GameFlags'.static.GetFlag(flagStr, Flag);
     Flag.Value = 1;

     class'GameFlags'.static.SetFlag(Flag);

        if (Flag.value == 0)
            valueStr = "яFALSE";
   else if (Flag.value == 1)
            valueStr = "я@TRUE";

     flaglist.list.Replace(flaglist.list.Index, flagStr$"| = "$valueStr$", expires at "$flag.ExpireLevel);
     //fillList();
  }
  if (Sender == bSetFalse) //...false
  {
     str = flagList.list.Get(true);
     Divide(str, "|", flagStr, uStr);

     class'GameFlags'.static.GetFlag(flagStr, Flag);

     Flag.Value = 0;

     class'GameFlags'.static.SetFlag(Flag);

        if (Flag.value == 0)
            valueStr = "яFALSE";
   else if (Flag.value == 1)
            valueStr = "я@TRUE";

     flaglist.list.Replace(flaglist.list.Index, flagStr$"| = "$valueStr$", expires at "$flag.ExpireLevel);
  }
  // Add flag
  if (Sender == bExtra)
  {
      AddFlag();
  }
  if (Sender == bLoad)
  {
      FillList();
  }
  if (Sender == bClose)
  {
     Controller.CloseMenu();
  }
  return false;
}

function AddFlag()
{
  local GameFlags.Flag Flag;

  Flag.Id = class'DxUtil'.static.TrimSpaces(eFlagName.GetText());
  Flag.Value = 1;
//	Flag.ExpireLevel = expiration;

  class'GameFlags'.static.SetFlag(Flag);

  fillList();
}

function editBoxChanged(GUIComponent Sender)
{
  if (class'DxUtil'.static.TrimSpaces(eFlagName.GetText()) != "")
   bExtra.EnableMe();
   else
      bExtra.DisableMe();
}

defaultproperties
{
    WinTitle="List of game flags"

		DefaultHeight=400
		DefaultWidth=548
		MaxPageHeight=400
		MaxPageWidth=548
		MinPageHeight=400
		MinPageWidth=548

		leftEdgeCorrectorX=4
		leftEdgeCorrectorY=0
		leftEdgeHeight=441

		RightEdgeCorrectorX=545
		RightEdgeCorrectorY=20
		RightEdgeHeight=413

		TopEdgeCorrectorX=240
		TopEdgeCorrectorY=16
    TopEdgeLength=303

    TopRightCornerX=542
    TopRightCornerY=16


	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Texture'ConWindowBackground'
		ImageRenderStyle=MSTY_Normal
		ImageStyle=ISTY_Scaled //PartialScaled
		ImageColor=(R=255,G=255,B=255,A=255)
		DropShadow=None
		WinWidth=540
		WinHeight=400 //229
		WinLeft=8
		WinTop=20
		RenderWeight=0.000003
		bBoundToParent=True
		bScaleToParent=True
								OnRendered=PaintOnBG
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