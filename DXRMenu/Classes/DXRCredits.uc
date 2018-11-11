/*

*/
class DXRCredits extends DxWindowTemplate;

var GUILabel lStatus;
var GUIButton btnClose, btnSupport;

var localized string strText, strSupport, strClose;
const supportLink="https://discord.gg/vpth4Dp"; // Бесконечное приглашение.


function CreateMyControls()
{
  lStatus = new(none) class'GUILabel';
  lStatus.bBoundToParent = true;
  lStatus.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  lStatus.caption = strText;
  lStatus.TextFont="UT2SmallFont";
  lStatus.bMultiLine = true;
  lStatus.TextAlign = TXTA_Center;
  lStatus.VertAlign = TXTA_Center;
  lStatus.FontScale = FNS_Small;
 	lStatus.WinHeight = 140;
  lStatus.WinWidth = 393;
  lStatus.WinLeft = 14;
  lStatus.WinTop = 28;
  AppendComponent(lStatus, true);

  btnClose = new(none) class'GUIButton';
  btnClose.WinHeight = 21;
  btnClose.WinWidth = 100;
  btnClose.WinLeft = 321;
  btnClose.WinTop = 237;
  btnClose.StyleName = "STY_DXR_MediumButton";
  btnClose.Caption = strClose;
  btnClose.OnClick = InternalOnClick;
  AppendComponent(btnClose, true);

  btnSupport = new(none) class'GUIButton';
  btnSupport.WinHeight = 21;
  btnSupport.WinWidth = 100;
  btnSupport.WinLeft = 9;
  btnSupport.WinTop = 237;
  btnSupport.StyleName = "STY_DXR_MediumButton";
  btnSupport.Caption = strSupport;
  btnSupport.OnClick = InternalOnClick;
  AppendComponent(btnSupport, true);
}

function bool InternalOnClick(GUIComponent Sender)
{
  if (Sender==btnClose)
      controller.CloseMenu(true);
  else if (Sender==btnSupport)
      Console(Controller.Master.Console).DelayedConsoleCommand("open"@supportLink);

  return true;
}


defaultproperties
{
    WinTitle="Need help?"

    strSupport="Get Support"
    strClose="OK"
    strText="Preview Alpha version. If you have problems running this mod and need help, click appropriate button below. Please keep in mind that this is still Alpha version, and it really does have bugs ))"

		DefaultHeight=256
		DefaultWidth=418
		MaxPageHeight=256
		MaxPageWidth=418
		MinPageHeight=256
		MinPageWidth=418

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

