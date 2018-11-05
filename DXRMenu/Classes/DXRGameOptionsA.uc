/*

*/

class DXRGameOptionsA extends DxWindowTemplate;

var MenuChoice_LeftClickForLastItem mLeftClickForLastItem;
var MenuChoice_RemainingAmmo mRemainingAmmo;
//var MenuChoice_StartupFullScreen mMenuChoice_StartupFullScreen;
var DXRChoiceInfo iLeftClickForLastItem, iRemainingAmmo, cFullScreen;
var localized string strOK, strCancel, strDefault;
var localized string strGamma, strGraphics, strPhysics;
var GUIButton btnDefault, btnOK, btnCancel;

function CreateMyControls()
{
  SetSize(226, 548);

  // Information fields first, this is important, otherwise scary things will happen...
  iLeftClickForLastItem = new class'DXRChoiceInfo';
  iLeftClickForLastItem.WinLeft = 285;
  iLeftClickForLastItem.WinTop = 46;
  iLeftClickForLastItem.WinWidth = 78;
  AppendComponent(iLeftClickForLastItem, true);

  iRemainingAmmo = new class'DXRChoiceInfo';
  iRemainingAmmo.WinLeft = 285;
  iRemainingAmmo.WinTop = 82;
  iRemainingAmmo.WinWidth = 78;
  AppendComponent(iRemainingAmmo, true);
/*
  cFullScreen = new class'DXRChoiceInfo';
  cFullScreen.WinLeft = 285;
  cFullScreen.WinTop = 118;
  cFullScreen.WinWidth = 78;
  AppendComponent(cFullScreen, true);
*/
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
/*
  mMenuChoice_StartupFullScreen = new class'MenuChoice_StartupFullScreen';
  mMenuChoice_StartupFullScreen.WinLeft = 15;
  mMenuChoice_StartupFullScreen.WinTop = 118;
  mMenuChoice_StartupFullScreen.WinWidth = 244;
  AppendComponent(mMenuChoice_StartupFullScreen, true);
  mMenuChoice_StartupFullScreen.info = cFullScreen;
  mMenuChoice_StartupFullScreen.LoadSetting();
  mMenuChoice_StartupFullScreen.UpdateInfoButton();
*/

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

  strOK="OK"
  strCancel="Cancel"
  strDefault="Reset to defaults"

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