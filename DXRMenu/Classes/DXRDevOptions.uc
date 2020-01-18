/*
[Engine.GameEngine]
ColorSlowCollisionMeshes=True
ColorNoCollisionMeshes=False
ColorWorldTextures=False
ColorPlayerAndWeaponTextures=False
ColorInterfaceTextures=False
bSlowRefChecking=False
*/

class DXRDevOptions extends DxWindowTemplate;

var localized string strOk, strDefault, strCancel;
var GUIButton btnOk, btnCancel, btnDefault;

var DXRChoiceInfo iExtraDebugInfo;

var MenuChoice_ExtraDebugInfo mExtraDebugInfo;

function CreateMyControls()
{
  SetSize(410, 400);

  iExtraDebugInfo = new class'DXRChoiceInfo';
  iExtraDebugInfo.WinLeft = 285;
  iExtraDebugInfo.WinTop = 46;
  iExtraDebugInfo.WinWidth = 78;
  AppendComponent(iExtraDebugInfo, true);

  mExtraDebugInfo = new class'MenuChoice_ExtraDebugInfo';
  mExtraDebugInfo.WinLeft = 15;
  mExtraDebugInfo.WinTop = 46;
  mExtraDebugInfo.WinWidth = 244;
  AppendComponent(mExtraDebugInfo, true);
  mExtraDebugInfo.info = iExtraDebugInfo;
  mExtraDebugInfo.LoadSetting();
  mExtraDebugInfo.UpdateInfoButton();


  btnDefault = new class'GUIButton';
  btnDefault.OnClick=InternalOnClick;
  btnDefault.fontScale = FNS_Small;
  btnDefault.StyleName="STY_DXR_MediumButton";
  btnDefault.Caption = strDefault;
  btnDefault.WinHeight = 21;
  btnDefault.WinWidth = 180;
  btnDefault.WinLeft = 7;
  btnDefault.WinTop = 428;
    AppendComponent(btnDefault, true);

  btnOK = new class'GUIButton';
  btnOK.OnClick=InternalOnClick;
  btnOK.fontScale = FNS_Small;
  btnOK.StyleName="STY_DXR_MediumButton";
  btnOK.Caption = strOK;
  btnOK.WinHeight = 21;
  btnOK.WinWidth = 100;
  btnOK.WinLeft = 300;
  btnOK.WinTop = 428;
    AppendComponent(btnOK, true);

  btnCancel = new class'GUIButton';
  btnCancel.OnClick=InternalOnClick;
  btnCancel.fontScale = FNS_Small;
  btnCancel.StyleName="STY_DXR_MediumButton";
  btnCancel.Caption = strCancel;
  btnCancel.WinHeight = 21;
  btnCancel.WinWidth = 100;
  btnCancel.WinLeft = 199;
  btnCancel.WinTop = 428;
    AppendComponent(btnCancel, true);
}

function resetToDefaults()
{
  local int i;

  PlayerOwner().ConsoleCommand("FLUSH"); // Cleanup engine caches, so you will see changes immediately

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

  PlayerOwner().ConsoleCommand("FLUSH"); // Cleanup engine caches, so you will see changes immediately

  for (i=0;i<Controls.Length;i++)
  {
     if (controls[i].IsA('DXREnumButton'))
        DXREnumButton(controls[i]).SaveSetting();
  }
}

function CancelSettings()
{
  local int i;

//  PlayerOwner().ConsoleCommand("FLUSH"); // Cleanup engine caches, so you will see changes immediately

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



defaultproperties
{
    strOk="OK"
    strDefault="Reset to Defaults"
    strCancel="Cancel"
    WinTitle="Developer options"

        leftEdgeCorrectorX=4
        leftEdgeCorrectorY=0
        leftEdgeHeight=447

        RightEdgeCorrectorX=399
        RightEdgeCorrectorY=20
        RightEdgeHeight=420

        TopEdgeCorrectorX=310
        TopEdgeCorrectorY=16
    TopEdgeLength=86

    TopRightCornerX=396
    TopRightCornerY=16


    Begin Object Class=FloatingImage Name=FloatingFrameBackground
        Image=Texture'DXR_DisplayBackground'
        ImageRenderStyle=MSTY_Translucent
        ImageStyle=ISTY_Tiled
        ImageColor=(R=255,G=255,B=255,A=255)
        DropShadow=None
        WinWidth=393
        WinHeight=410
        WinLeft=8
        WinTop=20
        RenderWeight=0.000003
        bBoundToParent=True
        bScaleToParent=True
        OnRendered=PaintOnBG
    End Object
    i_FrameBG=FloatingFrameBackground
}