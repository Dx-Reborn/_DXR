//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_DecoLayers extends MenuChoice_OnOff;

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
    defaultValue=1
    Hint="Whed this option is off, decorative terrain layers (like grass) will be removed."
    actionText="Decorative terrain layers"
    configSetting="ini:Engine.Engine.ViewportManager DecoLayers"
}
