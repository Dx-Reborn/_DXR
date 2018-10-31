//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_Projectors extends MenuChoice_OnOff;

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
    Hint="Materials, projected to the surface, like decals, shadows, etc."
    actionText="Projectors"
    configSetting="ini:Engine.Engine.ViewportManager Projectors"
}
