/* Экран Целей и заметок */

class gui_Goals extends PlayerInterfacePanel;

var GUIImage iGoals;
var GUILabel lGoals, lNotes, lNotesHDR;
var GuiButton bClear, bUserNote, bDeleteNote, bBack;
var GUIGoalsPanel myGoals;
var GUINotesPanel myNotes;
//var DeusExGlobals gl;

var GUIListBox rn;

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

  if (gl.notes.length < 1)
      bClear.DisableMe();
}

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);
//  gl = class'DeusExGlobals'.static.GetGlobals();
  CreateMyControls();
}

function CreateMyControls()
{
  myNotes = new(none) class'GUINotesPanel';
  myNotes.bBoundToParent = true;
  myNotes.bScaleToParent = true;
  myNotes.WinLeft = 31;
  myNotes.WinTop = 259;
  myNotes.WinHeight = 254;
  myNotes.WinWidth = 724;
  AppendComponent(myNotes, true);


  myGoals = new(none) class'GUIGoalsPanel';
  myGoals.bBoundToParent = true;
  myGoals.bScaleToParent = true;
  myGoals.WinLeft = 31;
  myGoals.WinTop = 54;
  myGoals.WinHeight = 156;
  myGoals.WinWidth = 724;
  AppendComponent(myGoals, true);

/*-------------------------------------------------------------------------------------------------------------------------*/
  iGoals = new(none) class'GUIImage'; 
  iGoals.Image=texture'DXR_GoalsBackground';
  iGoals.bBoundToParent = true;
	iGoals.WinHeight = 512;
  iGoals.WinWidth = 768;
  iGoals.WinLeft = 16;
  iGoals.WinTop = 32;
  iGoals.tag = 75;
	AppendComponent(iGoals, true);

  lGoals = new(none) class'GUILabel';
  lGoals.bBoundToParent = true;
  lGoals.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceHDR(gl.MenuThemeIndex);
  lGoals.caption = "Goals";
  lGoals.TextFont="UT2HeaderFont";
  lGoals.bMultiLine = false;
  lGoals.TextAlign = TXTA_Left;
  lGoals.VertAlign = TXTA_Center;
  lGoals.FontScale = FNS_Small;
 	lGoals.WinHeight = 20;
  lGoals.WinWidth = 120;
  lGoals.WinLeft = 25;
  lGoals.WinTop = 32;
	AppendComponent(lGoals, true);

  lNotesHDR = new(none) class'GUILabel';
  lNotesHDR.bBoundToParent = true;
  lNotesHDR.TextColor = class'DXR_Menu'.static.GetPlayerInterfaceHDR(gl.MenuThemeIndex);
  lNotesHDR.caption = "Notes";
  lNotesHDR.TextFont="UT2HeaderFont";
  lNotesHDR.bMultiLine = false;
  lNotesHDR.TextAlign = TXTA_Left;
  lNotesHDR.VertAlign = TXTA_Center;
  lNotesHDR.FontScale = FNS_Small;
 	lNotesHDR.WinHeight = 20;
  lNotesHDR.WinWidth = 120;
  lNotesHDR.WinLeft = 25;
  lNotesHDR.WinTop = 238;
	AppendComponent(lNotesHDR, true);

  bClear = new(none) class'GUIButton';
  bClear.FontScale = FNS_Small;
  bClear.Caption = "Manage Notes";
  bClear.Hint = "Allows to delete notes";
  bClear.StyleName="STY_DXR_ButtonNavbar";
  bClear.bBoundToParent = true;
  bClear.OnClick = InternalOnClick;
  bClear.WinHeight = 22;//22;
  bClear.WinWidth = 130;//100;
  bClear.WinLeft = 26;
  bClear.WinTop = 516;
	AppendComponent(bClear, true);
/*-------------------------------------------------------------------------------------------------------------------------*/
  bUserNote = new(none) class'GUIButton';
  bUserNote.FontScale = FNS_Small;
  bUserNote.Caption = "User notes";
  bUserNote.Hint = "Personal notes. Store any info you like.";
  bUserNote.StyleName="STY_DXR_ButtonNavbar";
  bUserNote.bBoundToParent = true;
  bUserNote.OnClick = InternalOnClick;
  bUserNote.WinHeight = 22;
  bUserNote.WinWidth = 130;
  bUserNote.WinLeft = 156;
  bUserNote.WinTop = 516;
	AppendComponent(bUserNote, true);

	ApplyTheme();
}
/*-------------------------------------------------------------------------------------------------------------------------*/

function bool InternalOnClick(GUIComponent Sender)
{
  if (Sender==bClear)
  {
    ModeDeleteNote();
  }
  if (Sender==bUserNote)
  {
    ModeUserNotes();
  }
  if (Sender==bBack)
  {
    BackToRegularNotes();
  }
  if (Sender==bDeleteNote)
  {
    if ((rn.list.ItemCount < 1) && (rn != none))
     BackToRegularNotes();
     else
     DeleteCurrentNote();
  }

  return false;
}

function ModeDeleteNote()
{
  local int f;

  myNotes.SetVisibility(false);
  myNotes.bAcceptsInput = false;
  myNotes.bCaptureMouse = false;
  bClear.DisableMe();
  bUserNote.DisableMe();

  rn = new class'GUIListBox';
  rn.MyScrollBar.WinWidth = 16;
  rn.SelectedStyleName="STY_DXR_ListSelection";
  rn.StyleName = "STY_DXR_Listbox";
  rn.bBoundToParent = true;
  rn.bScaleToParent = true;
  rn.WinLeft = 31;
  rn.WinTop = 259;
  rn.WinHeight = 254;
  rn.WinWidth = 724;
  AppendComponent(rn, true);
  rn.list.TextAlign = TXTA_Left;

  for (f=0; f<gl.notes.length; f++)
  {
     rn.list.add(class'DxUtil'.static.HtmlStrip(gl.notes[f].NoteText[0]@gl.notes[f].NoteText[1]@gl.notes[f].NoteText[2]));
  }

  bDeleteNote = new class'GUIButton';
  bDeleteNote.FontScale = FNS_Small;
  bDeleteNote.Caption = "Delete this note";
  bDeleteNote.Hint = "Remove selected note. If you find its source (usually Datacube), it will be added again.";
  bDeleteNote.StyleName="STY_DXR_ButtonNavbar";
  bDeleteNote.bBoundToParent = true;
  bDeleteNote.OnClick = InternalOnClick;
  bDeleteNote.WinHeight = 22;
  bDeleteNote.WinWidth = 150;
  bDeleteNote.WinLeft = 280;
  bDeleteNote.WinTop = 516;
	AppendComponent(bDeleteNote, true);

  bBack = new class'GUIButton';
  bBack.FontScale = FNS_Small;
  bBack.Caption = "Back";
  bBack.Hint = "Go back to normal notes mode";
  bBack.StyleName="STY_DXR_ButtonNavbar";
  bBack.bBoundToParent = true;
  bBack.OnClick = InternalOnClick;
  bBack.WinHeight = 22;
  bBack.WinWidth = 130;
  bBack.WinLeft = 431;
  bBack.WinTop = 516;
	AppendComponent(bBack, true);
}

function BackToRegularNotes()
{
  RemoveComponent(bDeleteNote);
  bDeleteNote.free();
  RemoveComponent(bBack);
  bBack.free();
  RemoveComponent(rn);
  rn.free();

  myNotes.SetVisibility(true);
  myNotes.bAcceptsInput = true;
  myNotes.bCaptureMouse = true;
  bClear.EnableMe();
  bUserNote.EnableMe();
}

function DeleteCurrentNote()
{
  local int x;

  if (rn.list.ItemCount > 0)
  {
   x = rn.list.index;
   gl.Notes.remove(x,1);
   rn.list.Remove(x,1);
   rn.OnChange(none);
  }
}

function ModeUserNotes()
{

}

function PaintFrames(canvas u)
{
  local float x,y;

  x = ActualLeft(); y = ActualTop();

//  u.SetDrawColor(0,255,0,128);
  u.DrawColor = class'DXR_Menu'.static.GetPlayerInterfaceFrames(gl.MenuThemeIndex);
  u.Style = EMenuRenderStyle.MSTY_Translucent;

  u.SetPos(x + lFrameX, y + lframeY);
  u.drawtileStretched(texture'GoalsBorder_1', lfSizeX, lfSizeY);

  u.SetPos(x + mFrameX, y + mframeY);
  u.drawtileStretched(texture'GoalsBorder_2', mfSizeX, mfSizeY);

  u.SetPos(x + rFrameX, y + rframeY);
  u.drawtileStretched(texture'GoalsBorder_3', rfSizeX, rfSizeY);
/*-----------------*/
  u.SetPos(x + lFrameXb, y + lframeYb);
  u.drawtileStretched(texture'GoalsBorder_4', lfSizeXb, lfSizeYb);

  u.SetPos(x + mFrameXb, y + mframeYb);
  u.drawtileStretched(texture'GoalsBorder_5', mfSizeXb, mfSizeYb);

  u.SetPos(x + rFrameXb, y + rframeYb);
  u.drawtileStretched(texture'GoalsBorder_6', rfSizeXb, rfSizeYb);

}


defaultproperties
{
 lFrameX=0
 lframeY=21
 lfSizeX=256
 lfSizeY=257

 mFrameX=256
 mframeY=21
 mfSizeX=487
 mfSizeY=257

 rFrameX=743
 rframeY=21
 rfSizeX=64
 rfSizeY=257
/////////////////

 lFrameXb=0
 lframeYb=278
 lfSizeXb=256
 lfSizeYb=337

 mFrameXb=256
 mframeYb=359
 mfSizeXb=487
 mfSizeYb=256

 rFrameXb=743
 rframeYb=278
 rfSizeXb=64
 rfSizeYb=337

//    bBoundToParent=true
    OnRendered=PaintFrames
}
