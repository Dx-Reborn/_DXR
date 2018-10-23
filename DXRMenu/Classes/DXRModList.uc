/*-----------------------------------
  Список модов.
  Почти копия UT2K4UserMods )))
-----------------------------------*/


class DXRModList extends DxWindowTemplate;

var localized string helpURL;
var automated GUIImage i_ModLogo;
var automated GUIListBox lb_ModList;
var automated GUIScrollTextBox lb_ModInfo;
var automated GUIButton bLoad, bWeb, bClose, bHelp, bGetMods;
var localized string strLoad, strWeb, strWeb2, strClose, strHelp, getModsUrl, strGetMods;
var automated GUILabel lblMods, lblImage, lblDescription;
var localized string strMods, strImage, strDescription;
var localized string NoModsListText;

var bool bInitialized;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);
	CreateMyControls();

    lb_ModList.List.Clear();
    LoadUserMods();
    bInitialized = true;
	  ModListChange(none);
}


function LoadUserMods()
{
	local array<string> ModDirs, ModTitles;
	local int i;

	GetModList(ModDirs, ModTitles);
	for (i=0;i<ModDirs.Length;i++)
	  	lb_ModList.List.Add(ModTitles[i],,ModDirs[i]);
}

function CreateMyControls()
{
  lb_ModList = new(none) class'GUIListBox'; // Список
//  lb_ModList.OnClick=InternalOnClick;
  lb_ModList.MyScrollBar.WinWidth = 16;
  lb_ModList.SelectedStyleName="STY_DXR_ListSelection";
  lb_ModList.StyleName = "STY_DXR_Listbox";
  lb_ModList.OnChange=ModListChange;
  lb_ModList.WinHeight = 225;
  lb_ModList.WinWidth = 512;
  lb_ModList.WinLeft = 268;
  lb_ModList.WinTop = 52;
	AppendComponent(lb_ModList, true);

  i_ModLogo = new(none) class'GUIImage'; // картинка
  i_ModLogo.ImageStyle = ISTY_Scaled;
  i_ModLogo.WinHeight = 256;
  i_ModLogo.WinWidth = 512;
  i_ModLogo.WinLeft = 8;
  i_ModLogo.WinTop = 304;
	AppendComponent(i_ModLogo, true);

	lb_ModInfo = new(none) class'GUIScrollTextBox';
  lb_ModInfo.StyleName = "STY_DXR_Listbox";
	lb_ModInfo.WinHeight = 256;
	lb_ModInfo.WinWidth = 256;
	lb_ModInfo.WinLeft = 524;
	lb_ModInfo.WinTop = 304;
  lb_ModInfo.bNoTeletype = true;
	AppendComponent(lb_ModInfo, true);
	/*--------------------------------------------*/
  bLoad = new(none) class'GUIButton'; // Загрузить
  bLoad.OnClick=LaunchClick;
  bLoad.RenderWeight = 1.0;
  bLoad.StyleName="STY_DXR_DeusExRectButton";
  bLoad.Caption = strLoad;
  bLoad.WinHeight = 32;
  bLoad.WinWidth = 243;
  bLoad.WinLeft = 20;
  bLoad.WinTop = 36;
	AppendComponent(bLoad, true);

  bWeb = new(none) class'GUIButton'; // Сайт мода
  bWeb.OnClick=WebClick;
  bWeb.RenderWeight = 1.0;
  bWeb.StyleName="STY_DXR_DeusExRectButton";
  bWeb.Caption = strWeb;
  bWeb.WinHeight = 32;
  bWeb.WinWidth = 243;
  bWeb.WinLeft = 20;
  bWeb.WinTop = 80;
	AppendComponent(bWeb, true);

  bClose = new(none) class'GUIButton'; // Закрыть окно
  bClose.OnClick = CloseClick;
  bClose.RenderWeight = 1.0;
  bClose.StyleName="STY_DXR_DeusExRectButton";
  bClose.Caption = strClose;
  bClose.WinHeight = 32;
  bClose.WinWidth = 243;
  bClose.WinLeft = 20;
  bClose.WinTop = 124;
	AppendComponent(bClose, true);

  bHelp = new(none) class'GUIButton'; // Подсказка
  bHelp.OnClick = HelpClick;
  bHelp.RenderWeight = 1.0;
  bHelp.StyleName="STY_DXR_DeusExRectButton";
  bHelp.Caption = strHelp;
  bHelp.WinHeight = 32;
  bHelp.WinWidth = 243;
  bHelp.WinLeft = 20;
  bHelp.WinTop = 168;
	AppendComponent(bHelp, true);

	bGetMods = new(none) class'GUIButton'; // Подсказка
  bGetMods.OnClick = GetModsClick;
  bGetMods.RenderWeight = 1.0;
  bGetMods.StyleName="STY_DXR_DeusExRectButton";
  bGetMods.Caption = strGetMods;
  bGetMods.WinHeight = 32;
  bGetMods.WinWidth = 243;
  bGetMods.WinLeft = 20;
  bGetMods.WinTop = 212;
	AppendComponent(bGetMods, true);

	/*------------------------------------------*/
  lblMods = new(none) class'GUILabel'; // Список
  lblMods.Caption = strMods;
  lblMods.TextFont="UT2HeaderFont";
  lblMods.TextColor = class'Canvas'.static.MakeColor(200, 200, 200);
  lblMods.FontScale = FNS_Small;
  lblMods.WinHeight = 20;
  lblMods.WinWidth = 150;
  lblMods.WinLeft = 268;
  lblMods.WinTop = 32;
	AppendComponent(lblMods, true);

  lblImage = new(none) class'GUILabel'; // Картинка
  lblImage.Caption = strImage;
  lblImage.TextFont="UT2HeaderFont";
  lblImage.TextColor = class'Canvas'.static.MakeColor(200, 200, 200);
  lblImage.FontScale = FNS_Small;
  lblImage.WinHeight = 20;
  lblImage.WinWidth = 500;
  lblImage.WinLeft = 8;
  lblImage.WinTop = 284;
	AppendComponent(lblImage, true);

  lblDescription = new(none) class'GUILabel'; // Описание
  lblDescription.Caption = strDescription;
  lblDescription.TextFont="UT2HeaderFont";
  lblDescription.TextColor = class'Canvas'.static.MakeColor(200, 200, 200);
  lblDescription.FontScale = FNS_Small;
  lblDescription.WinHeight = 20;
  lblDescription.WinWidth = 250;
  lblDescription.WinLeft = 524;
  lblDescription.WinTop = 284;
	AppendComponent(lblDescription, true);
}

function bool GetModsClick(GUIComponent Sender)
{
	Console(Controller.Master.Console).DelayedConsoleCommand("open"@getModsURL);
    return true;
}


function bool HelpClick(GUIComponent Sender)
{
	Console(Controller.Master.Console).DelayedConsoleCommand("open"@helpURL);
    return true;
}


function bool CloseClick(GUIComponent Sender)
{
  Controller.CloseMenu();
  return true;
}

function bool LaunchClick(GUIComponent Sender)
{
	local string CmdLine;

	if (lb_ModList.List.Index<0)
		return true;

	CmdLine = GetModValue( lb_ModList.List.GetExtra(), "ModCmdLine" );
    if (CmdLine!="")
		Console(Controller.Master.Console).DelayedConsoleCommand("relaunch"@CmdLine@"-mod="$lb_ModList.List.GetExtra()@"-newwindow");
	else
		Console(Controller.Master.Console).DelayedConsoleCommand("relaunch -mod="$lb_ModList.List.GetExtra()@"-newwindow");

    return true;
}

function bool WebClick(GUIComponent Sender)
{
	local string url;

	if (lb_ModList.List.Index<0)
		return true;

	url = GetModValue(lb_ModList.List.GetExtra(),"ModURL");
	Console(Controller.Master.Console).DelayedConsoleCommand("open"@url);
    return true;
}

function ModListChange(GUIComponent Sender)
{
	local Material M;
	local string modurl;
	lb_ModInfo.SetContent(GetModValue(lb_ModList.List.GetExtra(),"ModDesc"));
  lb_ModInfo.AddText(strWeb2 $ GetModValue(lb_ModList.List.GetExtra(),"ModURL"));

  modurl = GetModValue(lb_ModList.List.GetExtra(),"ModURL");
  bWeb.SetVisibility(modurl != "");

	M = GetModLogo(lb_ModList.List.GetExtra());

    if (m!=none)
    {
     i_ModLogo.Image = M;
     i_ModLogo.SetVisibility(true);
    }

    if (m==none)
    {
     i_ModLogo.Image = TexPanner'DeusExControls.Controls.Static';
     i_ModLogo.SetVisibility(true);
    }

    if (!bInitialized)
    	return;
}

function AddSystemMenu();

function bool AlignFrame(Canvas C)
{
  WinLeft = Controller.ResX/2 - 400;
//  WinTop  = Controller.ResY/2 - 300;

	return bInit;
}

function PaintOnHeader(Canvas C)
{
  local texture icon;//, bubble;

  icon = texture'DeusExSmallIcon';
  C.SetPos(t_WindowTitle.ActualLeft() + 8, t_WindowTitle.ActualTop() + 3);
  C.SetDrawColor(255,255,255);
  C.DrawIcon(icon, 1);
}



defaultproperties
{
    strMods="Installed mods:"
    strImage="Mod image (screenshot, logo):"
    strDescription="Mod description:"

    strHelp="How to add a mod ?"
    strLoad="Play this mod"
    strWeb="Visit Mod's site"
    strWeb2="Mod's URL: "
    strClose="Close"
    strGetMods="Download mods"
    helpURL="http://planetdeusex.ru/forum/index.php?showtopic=2481"
    getModsUrl="http://planetdeusex.ru/forum/index.php?showtopic=2481"

    bResizeWidthAllowed=false
    bResizeHeightAllowed=false


		DefaultHeight=600
		DefaultWidth=800

		MaxPageHeight=600
		MaxPageWidth=800
		MinPageHeight=600
		MinPageWidth=800

		winleft=200
		wintop=0.5

		bCaptureMouse=true
    bAcceptsInput=true

    WinTitle="Load mod"
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