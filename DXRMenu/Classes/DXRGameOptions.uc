/*

*/
class DXRGameOptions extends DxWindowTemplate;

var localized string strOk, strDefault, strCancel;
var GUIButton btnOk, btnCancel, btnDefault;

var DXRChoiceInfo iObjectNames, iWeaponAutoReload, iGoreLevel, iSubtitles, iCrosshairs;
var DXRChoiceInfo iHUDAugDisplay, iUIBackground, iHeadBob, iLogTimeoutValue;

var DXRSlider sLogTimeoutValue;

var MenuChoice_ObjectNames       mObjectNames;
var MenuChoice_WeaponAutoReload  mWeaponAutoReload;
var MenuChoice_GoreLevel         mGoreLevel;
var MenuChoice_Subtitles         mSubtitles;
var MenuChoice_Crosshairs        mCrosshairs;
var MenuChoice_HUDAugDisplay     mHUDAugDisplay;
var MenuChoice_UIBackground      mUIBackground;
var MenuChoice_HeadBob           mHeadBob;
var MenuChoice_LogTimeoutValue   mLogTimeoutValue;


function CreateMyControls()
{
  SetSize(410, 548);

  iObjectNames = new class'DXRChoiceInfo';
  iObjectNames.WinLeft = 285;
  iObjectNames.WinTop = 46;
  iObjectNames.WinWidth = 89;
  AppendComponent(iObjectNames, true);

  iWeaponAutoReload = new class'DXRChoiceInfo';
  iWeaponAutoReload.WinLeft = 285;
  iWeaponAutoReload.WinTop = 82;
  iWeaponAutoReload.WinWidth = 89;
  AppendComponent(iWeaponAutoReload, true);

  iGoreLevel = new class'DXRChoiceInfo';
  iGoreLevel.WinLeft = 285;
  iGoreLevel.WinTop = 118;
  iGoreLevel.WinWidth = 89;
  AppendComponent(iGoreLevel, true);

  iSubtitles = new class'DXRChoiceInfo';
  iSubtitles.WinLeft = 285;
  iSubtitles.WinTop = 154;
  iSubtitles.WinWidth = 89;
  AppendComponent(iSubtitles, true);

  iCrosshairs = new class'DXRChoiceInfo';
  iCrosshairs.WinLeft = 285;
  iCrosshairs.WinTop = 190;
  iCrosshairs.WinWidth = 89;
  AppendComponent(iCrosshairs, true);

  iHUDAugDisplay = new class'DXRChoiceInfo';
  iHUDAugDisplay.WinLeft = 285;
  iHUDAugDisplay.WinTop = 226;
  iHUDAugDisplay.WinWidth = 89;
  AppendComponent(iHUDAugDisplay, true);

  iUIBackground = new class'DXRChoiceInfo';
  iUIBackground.WinLeft = 285;
  iUIBackground.WinTop = 262;
  iUIBackground.WinWidth = 89;
  AppendComponent(iUIBackground, true);

  iHeadBob = new class'DXRChoiceInfo';
  iHeadBob.WinLeft = 285;
  iHeadBob.WinTop = 298;
  iHeadBob.WinWidth = 89;
  AppendComponent(iHeadBob, true);

  iLogTimeoutValue = new class'DXRChoiceInfo';
  iLogTimeoutValue.WinLeft = 469.000000;
  iLogTimeoutValue.WinTop = 334;
  iLogTimeoutValue.WinWidth = 64.000000;
  AppendComponent(iLogTimeoutValue, true);

  sLogTimeoutValue = new class'DXRSlider';
  sLogTimeoutValue.WinLeft = 289;
  sLogTimeoutValue.WinTop = 334;
  AppendComponent(sLogTimeoutValue, true);


  /*----------------------------------------------------*/
  mObjectNames = new class'MenuChoice_ObjectNames';
  mObjectNames.WinLeft = 15;
  mObjectNames.WinTop = 46;
  mObjectNames.WinWidth = 244;
  AppendComponent(mObjectNames, true);
  mObjectNames.info = iObjectNames;
  mObjectNames.LoadSetting();
  mObjectNames.UpdateInfoButton();

  mWeaponAutoReload = new class'MenuChoice_WeaponAutoReload';
  mWeaponAutoReload.WinLeft = 15;
  mWeaponAutoReload.WinTop = 82;
  mWeaponAutoReload.WinWidth = 244;
  AppendComponent(mWeaponAutoReload, true);
  mWeaponAutoReload.info = iWeaponAutoReload;
  mWeaponAutoReload.LoadSetting();
  mWeaponAutoReload.UpdateInfoButton();

  mGoreLevel = new class'MenuChoice_GoreLevel';
  mGoreLevel.WinLeft = 15;
  mGoreLevel.WinTop = 118;
  mGoreLevel.WinWidth = 244;
  AppendComponent(mGoreLevel, true);
  mGoreLevel.info = iGoreLevel;
  mGoreLevel.LoadSetting();
  mGoreLevel.UpdateInfoButton();

  mSubtitles = new class'MenuChoice_Subtitles';
  mSubtitles.WinLeft = 15;
  mSubtitles.WinTop = 154;
  mSubtitles.WinWidth = 244;
  AppendComponent(mSubtitles, true);
  mSubtitles.info = iSubtitles;
  mSubtitles.LoadSetting();
  mSubtitles.UpdateInfoButton();

  mCrosshairs = new class'MenuChoice_Crosshairs';
  mCrosshairs.WinLeft = 15;
  mCrosshairs.WinTop = 190;
  mCrosshairs.WinWidth = 244;
  AppendComponent(mCrosshairs, true);
  mCrosshairs.info = iCrosshairs;
  mCrosshairs.LoadSetting();
  mCrosshairs.UpdateInfoButton();

  mHUDAugDisplay = new class'MenuChoice_HUDAugDisplay';
  mHUDAugDisplay.WinLeft = 15;
  mHUDAugDisplay.WinTop = 226;
  mHUDAugDisplay.WinWidth = 244;
  AppendComponent(mHUDAugDisplay, true);
  mHUDAugDisplay.info = iHUDAugDisplay;
  mHUDAugDisplay.LoadSetting();
  mHUDAugDisplay.UpdateInfoButton();

  mUIBackground = new class'MenuChoice_UIBackground';
  mUIBackground.WinLeft = 15;
  mUIBackground.WinTop = 262;
  mUIBackground.WinWidth = 244;
  AppendComponent(mUIBackground, true);
  mUIBackground.info = iUIBackground;
  mUIBackground.LoadSetting();
  mUIBackground.UpdateInfoButton();

  mHeadBob = new class'MenuChoice_HeadBob';
  mHeadBob.WinLeft = 15;
  mHeadBob.WinTop = 298;
  mHeadBob.WinWidth = 244;
  AppendComponent(mHeadBob, true);
  mHeadBob.info = iHeadBob;
  mHeadBob.LoadSetting();
  mHeadBob.UpdateInfoButton();

  mLogTimeoutValue = new class'MenuChoice_LogTimeoutValue';
  mLogTimeoutValue.WinLeft = 15;
  mLogTimeoutValue.WinTop = 334;
  mLogTimeoutValue.WinWidth = 244;
  AppendComponent(mLogTimeoutValue, true);
  mLogTimeoutValue.btnSlider = sLogTimeoutValue;
  mLogTimeoutValue.info = iLogTimeoutValue;
  mLogTimeoutValue.InitSlider();

/*
  mDetailTexMipBias.info = iDetailTexMipBias;
  mDetailTexMipBias.LoadSetting();
  mDetailTexMipBias.UpdateInfoButton();
  */

  /*----------------------------------------------------*/
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
  btnOK.WinLeft = 446;
  btnOK.WinTop = 428;
	AppendComponent(btnOK, true);

  btnCancel = new class'GUIButton';
  btnCancel.OnClick=InternalOnClick;
  btnCancel.fontScale = FNS_Small;
  btnCancel.StyleName="STY_DXR_MediumButton";
  btnCancel.Caption = strCancel;
  btnCancel.WinHeight = 21;
  btnCancel.WinWidth = 100;
  btnCancel.WinLeft = 345;
  btnCancel.WinTop = 428;
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
    strOk="OK"
    strDefault="Reset to Defaults"
    strCancel="Cancel"
    WinTitle="Game Options"

		leftEdgeCorrectorX=4
		leftEdgeCorrectorY=0
		leftEdgeHeight=447

		RightEdgeCorrectorX=545
		RightEdgeCorrectorY=20
		RightEdgeHeight=420

		TopEdgeCorrectorX=456
		TopEdgeCorrectorY=16
    TopEdgeLength=86

    TopRightCornerX=542
    TopRightCornerY=16


	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Texture'DXR_MenuGameOptionsBackground'
		ImageRenderStyle=MSTY_Translucent
		ImageStyle=ISTY_Tiled
		ImageColor=(R=255,G=255,B=255,A=255)
		DropShadow=None
		WinWidth=540
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