/*

*/

class DXRColors extends DXRConfigurationDialog;

var GUIButton btnOK, btnCancel, btnDefault;

var MenuChoice_MenuTranslucency      mMenuTranslucency;
var MenuChoice_MenuColor             mMenuColor;
var MenuChoice_HUDBordersVisible     mHUDBordersVisible;
var MenuChoice_HUDBorderTranslucency mHUDBorderTranslucency;
var MenuChoice_HUDTranslucency       mHUDTranslucency;
var MenuChoice_HUDColor              mHUDColor;

var DXRChoiceInfo iMenuTranslucency,iMenuColor,iHUDBordersVisible,iHUDBorderTranslucency,iHUDTranslucency,iHUDColor;

var() float ExamplePosX, examplePosY;
var() float ExampleFramePosX, exampleFramePosY;

function CreateMyControls()
{
  SetSize(308, 632);

  iMenuTranslucency = new class'DXRChoiceInfo';
  iMenuTranslucency.WinLeft = 285;
  iMenuTranslucency.WinTop = 46;
  iMenuTranslucency.WinWidth = 99;
  AppendComponent(iMenuTranslucency, true);

  iMenuColor = new class'DXRChoiceInfo';
  iMenuColor.WinLeft = 285;
  iMenuColor.WinTop = 82;
  iMenuColor.WinWidth = 99;
  AppendComponent(iMenuColor, true);

  iHUDBordersVisible = new class'DXRChoiceInfo';
  iHUDBordersVisible.WinLeft = 285;
  iHUDBordersVisible.WinTop = 118;
  iHUDBordersVisible.WinWidth = 99;
  AppendComponent(iHUDBordersVisible, true);

  iHUDBorderTranslucency = new class'DXRChoiceInfo';
  iHUDBorderTranslucency.WinLeft = 285;
  iHUDBorderTranslucency.WinTop = 154;
  iHUDBorderTranslucency.WinWidth = 99;
  AppendComponent(iHUDBorderTranslucency, true);

  iHUDTranslucency = new class'DXRChoiceInfo';
  iHUDTranslucency.WinLeft = 285;
  iHUDTranslucency.WinTop = 190;
  iHUDTranslucency.WinWidth = 99;
  AppendComponent(iHUDTranslucency, true);

  iHUDColor = new class'DXRChoiceInfo';
  iHUDColor.WinLeft = 285;
  iHUDColor.WinTop = 226;
  iHUDColor.WinWidth = 99;
  AppendComponent(iHUDColor, true);
  /*-------------------------------------------------------*/
  mMenuTranslucency = new class'MenuChoice_MenuTranslucency';
  mMenuTranslucency.WinLeft = 15;
  mMenuTranslucency.WinTop = 46;
  mMenuTranslucency.WinWidth = 244;
  AppendComponent(mMenuTranslucency, true);
  mMenuTranslucency.info = iMenuTranslucency;
  mMenuTranslucency.LoadSetting();
  mMenuTranslucency.UpdateInfoButton();

  mMenuColor = new class'MenuChoice_MenuColor';
  mMenuColor.WinLeft = 15;
  mMenuColor.WinTop = 82;
  mMenuColor.WinWidth = 244;
  AppendComponent(mMenuColor, true);
  mMenuColor.info = iMenuColor;
  mMenuColor.LoadSetting();
  mMenuColor.UpdateInfoButton();

  mHUDBordersVisible = new class'MenuChoice_HUDBordersVisible';
  mHUDBordersVisible.WinLeft = 15;
  mHUDBordersVisible.WinTop = 118;
  mHUDBordersVisible.WinWidth = 244;
  AppendComponent(mHUDBordersVisible, true);
  mHUDBordersVisible.info = iHUDBordersVisible;
  mHUDBordersVisible.LoadSetting();
  mHUDBordersVisible.UpdateInfoButton();

  mHUDBorderTranslucency = new class'MenuChoice_HUDBorderTranslucency';
  mHUDBorderTranslucency.WinLeft = 15;
  mHUDBorderTranslucency.WinTop = 154;
  mHUDBorderTranslucency.WinWidth = 244;
  AppendComponent(mHUDBorderTranslucency, true);
  mHUDBorderTranslucency.info = iHUDBorderTranslucency;
  mHUDBorderTranslucency.LoadSetting();
  mHUDBorderTranslucency.UpdateInfoButton();

  mHUDTranslucency = new class'MenuChoice_HUDTranslucency';
  mHUDTranslucency.WinLeft = 15;
  mHUDTranslucency.WinTop = 190;
  mHUDTranslucency.WinWidth = 244;
  AppendComponent(mHUDTranslucency, true);
  mHUDTranslucency.info = iHUDTranslucency;
  mHUDTranslucency.LoadSetting();
  mHUDTranslucency.UpdateInfoButton();

  mHUDColor = new class'MenuChoice_HUDColor';
  mHUDColor.WinLeft = 15;
  mHUDColor.WinTop = 226;
  mHUDColor.WinWidth = 244;
  AppendComponent(mHUDColor, true);
  mHUDColor.info = iHUDColor;
  mHUDColor.LoadSetting();
  mHUDColor.UpdateInfoButton();

  /*-----------------------------*/
  btnDefault = new class'GUIButton';
  btnDefault.OnClick = InternalOnClick;
  btnDefault.fontScale = FNS_Small;
  btnDefault.StyleName="STY_DXR_MediumButton";
  btnDefault.Caption = strDefault;
  btnDefault.WinHeight = 21;
  btnDefault.WinWidth = 180;
  btnDefault.WinLeft = 9;
  btnDefault.WinTop = 321;
    AppendComponent(btnDefault, true);

  btnOK = new class'GUIButton';
  btnOK.OnClick=InternalOnClick;
  btnOK.fontScale = FNS_Small;
  btnOK.StyleName="STY_DXR_MediumButton";
  btnOK.Caption = strOK;
  btnOK.WinHeight = 21;
  btnOK.WinWidth = 100;
  btnOK.WinLeft = 526;
  btnOK.WinTop = 321;
    AppendComponent(btnOK, true);

  btnCancel = new class'GUIButton';
  btnCancel.OnClick=InternalOnClick;
  btnCancel.fontScale = FNS_Small;
  btnCancel.StyleName="STY_DXR_MediumButton";
  btnCancel.Caption = strCancel;
  btnCancel.WinHeight = 21;
  btnCancel.WinWidth = 100;
  btnCancel.WinLeft = 425;
  btnCancel.WinTop = 321;
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

function PaintOnBG(Canvas u)
{
  local float x,y;

  x = ActualLeft(); y = ActualTop();

  Super.PaintOnBG(u);


  if (DeusExPlayer(playerOwner().pawn).bHUDBordersVisible)
  {
    if (DeusExPlayer(playerOwner().pawn).bHUDBordersTranslucent)
    u.Style = EMenuRenderStyle.MSTY_Translucent;
    else
    u.Style = EMenuRenderStyle.MSTY_Alpha;

    u.DrawColor = class'DXR_HUD'.static.GetInfoLinkFrame(gl.HudThemeIndex);
    u.SetPos(x + ExampleFramePosX,y + ExampleFramePosY);
    u.DrawIcon(texture'MenuColorHUDBorders',1);
  }

  if (DeusExPlayer(playerOwner().pawn).bHUDBackgroundTranslucent)
  u.Style = EMenuRenderStyle.MSTY_Translucent;
  else
  u.Style = EMenuRenderStyle.MSTY_Alpha;
  u.DrawColor = class'DXR_HUD'.static.GetInfoLinkBG(gl.HudThemeIndex);
  u.SetPos(x + ExamplePosX,y + ExamplePosY);
  u.DrawIcon(texture'DXR_HUDExample',1);

  u.DrawColor = class'DXR_HUD'.static.GetInfoLinkTitles(gl.HudThemeIndex);
  u.font = font'DxFonts.HR_9';
  u.SetPos(x + ExamplePosX + 28,y + ExamplePosY + 24);
  u.DrawText("Infolink title");

  u.DrawColor = class'DXR_HUD'.static.GetInfoLinkText(gl.HudThemeIndex);
  u.font = font'DxFonts.MSS_8';
  u.SetPos(x + ExamplePosX + 26,y + ExamplePosY + 40);
  u.DrawText("HUD Message text");

  u.font = font'DxFonts.MSS_7';
  u.SetPos(x + ExamplePosX + 26,y + ExamplePosY + 55);
  u.DrawText("Infolink as an example. Other");
  u.SetPos(x + ExamplePosX + 26,y + ExamplePosY + 65);
  u.DrawText("HUD parts may have different");
  u.SetPos(x + ExamplePosX + 26,y + ExamplePosY + 75);
  u.DrawText("colors, since HUD themes for");
  u.SetPos(x + ExamplePosX + 26,y + ExamplePosY + 85);
  u.DrawText("DXR have color parameters");
  u.SetPos(x + ExamplePosX + 26,y + ExamplePosY + 95);
  u.DrawText("for different HUD parts.");



  
}

defaultproperties
{
  WinTitle="Colors"

        leftEdgeCorrectorX=4
        leftEdgeCorrectorY=0
        leftEdgeHeight=342

        RightEdgeCorrectorX=628
        RightEdgeCorrectorY=20
        RightEdgeHeight=313

        TopEdgeCorrectorX=546
        TopEdgeCorrectorY=16
    TopEdgeLength=80

    TopRightCornerX=626
    TopRightCornerY=16

    ExamplePosX=403
    ExamplePosY=42

    ExampleFramePosX=403
    ExampleFramePosY=42



    Begin Object Class=FloatingImage Name=FloatingFrameBackground
        Image=Texture'DXR_MenuColor'
        ImageRenderStyle=MSTY_Translucent
        ImageStyle=ISTY_Tiled
        ImageColor=(R=255,G=255,B=255,A=255)
        DropShadow=None
        WinWidth=622
        WinHeight=302
        WinLeft=8
        WinTop=20
        RenderWeight=0.000003
        bBoundToParent=True
        bScaleToParent=True
        OnRendered=PaintOnBG
    End Object
    i_FrameBG=FloatingFrameBackground
}