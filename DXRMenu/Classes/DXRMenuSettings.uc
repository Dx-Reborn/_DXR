/* Выбор категории настроек */

class DXRMenuSettings extends DxWindowTemplate;
// Клавиатура/мышь, управление, игровые настройки, экран/физика, цветовые схемы, звук, назад.
var GUIButton btnKeysMouse, btnControl, btnGameOptions, btnPerformance, btnColors, btnSound, btnBack;
var localized string strKeysMouse, strControl, strGameOptions, strPerformance, strColors, strSound, strBack;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);
//  CreateMyControls();
}


function CreateMyControls()
{
  btnKeysMouse = new(none) class'GUIButton';
  btnKeysMouse.OnClick=InternalOnClick;
  btnKeysMouse.RenderWeight = 1.0;
  btnKeysMouse.StyleName="STY_DXR_DeusExRectButton";
  btnKeysMouse.Caption = strKeysMouse;
  btnKeysMouse.WinHeight = 32;
  btnKeysMouse.WinWidth = 281;
  btnKeysMouse.WinLeft = 16;
  btnKeysMouse.WinTop = 33;
	AppendComponent(btnKeysMouse, true);

  btnControl = new(none) class'GUIButton';
  btnControl.OnClick=InternalOnClick;
  btnControl.StyleName="STY_DXR_DeusExRectButton";
  btnControl.Caption = strControl;
  btnControl.WinHeight = 32;
  btnControl.WinWidth = 281;
  btnControl.WinLeft = 16;
  btnControl.WinTop = 70;
	AppendComponent(btnControl, true);

  btnGameOptions = new(none) class'GUIButton';
  btnGameOptions.OnClick=InternalOnClick;
  btnGameOptions.StyleName="STY_DXR_DeusExRectButton";
  btnGameOptions.Caption = strGameOptions;
  btnGameOptions.WinHeight = 32;
  btnGameOptions.WinWidth = 281;
  btnGameOptions.WinLeft = 16;
  btnGameOptions.WinTop = 105;
	AppendComponent(btnGameOptions, true);

  btnPerformance = new(none) class'GUIButton';
  btnPerformance.OnClick=InternalOnClick;
  btnPerformance.StyleName="STY_DXR_DeusExRectButton";
  btnPerformance.Caption = strPerformance;
  btnPerformance.WinHeight = 32;
  btnPerformance.WinWidth = 281;
  btnPerformance.WinLeft = 16;
  btnPerformance.WinTop = 142;
	AppendComponent(btnPerformance, true);

  btnColors = new(none) class'GUIButton';
  btnColors.OnClick=InternalOnClick;
  btnColors.StyleName="STY_DXR_DeusExRectButton";
  btnColors.Caption = strColors;
  btnColors.WinHeight = 32;
  btnColors.WinWidth = 281;
  btnColors.WinLeft = 16;
  btnColors.WinTop = 177;
	AppendComponent(btnColors, true);

  btnSound = new(none) class'GUIButton';
  btnSound.OnClick=InternalOnClick;
  btnSound.StyleName="STY_DXR_DeusExRectButton";
  btnSound.Caption = strSound;
  btnSound.WinHeight = 32;
  btnSound.WinWidth = 281;
  btnSound.WinLeft = 16;
  btnSound.WinTop = 214;
	AppendComponent(btnSound, true);

  btnBack = new(none) class'GUIButton';
  btnBack.OnClick=InternalOnClick;
  btnBack.StyleName="STY_DXR_DeusExRectButton";
  btnBack.Caption = strBack;
  btnBack.WinHeight = 32;
  btnBack.WinWidth = 281;
  btnBack.WinLeft = 16;
  btnBack.WinTop = 286;
	AppendComponent(btnBack, true);
}

function bool InternalOnClick(GUIComponent Sender)
{
	if(Sender==btnBack)
	{
		Controller.CloseMenu(); // Back to previous menu
	}
	else if(Sender==btnSound) 
	{
		Controller.OpenMenu("DXRMenu.DXRMenuSound");
	}
	else if(Sender==btnControl)
	{
		Controller.OpenMenu("DXRMenu.DXRMenuControl");
	}
	else if(Sender==btnPerformance)
	{
		Controller.OpenMenu("DXRMenu.DXRScreenResolution");
	}
	else if (Sender==btnGameOptions)
	{
	  Controller.OpenMenu("DXRMenu.DXRGameOptions");
	}
	return true;
}

defaultproperties
{
    WinTitle="Settings"
    strKeysMouse="Keyboard/Mouse"
    strControl="Control"
    strGameOptions="Game options"
    strPerformance="Display/Physics"
    strColors="Colors"
    strSound="Sound"
    strBack="Previous menu"

		DefaultHeight=320
		DefaultWidth=300

		MaxPageHeight=320
		MaxPageWidth=300
		MinPageHeight=320
		MinPageWidth=300

	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Texture'DXR_MenuOptionsBackground'
		ImageRenderStyle=MSTY_Translucent
		ImageStyle=ISTY_Tiled
		ImageColor=(R=255,G=255,B=255,A=255)
		DropShadow=None
		WinWidth=297
		WinHeight=312
		WinLeft=8
		WinTop=20
		RenderWeight=0.000003
		bBoundToParent=True
		bScaleToParent=True
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


		winleft=0.4
		wintop=0.3

}
