//=============================================================================
// MenuChoice_ThemeColor
//=============================================================================

class MenuChoice_ThemeColor extends DXREnumButton;

var int currentTheme;
var String defaultTheme; // Change to Integer??

// ----------------------------------------------------------------------
// PopulateThemes()
// DXR: All themes are stored as defprops in DXR_Menu.uc and DXR_HUD.uc
// in DXRColors package. 
// ----------------------------------------------------------------------

function PopulateThemes(int themeType)
{
	local int i, k;
	local array<string> Themes;
	local array<string> MenuThemes;

	if (ThemeType == 1) // 1=HUD
	{
	  Themes = class'DXR_HUD'.static.GetAllHUDThemes();

	  for (i=0;i<Themes.length;i++)
	  {
	    enumText[i] = class'DXR_HUD'.static.GetHUDThemeName(i);
	  }
	}//--------------------------------------------------------
  else if (ThemeType == 0) // 0=Menu
	{
	  MenuThemes = class'DXR_Menu'.static.GetAllThemes();

	  for (k=0;k<MenuThemes.length;k++)
	  {
	    enumText[k] = class'DXR_Menu'.static.GetThemeName(k);
	  }
	}
}

// ----------------------------------------------------------------------
// SetValueFromString()
// ----------------------------------------------------------------------

function SetValueFromString(String stringValue)
{
	local int enumIndex;

	for(enumIndex=0; enumIndex<arrayCount(enumText); enumIndex++)
	{
		if (enumText[enumIndex] == stringValue)
		{
			SetValue(enumIndex);
			break;
		}
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
}
