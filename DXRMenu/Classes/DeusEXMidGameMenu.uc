/*--------------------------------------------------------------------
  Меню "Пауза"
--------------------------------------------------------------------*/

class DeusExMidGameMenu extends DxWindowTemplate;

#EXEC OBJ LOAD FILE=GuiContent.utx
#EXEC OBJ LOAD FILE=2K4Menus.utx
#exec OBJ LOAD FILE=DeusExUI.u

var bool bIgnoreEsc;

var Automated GUIButton bContinue, bQuit, bExitCurrent, bSettings, bSaveGame, bLoadGame;
var localized string strContinue, strQuit, strExitCurrent, strSettings, strSaveGame, strLoadGame;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);
  CreateMControls();
}


// Нужно для того, чтобы фон не жил своей жизнью.
function bool AlignFrame(Canvas C)
{
  if (bVisible)
  winleft = (controller.resX/2) - MaxPageWidth/2;
  else
  winleft = -2000;

	return bInit;
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{
	// Swallow first escape key event (key up from key down that opened menu)
	if(bIgnoreEsc && Key == 0x1B)
	{
		bIgnoreEsc = false;
		return true;
	}
	return false;
}

/*
Back to Game
Settings
Save Game
Load Game
Exit current Game
Exit
*/

function CreateMControls()
{
  bContinue = new(none) class'GUIButton';
  bContinue.OnClick=InternalOnClick;
  bContinue.StyleName="STY_DXR_DeusExRectButton";
  bContinue.Caption = strContinue;
  bContinue.WinHeight = 32;
  bContinue.WinWidth = 243;
  bContinue.WinLeft = 16;
  bContinue.WinTop = 33;
	AppendComponent(bContinue, true);

  bSettings = new(none) class'GUIButton';
  bSettings.OnClick=InternalOnClick;
  bSettings.StyleName="STY_DXR_DeusExRectButton";
  bSettings.Caption = strSettings;
  bSettings.WinHeight = 32;
  bSettings.WinWidth = 243;
  bSettings.WinLeft = 16;
  bSettings.WinTop = 70;
	AppendComponent(bSettings, true);

  bSaveGame = new(none) class'GUIButton';
  bSaveGame.OnClick=InternalOnClick;
  bSaveGame.StyleName="STY_DXR_DeusExRectButton";
  bSaveGame.Caption = strSaveGame;
  bSaveGame.WinHeight = 32;
  bSaveGame.WinWidth = 243;
  bSaveGame.WinLeft = 16;
  bSaveGame.WinTop = 105;
	AppendComponent(bSaveGame, true);

  bLoadGame = new(none) class'GUIButton';
  bLoadGame.OnClick=InternalOnClick;
  bLoadGame.StyleName="STY_DXR_DeusExRectButton";
  bLoadGame.Caption = strLoadGame;
  bLoadGame.WinHeight = 32;
  bLoadGame.WinWidth = 243;
  bLoadGame.WinLeft = 16;
  bLoadGame.WinTop = 142;
	AppendComponent(bLoadGame, true);

  bExitCurrent = new(none) class'GUIButton';
  bExitCurrent.OnClick=InternalOnClick;
  bExitCurrent.StyleName="STY_DXR_DeusExRectButton";
  bExitCurrent.Caption = strExitcurrent;
  bExitCurrent.WinHeight = 32;
  bExitCurrent.WinWidth = 243;
  bExitCurrent.WinLeft = 16;
  bExitCurrent.WinTop = 177;
	AppendComponent(bExitCurrent, true);

  bQuit = new(none) class'GUIButton';
  bQuit.OnClick=InternalOnClick;
  bQuit.RenderWeight = 1.0;
  bQuit.StyleName="STY_DXR_DeusExRectButton";
  bQuit.Caption = strQuit;
  bQuit.WinHeight = 32;
  bQuit.WinWidth = 243;
  bQuit.WinLeft = 16;
  bQuit.WinTop = 214;
	AppendComponent(bQuit, true);
}

event Opened(GUIComponent Sender)
{
  super.Opened(Sender);
	DeusExHUD(playerOwner().myHUD).midMenuMode = true;
}

event Closed(GUIComponent Sender, bool bCancelled)  // Called when the Menu Owner is closed
{
  super.Closed(Sender, bCancelled);
	DeusExHUD(playerOwner().myHUD).midMenuMode = false;
}


function InternalOnClose(optional Bool bCanceled)
{
	local PlayerController pc;

	pc = PlayerOwner();

	// Turn pause off if currently paused
	if(pc != None && pc.Level.Pauser != None)
		pc.SetPause(false);

	Super.OnClose(bCanceled);
}

function bool InternalOnClick(GUIComponent Sender)
{
	if(Sender==bQuit) // QUIT
	{
		return Controller.OpenMenu("DXRMenu.DXRQuitMessage");
	}
	if(Sender==bExitCurrent) // Exit to Main Menu
	{
	  log(Sender);
	  Controller.OpenMenu("DXRMenu.DXRExitCurrentGameQuestion");
	}
	if(Sender==bContinue) // CONTINUE
	{
		Controller.CloseMenu(); // Назад в игру
	}
	if(Sender==bSettings) // SETTINGS
	{
		return Controller.OpenMenu(Controller.GetSettingsPage());
	}
	if(Sender==bSaveGame)
	{
		return Controller.OpenMenu("DXRMenu.DXRSaveWindow");
	}
	if(Sender==bLoadGame)
	{
		return Controller.OpenMenu("DXRMenu.DXRLoadWindow");
	}
//	return true;
}

function InternalOnMouseRelease(GUIComponent Sender)
{
	if (Sender == Self)
		Controller.CloseMenu();
}

function AddSystemMenu(); // stub

defaultproperties
{
    strContinue="Back to Game"
    strQuit="Exit" 
    strExitCurrent="Exit current Game"
    strSettings="Settings"
    strSaveGame="Save Game"
    strLoadGame="Load Game"

    openSound=sound'DeusExSounds.UserInterface.Menu_Activate'

		DefaultHeight=249
		DefaultWidth=264

		MaxPageHeight=249
		MaxPageWidth=264
		MinPageHeight=249
		MinPageWidth=264

	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Texture'menumainbackground_1'
		ImageRenderStyle=MSTY_Translucent
		ImageStyle=ISTY_Tiled
		ImageColor=(R=255,G=255,B=255,A=255)
		DropShadow=None
		WinWidth=256
		WinHeight=229
		WinLeft=8
		WinTop=20
		RenderWeight=0.000003
		bBoundToParent=True
		bScaleToParent=True
	End Object
	i_FrameBG=FloatingFrameBackground
  /* Заголовок */
	Begin Object Class=GUIHeader Name=TitleBar
		WinWidth=0.98
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


		winleft=0.4
		wintop=0.3


    bIgnoreEsc=True
    WinTitle="Game paused..."

    bScaleToParent=false
    bRenderWorld=true
    bAllowedAsLast=True
    OnClose=DeusExMidGameMenu.InternalOnClose
//     OnPreDraw=DeusExMidGameMenu.InternalOnPreDraw
    OnMouseRelease=DeusExMidGameMenu.InternalOnMouseRelease
    OnKeyEvent=DeusExMidGameMenu.InternalOnKeyEvent
}
