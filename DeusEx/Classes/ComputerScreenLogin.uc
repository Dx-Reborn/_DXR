/* Окно ввода логина и пароля */

class ComputerScreenLogin extends ComputerUIWindow;

var localized String UserNameLabel, PasswordLabel, InvalidLoginMessage, ButtonLabelCancel, ButtonLabelLogin, WelcomeTo;
var GUILabel winLoginInfo, lUserName, lPassword, winStatus;
var GUIEditBox editPassword, editUserName;
var GUIButton btnLogin, btnCancel;
var GUIImage winLogo;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	CreateControls();
	EnableButtons();
}

function CreateControls()
{
  btnCancel = new(none) class'GUIButton';
  btnCancel.OnClick = InternalOnClick;
  btnCancel.bBoundToParent = true;
  btnCancel.Caption = ButtonLabelCancel;
  btnCancel.WinHeight = 21;
  btnCancel.WinWidth = 100;
  btnCancel.WinLeft = 171;
  btnCancel.WinTop = 186;
  btnCancel.StyleName = "STY_DXR_MediumButton";
  AppendComponent(btnCancel, true);

  btnLogin = new(none) class'GUIButton';
  btnLogin.OnClick = InternalOnClick;
  btnLogin.bBoundToParent = true;
  btnLogin.Caption = ButtonLabelLogin;
  btnLogin.WinHeight = 21;
  btnLogin.WinWidth = 100;
  btnLogin.WinLeft = 273;
  btnLogin.WinTop = 186;
  btnLogin.StyleName = "STY_DXR_MediumButton";
  AppendComponent(btnLogin, true);

  winLoginInfo = new(none) class'GUILabel';
  winLoginInfo.bBoundToParent = true;
  winLoginInfo.Caption = "winLoginInfo";
  winLoginInfo.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  winLoginInfo.TextFont="UT2HeaderFont";
  winLoginInfo.bMultiLine = true;
  winLoginInfo.TextAlign = TXTA_Left;
  winLoginInfo.VertAlign = TXTA_Center;
  winLoginInfo.FontScale = FNS_Small;
  winLoginInfo.WinHeight = 26;
  winLoginInfo.WinWidth = 351;
  winLoginInfo.WinLeft = 14;
  winLoginInfo.WinTop = 116;
  AppendComponent(winLoginInfo, true);

  winStatus = new(none) class'GUILabel';
  winStatus.bBoundToParent = true;
  winStatus.Caption = "winLoginInfo";
  winStatus.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  winStatus.TextFont="UT2SmallFont";
  winStatus.bMultiLine = true;
  winStatus.TextAlign = TXTA_Left;
  winStatus.VertAlign = TXTA_Center;
  winStatus.FontScale = FNS_Small;
  winStatus.WinHeight = 28;
  winStatus.WinWidth = 349;
  winStatus.WinLeft = 16;
  winStatus.WinTop = 151;
  AppendComponent(winStatus, true);

  lUserName = new(none) class'GUILabel';
  lUserName.bBoundToParent = true;
  lUserName.Caption = UserNameLabel;
  lUserName.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  lUserName.TextFont="UT2HeaderFont";
  lUserName.bMultiLine = true;
  lUserName.TextAlign = TXTA_Right;
  lUserName.VertAlign = TXTA_Center;
  lUserName.FontScale = FNS_Small;
  lUserName.WinHeight = 21;
  lUserName.WinWidth = 105;
  lUserName.WinLeft = 15;
  lUserName.WinTop = 40;
  AppendComponent(lUserName, true);

  lPassword = new(none) class'GUILabel';
  lPassword.bBoundToParent = true;
  lPassword.Caption = PasswordLabel;
  lPassword.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  lPassword.TextFont="UT2HeaderFont";
  lPassword.bMultiLine = true;
  lPassword.TextAlign = TXTA_Right;
  lPassword.VertAlign = TXTA_Center;
  lPassword.FontScale = FNS_Small;
  lPassword.WinHeight = 21;
  lPassword.WinWidth = 105;
  lPassword.WinLeft = 15;
  lPassword.WinTop = 74;
  AppendComponent(lPassword, true);

  editUserName = new(none) class'GUIEditBox';
  editUserName.bBoundToParent = true;
  editUserName.StyleName="STY_DXR_EditBox";
  editUserName.FontScale = FNS_Small;
  editUserName.WinHeight = 21;
  editUserName.WinWidth = 156;
  editUserName.WinLeft = 122;
  editUserName.WinTop = 39;
  editUserName.OnChange = ef_OnChange;
  AppendComponent(editUserName, true);

  editPassword = new(none) class'GUIEditBox';
  editPassword.bBoundToParent = true;
  editPassword.StyleName="STY_DXR_EditBox";
  editPassword.FontScale = FNS_Small;
  editPassword.WinHeight = 21;
  editPassword.WinWidth = 156;
  editPassword.WinLeft = 122;
  editPassword.WinTop = 73;
  editPassword.OnChange = ef_OnChange;
  AppendComponent(editPassword, true);

  winLogo = new(none) class'GUIImage';
  winLogo.bBoundToParent = true;
  winLogo.WinHeight = 64;
  winLogo.WinWidth = 64;
  winLogo.WinLeft = 306;
  winLogo.WinTop = 25;
  AppendComponent(winLogo, true);
}

function SetLogo(material newLogo)
{
	if (winLogo != None)
		winLogo.image = newLogo;
}

// ----------------------------------------------------------------------
// SetCompOwner()
// ----------------------------------------------------------------------

function SetCompOwner(ElectronicDevices newCompOwner)
{
	Super.SetCompOwner(newCompOwner);

	// Update the title, texture and description
  WinTitle = class'Actor'.static.Sprintf(WelcomeTo, Computers(compOwner).GetNodeName());
	winLoginInfo.caption = Computers(compOwner).GetNodeDesc();

	SetFocus(editUserName);
	SetLogo(Computers(compOwner).GetNodeTexture());
  winStatus.Caption = "Daedalus:GlobalNode:" $ Computers(compOwner).GetNodeAddress() $ "/" $ ComputerNodeFunctionLabel;
}

// ----------------------------------------------------------------------
// SetNetworkTerminal()
// ----------------------------------------------------------------------

function SetNetworkTerminal(NetworkTerminal newTerm)
{
	Super.SetNetworkTerminal(newTerm);

	// If the user already hacked this computer, then set the 
	// "Hack" button to "Return"
	if (winTerm != None)
		winTerm.SetHackButtonToReturn();
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool InternalOnClick(GUIComponent Sender)
{
	if (Sender==btnLogin)
      ProcessLogin();

  if (Sender==btnCancel)
      CloseScreen("EXIT");

return true;
}

// ----------------------------------------------------------------------
// ProcessLogin()
// ----------------------------------------------------------------------

function ProcessLogin()
{
	local string userName;
	local int userIndex;
	local int compIndex;
	local int userSkillLevel;
	local bool bSuccessfulLogin;

	bSuccessfulLogin = False;
	userIndex        = -1;

	// Verify that this is a valid userid/password combination

	// First check the name
	for (compIndex=0; compIndex<Computers(compOwner).NumUsers(); compIndex++)
	{
		if (Caps(editUsername.GetText()) == Caps(Computers(compOwner).GetUserName(compIndex)))
		{
			userName  = Caps(Computers(compOwner).GetUserName(compIndex));
			userIndex = compIndex;
			break;
		}
	}

	if (userIndex != -1)
	{
		if (Caps(editPassword.GetText()) == Caps(Computers(compOwner).GetPassword(userIndex)))
		{
			bSuccessfulLogin = True;
		}
	}

	if (bSuccessfulLogin)
	{
		winTerm.SetLoginInfo(userName, userIndex);

		// set the user's access level if it's higher than the player's
		userSkillLevel = Computers(compOwner).GetAccessLevel(userIndex);

		if (winTerm.GetSkillLevel() < userSkillLevel)
			winTerm.SetSkillLevel(userSkillLevel);

		CloseScreen("LOGIN");
	}
	else
	{
		// Print a message about invalid login
		winLoginInfo.Caption = InvalidLoginMessage;
    playerOwner().pawn.playSound(sound'buzz1'); // Make sound too )))

		// Clear text fields and reset focus
		editUserName.SetText("");
		editPassword.SetText("");
		SetFocus(editUserName);
	}
}

function ef_OnChange(GUIComponent Sender)
{
  if ((Sender==editUserName) || (Sender==editPassword))
	EnableButtons();
}

// ----------------------------------------------------------------------
// EnableButtons()
// ----------------------------------------------------------------------

function EnableButtons()
{
	// Text must be entered in the two fields for the login button to be
	// enabled
 if ((editUsername.GetText() != "") && (editPassword.GetText() != ""))
      btnLogin.EnableMe();
         else
      btnLogin.DisableMe();
}

//event Closed(GUIComponent Sender, bool bCancelled)

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
		DefaultHeight=212
		DefaultWidth=378
		MaxPageHeight=212
		MaxPageWidth=378
		MinPageHeight=212
		MinPageWidth=378

		leftEdgeCorrectorX=4
		leftEdgeCorrectorY=0
		leftEdgeHeight=205

		RightEdgeCorrectorX=374
		RightEdgeCorrectorY=20
		RightEdgeHeight=178

		TopEdgeCorrectorX=272
		TopEdgeCorrectorY=16
    TopEdgeLength=100

    TopRightCornerX=372
    TopRightCornerY=16

    UserNameLabel="User Name"
    PasswordLabel="Password"
    InvalidLoginMessage="LOGIN ERROR - ACCESS DENIED"
    WelcomeTo="Welcome to %s"
    ButtonLabelCancel="Cancel"
    ButtonLabelLogin="Login"
    ComputerNodeFunctionLabel="Login"

    escapeAction="EXIT"

	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Texture'DXR_LogonBackground'
		ImageRenderStyle=MSTY_Normal
		ImageStyle=ISTY_Tiled
		ImageColor=(R=255,G=255,B=255,A=255)
		DropShadow=None
		WinWidth=366
		WinHeight=170
		WinLeft=8
		WinTop=20
		RenderWeight=0.000003
		bBoundToParent=True
		bScaleToParent=True
		OnRendered=PaintOnBG
	End Object
	i_FrameBG=FloatingFrameBackground


}
