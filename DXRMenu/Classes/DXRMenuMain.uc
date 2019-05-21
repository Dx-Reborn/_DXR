/*--------------------------------------------
  Главное меню, как в оригинале (или почти)

--------------------------------------------*/
class DXRMenuMain extends DxWindowTemplate;

#exec OBJ LOAD FILE=DeusExUI.u
const ver="Deus Ex: Reborn Alpha build";
var Automated GUIButton bNew, bLoad, bTraining, bCreators, bOptions, bMods, bIntro, bExit;
var localized string strNew, strLoad, strTraining, strCreators, strOptions, strMods, strIntro, strExit;
var localized string dNew, dLoad, dSave, dTraining, dCreators, dOptions, dMods, dIntro, dExit;
var() float IconCorrectH, IconCorrectV;
var() float bX, bY;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);
  CreateMainMenuControls();
}

function CreateMainMenuControls()
{ // Новая игра
  bNew = new(none) class'GUIButton';
  bNew.OnClick=InternalOnClick;
  bNew.RenderWeight = 1.0;
  bNew.StyleName="STY_DXR_DeusExRectButton";
  bNew.Caption = strNew;
  bNew.Hint = dNew;
  bNew.WinHeight = 32;
  bNew.WinWidth = 243;
  bNew.WinLeft = 16;
  bNew.WinTop = 33;
	AppendComponent(bNew, true);
	// Загрузить
  bLoad = new(none) class'GUIButton';
  bLoad.OnClick=InternalOnClick;
  bLoad.RenderWeight = 1.0;
  bLoad.StyleName="STY_DXR_DeusExRectButton";
  bLoad.Caption = strLoad;
  bLoad.Hint = dLoad;
  bLoad.WinHeight = 32;
  bLoad.WinWidth = 243;
  bLoad.WinLeft = 16;
  bLoad.WinTop = 69;
	AppendComponent(bLoad, true);
	// Тренировка
  bTraining = new(none) class'GUIButton';
  bTraining.OnClick=InternalOnClick;
  bTraining.RenderWeight = 1.0;
  bTraining.StyleName="STY_DXR_DeusExRectButton";
  bTraining.Caption = strTraining;
  bTraining.Hint = dTraining;
  bTraining.WinHeight = 32;
  bTraining.WinWidth = 243;
  bTraining.WinLeft = 16;
  bTraining.WinTop = 105;
	AppendComponent(bTraining, true);
	// Авторы
  bCreators = new(none) class'GUIButton';
  bCreators.OnClick=InternalOnClick;
  bCreators.RenderWeight = 1.0;
  bCreators.StyleName="STY_DXR_DeusExRectButton";
  bCreators.Caption = strCreators;
  bCreators.Hint = dCreators;
  bCreators.WinHeight = 32;
  bCreators.WinWidth = 243;
  bCreators.WinLeft = 16;
  bCreators.WinTop = 141;
	AppendComponent(bCreators, true);
	// Настройки
  bOptions = new(none) class'GUIButton';
  bOptions.OnClick=InternalOnClick;
  bOptions.RenderWeight = 1.0;
  bOptions.StyleName="STY_DXR_DeusExRectButton";
  bOptions.Caption = strOptions;
  bOptions.Hint = dOptions;
  bOptions.WinHeight = 32;
  bOptions.WinWidth = 243;
  bOptions.WinLeft = 16;
  bOptions.WinTop = 177;
	AppendComponent(bOptions, true);
	// Моды )))
  bMods = new(none) class'GUIButton';
  bMods.OnClick=InternalOnClick;
  bMods.RenderWeight = 1.0;
  bMods.StyleName="STY_DXR_DeusExRectButton";
  bMods.Caption = strMods;
  bMods.Hint = dMods;
  bMods.WinHeight = 32;
  bMods.WinWidth = 243;
  bMods.WinLeft = 16;
  bMods.WinTop = 213;
	AppendComponent(bMods, true);
	// View Intro!
  bIntro = new(none) class'GUIButton';
  bIntro.OnClick=InternalOnClick;
  bIntro.RenderWeight = 1.0;
  bIntro.StyleName="STY_DXR_DeusExRectButton";
  bIntro.Caption = strIntro;
  bIntro.Hint = dIntro;
  bIntro.WinHeight = 32;
  bIntro.WinWidth = 243;
  bIntro.WinLeft = 16;
  bIntro.WinTop = 249;
	AppendComponent(bIntro, true);
	// Выход
  bExit = new(none) class'GUIButton';
  bExit.OnClick=InternalOnClick;
  bExit.RenderWeight = 1.0;
  bExit.StyleName="STY_DXR_DeusExRectButton";
  bExit.Caption = strExit;
  bExit.Hint = dExit;
  bExit.WinHeight = 32;
  bExit.WinWidth = 243;
  bExit.WinLeft = 16;
  bExit.WinTop = 307;
	AppendComponent(bExit, true);
}

function bool InternalOnClick(GUIComponent Sender)
{  
  if(Sender==bNew) // Начать новую игру
  {
    Controller.OpenMenu("DXRMenu.DXRCombatDifficultyChoice");
  }
	if(Sender==bMods) // Список модов
	{
		Controller.OpenMenu("DXRMenu.DXRModList");
	}
	if(Sender==bTraining) // Тренировка
	{
		Controller.OpenMenu("DXRMenu.DXRAskTrainingMessage");
	}
	if(Sender==bExit) // выход
	{
		Controller.OpenMenu(Controller.GetQuitPage());
	}
	if(Sender==bLoad) // Загрузить игру
	{
		Controller.OpenMenu("DXRMenu.DXRLoadWindow");
	}
	if(Sender==bOptions) // Опции
	{
		Controller.OpenMenu("DXRMenu.DXRMenuSettings");
	}
	if (Sender==bIntro)
	{
	  Controller.OpenMenu("DXRMenu.DXRAskIntroMessage");
	}
	if (Sender==bCreators)
	{
	  Controller.OpenMenu("DXRMenu.DXRCredits");
	}
	return true;
}

function AddSystemMenu();
function bool AlignFrame(Canvas C)
{
  if (bVisible)
  winleft = (controller.resX/2) - (MaxPageWidth/2);
  else
  winleft = -2000;

	return bInit;
}

function PaintDXRVersion(Canvas C)
{
  C.SetPos(i_FrameBG.ActualLeft() + 4, i_FrameBG.ActualTop() + i_FrameBG.WinWidth + 64);
  C.SetDrawColor(255,255,255);
  C.DrawText(ver@ class'DXRVersion'.static.GetDXRVersion());
}



defaultproperties
{
    openSound=sound'DeusExSounds.UserInterface.Menu_Activate'

    bPersistent=false
    bAllowedAsLast=true

    bResizeWidthAllowed=false
    bResizeHeightAllowed=false

    IconCorrectH=8
    IconCorrectV=3

    WinTitle="Deus Ex: Reborn+"
    strNew="New Game..."
    strLoad="Load Game..."
    strTraining="Training"
    strCreators="Credits"
    strOptions="Settings"
    strMods="Play a Mod..."
    strIntro="Play Intro"
    strExit="Exit"

    dNew="Start a new game"
    dLoad="Load saved game"
    dSave="Save game"
    dTraining="Start training course"
    dCreators="Creators of DeusEx: Reborn"
    dOptions="Configure game settings: graphics, keys, mouse, etc"
    dMods="Mod loader."
    dIntro="View Game Intro"
    dExit="Leave World of Conspiracies..."

		DefaultHeight=354
		DefaultWidth=264

		MaxPageHeight=354
		MaxPageWidth=264
		MinPageHeight=354
		MinPageWidth=264

	Begin Object Class=FloatingImage Name=FloatingFrameBackground
		Image=Texture'DXR_MenuMainBackground'
		ImageRenderStyle=MSTY_Translucent
		ImageStyle=ISTY_Tiled //PartialScaled
		ImageColor=(R=255,G=255,B=255,A=255)
		DropShadow=None
		WinWidth=256
		WinHeight=333 //229
		WinLeft=8
		WinTop=20
		RenderWeight=0.000003
		bBoundToParent=True
		bScaleToParent=True
    OnRendered=PaintDXRVersion
	End Object
	i_FrameBG=FloatingFrameBackground
}
