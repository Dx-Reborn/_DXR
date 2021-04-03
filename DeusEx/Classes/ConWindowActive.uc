//
// Окно для интерактивных (и не только) диалогов и вариантов ответа.
// ConWinThird
//

class ConWindowActive extends floatingwindow
                              transient
                              config(User);

const WHEEL_SCROLL_DELAY = 0.05; // Задержка при "проматывании" диалогов.
const AMOUNT_OF_CHOICES = 10;
const CHOICE_HEIGHT = 20.00; //16.00;
const DISAPPEAR_STEP = 0.005; // 0.002


enum EMoveModes
{
    MM_Enter,
    MM_Exit,
    MM_None
};
var EMoveModes moveMode;
var bool bExpandEffect; // DXR: Использовать эффект как в оригинальной игре
var config bool bChoicesAtTop; // Варианты ответа сверху.

struct sReceivedItems
{
   var() Inventory anItem;
   var() int anItemCount;
};
var() array<sReceivedItems> ReceivedItems; // DXR: Array of items for the player.

var Color colConTextFocus, colConTextChoice, colConTextSkill, colConTextChoiceUnhighlighted; // DXR: New color (colConTextChoiceUnhighlighted)
var color InfoLinkBG, InfoLinkText, InfoLinkTitles, InfoLinkFrame;

var int numChoices;                     // Number of choice buttons
var() transient ConChoiceWindow conChoices[AMOUNT_OF_CHOICES];   // Maximum of ten buttons // DXR: Transient for safety
var transient ConPlay conplay; // DXR: Transient for safety
var DeusExPlayer player;
var bool bRestrictInput;
var bool bTickEnabled;
var float fadealpha;

var bool bCanBeClosed;
var bool bRenderPlayerCredits;
var bool bRenderReceivedItems;

var string speech;
var bool bForcePlay;
var bool bSafeToClose;
var float conStartTime;
var float movePeriod;
var float aTime;
var localized string ChoiceBeginningChar, strPlayerCredits;

var float SpeakerStrLen;

var() automated GUILabel SpeakerName;
var() floatingimage i_FrameBG2;
var() automated GUIScrollTextBox winSpeech;

var transient DxCanvas dxc;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
   local DeusExHUD h;

   Super.InitComponent(MyController, MyOwner);

   dxc = DeusExHUD(PlayerOwner().myHUD).dxc;
   if (dxc == None)
       dxc = new(outer) class'DxCanvas';

   // DXR: Get colors...
   h = DeusExHUD(PlayerOwner().myHUD);
   InfoLinkBG = h.InfoLinkBG;
   InfoLinkText = h.InfoLinkText;
   InfoLinkTitles = h.InfoLinkTitles;
   InfoLinkFrame = h.InfoLinkFrame;

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
       i_FrameBG2.bFocusOnWatch = true;
       AppendComponent(i_FrameBG2, true);

   ShowMouseCursor(false);
}

// DXR: Works only in fullscreen mode!
function ShowMouseCursor(bool bNewValue)
{
   DeusExGUIController(Controller).ShowMouseCursor(bNewValue);
}


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

   if (bForcePlay)
   {
       winSpeech.TextAlign = TXTA_Center; // DXR: Установить текст по центру, как в оригинале.
       winSpeech.bNoTeletype = true; // Иначе это невозможно прочесть.
       winSpeech.InitComponent(Controller, self); // Ещё раз? Тогда это работает!
   }
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
   bRenderPlayerCredits = false;

   ShowMouseCursor(false);
}

function InternalOnClose(optional bool bCanceled)
{
   RemoveChoices();
   Super.OnClose(bCanceled);
}


// ----------------------------------------------------------------------
// DisplayChoice()
// Displays a choice, but sets up the button a little differently than 
// when displaying normal conversation text
// ----------------------------------------------------------------------
function DisplayChoice(ConChoice choice)
{
   local ConChoiceWindow newButton;

   newButton = CreateConButton(colConTextChoice, colConTextFocus);
   newButton.SetText(ChoiceBeginningChar $ choice.choiceText);
   newButton.SetUserObject(choice);

   // These next two calls handle highlighting of the choice
   newButton.SetButtonTextures(,Texture'Solid', Texture'Solid', Texture'Solid');
   newButton.SetButtonColors(,colConTextChoice, colConTextChoice, colConTextChoice);

   // Add the button
   AddButton(newButton);

   bRenderPlayerCredits = true;
   ShowMouseCursor(true); // DXR: Отобразить курсор для выбора ответа.
}

// ----------------------------------------------------------------------
// DisplaySkillChoice()
// Displays a Skilled choice, a choice that's only visible if the user
// has a particular skill at a certain skill level
// ToDo: Проверить что это работает?
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

   conStartTime = playerOwner().level.TimeSeconds;
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

   ShowMouseCursor(true);
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
    // DXR: Move mouse cursor to choices
    PlayerOwner().ConsoleCommand("SETMOUSE "$ConChoices[0].ActualLeft() + (ConChoices[0].ActualWidth() / 2)
                                                                                @ ConChoices[0].ActualTop());
}

function HideControls()
{
    SpeakerName.SetVisibility(false);
    winSpeech.SetVisibility(false);
}

function UnhideControls()
{
    SpeakerName.SetVisibility(true);
    winSpeech.SetVisibility(true);
}

function RealignControls()
{
    if (bForcePlay == false)
    {
        SpeakerName.WinWidth = SpeakerStrLen + 14;

        winSpeech.WinLeft = SpeakerStrLen + 20;
        winSpeech.WinWidth = ActualWidth() - (SpeakerStrLen + 30);
    }
}

function ConChoiceWindow CreateConButton(Color colTextNormal, Color colTextFocus)
{
    local ConChoiceWindow newButton;

    newButton = new class'ConChoiceWindow';
    newButton.bFocusOnWatch = true;
    newButton.CaptionAlign = TXTA_Left;
    newButton.WinHeight = CHOICE_HEIGHT;
    newButton.WinWidth = 1.0;
    newButton.WinTop = 0.0;
    newButton.WinLeft = 0.0;
    newButton.Hint = "";
    newButton.RenderWeight = 0.99;
    newButton.TabOrder = Controls.length + 1;
    newButton.bBoundToParent = true;
    newButton.OnClick = InternalOnClick;
    AppendComponent(newButton, true);

    newButton.SetTextColors(colTextNormal, colTextFocus, colTextFocus, colTextFocus);
    newButton.SetFocus(None);

    return newButton;
}

function alignChoices()
{
    local int amount;
    local float aY;

    if (!bChoicesAtTop)
    {
        aY = ActualHeight() - i_FrameBG.ActualHeight() + CHOICE_HEIGHT;
        if (numChoices > 0)
            for (amount=0; amount<numChoices; amount++)
                 conChoices[amount].wintop = aY +=CHOICE_HEIGHT;
    }
    else
    {
        aY = -CHOICE_HEIGHT;

        if (numChoices > 0)
            for (amount=0; amount<numChoices; amount++)
                 conChoices[amount].wintop = aY +=CHOICE_HEIGHT;
    }
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
           fadeAlpha += 1; //1

       if (i_FrameBG.ImageColor.A < 255) //255
       {
           i_FrameBG.ImageColor.A = FadeAlpha;
           i_FrameBG2.ImageColor.A = FadeAlpha;
       }
       break;

       case MM_Exit:
       i_FrameBG.ImageColor.A -=1;
       i_FrameBG2.ImageColor.A -=1;

       i_FrameBG2.WinTop -=DISAPPEAR_STEP;
       i_FrameBG.WinTop  +=DISAPPEAR_STEP;

       winSpeech.WinTop  += DISAPPEAR_STEP;
       SpeakerName.WinTop+= DISAPPEAR_STEP;

       if ((i_FrameBG2.ImageColor.A < 1) || (i_FrameBG.ImageColor.A < 1))
            bTickEnabled = false;
       break;

       default:
       bTickEnabled = false;
    }
}

function AddSystemMenu()
{
    local eFontScale tFontScale;

    b_ExitButton = GUIButton(t_WindowTitle.AddComponent("XInterface.GUIButton"));
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

    // Не реагировать на нажатия если не прошло достаточно времени.
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
           if (aTime > WHEEL_SCROLL_DELAY) // DXR: so conversations history will be recorded completely, without skipping last event.
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


// Срабатывает при нажатии ESC, вернуть true = позволить закрыть окно, вернуть false = не закрывать.
function bool CanCloseWindow(optional bool bCancelled)
{
    return bCanBeClosed;
}

function bool FloatingPreDraw(Canvas u)
{
    return Super.FloatingPreDraw(u);
}

function bool AlignFrame(Canvas C)
{
    return bInit;
}

function FloatingRendered(Canvas u)
{
    local float yl;

    //u.StrLen(SpeakerName.Caption, SpeakerStrLen, yl);
    SpeakerName.Style.TextSize(u, SpeakerName.MenuState, SpeakerName.Caption, SpeakerStrLen, yl, SpeakerName.FontScale);
    RealignControls();//

    if (bMoving)
    { 
        u.SetPos(FClamp(Controller.MouseX - MouseOffset[0], 0.0, Controller.ResX - ActualWidth()), FClamp(Controller.MouseY - MouseOffset[1], 0.0, Controller.ResY - ActualHeight()));
        u.SetDrawColor(255,255,255,255);
        u.DrawTileStretched(Controller.WhiteBorder, ActualWidth(), ActualHeight());
    }
    if (bTickEnabled)
        Tick(controller.renderDelta); // Как таковой Tick() не предусмотрен, но можно использовать RenderDelta.

    RenderExtraStuff(u);

//    if (bRenderReceivedItems)
    if (ReceivedItems.Length > 0)
        RenderReceivedItems(u);

}

function RenderReceivedItems(canvas u)
{
    local float w,h;
    local int x;
    local texture border;
    local material ico;
    local string infoBuffer;

    dxc.SetCanvas(u);

        u.SetDrawColor(255,255,255);
        u.Font = font'DXFonts.DPix_7';//'DxFonts.FontMenuSmall_DS';
        u.Style=1;

        //w = 50+40*ReceivedItems.Length;
        w = 50+80*ReceivedItems.Length;
        h = 64;
        infoBuffer = class'HudOverlay_received'.default.StrReceived; // DXR: Use string from HUD overlay

        //u.SetOrigin(int((u.SizeX-w)/2), int((u.SizeY-h)/2));
        u.SetOrigin(i_FrameBG.ActualLeft() + 20,i_FrameBG.ActualTop() - 80);
        u.SetClip(w, h);

        u.DrawColor = InfoLinkBG;
        if (DeusExPlayerController(PlayerOwner()).bHUDBackgroundTranslucent)
            u.Style = eMenuRenderStyle.MSTY_Translucent;
               else
            u.Style = eMenuRenderStyle.MSTY_Normal;

        //TL
        u.SetPos(-13,-16);
        u.DrawTile(texture'DeusExUI.HUDWindowBackground_TL',63,16, 1,0,63,16);
        //L
        u.SetPos(-13,0);
        u.DrawTile(texture'DeusExUI.HUDWindowBackground_Left',63,h, 1,0,63,8);
        //BL
        u.SetPos(-13, u.ClipY);
        u.DrawTile(texture'DeusExUI.HUDWindowBackground_BL',63,16, 1,0,63,16);

        //T
        u.SetPos(50,-16);
        u.DrawTile(texture'DeusExUI.HUDWindowBackground_Top',w-51,16, 0,0,8,16);
        //M
        u.SetPos(50,0);
        u.DrawTile(texture'DeusExUI.HUDWindowBackground_Center',w-51,h, 0,0,8,8);
        //B
        u.SetPos(50,u.ClipY);
        u.DrawTile(texture'DeusExUI.HUDWindowBackground_Bottom',w-51,16, 0,0,8,16);

        u.SetOrigin(u.OrgX+u.ClipX-1,u.OrgY-16);
        u.SetClip(32,h+32);
        //TR
        u.SetPos(0,0);
        u.DrawTileClipped(texture'DeusExUI.HUDWindowBackground_TR',30,16, 1,0,31,16);
        //R
        u.SetPos(0,16);
        u.DrawTileClipped(texture'DeusExUI.HUDWindowBackground_Right',30,h, 1,0,31,8);
        //BR
        u.SetPos(0, u.ClipY-16);
        u.DrawTileClipped(texture'DeusExUI.HUDWindowBackground_BR',30,16, 1,0,31,16);

        //u.SetOrigin(int((u.SizeX-w)/2), int((u.SizeY-h)/2));
        u.SetOrigin(i_FrameBG.ActualLeft() + 20,i_FrameBG.ActualTop() - 80);
        u.SetClip(w, h);

   if (DeusExPlayerController(PlayerOwner()).bHUDBordersVisible)
   {
     if (DeusExPlayerController(PlayerOwner()).bHUDBordersTranslucent)
        u.Style = eMenuRenderStyle.MSTY_Translucent;
        else
        u.Style = eMenuRenderStyle.MSTY_Alpha;

        u.DrawColor = InfoLinkFrame;

        u.SetPos(-14,-16);
        border = texture'DeusExUI.HUDWindowBorder_TL';
        u.DrawTile(border,64,16, 0,0,64,16);

        u.SetPos(-14,0);
        border = texture'DeusExUI.HUDWindowBorder_Left';
        u.DrawTile(border,64,h, 0,0,64,8);

        u.SetPos(-14, u.ClipY);
        border = texture'DeusExUI.HUDWindowBorder_BL';
        u.DrawIcon(border,1.0);

        u.SetPos(50,-16);
        border = texture'DeusExUI.HUDWindowBorder_Top';
        u.DrawTile(border,w-52,16, 0,0,8,16);


        u.SetPos(50,u.ClipY);
        border = texture'DeusExUI.HUDWindowBorder_Bottom';
        u.DrawTile(border,w-52,16, 0,0,8,16);

        u.SetPos(u.ClipX-3,-16);
        border = texture'DeusExUI.HUDWindowBorder_TR';
        u.DrawIcon(border,1.0);

        u.SetPos(u.OrgX+u.ClipX-3,u.OrgY);
        border = texture'DeusExUI.HUDWindowBorder_Right';
        u.DrawTileStretched(border,32,h);

        u.SetPos(u.ClipX-3, u.ClipY);
        border = texture'DeusExUI.HUDWindowBorder_BR';
        u.DrawIcon(border,1.0);
   }

        u.Style=1;
        u.DrawColor = InfoLinkTitles;
        //u.SetOrigin(int((u.SizeX-w)/2), int((u.SizeY-h)/2));
        u.SetOrigin(i_FrameBG.ActualLeft() + 20,i_FrameBG.ActualTop() - 80);
        u.SetClip(w, h);
        u.SetPos(0,0);

        dxc.DrawTextJustified(infoBuffer,0,0,0,u.ClipX,u.ClipY);

        u.SetOrigin(u.OrgX, u.OrgY+8);

        for(x=0; x<ReceivedItems.length; x++)
        {
          if (ReceivedItems[x].anItem != None)
          {
            u.Style = 2;
            //u.SetPos(60+40*x, 0);
            u.SetPos(60+80*x, 0);
            if (ReceivedItems[x].anItem.isA('DeusExPickup'))
            {
                u.SetDrawColor(255,255,255); // Исправлено, иконки были залиты текущим цветом.
                ico = DeusExPickup(ReceivedItems[x].anItem).default.Icon;
                u.DrawIconEx(ico,1.0);
                u.Style=1;
                u.DrawColor = InfoLinkText;
                //dxc.DrawTextJustified(DeusExPickup(ReceivedItems[x].anItem).default.beltDescription,1,60+40*x,48,100+40*x,58);
                dxc.DrawTextJustified(DeusExPickup(ReceivedItems[x].anItem).default.beltDescription $"["$ ReceivedItems[x].anItemCount $"]",1,60+80*x,48,100+80*x,58);
            }
            if (ReceivedItems[x].anItem.isA('DeusExWeapon'))
            {
                u.SetDrawColor(255,255,255); // Исправлено, иконки были залиты текущим цветом.
                ico = DeusExWeapon(ReceivedItems[x].anItem).default.Icon;
                u.DrawIconEx(ico,1.0);
                u.Style=1;
                u.DrawColor = InfoLinkText;
                //dxc.DrawTextJustified(DeusExWeapon(ReceivedItems[x].anItem).default.beltDescription,1,60+40*x,48,100+40*x,58);
                dxc.DrawTextJustified(DeusExWeapon(ReceivedItems[x].anItem).default.beltDescription $"["$ ReceivedItems[x].anItemCount $"]",1,60+80*x,48,100+80*x,58);
            }
            if (ReceivedItems[x].anItem.isA('DeusExAmmo'))
            {
                u.SetDrawColor(255,255,255); // Исправлено, иконки были залиты текущим цветом.
                ico = DeusExAmmo(ReceivedItems[x].anItem).default.Icon;
                u.DrawIconEx(ico,1.0);
                u.Style=1;
                u.DrawColor = InfoLinkText;
                //dxc.DrawTextJustified(DeusExWeapon(ReceivedItems[x].anItem).default.beltDescription,1,60+40*x,48,100+40*x,58);
                dxc.DrawTextJustified(DeusExAmmo(ReceivedItems[x].anItem).default.beltDescription $"["$
                                                 ReceivedItems[x].anItemCount * DeusExAmmo(ReceivedItems[x].anItem).default.AmmoAmount $"]",1,60+80*x,48,100+80*x,58);
            }
          }
        }
    u.reset();
    u.SetClip(u.sizeX,u.sizeY);
}

function RenderExtraStuff(canvas u)
{
    u.SetOrigin(self.ActualLeft(), self.ActualTop());
    u.SetClip(self.ActualWidth(), self.ActualHeight());
    u.font = font'dxFonts.MSS_10';

    if ((DeusExPlayer(playerOwner().pawn) != None) && (bRenderPlayerCredits))
    {
        u.Style = eMenuRenderStyle.MSTY_Alpha;
        u.SetDrawColor(1,1,1,128); // RGB Alpha
        u.SetPos(i_FrameBG2.ActualLeft(),i_FrameBG2.ActualTop() + i_FrameBG2.ActualHeight());
        u.DrawTileStretched(texture'Engine.BlackTexture', 200, 20);

        u.SetDrawColor(128,255,128,255); // RGB Alpha
        u.SetPos(4 + i_FrameBG2.ActualLeft(),i_FrameBG2.ActualTop() + i_FrameBG2.ActualHeight());
        u.DrawText(strPlayerCredits$DeusExPlayer(playerOwner().pawn).Credits);
    }
}

function SetSpeechTextColor(color NewColor)
{
    local int x;

    if ((WinSpeech != None) && (WinSpeech.Style != None))
    {
        for(x=0; x<5; x++)
            WinSpeech.Style.FontColors[x] = NewColor;
    }
}

function ShowReceivedItem(Inventory invItem, int count)
{
    local int x;

    x = ReceivedItems.length;
    ReceivedItems.length = x + 1; // добавить 1 к длине массива
    ReceivedItems[x].anItem = invItem; // присвоить данные к элементу массива
    ReceivedItems[x].anItemCount = count;
}

function bool InternalOnClick(GUIComponent Sender)
{
    local int buttonIndex;

    // Abort if we're restricting input
    if (bRestrictInput)
        return true;

    // Restrict input again until we've finished processing this choice
    bRestrictInput = true;

    // Take a look to make sure it's one of our buttons before continuing.
    for (buttonIndex=0; buttonIndex<numChoices; buttonIndex++)
    {
        if (sender == conChoices[buttonIndex])
        {
            conPlay.PlayChoice(ConChoice(conChoices[buttonIndex].GetUserObject()));
            ShowChoiceAsSpeech(ConChoice(conChoices[buttonIndex].GetUserObject()).ChoiceText);

//            UnhideControls(); //

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
    ReceivedItems.Length = 0; // DXR: Hide "Received:" overlay first.
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
    strPlayerCredits="Credits: "

    OnCanClose=CanCloseWindow
    OnPreDraw=InternalOnPreDraw
    OnKeyEvent=ConWindowActive.InternalOnKeyEvent
    OnMouseRelease=ConWindowActive.InternalOnMouseRelease

//    colConTextFocus=(R=255,G=255,B=0,A=255)
//    colConTextChoice=(R=0,G=0,B=255,A=255)
    colConTextFocus=(R=255,G=255,B=255,A=255)
    colConTextChoice=(R=14,G=52,B=88,A=255)
    colConTextChoiceUnhighlighted=(R=0,G=152,B=188,A=255)
    colConTextSkill=(R=255,G=0,B=0,A=255)

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

    ChoiceBeginningChar="  "
    //movePeriod=0.60
    movePeriod=0.30

    Begin Object class=GUIScrollTextBox Name=MySubTitles
        RenderWeight=0.8
        WinWidth=0.98
        WinHeight=0.18
        WinLeft=0.01
        WinTop=0.806667
        TabOrder=2
        bVisibleWhenEmpty=false
        bNoTeletype=false
        CharDelay=0.005
        EOLDelay=0.75
        RepeatDelay=3.0
        StyleName="STY_DXR_DXSubTitles"
        FontScale=FNS_Small
        TextAlign=TXTA_Left
    End Object
    winSpeech=MySubtitles

    Begin Object Class=GUILabel Name=MySpeaker
        Caption=""
        bMultiLine=true
        TextAlign=TXTA_Right
        TextColor=(B=255,G=255,R=255)
        FontScale=FNS_Small
        StyleName="STY_DXR_ConLabel"
        WinLeft=2.00
        WinTop=0.806667
        WinWidth=20.00 //0.200000
        WinHeight=0.18
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
