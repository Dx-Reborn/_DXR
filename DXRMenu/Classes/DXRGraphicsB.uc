/*
    step=36
*/
class DXRGraphicsB extends DxWindowTemplate;

var localized string strOk, strDefault, strCancel;
var GUIButton btnOk, btnCancel, btnDefault;

var DXRChoiceInfo iCoronas, iUseTrilinear, iUseVSync, iUseTripleBuffering, iLowQualityTerrain;
var DXRChoiceInfo iLevelOfAnisotropy, iUseStencil, iDefaultTexMipBias, iDetailTexMipBias;

var MenuChoice_Coronas             mCoronas;
var MenuChoice_UseTrilinear        mUseTrilinear;
var MenuChoice_UseVSync            mUseVSync;
var MenuChoice_UseTripleBuffering  mUseTripleBuffering;
var MenuChoice_LowQualityTerrain   mLowQualityTerrain;
var MenuChoice_LevelOfAnisotropy   mLevelOfAnisotropy;
var MenuChoice_UseStencil          mUseStencil;
var MenuChoice_DefaultTexMipBias   mDefaultTexMipBias;
var MenuChoice_DetailTexMipBias    mDetailTexMipBias;
// var MenuChoice_Use16bitTextures    mUse16bitTextures; // useless


function CreateMyControls()
{
  SetSize(410, 400);

  // Information fields first, this is important, otherwise scary things will happen...
  iCoronas = new class'DXRChoiceInfo';
  iCoronas.WinLeft = 285;
  iCoronas.WinTop = 46;
  iCoronas.WinWidth = 99;
  AppendComponent(iCoronas, true);

  iUseTrilinear = new class'DXRChoiceInfo';
  iUseTrilinear.WinLeft = 285;
  iUseTrilinear.WinTop = 82;
  iUseTrilinear.WinWidth = 99;
  AppendComponent(iUseTrilinear, true);

  iUseVSync = new class'DXRChoiceInfo';
  iUseVSync.WinLeft = 285;
  iUseVSync.WinTop = 118;
  iUseVSync.WinWidth = 99;
  AppendComponent(iUseVSync, true);

  iUseTripleBuffering = new class'DXRChoiceInfo';
  iUseTripleBuffering.WinLeft = 285;
  iUseTripleBuffering.WinTop = 154;
  iUseTripleBuffering.WinWidth = 99;
  AppendComponent(iUseTripleBuffering, true);

  iLowQualityTerrain = new class'DXRChoiceInfo';
  iLowQualityTerrain.WinLeft = 285;
  iLowQualityTerrain.WinTop = 190;
  iLowQualityTerrain.WinWidth = 99;
  AppendComponent(iLowQualityTerrain, true);

  iLevelOfAnisotropy = new class'DXRChoiceInfo';
  iLevelOfAnisotropy.WinLeft = 285;
  iLevelOfAnisotropy.WinTop = 226;
  iLevelOfAnisotropy.WinWidth = 99;
  AppendComponent(iLevelOfAnisotropy, true);

  iUseStencil = new class'DXRChoiceInfo';
  iUseStencil.WinLeft = 285;
  iUseStencil.WinTop = 262;
  iUseStencil.WinWidth = 99;
  AppendComponent(iUseStencil, true);

  iDefaultTexMipBias = new class'DXRChoiceInfo';
  iDefaultTexMipBias.WinLeft = 285;
  iDefaultTexMipBias.WinTop = 298;
  iDefaultTexMipBias.WinWidth = 99;
  AppendComponent(iDefaultTexMipBias, true);

  iDetailTexMipBias = new class'DXRChoiceInfo';
  iDetailTexMipBias.WinLeft = 285;
  iDetailTexMipBias.WinTop = 334;
  iDetailTexMipBias.WinWidth = 99;
  AppendComponent(iDetailTexMipBias, true);



  /*----------------------------------------------------*/
  mCoronas = new class'MenuChoice_Coronas';
  mCoronas.WinLeft = 15;
  mCoronas.WinTop = 46;
  mCoronas.WinWidth = 244;
  AppendComponent(mCoronas, true);
  mCoronas.info = iCoronas;
  mCoronas.LoadSetting();
  mCoronas.UpdateInfoButton();

  mUseTrilinear = new class'MenuChoice_UseTrilinear';
  mUseTrilinear.WinLeft = 15;
  mUseTrilinear.WinTop = 82;
  mUseTrilinear.WinWidth = 244;
  AppendComponent(mUseTrilinear, true);
  mUseTrilinear.info = iUseTrilinear;
  mUseTrilinear.LoadSetting();
  mUseTrilinear.UpdateInfoButton();

  mUseVSync = new class'MenuChoice_UseVSync';
  mUseVSync.WinLeft = 15;
  mUseVSync.WinTop = 118;
  mUseVSync.WinWidth = 244;
  AppendComponent(mUseVSync, true);
  mUseVSync.info = iUseVSync;
  mUseVSync.LoadSetting();
  mUseVSync.UpdateInfoButton();

  mUseTripleBuffering = new class'MenuChoice_UseTripleBuffering';
  mUseTripleBuffering.WinLeft = 15;
  mUseTripleBuffering.WinTop = 154;
  mUseTripleBuffering.WinWidth = 244;
  AppendComponent(mUseTripleBuffering, true);
  mUseTripleBuffering.info = iUseTripleBuffering;
  mUseTripleBuffering.LoadSetting();
  mUseTripleBuffering.UpdateInfoButton();

  mLowQualityTerrain = new class'MenuChoice_LowQualityTerrain';
  mLowQualityTerrain.WinLeft = 15;
  mLowQualityTerrain.WinTop = 190;
  mLowQualityTerrain.WinWidth = 244;
  AppendComponent(mLowQualityTerrain, true);
  mLowQualityTerrain.info = iLowQualityTerrain;
  mLowQualityTerrain.LoadSetting();
  mLowQualityTerrain.UpdateInfoButton();

  mLevelOfAnisotropy = new class'MenuChoice_LevelOfAnisotropy';
  mLevelOfAnisotropy.WinLeft = 15;
  mLevelOfAnisotropy.WinTop = 226;
  mLevelOfAnisotropy.WinWidth = 244;
  AppendComponent(mLevelOfAnisotropy, true);
  mLevelOfAnisotropy.info = iLevelOfAnisotropy;
  mLevelOfAnisotropy.LoadSetting();
  mLevelOfAnisotropy.UpdateInfoButton();

  mUseStencil = new class'MenuChoice_UseStencil';
  mUseStencil.WinLeft = 15;
  mUseStencil.WinTop = 262;
  mUseStencil.WinWidth = 244;
  AppendComponent(mUseStencil, true);
  mUseStencil.info = iUseStencil;
  mUseStencil.LoadSetting();
  mUseStencil.UpdateInfoButton();

  mDefaultTexMipBias = new class'MenuChoice_DefaultTexMipBias';
  mDefaultTexMipBias.WinLeft = 15;
  mDefaultTexMipBias.WinTop = 298;
  mDefaultTexMipBias.WinWidth = 244;
  AppendComponent(mDefaultTexMipBias, true);
  mDefaultTexMipBias.info = iDefaultTexMipBias;
  mDefaultTexMipBias.LoadSetting();
  mDefaultTexMipBias.UpdateInfoButton();

  mDetailTexMipBias = new class'MenuChoice_DetailTexMipBias';
  mDetailTexMipBias.WinLeft = 15;
  mDetailTexMipBias.WinTop = 334;
  mDetailTexMipBias.WinWidth = 244;
  AppendComponent(mDetailTexMipBias, true);
  mDetailTexMipBias.info = iDetailTexMipBias;
  mDetailTexMipBias.LoadSetting();
  mDetailTexMipBias.UpdateInfoButton();


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

//  PlayerOwner().ConsoleCommand("FLUSH"); // Cleanup engine caches, so you will see changes immediately

  for (i=0;i<Controls.Length;i++)
  {
     if (controls[i].IsA('DXREnumButton'))
        DXREnumButton(controls[i]).SaveSetting();
  }
}

function CancelSettings()
{
  local int i;

  PlayerOwner().ConsoleCommand("FLUSH"); // Cleanup engine caches, so you will see changes immediately

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
    WinTitle="Performance/Graphics settings [page 3]"

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