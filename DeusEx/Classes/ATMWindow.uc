/* Банковский терминал: Вход */
class ATMWindow extends ComputerUIWindow;

var() editconst ATM atmOwner;		// what ATM owns this window?
var() editconst DeusExPlayer player;

var GUIPage winHack;

var GUIButton btnLogin, btnCancel;
var GUIEditBox editAccount, editPIN;
var GUILabel winWarning, winLoginInfo, winLoginError, lLogin, lPin, lAddress;


var localized String AccountLabel, PinLabel, LoginInfoText, WarningText, StatusText, InvalidLoginMessage, strLogin, strExit;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

  /* Указатели для обратной связи */
  player = DeusExPlayer(playerOwner().pawn);
//  atmOwner = ATM(player.frobTarget);

  CreateControls();
  OnKeyEvent=InternalOnKeyEvent;
}

function CreateControls()
{
  btnLogin = new(none) class'GUIButton';
  btnLogin.WinHeight = 21;
  btnLogin.WinWidth = 100;
  btnLogin.WinLeft = 245;
  btnLogin.WinTop = 259;
  btnLogin.StyleName = "STY_DXR_MediumButton";
  btnLogin.Caption = strLogin;
  btnLogin.OnClick = InternalOnClick;
  AppendComponent(btnLogin, true);

  btnCancel = new(none) class'GUIButton';
  btnCancel.WinHeight = 21;
  btnCancel.WinWidth = 100;
  btnCancel.WinLeft = 142;
  btnCancel.WinTop = 259;
  btnCancel.StyleName = "STY_DXR_MediumButton";
  btnCancel.Caption = strExit;
  btnCancel.OnClick = InternalOnClick;
  AppendComponent(btnCancel, true);

  editPIN = new(none) class'GUIEditBox';
  editPIN.StyleName="STY_DXR_EditBox";
  editPIN.FontScale = FNS_Small;
  editPIN.WinHeight = 21;
  editPIN.WinWidth = 144;
  editPIN.WinLeft = 173;
  editPIN.WinTop = 158;
  editPin.OnChange = ef_OnChange;
  AppendComponent(editPIN, true);

  editAccount = new(none) class'GUIEditBox';
  editAccount.StyleName="STY_DXR_EditBox";
  editAccount.FontScale = FNS_Small;
  editAccount.WinHeight = 21;
  editAccount.WinWidth = 144;
  editAccount.WinLeft = 173;
  editAccount.WinTop = 128;
  editAccount.OnChange = ef_OnChange;
  AppendComponent(editAccount, true);

  lLogin = new(none) class'GUILabel';
  lLogin.bBoundToParent = true;
  lLogin.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  lLogin.caption = AccountLabel;
  lLogin.TextFont="UT2HeaderFont";
  lLogin.bMultiLine = true;
  lLogin.TextAlign = TXTA_Right;
  lLogin.VertAlign = TXTA_Center;
  lLogin.FontScale = FNS_Small;
  lLogin.WinHeight = 21;
  lLogin.WinWidth = 144;
  lLogin.WinLeft = 17;
  lLogin.WinTop = 128;
  AppendComponent(lLogin, true);

  lPin = new(none) class'GUILabel';
  lPin.bBoundToParent = true;
  lPin.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  lPin.caption = PinLabel;
  lPin.TextFont="UT2HeaderFont";
  lPin.bMultiLine = true;
  lPin.TextAlign = TXTA_Right;
  lPin.VertAlign = TXTA_Center;
  lPin.FontScale = FNS_Small;
  lPin.WinHeight = 21;
  lPin.WinWidth = 144;
  lPin.WinLeft = 17;
  lPin.WinTop = 158;
  AppendComponent(lPin, true);

  lAddress = new(none) class'GUILabel';
  lAddress.bBoundToParent = true;
  lAddress.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  lAddress.caption = StatusText;
  lAddress.TextFont="UT2HeaderFont";
  lAddress.bMultiLine = true;
  lAddress.TextAlign = TXTA_Center;
  lAddress.VertAlign = TXTA_Center;
  lAddress.FontScale = FNS_Small;
 	lAddress.WinHeight = 24;
  lAddress.WinWidth = 326;
  lAddress.WinLeft = 14;
  lAddress.WinTop = 225;
  AppendComponent(lAddress, true);

  winLoginError = new(none) class'GUILabel';
  winLoginError.bBoundToParent = true;
  winLoginError.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  winLoginError.caption = "";
  winLoginError.TextFont="UT2HeaderFont";
  winLoginError.bMultiLine = true;
  winLoginError.TextAlign = TXTA_Center;
  winLoginError.VertAlign = TXTA_Center;
  winLoginError.FontScale = FNS_Small;
 	winLoginError.WinHeight = 24;
  winLoginError.WinWidth = 326;
  winLoginError.WinLeft = 14;
  winLoginError.WinTop = 193; //225;
  AppendComponent(winLoginError, true);

  winLoginInfo = new(none) class'GUILabel';
  winLoginInfo.bBoundToParent = true;
  winLoginInfo.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  winLoginInfo.caption = LoginInfoText;
  winLoginInfo.TextFont="UT2HeaderFont";
  winLoginInfo.bMultiLine = true;
  winLoginInfo.TextAlign = TXTA_Center;
  winLoginInfo.VertAlign = TXTA_Center;
  winLoginInfo.FontScale = FNS_Small;
 	winLoginInfo.WinHeight = 33;
  winLoginInfo.WinWidth = 309;
  winLoginInfo.WinLeft = 15;
  winLoginInfo.WinTop = 86;
  AppendComponent(winLoginInfo, true);

  winWarning = new(none) class'GUILabel';
  winWarning.bBoundToParent = true;
  winWarning.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  winWarning.caption = WarningText;
  winWarning.TextFont="UT2HeaderFont";
  winWarning.bMultiLine = true;
  winWarning.TextAlign = TXTA_Center;
  winWarning.VertAlign = TXTA_Center;
  winWarning.FontScale = FNS_Small;
 	winWarning.WinHeight = 52;
  winWarning.WinWidth = 311;
  winWarning.WinLeft = 15;
  winWarning.WinTop = 28;
  AppendComponent(winWarning, true);
}


function SetCompOwner(ElectronicDevices newCompOwner)
{
	Super.SetCompOwner(newCompOwner);
	atmowner = ATM(compOwner);

	SetFocus(editAccount);

	// Check to see if this ATM has been sucked dry, in which
	// case we just want to show the the Disabled screen

	if (atmOwner.bSuckedDryByHack == True)
		CloseScreen("ATMDISABLED");
}

event Opened(GUIComponent Sender)                   // Called when the Menu Owner is opened
{
	super.Opened(Sender);
//	DeusExHud(PlayerOwner().myHUD).cubemapmode = true;
	ef_OnChange(editPIN);
	ef_OnChange(editAccount);
}

event Closed(GUIComponent Sender, bool bCancelled)  // Called when the Menu Owner is closed
{
  atmOwner.atmwindow = none;
//  Controller.CloseAll(false, true);
//	CloseScreen("EXIT");
  super.Closed(Sender, bCancelled);
//  DeusExHud(PlayerOwner().myHUD).cubemapmode = false;
//  if (winHack != none)
//      Controller.RemoveMenu(winHack);
}

event free()
{
//  atmOwner.atmwindow = none;
  super.free();
//	DeusExHud(PlayerOwner().myHUD).cubemapmode = false;

//  if (winHack != none)
//      winHack.free();
}

function ef_OnChange(GUIComponent Sender)
{
  if ((Sender==editPIN) || (Sender==editAccount))
  {
    if ((editPIN.GetText() != "") || (editAccount.GetText() != ""))
    {
      btnLogin.EnableMe();
    }
    else
      btnLogin.DisableMe();
  }
}

/*function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
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
}*/

function bool InternalOnClick(GUIComponent Sender)
{
  if (Sender==btnCancel)
  {
//    Controller.CloseMenu();
		CloseScreen("EXIT");
    return false;
  }
  if (Sender==btnLogin)
  {
    ProcessLogin();
  }
}


function ProcessLogin()
{
	local bool bSuccessfulLogin;
	local int  accountIndex;
	local int  userIndex;

	bSuccessfulLogin = false;

	for (accountIndex=0; accountIndex<atmOwner.NumUsers(); accountIndex++)
	{
		if (Caps(editAccount.GetText()) == atmOwner.GetAccountNumber(accountIndex))
		{
			userIndex = accountIndex;
			break;
		}
	}

	if (userIndex != -1)
	{
		if (Caps(editPIN.GetText()) == atmOwner.GetPIN(userIndex))
			bSuccessfulLogin = True;
	}

	if (bSuccessfulLogin)
	{
		winTerm.SetLoginInfo("", userIndex);
		CloseScreen("LOGIN");
	}
	else
	{
		// Print a message about invalid login
		playerOwner().pawn.playSound(sound'buzz1');
		winLoginError.Caption = InvalidLoginMessage;

		// Clear text fields and reset focus
		editAccount.SetText("");
		editPIN.SetText("");
		SetFocus(editAccount);
	}
}



//function bool AlignFrame(Canvas C);

defaultproperties
{
    AccountLabel="Account #:"
    PinLabel="PIN #:"
    LoginInfoText="Please enter your Account # and Pin"
    WarningText="WARNING: Unauthorized access will be met with excessive force!"
    StatusText="PNGBS//GLOBAL//PUB:3902.9571[login]"
    InvalidLoginMessage="LOGIN ERROR, ACCESS DENIED"
    WinTitle="PageNet Global Banking System"
    strLogin="Login"
    strExit="Cancel"

    escapeAction="EXIT"

		DefaultHeight=256
		DefaultWidth=356
		MaxPageHeight=256
		MaxPageWidth=356
		MinPageHeight=256
		MinPageWidth=356

	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Texture'DXR_BankLogin'
		ImageRenderStyle=MSTY_Normal
		ImageStyle=ISTY_Tiled
		ImageColor=(R=255,G=255,B=255,A=255)
		DropShadow=None
		WinWidth=346
		WinHeight=249
		WinLeft=8
		WinTop=20
		RenderWeight=0.000003
		bBoundToParent=True
		bScaleToParent=True
	End Object
	i_FrameBG=FloatingFrameBackground
}