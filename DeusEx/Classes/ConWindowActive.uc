//
// Окно для вариантов ответа (и интерактивных диалогов)
// ConWinThird
//

class ConWindowActive extends floatingwindow;

enum EMoveModes
{
	MM_Enter,
	MM_Exit,
	MM_None
};
var EMoveModes moveMode;

var Color colConTextFocus, colConTextChoice, colConTextSkill;

var int numChoices;										// Number of choice buttons
var() ConChoiceWindow conChoices[10];	// Maximum of ten buttons
var ConPlay conplay;
var DeusExPlayer player;
var bool bRestrictInput;
var bool bTickEnabled;
var float fadealpha;

var string speech;
var bool bForcePlay;
var bool bSafeToClose; // 
var float conStartTime;
var float movePeriod;
var localized string ChoiceBeginningChar;

var() automated GUILabel SpeakerName;
var() automated floatingimage i_FrameBG2;
var() automated GUIScrollTextBox winSpeech;

function DisplayName(string text)
{
	// Don't do this if bForcePlay == True
	if (!bForcePlay)
	{
		SpeakerName.caption = text;
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
	winSpeech.SetContent(text);
}

function AppendText(string text)
{
	winSpeech.AddText(text);
}

function ShowChoiceAsSpeech(string Text)
{
   SpeakerName.Caption = DeusExPlayer(PlayerOwner().pawn).GetTruePlayerName();
   winSpeech.SetContent(Text);
}


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	// Ia?aaaou oeacaoaeu ia naay.
	DeusExPlayer(playerOwner().pawn).conPlay.conWinThird = self;

	t_WindowTitle.DockAlign = PGA_Top;
	t_WindowTitle.winWidth = 0.0;

	i_FrameBG.Image = texture'Engine.BlackTexture';
	i_FrameBG.ImageRenderStyle=MSTY_Alpha;
	i_FrameBG.WinTop=0.8;
	i_FrameBG.bStandardized=true;
	i_FrameBG.StandardHeight=0.2;
	i_FrameBG.ImageColor.A=255;

	if (i_FrameBG2 == none)
	i_FrameBG2 = new(none) class'floatingimage';
	i_FrameBG2.Image = texture'Engine.BlackTexture';
	i_FrameBG2.ImageRenderStyle=MSTY_Alpha;
	i_FrameBG2.WinTop = 0.0;
	i_FrameBG2.WinLeft = 0.0;
	i_FrameBG2.WinWidth = 1.0;
	i_FrameBG2.bStandardized=true;
	i_FrameBG2.StandardHeight = 0.2;
	i_FrameBG2.bBoundToParent = true;
	i_FrameBG2.DropShadow = none;
	i_FrameBG2.ImageColor.A=255;
	AppendComponent(i_FrameBG2, true);
}

function AbortCinematicConvo()
{
	local MissionEndgame script;

	conPlay.TerminateConversation();

	foreach PlayerOwner().AllActors(class'MissionEndgame', script)
		break;

	if (script != None)
		script.FinishCinematic();
}

// Ii?ao oie?oi?eou eo oie ooieoeae?
function RemoveChoices()
{
	local int buttonIndex;

	// Clear our array as well
	for (buttonIndex=0; buttonIndex<numChoices; buttonIndex++)
	{
		conChoices[buttonIndex].bNeverFocus = true;
		conChoices[buttonIndex].FocusInstead = t_WindowTitle;
		conChoices[buttonIndex].SetText("");
		conChoices[buttonIndex].SetUserObject(none);
		conChoices[buttonIndex].Hide();
		conChoices[buttonIndex] = none;
	}
	numChoices = 0;
}

function InternalOnClose(optional Bool bCanceled)
{
	Super.OnClose(bCanceled);
	RemoveChoices();
}


// ----------------------------------------------------------------------
// DisplayChoice()
// Displays a choice, but sets up the button a little differently than 
// when displaying normal conversation text
// ----------------------------------------------------------------------
function DisplayChoice(ConChoice choice)
{
	local ConChoiceWindow newButton;

	newButton = CreateConButton(colConTextChoice, colConTextFocus );
	newButton.SetText(ChoiceBeginningChar $ choice.choiceText);
	newButton.SetUserObject(choice);

	// These next two calls handle highlighting of the choice
//	newButton.SetButtonTextures(,Texture'Solid', Texture'Solid', Texture'Solid');
//	newButton.SetButtonColors(,colConTextChoice, colConTextChoice, colConTextChoice);

	// Add the button
	AddButton(newButton);
}

// ----------------------------------------------------------------------
// DisplaySkillChoice()
// Displays a Skilled choice, a choice that's only visible if the user
// has a particular skill at a certain skill level
// A i?eaeiaeuiie ea?a ia eniieuciaaeinu.
// ----------------------------------------------------------------------
function DisplaySkillChoice(ConChoice choice)
{
	local ConChoiceWindow newButton;

	newButton = CreateConButton(colConTextSkill, colConTextFocus);
	newButton.SetText(ChoiceBeginningChar $ choice.choiceText $ "  (" $ choice.SkillNeeded $ ":" $ choice.SkillLevelNeeded $ ")" );
	newButton.SetUserObject(choice);

	// Add the button
	AddButton(newButton);
}

event Opened(GUIComponent Sender)                   // Called when the Menu Owner is opened
{
  Super.Opened(Sender);

	conStartTime = DeusExPlayer(playerOwner().pawn).level.TimeSeconds;
	DeusExHud((PlayerOwner()).myHUD).cubemapmode = true;

  i_FrameBG.ImageColor.A = 0;
  i_FrameBG2.ImageColor.A = 0;

  moveMode     = MM_Enter;
	bTickEnabled = true;
}

event Closed(GUIComponent Sender, bool bCancelled)  // Called when the Menu Owner is closed
{
  Super.Closed(Sender, bCancelled);

// Ii iaiiiyoiie i?e?eia, ainnoaiiaeaiea AAE iai?yio? aucuaaao aueao. 
// Iiyoiio y aiaaaeea caaa??eo a 1/2 naeoiau.
	DeusExHud((PlayerOwner()).myHUD).SafeRestore(); //cubemapmode = false;

  moveMode     = MM_None;
  bTickEnabled = false;
}

event Free() // Aie?ii ono?aieou aueao ia ia?aoe? ESC.
{
  Super.Free();

  DeusExHud((PlayerOwner()).myHUD).SafeRestore(); //cubemapmode = false;
}


// ----------------------------------------------------------------------
// AddButton()
// Creates a button to display text or a choice.
// ----------------------------------------------------------------------
function AddButton(ConChoiceWindow newButton)
{
	// Turn the cursor on so the user can use the cursor to 
	// select a choice.
	bAcceptsInput = true;
	bCaptureMouse = true;

	// Add to our button array
	conChoices[numChoices++] = newButton;

	alignChoices();
}

function ConChoiceWindow CreateConButton(Color colTextNormal, Color colTextFocus)
{
	local ConChoiceWindow newButton;

	newButton = new(none) class'ConChoiceWindow';
	newButton.bFocusOnWatch = true;
  newButton.CaptionAlign = TXTA_Left;
	newButton.WinHeight = 15;
	newButton.WinWidth = 1.0;
	newButton.WinTop = 0.0;
	newButton.WinLeft = 0.0;
	newButton.Hint = "";
	newButton.RenderWeight = 0.4;
	newButton.TabOrder = Controls.length+1;
	newButton.bBoundToParent = true;  //true;
	newButton.OnClick=InternalOnClick;
	AppendComponent(newButton, true);

	return newButton;
}

function bool FloatingPreDraw(Canvas C)
{
	return Super.FloatingPreDraw(C);
}

function bool AlignFrame(Canvas C)
{
	return bInit;
}

function alignChoices()
{
	local int amount;
	local float aY;

//	aY = 0.0;
	aY = -16.0;

	if (numChoices > 0)
	{
		for (amount=0; amount<numChoices; amount++)
		{
			//conChoices[amount].wintop = aY +=0.0160;
			conChoices[amount].wintop = aY +=16;
		}
	}

}

//----------------------------------------------
function Tick(float deltaTime)
{
  local int a;

  a += deltaTime;

	switch( moveMode )
	{
    case MM_Enter:
     if (a <= 0.1)
         fadeAlpha += 1;

     if (i_FrameBG.ImageColor.A < 255)
     {
       i_FrameBG.ImageColor.A = FadeAlpha;
       i_FrameBG2.ImageColor.A = FadeAlpha;
	   }
		break;

		case MM_Exit:
     if (a <= 0.1)
         fadeAlpha -= 1;

     if (i_FrameBG.ImageColor.A > 254)
     {
       i_FrameBG.ImageColor.A = FadeAlpha;
       i_FrameBG2.ImageColor.A = FadeAlpha;
	   }
		break;

		default:
			bTickEnabled = False;
	}
}


function FloatingRendered(Canvas C)
{
	if (bMoving)
	{ //I?eciae ia?aiauaiey ieia. Oioy caanu yoi ia io?ii.
		C.SetPos( FClamp(Controller.MouseX - MouseOffset[0], 0.0, Controller.ResX - ActualWidth()),
	          	FClamp(Controller.MouseY - MouseOffset[1], 0.0, Controller.ResY - ActualHeight()));
		C.SetDrawColor(255,255,255,255);
		C.DrawTileStretched( Controller.WhiteBorder, ActualWidth(), ActualHeight() );
	}
  if (bTickEnabled)
      Tick(controller.renderDelta); // Eae oaeiaie ooieoee Tick iao, ii ii?ii eniieuciaaou RenderDelta.
}

function AddSystemMenu()
{
//ioee??eou eeoiaa
	local eFontScale tFontScale;

	b_ExitButton = GUIButton(t_WindowTitle.AddComponent( "XInterface.GUIButton" ));
	b_ExitButton.Style = Controller.GetStyle("CloseButton",tFontScale);
	b_ExitButton.OnClick = XButtonClicked;
	b_ExitButton.bNeverFocus = true;
	b_ExitButton.FocusInstead = t_WindowTitle;
	b_ExitButton.RenderWeight = 1;
	b_ExitButton.bScaleToParent = false;
	b_ExitButton.OnPreDraw = SystemMenuPreDraw;
                                    
	// Do not want OnClick() called from MousePressed()
	b_ExitButton.bRepeatClick = False;
}

// HEX eiau eeaaeo 
// 0x20 -- i?iaae, 0x1B -- ESC
function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{
	local Interactions.EInputKey iKey;

	iKey = EInputKey(Key);

	if (bForcePlay)
    if (Key == 0x1B && state == 1) // 1--ia?aoi
    {
	    AbortCinematicConvo();
		  return false; //true;
    }
	// I?iaae || eieaneei iuoe
	if ((key == 0x20) || (ikey == IK_MouseWheelUp) || (ikey == IK_MouseWheelDown))
	{
		if (NumChoices < 1)
		conPlay.PlayNextEvent();
		return true;
	}
 return true; //false;
}

function bool OnCanClose(optional bool bCancelled)
{
	if (bForcePlay)
  {
	    AbortCinematicConvo();
//	    return true;
	}

/*     if (NumChoices == 0)// < 1)
     {
      if (ConPlay != none)
      {
       conPlay.PlayNextEvent();
       //return false;
      }
      else return true;
     }

   if (ConPlay == none)
       return true;*/

  return true; // false = ignore ESC key
}


function ShowReceivedItem(Inventory invItem, int count)
{
	// Iiea caaeooea
}

function bool InternalOnClick(GUIComponent Sender)
{
	local int buttonIndex;

	// Abort if we're restricting input
	if (bRestrictInput)
		return true;

	// Restrict input again until we've finished processing this choice
	bRestrictInput = True;

	// Take a look to make sure it's one of our buttons before continuing.
	for (buttonIndex=0; buttonIndex<numChoices; buttonIndex++ )
	{
		if (sender == conChoices[buttonIndex])
		{
			conPlay.PlayChoice(ConChoice(conChoices[buttonIndex].GetUserObject()));
			ShowChoiceAsSpeech(ConChoice(conChoices[buttonIndex].GetUserObject()).ChoiceText); // ioia?aceou aa?eaio ioaaoa eae oaeno.

			// Clear the screen
			RemoveChoices();
			break;
		}
	}
	return true;
}

function InternalOnMouseRelease(GUIComponent Sender)
{
		if (playerOwner().pawn.level.TimeSeconds - conStartTime < 2)
		{
				return;
		}
		else
		{
			if (NumChoices < 1)
			conPlay.PlayNextEvent();
			return;
		}
}

function Clear();

function bool isVisible();

function Destroy()
{
   Controller.closeMenu();
}

function close()
{
   Destroy();
}

defaultproperties
{
    colConTextFocus=(R=255,G=255,B=0,A=0),
    colConTextChoice=(R=0,G=0,B=255,A=0),
    colConTextSkill=(R=255,G=0,B=0,A=0),

		DefaultWidth=1.0 //0.2
		DefaultHeight=1.0 //0.6

		bCaptureMouse=true //true
    bAcceptsInput=true //true // Does this control accept input

		bResizeWidthAllowed=False
		bResizeHeightAllowed=False

 	  bPauseIfPossible=false   // Should this menu pause the game if possible
	  bRenderWorld=true // False - don't render anything behind this menu / True - render normally (everything)
    bAllowedAsLast=true

    WinTop=0.000000
    WinHeight=1.000000

    ChoiceBeginningChar="  "
        movePeriod=0.60

		Begin Object class=GUIScrollTextBox Name=MySubTitles
			RenderWeight=0.8
			WinWidth=0.98
			WinHeight=0.18
			WinLeft=0.01
			WinTop=0.825
        TabOrder=2
        bVisibleWhenEmpty=false
        bNoTeletype=false
				CharDelay=0.005
				EOLDelay=0.75
				RepeatDelay=3.0
				StyleName="STY_DXR_DXSubTitles"
				FontScale=FNS_Small
// Auaeyaeo ?ooei 0_o        TextAlign=TXTA_Center
		End Object
    winSpeech=MySubtitles

    Begin Object Class=GUILabel Name=MySpeaker
        Caption=" "
        TextAlign=TXTA_Left
        TextColor=(B=255,G=255,R=255)
        FontScale=FNS_Small
        StyleName="STY_DXR_ConLabel"
				WinLeft=0.01
        WinTop=0.800000
        WinWidth=0.200000
        WinHeight=0.030000
        RenderWeight=0.900000
        bBoundToParent=True
        bScaleToParent=True
        menustate=MSAT_Blurry
    End Object
		SpeakerName=MySpeaker


//		i_FrameBG=none //FloatingFrameBackground
//     onDraw=ConWindowActive.OnDraw
//     OnPreDraw=ConWindowActive.OnPreDraw
//     OnClose=DeusExMidGameMenu.InternalOnClose
		 OnPreDraw=InternalOnPreDraw
     OnMouseRelease=ConWindowActive.InternalOnMouseRelease
     OnKeyEvent=ConWindowActive.InternalOnKeyEvent
}