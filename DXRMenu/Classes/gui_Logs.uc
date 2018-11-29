/* История ClientMessage... */

class gui_Logs extends PlayerInterfacePanel;

var GUIImage iLogs;
var GUIListBox logList;
var GUIButton bClear, bFind;
var GUILabel lLogs; // Название.
var GUIEditBox eFindWhat;

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

     UpdateData();
     UpdateCounter();
}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);

	CreateMyControls();
//  logListChange(none);
}

function CreateMyControls()
{
  logList = new(none) class'GUIListBox';
  logList.MyScrollBar.WinWidth = 16;
  logList.SelectedStyleName="STY_DXR_ListSelection";
  logList.StyleName = "STY_DXR_Listbox";
  logList.bBoundToParent = true;
  logList.OnChange=logListChange;
  logList.WinHeight = 458;
  logList.WinWidth = 478;
  logList.WinLeft = 116;
  logList.WinTop = 70;//54;
	AppendComponent(logList, true);
  logList.list.TextAlign = TXTA_Left;

  bClear = new(none) class'GUIButton';
  bClear.FontScale = FNS_Small;
  bClear.Caption = "Clear logs";
  bClear.Hint = "Clear all current logs";
  bClear.StyleName="STY_DXR_ButtonNavbar";
  bClear.bBoundToParent = true;
  bClear.OnClick = InternalOnClick;
  bClear.WinHeight = 22;
  bClear.WinWidth = 100;
  bClear.WinLeft = 108;
  bClear.WinTop = 533; //517;
	AppendComponent(bClear, true);

  ilogs = new(none) class'GUIImage'; 
  ilogs.Image=texture'DXR_LogsBackground';
  ilogs.bBoundToParent = true;
	ilogs.WinHeight = 512;
  ilogs.WinWidth = 512;
  ilogs.WinLeft = 100;
  ilogs.WinTop = 48;
  iLogs.tag = 75;
	AppendComponent(ilogs, true);

  lLogs = new(none) class'GUILabel';
  lLogs.bBoundToParent = true;
  lLogs.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceHDR(gl.MenuThemeIndex);
  lLogs.caption = "Logs";
  lLogs.TextFont="UT2HeaderFont";
  lLogs.bMultiLine = false;
  lLogs.TextAlign = TXTA_Left;
  lLogs.VertAlign = TXTA_Center;
  lLogs.FontScale = FNS_Small;
 	lLogs.WinHeight = 20;
  lLogs.WinWidth = 100;
  lLogs.WinLeft = 108;
  lLogs.WinTop = 48;//32;
	AppendComponent(lLogs, true);

	/*-- Поиск ------------------------------*/
	eFindWhat = new(none) class'GUIEditBox';
  eFindWhat.StyleName="STY_DXR_EditBox";
	eFindWhat.bScaleToParent = false;
  eFindWhat.bBoundToParent = true;  // fixed
	eFindWhat.FontScale = FNS_Small;
	eFindWhat.bMaskText = false;
	eFindWhat.MaxWidth = 128;
	eFindWhat.WinHeight = 20;
  eFindWhat.WinWidth = 276;
  eFindWhat.WinLeft = 328;
  eFindWhat.WinTop = 534;
	AppendComponent(eFindWhat, true);

  bFind = new(none) class'GUIButton';
  bFind.FontScale = FNS_Small;
  bFind.Caption = "Find in logs:";
  bFind.Hint = "Find text in logs (case insensitive)";
  bFind.StyleName="STY_DXR_ButtonNavbar";
  bFind.bBoundToParent = true;
  bFind.OnClick = InternalOnClick;
  bFind.WinHeight = 22;
  bFind.WinWidth = 110;
  bFind.WinLeft = 215;
  bFind.WinTop = 533;//517;
	AppendComponent(bFind, true);

  ApplyTheme();

	fillData();
}

function logListChange(GUIComponent Sender)
{
}

function UpdateData()
{
   if (logList != none)
   fillData();
}

function UpdateCounter()
{
   if (lLogs != none)
   lLogs.caption = "Logs ["$ logList.List.ItemCount $"]";
}

function fillData()
{
  local DeusExPlayer p;
  local int i;

  logList.List.Clear(); // Сначала очистить список

  p = DeusExPlayer(playerOwner().pawn);

  if ((p != none) && (p.logMessages.length > 0))
  {
// Я должна перевернуть цикл, тогда новые вперед   for(i=0; i<p.logMessages.length; i++)
   for(i=p.logMessages.length-1; i>=0; i--)
   {
     logList.List.Add(p.logMessages[i]);
   }
  }
//  else
//  logList.List.Add("No logs for now.");
}

/* Поиск придется писать свой, встроенный ищет элемент списка целиком, а не часть. */
function bool InternalOnClick(GUIComponent Sender)
{
  local string findLog;

  if (Sender==bClear)
  {
    DeusExPlayer(playerOwner().pawn).logMessages.length = 0;
    fillData();
    UpdateCounter();
    return true;
  }

  if (Sender==bFind)
  {
    findLog = logList.List.Find(eFindWhat.GetText());
    log(findlog$" << return, find "$ eFindWhat.GetText());
    return true;
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
