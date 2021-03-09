/* Содержит вкладки для медбота */

class MedBotInterface extends GUIPage;

var() DXRTabControl pmTabs;
var(medicalBot) medicalBot mb;
var GUIButton bExit;
var(leftPart) float lFrameX, lframeY, lfSizeX, lfSizeY;
var(midPart) float mFrameX, mframeY, mfSizeX, mfSizeY;
var(rightPart) float rFrameX, rframeY, rfSizeX, rfSizeY;
var(TabBackground) float TabBackgroundX, TabBackgroundY;
var localized string strHealth, strAugs;
var Localized String MedbotInterfaceText;
var DeusExGlobals gl;
var(textLabel) float miCorrectorY;


function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.InitComponent(MyController, MyOwner);
    gl = class'DeusExGlobals'.static.GetGlobals();

    pmTabs = new(none) class'DXRTabControl';
    pmTabs.WinWidth = 800;
        pmTabs.WinLeft = controller.ResX/2 - 400;
        pmTabs.WinTop = controller.ResY/2 - 320;
        pmTabs.WinHeight=2.1;
        pmTabs.bAcceptsInput=true;
        pmTabs.bDockPanels=true;
    AppendComponent(pmTabs, true);

    GUIHeader(Controls[0]).DockedTabs = pmTabs;
    WinLeft=controller.ResX/2 - 400;
    WinTop=controller.ResY/2 - 320;
    pmTabs.WinLeft=controller.ResX/2 - 400;

    pmTabs.AddTab(strHealth,"DXRMenu.MedBotHealthScreen");
    pmTabs.AddTab(strAugs,"DXRMenu.MedBotAddAugsScreen");



/*-- Кнопка "Выход" --*/
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

event HandleParameters(string Param1, string Param2)
{
  if (Param1 == "AUGS")
  pmTabs.ActivateTabByName(strAugs, true);

  else if (Param1 =="HEALTH")
  pmTabs.ActivateTabByName(strHealth, true);
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

  if (class'DXR_Menu'.static.GetBackgoundMode(gl.MenuThemeIndex) == 0) // STY_Normal
    u.Style = EMenuRenderStyle.MSTY_Masked;
   else if (class'DXR_Menu'.static.GetBackgoundMode(gl.MenuThemeIndex) == 1)
  u.Style = EMenuRenderStyle.MSTY_Translucent;
   else if (class'DXR_Menu'.static.GetBackgoundMode(gl.MenuThemeIndex) == 2)
  u.Style = EMenuRenderStyle.MSTY_Additive;
   else if (class'DXR_Menu'.static.GetBackgoundMode(gl.MenuThemeIndex) == 3)
   {
     u.Style = eMenuRenderStyle.MSTY_Alpha;
     u.DrawColor.A = class'DXR_Menu'.static.GetAlpha(gl.MenuThemeIndex);
   }

  u.DrawIcon(texture'DXR_NavBar_Fill',1);

  u.font = font'DxFonts.HR_9';
  u.SetPos(x + 500,y + miCorrectorY);
  u.DrawText(MedbotInterfaceText);

  u.reset(); // Это нужно, иначе кнопки с аугментациями для установки будут нарисованы на зеленом фоне 0_0
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
  DeusExHUD(PlayerOwner().myHUD).cubemapmode = true;
}

function InternalOnClose(bool bCancelled)
{
  DeusExHUD(PlayerOwner().myHUD).cubemapmode = false;

    if (gl.lastMedBot != None)
    {
//      if (!bSkipAnimation)
//      {
            gl.lastMedBot.PlayAnim('Stop');
            gl.lastMedBot.PlaySound(sound'MedicalBotLowerArm', SLOT_None);
            gl.lastMedBot.FollowOrders();
//      }
    }
}

event Free() // This control is no longer needed
{
  DeusExHUD(PlayerOwner().myHUD).cubemapmode = false;
  super.free();
}

function SetMedicalBot(MedicalBot newBot, optional bool bPlayAnim)
{
    if (newBot != None)
    {
        newBot.StandStill();

        if (bPlayAnim)
        {
            newBot.PlayAnim('Start');
            newBot.PlaySound(sound'MedicalBotRaiseArm', SLOT_None);
        }
    }
}





defaultproperties
{
   strHealth="   Health   "
   strAugs="   Augmentations   "
   MedbotInterfaceText="MEDBOT INTERFACE"
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

 miCorrectorY=6

  Begin Object class=GUIHeader name=dxHeader
        Caption=""
        StyleName=""
        WinWidth=810
        WinHeight=32.0
        WinLeft=-6.00
        WinTop=-5.00
        bBoundToParent=true
        DockAlign=PGA_None
    End Object
    Controls(0)=dxHeader

  OnOpen=InternalOnOpen
  OnClose=InternalOnClose
//  OnRendered=IWantToDrawSomething
  OnRender=IWantToDrawSomething

  Background=none
    WinWidth=800
    WinHeight=600
    WinTop=0.0
    WinLeft=0.0
}
