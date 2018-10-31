//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_WeatherEffects extends MenuChoice_OnOff;

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
    Hint="Enables weather effects if any."
    actionText="Weather Effects"
    configSetting="ini:Engine.Engine.ViewportManager WeatherEffects"
}
