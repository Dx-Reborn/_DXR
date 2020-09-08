/*
  Пока здесь будет только одна опция )) Возможно будет что-то еще связанное с KARMA, не знаю...
*/

class DXRPhysics extends DXRConfigurationDialog;

var GUIButton btnDefault, btnOK, btnCancel;
var DXRChoiceInfo pdInfo;
var MenuChoice_PhysicsDetail mPhysicsDetail;

function CreateMyControls()
{
  SetSize(150, 548);

  pdInfo = new class'DXRChoiceInfo';
  pdInfo.WinLeft = 285;
  pdInfo.WinTop = 46;
  pdInfo.WinWidth = 78;
  AppendComponent(pdInfo, true);

  mPhysicsDetail = new class'MenuChoice_PhysicsDetail';
  mPhysicsDetail.WinLeft = 15;
  mPhysicsDetail.WinTop = 46;
  mPhysicsDetail.WinWidth = 244;
  AppendComponent(mPhysicsDetail, true);
  mPhysicsDetail.info = pdInfo;
  mPhysicsDetail.LoadSetting();
  mPhysicsDetail.UpdateInfoButton();


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
  btnCancel.WinTop = 149;//232; 83
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
    WinTitle="Physics"

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
