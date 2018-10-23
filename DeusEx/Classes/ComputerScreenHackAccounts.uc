/**/
class ComputerScreenHackAccounts extends ComputerUIWindow;

var GUIButton btnChangeAccount;
var GUILabel winCurrentUser, lAccounts, lCurrent;
var GUIListBox lstAccounts;

var Computers compOwner;		// what computer owns this window?
                            // Note: overriding variable that already defined in parent class will lead to compiler warning!

var localized String ChangeAccountButtonLabel;
var localized String AllAccountsHeader;
var localized String CurrentAccountHeader;
var(FrameOffset) int Fx, Fy;


function CreateMyControls()
{
  /* -- button and listbox ------------------------------------------------*/
  btnChangeAccount = new(none) class'GUIButton';
  btnChangeAccount.bBoundToParent = true;
  btnChangeAccount.WinHeight = 20;
  btnChangeAccount.WinWidth = 174;
  btnChangeAccount.WinLeft = 6;
  btnChangeAccount.WinTop = 159;
  btnChangeAccount.StyleName = "STY_DXR_ButtonNavbar";
  btnChangeAccount.Caption = ChangeAccountButtonLabel;
  btnChangeAccount.OnClick = InternalOnClick;
  AppendComponent(btnChangeAccount, true);

  lstAccounts = new(none) class'GUIListBox';
  lstAccounts.MyScrollBar.WinWidth = 16;
  lstAccounts.SelectedStyleName="STY_DXR_ListSelection";
  lstAccounts.StyleName = "STY_DXR_Listbox";
  lstAccounts.bBoundToParent = true;
  lstAccounts.WinHeight = 98;
  lstAccounts.WinWidth = 171;
  lstAccounts.WinLeft = 7;
  lstAccounts.WinTop = 59;
	AppendComponent(lstAccounts, true);
  lstAccounts.list.TextAlign = TXTA_Left;

  /* -- Text labels ------------------------------------------------*/
  winCurrentUser = new(none) class'GUILabel';
  winCurrentUser.bBoundToParent = true;
  winCurrentUser.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  winCurrentUser.caption = "winCurrentUser";
  winCurrentUser.TextFont="UT2HeaderFont";
  winCurrentUser.bMultiLine = true;
  winCurrentUser.TextAlign = TXTA_Left;
  winCurrentUser.VertAlign = TXTA_Center;
  winCurrentUser.FontScale = FNS_Small;
 	winCurrentUser.WinHeight = 20;
  winCurrentUser.WinWidth = 169;
  winCurrentUser.WinLeft = 8;
  winCurrentUser.WinTop = 15;
  AppendComponent(winCurrentUser, true);

  lAccounts = new(none) class'GUILabel';
  lAccounts.bBoundToParent = true;
  lAccounts.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  lAccounts.caption = AllAccountsHeader;
  lAccounts.TextFont="UT2HeaderFont";
  lAccounts.bMultiLine = true;
  lAccounts.TextAlign = TXTA_Left;
  lAccounts.VertAlign = TXTA_Center;
  lAccounts.FontScale = FNS_Small;
 	lAccounts.WinHeight = 20;
  lAccounts.WinWidth = 169;
  lAccounts.WinLeft = 8;
  lAccounts.WinTop = 39;
  AppendComponent(lAccounts, true);

  lCurrent = new(none) class'GUILabel';
  lCurrent.bBoundToParent = true;
  lCurrent.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  lCurrent.caption = CurrentAccountHeader;
  lCurrent.TextFont="UT2HeaderFont";
  lCurrent.bMultiLine = true;
  lCurrent.TextAlign = TXTA_Left;
  lCurrent.VertAlign = TXTA_Center;
  lCurrent.FontScale = FNS_Small;
 	lCurrent.WinHeight = 20;
  lCurrent.WinWidth = 169;
  lCurrent.WinLeft = 8;
  lCurrent.WinTop = 2; // lowest possible value is 2.0 (float). If value less than 2.0, UT2004 windows starts working in "relative mode"
  AppendComponent(lCurrent, true);
}


// SetNetworkTerminal()
function SetNetworkTerminal(NetworkTerminal newTerm)
{
	winTerm = newTerm;
	UpdateCurrentUser();
}

// SetCompOwner()
function SetCompOwner(ElectronicDevices newCompOwner)
{
	local int compIndex;
	local int rowId;
	local int userRowIndex;

	compOwner = Computers(newCompOwner);

	// Loop through the names and add them to our listbox
	for (compIndex=0; compIndex<compOwner.NumUsers(); compIndex++)
	{
		lstAccounts.list.Add(Caps(compOwner.GetUserName(compIndex)));

		if (Caps(winTerm.GetUserName()) == Caps(compOwner.GetUserName(compIndex)))
			userRowIndex = compIndex;
	}

	// Select the row that matches the current user
//	rowId = lstAccounts.IndexToRowId(userRowIndex);
	rowid = lstAccounts.list.FindIndex(winTerm.GetUserName(), false);//SetRow(rowId, True);
	log("RowId = "$rowId);
}

// UpdateCurrentUser()
function UpdateCurrentUser()
{
	if (winTerm != None)
		winCurrentUser.Caption = winTerm.GetUserName();
}

// ----------------------------------------------------------------------
// ChangeSelectedAccount()
// ----------------------------------------------------------------------

function ChangeSelectedAccount()
{
	local int userIndex;

	userIndex = lstAccounts.list.FindIndex(lstAccounts.list.SelectedText()); // lstAccounts.RowIdToIndex(lstAccounts.GetSelectedRow());
	log(userIndex);

	if (winTerm != None)
		winTerm.ChangeAccount(userIndex);
}

// ----------------------------------------------------------------------
// ButtonActivated()
// ----------------------------------------------------------------------

function bool InternalOnClick(GUIComponent Sender)
{
	local bool bHandled;

	bHandled = True;

	switch (Sender)
	{
		case btnChangeAccount:
			ChangeSelectedAccount();
     			UpdateCurrentUser(); // Добавлено
			break;

		default:
			bHandled = false;
			break;
	}

	if (bHandled)
		return true;
	else
		return Super.InternalOnClick(Sender);
}

function bool AlignFrame(Canvas C)
{
  local int x,y;

  x = ActualLeft(); y = ActualTop();
  c.SetPos(x - fx, y - fy);
  c.Style = eMenuRenderStyle.MSTY_Translucent;
  c.SetDrawColor(255,255,255);
  c.DrawIcon(texture'ComputerHackAccountsBorder', 1);

  winLeft = controller.ResX - 196;//206;
  winTop = 150;

  bVisible=true;

	return bInit;
}

function bool OnCanClose(optional Bool bCancelled)
{
 return false;
}



// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
    fx=5
    fy=7

		DefaultHeight=190
		DefaultWidth=190
		MaxPageHeight=190
		MaxPageWidth=190
		MinPageHeight=190
		MinPageWidth=190

    ChangeAccountButtonLabel="|&Change Account"
    AllAccountsHeader="All User Accounts"
    CurrentAccountHeader="Current User"

	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Texture'ComputerHackAccountsBackground'
		ImageRenderStyle=MSTY_Normal
		ImageStyle=ISTY_Tiled //PartialScaled
		ImageColor=(R=255,G=255,B=255,A=255)
		DropShadow=None
		WinWidth=189
		WinHeight=183
		WinLeft=0
		WinTop=0
		RenderWeight=0.000003
		bBoundToParent=True
		bScaleToParent=True
	End Object
	i_FrameBG=FloatingFrameBackground

	Begin Object Class=GUIHeader Name=TitleBar
		WinWidth=0.0
		WinHeight=0
	End Object
	t_WindowTitle=TitleBar
}
