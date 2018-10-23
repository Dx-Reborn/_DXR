/**/
class HackWin extends ComputerUIWindow;

var GUILabel winHackMessage,winDigits;
var GUIButton btnHack;
var GUIProgressBar barHackProgress;

//var NetworkTerminal winTerm;
// Text
var localized String HackButtonLabel,ReturnButtonLabel,HackReadyLabel,HackInitializingLabel,HackSuccessfulLabel,HackDetectedLabel;
var float detectionTime,saveDetectionTime,hackTime,saveHackTime,blinkTimer,digitUpdateTimer,hackDetectedDelay;
var bool bHacking,bHacked,bHackDetected,bHackDetectedNotified,bTickEnabled;

//var(fineTweak) float frCorrectorX, frCorrectorY;

var int    digitWidth;
var String digitStrings[4];
var String digitFillerChars;
var Color  colDigits;
var Color  colRed;

// Defaults
var Texture texBackground;
var Texture texBorder;


function CreateMyControls()
{
  winDigits = new(none) class'GUILabel';
  winDigits.bBoundToParent = true;
  winDigits.TextColor = class'Canvas'.static.MakeColor(0, 128, 0);
  winDigits.caption = "";
  winDigits.TextFont="UT2ircFont";
  winDigits.bMultiLine = true;
  winDigits.TextAlign = TXTA_Center;
  winDigits.VertAlign = TXTA_Center;
  winDigits.FontScale = FNS_Small;
 	winDigits.WinHeight = 32;
  winDigits.WinWidth = 169;
  winDigits.WinLeft = 16;
  winDigits.WinTop = 40;
  AppendComponent(winDigits, true);

	barHackProgress = new(none) class'GUIProgressBar';
  barHackProgress.FontName="UT2HeaderFont";
 	barHackProgress.WinHeight = 15;
  barHackProgress.WinWidth = 171;
  barHackProgress.WinLeft = 15;
  barHackProgress.WinTop = 76;
  barHackProgress.High = 100;
	barHackProgress.CaptionWidth = 0.0;
  barHackProgress.bBoundToParent = true;
  barHackProgress.bShowLow = true;
  barHackProgress.bShowHigh = true;
  barHackProgress.ValueRightWidth = 0.0;
  barHackProgress.Value = 100;
  barHackProgress.Caption = "test";
  barHackProgress.BarBack = Material'MenuTitleBubble_Center'; // The unselected portion of the bar
  barHackProgress.BarTop = Material'Solid'; // The selected portion of the bar
//  barHackProgress.OnRendered = pr_OnRendered;
  barHackProgress.BarColor = class'Actor'.static.GetColorScaled(barHackProgress.Value * 0.01);
	AppendComponent(barHackProgress, true);

  btnHack = new(none) class'GUIButton';
  btnHack.WinHeight = 19;
  btnHack.WinWidth = 88;
  btnHack.WinLeft = 14;
  btnHack.WinTop = 93;
  btnHack.StyleName = "STY_DXR_ButtonNavbar";
  btnHack.Caption = HackButtonLabel;
  btnHack.OnClick = InternalOnClick;
  AppendComponent(btnHack, true);

  winHackMessage = new(none) class'GUILabel';
  winHackMessage.bBoundToParent = true;
  winHackMessage.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  winHackMessage.caption = HackReadyLabel;
  winHackMessage.TextFont="UT2HeaderFont";
  winHackMessage.bMultiLine = true;
  winHackMessage.TextAlign = TXTA_Center;
  winHackMessage.VertAlign = TXTA_Center;
  winHackMessage.FontScale = FNS_Small;
 	winHackMessage.WinHeight = 48;
  winHackMessage.WinWidth = 169;
  winHackMessage.WinLeft = 16;
  winHackMessage.WinTop = 26;
  AppendComponent(winHackMessage, true);
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{
	local bool bKeyHandled;
	local Interactions.EInputKey iKey;

	iKey = EInputKey(Key);
	bKeyHandled = true;
		switch(iKey)
		{
			case IK_ESCAPE:
       if (State == 1)
       {
        winTerm.ForceCloseScreen();	
        Controller.CloseAll(false, true);
       }
			break;
			default:
				bKeyHandled = false;
		}
		return bKeyHandled;
}

function bool InternalOnClick(GUIComponent Sender)
{
	if (Sender==btnHack)
	{
		if (winTerm != None)
		{
			if (bHacked)
				winTerm.ComputerHacked();
			else
				StartHack();
			btnHack.DisableMe();
		}
	}
	return false;
}

function StartHack()
{
	bHacking     = True;
	bTickEnabled = True;

	// Display hack message
	WinHackMessage.Caption = HackInitializingLabel;
}

function UpdateDigits()
{
	local bool bSpace;
	local int stringIndex;

	// First move down the existing strings

	for(stringIndex=arrayCount(digitStrings)-1; stringIndex>0;	stringIndex--)
		digitStrings[stringIndex] = digitStrings[stringIndex-1];
	
	// Now fill the string.  As we get closer to detection time, 
	// will fill with more characters
	
	digitStrings[0] = "";

	for(stringIndex=0; stringIndex<digitWidth; stringIndex++)
	{
		// Calculate chance that this is a space
		bSpace = ((saveHackTime - hackTime) / saveHackTime) > FRand();

		if (bSpace)
			digitStrings[0] = digitStrings[0] $ " ";
		else
			digitStrings[0] = digitStrings[0] $ Mid(digitFillerChars, Rand(Len(digitFillerChars)) + 1, 1);
	}

	winDigits.Caption="";

	for(stringIndex=0; stringIndex<arrayCount(digitStrings); stringIndex++)
	{
		winDigits.Caption $= digitStrings[stringIndex];
		if (stringIndex - 1 == arrayCount(digitStrings))
			winDigits.Caption $= "|";
	}
}

function UpdateHackBar()
{
	local float percentRemaining;

	percentRemaining = (detectionTime / saveDetectionTime) * 100.0;
	barHackProgress.Value = percentRemaining;
	// Äîáàâëåíî
  barHackProgress.BarColor = class'Actor'.static.GetColorScaled(percentRemaining * 0.01);
}

function SetDetectionTime(float newDetectionTime, float newHackTime)
{
	// The detection time is how long it takes before the user is 
	// caught and electrified.  This now includes the Hack time to 
	// give the player the perception that he's being tracked 
	// immediately (a little more tense).  When in reality he has the 
	// same amount of "detection" time (once hacked) as before.

	detectionTime     = newDetectionTime + newHackTime;
	saveDetectionTime = detectionTime;

	// Hack time is also based on skill
	hackTime      = newHackTime;
	saveHackTime  = hackTime;
}



function InternalOnRendered(canvas u)
{
 local float deltaTime;
 local int x,y;

  x = ActualLeft(); y = ActualTop();
  u.SetPos(x - 6, y + 8);
  u.Style = eMenuRenderStyle.MSTY_Translucent;
  u.SetDrawColor(255,255,255);
  u.DrawIcon(texture'ComputerHackBorder', 1);


 if (!bTickEnabled)
 return;

 deltaTime = Controller.renderdelta;

 	if (bHacking)	// manage initial hacking
	{
		hackTime         -= deltaTime;
		blinkTimer       -= deltaTime;
		digitUpdateTimer -= deltaTime;

		// Update blinking text
		if (blinkTimer < 0)
		{
			if (winHackMessage.Caption == "")
			{
				blinkTimer = default.blinkTimer;
				winHackMessage.Caption = HackInitializingLabel;
			}
			else
			{
				blinkTimer = default.blinkTimer / 3;
				winHackMessage.Caption = "";
			}
		}

		// Update scrolling text
		if (digitUpdateTimer < 0)
		{
			digitUpdateTimer = default.digitUpdateTimer;
			UpdateDigits();
		}

		if (hackTime < 0)
		{
			bHacking = False;
			FinishHack();
		}	
	}
	
	if (bHackDetected)
	{
		detectionTime -= deltaTime;
		blinkTimer    -= deltaTime;

		// Update blinking text
		if (blinkTimer < 0)
		{
			if (winHackMessage.Caption == "")
			{
				blinkTimer = default.blinkTimer;
				winHackMessage.Caption = HackDetectedLabel;
			}
			else
			{
				blinkTimer = default.blinkTimer / 3;
				winHackMessage.Caption = "";
			}
		}

		if (detectionTime < 0)
		{
			if (winTerm != None)
			{
				bHackDetectedNotified = true;
				winTerm.HackDetected();
			}
		}
	}
	else
	{
		// manage detection
		detectionTime -= deltaTime;

		// Update the progress bar
		UpdateHackBar();

		if (detectionTime < 0)
		{
			detectionTime = 0;
			bTickEnabled = false;
			HackDetected();
		}
	}
}

function FinishHack()
{
	bHacked = True;

	// Display hack message
	winHackMessage.caption = HackSuccessfulLabel;

	winDigits.caption = "";

	if (winTerm != None)
		winTerm.ComputerHacked();
}

function HackDetected()
{
	bHackDetected = true;
	blinkTimer    = default.blinkTimer;
	detectionTime = hackDetectedDelay;
	bTickEnabled  = true;
	winHackMessage.Caption = HackDetectedLabel;
	winHackMessage.TextColor = colRed; //class'Canvas'.static.MakeColor(255, 255, 255);//SetTextColor(colRed);
}

function float GetSaveDetectionTime()
{
	return saveDetectionTime;
}

function UpdateDetectionTime(float newDetectionTime)
{
	detectionTime = newDetectionTime;

	// Update the progress bar
	UpdateHackBar();
}

function SetHackButtonToReturn()
{
	btnHack.EnableMe();//SetSensitivity(True);
	btnHack.Caption = ReturnButtonLabel;
}

function SetNetworkTerminal(NetworkTerminal newTerm)
{
	winTerm = newTerm;
}


function bool AlignFrame(Canvas C)
{

  winLeft = controller.ResX - 206;
  winTop = 0;

  bVisible=true;

	return bInit;
}

//event Opened(GUIComponent Sender);                   // Called when the Menu Owner is opened

event Closed(GUIComponent Sender, bool bCancelled)  // Called when the Menu Owner is closed
{
 	if ((bHackDetected) && (!bHackDetectedNotified) && (winTerm != None))
		winTerm.HackDetected(true);
		winTerm.ForceCloseScreen();

		super.Closed(Sender, bCancelled);
}

function bool OnCanClose(optional Bool bCancelled)
{
    return false;
}


defaultproperties
{
    blinkTimer=1.00
    digitUpdateTimer=0.05
    hackDetectedDelay=3.00
    digitWidth=23
    digitFillerChars="ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ01234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()_+-=][}{"
    colDigits=(R=0,G=128,B=0,A=255)
    colRed=(R=255,G=0,B=0,A=255)
    texBackground=Texture'DeusExUI.UserInterface.ComputerHackBackground'
    texBorder=Texture'DeusExUI.UserInterface.ComputerHackBorder'
    HackButtonLabel="Hack"
    ReturnButtonLabel="Return"
    HackReadyLabel="Ice Breaker Ready..."
    HackInitializingLabel="Initializing ICE Breaker..."
    HackSuccessfulLabel="ICE Breaker Hack Successful..."
    HackDetectedLabel="*** WARNING ***|INTRUDER DETECTED!"
    OnRendered=InternalOnRendered
		OnKeyEvent=InternalOnKeyEvent
    openSound=none

 	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Texture'DeusExUI.UserInterface.ComputerHackBackground'
		ImageRenderStyle=MSTY_Normal
		ImageStyle=ISTY_Tiled
		ImageColor=(R=255,G=255,B=255,A=255)
		DropShadow=None
		WinWidth=190
		WinHeight=98
		WinLeft=8
		WinTop=20
		RenderWeight=0.000003
		bBoundToParent=True
		bScaleToParent=True
	End Object
	i_FrameBG=FloatingFrameBackground
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