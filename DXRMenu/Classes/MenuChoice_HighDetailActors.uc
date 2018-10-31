//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_HighDetailActors extends MenuChoice_OnOff;

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
    Hint="Enables objects (usually decorations) with 'bHighDetail' flag."
    actionText="Allow Detailed objects"
    configSetting="ini:Engine.Engine.RenderDevice HighDetailActors"
}
