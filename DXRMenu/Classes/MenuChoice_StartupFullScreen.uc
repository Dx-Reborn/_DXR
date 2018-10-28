//=============================================================================
// MenuChoice_StartupFullScreen
//=============================================================================

class MenuChoice_StartupFullScreen extends MenuChoice_OnOff;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	LoadSettingBool();
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	SaveSettingBool();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=0
    Hint="Default mode when game is started. Windowed mode useful for use with UDebugger. ÿTip: You can switch between fullScreen and windowed mode at any time by pressing Alt+ENTER keys."
    actionText="Full screen at StartUp"
    configSetting="ini:Engine.Engine.ViewportManager StartupFullScreen"
}