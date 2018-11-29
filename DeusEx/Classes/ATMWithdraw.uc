/**/
class ATMWithdraw extends ComputerUIWindow;

var GUILabel winInstructions, winInfo, lBalance, lAmount, lAddress, lHacked;
var GUIEditBox editBalance, editWithdraw;
var GUIButton btnClose, btnWithdraw;

var float balanceModifier;
var float disabledDelay;		// Amount of time before ATM disabled when hacking
var DeusExPlayer player;
var bool bTickEnabled;
var ATM atmOwner;				// what ATM owns this window?

var localized String InvalidAmountLabel,InsufficientCreditsLabel,CreditsWithdrawnLabel,StatusText,HackedText;
var localized String ButtonLabelWithdraw,ButtonLabelClose,BalanceLabel,WithdrawAmountLabel,InstructionText;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

  player = DeusExPlayer(playerOwner().pawn);
}

function CreateMyControls()
{
  btnWithdraw = new(none) class'GUIButton';
  btnWithdraw.WinHeight = 21;
  btnWithdraw.WinWidth = 100;
  btnWithdraw.WinLeft = 245;
  btnWithdraw.WinTop = 259;
  btnWithdraw.StyleName = "STY_DXR_MediumButton";
  btnWithdraw.Caption = ButtonLabelWithdraw;
  btnWithdraw.OnClick = InternalOnClick;
  AppendComponent(btnWithdraw, true);

  btnClose = new(none) class'GUIButton';
  btnClose.WinHeight = 21;
  btnClose.WinWidth = 100;
  btnClose.WinLeft = 142;
  btnClose.WinTop = 259;
  btnClose.StyleName = "STY_DXR_MediumButton";
  btnClose.Caption = ButtonLabelClose;
  btnClose.OnClick = InternalOnClick;
  AppendComponent(btnClose, true);

  editBalance = new(none) class'GUIEditBox';
  editBalance.StyleName="STY_DXR_EditBox";
  editBalance.FontScale = FNS_Small;
  editBalance.WinHeight = 21;
  editBalance.WinWidth = 144;
  editBalance.WinLeft = 173;
  editBalance.WinTop = 128;//158;
  editBalance.bReadOnly=true;
  AppendComponent(editBalance, true);
  editBalance.SetText("editBalance");

  editWithdraw = new(none) class'GUIEditBox';
  editWithdraw.StyleName="STY_DXR_EditBox";
  editWithdraw.FontScale = FNS_Small;
  editWithdraw.WinHeight = 21;
  editWithdraw.WinWidth = 144;
  editWithdraw.WinLeft = 173;
  editWithdraw.WinTop = 158;//128;
  editWithdraw.OnChange = ef_OnChange;
  AppendComponent(editWithdraw, true);

  lBalance = new(none) class'GUILabel';
  lBalance.bBoundToParent = true;
  lBalance.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  lBalance.caption = BalanceLabel;
  lBalance.TextFont="UT2HeaderFont";
  lBalance.bMultiLine = true;
  lBalance.TextAlign = TXTA_Right;
  lBalance.VertAlign = TXTA_Center;
  lBalance.FontScale = FNS_Small;
  lBalance.WinHeight = 21;
  lBalance.WinWidth = 144;
  lBalance.WinLeft = 17;
  lBalance.WinTop = 128;
  AppendComponent(lBalance, true);

  lAmount = new(none) class'GUILabel';
  lAmount.bBoundToParent = true;
  lAmount.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  lAmount.caption = WithdrawAmountLabel;
  lAmount.TextFont="UT2HeaderFont";
  lAmount.bMultiLine = true;
  lAmount.TextAlign = TXTA_Right;
  lAmount.VertAlign = TXTA_Center;
  lAmount.FontScale = FNS_Small;
  lAmount.WinHeight = 21;
  lAmount.WinWidth = 144;
  lAmount.WinLeft = 17;
  lAmount.WinTop = 158;
  AppendComponent(lAmount, true);

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

  winInfo = new(none) class'GUILabel';
  winInfo.bBoundToParent = true;
  winInfo.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  winInfo.caption = "";//InvalidAmountLabel;
  winInfo.TextFont="UT2HeaderFont";
  winInfo.bMultiLine = true;
  winInfo.TextAlign = TXTA_Center;
  winInfo.VertAlign = TXTA_Center;
  winInfo.FontScale = FNS_Small;
 	winInfo.WinHeight = 24;
  winInfo.WinWidth = 326;
  winInfo.WinLeft = 14;
  winInfo.WinTop = 193; //225;
  AppendComponent(winInfo, true);

  lHacked = new(none) class'GUILabel';
  lHacked.bBoundToParent = true;
  lHacked.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  lHacked.caption = "";//HackedText;
  lHacked.TextFont="UT2HeaderFont";
  lHacked.bMultiLine = true;
  lHacked.TextAlign = TXTA_Center;
  lHacked.VertAlign = TXTA_Center;
  lHacked.FontScale = FNS_Small;
 	lHacked.WinHeight = 33;
  lHacked.WinWidth = 309;
  lHacked.WinLeft = 15;
  lHacked.WinTop = 86;
  AppendComponent(lHacked, true);

  winInstructions = new(none) class'GUILabel';
  winInstructions.bBoundToParent = true;
  winInstructions.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  winInstructions.caption = InstructionText;
  winInstructions.TextFont="UT2HeaderFont";
  winInstructions.bMultiLine = true;
  winInstructions.TextAlign = TXTA_Center;
  winInstructions.VertAlign = TXTA_Center;
  winInstructions.FontScale = FNS_Small;
 	winInstructions.WinHeight = 52;
  winInstructions.WinWidth = 311;
  winInstructions.WinLeft = 15;
  winInstructions.WinTop = 28;
  AppendComponent(winInstructions, true);
}

//event Opened(GUIComponent Sender);

event Closed(GUIComponent Sender, bool bCancelled)  // Called when the Menu Owner is closed
{
  atmOwner.atmwindow = none;
  super.Closed(Sender, bCancelled);
//  DeusExHud(PlayerOwner().myHUD).cubemapmode = false;
}

event free()
{
  atmOwner.atmwindow = none;
  super.free();
//	DeusExHud(PlayerOwner().myHUD).cubemapmode = false;
}

function bool InternalOnClick(GUIComponent Sender)
{
  if (Sender==btnClose)
      CloseScreen("LOGOUT");

  if (Sender==btnWithdraw)
      WithdrawCredits();

  //Controller.CloseAll(false, true);//CloseMenu();

  return false;
}

function WithdrawCredits()
{
	local int numCredits;
	local int balance;

	numCredits = Int(editWithdraw.GetText());

	// withdrawal
	if (numCredits > 0)
	{
		if (winTerm.bHacked)
			balance = atmOwner.GetBalance(-1, balanceModifier);
		else
			balance = atmOwner.GetBalance(winTerm.GetUserIndex(), balanceModifier);

		if (balance >= numCredits)
		{
			if (winTerm.bHacked)
				atmOwner.ModBalance(-1, numCredits, True);
			else
				atmOwner.ModBalance(winTerm.GetUserIndex(), numCredits, True);

			player.Credits += numCredits;
			winInfo.Caption = (String(numCredits) @ CreditsWithdrawnLabel);

			// If the user withdrew *ALL* the money and this ATM machine 
			// was hacked, then set a timer which will cause the 
			// ATM Disabled screen to come up after a few seconds.

			if ((winTerm.bHacked) && (balance - numCredits <= 0))
			{
				bTickEnabled = True;
				atmOwner.bSuckedDryByHack = True;
			}
		}
		else
		{
			winInfo.Caption = InsufficientCreditsLabel;
		}
	}
	else
	{
		winInfo.Caption = InvalidAmountLabel;
	}

	// Blank withdraw box and reset focus to that window
	editWithdraw.SetText("");
	UpdateBalance();
	SetFocus(editWithdraw);
}

function UpdateBalance()
{
	if (winTerm.bHacked)
		editBalance.SetText(String(atmOwner.GetBalance(-1, balanceModifier)));
	else
		editBalance.SetText(String(atmOwner.GetBalance(winTerm.GetUserIndex(), balanceModifier)));
}

// Tick()
function InternalOnRendered(Canvas u)
{
  if (!bTickEnabled)
  return;

	disabledDelay -= controller.renderDelta;

	if (disabledDelay <= 0.0)
	{
		bTickEnabled = false;

		// Go to the ATM Disabled screen
		CloseScreen("ATMDISABLED");
	}
}

function SetCompOwner(ElectronicDevices newCompOwner)
{
	local String test;

	Super.SetCompOwner(newCompOwner);
	atmowner = ATM(compOwner);

	balanceModifier = winTerm.GetSkillLevel() * 0.5;
	UpdateBalance();

	if (winTerm.bHacked)
	{
		// Once hacked, an ATM can't be returned to
		atmOwner.bSuckedDryByHack = True;
		test = class'Actor'.static.Sprintf(InstructionText, HackedText);
	}
	else
	{
		test = class'Actor'.static.Sprintf(InstructionText, atmOwner.GetAccountNumber(winTerm.GetUserIndex()));
	}

	winInstructions.Caption = test;

	EnableButtons();
	SetFocus(editWithdraw);
}

function EnableButtons()
{
	local float balance;

	// Only allow withdraw if there's money to be withdrawn and the user has typed
	// something into the editWithdraw field

	if (winTerm.bHacked)
		balance = atmOwner.GetBalance(-1, balanceModifier);
	else
		balance = atmOwner.GetBalance(winTerm.GetUserIndex(), balanceModifier);

		if ((editWithdraw.GetText() != "") && (balance > 0))
		btnWithdraw.EnableMe();
		else
		btnWithdraw.DisableMe();
//	btnWithdraw.SetSensitivity((editWithdraw.GetText() != "") && (balance > 0));
}

function ef_OnChange(GUIComponent Sender)
{
  if (Sender==editWithdraw)
     EnableButtons();
}

function bool AlignFrame(Canvas C)
{
  if (bVisible)
  winleft = (controller.resX/2) - (MaxPageWidth/2);

	return bInit;
}






defaultproperties
{
    disabledDelay=5.00
    ButtonLabelWithdraw="&Withdraw"
    ButtonLabelClose="&Close"
    BalanceLabel="Current Balance:"
    WithdrawAmountLabel="Amount to Withdraw:"
    InstructionText="Account #: %d|Please enter the amount of|credits you wish to withdraw."
    InvalidAmountLabel="INVALID AMOUNT ENTERED"
    InsufficientCreditsLabel="INSUFFICIENT CREDITS"
    CreditsWithdrawnLabel="CREDITS WITHDRAWN"
    StatusText="PNGBS//GLOBAL//PUB:3902.9571[wd]"
    HackedText="TERMINAL HACKED"
    WinTitle="PageNet Global Banking System"
    escapeAction="LOGOUT"
    ComputerNodeFunctionLabel="ATMWD"

		leftEdgeCorrectorX=4
		leftEdgeCorrectorY=0
		leftEdgeHeight=275

		RightEdgeCorrectorX=347
		RightEdgeCorrectorY=20
		RightEdgeHeight=252

		TopEdgeCorrectorX=260
		TopEdgeCorrectorY=16
    TopEdgeLength=86

    TopRightCornerX=345
    TopRightCornerY=16

		DefaultHeight=256
		DefaultWidth=356
		MaxPageHeight=256
		MaxPageWidth=356
		MinPageHeight=256
		MinPageWidth=356

    OnRendered=InternalOnRendered

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
		OnRendered=PaintOnBG
	End Object
	i_FrameBG=FloatingFrameBackground
}