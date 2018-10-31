/*

*/
class DXRGraphics extends DxWindowTemplate;

var localized string strOk, strDefault, strCancel;

var DXRChoiceInfo iNoDynamicLights, iProjectors, iUseCompressedLightmaps, iSuperHighDetailActors, iHighDetailActors;
var DXRChoiceInfo iWeatherEffects, iDetailTextures, iDecoLayers, iDecals, iCoronas;

var MenuChoice_NoDynamicLights mNoDynamicLights;
var MenuChoice_Projectors mProjectors;
var MenuChoice_UseCompressedLightmaps mUseCompressedLightmaps;
var MenuChoice_SuperHighDetailActors mSuperHighDetailActors;
var MenuChoice_HighDetailActors mHighDetailActors;
var MenuChoice_WeatherEffects mWeatherEffects;
var MenuChoice_DetailTextures mDetailTextures;
var MenuChoice_DecoLayers mDecoLayers;
var MenuChoice_Decals mDecals;
var MenuChoice_Coronas mCoronas;

var GUIButton btnOk, btnCancel, btnDefault;

function CreateMyControls()
{
  SetSize(410, 400);

  // Information fields first, this is important, otherwise scary things will happen...
  iNoDynamicLights = new class'DXRChoiceInfo';
  iNoDynamicLights.WinLeft = 285;
  iNoDynamicLights.WinTop = 46;
  iNoDynamicLights.WinWidth = 99;
  AppendComponent(iNoDynamicLights, true);

  iProjectors = new class'DXRChoiceInfo';
  iProjectors.WinLeft = 285;
  iProjectors.WinTop = 82;
  iProjectors.WinWidth = 99;
  AppendComponent(iProjectors, true);

  iUseCompressedLightmaps  = new class'DXRChoiceInfo';
  iUseCompressedLightmaps.WinLeft = 285;
  iUseCompressedLightmaps.WinTop = 118;
  iUseCompressedLightmaps.WinWidth = 99;
  AppendComponent(iUseCompressedLightmaps, true);

  iSuperHighDetailActors = new class'DXRChoiceInfo';
  iSuperHighDetailActors.WinLeft = 285;
  iSuperHighDetailActors.WinTop = 154;
  iSuperHighDetailActors.WinWidth = 99;
  AppendComponent(iSuperHighDetailActors, true);

  iHighDetailActors = new class'DXRChoiceInfo';
  iHighDetailActors.WinLeft = 285;
  iHighDetailActors.WinTop = 190;
  iHighDetailActors.WinWidth = 99;
  AppendComponent(iHighDetailActors, true);

  iWeatherEffects = new class'DXRChoiceInfo';
  iWeatherEffects.WinLeft = 285;
  iWeatherEffects.WinTop = 226;
  iWeatherEffects.WinWidth = 99;
  AppendComponent(iWeatherEffects, true);

  iDetailTextures = new class'DXRChoiceInfo';
  iDetailTextures.WinLeft = 285;
  iDetailTextures.WinTop = 262;
  iDetailTextures.WinWidth = 99;
  AppendComponent(iDetailTextures, true);

  iDecoLayers = new class'DXRChoiceInfo';
  iDecoLayers.WinLeft = 285;
  iDecoLayers.WinTop = 298;
  iDecoLayers.WinWidth = 99;
  AppendComponent(iDecoLayers, true);

  iDecals = new class'DXRChoiceInfo';
  iDecals.WinLeft = 285;
  iDecals.WinTop = 334;
  iDecals.WinWidth = 99;
  AppendComponent(iDecals, true);

  iCoronas = new class'DXRChoiceInfo';
  iCoronas.WinLeft = 285;
  iCoronas.WinTop = 370;
  iCoronas.WinWidth = 99;
  AppendComponent(iCoronas, true);

  /*-----------------------------------------------------*/

  mNoDynamicLights = new class'MenuChoice_NoDynamicLights';
  mNoDynamicLights.WinLeft = 15;
  mNoDynamicLights.WinTop = 46;
  mNoDynamicLights.WinWidth = 244;
  AppendComponent(mNoDynamicLights, true);
  mNoDynamicLights.info = iNoDynamicLights;
  mNoDynamicLights.LoadSetting();
  mNoDynamicLights.UpdateInfoButton();


  mProjectors = new class'MenuChoice_Projectors';
  mProjectors.WinLeft = 15;
  mProjectors.WinTop = 82;
  mProjectors.WinWidth = 244;
  AppendComponent(mProjectors, true);
  mProjectors.info = iProjectors;
  mProjectors.LoadSetting();
  mProjectors.UpdateInfoButton();


  mUseCompressedLightmaps = new class'MenuChoice_UseCompressedLightmaps';
  mUseCompressedLightmaps.WinLeft = 15;
  mUseCompressedLightmaps.WinTop = 118;
  mUseCompressedLightmaps.WinWidth = 244;
  AppendComponent(mUseCompressedLightmaps, true);
  mUseCompressedLightmaps.info = iUseCompressedLightmaps;
  mUseCompressedLightmaps.LoadSetting();
  mUseCompressedLightmaps.UpdateInfoButton();


  mSuperHighDetailActors = new class'MenuChoice_SuperHighDetailActors';
  mSuperHighDetailActors.WinLeft = 15;
  mSuperHighDetailActors.WinTop = 154;
  mSuperHighDetailActors.WinWidth = 244;
  AppendComponent(mSuperHighDetailActors, true);
  mSuperHighDetailActors.info = iSuperHighDetailActors;
  mSuperHighDetailActors.LoadSetting();
  mSuperHighDetailActors.UpdateInfoButton();


  mHighDetailActors = new class'MenuChoice_HighDetailActors';
  mHighDetailActors.WinLeft = 15;
  mHighDetailActors.WinTop = 190;
  mHighDetailActors.WinWidth = 244;
  AppendComponent(mHighDetailActors, true);
  mHighDetailActors.info = iHighDetailActors;
  mHighDetailActors.LoadSetting();
  mHighDetailActors.UpdateInfoButton();


  mWeatherEffects = new class'MenuChoice_WeatherEffects';
  mWeatherEffects.WinLeft = 15;
  mWeatherEffects.WinTop = 226;
  mWeatherEffects.WinWidth = 244;
  AppendComponent(mWeatherEffects, true);
  mWeatherEffects.info = iWeatherEffects;
  mWeatherEffects.LoadSetting();
  mWeatherEffects.UpdateInfoButton();


  mDetailTextures = new class'MenuChoice_DetailTextures';
  mDetailTextures.WinLeft = 15;
  mDetailTextures.WinTop = 262;
  mDetailTextures.WinWidth = 244;
  AppendComponent(mDetailTextures, true);
  mDetailTextures.info = iDetailTextures;
  mDetailTextures.LoadSetting();
  mDetailTextures.UpdateInfoButton();


  mDecoLayers = new class'MenuChoice_DecoLayers';
  mDecoLayers.WinLeft = 15;
  mDecoLayers.WinTop = 298;
  mDecoLayers.WinWidth = 244;
  AppendComponent(mDecoLayers, true);
  mDecoLayers.info = iDecoLayers;
  mDecoLayers.LoadSetting();
  mDecoLayers.UpdateInfoButton();


  mDecals = new class'MenuChoice_Decals';
  mDecals.WinLeft = 15;
  mDecals.WinTop = 334;
  mDecals.WinWidth = 244;
  AppendComponent(mDecals, true);
  mDecals.info = iDecals;
  mDecals.LoadSetting();
  mDecals.UpdateInfoButton();


  mCoronas = new class'MenuChoice_Coronas';
  mCoronas.WinLeft = 15;
  mCoronas.WinTop = 370;
  mCoronas.WinWidth = 244;
  AppendComponent(mCoronas, true);
  mCoronas.info = iCoronas;
  mCoronas.LoadSetting();
  mCoronas.UpdateInfoButton();

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
    WinTitle="Performance/Graphics settings [page 1]"

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