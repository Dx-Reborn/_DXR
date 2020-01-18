/* Выбор сложности игры */
class DXRCombatDifficultyChoice extends DxWindowTemplate;

var editconst float selectedDifficulty;
var GUIButton bEasy, bMedium, bHard, bRealistic, bBack;
var localized string strEasy, strMedium, strHard, strRealistic, strBack;


// ToDo: нарисовать основу окна и выставить кнопки 
function CreateMyControls()
{
  bEasy = new(none) class'GUIButton';
  bEasy.OnClick=InternalOnClick;
  bEasy.RenderWeight = 1.0;
  bEasy.StyleName="STY_DXR_DeusExRectButton";
  bEasy.Caption = strEasy;
  bEasy.WinHeight = 32;
  bEasy.WinWidth = 243;
   bEasy.WinLeft = 16;
   bEasy.WinTop = 33;
    AppendComponent(bEasy, true);

  bMedium = new(none) class'GUIButton';
  bMedium.OnClick=InternalOnClick;
  bMedium.RenderWeight = 1.0;
  bMedium.StyleName="STY_DXR_DeusExRectButton";
  bMedium.Caption = strMedium;
  bMedium.WinHeight = 32;
  bMedium.WinWidth = 243;
   bMedium.WinLeft = 16;
   bMedium.WinTop = 69;
    AppendComponent(bMedium, true);

  bHard = new(none) class'GUIButton';
  bHard.OnClick=InternalOnClick;
  bHard.RenderWeight = 1.0;
  bHard.StyleName="STY_DXR_DeusExRectButton";
  bHard.Caption = strHard;
  bHard.WinHeight = 32;
  bHard.WinWidth = 243;
   bHard.WinLeft = 16;
   bHard.WinTop = 105;
    AppendComponent(bHard, true);

  bRealistic = new(none) class'GUIButton';
  bRealistic.OnClick=InternalOnClick;
  bRealistic.RenderWeight = 1.0;
  bRealistic.StyleName="STY_DXR_DeusExRectButton";
  bRealistic.Caption = strRealistic;
  bRealistic.WinHeight = 32;
  bRealistic.WinWidth = 243;
   bRealistic.WinLeft = 16;
   bRealistic.WinTop = 141;
    AppendComponent(bRealistic, true);

    // Назад в Главное Меню
  bBack = new(none) class'GUIButton';
  bBack.OnClick=InternalOnClick;
  bBack.RenderWeight = 1.0;
  bBack.StyleName="STY_DXR_DeusExRectButton";
  bBack.Caption = strBack;
  bBack.WinHeight = 32;
  bBack.WinWidth = 243;
   bBack.WinLeft = 16;
   bBack.WinTop = 198;
    AppendComponent(bBack, true);
}


function bool InternalOnClick(GUIComponent Sender)
{  
  if (Sender==bEasy)
  {
    selectedDifficulty=1.0;
    Controller.OpenMenu("DXRMenu.DXRNewGame");
  }
  if (Sender==bMedium)
  {
    selectedDifficulty=1.5;
    Controller.OpenMenu("DXRMenu.DXRNewGame");
  }
  if (Sender==bHard)
  {
    selectedDifficulty=2.0;
    Controller.OpenMenu("DXRMenu.DXRNewGame");
  }
  if (Sender==bRealistic)
  {
    selectedDifficulty=4.0;
    Controller.OpenMenu("DXRMenu.DXRNewGame");
  }

  if (Sender==bBack)
  {
     Controller.CloseMenu();
  }
    return true;
}


defaultproperties
{
    WinTitle="Select Combat difficulty"
    strEasy="Easy"
    strMedium="Medium"
    strHard="Hard"
    strRealistic="Realistic"
    strBack="Back"
//    
        DefaultHeight=276
        DefaultWidth=264

        MaxPageHeight=276
        MaxPageWidth=264
        MinPageHeight=276
        MinPageWidth=264

    Begin Object Class=FloatingImage Name=FloatingFrameBackground
        Image=Texture'MenuDifficultyBackground_1'
        ImageRenderStyle=MSTY_Translucent //Normal
        ImageStyle=ISTY_Tiled //PartialScaled
        ImageColor=(R=255,G=255,B=255,A=255)
        DropShadow=None
        WinWidth=256
        WinHeight=255
        WinLeft=8
        WinTop=20
        RenderWeight=0.000003
        bBoundToParent=True
        bScaleToParent=True
    End Object
    i_FrameBG=FloatingFrameBackground

    Begin Object Class=GUIHeader Name=TitleBar
        WinWidth=1.15
        WinHeight=128
        WinLeft=-2
        WinTop=-3
        RenderWeight=0.1
        FontScale=FNS_Small
        bUseTextHeight=false
        bAcceptsInput=True
        bNeverFocus=true //False
        bBoundToParent=true
        bScaleToParent=true
        OnMousePressed=FloatingMousePressed
        OnMouseRelease=FloatingMouseRelease
    OnRendered=PaintOnHeader
        ScalingType=SCALE_ALL
    StyleName="STY_DXR_DXWinHeader"
    Justification=TXTA_Left
    End Object
    t_WindowTitle=TitleBar
}

