//=============================================================================
// MenuChoice_MenuColor
//=============================================================================

class MenuChoice_MenuColor extends MenuChoice_ThemeColor;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	// Populate the enums!
	PopulateThemes(0);

  currentTheme = gl.MenuThemeIndex;
	SetValueFromString(class'DXR_Menu'.static.GetThemeName(currentTheme));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	gl.MenuTheme = enumText[GetValue()];
	gl.MenuThemeIndex = GetValue();
  class'DeusExGlobals'.static.StaticSaveConfig();
}
/*
// ----------------------------------------------------------------------
// CancelSetting()
// ----------------------------------------------------------------------

function CancelSetting()
{
	player.ThemeManager.SetCurrentMenuColorTheme(currentTheme);
	ChangeStyle();
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
	local ColorTheme theme;

	player.MenuThemeName = defaultTheme;
	theme = player.ThemeManager.SetMenuThemeByName(defaultTheme);
	theme.ResetThemeToDefault();

	SetValueFromString(player.MenuThemeName);

	ChangeStyle();
}
*/
// ----------------------------------------------------------------------
// CycleNextValue()
// ----------------------------------------------------------------------

function CycleNextValue()
{
	Super.CycleNextValue();
	ChangeStyle();
}

// ----------------------------------------------------------------------
// CyclePreviousValue()
// ----------------------------------------------------------------------

function CyclePreviousValue()
{
	Super.CyclePreviousValue();
	ChangeStyle();
}

// ----------------------------------------------------------------------
// Change style of all opened menus, but don't save to .ini for now.
function ChangeStyle()
{
  local DxWindowTemplate dx;

	gl.MenuTheme = enumText[GetValue()];
	gl.MenuThemeIndex = GetValue();

     foreach AllObjects(class'DxWindowTemplate',dx)
     if (dx != none)
         dx.ApplyTheme();
}

// ----------------------------------------------------------------------

defaultproperties
{
    defaultTheme="Grey"
    Hint="Color scheme used in all menus."
    actionText="Menu Color Scheme"
}
