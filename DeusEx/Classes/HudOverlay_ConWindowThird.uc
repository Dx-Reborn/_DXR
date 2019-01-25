/*
   Оверлей ГДИ.
   Контроль через DeusExInteraction.
*/
class HudOverlay_ConWindowThird extends HudOverlay;

var float conStartTime;
var bool bForcePlay, bRestrictInput;
var string speech, speakerName;
var transient DeusExGlobals gl;
var transient object UserObjects[10];

var int numChoices;										// Number of choice items

var DeusExPlayer player;
var DeusExPlayerController dxpc;
var DeusExHUD dxhud;

var ConPlay conPlay;


function SetInitialState()
{
  dxpc = DeusExPlayerController(level.GetLocalPlayerController());
  player = DeusExPlayer(dxpc.pawn);
  dxhud = DeusExHUD(dxpc.myHUD);
  gl = class'DeusExGlobals'.static.GetGlobals();
  gl.conWindow = self;

	conStartTime = player.level.TimeSeconds;
}

function AbortCinematicConvo()
{
	local MissionEndgame script;

	conPlay.TerminateConversation();

	foreach AllActors(class'MissionEndgame', script)
		break;

	if (script != None)
		script.FinishCinematic();
}


function DisplayName(string text)
{
	// Don't do this if bForcePlay == True
	if (!bForcePlay)
	{
		SpeakerName = text;
	}
}

function SetForcePlay(bool bNewForcePlay)
{
	bForcePlay = bNewForcePlay;
}

function RestrictInput(bool bNewRestrictInput)
{
	bRestrictInput = bNewRestrictInput;
}

function DisplayText(string text, Actor speakingActor)
{
	Speech = text;
}

function AppendText(string text)
{
	Speech $= text;
}

function ShowChoiceAsSpeech(string Text)
{
   SpeakerName = player.GetTruePlayerName();
   Speech = Text;
}


function Render(canvas u)
{
   DrawCinematic(u);
}

// Sent from DeusExInteraction
function KeyEvent(Interactions.EInputKey Key)
{
   if (Key == IK_ESCAPE)
       Close(); //
}


function DrawCinematic(Canvas u)
{
    local float x,y;
    local float /*w,*/h;
//    local ConChoice choice;
    local int line;


    x=0;
    y=0;
    h=0;
    line=0;

    u.SetPos(0,0);
    u.DrawRect(texture'Engine.BlackTexture',u.ClipX,u.ClipY*0.2);

    u.SetPos(0,u.ClipY*0.8);
    u.DrawRect(texture'Engine.BlackTexture',u.ClipX,u.ClipY*0.2);

/*    if(speech != "")
    {
        u.SetDrawColor(255,255,255);
        u.SetPos(5,c.ClipY*0.8+8);
        u.Font=Font'DxFonts.FontConversationBold';
        if(DeusExPlayer(speech.speaker) != none)
        {
            u.DrawText(DeusExPlayer(speech.speaker).FamiliarName$": ");
        }

        u.TextSize(DeusExPlayer(speech.speaker).FamiliarName$": ",x,y);

        u.SetDrawColor(0,255,255);
        u.SetPos(15+x,u.ClipY*0.8+8);

        u.Font=Font'DxFonts.FontConversation';
        u.DrawText(speech.conSpeech.speech);
    }*/

/*    if(bChoosing)
    {
        c.Font=Font'DeusExFont.FontConversation';
        choice = conChoice.ChoiceList;
        c.SetDrawColor(0,0,255);
        c.SetPos(15,c.ClipY*0.8);
        while(choice != none)
        {
            c.SetPos(15,c.ClipY*0.8+h*line);

            c.StrLen(choice.choiceText,w,h);
            if(choice == self.currentChoice)
            {
                c.DrawRect(texture'DeusExControls.Controls.whitesquare',w,h);
            }

            c.SetPos(15,c.CurY);
            c.DrawText("~"$choice.choiceText);

            choice = choice.nextChoice;
            line++;
        }
    }*/
}

function Close()
{
   Destroy();
}

event Destroyed()
{
  super.Destroyed();
  gl.conWindow = none;
}
