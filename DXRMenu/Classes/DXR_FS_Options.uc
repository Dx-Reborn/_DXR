/*
   Setup sounds.
   Presets for footstepping
   Use sounds for ladders
   Use Special sounds (port these from GMDX first)
*/

class DXR_FS_Options extends DxWindowTemplate;

var GUIButton btnDefault, btnOK, btnCancel;
var DXRChoiceInfo iFS_Info, iLS_Toggle;
var MenuChoice_FS_Preset mMenuChoice_FS_Preset;
var MenuChoice_SoundForLadders mMenuChoice_SoundForLadders;

var localized string strOk, strDefault, strCancel, strHelp;

function CreateMyControls()
{
  SetSize(150, 548);

  iFS_Info = new class'DXRChoiceInfo';
  iFS_Info.WinLeft = 285;
  iFS_Info.WinTop = 46;
  iFS_Info.WinWidth = 200;
  AppendComponent(iFS_Info, true);

  iLS_Toggle = new class'DXRChoiceInfo';
  iLS_Toggle.WinLeft = 285;
  iLS_Toggle.WinTop = 82;
  iLS_Toggle.WinWidth = 200;
  AppendComponent(iLS_Toggle, true);

  mMenuChoice_FS_Preset = new class'MenuChoice_FS_Preset';
  mMenuChoice_FS_Preset.WinLeft = 15;
  mMenuChoice_FS_Preset.WinTop = 46;
  mMenuChoice_FS_Preset.WinWidth = 244;
  AppendComponent(mMenuChoice_FS_Preset, true);
  mMenuChoice_FS_Preset.info = iFS_Info;
  mMenuChoice_FS_Preset.LoadSetting();
  mMenuChoice_FS_Preset.UpdateInfoButton();

  mMenuChoice_SoundForLadders = new class'MenuChoice_SoundForLadders';
  mMenuChoice_SoundForLadders.WinLeft = 15;
  mMenuChoice_SoundForLadders.WinTop = 82;
  mMenuChoice_SoundForLadders.WinWidth = 244;
  AppendComponent(mMenuChoice_SoundForLadders, true);
  mMenuChoice_SoundForLadders.info = iLS_Toggle;
  mMenuChoice_SoundForLadders.LoadSetting();
  mMenuChoice_SoundForLadders.UpdateInfoButton();

  btnDefault = new class'GUIButton';
  btnDefault.OnClick=InternalOnClick;
  btnDefault.fontScale = FNS_Small;
  btnDefault.StyleName="STY_DXR_MediumButton";
  btnDefault.Caption = strDefault;
  btnDefault.WinHeight = 21;
  btnDefault.WinWidth = 180;
  btnDefault.WinLeft = 7;
  btnDefault.WinTop = 149;
  AppendComponent(btnDefault, true);

  btnOK = new class'GUIButton';
  btnOK.OnClick=InternalOnClick;
  btnOK.fontScale = FNS_Small;
  btnOK.StyleName="STY_DXR_MediumButton";
  btnOK.Caption = strOK;
  btnOK.WinHeight = 21;
  btnOK.WinWidth = 100;
  btnOK.WinLeft = 445;
  btnOK.WinTop = 149;
  AppendComponent(btnOK, true);

  btnCancel = new class'GUIButton';
  btnCancel.OnClick=InternalOnClick;
  btnCancel.fontScale = FNS_Small;
  btnCancel.StyleName="STY_DXR_MediumButton";
  btnCancel.Caption = strCancel;
  btnCancel.WinHeight = 21;
  btnCancel.WinWidth = 100;
  btnCancel.WinLeft = 344;
  btnCancel.WinTop = 149;
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



defaultproperties
{
    strOk="OK"
    strDefault="Reset to Defaults"
    strCancel="Cancel"
    strHelp="Select set of footstep sounds. This will affect all pawns."
    WinTitle="Setup footstepping sounds"

        leftEdgeCorrectorX=4
        leftEdgeCorrectorY=0
        leftEdgeHeight=168

        RightEdgeCorrectorX=545
        RightEdgeCorrectorY=20
        RightEdgeHeight=141

        TopEdgeCorrectorX=462
        TopEdgeCorrectorY=16
    TopEdgeLength=80

    TopRightCornerX=542
    TopRightCornerY=16


    Begin Object Class=FloatingImage Name=FloatingFrameBackground
        Image=Texture'DXR_Physics'
        ImageRenderStyle=MSTY_Translucent
        ImageStyle=ISTY_Tiled
        ImageColor=(R=255,G=255,B=255,A=255)
        DropShadow=None
        WinWidth=538
        WinHeight=128
        WinLeft=8
        WinTop=20
        RenderWeight=0.000003
        bBoundToParent=True
        bScaleToParent=True
        OnRendered=PaintOnBG
    End Object
    i_FrameBG=FloatingFrameBackground
}