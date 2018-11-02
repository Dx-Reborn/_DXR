//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_UseVSync extends MenuChoice_OnOff;

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
    Hint="Enables Use of Vertical Synchronization"
    actionText="Use Vertical Synchronization"
    configSetting="ini:Engine.Engine.RenderDevice UseVSync"
}
