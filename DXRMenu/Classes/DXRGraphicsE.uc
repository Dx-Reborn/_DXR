/*
Здесь будет четвертая страница настроек.
*/
class DXRGraphicsE extends DxWindowTemplate;

var localized string strOk, strDefault, strCancel;
var GUIButton btnOk, btnCancel, btnDefault;
/*
var DXRChoiceInfo iTextureDetailInterface, iTextureDetailLightmap, iTextureDetailPlayerSkin;
var DXRChoiceInfo iTextureDetailRenderMap, iTextureDetailTerrain, iTextureDetailWeaponSkin;
var DXRChoiceInfo iTextureDetailWorld, iDrawDistanceLOD, iUseCubemaps;

var MenuChoice_TextureDetailInterface  mTextureDetailInterface;
var MenuChoice_TextureDetailLightmap   mTextureDetailLightmap;
var MenuChoice_TextureDetailPlayerSkin mTextureDetailPlayerSkin;
var MenuChoice_TextureDetailRenderMap  mTextureDetailRenderMap;
var MenuChoice_TextureDetailTerrain    mTextureDetailTerrain;
var MenuChoice_TextureDetailWeaponSkin mTextureDetailWeaponSkin;
var MenuChoice_TextureDetailWorld      mTextureDetailWorld;
var MenuChoice_DrawDistanceLOD         mDrawDistanceLOD;
var MenuChoice_UseCubemaps             mUseCubemaps;
*/
function CreateMyControls()
{
  SetSize(410, 400);

  // Information fields first, this is important, otherwise scary things will happen...
/*  iTextureDetailInterface = new class'DXRChoiceInfo';
  iTextureDetailInterface.WinLeft = 285;
  iTextureDetailInterface.WinTop = 46;
  iTextureDetailInterface.WinWidth = 99;
  AppendComponent(iTextureDetailInterface, true);

  iTextureDetailLightmap = new class'DXRChoiceInfo';
  iTextureDetailLightmap.WinLeft = 285;
  iTextureDetailLightmap.WinTop = 82;
  iTextureDetailLightmap.WinWidth = 99;
  AppendComponent(iTextureDetailLightmap, true);

  iTextureDetailPlayerSkin  = new class'DXRChoiceInfo';
  iTextureDetailPlayerSkin.WinLeft = 285;
  iTextureDetailPlayerSkin.WinTop = 118;
  iTextureDetailPlayerSkin.WinWidth = 99;
  AppendComponent(iTextureDetailPlayerSkin, true);

  iTextureDetailRenderMap = new class'DXRChoiceInfo';
  iTextureDetailRenderMap.WinLeft = 285;
  iTextureDetailRenderMap.WinTop = 154;
  iTextureDetailRenderMap.WinWidth = 99;
  AppendComponent(iTextureDetailRenderMap, true);

  iTextureDetailTerrain = new class'DXRChoiceInfo';
  iTextureDetailTerrain.WinLeft = 285;
  iTextureDetailTerrain.WinTop = 190;
  iTextureDetailTerrain.WinWidth = 99;
  AppendComponent(iTextureDetailTerrain, true);

  iTextureDetailWeaponSkin = new class'DXRChoiceInfo';
  iTextureDetailWeaponSkin.WinLeft = 285;
  iTextureDetailWeaponSkin.WinTop = 226;
  iTextureDetailWeaponSkin.WinWidth = 99;
  AppendComponent(iTextureDetailWeaponSkin, true);

  iTextureDetailWorld = new class'DXRChoiceInfo';
  iTextureDetailWorld.WinLeft = 285;
  iTextureDetailWorld.WinTop = 262;
  iTextureDetailWorld.WinWidth = 99;
  AppendComponent(iTextureDetailWorld, true);

  iDrawDistanceLOD = new class'DXRChoiceInfo';
  iDrawDistanceLOD.WinLeft = 285;
  iDrawDistanceLOD.WinTop = 298;
  iDrawDistanceLOD.WinWidth = 99;
  AppendComponent(iDrawDistanceLOD, true);

  iUseCubemaps = new class'DXRChoiceInfo';
  iUseCubemaps.WinLeft = 285;
  iUseCubemaps.WinTop = 334;
  iUseCubemaps.WinWidth = 99;
  AppendComponent(iUseCubemaps, true);


  mTextureDetailInterface = new class'MenuChoice_TextureDetailInterface';
  mTextureDetailInterface.WinLeft = 15;
  mTextureDetailInterface.WinTop = 46;
  mTextureDetailInterface.WinWidth = 244;
  AppendComponent(mTextureDetailInterface, true);
  mTextureDetailInterface.info = iTextureDetailInterface;
  mTextureDetailInterface.LoadSetting();
  mTextureDetailInterface.UpdateInfoButton();


  mTextureDetailLightmap = new class'MenuChoice_TextureDetailLightmap';
  mTextureDetailLightmap.WinLeft = 15;
  mTextureDetailLightmap.WinTop = 82;
  mTextureDetailLightmap.WinWidth = 244;
  AppendComponent(mTextureDetailLightmap, true);
  mTextureDetailLightmap.info = iTextureDetailLightmap;
  mTextureDetailLightmap.LoadSetting();
  mTextureDetailLightmap.UpdateInfoButton();


  mTextureDetailPlayerSkin = new class'MenuChoice_TextureDetailPlayerSkin';
  mTextureDetailPlayerSkin.WinLeft = 15;
  mTextureDetailPlayerSkin.WinTop = 118;
  mTextureDetailPlayerSkin.WinWidth = 244;
  AppendComponent(mTextureDetailPlayerSkin, true);
  mTextureDetailPlayerSkin.info = iTextureDetailPlayerSkin;
  mTextureDetailPlayerSkin.LoadSetting();
  mTextureDetailPlayerSkin.UpdateInfoButton();


  mTextureDetailRenderMap = new class'MenuChoice_TextureDetailRenderMap';
  mTextureDetailRenderMap.WinLeft = 15;
  mTextureDetailRenderMap.WinTop = 154;
  mTextureDetailRenderMap.WinWidth = 244;
  AppendComponent(mTextureDetailRenderMap, true);
  mTextureDetailRenderMap.info = iTextureDetailRenderMap;
  mTextureDetailRenderMap.LoadSetting();
  mTextureDetailRenderMap.UpdateInfoButton();


  mTextureDetailTerrain = new class'MenuChoice_TextureDetailTerrain';
  mTextureDetailTerrain.WinLeft = 15;
  mTextureDetailTerrain.WinTop = 190;
  mTextureDetailTerrain.WinWidth = 244;
  AppendComponent(mTextureDetailTerrain, true);
  mTextureDetailTerrain.info = iTextureDetailTerrain;
  mTextureDetailTerrain.LoadSetting();
  mTextureDetailTerrain.UpdateInfoButton();


  mTextureDetailWeaponSkin = new class'MenuChoice_TextureDetailWeaponSkin';
  mTextureDetailWeaponSkin.WinLeft = 15;
  mTextureDetailWeaponSkin.WinTop = 226;
  mTextureDetailWeaponSkin.WinWidth = 244;
  AppendComponent(mTextureDetailWeaponSkin, true);
  mTextureDetailWeaponSkin.info = iTextureDetailWeaponSkin;
  mTextureDetailWeaponSkin.LoadSetting();
  mTextureDetailWeaponSkin.UpdateInfoButton();


  mTextureDetailWorld = new class'MenuChoice_TextureDetailWorld';
  mTextureDetailWorld.WinLeft = 15;
  mTextureDetailWorld.WinTop = 262;
  mTextureDetailWorld.WinWidth = 244;
  AppendComponent(mTextureDetailWorld, true);
  mTextureDetailWorld.info = iTextureDetailWorld;
  mTextureDetailWorld.LoadSetting();
  mTextureDetailWorld.UpdateInfoButton();


  mDrawDistanceLOD = new class'MenuChoice_DrawDistanceLOD';
  mDrawDistanceLOD.WinLeft = 15;
  mDrawDistanceLOD.WinTop = 298;
  mDrawDistanceLOD.WinWidth = 244;
  AppendComponent(mDrawDistanceLOD, true);
  mDrawDistanceLOD.info = iDrawDistanceLOD;
  mDrawDistanceLOD.LoadSetting();
  mDrawDistanceLOD.UpdateInfoButton();


  mUseCubemaps = new class'MenuChoice_UseCubemaps';
  mUseCubemaps.WinLeft = 15;
  mUseCubemaps.WinTop = 334;
  mUseCubemaps.WinWidth = 244;
  AppendComponent(mUseCubemaps, true);
  mUseCubemaps.info = iUseCubemaps;
  mUseCubemaps.LoadSetting();
  mUseCubemaps.UpdateInfoButton();
*/

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
    WinTitle="Setup Shadows"

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