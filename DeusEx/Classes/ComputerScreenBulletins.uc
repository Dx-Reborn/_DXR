/* Оконный интерфейс публичного терминала */

class ComputerScreenBulletins extends ComputerUIWindow;

const DefaultTextPackage = "DeusExText";

//var DeusExPlayer player;
var GUIListBox lstBulletins;
var GUIScrollTextBox winBulletin;
var string bulletinTag, textPack;
var GUILabel winHeader, winStatus;
var GUIButton btnSpecial, btnLogout;
var localized String NoBulletinsTodayText, BulletinsHeaderText, strLogout;

function CreateMyControls()
{
  winHeader = new(none) class'GUILabel';
  winHeader.bBoundToParent = true;
  winHeader.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  winHeader.caption = BulletinsHeaderText;
  winHeader.TextFont="UT2HeaderFont";
  winHeader.bMultiLine = false;
  winHeader.TextAlign = TXTA_Left;
  winHeader.VertAlign = TXTA_Center;
  winHeader.FontScale = FNS_Small;
 	winHeader.WinHeight = 20;
  winHeader.WinWidth = 300;
  winHeader.WinLeft = 16;
  winHeader.WinTop = 23;
	AppendComponent(winHeader, true);

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

  btnLogout = new(none) class'GUIButton';
  btnLogout.FontScale = FNS_Small;
  btnLogout.Caption = strLogout;
  btnLogout.Hint = "";
  btnLogout.StyleName="STY_DXR_MediumButton";
  btnLogout.bBoundToParent = true;
  btnLogout.OnClick = InternalOnClick;
  btnLogout.WinHeight = 21;
  btnLogout.WinWidth = 106;
  btnLogout.WinLeft = 413;
  btnLogout.WinTop = 530;
	AppendComponent(btnLogout, true);

  winBulletin = new(none) class'GUIScrollTextBox'; // Содержимое
  winBulletin.StyleName="STY_DXR_DeusExScrollTextBox_ex";
  winBulletin.FontScale=FNS_Small;
  winBulletin.bBoundToParent = true;
	winBulletin.WinHeight = 328;
  winBulletin.WinWidth = 492;
  winBulletin.WinLeft = 18;
  winBulletin.WinTop = 163;
  winBulletin.bRepeat = false;//true;
  winBulletin.bNoTeletype = gl.bUseCursorEffects;
  winBulletin.EOLDelay = 0.1;//75;
  winBulletin.CharDelay = 0.005;
  winBulletin.RepeatDelay = 3.0;
  winBulletin.MyScrollBar.WinWidth = 16;
	AppendComponent(winBulletin, true);

  lstBulletins = new(none) class'GUIListBox';
  lstBulletins.OnClick=InternalOnClick;
  lstBulletins.SelectedStyleName="STY_DXR_ListSelection";
  lstBulletins.StyleName = "STY_DXR_Listbox";
  lstBulletins.bBoundToParent = true;
  lstBulletins.OnChange=lstBulletinsChange;
  lstBulletins.WinHeight = 116;
  lstBulletins.WinWidth = 492;//407;
  lstBulletins.WinLeft = 18;
  lstBulletins.WinTop = 41;
	AppendComponent(lstBulletins, true);
	lstBulletins.List.TextAlign = TXTA_Left;
  lstBulletins.MyScrollBar.WinWidth = 16;

//	player = DeusExPlayer(playerOwner().pawn);
}

function fillList()
{
  local string fileName, title;
  local ExtString es;
  local int x;

  bulletinTag = string(ComputerPublic(compOwner).bulletinTag);
  textPack = ComputerPublic(compOwner).TextPackage;
  if (textPack == "")
      textPack=DefaultTextPackage;

  es = ExtString(DynamicLoadObject(TextPack$"."$bulletinTag, class'Extension.ExtString'));

  if ((es == none) || ComputerPublic(compOwner).bUseRandomMessages)
  {
    lstBulletins.List.Add(NoBulletinsTodayText);
    lstBulletins.OnChange=none;
    winBulletin.SetContent(class'DxUtil'.static.HtmlStrip(ComputerPublic(compOwner).extraMessages[rand(ComputerPublic(compOwner).extraMessages.length)]));
    winBulletin.bRepeat = true;
    return;
  }

  for (x=0; x<es.text.length; x++)
  {
//native(239) static final function bool   Divide ( coerce string Src, string Divider, out string LeftPart, out string RightPart);
    divide(class'DxUtil'.static.HtmlStrip(es.text[x]), ",", fileName, title);
    lstBulletins.List.Add(class'DxUtil'.static.HtmlStripB(title),,fileName);
  }
}

function lstBulletinsChange(GUIComponent Sender)
{
  local string textFile;
  local ExtString es;
  local int x;

  textFile = lstBulletins.List.GetExtra();

  es = ExtString(DynamicLoadObject(TextPack$"."$textFile, class'Extension.ExtString'));
  winBulletin.SetContent("");
  for (x=0; x<es.text.length; x++)
  {
    winBulletin.AddText(class'DxUtil'.static.HtmlStrip(es.text[x]));
  }
}


function SetCompOwner(ElectronicDevices newCompOwner)
{
	Super.SetCompOwner(newCompOwner);
	fillList();
	winStatus.Caption = "Daedalus:GlobalNode:" $ Computers(compOwner).GetNodeAddress() $ "/" $ ComputerNodeFunctionLabel;
}

function bool InternalOnClick(GUIComponent Sender)
{
   if (sender==btnLogout)
   CloseScreen("EXIT");

return false;
}

function InternalOnClose(optional bool bCancelled)
{
  if (WinTerm != none)
   WinTerm.SetTimer(0.1, false);
}

defaultproperties
{
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


    NoBulletinsTodayText="No Bulletins Today!"
    BulletinsHeaderText="Please choose a bulletin to view:"
    ComputerNodeFunctionLabel="Bulletins"
    WinTitle="Bulletins"
    strLogout="Close"
		DefaultHeight=512
		DefaultWidth=512
		MaxPageHeight=512
		MaxPageWidth=512
		MinPageHeight=512
		MinPageWidth=512

		OnClose=InternalOnClose

		openSound=sound'publicterminalfrob' // sound from GMDX mod

	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Texture'DXR_BulletinBackground'
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

	Begin Object Class=GUIHeader Name=TitleBar
		WinWidth=0.75
		WinHeight=128
		WinLeft=-2
		WinTop=-3
		RenderWeight=0.1
		FontScale=FNS_Small
		bUseTextHeight=false
		bAcceptsInput=True
		bNeverFocus=true //False
		bBoundToParent=true
		bScaleToParent=true
		OnMousePressed=FloatingMousePressed
		OnMouseRelease=FloatingMouseRelease
    OnRendered=PaintOnHeader
		ScalingType=SCALE_ALL
    StyleName="STY_DXR_DXWinHeader";
    Justification=TXTA_Left
	End Object
	t_WindowTitle=TitleBar
}