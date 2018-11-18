/**/

class DXRMenuSound extends DxWindowTemplate;

/* Вероятные настройки (отфильтрованные 12, остальные вероятно нам не нужны)
UseEAX=False            1
Use3DSound=False        2
CompatibilityMode=False 3
UsePrecache=True        4
ReverseStereo=False     5
LowQualitySound=False   6
Channels=32                1
MusicVolume=0.180000       2
AmbientVolume=0.500000     3
SoundVolume=1.000000       4
VoiceVolume=4.000000       5
DopplerFactor=1.000000     6
*/

var float fMusicVolume, fAmbientSoundVolume, fSoundVolume, fVoiceVolume, fDopplerFactor;
var bool bUseEAX, bUse3DSound, bCompatMode, bUsePreCache, bReverseStereo, bLowSoundQ, bDefaultDriver;
var int iNumChannels;

var DXRSlider sNumChannels, sMusicVolume, sAmbientSoundVolume, sVoiceVolume, sDopplerFactor, sSoundVolume;
var DXRChoiceInfo cNumChannels, cMusicVolume, cAmbientSoundVolume, cVoiceVolume, cDopplerFactor, cSoundVolume;
var DXRChoiceInfo cCompatMode, cUse3DSound, cUseEAX, cReverseStereo, cDefaultDriver, cLowSoundQ, cUsePreCache;

var GUIButton btnOK, btnDefault, btnCancel;
var localized string strOK, strCancel, strDefault;

var MenuChoice_EffectsChannels mEffectsChannels;
var MenuChoice_SoundVolume mSoundVolume;
var MenuChoice_MusicVolume mMusicVolume;
var MenuChoice_AmbientVolume mAmbientVolume;
var MenuChoice_DopplerFactor mDopplerFactor;
var MenuChoice_VoiceVolume mVoiceVolume;

var MenuChoice_ReverseStereo mReverseStereo;
var MenuChoice_Use3DSound mUse3DSound;
var MenuChoice_LowSoundQ mLowSoundQ;
var MenuChoice_DefaultSoundDriver mDefaultSoundDriver;
var MenuChoice_SoundCompatMode mSoundCompatMode;
var MenuChoice_UseEAX mUseEAX;
var MenuChoice_SoundUsePreCache mSoundUsePreCache;

var transient bool bRestartSoundSys; // changed to true when required by some options.

function CreateMyControls()
{
  cMusicVolume = new class'DXRChoiceInfo';
  cMusicVolume.WinLeft = 469;
  cMusicVolume.WinTop = 46;
  cMusicVolume.WinWidth = 60;
  AppendComponent(cMusicVolume, true);

  cAmbientSoundVolume = new class'DXRChoiceInfo';
  cAmbientSoundVolume.WinLeft = 469;
  cAmbientSoundVolume.WinTop = 82;
  cAmbientSoundVolume.WinWidth = 60;
  AppendComponent(cAmbientSoundVolume, true);

  cSoundVolume = new class'DXRChoiceInfo';
  cSoundVolume.WinLeft = 469;
  cSoundVolume.WinTop = 118;
  cSoundVolume.WinWidth = 60;
  AppendComponent(cSoundVolume, true);

  cVoiceVolume = new class'DXRChoiceInfo';
  cVoiceVolume.WinLeft = 469;
  cVoiceVolume.WinTop = 154;
  cVoiceVolume.WinWidth = 60;
  AppendComponent(cVoiceVolume, true);

  cDopplerFactor = new class'DXRChoiceInfo';
  cDopplerFactor.WinLeft = 469;
  cDopplerFactor.WinTop = 190;
  cDopplerFactor.WinWidth = 60;
  AppendComponent(cDopplerFactor, true);

  cNumChannels = new class'DXRChoiceInfo';
  cNumChannels.WinLeft = 469;
  cNumChannels.WinTop = 226;
  cNumChannels.WinWidth = 60;
  AppendComponent(cNumChannels, true);

/*------------------------------------------------------------------------------------*/

  sMusicVolume = new class'DXRSlider';
  sMusicVolume.WinLeft = 289;
  sMusicVolume.WinTop = 46;
  AppendComponent(sMusicVolume, true);

  sAmbientSoundVolume = new class'DXRSlider';
  sAmbientSoundVolume.WinLeft = 289;
  sAmbientSoundVolume.WinTop = 82;
  AppendComponent(sAmbientSoundVolume, true);

  sSoundVolume = new class'DXRSlider';
  sSoundVolume.WinLeft = 289;
  sSoundVolume.WinTop = 118;
  AppendComponent(sSoundVolume, true);

  sVoiceVolume = new class'DXRSlider';
  sVoiceVolume.WinLeft = 289;//68;
  sVoiceVolume.WinTop = 154;
  AppendComponent(sVoiceVolume, true);

  sDopplerFactor = new class'DXRSlider';
  sDopplerFactor.WinLeft = 289;
  sDopplerFactor.WinTop = 190;
  AppendComponent(sDopplerFactor, true);

  sNumChannels = new class'DXRSlider';
  sNumChannels.WinLeft = 289;
  sNumChannels.WinTop = 226;
  AppendComponent(sNumChannels, true);

  mEffectsChannels = new class'MenuChoice_EffectsChannels';
  mEffectsChannels.WinLeft = 15;
  mEffectsChannels.WinTop = 227;
  mEffectsChannels.WinWidth = 244;
  AppendComponent(mEffectsChannels, true);
  mEffectsChannels.btnSlider = sNumChannels;
  mEffectsChannels.info = cNumChannels;
  mEffectsChannels.InitSlider();

  mSoundVolume = new class'MenuChoice_SoundVolume';
  mSoundVolume.WinLeft = 15;
  mSoundVolume.WinTop = 118;
  mSoundVolume.WinWidth = 244;
  AppendComponent(mSoundVolume, true);
  mSoundVolume.btnSlider = sSoundVolume;
  mSoundVolume.info = cSoundVolume;
  mSoundVolume.InitSlider();

  mMusicVolume = new class'MenuChoice_MusicVolume';
  mMusicVolume.WinLeft = 15;
  mMusicVolume.WinTop = 46;
  mMusicVolume.WinWidth = 244;
  AppendComponent(mMusicVolume, true);
  mMusicVolume.btnSlider = sMusicVolume;
  mMusicVolume.info = cMusicVolume;
  mMusicVolume.InitSlider();

  mAmbientVolume = new class'MenuChoice_AmbientVolume';
  mAmbientVolume.WinLeft = 15;
  mAmbientVolume.WinTop = 82;
  mAmbientVolume.WinWidth = 244;
  AppendComponent(mAmbientVolume, true);
  mAmbientVolume.btnSlider = sAmbientSoundVolume;
  mAmbientVolume.info = cAmbientSoundVolume;
  mAmbientVolume.InitSlider();

  mDopplerFactor = new class'MenuChoice_DopplerFactor';
  mDopplerFactor.WinLeft = 15;
  mDopplerFactor.WinTop = 190;
  mDopplerFactor.WinWidth = 244;
  AppendComponent(mDopplerFactor, true);
  mDopplerFactor.btnSlider = sDopplerFactor;
  mDopplerFactor.info = cDopplerFactor;
  mDopplerFactor.InitSlider();

  mVoiceVolume = new class'MenuChoice_VoiceVolume';
  mVoiceVolume.WinLeft = 15;
  mVoiceVolume.WinTop = 154;
  mVoiceVolume.WinWidth = 244;
  AppendComponent(mVoiceVolume, true);
  mVoiceVolume.btnSlider = sVoiceVolume;
  mVoiceVolume.info = cVoiceVolume;
  mVoiceVolume.InitSlider();
  /*------------------------------------------------------------------------------------------------*/

  cCompatMode = new class'DXRChoiceInfo';
  cCompatMode.WinLeft = 285;//68;
  cCompatMode.WinTop = 262;
  cCompatMode.WinWidth = 83;
  AppendComponent(cCompatMode, true);

  cUse3DSound = new class'DXRChoiceInfo';
  cUse3DSound.WinLeft = 285;//68;
  cUse3DSound.WinTop = 298;
  cUse3DSound.WinWidth = 83;
  AppendComponent(cUse3DSound, true);

  cUseEAX = new class'DXRChoiceInfo';
  cUseEAX.WinLeft = 285;//68;
  cUseEAX.WinTop = 334;
  cUseEAX.WinWidth = 83;
  AppendComponent(cUseEAX, true);

  cReverseStereo = new class'DXRChoiceInfo';
  cReverseStereo.WinLeft = 285;//68;
  cReverseStereo.WinTop = 370;
  cReverseStereo.WinWidth = 83;
  AppendComponent(cReverseStereo, true);

  cDefaultDriver = new class'DXRChoiceInfo';
  cDefaultDriver.WinLeft = 285;//68;
  cDefaultDriver.WinTop = 406;
  cDefaultDriver.WinWidth = 83;
  AppendComponent(cDefaultDriver, true);

  cLowSoundQ = new class'DXRChoiceInfo';
  cLowSoundQ.WinLeft = 285;//68;
  cLowSoundQ.WinTop = 442;
  cLowSoundQ.WinWidth = 83;
  AppendComponent(cLowSoundQ, true);

  cUsePreCache = new class'DXRChoiceInfo';
  cUsePreCache.WinLeft = 285;//68;
  cUsePreCache.WinTop = 478;
  cUsePreCache.WinWidth = 83;
  AppendComponent(cUsePreCache, true);
/*-------------------------------------------------------*/

  mReverseStereo = new class'MenuChoice_ReverseStereo';
  mReverseStereo.WinLeft = 15;
  mReverseStereo.WinTop = 370;
  mReverseStereo.WinWidth = 244;
  AppendComponent(mReverseStereo, true);
  mReverseStereo.info = cReverseStereo;
  mReverseStereo.LoadSetting();
  mReverseStereo.UpdateInfoButton();

  mUse3DSound = new class'MenuChoice_Use3DSound';
  mUse3DSound.WinLeft = 15;
  mUse3DSound.WinTop = 298;
  mUse3DSound.WinWidth = 244;
  AppendComponent(mUse3DSound, true);
  mUse3DSound.info = cUse3DSound;
  mUse3DSound.LoadSetting();
  mUse3DSound.UpdateInfoButton();

  mLowSoundQ = new class'MenuChoice_LowSoundQ';
  mLowSoundQ.WinLeft = 15;
  mLowSoundQ.WinTop = 442;
  mLowSoundQ.WinWidth = 244;
  AppendComponent(mLowSoundQ, true);
  mLowSoundQ.info = cLowSoundQ;
  mLowSoundQ.LoadSetting();
  mLowSoundQ.UpdateInfoButton();

  mDefaultSoundDriver = new class'MenuChoice_DefaultSoundDriver';
  mDefaultSoundDriver.WinLeft = 15;
  mDefaultSoundDriver.WinTop = 406;
  mDefaultSoundDriver.WinWidth = 244;
  AppendComponent(mDefaultSoundDriver, true);
  mDefaultSoundDriver.info = cDefaultDriver;
  mDefaultSoundDriver.LoadSetting();
  mDefaultSoundDriver.UpdateInfoButton();

  mSoundCompatMode = new class'MenuChoice_SoundCompatMode';
  mSoundCompatMode.WinLeft = 15;
  mSoundCompatMode.WinTop = 262;
  mSoundCompatMode.WinWidth = 244;
  AppendComponent(mSoundCompatMode, true);
  mSoundCompatMode.info = cCompatMode;
  mSoundCompatMode.LoadSetting();
  mSoundCompatMode.UpdateInfoButton();

  mUseEAX = new class'MenuChoice_UseEAX';
  mUseEAX.WinLeft = 15;
  mUseEAX.WinTop = 334;
  mUseEAX.WinWidth = 244;
  AppendComponent(mUseEAX, true);
  mUseEAX.info = cUseEAX;
  mUseEAX.LoadSetting();
  mUseEAX.UpdateInfoButton();

  mSoundUsePreCache = new class'MenuChoice_SoundUsePreCache';
  mSoundUsePreCache.WinLeft = 15;
  mSoundUsePreCache.WinTop = 478;
  mSoundUsePreCache.WinWidth = 244;
  AppendComponent(mSoundUsePreCache, true);
  mSoundUsePreCache.info = cUsePreCache;
  mSoundUsePreCache.LoadSetting();
  mSoundUsePreCache.UpdateInfoButton();

  /*---------------------------------------------------*/

  btnDefault = new class'GUIButton';
  btnDefault.OnClick=InternalOnClick;
  btnDefault.fontScale = FNS_Small;
  btnDefault.StyleName="STY_DXR_MediumButton";
  btnDefault.Caption = strDefault;
  btnDefault.WinHeight = 21;
  btnDefault.WinWidth = 180;
  btnDefault.WinLeft = 9;
  btnDefault.WinTop = 530;
	AppendComponent(btnDefault, true);

  btnOK = new class'GUIButton';
  btnOK.OnClick=InternalOnClick;
  btnOK.fontScale = FNS_Small;
  btnOK.StyleName="STY_DXR_MediumButton";
  btnOK.Caption = strOK;
  btnOK.WinHeight = 21;
  btnOK.WinWidth = 100;
  btnOK.WinLeft = 443;
  btnOK.WinTop = 530;
	AppendComponent(btnOK, true);

  btnCancel = new class'GUIButton';
  btnCancel.OnClick=InternalOnClick;
  btnCancel.fontScale = FNS_Small;
  btnCancel.StyleName="STY_DXR_MediumButton";
  btnCancel.Caption = strCancel;
  btnCancel.WinHeight = 21;
  btnCancel.WinWidth = 100;
  btnCancel.WinLeft = 341;
  btnCancel.WinTop = 530;
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
     {
        DXREnumButton(controls[i]).bSavingChanges = true;
        DXREnumButton(controls[i]).SaveSetting();
     }
  }
  if (bRestartSoundSys)
  {
      PlayerOwner().ConsoleCommand("SOUND_REBOOT");

      if (PlayerOwner().Level.Song != "" && PlayerOwner().Level.Song != "None") // Restart music if required
          PlayerOwner().ClientSetMusic(PlayerOwner().Level.Song, MTRAN_Instant);
  }
}

function CancelSettings()
{
  local int i;

  for (i=0;i<Controls.Length;i++)
  {
     if (controls[i].IsA('DXREnumButton'))
     {
        DXREnumButton(controls[i]).CancelSetting();
     }
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
  WinTitle="Sound settings"
  strOK="OK"
  strCancel="Cancel"
  strDefault="Reset to defaults"

		DefaultHeight=412
		DefaultWidth=548

		MaxPageHeight=412
		MaxPageWidth=548
		MinPageHeight=412
		MinPageWidth=548

		leftEdgeCorrectorX=4
		leftEdgeCorrectorY=0
		leftEdgeHeight=551

		RightEdgeCorrectorX=545
		RightEdgeCorrectorY=20
		RightEdgeHeight=524

		TopEdgeCorrectorX=442
		TopEdgeCorrectorY=16
    TopEdgeLength=100

    TopRightCornerX=542
    TopRightCornerY=16

	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Texture'DXR_MenuSoundBackground'
		ImageRenderStyle=MSTY_Translucent
		ImageStyle=ISTY_Tiled
		ImageColor=(R=255,G=255,B=255,A=255)
		DropShadow=None
		WinWidth=540
		WinHeight=512
		WinLeft=8
		WinTop=20
		RenderWeight=0.000003
		bBoundToParent=True
		bScaleToParent=True
						OnRendered=PaintOnBG
	End Object
	i_FrameBG=FloatingFrameBackground
}
