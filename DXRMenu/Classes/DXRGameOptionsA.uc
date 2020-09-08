/*
   Дополнительные игровые настройки.
*/

class DXRGameOptionsA extends DXRConfigurationDialog;

var MenuChoice_LeftClickForLastItem mLeftClickForLastItem;
var MenuChoice_RemainingAmmo mRemainingAmmo;
var MenuChoice_PlayerInterfaceMode mPlayerInterfaceMode;
var MenuChoice_UseCursorEffects mUseCursorEffects;

var MenuChoice_DelayedExplosions mMenuChoice_DelayedExplosions;
var MenuChoice_BurnStaticObjects mMenuChoice_BurnStaticObjects;
var MenuChoice_InfiniteTurretsAmmo mMenuChoice_InfiniteTurretsAmmo;

var DXRChoiceInfo iLeftClickForLastItem, iRemainingAmmo, iExtraDebugInfo, iPlayerInterfaceMode, iUseCursorEffects;
var DXRChoiceInfo iMenuChoice_DelayedExplosions, iMenuChoice_BurnStaticObjects, iMenuChoice_InfiniteTurretsAmmo;

var localized string strGamma, strGraphics, strPhysics;
var GUIButton btnDefault, btnOK, btnCancel;

function CreateMyControls()
{
  SetSize(226, 548);

  // Information fields first, this is important, otherwise scary things will happen...
  iLeftClickForLastItem = new class'DXRChoiceInfo';
  iLeftClickForLastItem.WinLeft = 285;
  iLeftClickForLastItem.WinTop = 46;
  iLeftClickForLastItem.WinWidth = 178;
  AppendComponent(iLeftClickForLastItem, true);

  iRemainingAmmo = new class'DXRChoiceInfo';
  iRemainingAmmo.WinLeft = 285;
  iRemainingAmmo.WinTop = 82;
  iRemainingAmmo.WinWidth = 178;
  AppendComponent(iRemainingAmmo, true);

  iPlayerInterfaceMode = new class'DXRChoiceInfo';
  iPlayerInterfaceMode.WinLeft = 285;
  iPlayerInterfaceMode.WinTop = 118;
  iPlayerInterfaceMode.WinWidth = 178;
  AppendComponent(iPlayerInterfaceMode, true);

  iUseCursorEffects = new class'DXRChoiceInfo';
  iUseCursorEffects.WinLeft = 285;
  iUseCursorEffects.WinTop = 154;
  iUseCursorEffects.WinWidth = 178;
  AppendComponent(iUseCursorEffects, true);

  // Новые
  iMenuChoice_DelayedExplosions = new class'DXRChoiceInfo';
  iMenuChoice_DelayedExplosions.WinLeft = 285;
  iMenuChoice_DelayedExplosions.WinTop = 190;
  iMenuChoice_DelayedExplosions.WinWidth = 178;
  AppendComponent(iMenuChoice_DelayedExplosions, true);

  iMenuChoice_BurnStaticObjects = new class'DXRChoiceInfo';
  iMenuChoice_BurnStaticObjects.WinLeft = 285;
  iMenuChoice_BurnStaticObjects.WinTop = 226;
  iMenuChoice_BurnStaticObjects.WinWidth = 178;
  AppendComponent(iMenuChoice_BurnStaticObjects, true);

  iMenuChoice_InfiniteTurretsAmmo = new class'DXRChoiceInfo';
  iMenuChoice_InfiniteTurretsAmmo.WinLeft = 285;
  iMenuChoice_InfiniteTurretsAmmo.WinTop = 262;
  iMenuChoice_InfiniteTurretsAmmo.WinWidth = 178;
  AppendComponent(iMenuChoice_InfiniteTurretsAmmo, true);


  mLeftClickForLastItem = new class'MenuChoice_LeftClickForLastItem';
  mLeftClickForLastItem.WinLeft = 15;
  mLeftClickForLastItem.WinTop = 46;
  mLeftClickForLastItem.WinWidth = 244;
  AppendComponent(mLeftClickForLastItem, true);
  mLeftClickForLastItem.info = iLeftClickForLastItem;
  mLeftClickForLastItem.LoadSetting();
  mLeftClickForLastItem.UpdateInfoButton();

  mRemainingAmmo = new class'MenuChoice_RemainingAmmo';
  mRemainingAmmo.WinLeft = 15;
  mRemainingAmmo.WinTop = 82;
  mRemainingAmmo.WinWidth = 244;
  AppendComponent(mRemainingAmmo, true);
  mRemainingAmmo.info = iRemainingAmmo;
  mRemainingAmmo.LoadSetting();
  mRemainingAmmo.UpdateInfoButton();

  mPlayerInterfaceMode = new class'MenuChoice_PlayerInterfaceMode';
  mPlayerInterfaceMode.WinLeft = 15;
  mPlayerInterfaceMode.WinTop = 118;
  mPlayerInterfaceMode.WinWidth = 244;
  AppendComponent(mPlayerInterfaceMode, true);
  mPlayerInterfaceMode.info = iPlayerInterfaceMode;
  mPlayerInterfaceMode.LoadSetting();
  mPlayerInterfaceMode.UpdateInfoButton();

  mUseCursorEffects = new class'MenuChoice_UseCursorEffects';
  mUseCursorEffects.WinLeft = 15;
  mUseCursorEffects.WinTop = 154;
  mUseCursorEffects.WinWidth = 244;
  AppendComponent(mUseCursorEffects, true);
  mUseCursorEffects.info = iUseCursorEffects;
  mUseCursorEffects.LoadSetting();
  mUseCursorEffects.UpdateInfoButton();

  // Новые
  mMenuChoice_DelayedExplosions = new class'MenuChoice_DelayedExplosions';
  mMenuChoice_DelayedExplosions.WinLeft = 15;
  mMenuChoice_DelayedExplosions.WinTop = 190;
  mMenuChoice_DelayedExplosions.WinWidth = 244;
  AppendComponent(mMenuChoice_DelayedExplosions, true);
  mMenuChoice_DelayedExplosions.info = iMenuChoice_DelayedExplosions;
  mMenuChoice_DelayedExplosions.LoadSetting();
  mMenuChoice_DelayedExplosions.UpdateInfoButton();

  mMenuChoice_BurnStaticObjects = new class'MenuChoice_BurnStaticObjects';
  mMenuChoice_BurnStaticObjects.WinLeft = 15;
  mMenuChoice_BurnStaticObjects.WinTop = 226;
  mMenuChoice_BurnStaticObjects.WinWidth = 244;
  AppendComponent(mMenuChoice_BurnStaticObjects, true);
  mMenuChoice_BurnStaticObjects.info = iMenuChoice_BurnStaticObjects;
  mMenuChoice_BurnStaticObjects.LoadSetting();
  mMenuChoice_BurnStaticObjects.UpdateInfoButton();

  mMenuChoice_InfiniteTurretsAmmo = new class'MenuChoice_InfiniteTurretsAmmo';
  mMenuChoice_InfiniteTurretsAmmo.WinLeft = 15;
  mMenuChoice_InfiniteTurretsAmmo.WinTop = 262;
  mMenuChoice_InfiniteTurretsAmmo.WinWidth = 244;
  AppendComponent(mMenuChoice_InfiniteTurretsAmmo, true);
  mMenuChoice_InfiniteTurretsAmmo.info = iMenuChoice_InfiniteTurretsAmmo;
  mMenuChoice_InfiniteTurretsAmmo.LoadSetting();
  mMenuChoice_InfiniteTurretsAmmo.UpdateInfoButton();




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
    WinTitle="Additional game options"

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

