/* 
   Keypad interface
*/

class DXR_KeyPad extends DxWindowTemplate;

var bool bFirstFrameDone;

const AMOUNT_OF_KEYPAD_KEYS = 12;

var HUDKeypadButton btnKeys[AMOUNT_OF_KEYPAD_KEYS];
var GUIEditBox winText;
var GUIImage keyPadFrame;
var string inputCode;

var bool bInstantSuccess;       // we had the skill, so grant access immediately
var bool bWait;

var Keypad keypadOwner;         // what keypad owns this window?

// Border and Background Translucency
var bool bBorderTranslucent;
var bool bBackgroundTranslucent;
var bool bDrawBorder;

// Default Colors
var Color colBackground;
var Color colBorder;
var Color colHeaderText;

var localized string msgEnterCode;
var localized string msgAccessDenied;
var localized string msgAccessGranted;

var DeusExPlayer player; // Pointer to DeusExPlayer

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.InitComponent(MyController, MyOwner);

    player = DeusExPlayer(PlayerOwner().pawn); // Assign pointer to DeusExPlayer
    keypadOwner = keypad(player.frobTarget); // ... to KeyPad
    bInstantSuccess = keypadOwner.bWasHacked;
    CreateKControls();
}

function CreateKControls()
{
    winText = new(none) class'GUIEditBox';
    winText.FontScale = FNS_Small;
    winText.bBoundToParent = true;
    winText.bReadOnly = true;
    winText.winHeight = 15;
    winText.winWidth = 75;
    winText.winLeft = 17;
    winText.winTop = 19;
    winText.StyleName = "STY_DXR_EditBox_NoBG";
    AppendComponent(winText, true);

    keyPadFrame = new(none) class'GUIImage';
    keyPadFrame.bBoundToParent = true;
    keyPadFrame.image = Texture'DeusExUI.UserInterface.HUDKeypadBorder';
    keyPadFrame.ImageRenderStyle = MSTY_Translucent;
    keyPadFrame.WinHeight = 166;
    keyPadFrame.WinWidth = 109;
    keyPadFrame.WinLeft = 0;
    keyPadFrame.WinTop = 0;
    AppendComponent(keyPadFrame, true);

    inputCode="";

    CreateKeypadButtons();
}

function CreateKeypadButtons()
{
    local int i, x, y;

    for (y=0; y<4; y++)
    {
        for (x=0; x<3; x++)
        {
            i = x + y * 3;
            btnKeys[i] = new(none) class'HUDKeypadButton';
            btnKeys[i].WinLeft = (x * 26) + 16;
            btnKeys[i].WinTop = (y * 28) + 35;
            btnKeys[i].OnClick = InternalOnClick;
            btnKeys[i].num = i;
            btnKeys[i].caption = IndexToString(i);
            AppendComponent(btnKeys[i], true);
        }
    }
}


event Opened(GUIComponent Sender)                   // Called when the Menu Owner is opened
{
    Super.Opened(Sender);

    GenerateKeypadDisplay();
    winText.SetText(msgEnterCode);
    DeusExHud(PlayerOwner().myHUD).bDrawFrobBox = false;
}

event Closed(GUIComponent Sender, bool bCancelled)  // Called when the Menu Owner is closed
{
    super.Closed(Sender, bCancelled);
    DeusExHud(PlayerOwner().myHUD).bDrawFrobBox = true;
    KeyPadOwner = none;
}

event free()
{
    super.free();
    DeusExHud(PlayerOwner().myHUD).bDrawFrobBox = true;
    KeyPadOwner = none;
}

function bool AlignFrame(Canvas C)
{
    if (bVisible)
        winleft = (controller.resX/2) - (MaxPageWidth/2);

  winTop = 0.400;

  /*  ак и Tick(), UCanvas рисуетс€ каждый кадр, подставлю пока сюда... */
    if (!bFirstFrameDone)
    {
//      SetCursorPos(width, height);
        bFirstFrameDone = True;

        if (bInstantSuccess)
        {
            inputCode = keypadOwner.validCode;
            ValidateCode();
        }
    }
    return bInit;
}


// From DeusEx\PlayerInterfacePanel.uc
function ApplyTheme()
{
  local int i;

  for (i=0;i<Controls.Length;i++)
  {
     if ((controls[i].IsA('GUIImage')) && (controls[i].tag == 75))
     {
         if (class'DXR_Menu'.static.GetBackgoundMode(gl.MenuThemeIndex) == 0) // STY_Normal
         {
             GUIImage(controls[i]).ImageRenderStyle = eMenuRenderStyle.MSTY_Normal;
             GUIImage(controls[i]).ImageColor = class'DXR_Menu'.static.GetPlayerInterfaceBG(gl.MenuThemeIndex);
             GUIImage(controls[i]).ImageColor.A = 255;
         }
       else
         if (class'DXR_Menu'.static.GetBackgoundMode(gl.MenuThemeIndex) == 1)
         {
             GUIImage(controls[i]).ImageRenderStyle = eMenuRenderStyle.MSTY_Translucent;
             GUIImage(controls[i]).ImageColor = class'DXR_Menu'.static.GetPlayerInterfaceBG(gl.MenuThemeIndex);
             GUIImage(controls[i]).ImageColor.A = 255;
         }
       else 
          if (class'DXR_Menu'.static.GetBackgoundMode(gl.MenuThemeIndex) == 2)
          {
              GUIImage(controls[i]).ImageRenderStyle = eMenuRenderStyle.MSTY_Additive;
              GUIImage(controls[i]).ImageColor = class'DXR_Menu'.static.GetPlayerInterfaceBG(gl.MenuThemeIndex);
              GUIImage(controls[i]).ImageColor.A = 255;
          }
       else 
          if (class'DXR_Menu'.static.GetBackgoundMode(gl.MenuThemeIndex) == 3)
          {
              GUIImage(controls[i]).ImageRenderStyle = eMenuRenderStyle.MSTY_Alpha;
              GUIImage(controls[i]).ImageColor = class'DXR_Menu'.static.GetPlayerInterfaceBG(gl.MenuThemeIndex);
              GUIImage(controls[i]).ImageColor.A = class'DXR_Menu'.static.GetAlpha(gl.MenuThemeIndex);
          }
     }
  }
}


function bool InternalOnClick(GUIComponent Sender)
{
    local bool bHandled;
    local int i;

    bHandled = false;

    for (i=0; i<AMOUNT_OF_KEYPAD_KEYS; i++)
    {
        if (Sender==btnKeys[i])
        {
            PressButton(i);
            bHandled = true;
            break;
        }
    }
    return bHandled;
}

/* ¬вод с клавиатуры (дл€ клавиатуры :)))) ) */
function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{
    local bool bKeyHandled;
    local Interactions.EInputKey iKey;

    iKey = EInputKey(Key);

    bKeyHandled = true;

        switch(iKey)
        {   
            case IK_0:
            case IK_NUMPAD0:
                      if (State == 1)
                      {
                        InternalOnClick(btnKeys[10]);
                        btnKeys[10].MenuState = MSAT_Pressed; // Ёмул€ци€ нажати€ кнопки мышью ))
                      }
                      else
                        btnKeys[10].MenuState = MSAT_Watched;
            break;

            case IK_1:
            case IK_NUMPAD1:
                      if (State == 1)
                      {
                        InternalOnClick(btnKeys[0]);
                        btnKeys[0].MenuState = MSAT_Pressed;
                      }
                      else
                        btnKeys[0].MenuState = MSAT_Watched;
             break;

            case IK_2:
            case IK_NUMPAD2:
                      if (State == 1)
                      {
                                InternalOnClick(btnKeys[1]);
                                btnKeys[1].MenuState = MSAT_Pressed;
                      }
                      else
                        btnKeys[1].MenuState = MSAT_Watched;
             break;

            case IK_3:
            case IK_NUMPAD3:
                      if (State == 1)
                      {
                        InternalOnClick(btnKeys[2]);
                        btnKeys[2].MenuState = MSAT_Pressed;
                            }
                            else
                        btnKeys[2].MenuState = MSAT_Watched;
             break;

            case IK_4:
            case IK_NUMPAD4:
                            if (State == 1)
                      {
                        InternalOnClick(btnKeys[3]);
                        btnKeys[3].MenuState = MSAT_Pressed;
                            }
                            else
                        btnKeys[3].MenuState = MSAT_Watched;
             break;

            case IK_5:
            case IK_NUMPAD5:
                      if (State == 1)
                      {
                                InternalOnClick(btnKeys[4]);
                                btnKeys[4].MenuState = MSAT_Pressed;
                            }
                            else
                        btnKeys[4].MenuState = MSAT_Watched;
             break;

            case IK_6:
            case IK_NUMPAD6:
                      if (State == 1)
                      {
                                InternalOnClick(btnKeys[5]);
                                btnKeys[5].MenuState = MSAT_Pressed;
                            }
                            else
                        btnKeys[5].MenuState = MSAT_Watched;
             break;

            case IK_7:
            case IK_NUMPAD7:
                            if (State == 1)
                      {
                                InternalOnClick(btnKeys[6]);
                                btnKeys[6].MenuState = MSAT_Pressed;
                            }
                            else
                        btnKeys[6].MenuState = MSAT_Watched;
             break;

            case IK_8:
            case IK_NUMPAD8:
                            if (State == 1)
                      {
                                InternalOnClick(btnKeys[7]);
                                btnKeys[7].MenuState = MSAT_Pressed;
                            }
                            else
                        btnKeys[7].MenuState = MSAT_Watched;
             break;

            case IK_9:
            case IK_NUMPAD9:
                            if (State == 1)
                      {
                                InternalOnClick(btnKeys[8]);
                                btnKeys[8].MenuState = MSAT_Pressed;
                            }
                            else
                        btnKeys[8].MenuState = MSAT_Watched;
             break;

            default:
                bKeyHandled = false;
        }
        return bKeyHandled;
}

// User pressed a keypad button
function PressButton(int num)
{
    local sound tone;

    if (bWait)
        return;

    if (Len(inputCode) < 16)
    {
        inputCode = inputCode $ IndexToString(num);
        switch (num)
        {
            case 0:     tone = sound'Touchtone1'; break;
            case 1:     tone = sound'Touchtone2'; break;
            case 2:     tone = sound'Touchtone3'; break;
            case 3:     tone = sound'Touchtone4'; break;
            case 4:     tone = sound'Touchtone5'; break;
            case 5:     tone = sound'Touchtone6'; break;
            case 6:     tone = sound'Touchtone7'; break;
            case 7:     tone = sound'Touchtone8'; break;
            case 8:     tone = sound'Touchtone9'; break;
            case 9:     tone = sound'Touchtone10'; break;
            case 10:    tone = sound'Touchtone0'; break;
            case 11:    tone = sound'Touchtone11'; break;
        }
        player.PlaySound(tone, SLOT_Interface);
    }

    GenerateKeypadDisplay();
    winText.SetText("€€€"$msgEnterCode);

    if (Len(inputCode) == Len(keypadOwner.validCode))
        ValidateCode();
}


// Convert the numbered button to a character
function string IndexToString(int num)
{
    local string str;

    // buttons 0-8 are ok as is (text 1-9)
    // button 9 is *
    // button 10 is 0
    // button 11 is #
    switch (num)
    {
        case 9:     str = "*"; break;
        case 10:    str = "0"; break;
        case 11:    str = "#"; break;
        default:    str = String(num+1); break;
    }

    return str;
}

// Generate the keypad's display
function GenerateKeypadDisplay()
{
    local int i;

    msgEnterCode = "";

    for (i=0; i<Len(keypadOwner.validCode); i++)
    {
        if (i == Len(inputCode))
       msgEnterCode = msgEnterCode $ "_€";
      msgEnterCode = msgEnterCode $ "*";
    }
}

function SetGrayColor()
{
   if (KeyPadOwner != None)
       KeyPadOwner.SetLampColor(0);
}

function SetYellowColor()
{
   if (KeyPadOwner != None)
       KeyPadOwner.SetLampColor(1);
}

function SetRedColor()
{
   if (KeyPadOwner != None)
       KeyPadOwner.SetLampColor(2);
}

function SetGreenColor()
{
   if (KeyPadOwner != None)
       KeyPadOwner.SetLampColor(3);
}



function ValidateCode()
{
    local Actor A;
    local int i;

    if (inputCode == keypadOwner.validCode)
    {
        if (keypadOwner.Event != '')
        {
            if (keypadOwner.bToggleLock)
            {
                // Toggle the locked/unlocked state of the DeusExMover
                foreach player.AllActors(class 'Actor', A, keypadOwner.Event)
                    if (A.IsA('DeusExMover'))
                        DeusExMover(A).bLocked = !DeusExMover(A).bLocked;
            }
            else
            {
                // Trigger the successEvent
                foreach player.AllActors(class'Actor', A, keypadOwner.Event)
                    A.Trigger(keypadOwner, player);
            }
        }

        // UnTrigger event (if used)
        for (i=0; i<ArrayCount(keypadOwner.UnTriggerEvent); i++)
            if (keypadOwner.UnTriggerEvent[i] != '')
                foreach player.AllActors(class 'Actor', A, keypadOwner.UnTriggerEvent[i])
                    A.UnTrigger(keypadOwner, player);

        SetGreenColor(); // ”спешно, зелена€ лампочка
        player.PlaySound(keypadOwner.successSound, SLOT_None);
        winText.SetText("_€_"$msgAccessGranted);
    }
    else
    {
        // Trigger failure event
        if (keypadOwner.FailEvent != '')
            foreach player.AllActors(class 'Actor', A, keypadOwner.FailEvent)
                A.Trigger(keypadOwner, player);

        SetRedColor(); // Ќеудачный ввод, красна€ лампочка
        player.PlaySound(keypadOwner.failureSound, SLOT_None);
        winText.SetText("€_"$msgAccessDenied);
    }                      

    bWait = True;
    SetTimer(1.0, false);
}

function Timer()
{
    bWait = False;

    // if we entered a valid code, get out
    if (inputCode == keypadOwner.validCode)
        Controller.CloseMenu();
    else
    {
        inputCode = "";
        GenerateKeypadDisplay();
        winText.SetText("€€€"$msgEnterCode);
    }
}


defaultproperties
{
    msgEnterCode=""
    msgAccessDenied="DENIED"
    msgAccessGranted="GRANTED"

    winHeight=162
    winWidth=103

    MaxPageHeight=162
    MaxPageWidth=103
    MinPageHeight=162
    MinPageWidth=103

    OnKeyEvent=InternalOnKeyEvent

    Begin Object Class=FloatingImage Name=FloatingFrameBackground
        Image=texture'DeusExUI.UserInterface.HUDKeypadBackground'
        ImageRenderStyle=MSTY_Translucent
        ImageStyle=ISTY_Tiled
        ImageColor=(R=255,G=255,B=255,A=255)
        DropShadow=None
        WinWidth=103
        WinHeight=162
        WinLeft=0
        WinTop=0
        RenderWeight=0.000003
        bBoundToParent=True
        bScaleToParent=True
        Tag=75
    End Object
    i_FrameBG=FloatingFrameBackground
  /* «аголовок */
    Begin Object Class=GUIHeader Name=TitleBar
        WinWidth=0.0
        WinHeight=0.0
        WinLeft=0
        WinTop=0
        RenderWeight=0.01
        FontScale=FNS_Small
        bUseTextHeight=false
        bAcceptsInput=True
        bNeverFocus=true //False
        bBoundToParent=true
        bScaleToParent=true
    OnRendered=none
        ScalingType=SCALE_ALL
    StyleName=""
    Justification=TXTA_Left
    End Object
    t_WindowTitle=TitleBar
}
