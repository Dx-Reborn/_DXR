//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_Coronas extends MenuChoice_OnOff;

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
    Hint="Enables halo effect around some sources of light."
    actionText="Coronas"
    configSetting="ini:Engine.Engine.ViewportManager Coronas"
}
