/* Окно с сообщением и единственной кнопкой */

class DXROkMessage extends DxWindowTemplate;

var localized string strOkay;
var localized string strMessage;

var GuiButton bOk;
var GuiLabel lMessage;


function CreateMyControls()
{
  bOk = new(none) class'GUIButton';
  bOk.OnClick=InternalOnClick;
  bOk.RenderWeight = 1.0;
  bOk.fontScale=FNS_Small;
  bOk.StyleName="STY_DXR_MediumButton";
  bOk.Caption = strOkay;
  bOk.WinHeight = 21;
  bOk.WinWidth = 100;
  bOk.WinLeft = 300;
  bOk.WinTop = 148;
	AppendComponent(bOk, true);
	// Message
  lMessage = new(none) class'GUILabel';
  lMessage.RenderWeight = 1.0;
  lMessage.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  lMessage.TextAlign = TXTA_Center;
  lMessage.VertAlign = TXTA_Center;
  lMessage.Caption = strMessage;
  lMessage.bMultiLine = true;
  lMessage.WinHeight = 100;
  lMessage.WinWidth = 355;
  lMessage.WinLeft = 28;
  lMessage.WinTop = 32;
	AppendComponent(lMessage, true);
}


function bool InternalOnClick(GUIComponent Sender)
{
  if (Sender==bOk)
  Controller.CloseMenu();
  return true;
}


defaultproperties
{
    WinTitle="Message"
    strMessage="placeholder"
    strOkay="OK"

		DefaultHeight=200
		DefaultWidth=405

		MaxPageHeight=200
		MaxPageWidth=405
		MinPageHeight=200
		MinPageWidth=405

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
	End Object
	i_FrameBG=FloatingFrameBackground
}