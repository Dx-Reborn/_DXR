/*
   Ещё немного дополнительных игровых настроек.
*/

class DXRGameOptionsB extends DXRConfigurationDialog;

var localized string strGamma, strGraphics, strPhysics;
var GUIButton btnDefault, btnOK, btnCancel;

var MenuChoice_Hitmarker mMenuChoice_Hitmarker;
var DXRChoiceInfo iMenuChoice_Hitmarker;

function CreateMyControls()
{
  SetSize(226, 548);

  // Information fields first, this is important, otherwise scary things will happen...
  iMenuChoice_Hitmarker = new class'DXRChoiceInfo';
  iMenuChoice_Hitmarker.WinLeft = 285;
  iMenuChoice_Hitmarker.WinTop = 46;
  iMenuChoice_Hitmarker.WinWidth = 178;
  AppendComponent(iMenuChoice_Hitmarker, true);

  mMenuChoice_Hitmarker = new class'MenuChoice_Hitmarker';
  mMenuChoice_Hitmarker.WinLeft = 15;
  mMenuChoice_Hitmarker.WinTop = 46;
  mMenuChoice_Hitmarker.WinWidth = 244;
  AppendComponent(mMenuChoice_Hitmarker, true);
  mMenuChoice_Hitmarker.info = iMenuChoice_Hitmarker;
  mMenuChoice_Hitmarker.LoadSetting();
  mMenuChoice_Hitmarker.UpdateInfoButton();
  /*-------------------------------------*/




  btnDefault = new class'GUIButton';
  btnDefault.OnClick=InternalOnClick;
  btnDefault.fontScale = FNS_Small;
  btnDefault.StyleName="STY_DXR_MediumButton";
  btnDefault.Caption = strDefault;
  btnDefault.WinHeight = 21;
  btnDefault.WinWidth = 180;
  btnDefault.WinLeft = 7;
  btnDefault.WinTop = 320;
  AppendComponent(btnDefault, true);

  btnOK = new class'GUIButton';
  btnOK.OnClick=InternalOnClick;
  btnOK.fontScale = FNS_Small;
  btnOK.StyleName="STY_DXR_MediumButton";
  btnOK.Caption = strOK;
  btnOK.WinHeight = 21;
  btnOK.WinWidth = 100;
  btnOK.WinLeft = 445;
  btnOK.WinTop = 320;
  AppendComponent(btnOK, true);

  btnCancel = new class'GUIButton';
  btnCancel.OnClick=InternalOnClick;
  btnCancel.fontScale = FNS_Small;
  btnCancel.StyleName="STY_DXR_MediumButton";
  btnCancel.Caption = strCancel;
  btnCancel.WinHeight = 21;
  btnCancel.WinWidth = 100;
  btnCancel.WinLeft = 344;
  btnCancel.WinTop = 320;
  AppendComponent(btnCancel, true);
  /*-------------------------------------------------------------*/


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
    DeusExPlayer(playerOwner().pawn).SaveConfig();
    gl.SaveConfig();
}

function SaveSettings()
{
  local int i;

  for (i=0;i<Controls.Length;i++)
  {
     if (controls[i].IsA('DXREnumButton'))
        DXREnumButton(controls[i]).SaveSetting();
  }
    DeusExPlayer(playerOwner().pawn).SaveConfig();
    gl.SaveConfig();
}

function CancelSettings()
{
  local int i;

  for (i=0;i<Controls.Length;i++)
  {
     if (controls[i].IsA('DXREnumButton'))
        DXREnumButton(controls[i]).CancelSetting();
  }
    DeusExPlayer(playerOwner().pawn).SaveConfig();
    gl.SaveConfig();
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



defaultproperties
{
    WinTitle="Additional game options (2)"

    leftEdgeCorrectorX=4
    leftEdgeCorrectorY=0
    leftEdgeHeight=340

    RightEdgeCorrectorX=545
    RightEdgeCorrectorY=20
    RightEdgeHeight=314

    TopEdgeCorrectorX=462
    TopEdgeCorrectorY=16
    TopEdgeLength=80

    TopRightCornerX=542
    TopRightCornerY=16


    Begin Object Class=FloatingImage Name=FloatingFrameBackground
        Image=Texture'DXR_SpecialOptions'
        ImageRenderStyle=MSTY_Translucent
        ImageStyle=ISTY_Stretched
        ImageColor=(R=255,G=255,B=255,A=255)
        DropShadow=None
        WinWidth=546
        WinHeight=300
        WinLeft=8
        WinTop=20
        RenderWeight=0.000003
        bBoundToParent=True
        bScaleToParent=True
        OnRendered=PaintOnBG
    End Object
    i_FrameBG=FloatingFrameBackground
}

