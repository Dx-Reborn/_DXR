/* Запрос выхода */

class DXRQuitMessage extends DxWindowTemplate;//floatingwindow;

var() localized string stOk;
var() localized string stCancel;
var() localized string stMessage;
var GuiButton bOk, bCancel;
var GuiLabel lMessage;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);
  CreateControls();
}

function CreateControls()
{ // Ok
  bOk = new(none) class'GUIButton';
  bOk.OnClick=InternalOnClick;
  bOk.RenderWeight = 1.0;
  bOk.fontScale=FNS_Small;
  bOk.StyleName="STY_DXR_MediumButton";
  bOk.Caption = stOk;
  bOk.WinHeight = 21;
  bOk.WinWidth = 100;
  bOk.WinLeft = 203;
  bOk.WinTop = 148;
	AppendComponent(bOk, true);
	// Cancel
  bCancel = new(none) class'GUIButton';
  bCancel.OnClick=InternalOnClick;
  bCancel.RenderWeight = 1.0;
  bCancel.fontScale=FNS_Small;
  bCancel.StyleName="STY_DXR_MediumButton";
  bCancel.Caption = stCancel;
  bCancel.WinHeight = 21;
  bCancel.WinWidth = 100;
  bCancel.WinLeft = 305;
  bCancel.WinTop = 148;
	AppendComponent(bCancel, true);
	// Message
  lMessage = new(none) class'GUILabel';
  lMessage.RenderWeight = 1.0;
//  lMessage.StyleName="STY_DXR_MediumButton";
  lMessage.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  lMessage.TextAlign = TXTA_Center;
  lMessage.VertAlign = TXTA_Center;
  lMessage.Caption = stMessage;
  lMessage.bMultiLine = true;
  lMessage.WinHeight = 100;
  lMessage.WinWidth = 355;
  lMessage.WinLeft = 28;
  lMessage.WinTop = 32;
	AppendComponent(lMessage, true);
}

function bool InternalOnClick(GUIComponent Sender)
{
	if(Sender==bOk) // выход
	{
		PlayerOwner().ConsoleCommand("Exit");
	}

  if(Sender==bCancel)
	{
		Controller.CloseMenu(true);
	}
	return false;
}

/*event Opened(GUIComponent Sender)                   // Called when the Menu Owner is opened
{
  if (ParentPage != none)
  ParentPage.bVisible=false;
}

event Closed(GUIComponent Sender, bool bCancelled)  // Called when the Menu Owner is closed
{
  if (ParentPage != none)
  ParentPage.bVisible=true;
}*/




function AddSystemMenu();
function bool AlignFrame(Canvas C)
{
  if (bVisible)
  winleft = (controller.resX/2) - (MaxPageWidth/2);
  else
  winleft = -2000;

	return bInit;
}

/*function PaintOnHeader(Canvas C)
{
  local texture icon;//, bubble;

  icon = texture'DeusExSmallIcon';
  C.SetPos(t_WindowTitle.ActualLeft() + 8, t_WindowTitle.ActualTop() + 3);
  C.SetDrawColor(255,255,255);
  C.DrawIcon(icon, 1);
}*/

defaultproperties
{
    openSound=sound'DeusExSounds.UserInterface.Menu_Activate'

    stMessage="Are you sure you want to exit Deus Ex: Reborn ?"
    WinTitle="Please confirm"
    stOk="Ok"
    stCancel="Cancel"

    bResizeWidthAllowed=false
    bResizeHeightAllowed=false

		DefaultHeight=200
		DefaultWidth=405

		MaxPageHeight=200
		MaxPageWidth=405
		MinPageHeight=200
		MinPageWidth=405

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
		Image=Texture'DXR_MessageBox'//Material'DeusExControls.Background.DX_WinBack_BW'
		ImageRenderStyle=MSTY_Translucent //Normal
		ImageStyle=ISTY_Tiled //PartialScaled
		ImageColor=(R=255,G=255,B=255,A=255)
		DropShadow=None
		WinWidth=400
		WinHeight=128 //229
		WinLeft=8
		WinTop=20
		RenderWeight=0.000003
		bBoundToParent=True
		bScaleToParent=True
		OnRendered=PaintOnBG
	End Object
	i_FrameBG=FloatingFrameBackground
  /* Заголовок */
	Begin Object Class=GUIHeader Name=TitleBar
		WinWidth=0.98
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