/*------------------------------------------------------------------
  All menu color themes. You can put your own themes into
  defaultproperties, and access them by their index using
  static functions below. These functions can be called from
  any object or actor.

  Example:
  var color myColor;

  myColor = class'DXR_Menu'.static.GetPlayerInterfaceBG(10);
------------------------------------------------------------------*/

class DXR_Menu extends hcObject;

var() array <DXR_MenuColor> MenuColors;

/* Returns menu theme name */
static function string GetThemeName(int ThemeIndex)
{return default.MenuColors[ThemeIndex].ThemeName;}

static function array<string> GetAllThemes()
{
  local array<string> Themes;
  local int x;

	for (x = 0; x < default.MenuColors.Length; x++ )
		Themes[Themes.Length] = default.MenuColors[x].ThemeName;

  return Themes;
}

/* Returns background mode (no translucency, regular translucency, additive, alpha) */
static function int GetBackgoundMode(int ThemeIndex)
{return default.MenuColors[ThemeIndex].BackgoundMode;}

/*-------------------------------------------------------------
  These functions will return theme colors.
-------------------------------------------------------------*/

static function color GetPlayerInterfaceBG(int ThemeIndex)
{return default.MenuColors[ThemeIndex].PlayerInterfaceBG;}

static function color GetPlayerInterfaceHDR(int ThemeIndex)
{return default.MenuColors[ThemeIndex].PlayerInterfaceHDR;}

static function color GetPlayerInterfaceTextLabels(int ThemeIndex)
{return default.MenuColors[ThemeIndex].PlayerInterfaceTextLabels;}

/*----------------------------------------------------------------------*/
static function color GetPlayerInterfaceButton(int ThemeIndex)
{return default.MenuColors[ThemeIndex].PlayerInterfaceButton;}

static function color GetPlayerInterfaceButtonWatched(int ThemeIndex)
{return default.MenuColors[ThemeIndex].PlayerInterfaceButtonWatched;}

static function color GetPlayerInterfaceButtonFocused(int ThemeIndex)
{return default.MenuColors[ThemeIndex].PlayerInterfaceButtonFocused;}

static function color GetPlayerInterfaceButtonPressed(int ThemeIndex)
{return default.MenuColors[ThemeIndex].PlayerInterfaceButtonPressed;}

static function color GetPlayerInterfaceButtonDisabled(int ThemeIndex)
{return default.MenuColors[ThemeIndex].PlayerInterfaceButtonDisabled;}

/*----------------------------------------------------------------------*/

static function color GetPlayerInterfaceButtonText(int ThemeIndex)
{return default.MenuColors[ThemeIndex].PlayerInterfaceButtonText;}

static function color GetPlayerInterfaceButtonWatchedText(int ThemeIndex)
{return default.MenuColors[ThemeIndex].PlayerInterfaceButtonWatchedText;}

static function color GetPlayerInterfaceButtonFocusedText(int ThemeIndex)
{return default.MenuColors[ThemeIndex].PlayerInterfaceButtonFocusedText;}

static function color GetPlayerInterfaceButtonPressedText(int ThemeIndex)
{return default.MenuColors[ThemeIndex].PlayerInterfaceButtonPressedText;}

static function color GetPlayerInterfaceButtonDisabledText(int ThemeIndex)
{return default.MenuColors[ThemeIndex].PlayerInterfaceButtonDisabledText;}
/*----------------------------------------------------------------------*/
static function color GetPlayerInterfaceFrames(int ThemeIndex) ///////////
{return default.MenuColors[ThemeIndex].PlayerInterfaceFrames;} ///////////

static function color GetPlayerInterfaceTabsBackground(int ThemeIndex) ///
{return default.MenuColors[ThemeIndex].PlayerInterfaceTabsBackground;} ///
/*----------------------------------------------------------------------*/
static function color GetMenuButton(int ThemeIndex)
{return default.MenuColors[ThemeIndex].MenuButton;}

static function color GetMenuButtonWatched(int ThemeIndex)
{return default.MenuColors[ThemeIndex].MenuButtonWatched;}

static function color GetMenuButtonButtonFocused(int ThemeIndex)
{return default.MenuColors[ThemeIndex].MenuButtonButtonFocused;}

static function color GetMenuButtonPressed(int ThemeIndex)
{return default.MenuColors[ThemeIndex].MenuButtonPressed;}

static function color GetMenuButtonDisabled(int ThemeIndex)
{return default.MenuColors[ThemeIndex].MenuButtonDisabled;}

/*----------------------------------------------------------------------*/

static function color GetMenuButtonText(int ThemeIndex)
{return default.MenuColors[ThemeIndex].MenuButtonText;}

static function color GetMenuButtonWatchedText(int ThemeIndex)
{return default.MenuColors[ThemeIndex].MenuButtonWatchedText;}

static function color GetMenuButtonButtonFocusedText(int ThemeIndex)
{return default.MenuColors[ThemeIndex].MenuButtonButtonFocusedText;}

static function color GetMenuButtonPressedText(int ThemeIndex)
{return default.MenuColors[ThemeIndex].MenuButtonPressedText;}

static function color GetMenuButtonDisabledText(int ThemeIndex)
{return default.MenuColors[ThemeIndex].MenuButtonDisabledText;}
/*----------------------------------------------------------------------*/
static function color GetMenuHeaderText(int ThemeIndex) //////////////////
{return default.MenuColors[ThemeIndex].MenuHeaderText;} //////////////////

static function color GetMenuHeaderBubble(int ThemeIndex) ////////////////
{return default.MenuColors[ThemeIndex].MenuHeaderBubble;} ////////////////

static function color GetMenuHeader(int Themeindex) //////////////////////
{return default.MenuColors[ThemeIndex].MenuHeader;} //////////////////////

static function color GetMenuBackground(int ThemeIndex) //////////////////
{return default.MenuColors[ThemeIndex].MenuBackground;} //////////////////

static function color GetMenuBorders(int ThemeIndex) /////////////////////
{return default.MenuColors[ThemeIndex].MenuBorders;} /////////////////////
/*----------------------------------------------------------------------*/
static function color GetScrollBarColor(int ThemeIndex) //////////////////
{return default.MenuColors[ThemeIndex].ScrollBarColor;} //////////////////

static function color GetScrollBarButtonsColor(int ThemeIndex) ///////////
{return default.MenuColors[ThemeIndex].ScrollBarButtonsColor;} ///////////

static function color GetScrollBarArea(int ThemeIndex) ///////////////////
{return default.MenuColors[ThemeIndex].ScrollBarArea;} ///////////////////
/*----------------------------------------------------------------------*/
static function color GetSliderBG(int ThemeIndex)
{return default.MenuColors[ThemeIndex].SliderBG;}

static function color GetSliderKnob(int ThemeIndex)
{return default.MenuColors[ThemeIndex].SliderKnob;}
/*----------------------------------------------------------------------*/
static function color GetHintBG(int ThemeIndex)
{return default.MenuColors[ThemeIndex].HintBG;}

static function color GetHintText(int ThemeIndex)
{return default.MenuColors[ThemeIndex].HintText;}

static function byte GetAlpha(int ThemeIndex)
{return default.MenuColors[ThemeIndex].BackgroundAlpha;}
/*----------------------------------------------------------------------*/
static function color GetNotesText(int ThemeIndex)
{return default.MenuColors[ThemeIndex].NotesText;}

static function color GetNotesFrame(int ThemeIndex)
{return default.MenuColors[ThemeIndex].NotesFrame;}

static function color GetAugButtonBorder(int ThemeIndex)
{return default.MenuColors[ThemeIndex].AugButtonBorder;}


defaultproperties
{
	Begin Object Class=DXRColors.DXR_MenuColor Name=col00
	  ThemeName="Default"
	  BackgoundMode=BM_Regular
	  PlayerInterfaceBG=(R=255,G=255,B=255,A=255)
	  PlayerInterfaceHDR=(R=255,G=255,B=255,A=255)
	  PlayerInterfaceTextLabels=(R=225,G=225,B=225,A=255)
    BackgroundAlpha=200
    
    PlayerInterfaceButton=(R=225,G=225,B=225,A=255)
    PlayerInterfaceButtonWatched=(R=225,G=225,B=225,A=255)
    PlayerInterfaceButtonFocused=(R=255,G=255,B=255,A=255)
    PlayerInterfaceButtonPressed=(R=255,G=255,B=255,A=255)
    PlayerInterfaceButtonDisabled=(R=100,G=100,B=100,A=255)

    PlayerInterfaceButtonText=(R=211,G=211,B=211,A=255)
    PlayerInterfaceButtonWatchedText=(R=255,G=255,B=255,A=255)
    PlayerInterfaceButtonFocusedText=(R=255,G=255,B=255,A=255)
    PlayerInterfaceButtonPressedText=(R=200,G=200,B=200,A=255)
    PlayerInterfaceButtonDisabledText=(R=164,G=164,B=164,A=255)

    PlayerInterfaceFrames=(R=255,G=255,B=255,A=255)
    PlayerInterfaceTabsBackground=(R=255,G=255,B=255,A=255)

    MenuButton=(R=225,G=225,B=225,A=255)
    MenuButtonWatched=(R=225,G=225,B=225,A=255)
    MenuButtonButtonFocused=(R=255,G=255,B=255,A=255)
    MenuButtonPressed=(R=255,G=255,B=255,A=255)
    MenuButtonDisabled=(R=160,G=160,B=160,A=255)

    MenuButtonText=(R=211,G=211,B=211,A=255)
    MenuButtonWatchedText=(R=255,G=255,B=255,A=255)
    MenuButtonButtonFocusedText=(R=255,G=255,B=255,A=255)
    MenuButtonPressedText=(R=200,G=200,B=200,A=255)
    MenuButtonDisabledText=(R=164,G=164,B=164,A=255)

    MenuHeaderText=(R=255,G=255,B=255,A=255)
    MenuHeaderBubble=(R=10,G=64,B=255,A=255)
    MenuHeader=(R=255,G=255,B=255,A=255)
    MenuBackground=(R=255,G=255,B=255,A=255)
    MenuBorders=(R=255,G=255,B=255,A=255)

    ScrollBarColor=(R=255,G=255,B=255,A=255)
    ScrollBarButtonsColor=(R=255,G=255,B=255,A=255)
    ScrollBarArea=(R=255,G=255,B=255,A=255)

    SliderBG=(R=255,G=255,B=255,A=255)
    SliderKnob=(R=255,G=255,B=255,A=255)

	  HintBG=(R=128,G=128,B=128,A=255)
	  HintText=(R=200,G=200,B=200,A=255)

    NotesText=(R=200,G=200,B=200,A=255)
    NotesFrame=(R=128,G=128,B=128,A=255)

    AugButtonBorder=(R=255,G=255,B=0,A=255)

  End Object
  MenuColors(0)=col00
/*-------------------------------------------------------------------------------------------*/
	Begin Object Class=DXRColors.DXR_MenuColor Name=col01
	  ThemeName="Green colors"
	  BackgoundMode=BM_Alpha
	  PlayerInterfaceBG=(R=20,G=200,B=20,A=255)
	  PlayerInterfaceHDR=(R=128,G=128,B=0,A=255)
	  PlayerInterfaceTextLabels=(R=128,G=255,B=128,A=255)
    BackgroundAlpha=200

    PlayerInterfaceButton=(R=25,G=200,B=25,A=255)
    PlayerInterfaceButtonWatched=(R=25,G=200,B=25,A=255)
    PlayerInterfaceButtonFocused=(R=25,G=220,B=25,A=255)
    PlayerInterfaceButtonPressed=(R=25,G=255,B=25,A=255)
    PlayerInterfaceButtonDisabled=(R=10,G=100,B=10,A=255)

    PlayerInterfaceButtonText=(R=100,G=211,B=100,A=255)
    PlayerInterfaceButtonWatchedText=(R=255,G=255,B=255,A=255)
    PlayerInterfaceButtonFocusedText=(R=255,G=255,B=255,A=255)
    PlayerInterfaceButtonPressedText=(R=200,G=255,B=100,A=255)
    PlayerInterfaceButtonDisabledText=(R=0,G=160,B=0,A=255)

    PlayerInterfaceFrames=(R=0,G=255,B=0,A=255)
    PlayerInterfaceTabsBackground=(R=0,G=255,B=0,A=255)

    MenuButton=(R=25,G=225,B=25,A=255)
    MenuButtonWatched=(R=25,G=235,B=25,A=255)
    MenuButtonButtonFocused=(R=25,G=255,B=55,A=255)
    MenuButtonPressed=(R=25,G=255,B=25,A=255)
    MenuButtonDisabled=(R=100,G=100,B=100,A=255)

    MenuButtonText=(R=21,G=211,B=21,A=255)
    MenuButtonWatchedText=(R=25,G=255,B=25,A=255)
    MenuButtonButtonFocusedText=(R=55,G=255,B=55,A=255)
    MenuButtonPressedText=(R=20,G=255,B=20,A=255)
    MenuButtonDisabledText=(R=10,G=64,B=10,A=255)

    MenuHeaderText=(R=0,G=255,B=0,A=255)
    MenuHeaderBubble=(R=10,G=164,B=10,A=255)
    MenuHeader=(R=10,G=164,B=10,A=255)
    MenuBackground=(R=10,G=200,B=10,A=255)
    MenuBorders=(R=5,G=255,B=5,A=255)

    ScrollBarColor=(R=0,G=128,B=0,A=255)
    ScrollBarButtonsColor=(R=0,G=128,B=0,A=255)
    ScrollBarArea=(R=55,G=55,B=55,A=255)

    SliderBG=(R=0,G=200,B=25,A=255)
    SliderKnob=(R=0,G=255,B=20,A=255)

	  HintBG=(R=10,G=120,B=0,A=255)
	  HintText=(R=0,G=220,B=0,A=255)

    NotesText=(R=60,G=220,B=60,A=255)
    NotesFrame=(R=0,G=250,B=0,A=255)

    AugButtonBorder=(R=255,G=255,B=0,A=255)

  End Object
  MenuColors(1)=col01

	Begin Object Class=DXRColors.DXR_MenuColor Name=col02
	  ThemeName="Dusk"
	  BackgoundMode=BM_Alpha
	  PlayerInterfaceBG=(R=255,G=182,B=255,A=255) // Цвет фона инвентаря, заметок и т.п.
	  PlayerInterfaceHDR=(R=255,G=150,B=255,A=255) // Подзаголовок 
	  PlayerInterfaceTextLabels=(R=255,G=175,B=0,A=255) // Текст
    BackgroundAlpha=200 // Прозрачность

    PlayerInterfaceButton=(R=255,G=182,B=255,A=255)
    PlayerInterfaceButtonWatched=(R=255,G=192,B=255,A=200)
    PlayerInterfaceButtonFocused=(R=255,G=172,B=255,A=200)
    PlayerInterfaceButtonPressed=(R=255,G=162,B=255,A=200)
    PlayerInterfaceButtonDisabled=(R=120,G=0,B=120,A=200)

    PlayerInterfaceButtonText=(R=255,G=175,B=0,A=200)
    PlayerInterfaceButtonWatchedText=(R=255,G=200,B=255,A=200)
    PlayerInterfaceButtonFocusedText=(R=255,G=255,B=255,A=200)
    PlayerInterfaceButtonPressedText=(R=255,G=205,B=255,A=200)
    PlayerInterfaceButtonDisabledText=(R=255,G=99,B=255,A=200)

    PlayerInterfaceFrames=(R=255,G=182,B=255,A=255)
    PlayerInterfaceTabsBackground=(R=255,G=182,B=255,A=255)

    MenuButton=(R=84,G=0,B=84,A=255)
    MenuButtonWatched=(R=94,G=0,B=94,A=255)
    MenuButtonButtonFocused=(R=104,G=0,B=104,A=255)
    MenuButtonPressed=(R=80,G=0,B=80,A=255)
    MenuButtonDisabled=(R=44,G=0,B=44,A=255)

    MenuButtonText=(R=255,G=175,B=0,A=255)
    MenuButtonWatchedText=(R=255,G=200,B=255,A=255)
    MenuButtonButtonFocusedText=(R=255,G=255,B=255,A=255)
    MenuButtonPressedText=(R=255,G=205,B=255,A=255)
    MenuButtonDisabledText=(R=255,G=99,B=255,A=255)

    MenuHeaderText=(R=255,G=175,B=0,A=255) // Title text color
    MenuHeaderBubble=(R=84,G=0,B=84,A=255) // Area inside of titlebar
    MenuHeader=(R=255,G=182,B=255,A=255) // window titlebar
    MenuBackground=(R=255,G=182,B=255,A=255) // Background image
    MenuBorders=(R=255,G=182,B=255,A=255) // Frames, for windows only

    ScrollBarColor=(R=255,G=182,B=255,A=255)
    ScrollBarButtonsColor=(R=255,G=182,B=255,A=255)
    ScrollBarArea=(R=255,G=182,B=255,A=255)

    SliderBG=(R=158,G=0,B=154,A=255) // Slider background
    SliderKnob=(R=255,G=175,B=0,A=255) // Slider movable knob

	  HintBG=(R=84,G=0,B=84,A=255) // Tooltip
	  HintText=(R=255,G=175,B=0,A=255) // Tooltip text color

    NotesText=(R=255,G=175,B=0,A=255) // Notes text
    NotesFrame=(R=84,G=0,B=84,A=255) // Frame around note text

    AugButtonBorder=(R=255,G=255,B=0,A=255)

  End Object
  MenuColors(2)=col02

	Begin Object Class=DXRColors.DXR_MenuColor Name=col03
	  ThemeName="Darkest Time"
	  BackgoundMode=BM_Regular
	  PlayerInterfaceBG=(R=82,G=82,B=80,A=255) // Цвет фона инвентаря, заметок и т.п.
	  PlayerInterfaceHDR=(R=130,G=139,B=138,A=255) // Подзаголовок
	  PlayerInterfaceTextLabels=(R=121,G=119,B=106,A=255) // Текст
    BackgroundAlpha=200 // Прозрачность

    PlayerInterfaceButton=(R=82,G=82,B=80,A=255)
    PlayerInterfaceButtonWatched=(R=92,G=92,B=90,A=200)
    PlayerInterfaceButtonFocused=(R=122,G=92,B=120,A=200)
    PlayerInterfaceButtonPressed=(R=102,G=102,B=100,A=200)
    PlayerInterfaceButtonDisabled=(R=42,G=42,B=40,A=200)

    PlayerInterfaceButtonText=(R=130,G=139,B=138,A=200)
    PlayerInterfaceButtonWatchedText=(R=170,G=179,B=178,A=200)
    PlayerInterfaceButtonFocusedText=(R=180,G=189,B=188,A=200)
    PlayerInterfaceButtonPressedText=(R=190,G=199,B=198,A=200)
    PlayerInterfaceButtonDisabledText=(R=130,G=139,B=138,A=200)

    PlayerInterfaceFrames=(R=130,G=139,B=138,A=255)
    PlayerInterfaceTabsBackground=(R=130,G=139,B=138,A=255)

    MenuButton=(R=130,G=139,B=138,A=255)
    MenuButtonWatched=(R=130,G=139,B=138,A=255)
    MenuButtonButtonFocused=(R=130,G=139,B=138,A=255)
    MenuButtonPressed=(R=130,G=139,B=138,A=255)
    MenuButtonDisabled=(R=30,G=39,B=38,A=255)

    MenuButtonText=(R=175,G=176,B=178,A=255)
    MenuButtonWatchedText=(R=195,G=196,B=198,A=255)
    MenuButtonButtonFocusedText=(R=215,G=216,B=218,A=255)
    MenuButtonPressedText=(R=165,G=166,B=168,A=255)
    MenuButtonDisabledText=(R=75,G=76,B=78,A=255)

    MenuHeaderText=(R=130,G=139,B=138,A=255) // Title text color
    MenuHeaderBubble=(R=84,G=84,B=84,A=255) // Area inside of titlebar
    MenuHeader=(R=130,G=139,B=138,A=255) // window titlebar
    MenuBackground=(R=130,G=139,B=138,A=255) // Background image
    MenuBorders=(R=130,G=139,B=138,A=255) // Frames, for windows only

    ScrollBarColor=(R=130,G=139,B=138,A=255)
    ScrollBarButtonsColor=(R=130,G=139,B=138,A=255)
    ScrollBarArea=(R=130,G=139,B=138,A=255)

    SliderBG=(R=130,G=139,B=138,A=255) // Slider background
    SliderKnob=(R=180,G=189,B=188,A=255) // Slider movable knob

	  HintBG=(R=130,G=139,B=138,A=255) // Tooltip
	  HintText=(R=180,G=189,B=188,A=255) // Tooltip text color

    NotesText=(R=180,G=189,B=188,A=255) // Notes text
    NotesFrame=(R=130,G=139,B=138,A=255) // Frame around note text

    AugButtonBorder=(R=128,G=128,B=128,A=255) // Same for Inventory, Augmentations, and for MedicalBot too.

  End Object
  MenuColors(3)=col03

	Begin Object Class=DXRColors.DXR_MenuColor Name=col04
	  ThemeName="NC / FAR"
	  BackgoundMode=BM_Regular
	  PlayerInterfaceBG=(R=0,G=150,B=255,A=255) // Цвет фона инвентаря, заметок и т.п.
	  PlayerInterfaceHDR=(R=0,G=255,B=0,A=255) // Подзаголовок
	  PlayerInterfaceTextLabels=(R=255,G=255,B=255,A=255) // Текст
    BackgroundAlpha=220 // Прозрачность

    PlayerInterfaceButton=(R=0,G=150,B=255,A=255)
    PlayerInterfaceButtonWatched=(R=0,G=150,B=255,A=255)
    PlayerInterfaceButtonFocused=(R=0,G=150,B=255,A=255)
    PlayerInterfaceButtonPressed=(R=0,G=150,B=255,A=255)
    PlayerInterfaceButtonDisabled=(R=0,G=150,B=255,A=255)

    PlayerInterfaceButtonText=(R=200,G=200,B=200,A=255)
    PlayerInterfaceButtonWatchedText=(R=225,G=225,B=225,A=255)
    PlayerInterfaceButtonFocusedText=(R=235,G=235,B=235,A=255)
    PlayerInterfaceButtonPressedText=(R=255,G=255,B=255,A=255)
    PlayerInterfaceButtonDisabledText=(R=120,G=120,B=138,A=255)

    PlayerInterfaceFrames=(R=0,G=128,B=128,A=255)
    PlayerInterfaceTabsBackground=(R=0,G=128,B=128,A=255)

    MenuButton=(R=255,G=255,B=255,A=255)
    MenuButtonWatched=(R=255,G=255,B=255,A=255)
    MenuButtonButtonFocused=(R=255,G=255,B=255,A=255)
    MenuButtonPressed=(R=255,G=255,B=255,A=255)
    MenuButtonDisabled=(R=128,G=128,B=155,A=255)

    MenuButtonText=(R=0,G=200,B=255,A=255)
    MenuButtonWatchedText=(R=0,G=210,B=255,A=255)
    MenuButtonButtonFocusedText=(R=0,G=220,B=255,A=255)
    MenuButtonPressedText=(R=0,G=230,B=255,A=255)
    MenuButtonDisabledText=(R=75,G=76,B=78,A=255)

    MenuHeaderText=(R=130,G=139,B=138,A=255) // Title text color
    MenuHeaderBubble=(R=84,G=84,B=84,A=255) // Area inside of titlebar
    MenuHeader=(R=130,G=139,B=138,A=255) // window titlebar
    MenuBackground=(R=130,G=139,B=138,A=255) // Background image
    MenuBorders=(R=130,G=139,B=138,A=255) // Frames, for windows only

    ScrollBarColor=(R=130,G=139,B=138,A=255)
    ScrollBarButtonsColor=(R=130,G=139,B=138,A=255)
    ScrollBarArea=(R=130,G=139,B=138,A=255)

    SliderBG=(R=130,G=139,B=138,A=255) // Slider background
    SliderKnob=(R=180,G=189,B=188,A=255) // Slider movable knob

	  HintBG=(R=130,G=139,B=138,A=255) // Tooltip
	  HintText=(R=180,G=189,B=188,A=255) // Tooltip text color

    NotesText=(R=180,G=189,B=188,A=255) // Notes text
    NotesFrame=(R=130,G=139,B=138,A=255) // Frame around note text

    AugButtonBorder=(R=128,G=128,B=128,A=255) // Same for Inventory, Augmentations, and for MedicalBot too.

  End Object
  MenuColors(4)=col04
}