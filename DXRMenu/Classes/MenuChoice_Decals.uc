//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_Decals extends MenuChoice_OnOff;

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
    Hint="Decals are things like explosion marks, bullet holes, blood trails, etc."
    actionText="Enable decals"
    configSetting="ini:Engine.Engine.ViewportManager Decals"
}
