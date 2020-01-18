/*

*/

class DXRCredits extends DxWindowTemplate;

var GUIButton btnClose, btnSupport;
var GUIScrollTextBox Information;

var localized string strSupport, strClose;
var string Credits[100];
const supportLink="https://discord.gg/vpth4Dp"; // Бесконечное приглашение.


function CreateMyControls()
{
  Information = new(none) class'GUIScrollTextBox';
  Information.StyleName="STY_DXR_DeusExScrollTextBox";
  Information.FontScale=FNS_Small;
  Information.WinHeight = 203;
  Information.WinWidth = 403;
  Information.WinLeft = 12;
  Information.WinTop = 26;
  Information.bRepeat = false;
  Information.bNoTeletype = false;
  Information.EOLDelay = 0.1;
  Information.CharDelay = 0.1;
  Information.RepeatDelay = 3.0;
  Information.bBoundToParent = true;
  AppendComponent(Information, true);

  btnClose = new(none) class'GUIButton';
  btnClose.WinHeight = 21;
  btnClose.WinWidth = 100;
  btnClose.WinLeft = 321;
  btnClose.WinTop = 237;
  btnClose.StyleName = "STY_DXR_MediumButton";
  btnClose.Caption = strClose;
  btnClose.OnClick = InternalOnClick;
  AppendComponent(btnClose, true);

  btnSupport = new(none) class'GUIButton';
  btnSupport.WinHeight = 21;
  btnSupport.WinWidth = 100;
  btnSupport.WinLeft = 9;
  btnSupport.WinTop = 237;
  btnSupport.StyleName = "STY_DXR_MediumButton";
  btnSupport.Caption = strSupport;
  btnSupport.OnClick = InternalOnClick;
  AppendComponent(btnSupport, true);

  fillList();
}

function fillList()
{
   local int i;

   information.SetContent("");

   for (i=0;i<ArrayCount(Credits);i++)
        information.AddText(Credits[i]);
}

function bool InternalOnClick(GUIComponent Sender)
{
  if (Sender==btnClose)
      controller.CloseMenu(true);
  else if (Sender==btnSupport)
       Controller.OpenMenu("DXRMenu.DXRDevOptions");
//      Console(Controller.Master.Console).DelayedConsoleCommand("open"@supportLink);

  return true;
}


defaultproperties
{
    WinTitle="About Deus Ex: Reborn+"
    strSupport="Dev. Options"
    strClose="OK"

     Credits[0]="  Preview Beta version."
     Credits[1]="|"
     Credits[2]="  Please keep in mind that this is still Beta, and some bugs were not fixed yet."
     Credits[3]="|"
     Credits[4]=""
     Credits[5]="  This mod uses code from the following Deus Ex mods:"
     Credits[6]="    GMDX"
     Credits[7]="    Revision"
     Credits[8]="    Vanilla Matters"
     Credits[9]="    CoolBits"
    Credits[10]="    Deus Ex V2"
    Credits[11]="    Smoke39"
    Credits[12]="    Project 2027"
    Credits[13]="    HardCoreDX"
    Credits[14]="|"
    Credits[15]="  Special thanks to:"
    Credits[16]="    MVV"
    Credits[17]="    Hanfling"
    Credits[18]="    Akerfeldt"
    Credits[19]="|"
    Credits[20]="  Also thanks to:"
    Credits[21]="    Kolendar"
    Credits[22]="    GreenEyesMan"
    Credits[23]="    RoSoDude"
    Credits[24]="    Totalitarian"
    Credits[25]="    Markie"
    Credits[26]="  "
    Credits[27]="    "
    Credits[28]="    "
    Credits[29]="  "
    Credits[30]=""
    Credits[31]=""
    Credits[32]=""

    DefaultHeight=256
    DefaultWidth=418
    MaxPageHeight=256
    MaxPageWidth=418
    MinPageHeight=256
    MinPageWidth=418

    leftEdgeCorrectorX=4
    leftEdgeCorrectorY=0
    leftEdgeHeight=251

    RightEdgeCorrectorX=422
    RightEdgeCorrectorY=20
    RightEdgeHeight=230

    TopEdgeCorrectorX=333
    TopEdgeCorrectorY=16
    TopEdgeLength=86

    TopRightCornerX=419
    TopRightCornerY=16

    Begin Object Class=FloatingImage Name=FloatingFrameBackground
        Image=Texture'DXR_BankDisabled'
        ImageRenderStyle=MSTY_Normal
        ImageStyle=ISTY_Tiled
        ImageColor=(R=255,G=255,B=255,A=255)
        DropShadow=None
        WinWidth=418
        WinHeight=249
        WinLeft=8
        WinTop=20
        RenderWeight=0.000003
        bBoundToParent=True
        bScaleToParent=True
        OnRendered=PaintOnBG
    End Object
    i_FrameBG=FloatingFrameBackground
}

