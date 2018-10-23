/**/
class ComputerScreenSpecialOptions extends ComputerUIWindow;

struct S_OptionButtons
{
	var int specialIndex;
	var SpecialOptionsButton btnSpecial;
};

var S_OptionButtons optionButtons[4];

var GUIButton btnReturn, btnLogout;
var GUILabel winSpecialInfo, winStatus;

var DeusExPlayer player;

var() int buttonLeftMargin;
var() int firstButtonPosY;
var() int specialOffsetY;
var() int statusPosYOffset;
var() int TopTextureHeight;
var() int MiddleTextureHeight;
var() int BottomTextureHeight;
var() int ButtonHeight; // new in DXR

var localized String SecurityButtonLabel, ButtonLabelLogout;
var localized String EmailButtonLabel;

// ----------------------------------------------------------------------
// CreateControls()
// ----------------------------------------------------------------------

function CreateMyControls()
{
  player = DeusExPlayer(playerOwner().pawn);

  winSpecialInfo = new(none) class'GUILabel';
  winSpecialInfo.bBoundToParent = true;
  winSpecialInfo.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  winSpecialInfo.caption = "";
  winSpecialInfo.TextFont="UT2ircFont";
  winSpecialInfo.bMultiLine = true;
  winSpecialInfo.TextAlign = TXTA_Left;
  winSpecialInfo.VertAlign = TXTA_Center;
  winSpecialInfo.FontScale = FNS_Small;
 	winSpecialInfo.WinHeight = 27;
  winSpecialInfo.WinWidth = 489;
  winSpecialInfo.WinLeft = 13;
  winSpecialInfo.WinTop = 47;
  AppendComponent(winSpecialInfo, true);

  winStatus = new(none) class'GUILabel';
  winStatus.bBoundToParent = true;
  winStatus.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  winStatus.caption = "";
  winStatus.TextFont="UT2ircFont";
  winStatus.bMultiLine = true;
  winStatus.TextAlign = TXTA_Left;
  winStatus.VertAlign = TXTA_Center;
  winStatus.FontScale = FNS_Small;
 	winStatus.WinHeight = 20;
  winStatus.WinWidth = 491;
  winStatus.WinLeft = 13;
  winStatus.WinTop = 247;
  AppendComponent(winStatus, true);

	btnLogout = new(none) class'GUIButton';
  btnLogout.bBoundToParent = true;
  btnLogout.OnClick = InternalOnClick;
  btnLogout.FontScale = FNS_Small;
  btnLogout.Caption = ButtonLabelLogout;
  btnLogout.StyleName = "STY_DXR_MediumButton";
  btnLogout.OnClick = InternalOnClick;
  btnLogout.WinHeight = 21;
  btnLogout.WinWidth = 144;
  btnLogout.WinLeft = 218;
  btnLogout.WinTop = 276;
  AppendComponent(btnLogout, true);

/*	Super.CreateControls();

	btnLogout = winButtonBar.AddButton(ButtonLabelLogout, HALIGN_Right);

	CreateSpecialInfoWindow();*/
}

// ----------------------------------------------------------------------
// SetNetworkTerminal()
// ----------------------------------------------------------------------

function SetNetworkTerminal(NetworkTerminal newTerm)
{
	Super.SetNetworkTerminal(newTerm);

	btnReturn = new(none) class'GUIButton';
  btnReturn.bBoundToParent = true;
  btnReturn.OnClick = InternalOnClick;
  btnReturn.FontScale = FNS_Small;
  btnReturn.Caption = "";
  btnReturn.StyleName = "STY_DXR_MediumButton";
  btnReturn.OnClick = InternalOnClick;
  btnReturn.WinHeight = 21;
  btnReturn.WinWidth = 144;
  btnReturn.WinLeft = 364;
  btnReturn.WinTop = 276;
  AppendComponent(btnReturn, true);

	if (winTerm.IsA('NetworkTerminalPersonal'))
		btnReturn.Caption = EmailButtonLabel;
	else if (winTerm.IsA('NetworkTerminalSecurity'))
		btnReturn.Caption = SecurityButtonLabel;
}

// ----------------------------------------------------------------------
// SetCompOwner()
//
// Loop through the special options and create 'em, baby!
// ----------------------------------------------------------------------

function SetCompOwner(ElectronicDevices newCompOwner)
{
	Super.SetCompOwner(newCompOwner);

	CreateOptionButtons();
  winStatus.Caption = "Daedalus:GlobalNode:" $ Computers(compOwner).GetNodeAddress() $ "/" $ ComputerNodeFunctionLabel;
}

// ----------------------------------------------------------------------
// CreateOptionButtons()
// ----------------------------------------------------------------------

function CreateOptionButtons()
{
	local int specialIndex;
	local int numOptions;
	local SpecialOptionsButton winButton;

	// Figure out how many special options we have

	numOptions = 0;
	for (specialIndex=0; specialIndex<ArrayCount(Computers(compOwner).specialOptions); specialIndex++)
	{
		if ((Computers(compOwner).specialOptions[specialIndex].userName == "") || (Caps(Computers(compOwner).specialOptions[specialIndex].userName) == winTerm.GetUserName()))
		{
			if (Computers(compOwner).specialOptions[specialIndex].Text != "")
			{
				// Create the button
				winButton = new(none) class'SpecialOptionsButton'; //MenuUIChoiceButton(winClient.NewChild(Class'MenuUIChoiceButton'));
				winButton.OnClick = InternalOnClick;
				winButton.WinLeft = buttonLeftMargin;
				winButton.WinTop = firstButtonPosY + (numOptions * MiddleTextureHeight);
				winButton.WinWidth = 480;
				winButton.WinHeight = 21;
				winButton.Caption = Computers(compOwner).specialOptions[specialIndex].Text;
				winButton.Hint = Computers(compOwner).specialOptions[specialIndex].ButtonToolTip; // tooltip
          if (Computers(compOwner).specialOptions[specialIndex].bAlreadyTriggered)
          winButton.DisableMe();
        AppendComponent(winButton, true);

				optionButtons[numOptions].specialIndex = specialIndex;
				optionButtons[numOptions].btnSpecial   = winButton;

				numOptions++;				
			}
		}
	}

	// Update the location of the Special Info window and the Status window, also resize window itself ))
	SetWinSize(100 + (numOptions * ButtonHeight), 512);
	btnLogout.WinTop = 119 + (numOptions * ButtonHeight);
	btnReturn.WinTop = 119 + (numOptions * ButtonHeight);
	winStatus.WinTop = 90 + (numOptions * ButtonHeight);

	leftEdgeHeight = 138 + (numOptions * ButtonHeight);
	rightEdgeHeight = 112 + (numOptions * ButtonHeight);


}

// ----------------------------------------------------------------------
// UpdateOptionsButtons()
// ----------------------------------------------------------------------

function UpdateOptionsButtons()
{
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool InternalOnClick(GUIComponent Sender)
{
	local bool bHandled;

	// First check to see if one of our Special Options 
	// buttons was pressed
	if (sender.IsA('SpecialOptionsButton'))
	{
		ActivateSpecialOption(SpecialOptionsButton(Sender));
		bHandled = true;
	}
	else
	{
		bHandled = True;
		switch (Sender)
		{
			case btnLogout:
				CloseScreen("LOGOUT");
				break;

			case btnReturn:
				CloseScreen("RETURN");
				break;

			default:
				bHandled = False;
				break;
		}
	}

	if (bHandled)
		return True;
	else
		return Super.InternalOnClick(Sender);
}

// ----------------------------------------------------------------------
// ActivateSpecialOption()
// ----------------------------------------------------------------------

function ActivateSpecialOption(SpecialOptionsButton buttonPressed)
{
	local int buttonIndex;
	local int specialIndex;
	local Actor A;

	specialIndex = -1;

	// Loop through the buttons and find a Match!
	for(buttonIndex=0; buttonIndex<arrayCount(optionButtons); buttonIndex++)
	{
		if (optionButtons[buttonIndex].btnSpecial == buttonPressed)
		{
			specialIndex = optionButtons[buttonIndex].specialIndex;

			// Disable this button so the user can't activate this 
			// choice again
			optionButtons[buttonIndex].btnSpecial.DisableMe();//SetSensitivity(False);

			break;
		}
	}

	// If we found the matching button, activate the option!
	if (specialIndex != -1)
	{
		// Make sure this option wasn't already triggered
		if (!Computers(compOwner).specialOptions[specialIndex].bAlreadyTriggered)
		{
			if (Computers(compOwner).specialOptions[specialIndex].TriggerEvent != '')
				foreach player.AllActors(class'Actor', A, Computers(compOwner).specialOptions[specialIndex].TriggerEvent)
					A.Trigger(None, player);
		
			if (Computers(compOwner).specialOptions[specialIndex].UnTriggerEvent != '')
				foreach player.AllActors(class'Actor', A, Computers(compOwner).specialOptions[specialIndex].UnTriggerEvent)
					A.UnTrigger(None, player);
		
			if (Computers(compOwner).specialOptions[specialIndex].bTriggerOnceOnly)
				Computers(compOwner).specialOptions[specialIndex].bAlreadyTriggered = True;

			// Display a message			
			winSpecialInfo.Caption = Computers(compOwner).specialOptions[specialIndex].TriggerText;
		}
	}
}

function SetWinSize(float Height, float Width)
{
		DefaultHeight = Height;
		DefaultWidth = Width;
		MaxPageHeight = Height;
		MaxPageWidth = Width;
		MinPageHeight = Height;
		MinPageWidth = Width;

		i_FrameBG.WinWidth = Width;
		i_FrameBG.WinHeight = Height;

}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
    buttonLeftMargin=20 //25
    firstButtonPosY=80//17
    specialOffsetY=16
    statusPosYOffset=50
    TopTextureHeight=12
    MiddleTextureHeight=30
    BottomTextureHeight=75
    SecurityButtonLabel="|&Security"
    EmailButtonLabel="|&Email"
    ButtonLabelLogout="Logout"
    escapeAction="LOGOUT"
    WinTitle="Special Options"
    ButtonHeight=22

 		leftEdgeCorrectorX=4
		leftEdgeCorrectorY=0
		leftEdgeHeight=166

		RightEdgeCorrectorX=511
		RightEdgeCorrectorY=20
		RightEdgeHeight=140

		TopEdgeCorrectorX=410
		TopEdgeCorrectorY=16
    TopEdgeLength=100

    TopRightCornerX=509
    TopRightCornerY=16


	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Texture'DXR_SpecialOptions'
		ImageRenderStyle=MSTY_Normal
		ImageStyle=ISTY_Stretched
		ImageColor=(R=255,G=255,B=255,A=255)
		DropShadow=None
		WinWidth=512
		WinHeight=256
		WinLeft=8
		WinTop=20
		RenderWeight=0.000003
		bBoundToParent=True
		bScaleToParent=True
  	OnRendered=PaintOnBG
	End Object
	i_FrameBG=FloatingFrameBackground

  ComputerNodeFunctionLabel="SpecialOptions"
}
