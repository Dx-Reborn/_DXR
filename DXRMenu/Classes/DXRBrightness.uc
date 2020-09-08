/* Gamma, Brightness, Contrast */

class DXRBrightness extends DXRConfigurationDialog;

var() int exampleTop;

var MenuChoice_AdjustGamma mGamma;
var MenuChoice_AdjustContrast mContrast;
var MenuChoice_AdjustBrightness mBrightness;

var DXRSlider sGamma, sContrast, sBrightness;
var DXRChoiceInfo cGamma, cContrast, cBrightness;

var GUIButton btnOK, btnCancel, btnDefault;

var GUILabel helpText;

var localized string strHelpText;

function CreateMyControls()
{
  helpText = new class'GUILabel';
  helpText.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  helpText.TextFont="UT2SmallFont";
  helpText.TextAlign = TXTA_Center;
  helpText.VertAlign = TXTA_Center;
  helpText.Caption = strHelpText;
  helpText.bMultiLine = true;
  helpText.WinHeight = 29;
  helpText.WinWidth = 536;
  helpText.WinLeft = 14;
  helpText.WinTop = 307;
    AppendComponent(helpText, true);

  cGamma = new class'DXRChoiceInfo';
  cGamma.WinLeft = 488;
  cGamma.WinTop = 46;
  cGamma.WinWidth = 60;
  AppendComponent(cGamma, true);

  cBrightness = new class'DXRChoiceInfo';
  cBrightness.WinLeft = 488;
  cBrightness.WinTop = 80;
  cBrightness.WinWidth = 60;
  AppendComponent(cBrightness, true);

  cContrast = new class'DXRChoiceInfo';
  cContrast.WinLeft = 488;
  cContrast.WinTop = 113;
  cContrast.WinWidth = 60;
  AppendComponent(cContrast, true);

/*------------------------------------------------------------------------------------*/

  sGamma = new class'DXRSlider';
  sGamma.WinLeft = 309;
  sGamma.WinTop = 46;
  sGamma.bScaleToParent = false;
  AppendComponent(sGamma, true);

  sBrightness = new class'DXRSlider';
  sBrightness.WinLeft = 309;
  sBrightness.WinTop = 79;
  AppendComponent(sBrightness, true);

  sContrast = new class'DXRSlider';
  sContrast.WinLeft = 309;
  sContrast.WinTop = 112;
  AppendComponent(sContrast, true);

/*------------------------------------------------------------------------------------*/

  mGamma = new class'MenuChoice_AdjustGamma';
  mGamma.WinLeft = 15;
  mGamma.WinTop = 46;
  mGamma.WinWidth = 244;
  AppendComponent(mGamma, true);
  mGamma.btnSlider = sGamma;
  mGamma.info = cGamma;
  mGamma.InitSlider();

  mBrightness = new class'MenuChoice_AdjustBrightness';
  mBrightness.WinLeft = 15;
  mBrightness.WinTop = 80;
  mBrightness.WinWidth = 244;
  AppendComponent(mBrightness, true);
  mBrightness.btnSlider = sBrightness;
  mBrightness.info = cBrightness;
  mBrightness.InitSlider();

  mContrast = new class'MenuChoice_AdjustContrast';
  mContrast.WinLeft = 15;
  mContrast.WinTop = 113;
  mContrast.WinWidth = 244;
  AppendComponent(mContrast, true);
  mContrast.btnSlider = sContrast;
  mContrast.info = cContrast;
  mContrast.InitSlider();

  /*----------------------------------------------------------------*/

  btnDefault = new class'GUIButton';
  btnDefault.OnClick=InternalOnClick;
  btnDefault.fontScale = FNS_Small;
  btnDefault.StyleName="STY_DXR_MediumButton";
  btnDefault.Caption = strDefault;
  btnDefault.WinHeight = 21;
  btnDefault.WinWidth = 180;
  btnDefault.WinLeft = 7;
  btnDefault.WinTop = 363;
    AppendComponent(btnDefault, true);

  btnOK = new class'GUIButton';
  btnOK.OnClick=InternalOnClick;
  btnOK.fontScale = FNS_Small;
  btnOK.StyleName="STY_DXR_MediumButton";
  btnOK.Caption = strOK;
  btnOK.WinHeight = 21;
  btnOK.WinWidth = 100;
  btnOK.WinLeft = 465;
  btnOK.WinTop = 363;
    AppendComponent(btnOK, true);

  btnCancel = new class'GUIButton';
  btnCancel.OnClick=InternalOnClick;
  btnCancel.fontScale = FNS_Small;
  btnCancel.StyleName="STY_DXR_MediumButton";
  btnCancel.Caption = strCancel;
  btnCancel.WinHeight = 21;
  btnCancel.WinWidth = 100;
  btnCancel.WinLeft = 365;
  btnCancel.WinTop = 363;
    AppendComponent(btnCancel, true);
}

function resetToDefaults()
{
  local int i;

  for (i=0;i<Controls.Length;i++)
  {
     if (controls[i].IsA('DXREnumButton'))
     {
        DXREnumButton(controls[i]).ResetToDefault();
        DXREnumButton(controls[i]).OnChange(controls[i]); //UpdateInfoButton();
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
  return true;
}


function PaintOnBG(canvas u)
{
   super.PaintOnBG(u);
   // 130
    u.Style = EMenuRenderStyle.MSTY_Masked;

   u.SetPos(actualLeft() + 22, actualTop() + exampleTop);
   u.SetDrawColor(255,0,0,255);
   u.drawIcon(texture'DXR_MenuBrightnessGradient', 1);

   u.SetPos(actualLeft() + 152, actualTop() + exampleTop);
   u.SetDrawColor(0,255,0,255);
   u.drawIcon(texture'DXR_MenuBrightnessGradient', 1);

   u.SetPos(actualLeft() + 282, actualTop() + exampleTop);
   u.SetDrawColor(0,0,255,255);
   u.drawIcon(texture'DXR_MenuBrightnessGradient', 1);

   u.SetPos(actualLeft() + 412, actualTop() + exampleTop);
   u.SetDrawColor(255,255,255,255);
   u.drawIcon(texture'DXR_MenuBrightnessGradient', 1);
}

defaultproperties
{
  exampleTop=146

    DefaultHeight=348
    DefaultWidth=568

    MaxPageHeight=348
    MaxPageWidth=568
    MinPageHeight=348
    MinPageWidth=568

        leftEdgeCorrectorX=4
        leftEdgeCorrectorY=0
        leftEdgeHeight=382

        RightEdgeCorrectorX=565
        RightEdgeCorrectorY=20
        RightEdgeHeight=356

        TopEdgeCorrectorX=482
        TopEdgeCorrectorY=16
    TopEdgeLength=80

    TopRightCornerX=562
    TopRightCornerY=16


    WinTitle="Adjust Gamma, Brightness and Contrast"
    strHelpText="Adjust the sliders so the color bars fade smoothly to pure black at the bottom of the bars.|ÿ Will work only in full-screen mode."


    Begin Object Class=FloatingImage Name=FloatingFrameBackground
        Image=Texture'DXR_MenuBrightnessGammaContrast'
        ImageRenderStyle=MSTY_Translucent
        ImageStyle=ISTY_Tiled
        ImageColor=(R=255,G=255,B=255,A=255)
        DropShadow=None
        WinWidth=560
        WinHeight=348
        WinLeft=8
        WinTop=20
        RenderWeight=0.000003
        bBoundToParent=True
        bScaleToParent=True
        OnRendered=PaintOnBG
    End Object
    i_FrameBG=FloatingFrameBackground
}