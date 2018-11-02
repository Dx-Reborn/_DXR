//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_UseTrilinear extends MenuChoice_OnOff;

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
    Hint="Enables Trilinear filter for slightly better texture quality. Disabling can slightly increase performance."
    actionText="Trilinear Filter"
    configSetting="ini:Engine.Engine.RenderDevice UseTrilinear"
}
