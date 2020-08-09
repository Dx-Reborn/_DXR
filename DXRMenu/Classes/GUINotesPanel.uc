/*
  Панель заметок
*/

class GUINotesPanel extends GUIPanel;

#exec OBJ LOAD File=DeusExControls.utx

var DeusExGlobals gl;
var automated GUIVertScrollBar myScrollBar;
var bool bSetUp;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local float y;
    local GUIEditBox note;
    Super.InitComponent(MyController,MyOwner);

    gl = class'DeusExGlobals'.static.GetGlobals();
//    funcA();

    myScrollBar.ItemCount = DeusExPlayer(self.PlayerOwner().Pawn).notes.length;
    myScrollBar.ItemsPerPage = 1;
    myScrollBar.Step = 5;//1;
    myScrollBar.BigStep = 10; // При удержании CTRL?
    myScrollBar.CurPos = 0;

    y=0;
    note = GUIEditBox(self.AddComponent("XInterface.GUIEditBox"));
    note.WinTop = 0-note.WinHeight;
}

function bool GUIDraw(Canvas c)
{
    local int noteIt, textIt, lineIt;
    local float height,charwidth,lineHeight,dummy;
//    local array <DeusExPlayer.SDeusExNote> notes;
    local array <DeusExGlobals.SDeusExNote> notes;
    local array <string> newlines;
    local float x,y;
    local float indent;

    c.Font = font'DxFonts.MSS_9';//'DXFonts.EUX_9';
    c.SetOrigin(self.ActualLeft(), self.ActualTop());
    c.SetClip(self.ActualWidth(), self.ActualHeight());
    c.SetPos(0,0);

    x=0;
    y=-myScrollBar.CurPos;

//    c.SetDrawColor(255,255,255);

//    notes = DeusExPlayer(self.PlayerOwner().Pawn).notes;
    notes = gl.notes;

//    for(noteIt=0; noteIt<notes.length; noteIt++)
    /*-- Цикл перевернут, чтобы новые заметки были всегда сверху --*/
    for(noteIt=notes.length-1; noteIt>=0; noteIt--)
    {
        c.SetPos(x,y);

        c.StrLen("C",charwidth,lineHeight);
        indent = lineHeight/2;
        height = indent;

        c.SetOrigin(c.OrgX+indent,c.OrgY);
        c.SetPos(x,y+indent);

        for(textIt=0; textIt<notes[noteIt].NoteText.length; textIt++)
        {
            c.SetPos(x,y+height);

            if(Len(notes[noteIt].NoteText[textIt]) > 0)
            {
//                c.WrapStringToArray(notes[noteIt].NoteText[textIt], newlines, self.ActualWidth()-indent*2);
                c.WrapStringToArray(class'DxUtil'.static.HtmlStrip(notes[noteIt].NoteText[textIt]), newlines, self.ActualWidth()-indent*2);
                for(lineIt=0; lineIt<newlines.length; lineIt++)
                {
                    c.StrLen(newlines[lineIt],dummy,lineHeight);
                    //c.DrawTextClipped(newlines[lineIt]);
                    c.DrawColor = class'DXR_Menu'.static.GetNotesText(gl.MenuThemeIndex);
                    c.DrawTextClipped(class'DxUtil'.static.HtmlStrip(newlines[lineIt]));
                    c.SetPos(c.CurX,c.CurY+lineHeight);
                    /*
                    if(c.CurY > c.ClipY-lineHeight)
                        c.DrawText(newlines[lineIt]);      */
                }

                height += lineHeight*lineIt;
            }
            else
            {
                height += lineHeight;
            }
            newlines.length=0;
        }


        c.SetOrigin(c.OrgX-indent,c.OrgY);

        if(y<0 && y+height>0)
        {
            c.SetPos(self.ActualLeft(),self.ActualTop());
            c.DrawColor = class'DXR_Menu'.static.GetNotesFrame(gl.MenuThemeIndex);
            if(y+height > self.ActualWidth())
            {
                //c.DrawTileStretched(Texture'DeusExControls.Controls.DeusExEditBoxBlurry',self.ActualWidth(),self.ActualHeight());
                c.DrawTileStretched(Texture'DXR_PersonaNote',self.ActualWidth(),self.ActualHeight());
            }
            else
            {
                c.DrawTileStretched(Texture'DXR_PersonaNote',self.ActualWidth(),y+height);
//                c.DrawTileStretched(Texture'DeusExControls.Controls.DeusExEditBoxBlurry',self.ActualWidth(),y+height);
            }
        }
        else if(y>=0 && y<=self.ActualHeight())
        {
            c.SetPos(self.ActualLeft(),self.ActualTop()+y);
            c.DrawColor = class'DXR_Menu'.static.GetNotesFrame(gl.MenuThemeIndex);
            if(y+height > self.ActualHeight())
            {
                c.DrawTileStretched(Texture'DXR_PersonaNote',self.ActualWidth(),self.ActualHeight()-y);
            }
            else
            {
                c.DrawTileStretched(Texture'DXR_PersonaNote',self.ActualWidth(),height);
            }
        }
        y+=height+4;
    }

    c.SetOrigin(0, 0);
    c.SetPos(0,0);

    if(!bSetUp)
    {
        myScrollBar.ItemCount=y;
        bSetUp=true;
    }
 c.reset();
 c.SetClip(c.SizeX, c.SizeY);
    return true;
}

function funcA()
{
    local DeusExPlayer.SDeusExNote notes;
    local int x;

    DeusExPlayer(self.PlayerOwner().Pawn).notes.Length=10;
    //TEST DATA
    for(x=0; x<10; x++)
    {
        notes.NoteText.length = 4;
        notes.NoteText[0] = "testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote testnote ";
        notes.NoteText[1] = "";
        notes.NoteText[2] = "turn off the radio";
        notes.NoteText[3] = "turn off the tv";
        notes.bUserNote = true;

        DeusExPlayer(self.PlayerOwner().Pawn).notes[x]=notes;
    }
}

function bool myOnKeyEvent(out byte Key, out byte State, float delta)
{
    local Interactions.EInputKey iKey;

    iKey = EInputKey(Key);

  //колесико мыши
    if (ikey == IK_MouseWheelUp) 
    {
        myScrollBar.DecreaseClick(none);
        return true;
    }
    if (ikey == IK_MouseWheelDown)
    {
        myScrollBar.IncreaseClick(none);
        return true;
    }
}


defaultproperties
{
    Begin Object Class=GUIVertScrollBar Name=cOne
        bBoundToParent=true
        bScaleToParent=true
        WinHeight=1.0
        WinWidth=16
        WinTop=0.0
        WinLeft=1.0
    End Object

    myScrollBar=cOne

    bSetUp=false
    OnPostDraw=GUIDraw

    OnKeyEvent=myOnKeyEvent

    bAcceptsInput=true
    bCaptureMouse=true
}
