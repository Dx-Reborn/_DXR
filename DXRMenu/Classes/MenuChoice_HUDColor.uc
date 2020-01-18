//=============================================================================
// MenuChoice_HUDColor
//=============================================================================

class MenuChoice_HUDColor extends MenuChoice_ThemeColor;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
    // Populate the enums!
    PopulateThemes(1);
    currentTheme = gl.HUDThemeIndex;
    SetValueFromString(class'DXR_HUD'.static.GetHUDThemeName(currentTheme));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
  ChangeStyle();
  class'DeusExGlobals'.static.StaticSaveConfig();
  DeusExHUD(PlayerOwner().myHUD).LoadColorTheme();// Reload color theme
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

    player.HUDThemeName = defaultTheme;
    theme = player.ThemeManager.SetHUDThemeByName(defaultTheme);
    theme.ResetThemeToDefault();

    SetValueFromString(player.HUDThemeName);

    ChangeStyle();
}

// ----------------------------------------------------------------------
// CycleNextValue()
// ----------------------------------------------------------------------
*/
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

function ChangeStyle()
{
    gl.HUDTheme = enumText[GetValue()];
    gl.HUDThemeIndex = GetValue();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
    defaultTheme="Grey"
    Hint="Color scheme used in all the in-game screens."
    actionText="HUD Color Scheme"
}
