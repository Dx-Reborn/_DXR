/* Экран истории диалогов */

class gui_Conversations extends PlayerInterfacePanel;

var GUIImage iConvos;
var GUILabel lCons;
var GuiButton bClear;
var DXRConListBox ConvoList;
var GUIScrollTextBox ConvoDetails;
var DXRConList cList;

var GUIButton bsSpeaker, bsLocation, bsType;

/* Frames positioning */
var(leftPart) float lFrameX, lframeY, lfSizeX, lfSizeY;
var(midPart) float mFrameX, mframeY, mfSizeX, mfSizeY;
var(rightPart) float rFrameX, rframeY, rfSizeX, rfSizeY;

var(BleftPart) float lFrameXb, lframeYb, lfSizeXb, lfSizeYb;
var(BmidPart) float mFrameXb, mframeYb, mfSizeXb, mfSizeYb;
var(BrightPart) float rFrameXb, rframeYb, rfSizeXb, rfSizeYb;


function ShowPanel(bool bShow)
{
  super.ShowPanel(bShow);
  if (bShow) 
     PlayerOwner().pawn.PlaySound(Sound'Menu_OK',SLOT_Interface,0.25);
}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
//  gl = class'DeusExGlobals'.static.GetGlobals();
	Super.Initcomponent(MyController, MyOwner);
	CreateMyControls();
}

function CreateMyControls()
{
  iConvos = new(none) class'GUIImage'; 
  iConvos.Image=texture'DXR_ConversationsBackground';
  iConvos.bBoundToParent = true;
	iConvos.WinHeight = 512;
  iConvos.WinWidth = 512;
  iConvos.WinLeft = 100;
  iConvos.WinTop = 48;
  iConvos.tag = 75;
	AppendComponent(iConvos, true);

  lCons = new(none) class'GUILabel';
  lCons.bBoundToParent = true;
  lCons.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceHDR(gl.MenuThemeIndex);
  lCons.caption = "Conversations";
  lCons.TextFont="UT2HeaderFont";
  lCons.bMultiLine = false;
  lCons.TextAlign = TXTA_Left;
  lCons.VertAlign = TXTA_Center;
  lCons.FontScale = FNS_Small;
 	lCons.WinHeight = 20;
  lCons.WinWidth = 120;
  lCons.WinLeft = 108;
  lCons.WinTop = 48;//32;
	AppendComponent(lCons, true);

  bClear = new(none) class'GUIButton';
  bClear.FontScale = FNS_Small;
  bClear.Caption = "Clear logs";
  bClear.Hint = "Clear all current logs";
  bClear.StyleName="STY_DXR_ButtonNavbar";
  bClear.bBoundToParent = true;
//  bClear.OnClick = InternalOnClick;
  bClear.WinHeight = 0;//22;
  bClear.WinWidth = 0;//100;
  bClear.WinLeft = 108;
  bClear.WinTop = 533;//517;
	AppendComponent(bClear, true);

  ConvoList = new(none) class'DXRConListBox';
  ConvoList.bBoundToParent = true;
  ConvoList.WinHeight = 134;
  ConvoList.WinWidth = 480;
  ConvoList.WinLeft = 116;
  ConvoList.WinTop = 85;//69;
  ConvoList.bDisplayHeader = false;
	AppendComponent(ConvoList, true);
	cList = ConvoList.aList;
  cList.OnChange = ConvoListChange;

  ConvoDetails = new(none) class'GUIScrollTextBox'; // описание (считывается из SaveInfo.dxs)
  ConvoDetails.StyleName="STY_DXR_DeusExScrollTextBox";
  ConvoDetails.FontScale=FNS_Small;
	ConvoDetails.WinHeight = 306;
  ConvoDetails.WinWidth = 478;
  ConvoDetails.WinLeft = 118;
  ConvoDetails.WinTop = 240;
  ConvoDetails.bRepeat = false;
  ConvoDetails.bNoTeletype = gl.bUseCursorEffects;
  ConvoDetails.EOLDelay = 0.1;
  ConvoDetails.CharDelay = 0.005;
  ConvoDetails.RepeatDelay = 3.0;
  ConvoDetails.bBoundToParent = true;
	AppendComponent(ConvoDetails, true);

	bsSpeaker = new(none) class'GUIButton';
  bsSpeaker.FontScale = FNS_Small;
  bsSpeaker.Caption = "Speaker";
  bsSpeaker.Hint = "";
  bsSpeaker.StyleName="STY_DXR_Personal";
  bsSpeaker.bBoundToParent = true;
//  bsSpeaker.OnClick = InternalOnClick;
  bsSpeaker.WinHeight = 18;
  bsSpeaker.WinWidth = 194;
  bsSpeaker.WinLeft = 114;
  bsSpeaker.WinTop = 66;
	AppendComponent(bsSpeaker, true);

	bsLocation = new(none) class'GUIButton';
  bsLocation.FontScale = FNS_Small;
  bsLocation.Caption = "Location";
  bsLocation.Hint = "";
  bsLocation.StyleName="STY_DXR_Personal";
  bsLocation.bBoundToParent = true;
//  bsLocation.OnClick = InternalOnClick;
  bsLocation.WinHeight = 18;
  bsLocation.WinWidth = 247;
  bsLocation.WinLeft = 308;
  bsLocation.WinTop = 66;
	AppendComponent(bsLocation, true);

	bsType = new(none) class'GUIButton';
  bsType.FontScale = FNS_Small;
  bsType.Caption = "Type";
  bsType.Hint = "";
  bsType.StyleName="STY_DXR_Personal";
  bsType.bBoundToParent = true;
//  bsType.OnClick = InternalOnClick;
  bsType.WinHeight = 18;
  bsType.WinWidth = 47;
  bsType.WinLeft = 555;
  bsType.WinTop = 66;
	AppendComponent(bsType, true);

	ApplyTheme();
  fillNamesAndLocations();
}


function ConvoListChange(GUIComponent Sender)
{
  fillDetails();
}


function fillNamesAndLocations()
{
  local int x;

  if (gl.myConHistory.length < 1)
  return;

  cList.Clear();
  cList.ConvoHistory.length = gl.myConHistory.length;

// Наверное цикл нужно будет перевернуть...
  for (x=0; x<gl.myConHistory.length; x++)
  {
    cList.ConvoHistory[x].Speaker = gl.myConHistory[x].conOwnerName;
    cList.ConvoHistory[x].Location = gl.myConHistory[x].strLocation;

    if (gl.myConHistory[x].bInfoLink)
        cList.ConvoHistory[x].Type="B";
        else
        cList.ConvoHistory[x].Type="A";

    cList.AddedItem();
  }
//  ConvoListChange(none);
}

function fillDetails()
{
//    ConvoDetails.AddText(lstEmail.aList.myMailList[lstEmail.alist.CurrentListId()].text[x]);
  local int x;

  ConvoDetails.SetContent("");

  for (x=0; x<gl.myConHistory[cList.CurrentListId()].conHistoryEvents.length; x++)
  {
    ConvoDetails.AddText(gl.myConHistory[cList.CurrentListId()].conHistoryEvents[x].conSpeaker $"|"$chr(9)$chr(9)$ gl.myConHistory[cList.CurrentListId()].conHistoryEvents[x].speech$"|");
  }
}


function PaintFrames(canvas u)
{
  local float x,y;

  x = ActualLeft(); y = ActualTop();

//  u.SetDrawColor(0,255,0,128);
  u.DrawColor = class'DXR_Menu'.static.GetPlayerInterfaceFrames(gl.MenuThemeIndex);
  u.Style = EMenuRenderStyle.MSTY_Translucent;

  u.SetPos(x + lFrameX, y + lframeY);
  u.drawtileStretched(texture'ConversationsBorder_1', lfSizeX, lfSizeY);

  u.SetPos(x + mFrameX, y + mframeY);
  u.drawtileStretched(texture'ConversationsBorder_2', mfSizeX, mfSizeY);

  u.SetPos(x + rFrameX, y + rframeY);
  u.drawtileStretched(texture'ConversationsBorder_3', rfSizeX, rfSizeY);
/*-----------------*/
  u.SetPos(x + lFrameXb, y + lframeYb);
  u.drawtileStretched(texture'ConversationsBorder_4', lfSizeXb, lfSizeYb);

  u.SetPos(x + mFrameXb, y + mframeYb);
  u.drawtileStretched(texture'ConversationsBorder_5', mfSizeXb, mfSizeYb);

  u.SetPos(x + rFrameXb, y + rframeYb);
  u.drawtileStretched(texture'ConversationsBorder_6', rfSizeXb, rfSizeYb);

}


defaultproperties
{
 lFrameX=-6
 lframeY=30
 lfSizeX=256
 lfSizeY=363.2

 mFrameX=250
 mframeY=30
 mfSizeX=345
 mfSizeY=256

 rFrameX=595
 rframeY=30
 rfSizeX=64
 rfSizeY=363.2
/////////////////

 lFrameXb=-6
 lframeYb=393
 lfSizeXb=256
 lfSizeYb=256

 mFrameXb=250
 mframeYb=393
 mfSizeXb=345
 mfSizeYb=256

 rFrameXb=595
 rframeYb=393
 rfSizeXb=64
 rfSizeYb=256

    bBoundToParent=true
    OnRendered=PaintFrames
}
