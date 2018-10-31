/*
  Screen resolution, windowed && Fullscreen mode.
  PC.ConsoleCommand("set ini:Engine.Engine.ViewportManager NoDynamicLights"@!bDynLight);

  WindowedViewportX=1280
  WindowedViewportY=720
  FullscreenViewportX=1920
  FullscreenViewportY=1080
  StartupFullscreen=false
*/

class DXRScreenResolution extends DxWindowTemplate;

var MenuChoice_Resolution mMenuChoice_Resolution;
var MenuChoice_ResolutionW mMenuChoice_ResolutionW;
var MenuChoice_StartupFullScreen mMenuChoice_StartupFullScreen;
var DXRChoiceInfo cResolution, cResolutionW, cFullScreen;
var localized string strOK, strCancel, strDefault;
var localized string strGamma, strGraphics, strPhysics;
var localized string hGamma, hGraphics, hPhysics;
var GUIButton btnDefault, btnOK, btnCancel;

var GuiButton btnGamma, btnGraphics, btnPhysics; //

function CreateMyControls()
{
  SetSize(226, 548);

  // Information fields first, this is important, otherwise scary things will happen...
  cResolution = new class'DXRChoiceInfo';
  cResolution.WinLeft = 285;
  cResolution.WinTop = 46;
  cResolution.WinWidth = 78;
  AppendComponent(cResolution, true);

  cResolutionW = new class'DXRChoiceInfo';
  cResolutionW.WinLeft = 285;
  cResolutionW.WinTop = 82;
  cResolutionW.WinWidth = 78;
  AppendComponent(cResolutionW, true);

  cFullScreen = new class'DXRChoiceInfo';
  cFullScreen.WinLeft = 285;
  cFullScreen.WinTop = 118;
  cFullScreen.WinWidth = 78;
  AppendComponent(cFullScreen, true);

  mMenuChoice_Resolution = new class'MenuChoice_Resolution';
  mMenuChoice_Resolution.WinLeft = 15;
  mMenuChoice_Resolution.WinTop = 46;
  mMenuChoice_Resolution.WinWidth = 244;
  AppendComponent(mMenuChoice_Resolution, true);
  mMenuChoice_Resolution.info = cResolution;
  mMenuChoice_Resolution.LoadSetting();
  mMenuChoice_Resolution.UpdateInfoButton();

  mMenuChoice_ResolutionW = new class'MenuChoice_ResolutionW';
  mMenuChoice_ResolutionW.WinLeft = 15;
  mMenuChoice_ResolutionW.WinTop = 82;
  mMenuChoice_ResolutionW.WinWidth = 244;
  AppendComponent(mMenuChoice_ResolutionW, true);
  mMenuChoice_ResolutionW.info = cResolutionW;
  mMenuChoice_ResolutionW.LoadSetting();
  mMenuChoice_ResolutionW.UpdateInfoButton();

  mMenuChoice_StartupFullScreen = new class'MenuChoice_StartupFullScreen';
  mMenuChoice_StartupFullScreen.WinLeft = 15;
  mMenuChoice_StartupFullScreen.WinTop = 118;
  mMenuChoice_StartupFullScreen.WinWidth = 244;
  AppendComponent(mMenuChoice_StartupFullScreen, true);
  mMenuChoice_StartupFullScreen.info = cFullScreen;
  mMenuChoice_StartupFullScreen.LoadSetting();
  mMenuChoice_StartupFullScreen.UpdateInfoButton();


  btnDefault = new class'GUIButton';
  btnDefault.OnClick=InternalOnClick;
  btnDefault.fontScale = FNS_Small;
  btnDefault.StyleName="STY_DXR_MediumButton";
  btnDefault.Caption = strDefault;
  btnDefault.WinHeight = 21;
  btnDefault.WinWidth = 180;
  btnDefault.WinLeft = 7;
  btnDefault.WinTop = 232;
	AppendComponent(btnDefault, true);

  btnOK = new class'GUIButton';
  btnOK.OnClick=InternalOnClick;
  btnOK.fontScale = FNS_Small;
  btnOK.StyleName="STY_DXR_MediumButton";
  btnOK.Caption = strOK;
  btnOK.WinHeight = 21;
  btnOK.WinWidth = 100;
  btnOK.WinLeft = 445;
  btnOK.WinTop = 232;
	AppendComponent(btnOK, true);

  btnCancel = new class'GUIButton';
  btnCancel.OnClick=InternalOnClick;
  btnCancel.fontScale = FNS_Small;
  btnCancel.StyleName="STY_DXR_MediumButton";
  btnCancel.Caption = strCancel;
  btnCancel.WinHeight = 21;
  btnCancel.WinWidth = 100;
  btnCancel.WinLeft = 344;
  btnCancel.WinTop = 232;
	AppendComponent(btnCancel, true);
  /*-------------------------------------------------------------*/

  btnGamma = new class'GUIButton';
  btnGamma.OnClick=InternalOnClick;
  btnGamma.fontScale = FNS_Small;
  btnGamma.StyleName="STY_DXR_MediumButton";
  btnGamma.Caption = strGamma;
  btnGamma.Hint = hGamma;
  btnGamma.WinHeight = 21;
  btnGamma.WinWidth = 166;
  btnGamma.WinLeft = 20;
  btnGamma.WinTop = 177;
	AppendComponent(btnGamma, true);

  btnGraphics = new class'GUIButton';
  btnGraphics.OnClick=InternalOnClick;
  btnGraphics.fontScale = FNS_Small;
  btnGraphics.StyleName="STY_DXR_MediumButton";
  btnGraphics.Caption = strGraphics;
  btnGraphics.Hint = hGraphics;
  btnGraphics.WinHeight = 21;
  btnGraphics.WinWidth = 166;
  btnGraphics.WinLeft = 191;
  btnGraphics.WinTop = 177;
	AppendComponent(btnGraphics, true);

  btnPhysics = new class'GUIButton';
  btnPhysics.OnClick=InternalOnClick;
  btnPhysics.fontScale = FNS_Small;
  btnPhysics.StyleName="STY_DXR_MediumButton";
  btnPhysics.Caption = strPhysics;
  btnPhysics.Hint = hPhysics;
  btnPhysics.WinHeight = 21;
  btnPhysics.WinWidth = 166;
  btnPhysics.WinLeft = 361;
  btnPhysics.WinTop = 177;
	AppendComponent(btnPhysics, true);
}

function resetToDefaults()
{
  local int i;

  for (i=0;i<Controls.Length;i++)
  {
     if (controls[i].IsA('DXREnumButton'))
     {
        DXREnumButton(controls[i]).ResetToDefault();
        DXREnumButton(controls[i]).UpdateInfoButton();
     }
  }
}

function SaveSettings()
{
  local int i;

  for (i=0;i<Controls.Length;i++)
  {
     if (controls[i].IsA('DXREnumButton'))
        DXREnumButton(controls[i]).SaveSetting();
  }
}

function CancelSettings()
{
  local int i;

  for (i=0;i<Controls.Length;i++)
  {
     if (controls[i].IsA('DXREnumButton'))
        DXREnumButton(controls[i]).CancelSetting();
  }
}

function bool InternalOnClick(GUIComponent Sender)
{
   if (Sender==btnOK)
   {
     SaveSettings();
     Controller.CloseMenu(false);
   }
   else if (Sender==btnCancel)
   {
     CancelSettings();
     Controller.CloseMenu(true);
   }
   else if (Sender==btnDefault)
   {
     resetToDefaults();
   }
   else if (Sender==btnGamma)
   {
     Controller.OpenMenu("DXRMenu.DXRBrightness");
   }
   else if (Sender==btnPhysics)
   {
     Controller.OpenMenu("DXRMenu.DXRPhysics");
   }
   else if (Sender==btnGraphics)
   {
     Controller.OpenMenu("DXRMenu.DXRGraphics");
   }

  return true;
}



defaultproperties
{
  WinTitle="Screen Resolution, Graphics, Physics..."

  strOK="OK"
  strCancel="Cancel"
  strDefault="Reset to defaults"

  strGamma="Gamma, Brightness..."
  strGraphics="Graphics/Performance"
  strPhysics="Setup Physics"

  hGamma="Set Gamma, Brightness and Contrast. Keep in mind that these settings only working in FullScreen mode."
  hGraphics="Set texture details, quality, and so on. Many of these settings will affect performance."
  hPhysics="Set KARMA physics engine parameters, also affects performance"

		leftEdgeCorrectorX=4
		leftEdgeCorrectorY=0
		leftEdgeHeight=251

		RightEdgeCorrectorX=545
		RightEdgeCorrectorY=20
		RightEdgeHeight=224

		TopEdgeCorrectorX=462
		TopEdgeCorrectorY=16
    TopEdgeLength=80

    TopRightCornerX=542
    TopRightCornerY=16


	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Texture'DXR_ScreenResolution'
		ImageRenderStyle=MSTY_Translucent
		ImageStyle=ISTY_Tiled
		ImageColor=(R=255,G=255,B=255,A=255)
		DropShadow=None
		WinWidth=538
		WinHeight=238
		WinLeft=8
		WinTop=20
		RenderWeight=0.000003
		bBoundToParent=True
		bScaleToParent=True
		OnRendered=PaintOnBG
	End Object
	i_FrameBG=FloatingFrameBackground
}