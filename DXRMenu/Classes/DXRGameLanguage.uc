/*
  Game language
*/

class DXRGameLanguage extends DXRConfigurationDialog;

var GUIButton btnDefault, btnOK, btnCancel;
var DXRChoiceInfo iLangInfo;
var MenuChoice_GameLanguage mGameLang;

var localized string strAdditionalText;

function CreateMyControls()
{
  SetSize(150, 548);

  iLangInfo = new class'DXRChoiceInfo';
  iLangInfo.WinLeft = 285;
  iLangInfo.WinTop = 46;
  iLangInfo.WinWidth = 200;
  AppendComponent(iLangInfo, true);

  mGameLang = new class'MenuChoice_GameLanguage';
  mGameLang.WinLeft = 15;
  mGameLang.WinTop = 46;
  mGameLang.WinWidth = 244;
  AppendComponent(mGameLang, true);
  mGameLang.info = iLangInfo;
  mGameLang.LoadSetting();
  mGameLang.UpdateInfoButton();


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

// For testing!
function TestOnSelect(GUIContextMenu Sender, int ClickIndex)
{
   log("Clicked contextMenu "$sender$", item index = "$ClickIndex);
}



defaultproperties
{
    strAdditionalText="blah blah"
    WinTitle="Game language"

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

    Begin Object class=DXRContextMenu Name=cTestMenu
        ContextItems(0)="Test 0"
        ContextItems(1)="Test 1"
        ContextItems(2)="Test 1234"
        OnSelect=TestOnSelect
    End Object
    ContextMenu=cTestMenu
}

