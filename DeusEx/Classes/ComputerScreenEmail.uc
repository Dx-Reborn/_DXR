/**/
class ComputerScreenEmail extends ComputerUIWindow;

var GUIButton btnSpecial, btnLogout, btnSave;
var EmailListBox lstEmail;
var GUIScrollTextBox winEmail;

// Header vars
var GUILabel winEmailFrom, winEmailTo, winEmailSubject, winEmailCC, winEmailCCHeader, winStatus;

var bool bFromSortOrder;
var bool bSubjectSortOrder;
var DeusExPlayer player;

var localized String NoEmailTodayText,EmailFromHeader,EmailToHeader,EmailCarbonCopyHeader,EmailSubjectHeader;
var localized string HeaderFromLabel,HeaderSubjectLabel,strOptions,strSave,strLogout;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	player = DeusExPlayer(PlayerOwner().pawn);
	CreateControls();
}

function CreateControls()
{
  winStatus = new(none) class'GUILabel';
  winStatus.bBoundToParent = true;
  winStatus.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  winStatus.caption = "";
  winStatus.TextFont="UT2SmallFont";
  winStatus.bMultiLine = false;
  winStatus.TextAlign = TXTA_Left;
  winStatus.VertAlign = TXTA_Center;
  winStatus.FontScale = FNS_Small;
 	winStatus.WinHeight = 20;
  winStatus.WinWidth = 494;
  winStatus.WinLeft = 18;
  winStatus.WinTop = 497;
	AppendComponent(winStatus, true);

  lstEmail = new(none) class'EmailListBox';
  lstEmail.MyScrollBar.WinWidth = 16;
  lstEmail.Header.FontScale = FNS_Small;
  lstEmail.FontScale = FNS_Small;
  lstEmail.OnClick = InternalOnClick;
  lstEmail.bVisibleWhenEmpty = True;
  lstEmail.StyleName="STY_DXR_Listbox";
	lstEmail.WinHeight = 97;
  lstEmail.WinWidth = 493;
  lstEmail.WinLeft = 17;
  lstEmail.WinTop = 22;
	AppendComponent(lstEmail, true);

	winEmail = new(none) class'GUIScrollTextBox';
  winEmail.MyScrollBar.WinWidth = 16;
  winEmail.StyleName="STY_DXR_DeusExScrollTextBox";
  winEmail.FontScale=FNS_Small;
	winEmail.WinHeight = 322;
  winEmail.WinWidth = 490;
  winEmail.WinLeft = 18;
  winEmail.WinTop = 172;
  winEmail.bRepeat = false;
  winEmail.bNoTeletype = false;//true;
  winEmail.OnClick = InternalOnClick;
  winEmail.EOLDelay = 0.1;//75;
  winEmail.CharDelay = 0.005;
  winEmail.RepeatDelay = 3.0;
	AppendComponent(winEmail, true);

  winEmailFrom = new(none) class'GUILabel';
  winEmailFrom.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
//  winEmailFrom.default.caption = EmailFromHeader;
  winEmailFrom.bBoundToParent = true;
  winEmailFrom.TextFont="UT2HeaderFont";
  winEmailFrom.FontScale = FNS_Small;
 	winEmailFrom.WinHeight = 21;
  winEmailFrom.WinWidth = 221;
  winEmailFrom.WinLeft = 21;
  winEmailFrom.WinTop = 124;
	AppendComponent(winEmailFrom, true);

  winEmailTo = new(none) class'GUILabel';
  winEmailTo.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
//  winEmailTo.default.caption = EmailToHeader;
  winEmailTo.bBoundToParent = true;
  winEmailTo.TextFont="UT2HeaderFont";
  winEmailTo.FontScale = FNS_Small;
 	winEmailTo.WinHeight = 21;
  winEmailTo.WinWidth = 221;
  winEmailTo.WinLeft = 21;
  winEmailTo.WinTop = 146;
	AppendComponent(winEmailTo, true);

  winEmailSubject = new(none) class'GUILabel';
  winEmailSubject.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
//  winEmailSubject.default.caption = EmailSubjectHeader;
  winEmailSubject.TextFont="UT2HeaderFont";
  winEmailSubject.bBoundToParent = true;
  winEmailSubject.FontScale = FNS_Small;
 	winEmailSubject.WinHeight = 21;
  winEmailSubject.WinWidth = 221;
  winEmailSubject.WinLeft = 284;
  winEmailSubject.WinTop = 124;
	AppendComponent(winEmailSubject, true);

	winEmailCCHeader = new(none) class'GUILabel';
  winEmailCCHeader.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
//  winEmailCCHeader.default.caption = EmailCarbonCopyHeader;
  winEmailCCHeader.TextFont="UT2HeaderFont";
  winEmailCCHeader.bBoundToParent = true;
  winEmailCCHeader.FontScale = FNS_Small;
 	winEmailCCHeader.WinHeight = 21;
  winEmailCCHeader.WinWidth = 221;
  winEmailCCHeader.WinLeft = 284;
  winEmailCCHeader.WinTop = 146;
	AppendComponent(winEmailCCHeader, true);

	btnLogout = new(none) class'GUIButton';
  btnLogout.bBoundToParent = true;
  btnLogout.OnClick = InternalOnClick;
  btnLogout.FontScale = FNS_Small;
  btnLogout.Caption = strLogout;
  btnLogout.StyleName="STY_DXR_MediumButton";
  btnLogout.OnClick = InternalOnClick;
  btnLogout.WinHeight = 21;
  btnLogout.WinWidth = 129;
  btnLogout.WinLeft = 390;
  btnLogout.WinTop = 532;
  AppendComponent(btnLogout, true);

  /* Save current text to Datavault */
	btnSave = new(none) class'GUIButton';
  btnSave.bBoundToParent = true;
  btnSave.OnClick = InternalOnClick;
  btnSave.FontScale = FNS_Small;
  btnSave.Caption = strSave;
  btnSave.StyleName = "STY_DXR_MediumButton";
  btnSave.OnClick = InternalOnClick;
  btnSave.WinHeight = 21;
  btnSave.WinWidth = 144;
  btnSave.WinLeft = 245;
  btnSave.WinTop = 532;
  AppendComponent(btnSave, true);
}

function CloseScreen(String action)
{
	if (winTerm != None)
		winTerm.CloseHackAccountsWindow();

	Super.CloseScreen(action);
}


// ----------------------------------------------------------------------
// SetNetworkTerminal()
// ----------------------------------------------------------------------

function SetNetworkTerminal(NetworkTerminal newTerm)
{
	Super.SetNetworkTerminal(newTerm);

	if (winTerm.AreSpecialOptionsAvailable())
	{
	    btnSpecial = new(none) class'GUIButton';
	    btnSpecial.bBoundToParent = true;
	    btnSpecial.OnClick = InternalOnClick;
      btnSpecial.FontScale = FNS_Small;
      btnSpecial.Caption = strOptions;
      btnSpecial.StyleName="STY_DXR_MediumButton";
      btnSpecial.OnClick = InternalOnClick;
      btnSpecial.WinHeight = 21;
      btnSpecial.WinWidth = 129;
      btnSpecial.WinLeft = 10;
      btnSpecial.WinTop = 532;
	    AppendComponent(btnSpecial, true);
	}
	// Create the Hack Accounts window (will only be created
	// if the user hacked into the computer)
	winTerm.CreateHackAccountsWindow();
}

// ----------------------------------------------------------------------
// SetCompOwner()
// ----------------------------------------------------------------------

function SetCompOwner(ElectronicDevices newCompOwner)
{
	local String emailName;
	local String missionNumber;
	local DeusExLevelInfo info;

	Super.SetCompOwner(newCompOwner);

	info = player.GetLevelInfo();

	// hack for the DX.DX splash level
	if (info != None) 
	{
		if (info.MissionNumber < 10)
			MissionNumber = "0" $ String(info.MissionNumber);
		else
			MissionNumber = String(info.MissionNumber);
	}

	// Open the email menu based on the login id
	// or if it's been hacked, use the first account in the list
	emailName = MissionNumber $ "_EmailMenu_" $ winTerm.GetUserName();

//	log("emailName ="@emailName);
  winStatus.Caption = "Daedalus:GlobalNode:" $ Computers(compOwner).GetNodeAddress() $ "/" $ ComputerNodeFunctionLabel;

	fillEmailList(emailName);
}

function fillEmailList(string istok)
{
  local array<string> parts;
  local EmailList mlist;
  local ExtString es;
  local int x;

  mlist = lstEmail.aList;

  es = ExtString(DynamicLoadObject(Computers(compOwner).TextPackage$"."$istok, class'Extension.ExtString'));

  if (es == none)
  {
    winEmail.SetContent(NoEmailTodayText);
    return;
  }

  mlist.Clear();
  mlist.myMailList.length = es.text.length;

	for(x=0; x<es.text.length; x++)
	{
    Split(class'DxUtil'.static.HtmlStrip(es.text[x]),",",parts);
	  mlist.myMailList[x].Title = parts[1];
	  mlist.myMailList[x].From = parts[2];
	  mlist.myMailList[x].To = parts[3];
	  mlist.myMailList[x].cc = parts[4];

	  mlist.myMailList[x].text = ExtString(DynamicLoadObject(Computers(compOwner).TextPackage$"."$parts[0], class'Extension.ExtString')).text;
	  mlist.AddedItem();
	}
}

function fillEmailHeaders(string from,string to,string subject,string cc)
{
  winEmailFrom.Caption = EmailFromHeader @from;
  winEmailTo.Caption = EmailToHeader @to;
  winEmailSubject.Caption = EmailSubjectHeader @subject;
  winEmailCCHeader.caption = EmailCarbonCopyHeader @cc;

  winEmailCCHeader.bVisible = (cc != "");
}

function bool InternalOnClick(GUIComponent Sender)
{
  if (Sender==btnSpecial)
			CloseScreen("SPECIAL");

	if (Sender==btnLogout)
			CloseScreen("EXIT");

return false;
}

function EmailListChanged(GUIComponent Sender)
{
  local int x;

  winEmail.SetContent("");
  if (lstEmail.aList != none) // Я верю в тебя, но осторожность не повредит ))
  {
    for(x=0; x<lstEmail.aList.myMailList[lstEmail.alist.CurrentListId()].text.length; x++)
    {
       winEmail.AddText(class'DxUtil'.static.HtmlStrip(lstEmail.aList.myMailList[lstEmail.alist.CurrentListId()].text[x]));
    }
   fillEmailHeaders(lstEmail.aList.myMailList[lstEmail.alist.CurrentListId()].from,
                    lstEmail.aList.myMailList[lstEmail.alist.CurrentListId()].to,
                    lstEmail.aList.myMailList[lstEmail.alist.CurrentListId()].Title, 
                    class'DxUtil'.static.HtmlStripB(lstEmail.aList.myMailList[lstEmail.alist.CurrentListId()].cc));
  }
}

// If the account changes, the reload this screen, baby!
function ChangeAccount()
{
	Super.ChangeAccount();

	CloseScreen("EMAIL");
}

//event Opened(GUIComponent Sender);

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    bFromSortOrder=True
    NoEmailTodayText="No Email Today!"
    EmailFromHeader="From:"
    EmailToHeader="To:"
    EmailCarbonCopyHeader="CC:"
    EmailSubjectHeader="Subj:"
    HeaderFromLabel="From"
    HeaderSubjectLabel="Subject"
    escapeAction="LOGOUT"
    WinTitle="Email"
    strLogout="Close"
    strOptions="Special Options"
    strSave="Save to Datavault"
    ComputerNodeFunctionLabel="Email"

 		leftEdgeCorrectorX=4
		leftEdgeCorrectorY=0
		leftEdgeHeight=545

		RightEdgeCorrectorX=521
		RightEdgeCorrectorY=20
		RightEdgeHeight=523

		TopEdgeCorrectorX=269
		TopEdgeCorrectorY=16
    TopEdgeLength=250

    TopRightCornerX=519
    TopRightCornerY=16


		DefaultHeight=512
		DefaultWidth=512
		MaxPageHeight=512
		MaxPageWidth=512
		MinPageHeight=512
		MinPageWidth=512

	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Texture'DXR_Email'
		ImageRenderStyle=MSTY_Normal
		ImageStyle=ISTY_Tiled
		ImageColor=(R=255,G=255,B=255,A=255)
		DropShadow=None
		WinWidth=512
		WinHeight=512
		WinLeft=8
		WinTop=20
		RenderWeight=0.000003
		bBoundToParent=True
		bScaleToParent=True
    OnRendered=PaintOnBG
	End Object
	i_FrameBG=FloatingFrameBackground
}
