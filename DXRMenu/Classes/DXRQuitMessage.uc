/* Запрос выхода */

class DXRQuitMessage extends DXRConfigurationDialog;

var() localized string stOk;
var() localized string stCancel;
var() localized string stMessage;
var GuiButton bOk, bCancel;
var GuiLabel lMessage;

function CreateMyControls()
{ // Ok
  bOk = new(none) class'GUIButton';
  bOk.OnClick=InternalOnClick;
  bOk.RenderWeight = 1.0;
  bOk.fontScale=FNS_Small;
  bOk.StyleName="STY_DXR_MediumButton";
  bOk.Caption = stOk;
  bOk.WinHeight = 21;
  bOk.WinWidth = 100;
  bOk.WinLeft = 203;
  bOk.WinTop = 148;
    AppendComponent(bOk, true);
    // Cancel
  bCancel = new(none) class'GUIButton';
  bCancel.OnClick=InternalOnClick;
  bCancel.RenderWeight = 1.0;
  bCancel.fontScale=FNS_Small;
  bCancel.StyleName="STY_DXR_MediumButton";
  bCancel.Caption = stCancel;
  bCancel.WinHeight = 21;
  bCancel.WinWidth = 100;
  bCancel.WinLeft = 305;
  bCancel.WinTop = 148;
    AppendComponent(bCancel, true);
    // Message
  lMessage = new(none) class'GUILabel';
  lMessage.RenderWeight = 1.0;
//  lMessage.StyleName="STY_DXR_MediumButton";
  lMessage.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  lMessage.TextAlign = TXTA_Center;
  lMessage.VertAlign = TXTA_Center;
  lMessage.Caption = stMessage;
  lMessage.bMultiLine = true;
  lMessage.WinHeight = 100;
  lMessage.WinWidth = 355;
  lMessage.WinLeft = 28;
  lMessage.WinTop = 32;
    AppendComponent(lMessage, true);
}

function bool InternalOnClick(GUIComponent Sender)
{
    if(Sender==bOk) // выход
    {
        PlayerOwner().ConsoleCommand("Exit");
    }

  if(Sender==bCancel)
    {
        Controller.CloseMenu(true);
    }
    return false;
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{
    local Interactions.EInputKey iKey;

    iKey = EInputKey(Key);

    if (iKey == IK_ENTER)
    {
        InternalOnClick(bOk);
        bOk.MenuState = MSAT_Pressed;
    }
    if (iKey == IK_ESCAPE)
    {
        bCancel.MenuState = MSAT_Pressed;
    }
    return false;
}

defaultproperties
{
    bNoBorders=true
    bUseShadow=true

    stMessage="Are you sure you want to exit|Deus Ex: Reborn ?"
    WinTitle="Please confirm"
    stOk="Ok"
    stCancel="Cancel"

    OnKeyEvent=InternalOnKeyEvent

    DefaultHeight=200
    DefaultWidth=405

    MaxPageHeight=200
    MaxPageWidth=405
    MinPageHeight=200
    MinPageWidth=405

    leftEdgeCorrectorX=4
    leftEdgeCorrectorY=0
    leftEdgeHeight=168

    RightEdgeCorrectorX=405
    RightEdgeCorrectorY=20
    RightEdgeHeight=140

    TopEdgeCorrectorX=304
    TopEdgeCorrectorY=16
    TopEdgeLength=100

    TopRightCornerX=402
    TopRightCornerY=16


    Begin Object Class=FloatingImage Name=FloatingFrameBackground
        Image=Texture'DXRMenuImg.DXR_MessageBox'
        ImageRenderStyle=MSTY_Translucent //Normal
        ImageStyle=ISTY_Tiled //PartialScaled
        ImageColor=(R=255,G=255,B=255,A=255)
        DropShadow=None
        WinWidth=400
        WinHeight=128 //229
        WinLeft=8
        WinTop=20
        RenderWeight=0.000003
        bBoundToParent=True
        bScaleToParent=True
        OnRendered=PaintOnBG
    End Object
    i_FrameBG=FloatingFrameBackground
}
