/*
   Панель для отображения целей
*/

class GUIGoalsPanel extends GUIPanel;

#exec OBJ LOAD File=DeusExControls.utx

var localized string strPrimaryGoals, strSecondaryGoals, strShowCompleted;
var automated GUIVertScrollBar myScrollBar;
var automated moCheckBox myCheckBox;
var bool bSetUp;
var bool bShowComplete;

const green="я";
const gray="";
const orange="я_";

var DeusExGlobals gl;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    local float y;
    local GUIEditBox note;

    Super.InitComponent(MyController,MyOwner);

    gl = class'DeusExGlobals'.static.GetGlobals();

//    AddTestData();

    myScrollBar.ItemCount = gl.goals.length; //DeusExPlayer(self.PlayerOwner().Pawn).goals.length;
    myScrollBar.ItemsPerPage = 1;
    myScrollBar.Step=1;
    myScrollBar.BigStep = 10;
    myScrollBar.CurPos = 0;

    y=0;
    note = GUIEditBox(self.AddComponent("XInterface.GUIEditBox"));
    note.WinTop = -note.WinHeight;
}

function bool GUIDraw(Canvas c)
{
    local int goalIt, lineIt;
    local float /*width,*/height, charwidth, lineHeight, dummy;
//    local array<DeusExPlayer.SDeusExGoal> goals;
    local array<string> newlines;
    local float x,y;
    local float holdX,holdY;
    local float indent, addIndent;

    c.Font = font'DxFonts.MSS_9'; //'DXFonts.EUX_9';
    c.SetOrigin(self.ActualLeft(), self.ActualTop());
    c.SetClip(self.ActualWidth(), self.ActualHeight());
    c.SetPos(0,0);

    c.SetDrawColor(255,255,255);

    x=0;
    addIndent=16;
    y=-myScrollBar.CurPos;

//    goals = DeusExPlayer(self.PlayerOwner().Pawn).goals;

    c.SetPos(x,y);
    c.StrLen(strPrimaryGoals,charwidth,lineHeight);
    c.DrawTextClipped(strPrimaryGoals);
    y+=lineHeight;
    /*-------------------------------------------------------------------------------------------*/
    //Primary Goals
    for(goalIt=0; goalIt<gl.goals.length; goalIt++)
    {
        c.SetPos(x,y);
        c.StrLen("C",charwidth,lineHeight);
        addIndent = charwidth*2;
        indent = lineHeight/2;
        height = indent;

        c.SetOrigin(c.OrgX+indent,c.OrgY);
        c.SetPos(x,y+indent);

        if(gl.goals[goalIt].bPrimaryGoal)
        {
            if ((gl.goals[goalIt].bCompleted && bShowComplete) || !gl.goals[goalIt].bCompleted)
            {
                c.SetPos(x+addIndent,y+height);

                holdX=c.CurX;
                holdY=c.CurY;
                c.SetPos(holdX+indent/2-charwidth*2,holdY);
                c.DrawTextClipped("*");
                c.SetPos(holdX,holdY);

                //this if-test is kinda redundent but whatev
                //a lot of this shitty code is redundant
                if(Len(gl.goals[goalIt].text) > 0)
                {
                    c.WrapStringToArray(gl.goals[goalIt].text, newlines, self.ActualWidth()-indent*2);
                    for(lineIt=0; lineIt<newlines.length; lineIt++)
                    {
                        c.StrLen(newlines[lineIt],dummy,lineHeight);

                        if (!gl.goals[goalIt].bCompleted)
                        c.SetDrawColor(255,255,255);

                        if (gl.goals[goalIt].bCompleted)
                        c.SetDrawColor(155,155,155);

                        c.DrawTextClipped(newlines[lineIt]);
                        c.SetPos(c.CurX,c.CurY+lineHeight);
                    }
                    height += lineHeight*lineIt;
                }
                else
                {
                    height += lineHeight;
                }
                newlines.length=0;
                y+=height+4;
            }
        }
        c.SetOrigin(c.OrgX-indent,c.OrgY);
    }
    c.SetPos(x,y);
    c.SetDrawColor(255,255,255);
    c.StrLen(strSecondaryGoals,charwidth,lineHeight);
    c.DrawTextClipped(strSecondaryGoals);
    y+=lineHeight;
    /*-------------------------------------------------------------------------------------------*/
    //Secondary Goals
    for(goalIt=0; goalIt<gl.goals.length; goalIt++)
    {
        c.SetPos(x,y);

        c.StrLen("C",charwidth,lineHeight);
        addIndent = charwidth*2;
        indent = lineHeight/2;
        height = indent;

        c.SetOrigin(c.OrgX+indent,c.OrgY);
        c.SetPos(x,y+indent);

        if(!gl.goals[goalIt].bPrimaryGoal)
        {
            if((gl.goals[goalIt].bCompleted && bShowComplete) || !gl.goals[goalIt].bCompleted)
            {
                c.SetPos(x+addIndent,y+height);

                holdX=c.CurX;
                holdY=c.CurY;
                c.SetPos(holdX+indent/2-charwidth*2,holdY);
                c.DrawTextClipped("*");
                c.SetPos(holdX,holdY);


                if(Len(gl.goals[goalIt].text) > 0)
                {
                    c.WrapStringToArray(gl.goals[goalIt].text, newlines, self.ActualWidth()-indent*2);
                    for(lineIt=0; lineIt<newlines.length; lineIt++)
                    {
                        c.StrLen(newlines[lineIt],dummy,lineHeight);

                        if (!gl.goals[goalIt].bCompleted)
                        c.SetDrawColor(255,255,255);

                        if (gl.goals[goalIt].bCompleted)
                        c.SetDrawColor(155,155,155);

                        c.DrawTextClipped(newlines[lineIt]);
                        c.SetPos(c.CurX,c.CurY+lineHeight);
                    }
                    height += lineHeight*lineIt;
                }
                else
                {
                    height += lineHeight;
                }
                newlines.length=0;

                y+=height+4;
            }
        }
        c.SetOrigin(c.OrgX-indent,c.OrgY);
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

function CheckChange(GUIComponent Sender)
{
    bShowComplete=myCheckBox.IsChecked();
}

// Только для тестирования!
function AddTestData()
{
    local int x;
    local bool bPrimary;
    local DeusExPlayer.SDeusExGoal goals;

/*    DeusExPlayer(self.PlayerOwner().Pawn)*/gl.goals.Length=10;
    //TEST DATA
    for(x=0; x<10; x++)
    {
        bPrimary = !bPrimary;

        goals.bPrimaryGoal = bPrimary;

        goals.bCompleted = false;
        if((x+1)%3==0)
        goals.bCompleted = true;

        goals.text = "[Completed="$goals.bCompleted$"]"@"Test Goal. Here is some text. Unicode && localization support. Color is "$green$"green, now i want"$gray$" grey. No, i wanted "$orange$"orange. Color codes support.";
        DeusExPlayer(self.PlayerOwner().Pawn).goals[x]=goals;
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
    strPrimaryGoals=" Primary Goals"
    strSecondaryGoals=" Secondary Goals"
    strShowCompleted="Show completed goals"

    Begin Object Class=GUIVertScrollBar Name=cOne
          bBoundToParent=true
          bScaleToParent=true
          WinHeight=1.0
          WinTop=0.0
          WinLeft=1.0
          WinWidth=16
    End Object

    Begin Object Class=moCheckBox Name=cTwo
          FontScale=FNS_Small
/*          LabelFont="UT2SmallHeaderFont"
          LabelStyleName="DeusExCheckBox"
          StyleName="DeusExCheckBox"
          CheckStyleName="DeusExCheckBox"*/
          bBoundToParent=true
          bScaleToParent=true
          Caption="Show Completed Goals"
          ComponentJustification=TXTA_Left
          StandardHeight=0.02
          WinHeight=4
          WinWidth=0.59
          WinTop=1.01
          WinLeft=0.5
          CaptionWidth=0.59
          OnChange=CheckChange
    End Object

    myScrollBar=cOne
    myCheckBox=cTwo

    bShowComplete=false
    bSetUp=false
    OnPostDraw=GUIDraw

    OnKeyEvent=myOnKeyEvent

    bAcceptsInput=true
    bCaptureMouse=true
}
