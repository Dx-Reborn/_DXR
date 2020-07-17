//
// ќкно дл€ вариантов ответа (и интерактивных диалогов)
// ConWinThird
//

class ConWindowActive extends floatingwindow
                              transient;

const WHEEL_SCROLL_DELAY = 0.05; // ћаксимальноый интервал дл€ "проматывани€" диалогов.
const SINGLE_ITEM_DELAY = 1.0f;
const AMOUNT_OF_CHOICES = 10;

enum EMoveModes
{
    MM_Enter,
    MM_Exit,
    MM_None
};
var EMoveModes moveMode;

var array<Inventory> ReceivedItems;



var Color colConTextFocus, colConTextChoice, colConTextSkill;

var int numChoices;                     // Number of choice buttons
var() transient ConChoiceWindow conChoices[AMOUNT_OF_CHOICES];   // Maximum of ten buttons
var transient ConPlay conplay;
var DeusExPlayer player;
var bool bRestrictInput;
var bool bTickEnabled;
var float fadealpha;

var bool bCanBeClosed;

var string speech;
var bool bForcePlay;
var bool bSafeToClose;
var float conStartTime;
var float movePeriod;
var float aTime;
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
    RemoveChoices();
    Super.OnClose(bCanceled);
//    RemoveChoices();
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
//  newButton.SetButtonTextures(,Texture'Solid', Texture'Solid', Texture'Solid');
//  newButton.SetButtonColors(,colConTextChoice, colConTextChoice, colConTextChoice);

    // Add the button
    AddButton(newButton);
}

// ----------------------------------------------------------------------
// DisplaySkillChoice()
// Displays a Skilled choice, a choice that's only visible if the user
// has a particular skill at a certain skill level
// ToDo: ѕроверить что это работает?
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

   DeusExHud((PlayerOwner()).myHUD).SafeRestore();
   moveMode     = MM_None;
//   bTickEnabled = false;
}

event Free()
{
   DeusExHud((PlayerOwner()).myHUD).SafeRestore();
   Super.Free();
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

    newButton = new class'ConChoiceWindow';
    newButton.bFocusOnWatch = true;
    newButton.CaptionAlign = TXTA_Left;
    newButton.WinHeight = 15;
    newButton.WinWidth = 1.0;
    newButton.WinTop = 0.0;
    newButton.WinLeft = 0.0;
    newButton.Hint = "";
    newButton.RenderWeight = 0.4;
    newButton.TabOrder = Controls.length + 1;
    newButton.bBoundToParent = true;
    newButton.OnClick=InternalOnClick;
    AppendComponent(newButton, true);

    return newButton;
}

function bool FloatingPreDraw(Canvas u)
{
    return Super.FloatingPreDraw(u);
}

function bool AlignFrame(Canvas C)
{
    return bInit;
}

function alignChoices()
{
    local int amount;
    local float aY;

    aY = -16.0;

    if (numChoices > 0)
        for (amount=0; amount<numChoices; amount++)
             conChoices[amount].wintop = aY +=16;
}

function Tick(float deltaTime)
{
  local int a;

  a += deltaTime;
  aTime += deltaTime;

    switch(moveMode)
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


function FloatingRendered(Canvas u)
{
    if (bMoving)
    { 
        u.SetPos(FClamp(Controller.MouseX - MouseOffset[0], 0.0, Controller.ResX - ActualWidth()), FClamp(Controller.MouseY - MouseOffset[1], 0.0, Controller.ResY - ActualHeight()));
        u.SetDrawColor(255,255,255,255);
        u.DrawTileStretched(Controller.WhiteBorder, ActualWidth(), ActualHeight());
    }
    if (bTickEnabled)
        Tick(controller.renderDelta); //  ак таковой Tick() не предусмотрен, но можно использовать RenderDelta.

    RenderExtraStuff(u);
}

function AddSystemMenu()
{
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

// HEX коды клавиш
// 0x20 -- пробел, 0x1B -- ESC
function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{
    local Interactions.EInputKey iKey;

    iKey = EInputKey(Key);

    // Ќе реагировать на нажати€ если не прошло достаточно времени.
    if ((playerOwner().level.TimeSeconds - conStartTime < 2) && (!bForcePlay))
        return true;

    if (bForcePlay)
    {
      //if (Key == 0x1B && state == 1)
      if ((iKey == IK_Escape) || (iKey == IK_LeftMouse) || (iKey == IK_RightMouse) || (ikey == IK_MouseWheelUp) || (ikey == IK_MouseWheelDown) || (ikey == IK_Space) && State == 1)
      {
        AbortCinematicConvo();
        bCanBeClosed = true;
        Controller.CloseMenu(true);
        return true;
      }
    }
    else
    if ((key == 0x20) || (ikey == IK_MouseWheelUp) || (ikey == IK_MouseWheelDown))
    {
        if (NumChoices < 1)
        {
           if (aTime > WHEEL_SCROLL_DELAY) // so conversations history will be recorded completely, without skipping last event.
               conPlay.PlayNextEvent();
           aTime = 0;
        }
        return true;
    }
 return true;
}

function InternalOnMouseRelease(GUIComponent Sender)
{
    if (bForcePlay)
    {
        AbortCinematicConvo();
        bCanBeClosed = true;
        Controller.CloseMenu(true);
        return;
    }
    else if (playerOwner().level.TimeSeconds - conStartTime < 2)
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


// —рабатывает при нажатии ESC, вернуть true = позволить закрыть окно, вернуть false = не закрывать.
function bool CanCloseWindow(optional bool bCancelled)
{
    return bCanBeClosed;
}

function RenderExtraStuff(canvas u)
{
    u.SetOrigin(self.ActualLeft(), self.ActualTop());
    u.SetClip(self.ActualWidth(), self.ActualHeight());
    u.font = font'dxFonts.MSS_10';
    u.SetDrawColor(128,255,128,255); // RGB Alpha
    u.SetPos(20,200);

    u.DrawText("Canvas: Test text here! Coords X="$u.CurX @"Y="$u.CurY);
}


function ShowReceivedItem(Inventory invItem, int count)
{
    // ToDo: Ќарисовать окошки
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
            ShowChoiceAsSpeech(ConChoice(conChoices[buttonIndex].GetUserObject()).ChoiceText);

            // Clear the screen
            RemoveChoices();
            break;
        }
    }
    return true;
}

function Clear();

function bool isVisible()
{
   return false;
}

function Destroy()
{
    Close();
}

function close()
{
    SetTimer(movePeriod, false);
    moveMode     = MM_Exit;
    bTickEnabled = true;
    bCanBeClosed = true;
}

event Timer()
{
    Controller.closeMenu(true);
}

defaultproperties
{
    OnCanClose=CanCloseWindow
    OnPreDraw=InternalOnPreDraw
    OnKeyEvent=ConWindowActive.InternalOnKeyEvent
    OnMouseRelease=ConWindowActive.InternalOnMouseRelease

    colConTextFocus=(R=255,G=255,B=0,A=0)
    colConTextChoice=(R=0,G=0,B=255,A=0)
    colConTextSkill=(R=255,G=0,B=0,A=0)

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
//        TextAlign=TXTA_Center
    End Object
    winSpeech=MySubtitles

    Begin Object Class=GUILabel Name=MySpeaker
        Caption=""
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


//      i_FrameBG=none //FloatingFrameBackground
//     onDraw=ConWindowActive.OnDraw
//     OnPreDraw=ConWindowActive.OnPreDraw
//     OnClose=DeusExMidGameMenu.InternalOnClose
}
