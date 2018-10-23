/**/
class ATMDisabled extends ComputerUIWindow;

var GUILabel lStatus, lMessage;
var GUIButton btnClose;

var localized String ButtonLabelClose;
var localized String LoginInfoText;
var localized String StatusText;



function CreateMyControls()
{
  lMessage = new(none) class'GUILabel';
  lMessage.bBoundToParent = true;
  lMessage.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  lMessage.caption = LoginInfoText;
  lMessage.TextFont="UT2HeaderFont";
  lMessage.bMultiLine = true;
  lMessage.TextAlign = TXTA_Center;
  lMessage.VertAlign = TXTA_Center;
  lMessage.FontScale = FNS_Small;
 	lMessage.WinHeight = 142;
  lMessage.WinWidth = 396;
  lMessage.WinLeft = 15;
  lMessage.WinTop = 28;
  AppendComponent(lMessage, true);

  lStatus = new(none) class'GUILabel';
  lStatus.bBoundToParent = true;
  lStatus.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  lStatus.caption = StatusText;
  lStatus.TextFont="UT2HeaderFont";
  lStatus.bMultiLine = true;
  lStatus.TextAlign = TXTA_Center;
  lStatus.VertAlign = TXTA_Center;
  lStatus.FontScale = FNS_Small;
 	lStatus.WinHeight = 24;
  lStatus.WinWidth = 400;
  lStatus.WinLeft = 14;
  lStatus.WinTop = 178;
  AppendComponent(lStatus, true);

  btnClose = new(none) class'GUIButton';
  btnClose.WinHeight = 21;
  btnClose.WinWidth = 100;
  btnClose.WinLeft = 321;
  btnClose.WinTop = 237;
  btnClose.StyleName = "STY_DXR_MediumButton";
  btnClose.Caption = ButtonLabelClose;
  btnClose.OnClick = InternalOnClick;
  AppendComponent(btnClose, true);
}

function bool InternalOnClick(GUIComponent Sender)
{
  if (Sender==btnClose)
  controller.CloseAll(false,true);

  return false;
}

/*event Opened(GUIComponent Sender)                   // Called when the Menu Owner is opened
{

}*/

event Closed(GUIComponent Sender, bool bCancelled)  // Called when the Menu Owner is closed
{
  super.Closed(Sender, bCancelled);
}

event free()
{
  super.free();
}



defaultproperties
{
		DefaultHeight=256
		DefaultWidth=418
		MaxPageHeight=256
		MaxPageWidth=418
		MinPageHeight=256
		MinPageWidth=418

    ButtonLabelClose="Close"
    LoginInfoText="Sorry, this terminal is out of service (ERR 06MJ12)||We apologize for the inconvenience but would gladly service you at any of the other 231,000 PageNet Banking Terminals around the globe."
    StatusText="PNGBS//GLOBAL//PUB:3902.9571[dsbld]"
    WinTitle="PageNet Global Banking System"

	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Texture'DXR_BankDisabled'
		ImageRenderStyle=MSTY_Normal
		ImageStyle=ISTY_Tiled
		ImageColor=(R=255,G=255,B=255,A=255)
		DropShadow=None
		WinWidth=418
		WinHeight=249
		WinLeft=8
		WinTop=20
		RenderWeight=0.000003
		bBoundToParent=True
		bScaleToParent=True
		OnRendered=PaintOnBG
	End Object
	i_FrameBG=FloatingFrameBackground
}