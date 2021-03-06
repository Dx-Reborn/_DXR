/*
  Screen resolution, windowed && Fullscreen mode.
  PC.ConsoleCommand("set ini:Engine.Engine.ViewportManager NoDynamicLights"@!bDynLight);

  WindowedViewportX=1280
  WindowedViewportY=720
  FullscreenViewportX=1920
  FullscreenViewportY=1080
  StartupFullscreen=false

  03/05/2019: Added extra page.
  ToDo: delete "no dynamic lights" option, since it useless anyway and replace it with sth else.
*/

class DXRScreenResolution extends DXRConfigurationDialog;

var MenuChoice_Resolution mMenuChoice_Resolution;
var MenuChoice_ResolutionW mMenuChoice_ResolutionW;
var MenuChoice_StartupFullScreen mMenuChoice_StartupFullScreen;
var DXRChoiceInfo cResolution, cResolutionW, cFullScreen;
var localized string strGraphicsA, strGraphicsB;//, strGraphicsE;
var localized string strGamma, strGraphics, strPhysics;
var localized string hGamma, hGraphics, hPhysics, hGraphicsA, hGraphicsB;//, hGraphicsE;
var GUIButton btnDefault, btnOK, btnCancel;
var GuiButton btnGamma, btnGraphics, btnGraphicsA, btnGraphicsB,/* btnGraphicsE,*/ btnPhysics;

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
  btnGamma.WinLeft = 15;
  btnGamma.WinTop = 177;
    AppendComponent(btnGamma, true);

  btnPhysics = new class'GUIButton';
  btnPhysics.OnClick=InternalOnClick;
  btnPhysics.fontScale = FNS_Small;
  btnPhysics.StyleName="STY_DXR_MediumButton";
  btnPhysics.Caption = strPhysics;
  btnPhysics.Hint = hPhysics;
  btnPhysics.WinHeight = 21;
  btnPhysics.WinWidth = 166;
  btnPhysics.WinLeft = 184;
  btnPhysics.WinTop = 177;
    AppendComponent(btnPhysics, true);


    /*------------------------------------------------------------*/
    // Performance (page X)
  btnGraphics = new class'GUIButton';
  btnGraphics.OnClick=InternalOnClick;
  btnGraphics.fontScale = FNS_Small;
  btnGraphics.StyleName="STY_DXR_MediumButton";
  btnGraphics.Caption = strGraphics;
  btnGraphics.Hint = hGraphics;
  btnGraphics.WinHeight = 21;
  btnGraphics.WinWidth = 166;
  btnGraphics.WinLeft = 374;
  btnGraphics.WinTop = 46;
    AppendComponent(btnGraphics, true);

    btnGraphicsA = new class'GUIButton';
  btnGraphicsA.OnClick=InternalOnClick;
  btnGraphicsA.fontScale = FNS_Small;
  btnGraphicsA.StyleName="STY_DXR_MediumButton";
  btnGraphicsA.Caption = strGraphicsA;
  btnGraphicsA.Hint = hGraphicsA;
  btnGraphicsA.WinHeight = 21;
  btnGraphicsA.WinWidth = 166;
  btnGraphicsA.WinLeft = 374;
  btnGraphicsA.WinTop = 82;
    AppendComponent(btnGraphicsA, true);

    btnGraphicsB = new class'GUIButton';
  btnGraphicsB.OnClick=InternalOnClick;
  btnGraphicsB.fontScale = FNS_Small;
  btnGraphicsB.StyleName="STY_DXR_MediumButton";
  btnGraphicsB.Caption = strGraphicsB;
  btnGraphicsB.Hint = hGraphicsB;
  btnGraphicsB.WinHeight = 21;
  btnGraphicsB.WinWidth = 166;
  btnGraphicsB.WinLeft = 374;
  btnGraphicsB.WinTop = 118;
    AppendComponent(btnGraphicsB, true);

/*    btnGraphicsE = new class'GUIButton';
  btnGraphicsE.OnClick=InternalOnClick;
  btnGraphicsE.fontScale = FNS_Small;
  btnGraphicsE.StyleName="STY_DXR_MediumButton";
  btnGraphicsE.Caption = strGraphicsE;
  btnGraphicsE.Hint = hGraphicsE;
  btnGraphicsE.WinHeight = 21;
  btnGraphicsE.WinWidth = 166;
  btnGraphicsE.WinLeft = 374;
  btnGraphicsE.WinTop = 154;
    AppendComponent(btnGraphicsE, true);*/
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
   else if (Sender==btnGraphicsA)
   {
     Controller.OpenMenu("DXRMenu.DXRGraphicsA");
   }
   else if (Sender==btnGraphicsB)
   {
     Controller.OpenMenu("DXRMenu.DXRGraphicsB");
   }
/*   else if (Sender==btnGraphicsE)
   {
     Controller.OpenMenu("DXRMenu.DXRGraphicsE");
   }*/

  return true;
}



defaultproperties
{
  WinTitle="Screen Resolution, Graphics, Physics..."

  strGamma="Gamma, Brightness..."
  strGraphics="Performance [page 1]"
  strGraphicsA="Performance [page 2]"
  strGraphicsB="Performance [page 3]"
//  strGraphicsE="Setup Shadows..."
  strPhysics="Setup Physics"

  hGamma="Set Gamma, Brightness and Contrast. Keep in mind that these settings only working in FullScreen mode."
  hGraphics="Set texture details, quality, and so on. Many of these settings will affect performance."
  hGraphicsA="Set texture details, quality, and so on. Many of these settings will affect performance."
  hGraphicsB="Set texture details, quality, and so on. Many of these settings will affect performance."
//  hGraphicsE="Setup shadows for pawns, details, and so on. If you disabled  projectors, these settings will be ignored."
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