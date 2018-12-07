/* Загрузить сохранение */
class DXRLoadWindow extends DxWindowTemplate;//floatingwindow;

CONST MAXSAVESLOTS = 100;

var /*automated*/ DXRSaveListBox lSaveList;
var automated GUIButton bLoad, bDelete, bClose;
var automated GUIScrollTextBox tDesc;
var automated GUIImage sScreenShot;
/*var automated GUIEditBox eSaveNameAlt;
var automated GUIEditBox eSaveName;
var automated GUILabel saveLabelAlt;
var automated GUILabel saveLabel;*/
var() float ListItemsOffset;
var int midX, midY;
var bool bCentered;

var localized string SaveLabelCaption;

function CreateMyControls()
{
/*  saveLabel = new(none) class'GUILabel';
  saveLabel.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  saveLabel.caption = SaveLabelCaption;
  saveLabel.TextFont="UT2SmallFont";
  saveLabel.FontScale = FNS_Small;
 	saveLabel.WinHeight = 21;
  saveLabel.WinWidth = 221;
  saveLabel.WinLeft = 556;
  saveLabel.WinTop = 100;
	AppendComponent(saveLabel, true);

  saveLabelAlt = new(none) class'GUILabel';
  saveLabelAlt.TextColor = class'Canvas'.static.MakeColor(255, 255, 255);
  saveLabelAlt.caption = "Directory name";
  saveLabelAlt.TextFont="UT2SmallFont";
  saveLabelAlt.FontScale = FNS_Small;
 	saveLabelAlt.WinHeight = 21;
  saveLabelAlt.WinWidth = 221;
  saveLabelAlt.WinLeft = 556;
  saveLabelAlt.WinTop = 50;
	AppendComponent(saveLabelAlt, true);*/

  lSaveList = new(none) class'DXRSaveListBox'; // список
  lSaveList.MyScrollBar.WinWidth = 16;
  lSaveList.Header.FontScale = FNS_Small;
  lSaveList.FontScale = FNS_Small;
  lSaveList.OnClick=InternalOnClick;
  lSaveList.bVisibleWhenEmpty = True;
  lSaveList.StyleName="STY_DXR_Listbox";
	lSaveList.WinHeight = 256;
  lSaveList.WinWidth = 512;
  lSaveList.WinLeft = 24;
  lSaveList.WinTop = 304;
	AppendComponent(lSaveList, true);

/*  eSaveNameAlt = new(none) class'GUIEditBox'; // имя каталога
	eSaveNameAlt.bScaleToParent = false;
	eSaveNameAlt.FontScale = FNS_Small;
	eSaveNameAlt.bMaskText = false;
	eSaveNameAlt.MaxWidth = 128;
	eSaveNameAlt.WinHeight = 21;
  eSaveNameAlt.WinWidth = 221;
  eSaveNameAlt.WinLeft = 556;
  eSaveNameAlt.WinTop = 70;
	AppendComponent(eSaveNameAlt, true);

  eSaveName = new(none) class'GUIEditBox'; // имя
	eSaveName.bScaleToParent = false;
	eSaveName.FontScale = FNS_Small;
	eSaveName.bMaskText = false;
	eSaveName.MaxWidth = 128;
	eSaveName.WinHeight = 21;
  eSaveName.WinWidth = 221;
  eSaveName.WinLeft = 556;
  eSaveName.WinTop = 120;
	AppendComponent(eSaveName, true);*/

  sScreenShot = new(none) class'GUIImage'; // скриншот (512x256)
  sScreenShot.image = TexPanner'DeusExControls.Controls.Static';
  sScreenShot.ImageRenderStyle = MSTY_Normal;
  sScreenShot.ImageStyle = ISTY_Tiled;
	sScreenShot.WinHeight = 256;
  sScreenShot.WinWidth = 512;
  sScreenShot.WinLeft = 24;
  sScreenShot.WinTop = 44;
	AppendComponent(sScreenShot, true);

  /*--- Кнопки ----------------------*/
  bDelete = new(none) class'GUIButton'; // Кнопка "удалить"
  bDelete.OnClick=InternalOnClick;
  bDelete.StyleName="STY_DXR_DeusExRectButton";
  bDelete.Caption = "Delete";
	bDelete.WinHeight = 37;
  bDelete.WinWidth = 221;
  bDelete.WinLeft = 556;
  bDelete.WinTop = 160;
	AppendComponent(bDelete, true);

  bLoad = new(none) class'GUIButton'; // ..."сохранить"
  bLoad.OnClick=InternalOnClick;
  bLoad.StyleName="STY_DXR_DeusExRectButton";
  bLoad.Caption = "Load game";
	bLoad.WinHeight = 37;
  bLoad.WinWidth = 221;
  bLoad.WinLeft = 556;
  bLoad.WinTop = 204;
	AppendComponent(bLoad, true);

  bClose = new(none) class'GUIButton'; // ..."закрыть"
  bClose.OnClick=InternalOnClick;
  bClose.StyleName="STY_DXR_DeusExRectButton";
  bClose.Caption = "Close";
	bClose.WinHeight = 37;
  bClose.WinWidth = 221;
  bClose.WinLeft = 556;
  bClose.WinTop = 248;
	AppendComponent(bClose, true);
  /*---------------------------------*/

  tDesc = new(none) class'GUIScrollTextBox'; // описание (считывается из SaveInfo.dxs)
  tDesc.StyleName="STY_DXR_DeusExScrollTextBox";
  tDesc.FontScale=FNS_Small;
	tDesc.WinHeight = 256;
  tDesc.WinWidth = 240;
  tDesc.WinLeft = 540;
  tDesc.WinTop = 304;
  tDesc.bRepeat = false;//true;
  tDesc.bNoTeletype = gl.bUseCursorEffects;
  tDesc.EOLDelay = 0.1;//75;
  tDesc.CharDelay = 0.005;
  tDesc.RepeatDelay = 3.0;
	AppendComponent(tDesc, true);

}

function testfuncB()
{
   log(class@"testfuncB");
}

function DeleteSaveGame()
{
log("Do you see this ? :)");
}


function bool InternalOnClick(GUIComponent Sender)
{
//  local texture shot;
//  lSaveList.aList.InternalOnClick(none);
//  tdesc.SetContent(lSaveList.alist.SaveData[lSaveList.alist.CurrentListId()].ExtraData);
  if(Sender==lSaveList.alist)
  {
    tdesc.SetContent(lSaveList.alist.SaveData[lSaveList.alist.CurrentListId()].ExtraData);
  }

	if(Sender==bLoad)
	{
    log(lSaveList.alist.SaveData[lSaveList.alist.CurrentListId()].SaveName);
    log(lSaveList.alist.SaveData[lSaveList.alist.CurrentListId()].ExtraData);

    PlayerOwner().level.game.SendPlayer(DeusExPlayerController(PlayerOwner()), lSaveList.alist.SaveData[lSaveList.alist.CurrentListId()].map);//$"?load");
	}
	if(Sender==bDelete)
	{
	  Controller.OpenMenu("DXRMenu.DXRDeleteSaveQuestion", lSaveList.alist.SaveData[lSaveList.alist.CurrentListId()].SaveName);
/*    if (lSaveList.aList.SaveData.length == 0)
    {
      tdesc.SetContent("ERROR !");
      tdesc.AddText("Nothing to delete!");
      return false;
    }
    else
    {

    }*/
	}
  if(Sender==bClose)
	{
  	lSaveList.alist.Dump();
    Controller.CloseMenu();
	}
	return false;
}

//	PlayerOwner().ConsoleCommand("Admin Kick"@MyPlayerList.MyPlayers[MyPlayerList.Index].PlayerName);

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);
  CreateMyControls();
  lSaveList.aList.index = 0;
  lSaveList.aList.InternalOnClick(none);
}

function AddSystemMenu();

// index -- текущий выбранный элемент
// ItemCount -- общее кол-во элементов.

function bool AlignFrame(Canvas C)
{
/*  midX = Controller.ResX/2;
  midY = Controller.ResY/2;

  WinLeft = midX - 400;
  WinTop  = midY - 300;
  bCentered=true;

  lSaveList.aList.CellSpacing = 384 - midX;*/
  if (bVisible)
  {
   winleft = (controller.resX/2) - (MaxPageWidth/2);
   lSaveList.List.CellSpacing = 384 - (Controller.ResX/2);
  }
  else
  winleft = -2000;


	return bInit;
}


/*function PaintOnHeader(Canvas C)
{
  local texture icon;//, bubble;

  icon = texture'DeusExSmallIcon';
  C.SetPos(t_WindowTitle.ActualLeft() + 8, t_WindowTitle.ActualTop() + 3);
  C.SetDrawColor(255,255,255);
  C.DrawIcon(icon, 1);
}*/

/*event Opened(GUIComponent Sender)                   // Called when the Menu Owner is opened
{
  if (ParentPage != none)
  ParentPage.bVisible=false;
}

event Closed(GUIComponent Sender, bool bCancelled)  // Called when the Menu Owner is closed
{
  if (ParentPage != none)
  ParentPage.bVisible=true;
}*/

// Содержимое списка на месте при -256, окно в центре.
// Содержимое списка на месте при 0, окно в крайнем левом положении.
// Содержимое списка на месте при -512, окно в крайнем правом положении.
defaultproperties
{
    openSound=sound'DeusExSounds.UserInterface.Menu_Activate'

    SaveLabelCaption="Description (internal):"

    ListItemsOffset=-256

		DefaultHeight=600
		DefaultWidth=800

		MaxPageHeight=600
		MaxPageWidth=800
		MinPageHeight=600
		MinPageWidth=800

		winleft=200
		wintop=200

		bCaptureMouse=true
    bAcceptsInput=true

    WinTitle="Load Game"
  /* Фон окошка */
	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Material'DeusExControls.Background.DX_WinBack_BW'
		ImageRenderStyle=MSTY_Normal //Translucent //Normal
		ImageStyle=ISTY_PartialScaled
		ImageColor=(R=255,G=255,B=255,A=255)
		DropShadow=None
		WinWidth=795
		WinHeight=580
		WinLeft=4
		WinTop=18
		RenderWeight=0.000003
		bBoundToParent=True
		bScaleToParent=True
	End Object
	i_FrameBG=FloatingFrameBackground
  /* Заголовок */
	Begin Object Class=GUIHeader Name=TitleBar
		WinWidth=0.8
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

