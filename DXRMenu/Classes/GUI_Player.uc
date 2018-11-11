/*-----------------------------------------------------------
  Управление игроком

1  Инвентарь (Inventory)
2  Здоровье (Health)
3  Приращения (Augmentations)
4  Навыки (Skills)
5  Цели/Заметки (Goals/Notes)
6  Диалоги (Conversations)
7  Изображения (Images)
8  Логи (Logs)

0  Выход (Exit)

-----------------------------------------------------------*/

Class GUI_Player extends GUIPage;

var() DXRTabControl pmTabs;
var() GUIImage NavBar;
var GUIButton bExit;
var(leftPart) float lFrameX, lframeY, lfSizeX, lfSizeY;
var(midPart) float mFrameX, mframeY, mfSizeX, mfSizeY;
var(rightPart) float rFrameX, rframeY, rfSizeX, rfSizeY;

var(TabBackground) float TabBackgroundX, TabBackgroundY;

var localized string strInventory, strHealth, strAugs, strSkills, strGoals, strImages, strConversations, strLogs;
var DeusExGlobals gl;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.InitComponent(MyController, MyOwner);
    gl = class'DeusExGlobals'.static.GetGlobals();

    pmTabs = new(none) class'DXRTabControl';
    pmTabs.WinWidth = 800;
		pmTabs.WinLeft = controller.ResX/2 - 400;
		pmTabs.WinTop = controller.ResY/2 - 320;
		pmTabs.WinHeight=2.1;//48;
//		pmTabs.TabHeight=32;//0.04;
		pmTabs.bAcceptsInput=true;
		pmTabs.bDockPanels=true;
	
    AppendComponent(pmTabs, true);


    GUIHeader(Controls[0]).DockedTabs = pmTabs;

    /*GUIHeader(Controls[0]).*/WinLeft=controller.ResX/2 - 400;
    /*GUIHeader(Controls[0]).*/WinTop=controller.ResY/2 - 320;

    pmTabs.WinLeft=controller.ResX/2 - 400;

    pmTabs.AddTab(strInventory,"DXRMenu.gui_Inventory");

    pmTabs.AddTab(strHealth,"DXRMenu.gui_Health");
    pmTabs.AddTab(strAugs,"DXRMenu.gui_Augmentations");
    pmTabs.AddTab(strSkills,"DXRMenu.gui_Skills");

    pmTabs.AddTab(strGoals,"DXRMenu.gui_Goals");
    pmTabs.AddTab(strImages,"DXRMenu.gui_Images");
    pmTabs.AddTab(strConversations,"DXRMenu.gui_Conversations");
    pmTabs.AddTab(strLogs,"DXRMenu.gui_Logs");

/*    NavBar = new(none) class'GUIImage';
    NavBar.bBoundToParent = true;
    NavBar.WinWidth=800;
		NavBar.WinHeight=64;
		NavBar.WinLeft=0;
		NavBar.WinTop=0;
		NavBar.Image = texture'DXR_NavBar';
    AppendComponent(NavBar, true);
  */

/*-- Кнопка "Выход" --------------------------------------------------------------------------------*/
  bExit = new(none) class'GUIButton';
  bExit.FontScale = FNS_Small;
  bExit.Caption = "Exit";
  bExit.Hint = "Exit";
  bExit.StyleName="STY_DXR_ButtonNavbar";
  bExit.bBoundToParent = true;
  bExit.OnClick = InternalOnClick;
  bExit.WinHeight = 21;
  bExit.WinWidth = 68;
  bExit.WinLeft = 726;
  bExit.WinTop = 0;//-11;
	AppendComponent(bExit, true);
}

function IWantToDrawSomething(canvas u)
{
  local float x,y;

  x = ActualLeft(); y = ActualTop();

//  u.SetDrawColor(0,255,128,255);
  u.DrawColor = class'DXR_Menu'.static.GetPlayerInterfaceFrames(gl.MenuThemeIndex);
  u.Style = EMenuRenderStyle.MSTY_Translucent;
  u.SetPos(x + lFrameX, y + lframeY);
  u.drawtileStretched(texture'DXR_NavBarBorder_1', lfSizeX, lfSizeY);

  u.SetPos(x + mFrameX, y + mframeY);
  u.drawtileStretched(texture'DXR_NavBarBorder_2', mfSizeX, mfSizeY);

  u.SetPos(x + rFrameX, y + rframeY);
  u.drawtileStretched(texture'DXR_NavBarBorder_3', rfSizeX, rfSizeY);

  // DXR: colors in required style are ignored, so draw buttons background here...
  u.SetPos(x - TabBackgroundX ,y - TabBackgroundY);
  u.DrawColor=class'DXR_Menu'.static.GetPlayerInterfaceTabsBackground(gl.MenuThemeIndex);
  u.DrawIcon(texture'DXR_NavBar',1);
}


function bool InternalOnClick(GUIComponent Sender)
{
  if (Sender==bExit)
  {
    Controller.CloseMenu();
  }
return true;
}


function InternalOnOpen()
{
 if (DeusExPlayer(PlayerOwner().pawn).UIBackground == 0) // 0 = Render 3D
 {
     DeusExHUD(PlayerOwner().myHUD).cubemapmode = true;
 }
 else if (DeusExPlayer(PlayerOwner().pawn).UIBackground == 1) // 1 = Snapshot
 {
     DeusExHUD(PlayerOwner().myHUD).midMenuMode = true;
 }
 else if (DeusExPlayer(PlayerOwner().pawn).UIBackground == 2) // 2 = Black
 {
     DeusExHUD(PlayerOwner().myHUD).menuMode = true;
 }
 /*----------------------------------------------------*/
 if (DeusExPlayer(PlayerOwner().pawn).InterfaceMode == 0)
 {
     PlayerOwner().SetPause(true);
 }
 else if (DeusExPlayer(PlayerOwner().pawn).InterfaceMode == 1)
 {
     PlayerOwner().Level.game.SetGameSpeed(0.1);
     DeusExPlayer(PlayerOwner().pawn).Blur(5);
 }
 else if (DeusExPlayer(PlayerOwner().pawn).InterfaceMode == 2)
 {
     PlayerOwner().SetPause(false); // Just in case...
 }
}

function InternalOnClose(bool bCancelled)
{
  RestoreHUD();
  RestoreGameMode();
}

event Free()            // This control is no longer needed
{
  RestoreHUD();
  RestoreGameMode();
  super.free();
}

function RestoreHUD()
{
  DeusExHUD(PlayerOwner().myHUD).cubemapmode = false;
  DeusExHUD(PlayerOwner().myHUD).menuMode = false;
  DeusExHUD(PlayerOwner().myHUD).midMenuMode = false;
}

function RestoreGameMode()
{
  PlayerOwner().Level.game.SetGameSpeed(1.0);
  DeusExPlayer(PlayerOwner().pawn).unblur();
  PlayerOwner().SetPause(false);
}

//var globalconfig int InterfaceMode; // 0 = Pause game, 1 = Set gamespeed to 0.1, 2 = Do nothing (RealTime)

//var globalconfig int  UIBackground;					// 0 = Render 3D, 1 = Snapshot, 2 = Black
//cubemapmode // Render 3D
//menuMode // Черный
//midMenuMode // Растянутый фон



defaultproperties
{
   strInventory=" Inventory "

   strHealth=" Health "
   strAugs=" Augmentations "
   strSkills="  Skills  "

   strGoals=" Goals/Notes "
   strImages="  Images  "
   strConversations=" Conversations "
   strLogs=" Logs History "

   bRenderWorld=true
   bAllowedAsLast=True

 lFrameX=-23
 lframeY=-55
 lfSizeX=384
 lfSizeY=138

 mFrameX=361
 mframeY=-8
 mfSizeX=307
 mfSizeY=42

 rFrameX=668
 rframeY=-59
 rfSizeX=148
 rfSizeY=138

 TabBackgroundX=6
 TabBackgroundY=5



  Begin Object class=GUIHeader name=dxHeader
		Caption=""
//		StyleName="STY_DXR_Navbar"
		StyleName=""
		WinWidth=810
		WinHeight=32.0
		WinLeft=-6.00
		WinTop=-5.00
		bBoundToParent=true
		DockAlign=PGA_None
	End Object
	Controls(0)=dxHeader

/*  Begin Object Class=GUITabControl Name=dxtab
		WinWidth=800
		WinLeft=0
		WinTop=0.0
		WinHeight=48
		TabHeight=0.04
		bAcceptsInput=true
		bDockPanels=true
	End Object
  Controls(1)=dxtab*/

    OnOpen=GUI_Player.InternalOnOpen
    OnClose=GUI_Player.InternalOnClose
    OnRendered=IWantToDrawSomething

  Background=none
	WinWidth=800
	WinHeight=600
	WinTop=0.0
	WinLeft=0.0
}
