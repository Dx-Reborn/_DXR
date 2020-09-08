/*

*/

class DXRMenuControl extends DXRConfigurationDialog;

var GUIButton btnOK, btnCancel, btnDefault;

var MenuChoice_AlwaysRun mAlwaysRun;
var MenuChoice_ToggleCrouch mToggleCrouch;
var MenuChoice_InvertMouse mInvertMouse;
var MenuChoice_MouseSensitivity mMouseSens;
var MenuChoice_MenuMouseSensitivity mMenuSens;

var DXRChoiceInfo cMouseSens, cToggleCrouch, cInvertMouse, cAlwaysRun, cMenuSens;
var DXRSlider sMouseSens, sMenuSens;


function CreateMyControls()
{
  btnDefault = new class'GUIButton';
  btnDefault.OnClick=InternalOnClick;
  btnDefault.fontScale = FNS_Small;
  btnDefault.StyleName="STY_DXR_MediumButton";
  btnDefault.Caption = strDefault;
  btnDefault.WinHeight = 21;
  btnDefault.WinWidth = 180;
  btnDefault.WinLeft = 7;
  btnDefault.WinTop = 256;
    AppendComponent(btnDefault, true);

  btnOK = new class'GUIButton';
  btnOK.OnClick=InternalOnClick;
  btnOK.fontScale = FNS_Small;
  btnOK.StyleName="STY_DXR_MediumButton";
  btnOK.Caption = strOK;
  btnOK.WinHeight = 21;
  btnOK.WinWidth = 100;
  btnOK.WinLeft = 445;
  btnOK.WinTop = 256;
    AppendComponent(btnOK, true);

  btnCancel = new class'GUIButton';
  btnCancel.OnClick=InternalOnClick;
  btnCancel.fontScale = FNS_Small;
  btnCancel.StyleName="STY_DXR_MediumButton";
  btnCancel.Caption = strCancel;
  btnCancel.WinHeight = 21;
  btnCancel.WinWidth = 100;
  btnCancel.WinLeft = 344;
  btnCancel.WinTop = 256;
    AppendComponent(btnCancel, true);
    /*------------------------------------------------------------*/
  sMouseSens = new class'DXRSlider';
  sMouseSens.WinLeft = 289;
  sMouseSens.WinTop = 154;
  AppendComponent(sMouseSens, true);

  cMouseSens = new class'DXRChoiceInfo';
  cMouseSens.WinLeft = 469;
  cMouseSens.WinTop = 155;
  cMouseSens.WinWidth = 60;
  AppendComponent(cMouseSens, true);

  mMouseSens = new class'MenuChoice_MouseSensitivity';
  mMouseSens.WinLeft = 15;
  mMouseSens.WinTop = 155;
  mMouseSens.WinWidth = 244;
  AppendComponent(mMouseSens, true);
  mMouseSens.btnSlider = sMouseSens;
  mMouseSens.info = cMouseSens;
  mMouseSens.InitSlider();

  /*-------------------------------------------------------------------------------------------------------------*/
  cToggleCrouch = new class'DXRChoiceInfo';
  cToggleCrouch.WinLeft = 285;
  cToggleCrouch.WinTop = 47;
  cToggleCrouch.WinWidth = 77;
  AppendComponent(cToggleCrouch, true);

  mToggleCrouch = new class'MenuChoice_ToggleCrouch';
  mToggleCrouch.WinLeft = 15;
  mToggleCrouch.WinTop = 47;
  mToggleCrouch.WinWidth = 244;
  AppendComponent(mToggleCrouch, true);
  mToggleCrouch.info = cToggleCrouch;
  mToggleCrouch.LoadSetting();
  mToggleCrouch.UpdateInfoButton();
  /*------------------------------------------------------------*/
  cInvertMouse = new class'DXRChoiceInfo';
  cInvertMouse.WinLeft = 285;
  cInvertMouse.WinTop = 83;
  cInvertMouse.WinWidth = 77;
  AppendComponent(cInvertMouse, true);

  mInvertMouse = new class'MenuChoice_InvertMouse';
  mInvertMouse.WinLeft = 15;
  mInvertMouse.WinTop = 83;
  mInvertMouse.WinWidth = 244;
  AppendComponent(mInvertMouse, true);
  mInvertMouse.info = cInvertMouse;
  mInvertMouse.LoadSetting();
  mInvertMouse.UpdateInfoButton();
  /*------------------------------------------------------------*/
  cAlwaysRun = new class'DXRChoiceInfo';
  cAlwaysRun.WinLeft = 285;
  cAlwaysRun.WinTop = 119;
  cAlwaysRun.WinWidth = 77;
  AppendComponent(cAlwaysRun, true);

  mAlwaysRun = new class'MenuChoice_AlwaysRun';
  mAlwaysRun.WinLeft = 15;
  mAlwaysRun.WinTop = 119;
  mAlwaysRun.WinWidth = 244;
  AppendComponent(mAlwaysRun, true);
  mAlwaysRun.info = cAlwaysRun;
  mAlwaysRun.LoadSetting();
  mAlwaysRun.UpdateInfoButton();
  /*--------------------------------------------------------------------*/
  sMenuSens = new class'DXRSlider';
  sMenuSens.WinLeft = 289;
  sMenuSens.WinTop = 190;
  AppendComponent(sMenuSens, true);

  cMenuSens = new class'DXRChoiceInfo';
  cMenuSens.WinLeft = 469;
  cMenuSens.WinTop = 191;
  cMenuSens.WinWidth = 60;
  AppendComponent(cMenuSens, true);

  mMenuSens = new class'MenuChoice_MenuMouseSensitivity';
  mMenuSens.WinLeft = 15;
  mMenuSens.WinTop = 191;
  mMenuSens.WinWidth = 244;
  AppendComponent(mMenuSens, true);
  mMenuSens.btnSlider = sMenuSens;
  mMenuSens.info = cMenuSens;
  mMenuSens.InitSlider();
  // Есть место под еще одну какую-нибудь опцию ))
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
  return true;
}
/*-----------------------------------------------------*/










defaultproperties
{

  strDefault="Reset to defaults"


    DefaultHeight=256
    DefaultWidth=548

    MaxPageHeight=256
    MaxPageWidth=548
    MinPageHeight=256
    MinPageWidth=548

        leftEdgeCorrectorX=4
        leftEdgeCorrectorY=0
        leftEdgeHeight=275

        RightEdgeCorrectorX=545
        RightEdgeCorrectorY=20
        RightEdgeHeight=248

        TopEdgeCorrectorX=462
        TopEdgeCorrectorY=16
    TopEdgeLength=80

    TopRightCornerX=542
    TopRightCornerY=16


    Begin Object Class=FloatingImage Name=FloatingFrameBackground
        Image=Texture'DXR_MenuControlsBackground'
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