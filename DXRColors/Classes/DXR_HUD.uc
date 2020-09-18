/* ------------------------------------------------------------------
   Container for objects.
   defprops contains HUD colors objects, and of course i must fill 
   them manually! :D
------------------------------------------------------------------*/
class DXR_HUD extends hcObject;

var() array <DXR_HUDColor> HUDColors;

/* Returns menu theme name */
static function string GetHUDThemeName(int ThemeIndex)
{return default.HUDColors[ThemeIndex].HUDName;}

static function array<string> GetAllHUDThemes()
{
  local array<string> Themes;
  local int x;

    for (x = 0; x < default.HUDColors.Length; x++ )
        Themes[Themes.Length] = default.HUDColors[x].HUDName;

  return Themes;
}

/*---------------------------------------------------------------*/
static function color GetMessageBG(int ThemeIndex)   // ClientMessage Background
{return default.HUDColors[ThemeIndex].MessageBG;}

static function color GetMessageText(int ThemeIndex) // ClientMessage Text
{return default.HUDColors[ThemeIndex].MessageText;}

static function color GetMessageFrame(int ThemeIndex) // ClientMessage frame color
{return default.HUDColors[ThemeIndex].MessageBG;}
/*---------------------------------------------------------------*/
static function color GetToolBeltBG(int ThemeIndex) // toolbelt cells
{return default.HUDColors[ThemeIndex].ToolBeltBG;}

static function color GetToolBeltText(int ThemeIndex) // toolbelt text color
{return default.HUDColors[ThemeIndex].ToolBeltText;}

static function color GetToolBeltSpecialText(int ThemeIndex) //... HotKey Numbers (0..9)
{return default.HUDColors[ThemeIndex].ToolBeltSpecialText;}

static function color GetToolBeltFrame(int ThemeIndex) // frames color
{return default.HUDColors[ThemeIndex].ToolBeltFrame;}

static function color GetToolBeltHighlight(int ThemeIndex) // toolbelt selected item
{return default.HUDColors[ThemeIndex].ToolBeltHighlight;}
/*---------------------------------------------------------------*/
static function color GetAugsBeltBG(int ThemeIndex)
{return default.HUDColors[ThemeIndex].AugsBeltBG;}

static function color GetAugsBeltText(int ThemeIndex)
{return default.HUDColors[ThemeIndex].AugsBeltText;}

static function color GetAugsBeltFrame(int ThemeIndex)
{return default.HUDColors[ThemeIndex].AugsBeltFrame;}

static function color GetAugsBeltActive(int ThemeIndex)
{return default.HUDColors[ThemeIndex].AugsBeltActive;}

static function color GetAugsBeltInActive(int ThemeIndex)
{return default.HUDColors[ThemeIndex].AugsBeltInActive;}
/*---------------------------------------------------------------*/
static function color GetAmmoDisplayBG(int ThemeIndex)
{return default.HUDColors[ThemeIndex].AmmoDisplayBG;}

static function color GetAmmoDisplayFrame(int ThemeIndex)
{return default.HUDColors[ThemeIndex].AmmoDisplayFrame;}

static function color GetcompassBG(int ThemeIndex)
{return default.HUDColors[ThemeIndex].compassBG;}

static function color GetcompassFrame(int ThemeIndex)
{return default.HUDColors[ThemeIndex].compassFrame;}
/*---------------------------------------------------------------*/
static function color GetHealthBG(int ThemeIndex)
{return default.HUDColors[ThemeIndex].HealthBG;}

static function color GetHealthFrame(int ThemeIndex)
{return default.HUDColors[ThemeIndex].HealthFrame;}
/*---------------------------------------------------------------*/
static function color GetBooksBG(int ThemeIndex) // Background color for InformationDevices contents
{return default.HUDColors[ThemeIndex].BooksBG;}

static function color GetBooksText(int ThemeIndex) // text color 
{return default.HUDColors[ThemeIndex].BooksText;}

static function color GetBooksFrame(int ThemeIndex) // frame color
{return default.HUDColors[ThemeIndex].BooksFrame;}

static function color GetInfoLinkBG(int ThemeIndex) // infolink/first person dialogue/monologue
{return default.HUDColors[ThemeIndex].InfoLinkBG;}

static function color GetInfoLinkText(int ThemeIndex) // Text color
{return default.HUDColors[ThemeIndex].InfoLinkText;}
/*---------------------------------------------------------------*/
static function color GetInfoLinkTitles(int ThemeIndex) // header/bold text
{return default.HUDColors[ThemeIndex].InfoLinkTitles;}

static function color GetInfoLinkFrame(int ThemeIndex) // frame color
{return default.HUDColors[ThemeIndex].InfoLinkFrame;}

static function color GetAIBarksBG(int ThemeIndex)
{return default.HUDColors[ThemeIndex].AIBarksBG;}

static function color GetAIBarksText(int ThemeIndex)
{return default.HUDColors[ThemeIndex].AIBarksText;}

static function color GetAIBarksHeader(int ThemeIndex)
{return default.HUDColors[ThemeIndex].AIBarksHeader;}

static function color GetAIBarksFrame(int ThemeIndex)
{return default.HUDColors[ThemeIndex].AIBarksFrame;}
/*---------------------------------------------------------------*/
static function color GetFrobBoxColor(int ThemeIndex)
{return default.HUDColors[ThemeIndex].FrobBoxColor;}

static function color GetFrobBoxShadow(int ThemeIndex)
{return default.HUDColors[ThemeIndex].FrobBoxShadow;}

static function color GetFrobBoxText(int ThemeIndex)
{return default.HUDColors[ThemeIndex].FrobBoxText;}



defaultproperties
{
    Begin Object Class=DXRColors.DXR_HUDColor Name=col00
     MessageBG=(R=139,G=105,B=35,A=255)   // ClientMessage Background
     MessageText=(R=255,G=255,B=255,A=255) // ClientMessage Text
     MessageFrame=(R=185,G=177,B=140,A=255) // ClientMessage frame

     ToolBeltBG=(R=139,G=105,B=35,A=255)
     ToolBeltText=(R=255,G=255,B=255,A=255)
     ToolBeltFrame=(R=185,G=177,B=140,A=255)
     ToolBeltHighlight=(R=0,G=255,B=100,A=255)

     AugsBeltBG=(R=139,G=105,B=35,A=255)
     AugsBeltText=(R=255,G=255,B=255,A=255)
     AugsBeltFrame=(R=185,G=177,B=140,A=255)
     AugsBeltActive=(R=0,G=233,B=177,A=255)
     AugsBeltInActive=(R=100,G=100,B=100,A=255)

     AmmoDisplayBG=(R=139,G=105,B=35,A=255)
     AmmoDisplayFrame=(R=185,G=177,B=140,A=255)

     compassBG=(R=139,G=105,B=35,A=255)
     compassFrame=(R=185,G=177,B=140,A=255)

     HealthBG=(R=139,G=105,B=35,A=255)
     HealthFrame=(R=185,G=177,B=140,A=255)

     BooksBG=(R=139,G=105,B=35,A=255)
     BooksText=(R=255,G=255,B=255,A=255)
     BooksFrame=(R=185,G=177,B=140,A=255)

     InfoLinkBG=(R=139,G=105,B=35,A=255)
     InfoLinkText=(R=255,G=255,B=255,A=255)
     InfoLinkTitles=(R=255,G=233,B=177,A=255)
     InfoLinkFrame=(R=185,G=177,B=140,A=255)

     AIBarksBG=(R=139,G=105,B=35,A=255)
     AIBarksText=(R=255,G=255,B=255,A=255)
     AIBarksHeader=(R=255,G=233,B=177,A=255)
     AIBarksFrame=(R=185,G=177,B=140,A=255)

     FrobBoxColor=(R=139,G=105,B=35,A=255)
     FrobBoxShadow=(R=185,G=177,B=140,A=255)
     FrobBoxText=(R=255,G=255,B=255,A=255)

     HUDName="Amber"
    End Object
    HUDColors(0)=col00

    Begin Object Class=DXRColors.DXR_HUDColor Name=col01
     MessageBG=(R=128,G=0,B=0,A=255)   // ClientMessage Background
     MessageText=(R=255,G=255,B=255,A=255) // ClientMessage Text
     MessageFrame=(R=255,G=25,B=25,A=255) // ClientMessage frame

     ToolBeltBG=(R=128,G=0,B=0,A=255)
     ToolBeltText=(R=200,G=0,B=0,A=255)
     ToolBeltFrame=(R=255,G=25,B=25,A=255)
     ToolBeltHighlight=(R=255,G=0,B=0,A=255)

     AugsBeltBG=(R=128,G=0,B=0,A=255)
     AugsBeltText=(R=200,G=0,B=0,A=255)
     AugsBeltFrame=(R=255,G=25,B=25,A=255)
     AugsBeltActive=(R=0,G=233,B=177,A=255)
     AugsBeltInActive=(R=100,G=100,B=100,A=255)

     AmmoDisplayBG=(R=128,G=0,B=0,A=255)
     AmmoDisplayFrame=(R=255,G=25,B=25,A=255)

     compassBG=(R=128,G=0,B=0,A=255)
     compassFrame=(R=255,G=25,B=25,A=255)

     HealthBG=(R=128,G=0,B=0,A=255)
     HealthFrame=(R=255,G=25,B=25,A=255)

     BooksBG=(R=128,G=0,B=0,A=255)
     BooksText=(R=200,G=0,B=0,A=255)
     BooksFrame=(R=255,G=25,B=25,A=255)

     InfoLinkBG=(R=128,G=0,B=0,A=255)
     InfoLinkText=(R=200,G=255,B=0,A=255)
     InfoLinkTitles=(R=255,G=0,B=0,A=255)
     InfoLinkFrame=(R=255,G=25,B=25,A=255)

     AIBarksBG=(R=128,G=0,B=0,A=255)
     AIBarksText=(R=200,G=0,B=0,A=255)
     AIBarksHeader=(R=255,G=0,B=0,A=255)
     AIBarksFrame=(R=255,G=25,B=25,A=255)

     FrobBoxColor=(R=255,G=0,B=0,A=255)
     FrobBoxShadow=(R=128,G=0,B=0,A=255)
     FrobBoxText=(R=200,G=0,B=0,A=255)

     HUDName="Terminator"
    End Object
    HUDColors(1)=col01

    // Darkest Time
    Begin Object Class=DXRColors.DXR_HUDColor Name=col02
     MessageBG=(R=82,G=82,B=80,A=255)   // ClientMessage Background
     MessageText=(R=130,G=139,B=138,A=255) // ClientMessage Text
     MessageFrame=(R=255,G=255,B=255,A=255) // ClientMessage frame

     ToolBeltBG=(R=82,G=82,B=80,A=255) // ToolBelt Background
     ToolBeltText=(R=130,G=139,B=138,A=255) // ToolBelt items text
     ToolBeltFrame=(R=55,G=55,B=55,A=255) // Frame
     ToolBeltHighlight=(R=200,G=200,B=200,A=255) // Selected item

     AugsBeltBG=(R=82,G=82,B=80,A=255)
     AugsBeltText=(R=130,G=139,B=138,A=255)
     AugsBeltFrame=(R=82,G=82,B=80,A=255)
     AugsBeltActive=(R=0,G=233,B=177,A=255) // Active aug color
     AugsBeltInActive=(R=100,G=100,B=100,A=255)

     AmmoDisplayBG=(R=82,G=82,B=80,A=255)
     AmmoDisplayFrame=(R=82,G=82,B=80,A=255)

     compassBG=(R=82,G=82,B=80,A=255)
     compassFrame=(R=82,G=82,B=80,A=255)

     HealthBG=(R=82,G=82,B=80,A=255)
     HealthFrame=(R=82,G=82,B=80,A=255)

     BooksBG=(R=82,G=82,B=80,A=255) // Text background for contents of datacubes, newspapers, etc.
     BooksText=(R=130,G=139,B=138,A=255) // Color of text contents
     BooksFrame=(R=82,G=82,B=80,A=255) // Frame around background

     InfoLinkBG=(R=82,G=82,B=80,A=255) // Self explaining?
     InfoLinkText=(R=130,G=139,B=138,A=255)
     InfoLinkTitles=(R=170,G=179,B=178,A=255)
     InfoLinkFrame=(R=82,G=82,B=80,A=255)

     AIBarksBG=(R=82,G=82,B=80,A=255)
     AIBarksText=(R=130,G=139,B=138,A=255)
     AIBarksHeader=(R=170,G=179,B=178,A=255)
     AIBarksFrame=(R=82,G=82,B=80,A=255)

     FrobBoxColor=(R=170,G=179,B=178,A=255)
     FrobBoxShadow=(R=82,G=82,B=80,A=255)
     FrobBoxText=(R=130,G=139,B=138,A=255)

     HUDName="Darkest Time"
    End Object
    HUDColors(2)=col02
//----------------------------
    // Default
    Begin Object Class=DXRColors.DXR_HUDColor Name=col03
//     MessageBG=(R=255,G=255,B=255,A=255)   // ClientMessage Background
     MessageBG=(R=128,G=128,B=128,A=255)   // ClientMessage Background
     MessageText=(R=255,G=255,B=255,A=255) // ClientMessage Text
     MessageFrame=(R=255,G=255,B=255,A=255) // ClientMessage frame

     ToolBeltBG=(R=255,G=255,B=255,A=255) // ToolBelt Background
     ToolBeltText=(R=255,G=255,B=255,A=255) // ToolBelt items text
     ToolBeltFrame=(R=255,G=255,B=255,A=255) // Frame
     ToolBeltHighlight=(R=255,G=255,B=255,A=255) // Selected item

     AugsBeltBG=(R=255,G=255,B=255,A=255)
     AugsBeltText=(R=255,G=255,B=255,A=255)
     AugsBeltFrame=(R=255,G=255,B=255,A=255)
     AugsBeltActive=(R=0,G=233,B=177,A=255) // Active aug color
     AugsBeltInActive=(R=100,G=100,B=100,A=255)

     AmmoDisplayBG=(R=255,G=255,B=255,A=255)
     AmmoDisplayFrame=(R=255,G=255,B=255,A=255)

     compassBG=(R=255,G=255,B=255,A=255)
     compassFrame=(R=255,G=255,B=255,A=255)

     HealthBG=(R=255,G=255,B=255,A=255)
     HealthFrame=(R=255,G=255,B=255,A=255)

     BooksBG=(R=255,G=255,B=255,A=255) // Text background for contents of datacubes, newspapers, etc.
     BooksText=(R=255,G=255,B=255,A=255) // Color of text contents
     BooksFrame=(R=255,G=255,B=255,A=255) // Frame around background

     InfoLinkBG=(R=255,G=255,B=255,A=255) // Self explaining?
     InfoLinkText=(R=255,G=255,B=255,A=255)
     InfoLinkTitles=(R=255,G=255,B=255,A=255)
     InfoLinkFrame=(R=255,G=255,B=255,A=255)

     AIBarksBG=(R=255,G=255,B=255,A=255)
     AIBarksText=(R=255,G=255,B=255,A=255)
     AIBarksHeader=(R=255,G=255,B=255,A=255)
     AIBarksFrame=(R=82,G=82,B=80,A=255)

     FrobBoxColor=(R=255,G=255,B=255,A=255)
     FrobBoxShadow=(R=82,G=82,B=80,A=255)
     FrobBoxText=(R=255,G=255,B=255,A=255)

     HUDName="Default"
    End Object
    HUDColors(3)=col03

//----------------------------
    // Blue
    Begin Object Class=DXRColors.DXR_HUDColor Name=col04
     MessageBG=(R=255,G=255,B=255,A=255)   // ClientMessage Background
     MessageText=(R=255,G=255,B=255,A=255) // ClientMessage Text
     MessageFrame=(R=255,G=255,B=255,A=255) // ClientMessage frame

     ToolBeltBG=(R=255,G=255,B=255,A=255) // ToolBelt Background
     ToolBeltText=(R=255,G=255,B=255,A=255) // ToolBelt items text
     ToolBeltFrame=(R=255,G=255,B=255,A=255) // Frame
     ToolBeltHighlight=(R=255,G=255,B=255,A=255) // Selected item

     AugsBeltBG=(R=255,G=255,B=255,A=255)
     AugsBeltText=(R=255,G=255,B=255,A=255)
     AugsBeltFrame=(R=255,G=255,B=255,A=255)
     AugsBeltActive=(R=0,G=233,B=177,A=255) // Active aug color
     AugsBeltInactive=(R=100,G=100,B=100,A=255)

     AmmoDisplayBG=(R=255,G=255,B=255,A=255)
     AmmoDisplayFrame=(R=255,G=255,B=255,A=255)

     compassBG=(R=255,G=255,B=255,A=255)
     compassFrame=(R=255,G=255,B=255,A=255)

     HealthBG=(R=255,G=255,B=255,A=255)
     HealthFrame=(R=255,G=255,B=255,A=255)

     BooksBG=(R=255,G=255,B=255,A=255) // Text background for contents of datacubes, newspapers, etc.
     BooksText=(R=255,G=255,B=255,A=255) // Color of text contents
     BooksFrame=(R=255,G=255,B=255,A=255) // Frame around background

     InfoLinkBG=(R=255,G=255,B=255,A=255) // Self explaining?
     InfoLinkText=(R=255,G=255,B=255,A=255)
     InfoLinkTitles=(R=255,G=255,B=255,A=255)
     InfoLinkFrame=(R=255,G=255,B=255,A=255)

     AIBarksBG=(R=255,G=255,B=255,A=255)
     AIBarksText=(R=255,G=255,B=255,A=255)
     AIBarksHeader=(R=255,G=255,B=255,A=255)
     AIBarksFrame=(R=82,G=82,B=80,A=255)

     FrobBoxColor=(R=255,G=255,B=255,A=255)
     FrobBoxShadow=(R=82,G=82,B=80,A=255)
     FrobBoxText=(R=255,G=255,B=255,A=255)

     HUDName="Blue"
    End Object
    HUDColors(4)=col04

    // Green
    Begin Object Class=DXRColors.DXR_HUDColor Name=col05
     MessageBG=(R=128,G=255,B=128,A=255)   // ClientMessage Background
     MessageText=(R=255,G=255,B=255,A=255) // ClientMessage Text
     MessageFrame=(R=0,G=255,B=128,A=255) // ClientMessage frame

     ToolBeltBG=(R=0,G=128,B=0,A=255) // ToolBelt Background
     ToolBeltText=(R=0,G=255,B=128,A=255) // ToolBelt items text
     ToolBeltFrame=(R=128,G=255,B=255,A=255) // Frame
     ToolBeltHighlight=(R=128,G=255,B=128,A=255) // Selected item

     AugsBeltBG=(R=255,G=255,B=255,A=255)
     AugsBeltText=(R=255,G=255,B=255,A=255)
     AugsBeltFrame=(R=255,G=255,B=255,A=255)
     AugsBeltActive=(R=0,G=233,B=177,A=255) // Active aug color
     AugsBeltInactive=(R=100,G=100,B=100,A=255)

     AmmoDisplayBG=(R=255,G=255,B=255,A=255)
     AmmoDisplayFrame=(R=255,G=255,B=255,A=255)

     compassBG=(R=255,G=255,B=255,A=255)
     compassFrame=(R=255,G=255,B=255,A=255)

     HealthBG=(R=255,G=255,B=255,A=255)
     HealthFrame=(R=255,G=255,B=255,A=255)

     BooksBG=(R=255,G=255,B=255,A=255) // Text background for contents of datacubes, newspapers, etc.
     BooksText=(R=255,G=255,B=255,A=255) // Color of text contents
     BooksFrame=(R=255,G=255,B=255,A=255) // Frame around background

     InfoLinkBG=(R=255,G=255,B=255,A=255) // Self explaining?
     InfoLinkText=(R=255,G=255,B=255,A=255)
     InfoLinkTitles=(R=255,G=255,B=255,A=255)
     InfoLinkFrame=(R=255,G=255,B=255,A=255)

     AIBarksBG=(R=255,G=255,B=255,A=255)
     AIBarksText=(R=255,G=255,B=255,A=255)
     AIBarksHeader=(R=255,G=255,B=255,A=255)
     AIBarksFrame=(R=82,G=82,B=80,A=255)

     FrobBoxColor=(R=255,G=255,B=255,A=255)
     FrobBoxShadow=(R=82,G=82,B=80,A=255)
     FrobBoxText=(R=255,G=255,B=255,A=255)

     HUDName="Green"
    End Object
    HUDColors(5)=col05
}

